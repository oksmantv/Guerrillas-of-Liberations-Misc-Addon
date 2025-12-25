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

private _selectedObjects = get3DENSelected "object";

// Some Eden context menus pass a clicked entity even when not selected.
private _md0 = _menuData param [0, objNull];
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

private _aaaObj = objNull;
{
    if (_x isKindOf "StaticWeapon" || {_x isKindOf "LandVehicle"}) exitWith { _aaaObj = _x; };
} forEach _contextObjects;

if (isNull _aaaObj) exitWith {
    ["Ambient AAA: Select (or right-click) the AAA object first", 1, 6, true] call BIS_fnc_3DENNotification;
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
private _desc = format [
    "Ambient AAA copied: AAA=%1 | Side=%2 | Radar=%3 | isHMG=%4 | Range=%5",
    _aaaName,
    _sideStr,
    if (_radar) then {"ON"} else {"OFF"},
    if (_isHMG) then {"true"} else {"false"},
    _range
];

[format ["CopiedToClipboard: %1\n%2", _desc, _example], true] call OKS_fnc_LogDebug;
[_desc, 0, 5, true] call BIS_fnc_3DENNotification;
true;
