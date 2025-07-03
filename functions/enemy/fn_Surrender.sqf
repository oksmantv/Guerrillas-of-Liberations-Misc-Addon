/*
    [_this, 0.4, 50, true, true] spawn OKS_fnc_Surrender;
    [_unit, _chance, _ChanceWeaponAim, _distance, _DistanceWeaponAim, _byShot, _byFlashbang, _NearFriendliesDistance] spawn OKS_fnc_Surrender;
*/
params [
    "_Unit",
    ["_Chance",(missionNamespace getVariable ["GOL_Surrender_Chance", 0.2]),[0]],
    ["_ChanceWeaponAim",(missionNamespace getVariable ["GOL_Surrender_ChanceWeaponAim", 0.2]),[0]],
    ["_Distance",(missionNamespace getVariable ["GOL_Surrender_Distance", 30]),[0]],
    ["_DistanceWeaponAim",(missionNamespace getVariable ["GOL_Surrender_DistanceWeaponAim", 50]),[0]],
    ["_SurrenderByShot",(missionNamespace getVariable ["GOL_Surrender_Shot", true]),[false]],
    ["_SurrenderByFlashbang",(missionNamespace getVariable ["GOL_Surrender_Flashbang", true]),[false]],
    ["_NearFriendliesDistance",(missionNamespace getVariable ["GOL_Surrender_FriendlyDistance", 200]),[0]],
    ["_SurrenderByThreat",(missionNamespace getVariable ["GOL_Surrender_Threat", false]),[false]]
];

if(_Unit getVariable ["GOL_SurrenderEnabled",false]) exitWith {};
_Unit setVariable ["GOL_SurrenderEnabled",true,true];
private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];
private ["_NearPlayers"];

if(hasInterface && !isServer) exitWith {};
if(isNil "_Unit") exitWith {
    if(_surrenderDebug) then {
        format ["[SURRENDER] Surrender Script Unit is nil, exiting..",_Unit, name _Unit] spawn OKS_fnc_LogDebug;
    };
};
if(isNull _Unit) exitWith {
    if(_surrenderDebug) then {
        format ["[SURRENDER] Surrender Script Unit is null, exiting..",_Unit, name _Unit] spawn OKS_fnc_LogDebug;
    };
};
if(_surrenderDebug) then {
    format ["[SURRENDER] Surrender Script Activated for %1 - %2",_Unit, name _Unit] spawn OKS_fnc_LogDebug;
};

_Unit setVariable ["GOL_Surrender",true,true];
_Unit setVariable ["GOL_SurrenderDistance",_Distance,true];
_Unit setVariable ["GOL_ChanceSurrender",_Chance,true];
_Unit setVariable ["GOL_NearFriendliesDistance",_NearFriendliesDistance,true];

if (_SurrenderByShot) then {
    _Unit addEventHandler ["Hit", {
        params ["_unit", "_source", "_damage", "_instigator"];

        if(!isPlayer _instigator) exitWith {
            // If the instigator is not a player, do not check for surrender.
        };

        private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];
        private _baseChance = _unit getVariable ["GOL_ChanceSurrender", 0];
        private _surrenderDistance = _Unit getVariable ["GOL_SurrenderDistance",50];

        if (isPlayer _instigator && (_instigator distance _unit < _surrenderDistance) && vehicle _unit == _unit) then {
            if([_unit, 5, "Hit"] call OKS_fnc_CheckCooldown) then {
                // Increase for suppression
                _adjustedChance = [_unit, _baseChance] call OKS_fnc_Adjust_Suppressed;

                // Increase for being shot
                _adjustedChance = [_unit, _adjustedChance] call OKS_fnc_Adjust_Shot;

                // Set to surrendered if unarmed.
                _adjustedChance = [_unit, _adjustedChance] call OKS_fnc_Adjust_Unarmed;

                // Handle Surrender
                [_unit, _adjustedChance] call OKS_fnc_HandleChance;
            };
        };
    }];
};

// Add Surrender by Flashbang
if (_SurrenderByFlashbang) then {
    ["ace_grenades_flashbangedAI", {
        params ["_unit"];
        private _baseChance = _unit getVariable ["GOL_ChanceSurrender", 0];
        if (_unit getVariable ["GOL_Surrender", false] && vehicle _unit == _unit) then {
            if([_unit, 5, "Flashbang"] call OKS_fnc_CheckCooldown) then {
                // Increase for suppression
                _adjustedChance = [_unit, _baseChance] call OKS_fnc_Adjust_Suppressed;

                // Increase for being shot
                _adjustedChance = [_unit, _adjustedChance] call OKS_fnc_Adjust_Shot;

                // Set to surrendered if unarmed.
                _adjustedChance = [_unit, _adjustedChance] call OKS_fnc_Adjust_Unarmed;

                // Increase for flashbang
                _adjustedChance = [_unit, _adjustedChance] call OKS_fnc_Adjust_Flashbang;

                // Handle Surrender
                [_unit, _adjustedChance] call OKS_fnc_HandleChance;
            };
        };
    }] call CBA_fnc_addEventHandler;
};

// Add FiredNear Event for Surrender.
_Unit addEventHandler ["Suppressed", {
    params ["_unit", "_distance", "_firer", "_instigator", "_ammoObject", "_ammoClassname", "_ammoConfig"];

    if(!isPlayer _firer) exitWith {
        // If the firer is not a player, do not check for surrender.
    };

    if (_distance > 20) exitWith {}; // Skip if round is far from the unit.
    if (!isPlayer _firer) exitWith {}; // Skip if round is not fired from player;
    private _baseChance = _unit getVariable ["GOL_ChanceSurrender", 0];
    private _surrenderDistance = _unit getVariable ["GOL_SurrenderDistance",50];
    if (isPlayer _firer && ((_unit distance _firer) < _surrenderDistance) && vehicle _unit == _unit) then {
        if([_unit, 5,"Suppressed"] call OKS_fnc_CheckCooldown) then {
            // Increase if Suppressed
            _adjustedChance = [_unit, _baseChance] call OKS_fnc_Adjust_Suppressed;

            // Increase if unarmed.
            _adjustedChance = [_unit, _adjustedChance] call OKS_fnc_Adjust_Unarmed;

            // Handle Surrender
            [_unit, _adjustedChance] call OKS_fnc_HandleChance;
        };
    };
}];

if(_surrenderDebug) then {"[SURRENDER] Setup OK - Waiting for Nearby Player for Aim Threat" spawn OKS_fnc_LogDebug};
waitUntil {
    sleep 5 + (random 5);
    _NearPlayers = (_Unit nearEntities [["Man"], _DistanceWeaponAim]) select {isPlayer _X};
    count _NearPlayers > 0 || !Alive _Unit
};

if(!(_unit getVariable ["GOL_Surrender",true]) || !Alive _Unit) exitWith { if(_surrenderDebug) then { "Surrendered already or killed. Will not check player aiming." spawn OKS_fnc_LogDebug } };

if(_SurrenderByThreat) then {
    private _interval = 0.5; // seconds
    private _pfhId = [
        {
            params ["_args", "_pfhId"];
            _args params ["_unit", "_chance", "_distance"];
            private _threatTolerance = 70; // degrees
            private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];

            // Debug: Handler running
            // systemChat format ["Handler running for unit %1", name _unit];

            // Exit if unit is dead, captive, or surrender logic is off
            if !(alive _unit && !captive _unit && _unit getVariable ["GOL_Surrender", false]) exitWith {
                [_pfhId] call CBA_fnc_removePerFrameHandler;
            };

            // Skip surrender check if unit is inside any vehicle (but keep handler running)
            if (vehicle _unit != _unit || _unit getVariable ["GOL_Threatened",false]) exitWith {};

            // "Aimed at" check
            private _players = (_unit nearEntities [["Man"], _distance]) select {isPlayer _x && alive _x};
            {
                private _playerPos = eyePos _x;
                private _unitPos = aimPos _unit;
                private _dirToUnit = _unitPos vectorDiff _playerPos; // Direction from player to unit

                private _playerDir = _x weaponDirection (currentWeapon _x);

                // Avoid division by zero
                if ((vectorMagnitude _playerDir) == 0 || (vectorMagnitude _dirToUnit) == 0) exitWith {};

                // Normalize vectors
                private _dirToUnitNorm = _dirToUnit vectorMultiply (1 / vectorMagnitude _dirToUnit);
                private _playerDirNorm = _playerDir vectorMultiply (1 / vectorMagnitude _playerDir);

                // Dot product and clamp
                private _dot = _playerDirNorm vectorDotProduct _dirToUnitNorm;
                _dot = (_dot max -1) min 1;

                // Angle in radians and degrees
                private _angle = acos _dot;
                private _angleDeg = _angle * 57.2958;

                // Debug: Show angle degrees
                //systemChat format ["Angle between player %1 and unit %2: %3", name _x, name _unit, _angleDeg];
                if (_angleDeg < _threatTolerance &&
                    behaviour _unit == "COMBAT" &&
                    _unit knowsAbout _X > 3 &&
                    (side group _unit) getFriend (side group _x) < 0.6
                ) then {
                    // Set to surrendered if unarmed.
                    if(primaryWeapon _unit == "" && secondaryWeapon _unit == "" && handgunWeapon _unit == "") then {
                        _chance = 0.5;
                        if(_surrenderDebug) then { format ["[SURRENDER] Unarmed increased chance to %1%%", round(_chance * 100)] spawn OKS_fnc_LogDebug; };
                    }; 

                    _unit setVariable ["GOL_Threatened",true,true];
                    _unit spawn {
                        params ["_unit"];
                        sleep 5;
                        _unit setVariable ["GOL_Threatened",false,true];
                    };

                    private _dice = random 1;
                    if (_dice < _chance ) exitWith {
                        if(_unit getVariable ["GOL_Surrender",false]) then {
                            [_unit,_X] spawn {
                                params ["_unit","_player"];
                                private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];
                                [_unit] spawn OKS_fnc_SurrenderHandle;
                                _unit setVariable ["GOL_Surrender", false, true];
                                if(_surrenderDebug) then { format ["[SURRENDER] Unit %1 surrendered to player %2", name _unit, name _player] spawn OKS_fnc_LogDebug; };
                            };
                        };
                        [_pfhId] call CBA_fnc_removePerFrameHandler;
                    };
                };
            } forEach _players;
        },
        _interval, // Interval in seconds
        [_unit, _ChanceWeaponAim, _DistanceWeaponAim] // Arguments passed to the handler
    ] call CBA_fnc_addPerFrameHandler;

};