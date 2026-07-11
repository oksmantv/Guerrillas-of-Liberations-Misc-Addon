/*
    Plays a sentry reaction yell and optionally triggers a radio help call.

    Usage:
    [_unit] call OKS_fnc_Stealth_SentryAlert;
*/

params [
    ["_unit", objNull, [objNull]],
    ["_callRadioHelp", true, [true]],
    ["_requiresRadioToCall", true, [true]],
    ["_setCombat", true, [true]]
];

if (!isServer) exitWith { false };
if (isNull _unit || { !alive _unit }) exitWith { false };

if (!isNil "ace_common_fnc_isAwake" && { !([_unit] call ace_common_fnc_isAwake) }) exitWith { false };

[] call OKS_fnc_Stealth_Init;

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];
private _log = {
    params ["_message"];
    if (_debug) then {
        [format ["[Stealth.SentryAlert] %1", _message], false, false, true] spawn OKS_fnc_LogDebug;
    };
};

private _side = side group _unit;
private _reactionBySide = missionNamespace getVariable ["GOL_Stealth_TalkReactionBySide", createHashMap];
private _reactionSounds = _reactionBySide getOrDefault [str _side, []];

private _nearestPlayerDistance = 125;
{
    if (alive _x) then {
        private _distanceToPlayer = _unit distance _x;
        if (_distanceToPlayer < _nearestPlayerDistance) then {
            _nearestPlayerDistance = _distanceToPlayer;
        };
    };
} forEach allPlayers;

if !(_reactionSounds isEqualTo []) then {
    private _soundPath = selectRandom _reactionSounds;
    private _soundRange = 200;
    private _volume = 5;
    playSound3D [_soundPath, _unit, false, getPosASL _unit, _volume, 1, _soundRange];
    [format ["Voice line used: %1", _soundPath]] call _log;
};

if (_setCombat) then {
    _unit setBehaviour "COMBAT";
    _unit setCombatMode "RED";
};

if (_callRadioHelp) then {
    [_unit, _requiresRadioToCall] call OKS_fnc_Stealth_CallRadioHelp;
};

true
