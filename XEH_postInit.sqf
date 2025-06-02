
diag_log "OKS_GOL_Misc: XEH_postInit.sqf executed";

GOL_Core_Enabled = missionNamespace getVariable ["GOL_CORE_Enabled",false];
if(GOL_Core_Enabled isEqualTo true) then {

    /*
        Global Executions.
    */
    if(true) then {
        /* Define Player Side for Scripts */
        missionNameSpace setVariable ["GOL_Friendly_Side",(side group player),true];

        /* Setup Support & Tent MHQ */
        _condition = {leader group player == player};
        _action = ["Request_Support", "Request Support","\A3\ui_f\data\map\VehicleIcons\iconCrateVeh_ca.paa", {}, _condition] call ace_interact_menu_fnc_createAction;
        [typeOf player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToClass;
        [] spawn OKS_fnc_Orbat_Action;

        if(!isNil "Tent_MHQ") then {
            [] spawn OKS_fnc_ACE_MoveMHQ;
        };

        /*
            Setup ORBAT
        */
        private _interval = 10;        // Check every 10 seconds
        private _timeout = time + 60;  // Stop after 60 seconds
        private _handler = [
            {
                // Condition: Either both variables are defined, or timeout reached
                (!isNil "ORBAT_GROUP" && !isNil "GOL_SelectedComposition") || {time > _timeout}
            },
            {
                // Execution: Check which case triggered
                if (!isNil "ORBAT_GROUP" && !isNil "GOL_SelectedComposition") then {
                    private _composition = missionNamespace getVariable "GOL_SelectedComposition";
                    [_composition] spawn OKS_fnc_Orbat_Setup;
                } else {
                    if (isServer) then {
                        if (isNil "ORBAT_GROUP") then {
                            "The ORBAT Group module is missing." spawn OKS_fnc_LogDebug;
                        };
                        if (isNil "GOL_SelectedComposition") then {
                            "GOL_SelectedComposition variable is undefined. If you want to use the ORBAT, make sure to assign it in missionSettings.sqf." spawn OKS_fnc_LogDebug;
                        };
                    };
                };
            },
            [],
            _interval
        ] call CBA_fnc_waitUntilAndExecute;

        /*
            Setup TFAR Radios
        */
        [] spawn OKS_fnc_TFAR_RadioSetup;

        /*
            Setup Vehicle & MHQ Drops
        */
        if(!isNil "Vehicle_1") then {
            GOL_NEKY_VEHICLEDROP_VEHICLECLASS = (typeOf Vehicle_1); // Classname
            GOL_NEKY_VEHICLEDROP_APPEARANCE = compile ([Vehicle_1,""] call BIS_fnc_exportVehicle);
            GOL_NEKY_VEHICLEDROP_CODE = {

                Params ["_Vehicle"];
                _Vehicle call GOL_NEKY_VEHICLEDROP_APPEARANCE;

                sleep 5;
                [_Vehicle] spawn OKS_fnc_Mechanized;	
            };
        };

        if(!isNil "MHQ_1") then {
            GOL_NEKY_MHQDROP_VEHICLECLASS = (typeOf MHQ_1); // Classname
            GOL_NEKY_MHQDROP_APPEARANCE = compile ([MHQ_1,""] call BIS_fnc_exportVehicle);
            GOL_NEKY_MHQDROP_CODE = {

                Params ["_Vehicle"];
                _Vehicle call GOL_NEKY_MHQDROP_APPEARANCE;

                [_Vehicle, "medium"] call GW_MHQ_Fnc_Handler;
                [_Vehicle,25,true] spawn OKS_fnc_MobileSS;

                sleep 5;	
                [_Vehicle] spawn OKS_fnc_Mechanized;	
            };
        };

        /*
            Warning System for Speaker
        */
        if (hasInterface) then {
            [
                { !isNil "TFAR_CurrentUnit" },
                {
                    [
                        {
                            private _lrspeakers = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrSpeakers;
                            private _swspeakers = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwSpeakers;

                            if (!isNil "_lrspeakers" && { _lrspeakers }) then {
                                systemChat "WARNING! You have your long-range set to speaker not headphones. Change it!";
                            };
                            if (!isNil "_swspeakers" && { _swspeakers }) then {
                                systemChat "WARNING! You have your short-range set to speaker not headphones. Change it!";
                            };
                        },
                        10 // Check every 10 seconds
                    ] call CBA_fnc_addPerFrameHandler;
                }
            ] call CBA_fnc_waitUntilAndExecute;
        };

        /*
            Inventory Warning System
        */
        if (hasInterface) then {
            player addEventHandler ["InventoryOpened", {
                params ["_unit", "_container"];

                if(isNil "medical_box_west" || isNil "medical_box_east") exitWith {};
                if(isNil "flag_west_1" || isNil "flag_east_1") exitWith {};
                if(isNil "flag_west_2" || isNil "flag_east_2") exitWith {};

                // Medical crate check
                if (_container in [medical_box_west, medical_box_east]) then {
                    format["%1 accessed the medical crate at base.", name _unit] remoteExec ["systemChat", 0];
                };

                // Ammo crate at base check
                if (
                    typeOf _container in ["Box_Syndicate_Ammo_F", "Box_Syndicate_Wps_F", "B_supplyCrate_F"] &&
                    { _container distance _x < 150 } count [flag_west_1, flag_east_1, flag_west_2, flag_east_2] > 0
                ) then {
                    format["%1 accessed an ammo crate at base.", name _unit] remoteExec ["systemChat", 0];
                };

                // Equipment crate at base check
                if (
                    typeOf _container in ["Box_NATO_Equip_F"] &&
                    { _container distance _x < 150 } count [flag_west_1, flag_east_1, flag_west_2, flag_east_2] > 0
                ) then {
                    format["%1 accessed the equipment crate at base.", name _unit] remoteExec ["systemChat", 0];
                };
            }];

            /*
                Add Unconscious Camera
            */
            ["ace_unconscious", {
                params ["_unit","_unconscious"];
                if (_unit isNotEqualTo player) exitWith {};
                if(_unconscious) then {
                    private _camera = nil;
                    _playerbloodVolume = _unit getVariable ["ace_medical_bloodVolume", 6];
                    if(_playerbloodVolume <= 5.1) then {
                        [_unit] spawn {
                            params ["_unit"];
                            private _dir = 0;
                            private _height = 4;
                            private _distance = 3;

                            _camera = _unit getVariable ["GOL_SpectatorCamera",nil];
                            if(isNil "_camera") then {
                                _Position = (getPosATL _unit) getPos [_distance,_Dir];
                                _camera = "camera" camCreate [_Position select 0,_Position select 1,_height];     
                            };
                            _camera camSetTarget player;
                            _unit setVariable ["GOL_SpectatorCamera",_camera,true];	
                            cutText ["", "BLACK OUT",1]; sleep 1;
                            
                            waitUntil {!isNil "ace_medical_feedback_ppUnconsciousBlur"};
                            ppEffectDestroy ace_medical_feedback_ppUnconsciousBlur;            

                            waitUntil {!isNil "ace_medical_feedback_ppUnconsciousBlackout"};
                            ppEffectDestroy ace_medical_feedback_ppUnconsciousBlackout;      

                            showCinemaBorder true;
                            _camera cameraEffect ["internal", "back"];
                            sleep 2;
                            cutText ["", "BLACK IN",3];

                            while {!([_unit] call ace_common_fnc_isAwake)} do {
                                _playerbloodVolume = _unit getVariable ["ace_medical_bloodVolume", 6];
                                private _Tier = "<t color='#ffff66'>TIER 3</t>";
                                if(_playerbloodVolume < 5.1) then {
                                    _Tier = "<t color='#ff9933'>TIER 2</t>";
                                };
                                if (_playerbloodVolume < 3.6) then {
                                    _Tier = "<t color='#ff0000'>TIER 1</t>";
                                };

                                [format["YOU ARE A %1 CASUALTY.",_Tier], -1, 0, 5, 0, 0, 935] spawn BIS_fnc_dynamicText;
                                _Position = (getPosATL _unit) getPos [_distance,_Dir];
                                _Dir = _dir + 10;
                                _camera camSetPos [_Position select 0,_Position select 1,_height];
                                _camera camCommit 1;
                                sleep 1;
                            };			
                        };
                    };
                };
                if(!(_unconscious)) then {
                    _unit spawn {
                        _camera = _this getVariable ["GOL_SpectatorCamera",objNull];
                        _camera camSetPos [(getPosATL _this) select 0,(getPosATL _this) select 1,0.1];
                        _camera camSetTarget _this;
                        _camera camCommit 0.5;      
                        cutText ["", "BLACK OUT",0.5]; sleep 0.6;
                        _this setVariable ["GOL_SpectatorCamera",nil,true];
                        _camera cameraEffect ["terminate", "back"];			
                        camDestroy _camera;
                        ["", -1, 0, 1, 2, 0, 935] spawn BIS_fnc_dynamicText;
                        sleep 0.05;
                        cutText ["", "BLACK IN",1];   
                    }
                };
            }] call CBA_fnc_addEventHandler;

            /* Add Fallback Exit if killed during unconscious camera */
            player addEventHandler ["Killed", {
                private _camera = player getVariable ["GOL_SpectatorCamera", objNull];
                if (!isNull _camera) then {
                    _camera cameraEffect ["terminate", "back"];
                    camDestroy _camera;
                    player setVariable ["GOL_SpectatorCamera", nil, true];
                    ["", -1, 0, 1, 2, 0, 935] spawn BIS_fnc_dynamicText;
                };
            }];

            /*
                Add Medical Messages to Players.
            */
            ["ace_treatmentStarted", OKS_fnc_medicalMessage] call CBA_fnc_addEventHandler;
        };
    };

    /*
        Server Side Executions
    */
    if(isServer) then {
        /*
            Setup Framework Check
        */       
        _ReturnText = [] call OKS_fnc_CheckFrameworkObjects;
        if(_ReturnText != "") then {
            _ReturnText spawn OKS_fnc_LogDebug;
            copyToClipboard _ReturnText;
        } else {
            "Framework is not missing any items." spawn OKS_fnc_LogDebug;
        };

        /*
            Setup Death Board
        */
        private _timeout = time + 60; // 60 seconds timeout
        [
            {
                // Wait until all scoreboard variables are defined, or timeout
                (
                    !isNil "scoreboard_west_support" &&
                    !isNil "scoreboard_west" &&
                    !isNil "scoreboard_east" &&
                    !isNil "scoreboard_east_support"
                ) || {time > _timeout}
            },
            {
                if (
                    !isNil "scoreboard_west_support" &&
                    !isNil "scoreboard_west" &&
                    !isNil "scoreboard_east" &&
                    !isNil "scoreboard_east_support"
                ) then {
                    // All variables exist, start the handler
                    [
                        { [] spawn OKS_fnc_DeathScore; },
                        30
                    ] call CBA_fnc_addPerFrameHandler;
                } else {
                    // Timeout reached, show debug message
                    private _Debug = missionNamespace getVariable ["GOL_Core_Debug", false];
                    if(_Debug) then {
                        "DeathScore disabled - Can't find scoreboards" spawn OKS_fnc_LogDebug;
                    };
                };
            }
        ] call CBA_fnc_waitUntilAndExecute;
        

        /*
            Set Civilians to Friendly to all sides.
        */
        civilian setFriend [west,1];
        civilian setFriend [east,1];
        civilian setFriend [independent,1];

        /*
            NEKY Service Station Values.
        */
        if(isNil "NEKY_ServiceStationActive" && isNil "NEKY_ServiceStations") then {
            NEKY_ServiceStationActive = [];
            NEKY_ServiceStations = [];
            publicVariable "NEKY_ServiceStationActive";
            publicVariable "NEKY_ServiceStations";
        };

        /*
            RemoveVehicleHE from Current and spawned Vehicles.
        */
        private _RemoveVehicleHE_Enabled = missionNamespace getVariable ["GOL_RemoveVehicleHE_Enabled",true];
        if (_RemoveVehicleHE_Enabled) then {
            _HeadlessClients = entities "HeadlessClient_F";
            // Process existing vehicles immediately
            {
                _vehicle = _X;
                if (["T34","T55","T72","T80"] findIf {typeOf _vehicle find _x >= 0} != -1 
                    && (typeOf _x find "UK3CB" >= 0)) then {
                    [_vehicle] remoteExec ["OKS_fnc_AdjustDamage",0];
                    [_vehicle] remoteExec ["OKS_fnc_AdjustDamage",_HeadlessClients];
                };
                [_vehicle] remoteExec ["OKS_fnc_RemoveVehicleHE",0];
                [_vehicle] remoteExec ["OKS_fnc_RemoveVehicleHE",_HeadlessClients];  
                [_vehicle] remoteExec ["OKS_fnc_ForceVehicleSpeed",0];
                [_vehicle] remoteExec ["OKS_fnc_ForceVehicleSpeed",_HeadlessClients];                  
            } forEach (vehicles select {_x isKindOf "LandVehicle"});
            
            ["LandVehicle", "init", {
                params ["_vehicle"];
                _HeadlessClients = entities "HeadlessClient_F";
                [_vehicle] remoteExec ["OKS_fnc_RemoveVehicleHE",0];
                [_vehicle] remoteExec ["OKS_fnc_RemoveVehicleHE",_HeadlessClients];  
                [_vehicle] remoteExec ["OKS_fnc_ForceVehicleSpeed",0];
                [_vehicle] remoteExec ["OKS_fnc_ForceVehicleSpeed",_HeadlessClients]; 
                
                // Whitelist check moved outside select for better performance
                private _type = typeOf _vehicle;
                if ((["T34","T55","T72","T80"] findIf {_type find _x >= 0}) != -1 
                    && (_type find "UK3CB" >= 0)) then {
                    [_vehicle] remoteExec ["OKS_fnc_AdjustDamage",0];
                    [_vehicle] remoteExec ["OKS_fnc_AdjustDamage",_HeadlessClients];
                };
            }, true, [], true] call CBA_fnc_addClassEventHandler;
        };

        /*
            Add code to spawned units.
        */
        ["CAManBase", "init", {
            params ["_unit"];
            if (!isPlayer _unit) then {
                private _SuppressionEnabled = missionNamespace getVariable ["GOL_Suppression_Enabled", true];
                if(_SuppressionEnabled && side group _unit != civilian) then {
                    _HeadlessClients = entities "HeadlessClient_F";
                    [_unit] remoteExec ["OKS_fnc_Suppressed",2];
                    [_unit] remoteExec ["OKS_fnc_Suppressed",_HeadlessClients];
                };

                private _SurrenderEnabled = missionNamespace getVariable ["GOL_Surrender_Enabled", true];
                if(_SurrenderEnabled && side group _unit != civilian) then {
                    _HeadlessClients = entities "HeadlessClient_F";
                    [_unit] remoteExec ["OKS_fnc_Surrender",2];
                    [_unit] remoteExec ["OKS_fnc_Surrender",_HeadlessClients];
                };

                private _FaceSwapEnabled = missionNamespace getVariable ["GOL_FaceSwap_Enabled", true];
                if(_FaceSwapEnabled) then {
                    // Apply ethnicity and face swap
                    _unit spawn {
                        params ["_unit"];
                        sleep 1;
                        _HeadlessClients = entities "HeadlessClient_F";
                        [_unit] remoteExec ["OKS_fnc_FaceSwap",2];
                        [_unit] remoteExec ["OKS_fnc_FaceSwap",_HeadlessClients];
                    };
                };

                if(side group _unit != civilian) then {
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

        _unit spawn {
            params ["_unit"];
            sleep 5;

            // Get all player units (for side comparison)
            private _players = allPlayers select {alive _x};
            if (_players isEqualTo []) exitWith {
                private _SurrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", true];  
                if(_SurrenderDebug) then {
                    "No players found for enemy check!" spawn OKS_fnc_LogDebug;
                };
            };

            // Assume first player as reference for "enemy" side
            private _playerSide = side (group (_players select 0));
            {
                if (
                    _x isKindOf "CAManBase" &&
                    !isPlayer _x &&
                    side _x getFriend _playerSide < 0.6 &&
                    side group _x != civilian
                ) then {
                    private _SurrenderEnabled = missionNamespace getVariable ["GOL_Surrender_Enabled", true];
                    if(_SurrenderEnabled) then {                                
                        _HeadlessClients = entities "HeadlessClient_F";
                        [_x] remoteExec ["OKS_fnc_Surrender",2];
                        [_x] remoteExec ["OKS_fnc_Surrender",_HeadlessClients];
                    };
                };

                if(_X isKindOf "CAManBase" && !isPlayer _X) then {
                    private _SuppressionEnabled = missionNamespace getVariable ["GOL_Suppression_Enabled", true];
                    if(_SuppressionEnabled) then {
                        _HeadlessClients = entities "HeadlessClient_F";
                        [_unit] remoteExec ["OKS_fnc_Suppressed",2];
                        [_unit] remoteExec ["OKS_fnc_Suppressed",_HeadlessClients];
                    };

                    private _FaceSwapEnabled = missionNamespace getVariable ["GOL_FaceSwap_Enabled", true];
                    if(_FaceSwapEnabled) then {
                        _HeadlessClients = entities "HeadlessClient_F";
                        [_x] remoteExec ["OKS_fnc_FaceSwap",0];
                        [_x] remoteExec ["OKS_fnc_FaceSwap",_HeadlessClients];                     
                    };

                    _unit spawn {
                        params ["_unit"];
                        private ["_group"];
                        sleep 5;
                        _group = group _unit;
                        if(_group getVariable ["OKS_EnablePath_Active",false]) exitWith {
                            // Exit if already enabled on Group level.
                        };
        
                        if(!isNil "OKS_fnc_EnablePath" && !(_unit checkAIFeature "PATH")) then {        
                            _group setVariable ["OKS_EnablePath_Active",true,true];

                            _HeadlessClients = entities "HeadlessClient_F";
                            [_group] remoteExec ["OKS_fnc_EnablePath",0];
                            [_groupk] remoteExec ["OKS_fnc_EnablePath",_HeadlessClients];
                        };
                    };  
                };
            } forEach allUnits;
        };

        /*
            OKS Locations for Dynamic Setup
        */
        OKS_AllUnits = [];
        OKS_Logics = (allMissionObjects "all") select {typeOf _X in ["LocationCamp_F","LocationResupplyPoint_F","LocationRespawnPoint_F","LocationEvacPoint_F","LocationFOB_F","LocationCityCapital_F","LocationCity_F","LocationVillage_F","LocationArea_F","LocationBase_F","LocationOutpost_F","LocationCamp_F","LocationRespawnPoint_F"]};

        OKS_Locations = OKS_Logics select {typeOf _X in ["LocationResupplyPoint_F","LocationEvacPoint_F","LocationCityCapital_F","LocationCity_F","LocationArea_F"]};
        OKS_Compounds = OKS_Logics select {typeOf _X in ["LocationOutpost_F"]};
        OKS_Strongholds = OKS_Logics select {typeOf _X in ["LocationBase_F"]};
        OKS_Objectives = OKS_Logics select {typeOf _X in ["LocationCamp_F"]};
        OKS_HuntLocations = OKS_Logics select {typeOf _X in ["LocationRespawnPoint_F"]};
        OKS_RoadBlocks = OKS_Logics select {typeOf _X in ["LocationFOB_F"]};
        OKS_Villages = OKS_Logics select {typeOf _X in ["LocationVillage_F"]};
        OKS_RoadBlock_Positions = [];
        OKS_Mortar_Positions = [];
        OKS_Objective_Positions = [];
        OKS_Hunt_Positions = [];

        /*
            OKS Force & Response Multiplier Values
            Used for increasing hunt intensity
        */
        missionNamespace setVariable ["GOL_ForceMultiplier", 1, true];
        missionNamespace setVariable ["GOL_ResponseMultiplier", 1, true];

        /*
            Create Arsenal for Grenadiers & Automatic Riflemen
        */
        if (isNil "GOL_Arsenal_LMG") then {
            GOL_Arsenal_LMG = "Logic" createVehicle [1000,1000,0];
            publicVariable "GOL_Arsenal_LMG";
        };   
        if (isNil "GOL_Arsenal_GL") then {
            GOL_Arsenal_GL = "Logic" createVehicle [1000,15000,0];
            publicVariable "GOL_Arsenal_GL";
        };   
    
        NEKY_Hunt_CurrentCount = [];
        publicVariable "NEKY_Hunt_CurrentCount";
    };  
};