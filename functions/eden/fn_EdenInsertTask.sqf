/*
    OKS_fnc_EdenInsertTask

    3DEN helper:
    - Right-click terrain to create a named trigger LZ reference
    - Copies a spawnList-ready call to OKS_fnc_Insert_Task

    Notes:
    - The runtime function will (re)configure the trigger (radius/alt/timeout/condition).
*/

params ["_menuData"];

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

private _md = if (_menuData isEqualType []) then {_menuData} else {[]};

private _anchorPos = {
    params ["_md"];
    private _p = [];

    if (_md isEqualType []) then {
        _p = [_md] call OKS_fnc_EdenPosFromArray;
    };

    if (_p isEqualTo []) then {
        private _md0 = _md param [0, []];
        if (_md0 isEqualType []) then {
            _p = [_md0] call OKS_fnc_EdenPosFromArray;
        };
    };

    if (_p isEqualTo []) then { _p = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray; };
    _p set [2, 0];
    _p = [_p] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith {[]};
    _p
};

private _p0 = [_md] call _anchorPos;
if (_p0 isEqualTo []) exitWith {
    ["Insert Task: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _trg = create3DENEntity ["Trigger", "EmptyDetector", _p0];
if (isNull _trg) exitWith {
    ["Insert Task: Failed to create trigger", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _layer = ["Insert Task", "OKS Eden - Task Helpers"] call OKS_fnc_EdenGetOrCreateLayer;
if (!isNil "_layer") then { [_trg, _layer] call OKS_fnc_EdenSetLayerSafe; };

private _ensureNamed = {
    params ["_entity", "_namePrefix"];
    private _n = (_entity get3DENAttribute "name") select 0;
    if (_n isEqualTo "") then {
        _n = [_namePrefix] call OKS_fnc_next3DENName;
        _entity set3DENAttribute ["name", _n];
    };
    _n
};

private _trgName = [_trg, "InsertLZ"] call _ensureNamed;

// Make the trigger roughly correct visually in Eden.
_trg set3DENAttribute ["size3", [100, 100,25]];
_trg set3DENAttribute ["text", format["Insert Task: %1", _trgName]];
_trg set3DENAttribute ["activationBy", "ANYPLAYER"];
_trg set3DENAttribute ["activationType", "PRESENT"];
_trg set3DENAttribute ["repeatable", false];
_trg set3DENAttribute ["repeating", false];

private _example = format [
    "[%1] spawn OKS_fnc_Insert_Task;",
    _trgName
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenInsertTask", [], [_trg]] call OKS_fnc_EdenRememberLastAction;

private _logText = format ["CopiedToClipboard | Insert Task copied to clipboard | Cache=%1 | %2", _cacheCount, _example];
private _chatText = format ["CopiedToClipboard | Insert Task copied to clipboard | Cache=%1", _cacheCount];
systemChat _chatText;

private _logExample = _example splitString "\r\n" joinString " ";
_logText = format ["CopiedToClipboard | Insert Task copied to clipboard | Cache=%1 | %2", _cacheCount, _logExample];
[_logText, false, true, true] call OKS_fnc_LogDebug;
if (_debug3DEN) then {
    [format ["Insert Task | trigger=%1 pos=%2", _trgName, _p0], false, true, true] call OKS_fnc_LogDebug;
};

[format ["Insert Task copied to clipboard (trigger: %1) | Cache=%2", _trgName, _cacheCount], 0, 10, true] call BIS_fnc_3DENNotification;
true
