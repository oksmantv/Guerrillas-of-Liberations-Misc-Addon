/*
    OKS_fnc_ModuleMortars

    Module function for OKS_Module_Mortars.
    Called by the engine when the module activates (immediate or via synced trigger).

    If a mortar/artillery vehicle is synced to this module, it is used directly
    as the firing platform. Otherwise, the Vehicle Class fallback classname is
    spawned at the module position.

    Standard module signature: [_logic, _units, _activated]
*/

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (isNull _logic) exitWith {};
if (hasInterface && !isServer) exitWith {};

// --- Read module attributes ---
private _platform      = _logic getVariable ["Platform", "manned"];
private _vehicleClass  = _logic getVariable ["FallbackVehicle", "O_Mortar_01_F"];
private _sideStr       = _logic getVariable ["Side", "east"];
private _firingMode    = _logic getVariable ["FiringMode", "precise"];
private _roundType     = _logic getVariable ["RoundType", "light"];
private _targeting     = _logic getVariable ["Targeting", "designated"];
private _inaccuracy    = _logic getVariable ["Inaccuracy", 50];
private _minRange      = _logic getVariable ["MinRange", 150];
private _maxRange      = _logic getVariable ["MaxRange", 400];
private _ammo          = _logic getVariable ["Ammo", 20];
private _roundInterval = _logic getVariable ["RoundInterval", -1];
private _roundCount    = _logic getVariable ["RoundCount", -1];
private _delay         = _logic getVariable ["Delay", 0];

// --- Resolve side ---
private _side = switch (toLower _sideStr) do {
    case "west":        { west };
    case "east":        { east };
    case "independent": { independent };
    default             { east };
};

// --- Delay ---
if (_delay > 0) then { sleep _delay; };

// --- Resolve synced objects ---
private _syncedTarget = objNull;
private _syncedVehicle = objNull;
{
    if (typeOf _x == "OKS_Module_MortarTarget") then {
        _syncedTarget = _x;
    } else {
        if (!(_x isKindOf "Logic") && !(_x isKindOf "EmptyDetector")) then {
            _syncedVehicle = _x;
        };
    };
} forEach (synchronizedObjects _logic);

// --- Resolve mortar argument ---
private _mortarArg = "OffMap";
private _platformLower = toLower _platform;

if (_platformLower == "manned") then {
    if (!isNull _syncedVehicle) then {
        // Use the synced vehicle directly
        _mortarArg = _syncedVehicle;
        format ["[Module Mortars] Using synced vehicle: %1 (%2) at %3", typeOf _syncedVehicle, _syncedVehicle, getPosATL _syncedVehicle] spawn OKS_fnc_LogDebug;
    } else {
        // Fallback: spawn from classname at module position
        private _spawnPos = getPosATL _logic;
        _spawnPos set [2, 0];
        _mortarArg = createVehicle [_vehicleClass, _spawnPos, [], 0, "CAN_COLLIDE"];
        if (isNull _mortarArg) exitWith {
            format ["[Module Mortars] ERROR: Failed to spawn vehicle %1", _vehicleClass] spawn OKS_fnc_LogDebug;
        };
        _mortarArg setDir (getDir _logic);
        format ["[Module Mortars] Spawned mortar: %1 at %2", _vehicleClass, _spawnPos] spawn OKS_fnc_LogDebug;
    };
};

// --- Resolve position argument ---
private _posArg = [];

if (toLower _targeting == "auto") then {
    _posArg = ["auto", _inaccuracy];
} else {
    // Designated: use synced target module position, fallback to module position
    private _targetPos = if (!isNull _syncedTarget) then {
        getPosATL _syncedTarget
    } else {
        "[Module Mortars] WARNING: No synced MortarTarget found, using module position as target" spawn OKS_fnc_LogDebug;
        getPosATL _logic
    };
    _targetPos set [2, 0];
    _posArg = [_targetPos, _inaccuracy];
};

// --- Build and execute ---
private _args = [
    _mortarArg,
    _side,
    _firingMode,
    _roundType,
    _posArg,
    _minRange,
    _maxRange,
    _ammo,
    _roundInterval,
    _roundCount
];

format ["[Module Mortars] Executing with args: %1", _args] spawn OKS_fnc_LogDebug;

_args spawn OKS_fnc_Mortars;

// Clean up target module if present
if (!isNull _syncedTarget) then {
    deleteVehicle _syncedTarget;
};

// Clean up main module logic
deleteVehicle _logic;
