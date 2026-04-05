/*
    OKS_fnc_ModuleConvoy

    Module function for OKS_Module_Convoy.
    Called by the engine when the module activates (immediate or via synced trigger).

    Waypoint chain: sync the main module to OKS_Module_ConvoyWaypoint modules.
    Each waypoint syncs to the next in a chain. The last one must have Type=End.
    The chain is followed: Main → WP1 → WP2 → ... → End.

    Synced non-Logic, non-waypoint vehicles are used for classname extraction
    (vehicles are deleted, classnames passed to core script).

    Standard module signature: [_logic, _units, _activated]
*/

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (isNull _logic) exitWith {};
if (hasInterface && !isServer) exitWith {};

// --- Read module attributes ---
private _sideStr            = _logic getVariable ["Side", "east"];
private _vehicleCount       = _logic getVariable ["VehicleCount", 4];
private _vehicleClassStr    = _logic getVariable ["VehicleClassnames", "O_MRAP_02_F"];
private _speedKph           = _logic getVariable ["SpeedKph", 35];
private _dispersion         = _logic getVariable ["Dispersion", 50];
private _parkingDispersion  = _logic getVariable ["ParkingDispersion", 30];
private _spawnCargoStr      = _logic getVariable ["SpawnCargo", "yes"];
private _cargoCount         = _logic getVariable ["CargoCount", 6];
private _forcedCarelessStr  = _logic getVariable ["ForcedCareless", "no"];
private _deleteAtFinalStr   = _logic getVariable ["DeleteAtFinalWP", "no"];
private _dismountBehaviour  = _logic getVariable ["DismountBehaviour", "rush"];
private _parkingMode        = _logic getVariable ["ParkingMode", "alternate"];
private _delay              = _logic getVariable ["Delay", 0];

// --- Resolve side ---
private _side = switch (toLower _sideStr) do {
    case "west":        { west };
    case "east":        { east };
    case "independent": { independent };
    default             { east };
};

// --- Parse comma-separated vehicle classnames ---
private _vehicleClassnames = [];
{
    private _s = _x trim [" ", 0] trim [" ", 1];
    if (_s != "") then { _vehicleClassnames pushBack _s; };
} forEach (_vehicleClassStr splitString ",;");
if (_vehicleClassnames isEqualTo []) then {
    _vehicleClassnames = ["O_MRAP_02_F"];
};

// --- Resolve booleans ---
private _spawnCargo = (toLower _spawnCargoStr) == "yes";
private _forcedCareless = (toLower _forcedCarelessStr) == "yes";
private _deleteAtFinal = (toLower _deleteAtFinalStr) == "yes";

// --- Delay ---
if (_delay > 0) then { sleep _delay; };

// --- Walk the waypoint chain ---
// Synced objects of the main module: find ConvoyWaypoint modules and other vehicles
private _waypointModules = [];
private _endModule = objNull;
private _syncedVehicles = [];

// Recursive chain walker: follow sync lines from module to module
private _visited = [_logic];

private _collectChain = {
    params ["_current"];
    {
        if (_x in _visited) then { continue; };
        _visited pushBack _x;

        if (typeOf _x == "OKS_Module_ConvoyWaypoint") then {
            private _wpType = _x getVariable ["WaypointType", "waypoint"];
            if (toLower _wpType == "end") then {
                _endModule = _x;
            } else {
                _waypointModules pushBack _x;
                // Follow the chain from this waypoint
                [_x] call _collectChain;
            };
        } else {
            if (!(_x isKindOf "Logic") && !(_x isKindOf "EmptyDetector")) then {
                _syncedVehicles pushBack _x;
            };
        };
    } forEach (synchronizedObjects _current);
};

[_logic] call _collectChain;

// --- Override vehicle classnames from synced vehicles if any ---
if (_syncedVehicles isNotEqualTo []) then {
    _vehicleClassnames = _syncedVehicles apply { typeOf _x };
    _vehicleCount = count _vehicleClassnames;
    // Delete synced vehicles (core script spawns fresh ones)
    {
        private _crewToDelete = crew _x;
        { deleteVehicle _x } forEach _crewToDelete;
        deleteVehicle _x;
    } forEach _syncedVehicles;
    format ["[Module Convoy] Using synced vehicle classnames: %1", _vehicleClassnames] spawn OKS_fnc_LogDebug;
};

// --- Build spawn position object ---
// Pass _logic directly — core script uses getDir/getPos on it

// --- Build waypoint objects array ---
private _waypointArg = [];
if (_waypointModules isNotEqualTo []) then {
    _waypointArg = _waypointModules;
};

// --- Resolve end object ---
private _endObj = objNull;
if (!isNull _endModule) then {
    _endObj = _endModule;
} else {
    systemChat "[Convoy Module] Missing End waypoint — sync a chain of OKS_Module_ConvoyWaypoint modules with at least one set to Type=End.";
    "[Module Convoy] WARNING: No End waypoint found, using module position" spawn OKS_fnc_LogDebug;
    _endObj = _logic;
};

// --- Build vehicle params ---
private _vehParams = [_vehicleCount, _vehicleClassnames, _speedKph, _dispersion, _parkingDispersion];
private _cargoParams = [_spawnCargo, _cargoCount];
private _dismountTypes = [_dismountBehaviour];

// --- Build args and call core script ---
private _args = [
    _logic,
    if (_waypointArg isEqualTo []) then { nil } else { _waypointArg },
    _endObj,
    _side,
    _vehParams,
    _cargoParams,
    [],
    _forcedCareless,
    _deleteAtFinal,
    _dismountTypes,
    _parkingMode
];

format ["[Module Convoy] Executing with vehParams=%1, cargoParams=%2, waypointCount=%3, parkingMode=%4", _vehParams, _cargoParams, count _waypointModules, _parkingMode] spawn OKS_fnc_LogDebug;

_args spawn OKS_fnc_Convoy_Spawn;

// Delay cleanup — core script references getPos/getDir on spawn/waypoint/end objects over time
[_logic] spawn {
    params ["_logic"];
    sleep 120;
    deleteVehicle _logic;
};
