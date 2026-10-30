/*
    Adds a multiplayer-safe hold action which disables an alarm speaker.

    Usage:
    [_speaker] call OKS_fnc_Stealth_Alert_AddDisableAlarmAction;
*/

params [
    ["_speaker", objNull, [objNull]],
    ["_title", "Disable Alarm", [""]],
    ["_duration", 5, [0]]
];

if (!isServer) exitWith { false };
if (isNull _speaker) exitWith { false };
if (_speaker getVariable ["OKS_Stealth_AlarmDisableActionAdded", false]) exitWith { false };

_duration = _duration max 0;
_speaker setVariable ["OKS_Stealth_AlarmDisabled", false, true];
_speaker setVariable ["OKS_Stealth_AlarmDisableActionAdded", true, true];

[
    _speaker,
    _title,
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",
    "_this distance _target < 3 && !(_target getVariable ['OKS_Stealth_AlarmDisabled', false])",
    "_caller distance _target < 3 && !(_target getVariable ['OKS_Stealth_AlarmDisabled', false])",
    {},
    {},
    {
        params ["_target"];
        [_target] remoteExecCall ["OKS_fnc_Stealth_Alert_DisableAlarm", 2];
    },
    {},
    [],
    _duration,
    0,
    true,
    false
] remoteExec ["BIS_fnc_holdActionAdd", 0, _speaker];

true