
diag_log "OKS_GOL_Misc: XEH_postInit.sqf executed";

OKS_Core_Enabled = missionNamespace getVariable ["OKS_CORE_Enabled",false];
if(OKS_Core_Enabled isEqualTo true) then {
    /*
        OKS Force & Response Multiplier Values
        Used for increasing hunt intensity
    */
    missionNamespace setVariable ["OKS_ForceMultiplier", 1, true];
    missionNamespace setVariable ["OKS_ResponseMultiplier", 1, true];
    OKS_Entrench = missionNamespace getVariable ["GOL_ENTRENCH",false];
    OKS_WireCutter = missionNamespace getVariable ["GOL_Wirecutter",false];
    OKS_ForceNVG = missionNamespace getVariable ["GOL_ForceNVG",false];
    OKS_AIForceNVG = missionNamespace getVariable ["GOL_AIForceNVG",false]; 
    OKS_ForceNVGClassname = missionNamespace getVariable ["GOL_ForceNVGClassname",""];
    OKS_AIForceNVGClassname = missionNamespace getVariable ["GOL_AIForceNVGClassname",""];  
    OKS_Weapons = missionNamespace getVariable ["GOL_WEAPONS",false];
    OKS_MagnifiedOptics = missionNamespace getVariable ["GOL_MAGNIFIED_OPTICS",false];
    OKS_Optics = missionNamespace getVariable ["GOL_OPTICS",true];
    OKS_GroundRoles = missionNamespace getVariable ["GOL_AllowSpecialistGroundRoles",false];
    OKS_AirRoles = missionNamespace getVariable ["GOL_AllowSpecialistAirRoles",false];
    OKS_Arsenal = missionNamespace getVariable ["GOL_ARSENAL_ALLOWED",false];

    // Make all variables public for multiplayer
    publicVariable "OKS_Entrench";
    publicVariable "OKS_WireCutter";
    publicVariable "OKS_ForceNVG";
    publicVariable "OKS_AIForceNVG";
    publicVariable "OKS_ForceNVGClassname";
    publicVariable "OKS_AIForceNVGClassname";
    publicVariable "OKS_Weapons";
    publicVariable "OKS_MagnifiedOptics";
    publicVariable "OKS_Optics";
    publicVariable "OKS_GroundRoles";
    publicVariable "OKS_AirRoles";
    publicVariable "OKS_Arsenal";

    if(isServer) then {
        NEKY_Hunt_CurrentCount = [];
        publicVariable "NEKY_Hunt_CurrentCount";
    };

    /* Define Player Side for Scripts */
    missionNameSpace setVariable ["OKS_Friendly_Side",(side group player),true];

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
            (!isNil "ORBAT_GROUP" && !isNil "GOL_Composition") || {time > _timeout}
        },
        {
            // Execution: Check which case triggered
            if (!isNil "ORBAT_GROUP" && !isNil "GOL_Composition") then {
                private _composition = missionNamespace getVariable "GOL_Composition";
                [_composition] spawn OKS_fnc_Orbat_Setup;
            } else {
                if (isServer) then {
                    if (isNil "ORBAT_GROUP") then {
                        systemChat "[DEBUG] The ORBAT Group module is missing.";
                    };
                    if (isNil "GOL_Composition") then {
                        systemChat "[DEBUG] GOL_Composition variable is undefined. If you want to use the ORBAT, make sure to assign it in missionSettings.sqf.";
                    };
                };
            };
        },
        [],
        _interval
    ] call CBA_fnc_waitUntilAndExecute;

    /*
        Setup Framework Check
    */
    [] call OKS_fnc_CheckFrameworkObjects;

    /*
        Setup TFAR Radios
    */
    [] call OKS_fnc_TFAR_RadioSetup;

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
                systemChat "[DEBUG] DeathScore disabled - Can't find scoreboards";
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
    NEKY_ServiceStationActive = [];
    NEKY_ServiceStations = [];
    publicVariable "NEKY_ServiceStationActive";
    publicVariable "NEKY_ServiceStations";

    /*
        RemoveVehicleHE from Current Vehicles.
    */
    private _RemoveVehicleHE_Enabled = missionNamespace getVariable ["OKS_RemoveVehicleHE_Enabled",true];
    if (_RemoveVehicleHE_Enabled) then {
        // Process existing vehicles immediately
        {
            _vehicle = _X;
            if (["T34","T55","T72","T80"] findIf {typeOf _vehicle find _x >= 0} != -1 
                && (typeOf _x find "UK3CB" >= 0)) then {
                [_vehicle] spawn OKS_fnc_AdjustDamage;
            };
            [_vehicle] spawn OKS_fnc_RemoveVehicleHE;
            [_vehicle] spawn OKS_fnc_ForceVehicleSpeed;
        } forEach (vehicles select {_x isKindOf "LandVehicle"});
        
        ["LandVehicle", "init", {
            params ["_vehicle"];
            [_vehicle] spawn OKS_fnc_RemoveVehicleHE;
            [_vehicle] spawn OKS_fnc_ForceVehicleSpeed;
            
            // Whitelist check moved outside select for better performance
            private _type = typeOf _vehicle;
            if ((["T34","T55","T72","T80"] findIf {_type find _x >= 0}) != -1 
                && (_type find "UK3CB" >= 0)) then {
                [_vehicle] spawn OKS_AdjustDamage;
            };
        }, true, [], true] call CBA_fnc_addClassEventHandler;
    };

    // Adds Code on EventHandler: Spawned Units.
    ["CAManBase", "init", {
        params ["_unit"];
        if (local _unit && {!isPlayer _unit}) then {
            private _SuppressionEnabled = missionNamespace getVariable ["OKS_Suppression_Enabled", true];
            if(_SuppressionEnabled) then {
                [_unit] spawn OKS_fnc_Suppressed;
            };

            private _SurrenderEnabled = missionNamespace getVariable ["OKS_Surrender_Enabled", true];
            if(_SurrenderEnabled) then {
                // Get current CBA settings
                private _surrenderByShot               = missionNamespace getVariable ["OKS_Surrender_Shot", true];
                private _surrenderByFlashbang          = missionNamespace getVariable ["OKS_Surrender_Flashbang", true];
                private _surrenderChance               = missionNamespace getVariable ["OKS_Surrender_Chance", 0.2];
                private _surrenderChanceWeaponAim      = missionNamespace getVariable ["OKS_Surrender_ChanceWeaponAim", 0.2];           
                private _surrenderDistance             = missionNamespace getVariable ["OKS_Surrender_Distance", 30];
                private _surrenderDistanceWeaponAim    = missionNamespace getVariable ["OKS_Surrender_DistanceWeaponAim", 50];
                private _surrenderFriendlyDistance     = missionNamespace getVariable ["OKS_Surrender_FriendlyDistance", 200];
            
                // Call your Surrender function with these settings
                [_unit, _surrenderChance, _surrenderChanceWeaponAim, _surrenderDistance, _surrenderDistanceWeaponAim, _surrenderByShot, _surrenderByFlashbang, _surrenderFriendlyDistance] spawn OKS_fnc_Surrender;
            };

            private _FaceSwapEnabled = missionNamespace getVariable ["OKS_FaceSwap_Enabled", true];
            if(_FaceSwapEnabled) then {
                // Apply ethnicity and face swap
                _unit spawn {
                    params ["_unit"];
                    sleep 1;
                    private _ethnicity = [_unit] call OKS_fnc_GetEthnicity;
                    [_unit, _ethnicity] call OKS_fnc_FaceSwap;
                };
            };           
        };
    }] call CBA_fnc_addClassEventHandler;

    if (isServer) then {
        // Get all player units (for side comparison)
        private _players = allPlayers select {alive _x};
        if (_players isEqualTo []) exitWith {
            private _SurrenderDebug = missionNamespace getVariable ["OKS_Surrender_Debug", true];  
            if(_SurrenderDebug) then {
                systemChat "[OKS] No players found for enemy check!";
            };
        };

        // Assume first player as reference for "enemy" side
        private _playerSide = side (group (_players select 0));
        {
            if (
                _x isKindOf "CAManBase" &&
                !isPlayer _x &&
                side _x getFriend _playerSide < 0.6 // 0.6 = hostile, see https://community.bistudio.com/wiki/side_relations
            ) then {
                private _SurrenderEnabled = missionNamespace getVariable ["OKS_Surrender_Enabled", true];
                if(_SurrenderEnabled) then {
                    // Get current CBA settings
                    private _surrenderByShot               = missionNamespace getVariable ["OKS_Surrender_Shot", true];
                    private _surrenderByFlashbang          = missionNamespace getVariable ["OKS_Surrender_Flashbang", true];
                    private _surrenderChance               = missionNamespace getVariable ["OKS_Surrender_Chance", 0.2];
                    private _surrenderChanceWeaponAim      = missionNamespace getVariable ["OKS_Surrender_ChanceWeaponAim", 0.2];           
                    private _surrenderDistance             = missionNamespace getVariable ["OKS_Surrender_Distance", 30];
                    private _surrenderDistanceWeaponAim    = missionNamespace getVariable ["OKS_Surrender_DistanceWeaponAim", 50];
                    private _surrenderFriendlyDistance     = missionNamespace getVariable ["OKS_Surrender_FriendlyDistance", 200];               
                
                    // Call your Surrender function with these settings
                    [_x, _surrenderChance, _surrenderChanceWeaponAim, _surrenderDistance, _surrenderDistanceWeaponAim, _surrenderByShot, _surrenderByFlashbang, _surrenderFriendlyDistance] spawn OKS_fnc_Surrender;
                };
            };

            if(_X isKindOf "CAManBase" && !isPlayer _X) then {
                private _SuppressionEnabled = missionNamespace getVariable ["OKS_Suppression_Enabled", true];
                if(_SuppressionEnabled) then {
                    [_unit] spawn OKS_fnc_Suppressed;
                };

                private _FaceSwapEnabled = missionNamespace getVariable ["OKS_FaceSwap_Enabled", true];
                if(_FaceSwapEnabled) then {
                    // Apply ethnicity and face swap
                    private _ethnicity = [_x] call OKS_fnc_GetEthnicity;
                    [_x, _ethnicity] call OKS_fnc_FaceSwap;
                };
            };
        } forEach allUnits;
    };

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
            [_Vehicle] execVM "Scripts\OKS_Vehicles\OKS_Mechanized.sqf";	
        };
    };

    if(!isNil "MHQ_1") then {
        GOL_NEKY_MHQDROP_VEHICLECLASS = (typeOf MHQ_1); // Classname
        GOL_NEKY_MHQDROP_APPEARANCE = compile ([MHQ_1,""] call BIS_fnc_exportVehicle);
        GOL_NEKY_MHQDROP_CODE = {

            Params ["_Vehicle"];
            _Vehicle call GOL_NEKY_MHQDROP_APPEARANCE;

            [_Vehicle, "medium"] call GW_MHQ_Fnc_Handler;
            [_Vehicle,25,true] ExecVM "Scripts\NEKY_ServiceStation\MobileSS.sqf";

            sleep 5;	
            [_Vehicle] execVM "Scripts\OKS_Vehicles\OKS_Mechanized.sqf";	

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
                //systemChat format["%1 is unconscious",name _unit];
                _playerbloodVolume = _unit getVariable ["ace_medical_bloodVolume", 6];

                //systemChat str _playerbloodVolume;
                if(_playerbloodVolume <= 5.1) then {
                    //systemChat "Player is Tier 2";
                    //[false, 0] call ace_medical_feedback_fnc_effectUnconscious;
                    [_unit] spawn {
                        params ["_unit"];
                        private _dir = 0;
                        private _height = 4;
                        private _distance = 3;

                        _camera = _unit getVariable ["GOL_SpectatorCamera",nil];
                        if(isNil "_camera") then {
                            //systemChat "Creating Camera";
                            _Position = (getPosATL _unit) getPos [_distance,_Dir];
                            _camera = "camera" camCreate [_Position select 0,_Position select 1,_height];     
                        };
                        _camera camSetTarget player;
                        _unit setVariable ["GOL_SpectatorCamera",_camera,true];	
                        cutText ["", "BLACK OUT",1]; sleep 1;
                        //systemChat "BLACK OUT";
                        
                        waitUntil {!isNil "ace_medical_feedback_ppUnconsciousBlur"};
                        ppEffectDestroy ace_medical_feedback_ppUnconsciousBlur;            

                        waitUntil {!isNil "ace_medical_feedback_ppUnconsciousBlackout"};
                        ppEffectDestroy ace_medical_feedback_ppUnconsciousBlackout;      

                        showCinemaBorder true;
                        _camera cameraEffect ["internal", "back"];
                        sleep 2;
                        cutText ["", "BLACK IN",3];
                        //systemChat "BLACK IN";

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
                            //systemChat "Unconscious - Moving Camera";
                            sleep 1;
                        };			

                        //cutText ["", "BLACK IN",1];
                        //[true, 0] call ace_medical_feedback_fnc_effectUnconscious;   
                    };
                };
            };
            if(!(_unconscious)) then {
                // Exit Camera 
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
            };
        }];

        /*
            Add Medical Messages to Players.
        */
        ["ace_treatmentStarted", OKS_fnc_medicalMessage] call CBA_fnc_addEventHandler;

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

};