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

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

if (_debug3DEN) then {
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

private _offsetPosFrom = {
    params ["_pos", "_dist", "_dirDeg"];
    private _p = +_pos;
    if ((count _p) < 2) exitWith {[]};
    if ((count _p) == 2) then { _p pushBack 0; };
    _p set [
        0,
        (_p select 0) + (sin _dirDeg) * _dist
    ];
    _p set [
        1,
        (_p select 1) + (cos _dirDeg) * _dist
    ];
    _p set [2, 0];
    [_p] call OKS_fnc_EdenSanitizePos
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
    if (_debug3DEN) then {
		[format ["Mortars: invalid click position. menuData=%1", _md], false, true] call OKS_fnc_LogDebug;
    };
    ["Mortars: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _mortarObj = objNull;
{
    if (_x isKindOf "StaticMortar" || {_x isKindOf "StaticWeapon"}) exitWith { _mortarObj = _x; };
} forEach _contextObjects;

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

// If the user right-clicked the mortar itself, Eden often anchors to the mortar position.
// Offset the target helper so it's easy to grab/move.
if (!isNull _mortarObj && {(_p0 distance2D (getPosATL _mortarObj)) < 1}) then {
    private _mp = getPosATL _mortarObj;
    private _dir = getDir _mortarObj;
    private _tp = ([_mp, 6, _dir + 90] call _offsetPosFrom);
    if !(_tp isEqualTo []) then {
        _p0 = _tp;
    };
};

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
    // New behavior: if no mortar is selected, spawn one so the snippet is always a manned mortar.
    _platformResolved = "manned";
};

private _mortarAutoSpawned = false;

private _requiresMortar = (_platformResolved == "manned");
if (_requiresMortar && {isNull _mortarObj}) then {
    // No mortar selected: interpret the click as mortar placement (always).
    // If DESIGNATED, we'll offset the target helper logic instead so the mortar is easy to spot.
    private _spawnPos = _p0;
    private _created = ["O_Mortar_01_F", _spawnPos, "Mortar"] call _createVehicleAt;
    _mortarObj = _created select 0;
    _mortarAutoSpawned = !isNull _mortarObj;
};

if (_requiresMortar && {isNull _mortarObj}) exitWith {
    ["Mortars: Failed to create/select a mortar", 1, 6, true] call BIS_fnc_3DENNotification;
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
    // If we auto-spawned the mortar at the click position, offset the target helper so it doesn't overlap.
    if (_mortarAutoSpawned) then {
        private _tp = ([_p0, 8, 90] call _offsetPosFrom);
        if !(_tp isEqualTo []) then { _p0 = _tp; };
    };
    _targetName = ["MortarTarget", _p0] call _createHiddenLogic;
    if (_targetName isEqualTo "") exitWith {
        ["Mortars: Failed to create target helper", 1, 6, true] call BIS_fnc_3DENNotification;
        false
    };
    _posArg = format ["getPosATL %1", _targetName];
};

private _example = format [
    "null = [%1,%2,%3,%4,[%5,%6],%7,%8,%9,%10,%11] spawn OKS_fnc_Mortars;",
    _mortarArg,
    _sideStr,
    str _firingModeLower,
    str _roundTypeLower,
    _posArg,
    _inaccuracy,
    _minRange,
    _maxRange,
    _ammo,
    -1,
    -1
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenMortars", [_platform, _targeting, _firingMode, _roundType], _contextObjects] call OKS_fnc_EdenRememberLastAction;
// Mortar examples do not need crew in Eden; remove any placed crew after copy.
private _crewDeleted = 0;
if (_platformResolved == "manned" && {!isNull _mortarObj}) then {
    private _crewToDelete = (crew _mortarObj) select { _x isKindOf "Man" };
    if !(_crewToDelete isEqualTo []) then {
        delete3DENEntities _crewToDelete;
        _crewDeleted = count _crewToDelete;
    };
};
private _targetDesc = if (_targetingLower == "auto") then {"AUTO"} else {format ["DESIGNATED (%1)", _targetName]};
private _platformDesc = if (_platformResolved == "offmap") then {"OFFMAP"} else {format ["MANNED (%1)", _mortarName]};

private _desc = format [
    "Mortars copied to clipboard: %1 | %2 | Mode=%3 | Round=%4 | Side=%5",
    _platformDesc,
    _targetDesc,
    _firingModeLower,
    _roundTypeLower,
    _sideStr
];

if (_crewDeleted > 0) then {
    _desc = format ["%1 | DeletedCrew=%2", _desc, _crewDeleted];
};

private _logText = format ["CopiedToClipboard | Mortars copied to clipboard | Cache=%1 | %2", _cacheCount, _example];
private _chatText = format ["CopiedToClipboard | Mortars copied to clipboard | Cache=%1", _cacheCount];
systemChat _chatText;

private _logExample = _example splitString "\r\n" joinString " ";
_logText = format ["CopiedToClipboard | Mortars copied to clipboard | Cache=%1 | %2", _cacheCount, _logExample];
[_logText, false, true, true] call OKS_fnc_LogDebug;
if (_debug3DEN) then {
    [format ["Mortars | %1", _desc], false, true, true] call OKS_fnc_LogDebug;
};

private _notify = if (_debug3DEN) then {_desc} else {"Mortars copied to clipboard"};
_notify = format ["%1 | Cache=%2", _notify, _cacheCount];
[_notify, 0, 10, true] call BIS_fnc_3DENNotification;
true;
