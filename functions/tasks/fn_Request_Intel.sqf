/*
    OKS_fnc_Request_Intel

    Adds a "Request Intel" action to an object.

    Legacy script:
        [this,"This information is intel","photo.jpeg"] execVM "Scripts\OKS_TASK\OKS_Request_Intel\OKS_Request_Intel.sqf";

    Params:
        0: OBJECT (required) intel giver
        1: STRING (required) intel text
        2: STRING (optional) intel image path (for ACE photo intel)

    Notes:
        - addAction is local, so on dedicated server this function will remoteExec to clients (JIP).
        - ACE Intel Items required for the intel items.
*/

params [
    ["_giver", objNull, [objNull]],
    ["_intelText", "", [""]],
    ["_intelImagePath", "", [""]]
];

if (isNull _giver) exitWith { false };
if (_intelText isEqualTo "") exitWith { false };

// Ensure action exists on clients. Dedicated server has no interface.
if (isServer && {!hasInterface}) exitWith {
    [_giver, _intelText, _intelImagePath] remoteExecCall ["OKS_fnc_Request_Intel", 0, true];
    true
};

if (!hasInterface) exitWith { true };

private _actionTitle = "<t color='#ebe834'>Request Intel</t>";

_giver addAction [
    _actionTitle,
    {
        params ["_target", "_caller", "_actionId", "_args"];
        _args params ["_intelText", "_intelImagePath"];

        // Prefer adding intel on the caller's machine.
        if (!isNil "ace_intelitems_fnc_addIntel") then {
            [_caller, "acex_intelitems_document", _intelText] remoteExecCall ["ace_intelitems_fnc_addIntel", 2];
            systemChat "You have been given a document..";

            if !(_intelImagePath isEqualTo "") then {
                [_caller, "acex_intelitems_photo", _intelImagePath] remoteExecCall ["ace_intelitems_fnc_addIntel", 2];
                systemChat "You have been given a photograph..";
            };
        } else {
            systemChat "ACE Intel Items not available (ace_intelitems_fnc_addIntel missing).";
        };

        private _line = "I have given you all that I can, I hope that helps you.";
        if (!isNil "OKS_fnc_Chat") then {
            [_target, "local", _line] remoteExec ["OKS_fnc_Chat", 0];
        } else {
            if (!isNil "OKS_Chat") then {
                [_target, "local", _line] remoteExec ["OKS_Chat", 0];
            };
        };
    },
    [_intelText, _intelImagePath],
    1,
    true,
    true,
    "",
    "_this distance _target < 8",
    15,
    false,
    "",
    ""
];

true
