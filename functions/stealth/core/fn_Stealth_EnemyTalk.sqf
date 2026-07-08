/*
    Enemy proximity talk/chatter for a group.

    Usage:
    [_group] spawn OKS_fnc_Stealth_EnemyTalk;
*/

params [
    ["_group", grpNull, [grpNull]],
    ["_distance", 125, [0]],
    ["_chance", 1, [0]],
    ["_minMaxDelayBetweenTalks", [9, 14], [[]]],
    ["_loopDelayToCheckNearby", 5, [0]],
    ["_shouldTalkAsStaticUnits", true, [true]]
];

if (!isServer) exitWith { false };
if (isNull _group) exitWith { false };

[] call OKS_fnc_Stealth_Init;

private _talkBySide = missionNamespace getVariable ["GOL_Stealth_TalkCalmBySide", createHashMap];
private _groupSide = side _group;
private _talkSounds = _talkBySide getOrDefault [str _groupSide, []];

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];
private _log = {
    params ["_message"];
    if (_debug) then {
        [format ["[Stealth.Talk] %1", _message], false, false, true] spawn OKS_fnc_LogDebug;
    };
};

private _canSpeak = {
    params ["_group", "_distance", "_shouldTalkAsStaticUnits"];

    if (isNull _group) exitWith { false };
    if ({ alive _x } count units _group == 0) exitWith { false };
    if (_group getVariable ["GOL_IsStatic", false] && !(_shouldTalkAsStaticUnits)) exitWith { false };
    if ({ behaviour _x == "COMBAT" } count units _group > 0) exitWith { false };
    if (_group getVariable ["OKS_Talking_Currently", false]) exitWith { false };

    ({
        private _unit = _x;
        allPlayers findIf { alive _x && { _unit distance _x < _distance } } != -1
    } count (units _group)) > 0
};

while { !isNull _group && { { alive _x } count units _group > 0 } } do {
    private _inCombat = ({ behaviour _x == "COMBAT" } count units _group) > 0;
    if (_inCombat) then {
        if !(_group getVariable ["OKS_Stealth_ReactionFired", false]) then {
            private _awakeUnits = units _group select {
                alive _x && { isNil "ace_common_fnc_isAwake" || { [_x] call ace_common_fnc_isAwake } }
            };
            if !(_awakeUnits isEqualTo []) then {
                private _reactor = selectRandom _awakeUnits;
                [_reactor, true, true, true] call OKS_fnc_Stealth_SentryAlert;
            };
            _group setVariable ["OKS_Stealth_ReactionFired", true, true];
        };
        sleep _loopDelayToCheckNearby;
        continue;
    } else {
        _group setVariable ["OKS_Stealth_ReactionFired", false, true];
    };

    if !([_group, _distance, _shouldTalkAsStaticUnits] call _canSpeak) then {
        sleep _loopDelayToCheckNearby;
        continue;
    };

    private _pairs = [];
    {
        private _enemy = _x;
        if (!alive _enemy) then { continue; };

        private _nearPlayers = allPlayers select { alive _x && { _enemy distance _x <= _distance } };
        {
            _pairs pushBack [_x, _enemy, _x distance _enemy];
        } forEach _nearPlayers;
    } forEach units _group;

    if (_pairs isEqualTo []) then {
        sleep _loopDelayToCheckNearby;
        continue;
    };

    private _selected = ([_pairs, [], { _x select 2 }, "ASCEND"] call BIS_fnc_sortBy) select 0;
    _selected params ["_player", "_enemy", "_enemyDistance"];

    private _dice = random 1;
    if (_dice <= _chance) then {
        _group setVariable ["OKS_Talking_Currently", true, true];

        if (_talkSounds isEqualType [] && { count _talkSounds > 0 }) then {
            private _soundPath = selectRandom _talkSounds;
            private _soundRange = if (_enemyDistance > 50) then { 150 } else { 100 };
            private _volume = if (_enemyDistance > 50) then { 5 } else { 2.5 };
            playSound3D [_soundPath, _enemy, false, getPosASL _enemy, _volume, 1, _soundRange];
            [format ["Group %1 spoke near %2 with %3", _group, _player, _soundPath]] call _log;
        } else {
            [format ["No talk sounds configured for side %1", _groupSide]] call _log;
        };

        _minMaxDelayBetweenTalks params ["_min", "_max"];
        private _delay = _min + random (_max - _min);
        sleep _delay;

        _group setVariable ["OKS_Talking_Currently", false, true];
    };

    sleep _loopDelayToCheckNearby;
};

true
