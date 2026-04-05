/*
    OKS_fnc_ModuleArtySuppression

    Module function for OKS_Module_ArtySuppression.
    Called by the engine when the module activates (immediate or via synced trigger).

    Sync an artillery vehicle to use it directly. If no vehicle is synced,
    one is spawned from the fallback classname at the module position.
    Sync multiple OKS_Module_ArtyTarget modules to define target positions.
    Targets are fired upon in order, optionally looping.

    Standard module signature: [_logic, _units, _activated]
*/

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (isNull _logic) exitWith {};
if (hasInterface && !isServer) exitWith {};

// --- Read module attributes ---
private _sideStr          = _logic getVariable ["Side", "east"];
private _fallbackVehicle  = _logic getVariable ["FallbackVehicle", "rhs_2s1_tv"];
private _roundsPerTarget  = _logic getVariable ["RoundsPerTarget", 3];
private _timeBetweenRounds = _logic getVariable ["TimeBetweenRounds", 5];
private _unlimitedAmmoStr = _logic getVariable ["UnlimitedAmmo", "yes"];
private _shouldLoopStr    = _logic getVariable ["ShouldLoop", "yes"];
private _loopDelay        = _logic getVariable ["LoopDelay", 120];
private _shouldMarkStr    = _logic getVariable ["ShouldMark", "yes"];
private _delay            = _logic getVariable ["Delay", 0];

// --- Resolve side ---
private _side = switch (toLower _sideStr) do {
    case "west":        { west };
    case "east":        { east };
    case "independent": { independent };
    default             { east };
};

// --- Resolve booleans ---
private _unlimitedAmmo = (toLower _unlimitedAmmoStr) == "yes";
private _shouldLoop = (toLower _shouldLoopStr) == "yes";
private _shouldMark = (toLower _shouldMarkStr) == "yes";

// --- Delay ---
if (_delay > 0) then { sleep _delay; };

// --- Resolve synced objects ---
private _syncedTargets = [];
private _syncedVehicle = objNull;
{
    if (typeOf _x == "OKS_Module_ArtyTarget") then {
        _syncedTargets pushBack _x;
    } else {
        if (!(_x isKindOf "Logic") && !(_x isKindOf "EmptyDetector")) then {
            _syncedVehicle = _x;
        };
    };
} forEach (synchronizedObjects _logic);

// --- Resolve artillery vehicle ---
private _artyObj = objNull;
if (!isNull _syncedVehicle) then {
    _artyObj = _syncedVehicle;
    format ["[Module ArtySuppression] Using synced vehicle: %1 (%2) at %3", typeOf _syncedVehicle, _syncedVehicle, getPosATL _syncedVehicle] spawn OKS_fnc_LogDebug;
} else {
    private _spawnPos = getPosATL _logic;
    _spawnPos set [2, 0];
    _artyObj = createVehicle [_fallbackVehicle, _spawnPos, [], 0, "CAN_COLLIDE"];
    if (isNull _artyObj) exitWith {
        format ["[Module ArtySuppression] ERROR: Failed to spawn vehicle %1", _fallbackVehicle] spawn OKS_fnc_LogDebug;
    };
    _artyObj setDir (getDir _logic);
    format ["[Module ArtySuppression] Spawned artillery: %1 at %2", _fallbackVehicle, _spawnPos] spawn OKS_fnc_LogDebug;
};

// --- Resolve target positions from synced ArtyTarget modules ---
private _targetPositions = [];
{
    private _pos = getPosATL _x;
    _pos set [2, 0];
    _targetPositions pushBack _pos;
} forEach _syncedTargets;

if (_targetPositions isEqualTo []) then {
    systemChat "[ArtySuppression Module] Missing synchronized ArtyTarget(s) — sync one or more OKS_Module_ArtyTarget to define target positions.";
    "[Module ArtySuppression] WARNING: No synced ArtyTarget modules found, using module position as target" spawn OKS_fnc_LogDebug;
    private _pos = getPosATL _logic;
    _pos set [2, 0];
    _targetPositions pushBack _pos;
};

// --- Build args and call core script ---
private _args = [
    _artyObj,
    _targetPositions,
    _side,
    _roundsPerTarget,
    _timeBetweenRounds,
    _unlimitedAmmo,
    _shouldLoop,
    _loopDelay,
    _shouldMark
];

format ["[Module ArtySuppression] Executing with %1 targets, rounds=%2, loop=%3", count _targetPositions, _roundsPerTarget, _shouldLoop] spawn OKS_fnc_LogDebug;

_args spawn OKS_fnc_ArtySuppression;

// Clean up target modules
{
    deleteVehicle _x;
} forEach _syncedTargets;

// Clean up module logic
deleteVehicle _logic;
