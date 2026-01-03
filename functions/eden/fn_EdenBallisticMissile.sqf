/*
    OKS_fnc_EdenBallisticMissile

    Eden helper:
    - Right-click terrain to choose launcher spawn position
    - Spawns a launcher entity (SCUD/VLS) at click position and names it
    - Spawns a nearby trigger (EmptyDetector) and names it (target reference)
    - Uses GW global side selection (uiNamespace GW_FRAMEWORK_GLOBAL_SIDE)
    - Copies a spawnList-ready OKS_fnc_ScudIntercept_LaunchAI call to clipboard

    Usage from CfgEden:
      [(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), 'rhs_9k79'] call OKS_fnc_EdenBallisticMissile;
      [(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), 'B_Ship_MRLS_01_F'] call OKS_fnc_EdenBallisticMissile;
*/

params [
    "_menuData",
    ["_launcherClass", "rhs_9k79", [""]]
];

private _md = if (_menuData isEqualType []) then { _menuData } else { [] };

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

private _anchorPos = {
    params ["_md"];
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

    if (_p isEqualTo []) then {
        _p = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray;
    };

    _p set [2, 0];
    _p = [_p] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith { [] };
    _p
};

private _offsetPosFrom = {
    params ["_pos", "_dist", "_dirDeg"];
    private _p = +_pos;
    if ((count _p) < 2) exitWith { [] };
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

private _sideToString = {
    params ["_side"];
    if (_side isEqualTo west) exitWith {"west"};
    if (_side isEqualTo east) exitWith {"east"};
    if (_side isEqualTo independent) exitWith {"independent"};
    if (_side isEqualTo civilian) exitWith {"civilian"};
    "west"
};

private _sideFromGWGlobalSelection = {
    private _s = toUpper (uiNamespace getVariable ["GW_FRAMEWORK_GLOBAL_SIDE", "WEST"]);
    switch (_s) do {
        case "EAST": { east };
        case "INDEPENDENT": { independent };
        case "GUER": { independent };
        default { west };
    }
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

    // Some vehicle classes (notably factioned assets like VLS) can cause Eden to
    // auto-create crew units. We want the launcher to be empty in Eden; runtime
    // LaunchAI will spawn/replace crew as needed.
    private _objsBefore = all3DENEntities select 0;
    private _obj = create3DENEntity ["Object", _class, _p, true];
    if (isNull _obj) exitWith { [objNull, ""] };

    private _objsAfter = all3DENEntities select 0;
    private _newObjs = _objsAfter - _objsBefore;
    private _toDelete = [];
    {
        if (_x isKindOf "Man" && {_x != _obj}) then { _toDelete pushBack _x; };
    } forEach _newObjs;
    if !(_toDelete isEqualTo []) then {
        delete3DENEntities _toDelete;
    };

    // Some classes (notably ships like VLS) can still end up with assigned crew.
    // Ensure the launcher is empty by deleting any units currently assigned as vehicle crew.
    private _assignedCrewUnits = (all3DENEntities select 0) select {
        (_x isKindOf "Man") && {vehicle _x == _obj}
    };
    if !(_assignedCrewUnits isEqualTo []) then {
        delete3DENEntities _assignedCrewUnits;
    };

    private _n = [_namePrefix] call OKS_fnc_next3DENName;
    _obj set3DENAttribute ["name", _n];

    // Make sure the launcher is locked in the mission by default.
    // (Lock values in Eden are stored as strings like "LOCKED" in mission.sqm.)
    _obj set3DENAttribute ["lock", "LOCKED"]; 
    [_obj, _n]
};

private _createTriggerAt = {
    params ["_pos", "_namePrefix", ["_radius", 500, [0]]];

    private _p = [_pos] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) then { _p = [0, 0, 0]; };
    _p set [2, 0];

    private _trg = create3DENEntity ["Trigger", "EmptyDetector", _p];
    if (isNull _trg) exitWith { [objNull, ""] };

    private _n = [_namePrefix] call OKS_fnc_next3DENName;
    _trg set3DENAttribute ["name", _n];

    // Trigger is used as an area reference (inArea) for target selection.
    // Use the same attributes as other Eden helpers in this repo.
    // Default size is just a starting point; users can resize in Eden.
    _trg set3DENAttribute ["size3", [_radius, _radius, 0]];
    _trg set3DENAttribute ["IsRectangle", false];

    [_trg, _n]
};

if (!isClass (configFile >> "CfgVehicles" >> _launcherClass)) exitWith {
    [format ["Ballistic Missile: Invalid launcher classname (%1)", _launcherClass], 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _spawnPos = [_md] call _anchorPos;
if (_spawnPos isEqualTo []) exitWith {
    ["Ballistic Missile: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _launcherPrefix = if (_launcherClass isEqualTo "B_Ship_MRLS_01_F") then {"VLS"} else {"SCUD"};
private _createdLauncher = [_launcherClass, _spawnPos, _launcherPrefix] call _createVehicleAt;
private _launcherObj = _createdLauncher select 0;
private _launcherName = _createdLauncher select 1;

if (isNull _launcherObj || {_launcherName isEqualTo ""}) exitWith {
    ["Ballistic Missile: Failed to create launcher", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

// Place trigger near the launcher so it is easy to grab/move in Eden.
private _triggerPos = [_spawnPos, 25, 90] call _offsetPosFrom;
if (_triggerPos isEqualTo []) then {
    _triggerPos = [_spawnPos, 25, 0] call _offsetPosFrom;
};

private _createdTrigger = [_triggerPos, "BallisticTarget", 500] call _createTriggerAt;
private _triggerObj = _createdTrigger select 0;
private _triggerName = _createdTrigger select 1;

if (isNull _triggerObj || {_triggerName isEqualTo ""}) exitWith {
    ["Ballistic Missile: Failed to create target trigger", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _side = call _sideFromGWGlobalSelection;
private _sideStr = [_side] call _sideToString;

// Minimal call uses defaults for allowed weapons, turret, and creates task by default.
private _example = format [
    "null = [%1, %2, %3, 15] spawn OKS_fnc_ScudIntercept_LaunchAI;",
    _launcherName,
    _triggerName,
    _sideStr
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
["OKS_fnc_EdenBallisticMissile", [_launcherClass], [_launcherObj, _triggerObj]] call OKS_fnc_EdenRememberLastAction;

private _desc = format [
    "[3DEN] Ballistic Missile copied to clipboard: Launcher=%1 (%2) | TargetTrigger=%3 | Side=%4",
    _launcherName,
    _launcherClass,
    _triggerName,
    _sideStr
];

if (_debug3DEN) then {
    [format ["[3DEN] EdenBallisticMissile | %1", _desc], false, true] call OKS_fnc_LogDebug;
};

systemChat _desc;
true
