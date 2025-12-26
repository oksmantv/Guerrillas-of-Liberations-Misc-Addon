/*
    OKS_fnc_EdenHostageTask
    _this: BIS_fnc_3DENEntityMenu_data from Eden context menu
*/

params ["_menuData"];

private _fnc_sanitizePos0 = {
    params ["_pos"];
    private _p = [_pos] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith {[]};
    _p set [2, 0];
    _p
};

private _anchorPos = {
    params ["_objs", "_md"];
    private _p = [];

    // Some Eden contexts pass menuData as [x,y,z] directly.
    if (_md isEqualType []) then {
        _p = [_md] call OKS_fnc_EdenPosFromArray;
    };

    // Other contexts pass menuData as [[x,y,z], <entity>, ...] or [<entity>, ...].
    if (_p isEqualTo []) then {
        private _md0 = _md param [0, []];
        if (_md0 isEqualType objNull) then {
            if (!isNull _md0) then { _p = getPosATL _md0; };
        } else {
            if (_md0 isEqualType []) then { _p = [_md0] call OKS_fnc_EdenPosFromArray; };
        };
    };

    if (_p isEqualTo [] && {!(_objs isEqualTo [])}) then {
        _p = getPosATL (_objs select 0);
    };

    if (_p isEqualTo []) then { _p = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray; };
    _p = [_p] call _fnc_sanitizePos0;
    if (_p isEqualTo []) exitWith {[]};
    _p
};

private _selected = get3DENSelected "object";
private _men = _selected select { _x isKindOf "Man" };
private _p0 = [_selected, _menuData] call _anchorPos;
if (_p0 isEqualTo []) then { _p0 = [0, 0, 0]; };

{
    private _init = (_x get3DENAttribute "init") select 0;
    private _needle = 'this disableAI "MOVE";';
    if (_init isEqualTo "") then {
        _init = _needle;
    } else {
        if ((_init find _needle) == -1) then {
            _init = _init + " " + _needle;
        };
    };
    _x set3DENAttribute ["init", _init];
} forEach _men;

private _hostageNames = [];
{
    private _n = (_x get3DENAttribute "name") select 0;
    if (_n isEqualTo "") then {
        _n = ["hostage"] call OKS_fnc_next3DENName;
        _x set3DENAttribute ["name", _n];
    };
    _hostageNames pushBack _n;
} forEach _men;

private _example = "";

if (_men isEqualTo []) then {
    // Default: create 3 civilians at click position.
    private _dir = 0;
    private _firstName = ["hostage"] call OKS_fnc_next3DENName;
    private _firstUnit = create3DENEntity ["Object", "C_man_1", (_p0 getPos [0, 0])];
    _firstUnit set3DENAttribute ["name", _firstName];
    _firstUnit set3DENAttribute ["init", 'this disableAI "MOVE";'];
    private _grp = group _firstUnit;

    _dir = _dir + 45;
    for "_i" from 2 to 3 do {
        private _unitName = ["hostage"] call OKS_fnc_next3DENName;
        private _unit = _grp create3DENEntity ["Object", "C_man_1", (_p0 getPos [3, _dir])];
        _unit set3DENAttribute ["name", _unitName];
        _unit set3DENAttribute ["presence", 1];
        _unit set3DENAttribute ["init", 'this disableAI "MOVE";'];
        _dir = _dir + 45;
    };

    ["No unit selected: created example hostage group (3 civilians)", 0, 5, true] call BIS_fnc_3DENNotification;
    _example = format ["[group %1] spawn OKS_fnc_Hostage;", _firstName];
} else {
    private _groups = [];
    { _groups pushBackUnique (group _x); } forEach _men;
    _groups = _groups select { !isNull _x };

    if ((count _groups) == 1) then {
        // Preferred: run on group (function supports GROUP).
        _example = format ["[group %1] spawn OKS_fnc_Hostage;", _hostageNames select 0];
    } else {
        // Mixed groups: run on array (function supports ARRAY).
        _example = format ["[[%1]] spawn OKS_fnc_Hostage;", _hostageNames joinString ", "];
    };
};
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

private _notify = if (_debug) then {"Hostage Task copied"} else {"Hostage Task copied to clipboard"};
_notify = format ["%1 | Cache=%2", _notify, _cacheCount];
[_notify, 0, 4, true] call BIS_fnc_3DENNotification;

true