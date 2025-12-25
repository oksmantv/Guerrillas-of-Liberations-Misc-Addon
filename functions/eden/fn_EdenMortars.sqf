/*
    OKS_fnc_EdenMortars

    Eden helper:
    - Right-click to choose target position
    - If a mortar is selected/clicked, ensures it has a unique variable name
    - Creates a hidden target helper logic and names it
    - Copies a spawnList-ready OKS_fnc_Mortars call to clipboard

    Usage from CfgEden:
      (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenMortars;
*/

params [
    "_menuData",
    ["_platform", "auto", [""]],
    ["_targeting", "designated", [""]],
    ["_firingMode", "precise", [""]],
    ["_roundType", "light", [""]]
];

private _md = if (_menuData isEqualType []) then {_menuData} else {[]};

if (missionNamespace getVariable ["OKS_3DEN_DEBUG", false]) then {
    ["[3DEN] EdenMortars: action fired", 0, 2, true] call BIS_fnc_3DENNotification;
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
    _p set [2, 0];
    _p = [_p] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith {[]};
    _p
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

private _createHiddenLogic = {
    params ["_namePrefix", "_pos"];
    private _p = [_pos] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) then { _p = [0, 0, 0]; };
    _p set [2, 0];

    private _obj = create3DENEntity ["Logic", "Logic", _p];
    if (isNull _obj) exitWith {""};

    private _n = [_namePrefix] call OKS_fnc_next3DENName;
    _obj set3DENAttribute ["name", _n];
    _obj set3DENAttribute ["hideObject", true];
    _n
};

private _p0 = [_contextObjects, _md] call _anchorPos;
if (_p0 isEqualTo []) exitWith {
    (format ["Mortars: invalid click position. menuData=%1", _md]) call OKS_fnc_LogDebug;
    ["Mortars: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _mortarObj = objNull;
{
    if (_x isKindOf "StaticMortar" || {_x isKindOf "StaticWeapon"}) exitWith { _mortarObj = _x; };
} forEach _contextObjects;

private _sideStr = [([_contextObjects] call _sideFromSelection)] call _sideToString;

private _firingModeLower = toLower _firingMode;
private _roundTypeLower = toLower _roundType;
private _inaccuracy = 50;
private _minRange = 150;
private _maxRange = 400;
private _ammo = 20;

private _platformLower = toLower _platform;
private _targetingLower = toLower _targeting;

private _platformResolved = _platformLower;
if (_platformResolved == "auto") then {
    _platformResolved = if (isNull _mortarObj) then {"offmap"} else {"manned"};
};

private _requiresMortar = (_platformResolved == "manned");
if (_requiresMortar && {isNull _mortarObj}) exitWith {
    ["Mortars: Manned mode requires selecting/right-clicking a mortar", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _mortarArg = str "OffMap";
private _mortarName = "OffMap";

if (_platformResolved == "manned") then {
    _mortarName = [_mortarObj, "Mortar"] call _ensureNamed;
    _mortarArg = _mortarName;
};

private _posArg = "";
private _targetName = "";

if (_targetingLower == "auto") then {
    _posArg = str "auto";
} else {
    _targetName = ["MortarTarget", _p0] call _createHiddenLogic;
    if (_targetName isEqualTo "") exitWith {
        ["Mortars: Failed to create target helper", 1, 6, true] call BIS_fnc_3DENNotification;
        false
    };
    _posArg = format ["getPosATL %1", _targetName];
};

private _example = format [
    "null = [%1,%2,%3,%4,[%5,%6],%7,%8,%9] spawn OKS_fnc_Mortars;",
    _mortarArg,
    _sideStr,
    str _firingModeLower,
    str _roundTypeLower,
    _posArg,
    _inaccuracy,
    _minRange,
    _maxRange,
    _ammo
];

copyToClipboard _example;
private _targetDesc = if (_targetingLower == "auto") then {"AUTO"} else {format ["DESIGNATED (%1)", _targetName]};
private _platformDesc = if (_platformResolved == "offmap") then {"OFFMAP"} else {format ["MANNED (%1)", _mortarName]};

private _desc = format [
    "Mortars copied: %1 | %2 | Mode=%3 | Round=%4 | Side=%5 | Inacc=%6 | Ammo=%7",
    _platformDesc,
    _targetDesc,
    _firingModeLower,
    _roundTypeLower,
    _sideStr,
    _inaccuracy,
    _ammo
];

[format ["CopiedToClipboard: %1\n%2", _desc, _example], true] call OKS_fnc_LogDebug;
[_desc, 0, 5, true] call BIS_fnc_3DENNotification;
true;
