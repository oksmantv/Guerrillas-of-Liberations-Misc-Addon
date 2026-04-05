/*
    OKS_fnc_ModuleAirBase

    Module function for OKS_Module_AirBase.
    Called by the engine when the module activates (immediate or via synced trigger).

    The module's area (canSetArea) defines the reinforcement zone — a trigger is
    created at runtime using the module's area dimensions. This gives Eden users
    the drag-resize area handles to visualize and adjust the zone.

    Required synced objects:
      - A destructible object (base) — when destroyed, spawning stops.
      - An OKS_Module_SpawnPoint — defines helicopter spawn position/direction.

    Standard module signature: [_logic, _units, _activated]
*/

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (isNull _logic) exitWith {};
if (hasInterface && !isServer) exitWith {};

// --- Read module attributes ---
private _sideStr            = _logic getVariable ["Side", "east"];
private _helicopterClassStr = _logic getVariable ["HelicopterClass", "O_Heli_Light_02_unarmed_F"];
private _insertType         = _logic getVariable ["InsertType", "unload"];
private _numGroups          = _logic getVariable ["NumGroups", 2];
private _cargoPercent       = _logic getVariable ["CargoPercent", 100];
private _respawnTimer       = _logic getVariable ["RespawnTimer", 900];
private _randomDistanceLZ   = _logic getVariable ["RandomDistanceLZ", 200];
private _refreshRate        = _logic getVariable ["RefreshRate", 90];
private _respawnCount       = _logic getVariable ["RespawnCount", 5];
private _delay              = _logic getVariable ["Delay", 0];

// --- Resolve side ---
private _side = switch (toLower _sideStr) do {
    case "west":        { west };
    case "east":        { east };
    case "independent": { independent };
    default             { east };
};

// --- Parse helicopter classnames (comma-separated for random selection) ---
private _helicopterClasses = [];
{
    private _s = _x trim [" ", 0] trim [" ", 1];
    if (_s != "") then { _helicopterClasses pushBack _s; };
} forEach (_helicopterClassStr splitString ",;");
if (_helicopterClasses isEqualTo []) then {
    _helicopterClasses = ["O_Heli_Light_02_unarmed_F"];
};

// Core script accepts string or array — use array if multiple, string if single
private _classParam = if (count _helicopterClasses == 1) then { _helicopterClasses select 0 } else { _helicopterClasses };

// --- Convert cargo percent from 0-100 to 0-1 ---
private _cargoFraction = (_cargoPercent max 0 min 100) / 100;

// --- Resolve synced objects ---
private _baseObj = objNull;
private _spawnPoint = objNull;
{
    if (typeOf _x == "OKS_Module_SpawnPoint") then {
        _spawnPoint = _x;
    } else {
        if (!(_x isKindOf "Logic") && !(_x isKindOf "EmptyDetector")) then {
            _baseObj = _x;
        };
    };
} forEach (synchronizedObjects _logic);

// --- Validate required syncs ---
if (isNull _baseObj) exitWith {
    systemChat "[AirBase Module] Missing synchronized Base Object — sync a destructible object (building, helipad, etc.) that acts as the base.";
    "[Module AirBase] ERROR: No synced base object found" spawn OKS_fnc_LogDebug;
};

if (isNull _spawnPoint) exitWith {
    systemChat "[AirBase Module] Missing synchronized SpawnPoint — sync an OKS_Module_SpawnPoint to define the helicopter spawn position.";
    "[Module AirBase] ERROR: No synced SpawnPoint found" spawn OKS_fnc_LogDebug;
};

// --- Delay ---
if (_delay > 0) then { sleep _delay; };

// --- Create runtime trigger from module area ---
// Module area: [a, b, angle, isRectangle, c]
private _area = _logic getVariable ["objectArea", [5000, 5000, 0, false, -1]];
_area params ["_a", "_b", "_angle", "_isRect"];

private _triggerPos = getPosATL _logic;
_triggerPos set [2, 0];
private _reinforceTrigger = createTrigger ["EmptyDetector", _triggerPos, false];
_reinforceTrigger setTriggerArea [_a, _b, _angle, _isRect];
_reinforceTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];

format ["[Module AirBase] Created reinforcement zone trigger at %1, area=[%2, %3, %4, rect=%5]", _triggerPos, _a, _b, _angle, _isRect] spawn OKS_fnc_LogDebug;

// --- Build args and call core script ---
// fn_Airbase params: [Object, SpawnPos, ReinforcementZone, Side, Classname, Type, Troops, RespawnTimer, RandomDistanceLZ, RefreshRate, RespawnCount]
private _args = [
    _baseObj,
    _spawnPoint,
    _reinforceTrigger,
    _side,
    _classParam,
    _insertType,
    [_numGroups, _cargoFraction],
    _respawnTimer,
    _randomDistanceLZ,
    _refreshRate,
    _respawnCount
];

format ["[Module AirBase] Executing with base=%1, spawn=%2, side=%3, heli=%4, type=%5, waves=%6", _baseObj, _spawnPoint, _side, _classParam, _insertType, _respawnCount] spawn OKS_fnc_LogDebug;

_args spawn OKS_fnc_Airbase;

// Clean up module logic (delayed — core reads trigger immediately)
[_logic] spawn {
    params ["_logic"];
    sleep 15;
    deleteVehicle _logic;
    // Note: do NOT delete _spawnPoint — core script uses it throughout its lifetime
};
