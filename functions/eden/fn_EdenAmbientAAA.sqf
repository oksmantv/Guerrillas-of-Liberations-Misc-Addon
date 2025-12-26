/*
    OKS_fnc_EdenAmbientAAA

    Eden helper:
    - Requires a selected/clicked AAA object
    - Ensures the AAA object has a unique variable name
    - Copies a spawnList-ready OKS_fnc_Ambient_AAA call to clipboard

    Usage from CfgEden:
      (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenAmbientAAA;
*/

params [
    "_menuData",
    ["_radar", true, [true]],
    ["_isHMG", false, [true]],
    ["_range", 1500, [0]]
];

private _md = if (_menuData isEqualType []) then {_menuData} else {[]};

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

    if (_p isEqualTo []) then { _p = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray; };
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

private _sideFromSelection = {
    params ["_objs"];
    private _s = sideUnknown;
    {
        if (_x isKindOf "Man") exitWith {_s = side _x};
        if (_x isKindOf "LandVehicle" || {_x isKindOf "Air"} || {_x isKindOf "Ship"}) exitWith {_s = side _x};
    } forEach _objs;
    if (_s isEqualTo sideUnknown) then {_s = east};
    _s
};

private _sideToString = {
    params ["_side"];
    if (_side isEqualTo west) exitWith {"west"};
    if (_side isEqualTo east) exitWith {"east"};
    if (_side isEqualTo independent) exitWith {"independent"};
    if (_side isEqualTo civilian) exitWith {"civilian"};
    "east"
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

private _createVehicleAt = {
    params ["_class", "_pos", "_namePrefix"];
    private _p = [_pos] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) then { _p = [0, 0, 0]; };
    _p set [2, 0];
    private _obj = create3DENEntity ["Object", _class, _p];
    if (isNull _obj) exitWith {[objNull, ""]};
    private _n = [_namePrefix] call OKS_fnc_next3DENName;
    _obj set3DENAttribute ["name", _n];
    [_obj, _n]
};

private _aaaObj = objNull;
{
    if (_x isKindOf "StaticWeapon" || {_x isKindOf "LandVehicle"}) exitWith { _aaaObj = _x; };
} forEach _contextObjects;

if (isNull _aaaObj) then {
    private _p0 = [_contextObjects, _md] call _anchorPos;
    if (_p0 isEqualTo []) exitWith {
        ["Ambient AAA: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
        false
    };
    private _created = ["RHS_Ural_Zu23_MSV_01", _p0, "AAA"] call _createVehicleAt;
    _aaaObj = _created select 0;
};

if (isNull _aaaObj) exitWith {
    ["Ambient AAA: Failed to create/select an AAA vehicle", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _aaaName = [_aaaObj, "AAA"] call _ensureNamed;
private _sideStr = [([_contextObjects] call _sideFromSelection)] call _sideToString;

private _isHMGStr = if (_isHMG) then {"true"} else {"false"};
private _radarStr = if (_radar) then {"true"} else {"false"};

private _example = format [
    "null = [%1,%2,%3,%4,%5] spawn OKS_fnc_Ambient_AAA;",
    _aaaName,
    _sideStr,
    _isHMGStr,
    _range,
    _radarStr
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);
// If the AAA has crew placed in Eden, remove them after copy.
private _crewToDelete = (crew _aaaObj) select { _x isKindOf "Man" };
private _crewDeleted = 0;
if !(_crewToDelete isEqualTo []) then {
    delete3DENEntities _crewToDelete;
    _crewDeleted = count _crewToDelete;
};

private _desc = format [
    "Ambient AAA copied: AAA=%1 | Side=%2 | Radar=%3 | isHMG=%4 | Range=%5",
    _aaaName,
    _sideStr,
    if (_radar) then {"ON"} else {"OFF"},
    if (_isHMG) then {"true"} else {"false"},
    _range
];

private _desc2 = if (_crewDeleted > 0) then {
    format ["%1 | DeletedCrew=%2", _desc, _crewDeleted]
} else {
    _desc
};

private _debug = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];
private _logText = if (_debug) then {
    format ["CopiedToClipboard: %1\n%2", _desc2, _example]
} else {
    format ["CopiedToClipboard: %1", _example]
};
[_logText, true] call OKS_fnc_LogDebug;

private _notify = if (_debug) then {_desc2} else {"Ambient AAA copied to clipboard"};
_notify = format ["%1 | Cache=%2", _notify, _cacheCount];
[_notify, 0, 5, true] call BIS_fnc_3DENNotification;
true;
