/*
    OKS_fnc_EdenArtyFire

    Eden helper for OKS_fnc_ArtyFire.
    - Requires a selected/clicked artillery vehicle/object (validation)
    - Creates a hidden target helper logic at click position and names it
    - Copies a spawnList-ready OKS_fnc_ArtyFire call to clipboard

    OKS_fnc_ArtyFire signature:
      [side, artyObject, target(Object/Pos), rounds, rearmTime, reloadTime, fullCrew] spawn OKS_fnc_ArtyFire;

    Usage from CfgEden:
      (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenArtyFire;
*/

params [
    "_menuData",
    ["_rounds", 7, [0]],
    ["_rearmTime", 300, [0]],
    ["_reloadTime", 30, [0]],
    ["_fullCrew", false, [false]]
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

private _createLogic = {
    params ["_namePrefix", "_pos"];
    private _p = [_pos] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) then { _p = [0, 0, 0]; };
    _p set [2, 0];

    private _obj = create3DENEntity ["Logic", "Logic", _p];
    if (isNull _obj) exitWith {""};

    private _n = [_namePrefix] call OKS_fnc_next3DENName;
    _obj set3DENAttribute ["name", _n];
    _n
};

// Validate artillery object selection
private _artyObj = objNull;
{
    if (_x isKindOf "AllVehicles") exitWith { _artyObj = _x; };
} forEach _contextObjects;

if (isNull _artyObj) then {
    private _p0 = [_contextObjects, _md] call _anchorPos;
    if (_p0 isEqualTo []) exitWith {
        ["ArtyFire: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
        false
    };
    private _created = ["rhs_2s1_tv", _p0, "Arty"] call _createVehicleAt;
    _artyObj = _created select 0;
};

if (isNull _artyObj) exitWith {
    ["ArtyFire: Failed to create/select artillery", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _artyName = [_artyObj, "Arty"] call _ensureNamed;

// Create target helper next to the artillery (user can move it afterwards).
private _artyPos = getPosATL _artyObj;
private _dir = getDir _artyObj;
private _tp = ([_artyPos, 8, _dir] call _offsetPosFrom);
if (_tp isEqualTo []) then { _tp = _artyPos; _tp set [2, 0]; };

private _targetName = ["ArtyTarget", _tp] call _createLogic;
if (_targetName isEqualTo "") exitWith {
    ["ArtyFire: Failed to create target helper", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _sideStr = [([_contextObjects] call _sideFromSelection)] call _sideToString;
private _fullCrewStr = if (_fullCrew) then {"true"} else {"false"};

private _example = format [
    "null = [%1,%2,getpos %3,%4,%5,%6,%7] spawn OKS_fnc_ArtyFire;",
    _sideStr,
    _artyName,
    _targetName,
    _rounds,
    _rearmTime,
    _reloadTime,
    _fullCrewStr
];

private _desc = format [
    "ArtyFire (Ambience) copied to clipboard: Arty=%1 | Target=%2 (spawned next to arty) | Side=%3 | Rounds=%4 | Rearm=%5 | Reload=%6 | FullCrew=%7",
    _artyName,
    _targetName,
    _sideStr,
    _rounds,
    _rearmTime,
    _reloadTime,
    _fullCrewStr
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenArtyFire", [_rounds, _rearmTime, _reloadTime, _fullCrew], _contextObjects] call OKS_fnc_EdenRememberLastAction;

// If the artillery has crew placed in Eden, remove them after copy.
private _crewToDelete = (crew _artyObj) select { _x isKindOf "Man" };
private _crewDeleted = 0;
if !(_crewToDelete isEqualTo []) then {
    delete3DENEntities _crewToDelete;
    _crewDeleted = count _crewToDelete;
};

private _desc2 = if (_crewDeleted > 0) then {
    format ["%1 | DeletedCrew=%2", _desc, _crewDeleted]
} else {
    _desc
};
private _debug = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];
private _chatText = format ["CopiedToClipboard | ArtyFire copied to clipboard | Cache=%1", _cacheCount];
systemChat _chatText;

private _logExample = _example splitString "\r\n" joinString " ";
private _logText = format ["CopiedToClipboard | ArtyFire copied to clipboard | Cache=%1 | %2", _cacheCount, _logExample];
[_logText, false, true, true] call OKS_fnc_LogDebug;
if (_debug) then {
    [format ["ArtyFire | %1", _desc2], false, true, true] call OKS_fnc_LogDebug;
};

private _notify = if (_debug) then {_desc2} else {"ArtyFire copied to clipboard"};
_notify = format ["%1 | Cache=%2", _notify, _cacheCount];
[_notify, 0, 10, true] call BIS_fnc_3DENNotification;
true;
