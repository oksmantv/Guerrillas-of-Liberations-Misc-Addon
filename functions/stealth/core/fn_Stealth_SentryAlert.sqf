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

if !(_reactionSounds isEqualTo []) then {
    private _soundPath = selectRandom _reactionSounds;
    playSound3D [_soundPath, _unit, false, getPosASL _unit, 5, 1, 120];
    [format ["Reaction sound played: %1", _soundPath]] call _log;
};

if (_setCombat) then {
    _unit setBehaviour "COMBAT";
    _unit setCombatMode "RED";
};

if (_callRadioHelp) then {
    [_unit, _requiresRadioToCall] call OKS_fnc_Stealth_CallRadioHelp;
};

true
