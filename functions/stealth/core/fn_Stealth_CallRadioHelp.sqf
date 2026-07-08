/*
    Plays side-profiled radio help call from a radio-capable friendly near caller.

    Usage:
    [_caller] call OKS_fnc_Stealth_CallRadioHelp;

    Returns:
    BOOL true when a help call was played.
*/

params [
    ["_caller", objNull, [objNull]],
    ["_requiresRadioToCall", true, [true]]
];

if (!isServer) exitWith { false };
if (isNull _caller || { !alive _caller }) exitWith { false };

[] call OKS_fnc_Stealth_Init;

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];
private _log = {
    params ["_message"];
    if (_debug) then {
        [format ["[Stealth.RadioHelp] %1", _message], false, false, true] spawn OKS_fnc_LogDebug;
    };
};

private _side = side group _caller;
private _helpBySide = missionNamespace getVariable ["GOL_Stealth_RadioHelpBySide", createHashMap];
private _helpSounds = _helpBySide getOrDefault [str _side, []];
if (_helpSounds isEqualTo []) exitWith {
    [format ["No help-radio sounds configured for side %1", _side]] call _log;
    false
};

private _radioData = [_caller] call OKS_fnc_Stealth_FindNearRadioMen;
_radioData params ["_radioNearby", "_nearFriendliesWithRadio"];

private _callerHasRadio = _caller getVariable ["GOL_HasRadio", false];
if (_requiresRadioToCall && !(_callerHasRadio || _radioNearby)) exitWith {
    ["Caller has no radio and no nearby radio units"] call _log;
    false
};

private _radioCaller = objNull;
if (_callerHasRadio) then {
    _radioCaller = _caller;
} else {
    if !(_nearFriendliesWithRadio isEqualTo []) then {
        private _sorted = [_nearFriendliesWithRadio, [], { _x distance _caller }, "ASCEND"] call BIS_fnc_sortBy;
        _radioCaller = _sorted select 0;
    };
};

if (isNull _radioCaller) exitWith {
    ["No valid radio caller found"] call _log;
    false
};

private _cooldown = missionNamespace getVariable ["GOL_Stealth_RadioHelpCooldown", 120];
private _now = serverTime;
private _lastCall = _radioCaller getVariable ["OKS_Stealth_RadioCalledAt", -1];
if (_lastCall >= 0 && { (_now - _lastCall) < _cooldown }) exitWith {
    [format ["Radio help cooldown active (%1s left)", round (_cooldown - (_now - _lastCall))]] call _log;
    false
};

private _soundPath = selectRandom _helpSounds;
playSound3D [_soundPath, _radioCaller, false, getPosASL _radioCaller, 2.5, 1, 80];
_radioCaller setVariable ["OKS_Stealth_RadioCalledAt", _now, true];

[format ["%1 called radio help using %2", _radioCaller, _soundPath]] call _log;

true
