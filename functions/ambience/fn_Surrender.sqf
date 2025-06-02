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
    ["_NearFriendliesDistance",(missionNamespace getVariable ["GOL_Surrender_FriendlyDistance", 200]),[0]]
];

private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];
private ["_NearPlayers"];

if(hasInterface) exitWith {};

if(isNull _Unit) exitWith {
    format ["Surrender Script Unit is null, exiting..",_Unit, name _Unit] spawn OKS_fnc_LogDebug;
};

if(_surrenderDebug) then {
    format ["Surrender Script Activated for %1 - %2",_Unit, name _Unit] spawn OKS_fnc_LogDebug;
};

_Unit setVariable ["GOL_Surrender",true,true];
_Unit setVariable ["GOL_SurrenderDistance",_Distance,true];
_Unit setVariable ["GOL_ChanceSurrender",_Chance,true];
_Unit setVariable ["GOL_NearFriendliesDistance",_NearFriendliesDistance,true];

if (_SurrenderByShot) then {
    _Unit addEventHandler ["Hit", {
        params ["_unit", "_source", "_damage", "_instigator"];
        private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];
        private _surrenderDistance = _Unit getVariable ["GOL_SurrenderDistance",50];
        private _nearFriendliesDistance = _Unit getVariable ["GOL_NearFriendliesDistance",200];
        if (isPlayer _instigator && (_instigator distance _unit < _surrenderDistance) && vehicle _unit == _unit) then {
            private _baseChance = _unit getVariable ["GOL_ChanceSurrender", 0];
            private _side = side (group _unit);
            private _nearbyFriendlies = (_unit nearEntities [["Man"], _nearFriendliesDistance]) select {
                side (group _x) isEqualTo _side && alive _x && _x != _unit
            };
            private _nearbyFriendliesClose = (_unit nearEntities [["Man"], _nearFriendliesDistance * 0.5]) select {
                side (group _x) isEqualTo _side && alive _x && _x != _unit
            };

            if(count _nearbyFriendliesClose > 10) exitWith {}; // Skip if close to a lot of friendlies

            private _numFriendlies = count _nearbyFriendlies;
            private _adjustedChance = _baseChance;

            // Increase for few friendlies
            if (_numFriendlies < 10) then {
                private _inc = 0.025 * (10 - _numFriendlies);
                _adjustedChance = _adjustedChance + _inc;
                if(_surrenderDebug) then {
                    format ["Surrender chance increased by %1 %% (few friendlies nearby: %2). New chance: %3%%",(_inc * 100), _numFriendlies, (_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
                };
            } else {
                _adjustedChance = _adjustedChance * 0.3;
            };

            // Increase for suppression
            private _suppression = getSuppression _unit;
            if (_suppression > 0.7) then {
                _adjustedChance = _adjustedChance + 0.1;
                if(_surrenderDebug) then {
                    format [
                        "Surrender chance increased by 10%% (suppression: %1). New chance: %2%%",
                        round(_suppression * 100), round(_adjustedChance * 100)
                    ] spawn OKS_fnc_LogDebug;
                };
            };

            // Increase for being shot
            _adjustedChance = _adjustedChance + 0.1;
            if(_surrenderDebug) then {
                format [
                    "Surrender chance increased by 10%% (shot). New chance: %1%%",
                    round(_adjustedChance * 100)
                ] spawn OKS_fnc_LogDebug;
            };
            // Set to surrendered if unarmed.
            if(primaryWeapon _unit == "" && secondaryWeapon _unit == "" && handgunWeapon _unit == "") then {
                _adjustedChance = 0.5;
                if(_surrenderDebug) then {
                    format ["Unarmed increased chance to %1%%", round(_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
                };
            };

            _adjustedChance = _adjustedChance min 1;
            if(_surrenderDebug) then {
                format ["Final surrender chance: %1%%", round(_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
            };
            private _dice = random 1;
            if(_surrenderDebug) then {
                format ["Dice rolled: %1 (must be less than %2 to surrender)", round(_dice * 100), round(_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
            };
            if (_dice < _adjustedChance) then {
                if(_unit getVariable ["GOL_Surrender",false]) then {
                    [_unit] spawn OKS_fnc_SurrenderHandle;
                };
                _unit removeAllEventHandlers "Hit";
            } else {
                if(_surrenderDebug) then {"Surrender not triggered by shot." spawn OKS_fnc_LogDebug;}
            };

        };
    }];
};


// Add Surrender by Flashbang
if (_SurrenderByFlashbang) then {
    ["ace_grenades_flashbangedAI", {
        _unit = _this select 0;
        if (_unit getVariable ["GOL_Surrender", false] && vehicle _unit == _unit) then {
            private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];
            private _baseChance = _unit getVariable ["GOL_ChanceSurrender", 0];
            private _side = side (group _unit);
            private _nearFriendliesDistance = _Unit getVariable ["GOL_NearFriendliesDistance",200];
            private _nearbyFriendlies = (_unit nearEntities [["Man"], _NearFriendliesDistance]) select {
                side (group _x) isEqualTo _side && alive _x && _x != _unit
            };
            private _nearbyPlayers = AllPlayers select {
                alive _x && _x distance _unit < 50
            };
            if(count _nearbyPlayers == 0) exitWith { if(_surrenderDebug) then {"Flashbang Event Cancelled - No players nearby." spawn OKS_fnc_LogDebug; }};
            private _numFriendlies = count _nearbyFriendlies;
            private _adjustedChance = _baseChance;

             // Increase for flashbang
            _adjustedChance = _adjustedChance * 3;
            if(_surrenderDebug) then {
                format [
                    "Surrender chance increased by 300%% (flashbang). New chance: %1%%",
                    round(_adjustedChance * 100)
                ] spawn OKS_fnc_LogDebug;           
            };
            // Increase for few friendlies
            if (_numFriendlies < 10) then {
                private _inc = 0.025 * (10 - _numFriendlies);
                private _chanceInProcent = _inc * 100;
                _adjustedChance = _adjustedChance * (1 +_inc);
                if(_surrenderDebug) then {
                    format [
                        "Surrender chance increased by %1%% (few friendlies nearby: %2). New chance: %3%%",
                        round(_chanceInProcent), _numFriendlies, round(_adjustedChance * 100)
                    ] spawn OKS_fnc_LogDebug;
                };
            };

            // Increase for suppression
            private _suppression = getSuppression _unit;
            if (_suppression > 0.7) then {
                _adjustedChance = _adjustedChance * 1.2;
                if(_surrenderDebug) then {
                    format [
                        "Surrender chance increased by 20%% (suppression: %1). New chance: %2%%",
                        _suppression, (_adjustedChance * 100)
                    ] spawn OKS_fnc_LogDebug;;
                };
            };

            // Set to surrendered if unarmed.
            if(primaryWeapon _unit == "" && secondaryWeapon _unit == "" && handgunWeapon _unit == "") then {
                _adjustedChance = _adjustedChance * 1.5;
                if(_surrenderDebug) then {
                    format ["Unarmed increased chance by %1%%", round(_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
                };
            };

            _adjustedChance = _adjustedChance min 1;
            if(_surrenderDebug) then {
                format ["Final surrender chance: %1%%", round(_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
            };
            private _dice = random 1;
            if(_surrenderDebug) then {
                format ["Dice rolled: %1 %% (must be less than %2 %% to surrender)", round(_dice * 100), round(_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
            };
            if (_dice < _adjustedChance) then {
                if(_unit getVariable ["GOL_Surrender",false]) then {
                    [_unit] spawn OKS_fnc_SurrenderHandle;
                    private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];                     
                    if(_surrenderDebug) then {"Surrender triggered by flashbang!" spawn OKS_fnc_LogDebug;}
                }
            } else {
               if(_surrenderDebug) then { "Surrender not triggered by flashbang." spawn OKS_fnc_LogDebug; }
            };
        };
    }] call CBA_fnc_addEventHandler;
};


// Add FiredNear Event for Surrender.
_Unit addEventHandler ["Suppressed", {
    params ["_unit", "_distance", "_firer", "_instigator", "_ammoObject", "_ammoClassname", "_ammoConfig"];

    private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];
    private _cooldown = 3; // seconds
    private _lastCheck = _unit getVariable ["GOL_SurrenderCooldown", -_cooldown];
    if (CBA_missionTime - _lastCheck < _cooldown) exitWith {}; // Skip if still on cooldown
    if (_distance > 50) exitWith {}; // Skip if round is far from the unit.

    _unit setVariable ["GOL_SurrenderCooldown", CBA_missionTime];
    
    _nearFriendliesDistance = _Unit getVariable ["GOL_NearFriendliesDistance",200];
    private _nearbyFriendliesClose = (_unit nearEntities [["Man"], _nearFriendliesDistance * 0.5]) select {
        side (group _x) isEqualTo _side && alive _x && _x != _unit
    };

    if(count _nearbyFriendliesClose > 10) exitWith {}; // Skip if close to a lot of friendlies

    _surrenderDistance = _unit getVariable ["GOL_SurrenderDistance",50];
    if (isPlayer _firer && _distance < _surrenderDistance && vehicle _unit == _unit) then {
        private _baseChance = _unit getVariable ["GOL_ChanceSurrender", 0];
        private _side = side (group _unit);
        private _nearbyFriendlies = (_unit nearEntities [["Man"], _NearFriendliesDistance]) select {
            side (group _x) isEqualTo _side && alive _x && _x != _unit
        };
        private _numFriendlies = count _nearbyFriendlies;

        private _adjustedChance = _baseChance;
        if (_numFriendlies < 10) then {
            private _inc = 0.025 * (10 - _numFriendlies);
            _adjustedChance = _adjustedChance + _inc;
            if(_surrenderDebug) then {
                format [
                    "Surrender chance increased by %1 %% (few friendlies nearby: %2). New chance: %3%%",
                    round(_inc * 100), _numFriendlies, round(_adjustedChance * 100)
                ] spawn OKS_fnc_LogDebug;
            };
        };

        private _suppression = getSuppression _unit;
        if (_suppression > 0.7) then {
            _adjustedChance = _adjustedChance * 1.05;
            if(_surrenderDebug) then {
                format [
                    "Surrender chance increased by 5%% (suppression: %1). New chance: %2%%",
                    _suppression, round(_adjustedChance * 100)
                ] spawn OKS_fnc_LogDebug;
            };
        };

        // Set to surrendered if unarmed.
        if(primaryWeapon _unit == "" && secondaryWeapon _unit == "" && handgunWeapon _unit == "") then {
            _adjustedChance = _adjustedChance * 1.5;
            if(_surrenderDebug) then {
                format ["Unarmed increased chance by %1%%", round(_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
            };
        };

        _adjustedChance = _adjustedChance min 1; // Cap at 1 (100%)
        if(_surrenderDebug) then {
            format ["Final surrender chance: %1%%", round(_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
        };

        private _dice = random 1;
        if(_surrenderDebug) then {
            format ["Dice rolled: %1 %% (must be less than %2 %% to surrender)", round(_dice * 100), round(_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
        };

        if (_dice < _adjustedChance) then {
            if(_unit getVariable ["GOL_Surrender",false]) then {
                if(_surrenderDebug) then {
                    "Surrender triggered!" spawn OKS_fnc_LogDebug;
                };

                [_unit] spawn OKS_fnc_SurrenderHandle;
            };
            _unit removeAllEventHandlers "FiredNear";      
        } else {
            if(_surrenderDebug) then {
                "Surrender not triggered." spawn OKS_fnc_LogDebug;
            };
        };
    };
}];


if(_surrenderDebug) then {"Surrender Setup OK - Waiting for Nearby Player for Aim Threat" spawn OKS_fnc_LogDebug};
waitUntil {
    sleep 5 + (random 5);
    _NearPlayers = (_Unit nearEntities [["Man"], _DistanceWeaponAim]) select {isPlayer _X};
    count _NearPlayers > 0 || !Alive _Unit
};

if(!(_unit getVariable ["GOL_Surrender",true]) || !Alive _Unit) exitWith { if(_surrenderDebug) then { "Surrendered already or killed. Will not check player aiming." spawn OKS_fnc_LogDebug } };

private _interval = 0.5; // seconds
private _pfhId = [
    {
        params ["_args", "_pfhId"];
        _args params ["_unit", "_chance", "_distance"];
        private _threatTolerance = 100; // degrees
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

            if (_angleDeg < _threatTolerance) then {
                // Set to surrendered if unarmed.
                if(primaryWeapon _unit == "" && secondaryWeapon _unit == "" && handgunWeapon _unit == "") then {
                    _chance = 0.5;
                    if(_surrenderDebug) then { format ["Unarmed increased chance to %1%%", round(_chance * 100)] spawn OKS_fnc_LogDebug; };
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
                            if(_surrenderDebug) then { format ["Unit %1 surrendered to player %2", name _unit, name _player] spawn OKS_fnc_LogDebug; };
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
