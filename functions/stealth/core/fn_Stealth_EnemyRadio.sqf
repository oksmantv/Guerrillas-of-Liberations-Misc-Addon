/*
    Enemy radio chatter from dead enemy units near players.

    Usage:
    [east] spawn OKS_fnc_Stealth_EnemyRadio;

    Params:
    0: SIDE  Enemy faction side.
    1: NUMBER  Trigger distance to players. Default: 15
    2: NUMBER  Radio hearing range. Default: 30
    3: NUMBER  Delay between transmissions (seconds). Default: 60
    4: NUMBER  Corpse cleanup distance from all players. Default: 300
    5: NUMBER  Knowledge threshold (0-4). Default: 2.5
*/

params [
    ["_enemyFaction", east],
    ["_triggerDistance", 15, [0]],
    ["_radioRange", 30, [0]],
    ["_cooldown", 60, [0]],
    ["_cleanupDistance", 300, [0]],
    ["_knowledgeThreshold", 2.5, [0]]
];

if (!isServer) exitWith { false };
if ((typeName _enemyFaction) != "SIDE") exitWith { false };

[] call OKS_fnc_Stealth_Init;

private _radioBySide = missionNamespace getVariable ["GOL_Stealth_RadioPatrolBySide", createHashMap];
private _radioSounds = _radioBySide getOrDefault [str _enemyFaction, []];

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];
private _log = {
    params ["_message", ["_force", false, [false]]];
    if (_debug || _force) then {
        [format ["[Stealth.Radio] %1", _message], false, false, true] spawn OKS_fnc_LogDebug;
    };
};

private _isEnemyCorpse = {
    params ["_unit", "_side"];
    (!isNull _unit)
    && { !alive _unit }
    && { !isPlayer _unit }
    && { _unit isKindOf "Man" }
    && { side group _unit == _side }
};

private _enemyKnowsPlayers = {
    params ["_side", "_threshold"];

    private _players = allPlayers select { alive _x };
    if (_players isEqualTo []) exitWith { false };

    private _enemyUnits = allUnits select {
        alive _x
        && { !isPlayer _x }
        && { side group _x == _side }
    };

    if (_enemyUnits isEqualTo []) exitWith { false };

    _enemyUnits findIf {
        private _enemy = _x;
        _players findIf { _enemy knowsAbout _x > _threshold } != -1
    } != -1
};

private _nearestPlayerDistanceForCorpse = {
    params ["_corpse"];

    private _nearestDistance = 125;
    {
        if (alive _x) then {
            private _distanceToPlayer = _corpse distance _x;
            if (_distanceToPlayer < _nearestDistance) then {
                _nearestDistance = _distanceToPlayer;
            };
        };
    } forEach allPlayers;

    _nearestDistance
};

while { true } do {
    private _allDead = allDeadMen;
    private _enemyCorpses = _allDead select { [_x, _enemyFaction] call _isEnemyCorpse };

    {
        private _corpse = _x;

        if (isNull _corpse) then {
            continue;
        };

        if (!(_corpse getVariable ["OKS_Stealth_RadioLoop", false])) then {
            _corpse setVariable ["OKS_Stealth_RadioLoop", true, true];

            [_corpse, _enemyFaction, _triggerDistance, _radioRange, _cooldown, _cleanupDistance, _knowledgeThreshold, _isEnemyCorpse, _enemyKnowsPlayers, _log, _radioSounds] spawn {
                params ["_corpse", "_enemyFaction", "_triggerDistance", "_radioRange", "_cooldown", "_cleanupDistance", "_knowledgeThreshold", "_isEnemyCorpse", "_enemyKnowsPlayers", "_log", "_radioSounds"];

                while { !isNull _corpse } do {
                    if !([_corpse, _enemyFaction] call _isEnemyCorpse) exitWith {};

                    private _nearPlayers = allPlayers select { alive _x && { _corpse distance _x < _triggerDistance } };
                    if (_nearPlayers isEqualTo []) then {
                        if ({ _corpse distance _x < _cleanupDistance } count allPlayers == 0) then {
                            deleteVehicle _corpse;
                            break;
                        };
                        sleep 8;
                        continue;
                    };

                    private _transmittingNearby = (allDeadMen select {
                        _x getVariable ["OKS_Transmit_Currently", false]
                        && { _corpse distance _x < _radioRange }
                    });

                    private _enemyAware = [_enemyFaction, _knowledgeThreshold] call _enemyKnowsPlayers;

                    if ((_transmittingNearby isEqualTo []) && _enemyAware) then {
                        _corpse setVariable ["OKS_Transmit_Currently", true, true];

                        if (_radioSounds isEqualType [] && { count _radioSounds > 0 }) then {
                            private _soundPath = selectRandom _radioSounds;
                            private _soundRange = 200;
                            private _volume = 5;
                            playSound3D [_soundPath, _corpse, false, getPosASL _corpse, _volume, 1, _soundRange];
                            [format ["Voice line used: %1", _soundPath]] call _log;
                        } else {
                            [format ["No radio sounds configured for side %1", _enemyFaction]] call _log;
                        };

                        if ((OKS_Radios find _corpse) == -1) then {
                            OKS_Radios pushBack _corpse;
                        };

                        sleep (5 + random 5);
                        _corpse setVariable ["OKS_Transmit_Currently", false, true];
                        sleep _cooldown;
                    } else {
                        sleep 8;
                    };
                };

                _corpse setVariable ["OKS_Stealth_RadioLoop", false, true];
                _corpse setVariable ["OKS_Transmit_Currently", false, true];
                OKS_Radios deleteAt (OKS_Radios find _corpse);
            };
        };
    } forEach _enemyCorpses;

    sleep 6;
};
