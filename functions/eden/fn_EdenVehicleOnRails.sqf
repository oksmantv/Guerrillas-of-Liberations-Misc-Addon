/*
    OKS_fnc_EdenVehicleOnRails

    Eden helper:
    - Ensures a Spawn Logic + at least 2 waypoint Logics (WP + End) exist and are named
    - Infers vehicle classname + side from editor selection (fallbacks to defaults)
    - Copies a spawnList-ready call to OKS_fnc_RailVehicle_Spawn
    - Caches snippet and remembers last action for OKS_fnc_EdenRepeatLastAction

    Usage from CfgEden:
      (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenVehicleOnRails;
*/

private _args = _this;
if !(_args isEqualType []) then { _args = [_args]; };

private _menuData = _args param [0, []];
private _vehicleClassOverride = _args param [1, ""]; // optional
private _sideStrOverride = _args param [2, ""];      // optional

if (_menuData isEqualType objNull) then {
    _menuData = [_menuData];
};
if !(_menuData isEqualType []) then { _menuData = []; };
if !(_vehicleClassOverride isEqualType "") then { _vehicleClassOverride = ""; };
if !(_sideStrOverride isEqualType "") then { _sideStrOverride = ""; };

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

    // If user has any selection, use the first as a reliable origin.
    if (_p isEqualTo [] && {!(_objs isEqualTo [])}) then {
        _p = getPosATL (_objs select 0);
    };

    if (_p isEqualTo []) then { _p = [screenToWorld getMousePosition] call OKS_fnc_EdenPosFromArray; };
    _p set [2, 0];
    _p = [_p] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith {[]};
    _p
};

private _offsetPos = {
    params ["_pos", "_dist", "_dirDeg"];
    private _p = [
        (_pos select 0) + (sin _dirDeg) * _dist,
        (_pos select 1) + (cos _dirDeg) * _dist,
        (_pos select 2)
    ];
    [_p] call OKS_fnc_EdenSanitizePos
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

private _layer = ["Vehicle On Rails", "OKS Eden - Spawn Helpers"] call OKS_fnc_EdenGetOrCreateLayer;

// Only treat Logic entities as helper anchors.
private _selectedHelpers = _selectedObjects select { _x isKindOf "Logic" };

private _spawnObj = objNull;
private _wpObjs = [];
private _createdHelpers = [];

if ((count _selectedHelpers) >= 2) then {
    _spawnObj = _selectedHelpers select 0;
    _wpObjs = _selectedHelpers select [1, (count _selectedHelpers) - 1];
} else {
    private _p0 = [_selectedObjects, _menuData] call _anchorPos;
    if (_p0 isEqualTo []) exitWith {
        if (_debug3DEN) then {
            [format ["[3DEN] Vehicle On Rails: invalid click position. menuData=%1", _menuData], false, true] call OKS_fnc_LogDebug;
        };
        ["Vehicle On Rails: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
        false
    };

    // Create Spawn
    _spawnObj = create3DENEntity ["Logic", "Logic", _p0];
    if (isNull _spawnObj) exitWith {
        ["Vehicle On Rails: Failed to create spawn helper", 1, 6, true] call BIS_fnc_3DENNotification;
        false
    };
    _createdHelpers pushBack _spawnObj;

    // Create WP + End
    private _wp1 = create3DENEntity ["Logic", "Logic", ([_p0, 35, 0] call _offsetPos)];
    private _wp2 = create3DENEntity ["Logic", "Logic", ([_p0, 70, 0] call _offsetPos)];
    if (!isNull _wp1) then { _createdHelpers pushBack _wp1; _wpObjs pushBack _wp1; };
    if (!isNull _wp2) then { _createdHelpers pushBack _wp2; _wpObjs pushBack _wp2; };
};

if (isNull _spawnObj || { _wpObjs isEqualTo [] }) exitWith {
    ["Vehicle On Rails: Missing helpers (need Spawn + at least 1 waypoint)", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _spawnName = [_spawnObj, "RailSpawn"] call _ensureNamed;
private _wpNames = [];
{
    private _prefix = if (_forEachIndex == ((count _wpObjs) - 1)) then {"RailEnd"} else {"RailWP"};
    _wpNames pushBack ([_x, _prefix] call _ensureNamed);
} forEach _wpObjs;

// Assign layer for created/selected helpers.
if (!isNil "_layer") then {
    [_spawnObj, _layer] call OKS_fnc_EdenSetLayerSafe;
    { [_x, _layer] call OKS_fnc_EdenSetLayerSafe; } forEach _wpObjs;
};

// Vehicle classname from selection (optional)
private _vehicleClass = "O_APC_Wheeled_02_rcws_v2_F";
private _veh = objNull;
{
    if (_x isKindOf "LandVehicle") exitWith { _veh = _x; };
} forEach _contextObjects;
if (!isNull _veh) then {
    _vehicleClass = typeOf _veh;
};
if !(_vehicleClassOverride isEqualTo "") then {
    _vehicleClass = _vehicleClassOverride;
};

private _side = [_contextObjects] call _sideFromSelection;
private _sideStr = [_side] call _sideToString;
if !(_sideStrOverride isEqualTo "") then {
    _sideStr = _sideStrOverride;
};

// Defaults (kept simple; user can edit the snippet).
private _cargoCount = 6;
private _speedKph = 35;
private _deploy = "rush";

private _wpArrayStr = "[" + (_wpNames joinString ",") + "]";
private _example = format [
    "[%1, %2, %3, %4, %5, %6, %7] spawn OKS_fnc_RailVehicle_Spawn;",
    _spawnName,
    str _vehicleClass,
    _sideStr,
    _cargoCount,
    _speedKph,
    _wpArrayStr,
    str _deploy
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

// Remember last action: keep defaults as fixed args, and store helper objects for repeat fallback.
["OKS_fnc_EdenVehicleOnRails", [_vehicleClass, _sideStr], ([_spawnObj] + _wpObjs)] call OKS_fnc_EdenRememberLastAction;

systemChat format ["CopiedToClipboard | Vehicle On Rails copied to clipboard | Cache=%1", _cacheCount];
[format ["CopiedToClipboard | Vehicle On Rails copied to clipboard | Cache=%1 | %2", _cacheCount, _example], false, true, true] call OKS_fnc_LogDebug;
[format ["Vehicle On Rails copied (%1) (helpers: %2 + %3 WPs) | Cache=%4", _sideStr, _spawnName, count _wpObjs, _cacheCount], 0, 10, true] call BIS_fnc_3DENNotification;

// Delete selected template objects that are not required at runtime.
// Keep Logic helpers (they are referenced by name in the generated snippet).
private _selectedToDelete = _selectedObjects select { !(_x isKindOf "Logic") };
if !(_selectedToDelete isEqualTo []) then {
    if (!(uiNamespace getVariable ["OKS_3DEN_IS_REPEAT", false])) then {
        delete3DENEntities _selectedToDelete;
    };
};

true
