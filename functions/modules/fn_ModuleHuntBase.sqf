/*
    OKS_fnc_ModuleHuntBase

    Module function for OKS_Module_HuntBase.
    Called by the engine when the module activates (immediate or via synced trigger).

    The module's area (canSetArea) defines the hunt zone — a trigger is created at
    runtime using the module's area dimensions. This gives Eden users the drag-resize
    area handles to visualize and adjust the zone.

    Required synced objects:
      - A destructible object (base) — when destroyed, spawning stops.
      - An OKS_Module_SpawnPoint — defines spawn position/direction for units/vehicles.

    Standard module signature: [_logic, _units, _activated]
*/

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (isNull _logic) exitWith {};
if (hasInterface && !isServer) exitWith {};

// --- Read module attributes ---
private _sideStr           = _logic getVariable ["Side", "east"];
private _soldiers          = _logic getVariable ["Soldiers", 6];
private _vehicleClassStr   = _logic getVariable ["VehicleClassnames", ""];
private _waves             = _logic getVariable ["Waves", 5];
private _respawnDelay      = _logic getVariable ["RespawnDelay", 900];
private _refreshRate       = _logic getVariable ["RefreshRate", 120];
private _deployFlareStr    = _logic getVariable ["DeployFlare", "yes"];
private _waypointBehaviour = _logic getVariable ["WaypointBehaviour", ""];
private _delay             = _logic getVariable ["Delay", 0];

// --- Resolve side ---
private _side = switch (toLower _sideStr) do {
    case "west":        { west };
    case "east":        { east };
    case "independent": { independent };
    default             { east };
};

// --- Resolve boolean ---
private _shouldDeployFlare = (toLower _deployFlareStr) == "yes";

// --- Parse comma-separated vehicle classnames ---
private _vehicleClasses = [];
{
    private _s = _x trim [" ", 0] trim [" ", 1];
    if (_s != "") then { _vehicleClasses pushBack _s; };
} forEach (_vehicleClassStr splitString ",;");

// --- Determine soldiers parameter for core script ---
// If vehicle classnames provided, use array/string; otherwise use unit count
private _soldiersParam = if (_vehicleClasses isNotEqualTo []) then {
    if (count _vehicleClasses == 1) then { _vehicleClasses select 0 } else { _vehicleClasses }
} else {
    _soldiers
};

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
    systemChat "[HuntBase Module] Missing synchronized Base Object — sync a destructible object (building, vehicle, etc.) that acts as the base.";
    "[Module HuntBase] ERROR: No synced base object found" spawn OKS_fnc_LogDebug;
};

if (isNull _spawnPoint) exitWith {
    systemChat "[HuntBase Module] Missing synchronized SpawnPoint — sync an OKS_Module_SpawnPoint to define the spawn position.";
    "[Module HuntBase] ERROR: No synced SpawnPoint found" spawn OKS_fnc_LogDebug;
};

// --- Delay ---
if (_delay > 0) then { sleep _delay; };

// --- Create runtime trigger from module area ---
// Module area: [a, b, angle, isRectangle, c]
private _area = _logic getVariable ["objectArea", [3000, 3000, 0, false, -1]];
_area params ["_a", "_b", "_angle", "_isRect"];

private _triggerPos = getPosATL _logic;
_triggerPos set [2, 0];
private _huntTrigger = createTrigger ["EmptyDetector", _triggerPos, false];
_huntTrigger setTriggerArea [_a, _b, _angle, _isRect];
_huntTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];

format ["[Module HuntBase] Created hunt zone trigger at %1, area=[%2, %3, %4, rect=%5]", _triggerPos, _a, _b, _angle, _isRect] spawn OKS_fnc_LogDebug;

// --- Resolve waypoint behaviour (nil = auto in core script) ---
private _wpBehaviour = if (_waypointBehaviour == "" || _waypointBehaviour == "auto") then { nil } else { _waypointBehaviour };

// --- Build args and call core script ---
// fn_HuntBase params: [Base, SpawnPos, HuntZone, Waves, RespawnDelay, Side, Soldiers, RefreshRate, ShouldDeployFlare, WaypointBehaviour]
private _args = [
    _baseObj,
    _spawnPoint,
    _huntTrigger,
    _waves,
    _respawnDelay,
    _side,
    _soldiersParam,
    _refreshRate,
    _shouldDeployFlare
];

// Append waypoint behaviour only if explicitly set (nil = auto)
if (!isNil "_wpBehaviour") then {
    _args pushBack _wpBehaviour;
};

format ["[Module HuntBase] Executing with base=%1, spawn=%2, side=%3, soldiers=%4, waves=%5", _baseObj, _spawnPoint, _side, _soldiersParam, _waves] spawn OKS_fnc_LogDebug;

_args spawn OKS_fnc_HuntBase;

// Clean up module logic and spawn point (delayed — core script reads position initially)
[_logic, _spawnPoint] spawn {
    params ["_logic", "_sp"];
    sleep 15;
    deleteVehicle _logic;
    // Note: do NOT delete _spawnPoint — core script uses it throughout its lifetime
    // for getPos/getDir on every spawn cycle.
};
