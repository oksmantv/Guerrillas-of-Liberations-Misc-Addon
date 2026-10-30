/*
    Marks an alarm speaker as disabled.

    Usage:
    [_speaker] call OKS_fnc_Stealth_Alert_DisableAlarm;
*/

params [
    ["_speaker", objNull, [objNull]]
];

if (!isServer) exitWith { false };
if (isNull _speaker) exitWith { false };

_speaker setVariable ["OKS_Stealth_AlarmDisabled", true, true];
true