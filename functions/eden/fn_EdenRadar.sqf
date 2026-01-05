/*
    OKS_fnc_EdenRadar

    Eden helper for OKS_fnc_Radar.
    - Requires a selected/clicked radar vehicle/object (validation)
    - Uses other selected vehicles as AAA template classnames (optional)
    - Copies a spawnList-ready OKS_fnc_Radar call to clipboard

    Usage from CfgEden:
      (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenRadar;
*/

private _args = _this;
if !(_args isEqualType []) then { _args = [_args]; };

_args params [
    ["_menuData", [], [[], objNull]],
    ["_shareDistance", 2000, [0]],
    ["_maxRangeAAA", 2500, [0]],
    ["_minimumAltitude", 100, [0]],
    ["_aaaClassnamesOverride", [], [[]]]
];

if (_menuData isEqualType objNull) then {
    _menuData = [_menuData];
};

private _md = if (_menuData isEqualType []) then {_menuData} else {[]};

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

private _anchorPos = {
    params ["_objs", "_md"];
    private _p = [];

    if (_md isEqualType []) then {
        _p = [_md] call OKS_fnc_EdenPosFromArray;
    };

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

    if (_p isEqualTo []) then { _p = [screenToWorld getMousePosition] call OKS_fnc_EdenPosFromArray; };
    _p set [2, 0];
    _p = [_p] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith {[]};
    _p
};

private _selectedObjects = get3DENSelected "object";

// Some Eden context menus pass a clicked entity even when not selected.
private _md0 = _md param [0, objNull];
private _clickedObj = if (_md0 isEqualType objNull && {!isNull _md0}) then {_md0} else {objNull};
private _contextObjects = +_selectedObjects;
if (!isNull _clickedObj && { !(_clickedObj in _contextObjects) }) then {
    _contextObjects pushBack _clickedObj;
};

private _ensureNamed = {
    params ["_entity", "_namePrefix"];
    private _n = (_entity get3DENAttribute "name") select 0;
    if (_n isEqualTo "") then {
        _n = [_namePrefix] call OKS_fnc_next3DENName;
        _entity set3DENAttribute ["name", _n];
    };
    _n
};

private _layer = ["Radar", "OKS Eden - Support Helpers"] call OKS_fnc_EdenGetOrCreateLayer;

private _createVehicleAt = {
    params ["_class", "_pos", "_namePrefix"];
    private _p = [_pos] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) then { _p = [0, 0, 0]; };
    _p set [2, 0];
    private _obj = create3DENEntity ["Object", _class, _p];
    if (isNull _obj) exitWith {[objNull, ""]};
	if (!isNil "_layer") then { [_obj, _layer] call OKS_fnc_EdenSetLayerSafe; };
    private _n = [_namePrefix] call OKS_fnc_next3DENName;
    _obj set3DENAttribute ["name", _n];
    [_obj, _n]
};

// Find a selected radar by radarType==2; if none is selected, spawn a default radar at the click position.
private _radarObj = objNull;
{
    if (_x isKindOf "AllVehicles") then {
        private _rt = getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "radarType");
        if (_rt isEqualTo 2) exitWith { _radarObj = _x; };
    };
} forEach _contextObjects;

if (isNull _radarObj) then {
    private _p0 = [_contextObjects, _md] call _anchorPos;
    if (_p0 isEqualTo []) exitWith {
        ["Radar Share: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
        false
    };
    private _created = ["O_Radar_System_02_F", _p0, "Radar"] call _createVehicleAt;
    _radarObj = _created select 0;
};

if (isNull _radarObj) exitWith {
    ["Radar Share: Failed to create/select a radar", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _radarName = [_radarObj, "Radar"] call _ensureNamed;

// AAA templates: any other selected vehicles become classnames.
private _aaaClassnames = [];
{
    if (_x isNotEqualTo _radarObj && {_x isKindOf "AllVehicles"}) then {
        _aaaClassnames pushBackUnique (typeOf _x);
    };
} forEach _contextObjects;

// If none selected, keep a clear placeholder so the user sees it.
if (_aaaClassnames isEqualTo []) then {
    _aaaClassnames = ["rhsgref_ins_zsu234"]; // placeholder from script header
};

if !(_aaaClassnamesOverride isEqualTo []) then {
    _aaaClassnames = _aaaClassnamesOverride;
};

private _classArrayStr = str _aaaClassnames;

private _example = format [
    "null = [%1,%2,%3,%4,%5] spawn OKS_fnc_Radar;",
    _radarName,
    _classArrayStr,
    _shareDistance,
    _maxRangeAAA,
    _minimumAltitude
];

private _rangeDesc = if (_shareDistance isEqualTo _maxRangeAAA) then {
    format ["Range=%1", _shareDistance]
} else {
    format ["Share=%1 | MaxAAA=%2", _shareDistance, _maxRangeAAA]
};

private _desc = format [
    "Radar Share copied to clipboard: Radar=%1 | AAA Classes=%2 | %3 | MinAlt=%4",
    _radarName,
    _classArrayStr,
    _rangeDesc,
    _minimumAltitude
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenRadar", [_shareDistance, _maxRangeAAA, _minimumAltitude, _aaaClassnames], []] call OKS_fnc_EdenRememberLastAction;
private _chatText = format ["CopiedToClipboard | Radar Share copied to clipboard | Cache=%1", _cacheCount];
systemChat _chatText;

private _logExample = _example splitString "\r\n" joinString " ";
private _logText = format ["CopiedToClipboard | Radar Share copied to clipboard | Cache=%1 | %2", _cacheCount, _logExample];
[_logText, false, true, true] call OKS_fnc_LogDebug;
if (_debug3DEN) then {
    [format ["Radar Share | %1", _desc], false, true, true] call OKS_fnc_LogDebug;
};

private _notify = if (_debug3DEN) then {_desc} else {"Radar Share copied to clipboard"};
_notify = format ["%1 | Cache=%2", _notify, _cacheCount];
[_notify, 0, 10, true] call BIS_fnc_3DENNotification;
true;
