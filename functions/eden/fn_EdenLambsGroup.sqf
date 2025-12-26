/*
        OKS_fnc_EdenLambsGroup

        Creates a hidden 3DEN spawn helper object and copies an example call to:
            OKS_fnc_Lambs_SpawnGroup

        Modes:
            - infantry: uses number of selected men (defaults to 6)
            - vehicle:  uses selected vehicle classnames + cargo seats from config (defaults to 6)

        Output defaults (edit after paste):
            - range = 1500

        For docs: Use the Eden menu item "Open Docs" (Functions Viewer search).
*/

params ["_positionArray", "_lambsType", ["_mode", "infantry", [""]]];
_positionArray params ["_position"];

private _spawnName = ["LambsGroupSpawn"] call OKS_fnc_next3DENName;
_position set [2, 0];
private _spawn = create3DENEntity ["Object", "Land_Matches_F", _position];
_spawn set3DENAttribute ["name", _spawnName];
_spawn set3DENAttribute ["hideObject", true];

private _selected = get3DENSelected "object";
private _vehicleClasses = [];
private _unitCount = 0;
private _side = east;
private _cargoCount = 0;

private _sideCandidates = [];

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

{
    private _type = typeOf _x;
    if (_x isKindOf "Man") then {
        _sideCandidates pushBack (side _x);
        _unitCount = _unitCount + 1;
    } else {
        _vehicleClasses pushBack _type;
        _sideCandidates pushBack ([_type] call _fnc_sideFromVehicleClass);
    };
} forEach _selected;

if (_sideCandidates isNotEqualTo []) then {
    private _uniqueSides = [];
    { _uniqueSides pushBackUnique _x } forEach _sideCandidates;
    _side = _uniqueSides select 0;
};

if (_unitCount == 0 && _vehicleClasses isEqualTo []) then {
    _unitCount = 6;
};

// Normalize mode
_mode = toLower _mode;
if !(_mode in ["infantry", "vehicle"]) then {
    _mode = "infantry";
};

// Derive cargo count (vehicle mode). Use minimum transportSoldier across selected vehicle classes.
if (_mode == "vehicle") then {
    private _uniqueVehicleClasses = [];
    { _uniqueVehicleClasses pushBackUnique _x } forEach _vehicleClasses;
    _vehicleClasses = _uniqueVehicleClasses;

    if (_vehicleClasses isEqualTo []) then {
        // No vehicle selected, still produce a reasonable default
        _vehicleClasses = ["O_MRAP_02_hmg_F"]; // editor can change
    };

    private _minTransport = -1;
    {
        private _cfg = configFile >> "CfgVehicles" >> _x;
        private _ts = if (isClass _cfg) then { getNumber (_cfg >> "transportSoldier") } else { 0 };
        if (_minTransport < 0) then { _minTransport = _ts; } else { _minTransport = _minTransport min _ts; };
    } forEach _vehicleClasses;

    _cargoCount = _minTransport max 0;
    if (_cargoCount == 0) then {
        // If config doesn't report cargo well (or technicals), default to 2 rather than 0
        _cargoCount = 2;
    };
};

private _example = "";
private _range = 1500;

if (_mode == "vehicle") then {
    private _vehicleParam = [_vehicleClasses, _cargoCount];
    _example = format [
        "[getPos %1, %2, %3, %4, %5, []] spawn OKS_fnc_Lambs_SpawnGroup;",
        _spawnName,
        str _lambsType,
        str _vehicleParam,
        [_side] call _fnc_sideToCode,
        _range
    ];
} else {
    if (_unitCount <= 0) then { _unitCount = 6; };
    _example = format [
        "[getPos %1, %2, %3, %4, %5, []] spawn OKS_fnc_Lambs_SpawnGroup;",
        _spawnName,
        str _lambsType,
        _unitCount,
        [_side] call _fnc_sideToCode,
        _range
    ];
};
copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);
[format ["CopiedToClipboard: %1", _example], true] call OKS_fnc_LogDebug;
[format ["LAMBS SpawnGroup copied to clipboard | Cache=%1", _cacheCount], 0, 4, true] call BIS_fnc_3DENNotification;
delete3DENEntities _selected;


