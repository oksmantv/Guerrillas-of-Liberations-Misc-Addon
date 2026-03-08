/*
    OKS_fnc_EdenBuildingRestCamp

    Eden helper:
    - Creates a named game logic at the clicked position (near a building)
    - Copies a spawnList-ready call to OKS_fnc_BuildingRestCamp

    Usage from CfgEden:
      (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenBuildingRestCamp;
*/

private _args = _this;
if !(_args isEqualType []) then { _args = [_args]; };

_args params [
    ["_menuData", []],
    ["_sideStrOverride", ""],
    ["_maxUnitsOverride", -1],
    ["_garrisonRangeOverride", -1],
    ["_wakeModeOverride", ""]
];

if (_menuData isEqualType objNull) then {
    _menuData = [_menuData];
};

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

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

private _layer = ["Building RestCamp", "OKS Eden - Spawn Helpers"] call OKS_fnc_EdenGetOrCreateLayer;

private _createHelper = {
    params ["_namePrefix", "_pos"];
    private _p = [_pos] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith {""};
    private _obj = create3DENEntity ["Logic", "Logic", _p];
    if (isNull _obj) exitWith {""};
    if (!isNil "_layer") then { [_obj, _layer] call OKS_fnc_EdenSetLayerSafe; };
    private _n = [_namePrefix] call OKS_fnc_next3DENName;
    _obj set3DENAttribute ["name", _n];
    _obj set3DENAttribute ["hideObject", true];
    _n
};

private _ensureNamed = {
    params ["_obj", "_namePrefix"];
    private _n = (_obj get3DENAttribute "name") select 0;
    if (_n isEqualTo "") then {
        _n = [_namePrefix] call OKS_fnc_next3DENName;
        _obj set3DENAttribute ["name", _n];
    };
    _n
};

// ── Determine anchor position ──────────────────────────────────────────────
private _logicName = "";

private _p0 = [_selectedObjects, _menuData] call _anchorPos;
if (_p0 isEqualTo []) exitWith {
    if (_debug3DEN) then {
        [format ["[3DEN] BuildingRestCamp: invalid click position. menuData=%1", _menuData], false, true] call OKS_fnc_LogDebug;
    };
    ["Building RestCamp: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};
_p0 = [_p0] call OKS_fnc_EdenSanitizePos;
if (_p0 isEqualTo []) then { _p0 = [0, 0, 0]; };

// Re-use an existing selected Logic if present, otherwise create one
private _existingLogic = objNull;
{
    if (_x isKindOf "Logic") exitWith { _existingLogic = _x; };
} forEach _selectedObjects;

if (!isNull _existingLogic) then {
    _logicName = [_existingLogic, "BldgRestCamp"] call _ensureNamed;
    if (!isNil "_layer") then { [_existingLogic, _layer] call OKS_fnc_EdenSetLayerSafe; };
} else {
    _logicName = ["BldgRestCamp", _p0] call _createHelper;
};

if (_logicName isEqualTo "") exitWith {
    ["Building RestCamp: Failed to create helper logic", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

// ── Determine side ─────────────────────────────────────────────────────────
private _side = [_contextObjects] call _sideFromSelection;
private _sideStr = [_side] call _sideToString;

if !(_sideStrOverride isEqualTo "") then {
    _sideStr = _sideStrOverride;
};

// ── Max units ───────────────────────────────────────────────────────────────
private _maxUnits = 8;
if (_maxUnitsOverride isEqualType 0 && {_maxUnitsOverride > 0}) then {
    _maxUnits = _maxUnitsOverride;
};
// ── Garrison range ─────────────────────────────────────────────────────────
private _garrisonRange = 50;
if (_garrisonRangeOverride isEqualType 0 && {_garrisonRangeOverride >= 0}) then {
    _garrisonRange = _garrisonRangeOverride;
};
// ── Wake mode ───────────────────────────────────────────────────────────────
private _wakeMode = "GARRISON";
if !(_wakeModeOverride isEqualTo "") then {
    _wakeMode = toUpper _wakeModeOverride;
};// ── Build clipboard snippet ────────────────────────────────────────────────
private _example = format [
    "[%1,%2,%3,%4,[10,30],%5] spawn OKS_fnc_BuildingRestCamp;",
    _logicName,
    _sideStr,
    _maxUnits,
    _garrisonRange,
    str _wakeMode
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenBuildingRestCamp", [_sideStr, _maxUnits, _garrisonRange, _wakeMode], []] call OKS_fnc_EdenRememberLastAction;
systemChat format ["CopiedToClipboard | Building RestCamp (%1) copied to clipboard | Cache=%2", _wakeMode, _cacheCount];
[format ["CopiedToClipboard | Building RestCamp copied to clipboard | Cache=%1 | %2", _cacheCount, _example], false, true, true] call OKS_fnc_LogDebug;
[format ["Building RestCamp copied (%1, %2, %3m, max:%4) (helper: %5) | Cache=%6", _wakeMode, _sideStr, _garrisonRange, _maxUnits, _logicName, _cacheCount], 0, 10, true] call BIS_fnc_3DENNotification;

// Delete selected template objects (keep logics)
private _selectedToDelete = _selectedObjects select { !(_x isKindOf "Logic") };
if !(_selectedToDelete isEqualTo []) then {
    if (!(uiNamespace getVariable ["OKS_3DEN_IS_REPEAT", false])) then {
        delete3DENEntities _selectedToDelete;
    };
};

true
