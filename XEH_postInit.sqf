
diag_log "OKS_GOL_Misc: XEH_postInit.sqf executed";
/*
    OKS Force & Response Multiplier Values
    Used for increasing hunt intensity
*/
missionNamespace setVariable ["OKS_ForceMultiplier", 1, true];
missionNamespace setVariable ["OKS_ResponseMultiplier", 1, true];

/* Define Player Side for Scripts */
OKS_FRIENDLY_SIDE = side group player;
publicVariable "OKS_FRIENDLY_SIDE";
missionNameSpace setVariable ["OKS_Friendly_Side",OKS_FRIENDLY_SIDE,true];

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

