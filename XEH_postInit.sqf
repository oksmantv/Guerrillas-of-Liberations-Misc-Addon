
diag_log "OKS_GOL_Misc: XEH_postInit.sqf executed";

GOL_Core_Enabled = missionNamespace getVariable ["GOL_CORE_Enabled",false];
if(GOL_Core_Enabled isEqualTo true) then {
/*
    Global Executions.
*/
if(true) then {
    /* Define Player Side for Scripts */
    missionNameSpace setVariable ["GOL_Friendly_Side",(side group player),true];

    /*
        RemoveVehicleHE from Current and spawned Vehicles.
    */
    private _RemoveVehicleHE_Enabled = missionNamespace getVariable ["GOL_RemoveVehicleHE_Enabled",true];
    if (_RemoveVehicleHE_Enabled) then {
        _HeadlessClients = entities "HeadlessClient_F";
        // Process existing vehicles immediately
        {
            _vehicle = _X;
            if(local _x) then {
                if (["T34","T55","T72","T80"] findIf {typeOf _vehicle find _x >= 0} != -1 
                    && (typeOf _x find "UK3CB" >= 0)) then {
                    [_vehicle] spawn OKS_fnc_AdjustDamage;
                };
                [_vehicle] spawn OKS_fnc_RemoveVehicleHE;
                [_vehicle] spawn OKS_fnc_ForceVehicleSpeed;               
            };
        } forEach (vehicles select {_x isKindOf "LandVehicle"});
        
        ["LandVehicle", "init", {
            params ["_vehicle"];
            if(local _vehicle) then {
                [_vehicle] spawn OKS_fnc_RemoveVehicleHE;
                [_vehicle] spawn OKS_fnc_ForceVehicleSpeed;
                
                // Whitelist check moved outside select for better performance
                private _type = typeOf _vehicle;
                if ((["T34","T55","T72","T80"] findIf {_type find _x >= 0}) != -1 
                    && (_type find "UK3CB" >= 0)) then {
                    [_vehicle] spawn OKS_fnc_AdjustDamage;
                };
            };
        }, true, [], true] call CBA_fnc_addClassEventHandler;
    };

    /*
        Add code to spawned units.
    */
    ["CAManBase", "init", {
        params ["_unit"];
        if (!isPlayer _unit && local _unit) then {
            private _SuppressionEnabled = missionNamespace getVariable ["GOL_Suppression_Enabled", true];
            if(_SuppressionEnabled && side group _unit != civilian) then {
                _unit spawn {
                    sleep 1;
                    [_unit] spawn OKS_fnc_Suppressed;
                };
            };

            private _SurrenderEnabled = missionNamespace getVariable ["GOL_Surrender_Enabled", true];
            if(_SurrenderEnabled && side group _unit != civilian) then {
                _unit spawn {
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
            side group _x != civilian &&
            local _X
        ) then {
            private _SurrenderEnabled = missionNamespace getVariable ["GOL_Surrender_Enabled", true];
            if(_SurrenderEnabled) then {                                
                [_x] spawn OKS_fnc_Surrender
            };
        };

        if(_X isKindOf "CAManBase" && !isPlayer _X) then {
            private _SuppressionEnabled = missionNamespace getVariable ["GOL_Suppression_Enabled", true];
            if(_SuppressionEnabled) then {
                [_unit] spawn OKS_fnc_Suppressed
            };

            private _FaceSwapEnabled = missionNamespace getVariable ["GOL_FaceSwap_Enabled", true];
            if(_FaceSwapEnabled) then {
                [_x] spawn OKS_fnc_FaceSwap;                   
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

        /* Setup Support & Tent MHQ */
        _condition = {leader group player == player};
        _action = ["Request_Support", "Request Support","\A3\ui_f\data\map\VehicleIcons\iconCrateVeh_ca.paa", {}, _condition] call ace_interact_menu_fnc_createAction;
        [typeOf player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToClass;
        [] spawn OKS_fnc_Orbat_Action;

        if(!isNil "Tent_MHQ") then {
            [] spawn OKS_fnc_ACE_MoveMHQ;
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