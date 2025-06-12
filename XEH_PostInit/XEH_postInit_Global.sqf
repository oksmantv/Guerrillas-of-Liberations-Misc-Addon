diag_log "OKS_GOL_Misc: XEH_postInit_Global.sqf executed";

GOL_Core_Enabled = missionNamespace getVariable ["GOL_CORE_Enabled",false];
if(GOL_Core_Enabled isEqualTo true) then {
/*
    Global Executions.
*/
if(true) then {

    /* Define Player Side for Scripts */
    missionNameSpace setVariable ["GOL_Friendly_Side",(side group player),true];

    /* Setup Flag Teleport */
    [] spawn OKS_fnc_FlagTeleport;

    /* Setup player vehicles & boxes */
    [] spawn {
        sleep 1;
        {
            private _Vehicle = _x;
            private _varName = toLower vehicleVarName _Vehicle;
            [_Vehicle, _varName] spawn {
                params ["_Vehicle", "_varName"];
                waitUntil {
                    sleep 1;
                    !isNil "OKS_fnc_Mechanized" &&
                    !isNil "GW_MHQ_Fnc_Handler" &&
                    !isNil "GW_Gear_Fnc_Init"
                };

                if(isServer) then {
                    if (["vehicle_", _varName] call BIS_fnc_inString) exitWith {
                        [_Vehicle] spawn OKS_fnc_Mechanized;
                    };
                    if (["mhq_", _varName] call BIS_fnc_inString) exitWith {
                        [_Vehicle, "medium"] call GW_MHQ_Fnc_Handler;
                        _MHQShouldBeMobileServiceStation = missionNamespace getVariable ["MHQ_ShouldBe_ServiceStation",false];
                        if(_MHQShouldBeMobileServiceStation isEqualTo true) then {
                            [_Vehicle] spawn OKS_fnc_SetupMobileServiceStation;
                            _Debug = missionNamespace getVariable ["MHQ_Debug",false];
                            if(_Debug) then {
                                format["SetupMSS-Init was run on %1",_Vehicle] spawn OKS_fnc_LogDebug;
                            };
                        };
                        [_Vehicle] spawn OKS_fnc_Mechanized;
                    };
                    if (["helicopter_", _varName] call BIS_fnc_inString) exitWith {
                        [_Vehicle] spawn OKS_fnc_Helicopter;
                    };
                };
            };
        } forEach Vehicles;
    };

    /* RemoveVehicleHE from Current and spawned Vehicles. */
    {
        _vehicle = _X;
        if(
            !(["vehicle",vehicleVarName _Vehicle, false] call BIS_fnc_inString) &&
            !(["mhq",vehicleVarName _Vehicle, false] call BIS_fnc_inString)
        ) then {
            private _RemoveVehicleHE_Enabled = missionNamespace getVariable ["GOL_RemoveVehicleHE_Enabled",true];
            if (_RemoveVehicleHE_Enabled) then {
                [_vehicle] spawn OKS_fnc_RemoveVehicleHE;
            };
            [_vehicle] spawn OKS_fnc_ForceVehicleSpeed;   
            [_vehicle] spawn OKS_fnc_AbandonVehicle;      
            [_vehicle] call OKS_fnc_VehicleAppearance;

            private _type = typeOf _vehicle;
            if (["T34","T55","T72","T80"] findIf {_type find _x >= 0} != -1 
                && (typeOf _x find "UK3CB" >= 0)) then {
                [_vehicle] spawn OKS_fnc_AdjustDamage;
            };
        }
    } forEach (vehicles select {_x isKindOf "LandVehicle"});
    
    ["LandVehicle", "init", {
        params ["_vehicle"];
        if( 
            !(["vehicle",vehicleVarName _Vehicle, false] call BIS_fnc_inString) &&
            !(["mhq",vehicleVarName _Vehicle, false] call BIS_fnc_inString)
        ) then {           
            private _RemoveVehicleHE_Enabled = missionNamespace getVariable ["GOL_RemoveVehicleHE_Enabled",true];
            if (_RemoveVehicleHE_Enabled) then {
                [_vehicle] spawn OKS_fnc_RemoveVehicleHE;
            };
            [_vehicle] spawn OKS_fnc_ForceVehicleSpeed;
            [_vehicle] spawn OKS_fnc_AbandonVehicle;
            [_vehicle] call OKS_fnc_VehicleAppearance;
            
            private _type = typeOf _vehicle;
            if ((["T34","T55","T72","T80"] findIf {_type find _x >= 0}) != -1 
                && (_type find "UK3CB" >= 0)) then {
                [_vehicle] spawn OKS_fnc_AdjustDamage;
            };
        };
    }, true, [], true] call CBA_fnc_addClassEventHandler;

    /*
        Add code to spawned units.
    */
    ["CAManBase", "init", {
        params ["_unit"];
        if (!isPlayer _unit) then {
            // Add Killed EventHandler for Scores.
            private _playerSide = missionNameSpace getVariable ["GOL_Friendly_Side",(side group player)];     
            if (_unit isKindOf "CAManBase" && side _unit getFriend _playerSide < 0.6 && side group _unit != civilian) then 
            {
                [_unit] call OKS_fnc_AddKilledScore;    
            };

            if (_unit isKindOf "CAManBase" && side group _unit == civilian) then 
            {
                [_unit] call OKS_fnc_AddCivilianKilled;    
            };        

            private _SuppressionEnabled = missionNamespace getVariable ["GOL_Suppression_Enabled", true];
            if(_SuppressionEnabled && side group _unit != civilian && vehicle _unit == _unit) then {
                _unit spawn {
                    params ["_unit"];
                    sleep 1;
                    [_unit] spawn OKS_fnc_Suppressed;
                };
            };

            private _SurrenderEnabled = missionNamespace getVariable ["GOL_Surrender_Enabled", true];
            if(_SurrenderEnabled && side group _unit != civilian && vehicle _unit == _unit) then {
                _unit spawn {
                    params ["_unit"];
                    sleep 1;
                    [_unit] spawn OKS_fnc_Surrender;
                };
            };

            private _FaceSwapEnabled = missionNamespace getVariable ["GOL_FaceSwap_Enabled", true];
            if(_FaceSwapEnabled) then {
                // Apply ethnicity and face swap
                _unit spawn {
                    params ["_unit"];
                    sleep 1;
                    [_unit] spawn OKS_fnc_FaceSwap;
                };
            };

            if(side group _unit != civilian || vehicle _unit == _unit) then {
                _unit spawn {
                    params ["_unit"];
                    private ["_group"];
                    sleep 5;
                    _group = group _unit;
    
                    if(!isNil "OKS_fnc_EnablePath" && !(_unit checkAIFeature "PATH")) then {                          
                        [_group] spawn OKS_fnc_EnablePath;
                    };
                };
            };
        };
    }] call CBA_fnc_addClassEventHandler;

    // Get all player units (for side comparison)
    private _players = allPlayers select {alive _x};
    if (_players isEqualTo []) exitWith {
        private _SurrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", true];  
        if(_SurrenderDebug) then {
            "No players found for enemy check!" spawn OKS_fnc_LogDebug;
        };
    };

    // Assume first player as reference for "enemy" side
    private _playerSide = missionNameSpace getVariable ["GOL_Friendly_Side",(side group player)];   
    {
        // Add Killed EventHandler for Scores.    
        if (_x isKindOf "CAManBase" &&
            !isPlayer _x &&
            side _x getFriend _playerSide < 0.6 &&
            side group _x != civilian) then 
        {
            [_X] call OKS_fnc_AddKilledScore;    
        };

        if (_X isKindOf "CAManBase" && side group _X == civilian) then 
        {
            [_X] call OKS_fnc_AddCivilianKilled;    
        };        

        if (
            _x isKindOf "CAManBase" &&
            !isPlayer _x &&
            side _x getFriend _playerSide < 0.6 &&
            side group _x != civilian &&
            vehicle _X == _X
        ) then {
            private _SurrenderEnabled = missionNamespace getVariable ["GOL_Surrender_Enabled", true];
            if(_SurrenderEnabled) then {                                
                [_x] spawn OKS_fnc_Surrender
            };
        };

        if(_X isKindOf "CAManBase" && !isPlayer _X) then {
            private _SuppressionEnabled = missionNamespace getVariable ["GOL_Suppression_Enabled", true];
            if(_SuppressionEnabled && vehicle _X == _X) then {
                [_x] spawn OKS_fnc_Suppressed
            };

            private _FaceSwapEnabled = missionNamespace getVariable ["GOL_FaceSwap_Enabled", true];
            if(_FaceSwapEnabled) then {
                [_x] spawn OKS_fnc_FaceSwap;                   
            };

            _x spawn {
                params ["_X"];
                private ["_group"];
                sleep 5;
                _group = group _X;
                if(_group getVariable ["OKS_EnablePath_Active",false] || vehicle _X != _X) exitWith {
                    // Exit if already enabled on Group level or if inside vehicle.
                };

                if(!isNil "OKS_fnc_EnablePath" && !(_X checkAIFeature "PATH")) then {        
                    _group setVariable ["OKS_EnablePath_Active",true,true];
                    [_group] spawn OKS_fnc_EnablePath;
                };
            };  
        };
    } forEach allUnits;
    };       

    /* Setup Vehicle & MHQ Drops */
    [] spawn OKS_fnc_VehicleDropSetup;

    /* Setup ACE Carrying Limits */
    ACE_maxWeightCarry = 1600; 
    ACE_maxWeightDrag = 2500;

    if (hasInterface) then {
        /* Setup TFAR Radios */
        [] spawn OKS_fnc_TFAR_RadioSetup;

        /* Warning System for Speaker */
        [] spawn OKS_fnc_WarningSpeakerHandler;

        /* Inventory Warning System */
        [] spawn OKS_fnc_InventoryHandler;

        /* Add Unconscious Camera Handler */
        [] spawn OKS_fnc_SetupUnconsciousCamera;
        
        /* Add Medical Messages to Players. */
        ["ace_treatmentStarted", OKS_fnc_medicalMessage] call CBA_fnc_addEventHandler;

        /* Setup ORBAT */
        [] spawn OKS_fnc_ORBATHandler;

        /* Setup Support & Mobile HQ MHQ */
        _condition = {leader group player == player};
        _action = ["Request_Support", "Request Support","\A3\ui_f\data\map\VehicleIcons\iconCrateVeh_ca.paa", {}, _condition] call ace_interact_menu_fnc_createAction;
        [typeOf player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToClass;

        /* Setup ORBAT Actions for Pilots */
        [] spawn OKS_fnc_Orbat_Action;

        if(!isNil "Mobile_HQ") then {
            [] spawn OKS_fnc_ACE_MoveMHQ;
        };           

        /* Setup AI Supply Drops */
        _SupplyEnabled = missionNamespace getVariable ["NEKY_Supply_Enabled", true];
        _VehicleDropEnabled = missionNamespace getVariable ["NEKY_SupplyVehicle_Enabled", true];
        _MHQDropEnabled = missionNamespace getVariable ["NEKY_SupplyMHQ_Enabled", true];
        if(_SupplyEnabled isEqualTo true) then {
            [] spawn OKS_fnc_Ace_Resupply;
        };
        if(!isNil "Vehicle_1" && _VehicleDropEnabled isEqualTo true) then {
            [] spawn OKS_fnc_Ace_VehicleDrop;
        };
        if(!isNil "MHQ_1" && _MHQDropEnabled isEqualTo true) then {
            [] spawn OKS_fnc_Ace_MHQDrop;
        };	

        /* Reset Radio Transmit upon death handler */
        player addEventHandler ["Killed", {
            // Get the player's current SR radio info
            private _radio = player call TFAR_fnc_activeSwRadio;
            private _channel = player getVariable ["TFAR_currentSwChannel", 1];
            private _frequency = player getVariable ["TFAR_currentSwFrequency", ""];
            private _isAdditional = false;

            if (!isNil "_radio" && {!isNull _radio}) then {
                [_radio, _channel, _frequency, _isAdditional] call TFAR_fnc_doSRTransmitEnd;
            };

            // Optionally, also handle LR radios:
            private _lrRadio = player call TFAR_fnc_activeLrRadio;
            private _lrChannel = player getVariable ["TFAR_currentLrChannel", 1];
            private _lrFrequency = player getVariable ["TFAR_currentLrFrequency", ""];
            if (!isNil "_lrRadio" && {!isNull _lrRadio}) then {
                [_lrRadio, _lrChannel, _lrFrequency, false] call TFAR_fnc_doLRTransmitEnd;
            };
        }];
    };
};