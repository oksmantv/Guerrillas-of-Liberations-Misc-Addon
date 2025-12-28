/*
    OKS_fnc_EdenAttackSpawnGroup

    Eden helper:
    - Uses selection (or creates helper objects) for spawn/target reference
    - Copies a spawnList-ready call to OKS_fnc_Attack_SpawnGroup

    Usage from CfgEden:
      [(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), 'infantry'] call OKS_fnc_EdenAttackSpawnGroup;
      [(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), 'vehicle'] call OKS_fnc_EdenAttackSpawnGroup;
*/

params ["_menuData", ["_mode", "infantry", [""]]];

private _selected = get3DENSelected "object";

private _fnc_sanitizePos0 = {
    params ["_pos"];
    private _p = [_pos] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith {[]};
    _p set [2, 0];
    _p
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

    if (_p isEqualTo []) then { _p = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray; };
    _p = [_p] call _fnc_sanitizePos0;
    if (_p isEqualTo []) exitWith {[]};
    _p
};

private _offsetPos = {
    params ["_pos", "_dist", "_dirDeg"];
    private _p = [_pos] call _fnc_sanitizePos0;
    if (_p isEqualTo []) exitWith {[0, 0, 0]};
    [
        (_p select 0) + (sin _dirDeg) * _dist,
        (_p select 1) + (cos _dirDeg) * _dist,
        (_p select 2)
    ]
};

private _createHelper = {
    params ["_namePrefix", "_pos"];
    private _p = [_pos] call _fnc_sanitizePos0;
    if (_p isEqualTo []) then { _p = [0, 0, 0]; };
    private _obj = create3DENEntity ["Logic", "Logic", _p];
    if (isNull _obj) exitWith {""};
    private _n = [_namePrefix] call OKS_fnc_next3DENName;
    _obj set3DENAttribute ["name", _n];
    _obj set3DENAttribute ["hideObject", true];
    if (((_obj get3DENAttribute "name") select 0) isEqualTo "") then {
        _obj set3DENAttribute ["name", _n];
    };
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

private _spawnName = "";
private _targetName = "";

// Always create new helper logics.
// Selection is treated as template objects (for side/count/classname) and may be deleted at the end.
private _p0 = [_selected, _menuData] call _anchorPos;
if (_p0 isEqualTo []) exitWith {
    [format ["EdenAttackSpawnGroup: invalid click position. menuData=%1", _menuData], false, true] call OKS_fnc_LogDebug;
    ["Attack SpawnGroup: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};
_spawnName = ["AttackSpawn", _p0] call _createHelper;
_targetName = ["AttackTarget", ([_p0, 75, 0] call _offsetPos)] call _createHelper;

private _side = [_selected] call _sideFromSelection;
private _sideStr = [_side] call _sideToString;

private _stepWP = false;
private _range = 1000;

private _modeLower = toLower _mode;
private _thirdParam = 6;

if (_modeLower isEqualTo "vehicle") then {
    private _veh = objNull;
    {
        if (_x isKindOf "LandVehicle") exitWith { _veh = _x; };
    } forEach _selected;

    if (isNull _veh) then {
        _thirdParam = str "O_MRAP_02_F";
        ["No vehicle selected: using O_MRAP_02_F as placeholder classname.", 0, 5, true] call BIS_fnc_3DENNotification;
    } else {
        _thirdParam = str (typeOf _veh);
    };
} else {
    // Infantry count: if selection has men, use that count, otherwise default.
    private _men = _selected select { _x isKindOf "Man" };
    if (!(_men isEqualTo [])) then {
        _thirdParam = (count _men) max 1;
    };
};

private _example = format [
    "[%1,%2,%3,%4,%5,%6] spawn OKS_fnc_Attack_SpawnGroup;",
    _spawnName,
    _targetName,
    _thirdParam,
    _sideStr,
    if (_stepWP) then {"true"} else {"false"},
    _range
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenAttackSpawnGroup", [_mode], _selected] call OKS_fnc_EdenRememberLastAction;
systemChat format ["CopiedToClipboard | Attack SpawnGroup copied to clipboard | Cache=%1", _cacheCount];
[format ["CopiedToClipboard | Attack SpawnGroup copied to clipboard | Cache=%1 | %2", _cacheCount, _example], false, true, true] call OKS_fnc_LogDebug;
[format ["Attack SpawnGroup copied to clipboard (%1/%2) (helpers: %3, %4) | Cache=%5", _modeLower, _sideStr, _spawnName, _targetName, _cacheCount], 0, 10, true] call BIS_fnc_3DENNotification;

// Delete template objects (avoid deleting helper logics if the user had any selected).
private _selectedToDelete = _selected select { !(_x isKindOf "Logic") };
if !(_selectedToDelete isEqualTo []) then {
    delete3DENEntities _selectedToDelete;
};

true
