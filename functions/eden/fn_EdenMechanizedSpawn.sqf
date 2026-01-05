/*
    OKS_fnc_EdenMechanizedSpawn

    Eden helper:
    - Ensures Spawn + Hunt trigger exist and are named
    - Uses selected vehicle (optional) as classname template
    - Copies a spawnList-ready call to OKS_fnc_Mechanized_Spawn

    Usage from CfgEden:
      (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenMechanizedSpawn;
*/

private _args = _this;
if !(_args isEqualType []) then { _args = [_args]; };

_args params [
    ["_menuData", []],
    ["_vehicleClassOverride", ""],
    ["_infCountOverride", -1],
    ["_sideStrOverride", ""]
];

if (_menuData isEqualType objNull) then {
    _menuData = [_menuData];
};

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

private _selectedObjects = get3DENSelected "object";
private _selectedTriggers = get3DENSelected "trigger";

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

private _spawnName = "";
private _triggerName = "";

private _layer = ["Mechanized Spawn", "OKS Eden - Hunt Helpers"] call OKS_fnc_EdenGetOrCreateLayer;

private _p0 = [_selectedObjects, _menuData] call _anchorPos;
if (_p0 isEqualTo []) exitWith {
    if (_debug3DEN) then {
		[format ["[3DEN] Mechanized Spawn: invalid click position. menuData=%1", _menuData], false, true] call OKS_fnc_LogDebug;
    };
    ["Mechanized Spawn: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};
_p0 = [_p0] call OKS_fnc_EdenSanitizePos;
if (_p0 isEqualTo []) then { _p0 = [0, 0, 0]; };

// Spawn object
private _existingLogic = objNull;
{
    if (_x isKindOf "Logic") exitWith { _existingLogic = _x; };
} forEach _selectedObjects;

if (!isNull _existingLogic) then {
    _spawnName = [_existingLogic, "MechSpawn"] call _ensureNamed;
	if (!isNil "_layer") then { [_existingLogic, _layer] call OKS_fnc_EdenSetLayerSafe; };
} else {
    private _spawnObj = create3DENEntity ["Logic", "Logic", _p0];
    if (isNull _spawnObj) exitWith {
        ["Mechanized Spawn: Failed to create spawn helper", 1, 6, true] call BIS_fnc_3DENNotification;
        false
    };
	if (!isNil "_layer") then { [_spawnObj, _layer] call OKS_fnc_EdenSetLayerSafe; };
    _spawnName = [_spawnObj, "MechSpawn"] call _ensureNamed;
    _spawnObj set3DENAttribute ["hideObject", true];
};

// Hunt trigger
if ((count _selectedTriggers) > 0) then {
    _triggerName = [(_selectedTriggers select 0), "MechHunt"] call _ensureNamed;
	if (!isNil "_layer") then { [(_selectedTriggers select 0), _layer] call OKS_fnc_EdenSetLayerSafe; };
} else {
    private _tp = ([_p0, 60, 0] call _offsetPos);
_tp = [_tp] call OKS_fnc_EdenSanitizePos;
    if (_tp isEqualTo []) then { _tp = _p0; };
    private _trg = create3DENEntity ["Trigger", "EmptyDetector", _tp];
	if (!isNil "_layer") then { [_trg, _layer] call OKS_fnc_EdenSetLayerSafe; };
    _triggerName = [_trg, "MechHunt"] call _ensureNamed;
    _trg set3DENAttribute ["size3", [500, 500, -1]];
    _trg set3DENAttribute ["IsRectangle", false];
    // HuntRun/ScanZone uses `list _Zone`, which depends on trigger activation filtering.
    // Default to players-in-zone.
    _trg set3DENAttribute ["activationBy", "ANYPLAYER"];
    _trg set3DENAttribute ["activationType", "PRESENT"];
    _trg set3DENAttribute ["isServerOnly", true];
    _trg set3DENAttribute ["repeating", true];
    _trg set3DENAttribute ["repeatable", true];
};

// Vehicle classname template (optional)
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

// Infantry count from selection (optional)
private _infCount = 5;
private _men = _selectedObjects select { _x isKindOf "Man" };
if (!(_men isEqualTo [])) then {
    _infCount = (count _men) max 0;
};

if (_infCountOverride >= 0) then {
    _infCount = _infCountOverride;
};

private _side = [_contextObjects] call _sideFromSelection;
private _sideStr = [_side] call _sideToString;

if !(_sideStrOverride isEqualTo "") then {
    _sideStr = _sideStrOverride;
};

private _vehicleClassStr = str _vehicleClass;

private _example = format [
    "[%1,%2,%3,%4,%5,%6] spawn OKS_fnc_Mechanized_Spawn;",
    _spawnName,
    _triggerName,
    _vehicleClassStr,
    _infCount,
    _sideStr,
    2000
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenMechanizedSpawn", [_vehicleClass, _infCount, _sideStr], []] call OKS_fnc_EdenRememberLastAction;
systemChat format ["CopiedToClipboard | Mechanized Spawn copied to clipboard | Cache=%1", _cacheCount];
[format ["CopiedToClipboard | Mechanized Spawn copied to clipboard | Cache=%1 | %2", _cacheCount, _example], false, true, true] call OKS_fnc_LogDebug;
[format ["Mechanized Spawn copied to clipboard (%1) (helpers: %2, %3) | Cache=%4", _sideStr, _spawnName, _triggerName, _cacheCount], 0, 10, true] call BIS_fnc_3DENNotification;

// Delete selected template objects (keep selected logics; never delete right-clicked entity unless it was selected).
private _selectedToDelete = _selectedObjects select { !(_x isKindOf "Logic") };
if !(_selectedToDelete isEqualTo []) then {
    if (!(uiNamespace getVariable ["OKS_3DEN_IS_REPEAT", false])) then {
        delete3DENEntities _selectedToDelete;
    };
};

true
