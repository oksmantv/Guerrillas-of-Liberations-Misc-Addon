/*
    OKS_fnc_ModuleLambsSpawnGroup

    Module function for OKS_Module_LambsSpawnGroup.
    Called by the engine when the module activates (immediate or via synced trigger).

    Infantry mode: spawns a group of _UnitCount infantry at module position.
    Vehicle mode: uses synced vehicle classnames (vehicles are deleted, classnames
    passed to core script which spawns fresh ones with crew). If no vehicles are
    synced, uses the FallbackVehicle classname.

    Standard module signature: [_logic, _units, _activated]
*/

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (isNull _logic) exitWith {};
if (hasInterface && !isServer) exitWith {};

// --- Read module attributes ---
private _mode           = _logic getVariable ["Mode", "infantry"];
private _lambsType      = _logic getVariable ["LambsType", "rush"];
private _sideStr        = _logic getVariable ["Side", "east"];
private _unitCount      = _logic getVariable ["UnitCount", 6];
private _fallbackVehicle = _logic getVariable ["FallbackVehicle", "O_MRAP_02_hmg_F"];
private _cargoCount     = _logic getVariable ["CargoCount", 2];
private _range          = _logic getVariable ["Range", 1500];
private _delay          = _logic getVariable ["Delay", 0];

// --- Resolve side ---
private _side = switch (toLower _sideStr) do {
    case "west":        { west };
    case "east":        { east };
    case "independent": { independent };
    default             { east };
};

// --- Resolve synced vehicles (vehicle mode) — before delay so they disappear immediately ---
private _vehicleClassnames = [];
private _syncedVehicles = [];
{
    if (!(_x isKindOf "Logic") && !(_x isKindOf "EmptyDetector")) then {
        _syncedVehicles pushBack _x;
        _vehicleClassnames pushBack (typeOf _x);
    };
} forEach (synchronizedObjects _logic);

// In vehicle mode, use the first synced vehicle's position/direction as spawn point
// then delete all synced vehicles (we only need classnames + location)
private _spawnObj = _logic;
if (toLower _mode == "vehicle" && {_syncedVehicles isNotEqualTo []}) then {
    private _templateVeh = _syncedVehicles select 0;
    // Move module logic to the vehicle's position and direction so the core script reads it
    _logic setPosATL (getPosATL _templateVeh);
    _logic setDir (getDir _templateVeh);
    format ["[Module LambsSpawnGroup] Using synced vehicle position: %1, dir: %2", getPosATL _templateVeh, getDir _templateVeh] spawn OKS_fnc_LogDebug;

    {
        private _crewToDelete = crew _x;
        { deleteVehicle _x } forEach _crewToDelete;
        deleteVehicle _x;
    } forEach _syncedVehicles;
};

// --- Delay ---
if (_delay > 0) then { sleep _delay; };

// --- Build third parameter based on mode ---
private _thirdParam = 0;

if (toLower _mode == "vehicle") then {
    if (_vehicleClassnames isEqualTo []) then {
        _vehicleClassnames = [_fallbackVehicle];
    };
    _thirdParam = [_vehicleClassnames, _cargoCount];
    format ["[Module LambsSpawnGroup] Vehicle mode: classes=%1, cargo=%2", _vehicleClassnames, _cargoCount] spawn OKS_fnc_LogDebug;
} else {
    _thirdParam = _unitCount;
    format ["[Module LambsSpawnGroup] Infantry mode: unitCount=%1", _unitCount] spawn OKS_fnc_LogDebug;
};

// --- Build args and call core script ---
// Pass _logic as object so the core script can use getDir/getPosATL
private _args = [
    _logic,
    _lambsType,
    _thirdParam,
    _side,
    _range,
    []
];

format ["[Module LambsSpawnGroup] Executing with args: %1", _args] spawn OKS_fnc_LogDebug;

_args spawn OKS_fnc_Lambs_SpawnGroup;

// Delay cleanup — the spawned script needs _logic for getDir/getPosATL
[_logic] spawn {
    params ["_logic"];
    sleep 10;
    deleteVehicle _logic;
};
