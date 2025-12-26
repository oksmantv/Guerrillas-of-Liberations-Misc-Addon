/*
    OKS_fnc_EdenLambsWaveSpawn

    Creates 3DEN spawn helper object(s) and copies a spawnList-ready call to:
      OKS_fnc_Lambs_Wavespawn

    Usage (from Eden context menu):
      [(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), 'rush', 'single'] call OKS_fnc_EdenLambsWaveSpawn;
      [(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), 'hunt', 'triple'] call OKS_fnc_EdenLambsWaveSpawn;

    Options:
      - _lambsType: rush/hunt/creep/...
      - _layout: "single" | "triple"

    Notes:
      - Avoids getPos in the copied string so you can move the helper objects later.
      - Side is derived from current selection where possible.

        Output defaults (edit after paste):
            - unitsPerWave = 8
            - waves        = 3
            - delay        = 90
            - range        = 1500

        For docs: Use the Eden menu item "Open Docs" (Functions Viewer search).
*/

params ["_menuData", "_lambsType", ["_layout", "single", [""]]];

// Placement anchor: follow the exact same rule as EdenLambsGroup (SpawnGroup):
// use BIS_fnc_3DENEntityMenu_data param [0] as the clicked position.
private _clickPos = [];

// Some Eden contexts pass menuData as [x,y,z] directly.
if (_menuData isEqualType []) then {
    _clickPos = [_menuData] call OKS_fnc_EdenPosFromArray;
};

// Other contexts pass menuData as [[x,y,z], <entity>, ...] or [<entity>, ...].
if (_clickPos isEqualTo []) then {
    private _md0 = _menuData param [0, []];
    if (_md0 isEqualType objNull) then {
        if (!isNull _md0) then { _clickPos = getPosATL _md0; };
    } else {
        if (_md0 isEqualType []) then { _clickPos = [_md0] call OKS_fnc_EdenPosFromArray; };
    };
};

if (_clickPos isEqualTo []) then { _clickPos = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray; };
_clickPos set [2, 0];
_clickPos = [_clickPos] call OKS_fnc_EdenSanitizePos;

if (_clickPos isEqualTo []) exitWith {
    (format ["LAMBS WaveSpawn: invalid click position. menuData=%1", _menuData]) call OKS_fnc_LogDebug;
    ["LAMBS WaveSpawn: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
};
_layout = toLower _layout;
if !(_layout in ["single", "triple"]) then { _layout = "single"; };

private _fnc_offsetPos = {
    params ["_pos", "_dist", "_dir"];
    private _base = [_pos] call OKS_fnc_EdenPosFromArray;
    if (_base isEqualTo []) exitWith {[]};
    private _x = (_base select 0) + (_dist * sin _dir);
    private _y = (_base select 1) + (_dist * cos _dir);
    [[_x, _y, 0]] call OKS_fnc_EdenSanitizePos
};

// Side detection from selection (units) or from vehicle class config
private _side = east;
private _selected = get3DENSelected "object";
private _selectedToDelete = +_selected;
private _sideCandidates = [];

private _fnc_sideFromVehicleClass = {
    params ["_vehicleClass"];
    private _cfg = configFile >> "CfgVehicles" >> _vehicleClass;
    if (!isClass _cfg) exitWith {east};
    private _sideNum = getNumber (_cfg >> "side");
    switch (_sideNum) do {
        case 0: {west};
        case 1: {east};
        case 2: {independent};
        case 3: {civilian};
        default {east};
    };
};

private _fnc_sideToCode = {
    params ["_sideValue"];
    switch (_sideValue) do {
        case west: {"west"};
        case east: {"east"};
        case independent: {"independent"};
        case civilian: {"civilian"};
        default {"east"};
    };
};

{
    if (_x isKindOf "Man") then {
        _sideCandidates pushBack (side _x);
    } else {
        _sideCandidates pushBack ([typeOf _x] call _fnc_sideFromVehicleClass);
    };
} forEach _selected;

if (_sideCandidates isNotEqualTo []) then {
    private _uniqueSides = [];
    { _uniqueSides pushBackUnique _x } forEach _sideCandidates;
    _side = _uniqueSides select 0;
};

// unitsPerWave default: use selected men count if present.
private _unitsPerWave = 8;
private _selectedMen = _selected select { _x isKindOf "Man" };
if !(_selectedMen isEqualTo []) then {
    _unitsPerWave = (count _selectedMen) max 1;
};

// Create helper object(s)
private _spawnObjects = [];
private _spawnPrefix = "LambsWaveSpawn";

private _createSpawnObj = {
    // Accept either a raw position array [x,y,z] or a wrapped one [[x,y,z]].
    private _pos = _this;
    if (_pos isEqualType [] && {(count _pos) == 1} && {(_pos select 0) isEqualType []}) then {
        _pos = _pos select 0;
    };
    private _p = [_pos] call OKS_fnc_EdenPosFromArray;
    if (_p isEqualTo []) exitWith {[objNull, ""]};

    private _name = [_spawnPrefix] call OKS_fnc_next3DENName;
    _p set [2, 0];
    _p = [_p] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith {[objNull, ""]};
    // Prefer a tiny physical helper object, but fall back to a Logic entity if creation fails.
    private _obj = create3DENEntity ["Object", "Land_Matches_F", _p];
    if (isNull _obj) then {
        _obj = create3DENEntity ["Logic", "Logic", _p];
    };
    if (isNull _obj) exitWith {[objNull, ""]};
    _obj set3DENAttribute ["name", _name];
    _obj set3DENAttribute ["hideObject", true];
    [_obj, _name]
};

if (_layout == "triple") then {
    // Create the first helper at the click position.
    private _o0 = _clickPos call _createSpawnObj;
    private _obj0 = _o0 select 0;
    _spawnObjects pushBack _obj0;

    // Place two additional helpers in dir 0 and 180 from the first helper.
    private _basePos = if (isNull _obj0) then {_clickPos} else { getPosATL _obj0 };
    private _p1 = [_basePos, 25, 0] call _fnc_offsetPos;
    private _p2 = [_basePos, 25, 180] call _fnc_offsetPos;

    private _o1 = _p1 call _createSpawnObj;
    private _o2 = _p2 call _createSpawnObj;
    _spawnObjects pushBack (_o1 select 0);
    _spawnObjects pushBack (_o2 select 0);
} else {
    private _o0 = _clickPos call _createSpawnObj;
    _spawnObjects pushBack (_o0 select 0);
};

if (_spawnObjects isEqualTo [] || {isNull (_spawnObjects select 0)} || {(_layout == "triple") && {(count _spawnObjects) < 3}} || {(_layout == "triple") && {isNull (_spawnObjects select 1) || {isNull (_spawnObjects select 2)}}}) exitWith {
    (format ["LAMBS WaveSpawn: Could not create 3DEN spawn object(s). clickPos=%1 md0Type=%2", _clickPos, typeName (_menuData param [0, objNull])]) call OKS_fnc_LogDebug;
    ["LAMBS WaveSpawn: Failed to create helper objects", 1, 6, true] call BIS_fnc_3DENNotification;
};

// Build variable name (unique per created object set)
private _varName = format ["%1_Done", ((_spawnObjects select 0) get3DENAttribute "name") select 0];

// Sane defaults; editors tweak after paste
private _waves = 3;
private _delay = 90;
private _range = 1500;

private _spawnArg = if (_layout == "triple") then {
    // Pass objects directly to keep it dynamic (move them later)
    format ["[%1, %2, %3]", ((_spawnObjects select 0) get3DENAttribute "name") select 0, ((_spawnObjects select 1) get3DENAttribute "name") select 0, ((_spawnObjects select 2) get3DENAttribute "name") select 0]
} else {
    ((_spawnObjects select 0) get3DENAttribute "name") select 0
};

private _example = format [
    "[%1, %2, %3, %4, %5, %6, %7, %8] spawn OKS_fnc_Lambs_Wavespawn;",
    _spawnArg,
    _unitsPerWave,
    _waves,
    _delay,
    str _lambsType,
    [_side] call _fnc_sideToCode,
    _range,
    str _varName
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);
[format ["CopiedToClipboard: %1", _example], true] call OKS_fnc_LogDebug;
[format ["LAMBS WaveSpawn copied to clipboard | Cache=%1", _cacheCount], 0, 4, true] call BIS_fnc_3DENNotification;

// Match behavior of other Eden helpers: remove selected template units/objects after copy.
if !(_selectedToDelete isEqualTo []) then {
    delete3DENEntities _selectedToDelete;
};
