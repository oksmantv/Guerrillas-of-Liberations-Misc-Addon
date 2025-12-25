/*
    OKS_fnc_EdenRadar

    Eden helper for OKS_fnc_Radar.
    - Requires a selected/clicked radar vehicle/object (validation)
    - Uses other selected vehicles as AAA template classnames (optional)
    - Copies a spawnList-ready OKS_fnc_Radar call to clipboard

    Usage from CfgEden:
      (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenRadar;
*/

params [
    "_menuData",
    ["_shareDistance", 2000, [0]],
    ["_maxRangeAAA", 2500, [0]],
    ["_minimumAltitude", 100, [0]]
];

private _selectedObjects = get3DENSelected "object";

// Some Eden context menus pass a clicked entity even when not selected.
private _md0 = _menuData param [0, objNull];
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

// Must select a radar object/vehicle.
private _radarObj = objNull;
{
    // Most radar assets are vehicles (AllVehicles). Using a broad check keeps it flexible.
    if (_x isKindOf "AllVehicles") exitWith { _radarObj = _x; };
} forEach _contextObjects;

if (isNull _radarObj) exitWith {
    ["Radar Share: You must select a radar vehicle/object", 1, 6, true] call BIS_fnc_3DENNotification;
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

private _classQuoted = _aaaClassnames apply { format ["\"%1\"", _x] };
private _classArrayStr = format ["[%1]", _classQuoted joinString ","]; 

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
    "Radar Share copied: Radar=%1 | AAA Classes=%2 | %3 | MinAlt=%4",
    _radarName,
    _classArrayStr,
    _rangeDesc,
    _minimumAltitude
];

copyToClipboard _example;
[format ["CopiedToClipboard: %1\n%2", _desc, _example], true] call OKS_fnc_LogDebug;
[_desc, 0, 5, true] call BIS_fnc_3DENNotification;
true;
