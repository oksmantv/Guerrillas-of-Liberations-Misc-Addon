/*
    OKS_fnc_EdenDestroyTask
*/

// Copy example code to clipboard
private _selected = get3DENSelected "object";
private _objectNames = [];

if (_selected isEqualTo []) exitWith {
    ["Select an object to create a Destroy Task for.", 1, 5, true] call BIS_fnc_3DENNotification;
    false
};

{
    private _nameAttr = (_x get3DENAttribute "name") select 0;
    if (_nameAttr isEqualTo "") then {
        // Assign a new unique name using your function
        private _newName = ["DestroyObject"] call OKS_fnc_next3DENName;
        _x set3DENAttribute ["name", _newName];
        _objectNames pushBack _newName;
    } else {
        _objectNames pushBack _nameAttr;
    };
} forEach _selected;

private _objectNamesStr = _objectNames joinString ",";
private _example = format [
    "[[%1]] spawn OKS_fnc_Destroy_Task;",
    _objectNamesStr
];
copyToClipboard _example;

[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

private _debug = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];
private _logText = if (_debug) then {
    format ["CopiedToClipboard: %1", _example]
} else {
    format ["CopiedToClipboard: %1", _example]
};
[_logText, true] call OKS_fnc_LogDebug;

private _notify = if (_debug) then {"Destroy Task copied"} else {"Destroy Task copied to clipboard"};
_notify = format ["%1 | Cache=%2", _notify, _cacheCount];
[_notify, 0, 4, true] call BIS_fnc_3DENNotification;

true