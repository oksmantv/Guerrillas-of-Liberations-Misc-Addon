/*
    OKS_fnc_ModuleAmbientAAA

    Module function for OKS_Module_AmbientAAA.
    Called by the engine when the module activates (immediate or via synced trigger).

    Sync a static weapon or vehicle to use as the AAA platform. If no vehicle
    is synced, one is spawned from the fallback classname at the module position.
    The core script auto-creates crew if the vehicle has no gunner.

    Standard module signature: [_logic, _units, _activated]
*/

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (isNull _logic) exitWith {};
if (hasInterface && !isServer) exitWith {};

// --- Read module attributes ---
private _sideStr         = _logic getVariable ["Side", "east"];
private _fallbackVehicle = _logic getVariable ["FallbackVehicle", "RHS_Ural_Zu23_MSV_01"];
private _isHMGStr        = _logic getVariable ["IsHMG", "no"];
private _range           = _logic getVariable ["Range", 1500];
private _radarStr        = _logic getVariable ["Radar", "yes"];
private _rofStr          = _logic getVariable ["RateOfFire", "3,4,5,6"];
private _timeBetweenShots = _logic getVariable ["TimeBetweenShots", 0];
private _delay           = _logic getVariable ["Delay", 0];

// --- Resolve side ---
private _side = switch (toLower _sideStr) do {
    case "west":        { west };
    case "east":        { east };
    case "independent": { independent };
    default             { east };
};

// --- Resolve booleans ---
private _isHMG = (toLower _isHMGStr) == "yes";
private _radar = (toLower _radarStr) == "yes";

// --- Parse comma-separated rate of fire array ---
private _rof = [];
{
    private _s = _x trim [" ", 0] trim [" ", 1];
    if (_s != "") then {
        private _n = parseNumber _s;
        if (_n > 0) then { _rof pushBack _n; };
    };
} forEach (_rofStr splitString ",;");
if (_rof isEqualTo []) then {
    _rof = [3, 4, 5, 6];
};

// --- Delay ---
if (_delay > 0) then { sleep _delay; };

// --- Resolve synced AAA vehicle ---
private _aaaObj = objNull;
{
    if (!(_x isKindOf "Logic") && !(_x isKindOf "EmptyDetector")) then {
        _aaaObj = _x;
    };
} forEach (synchronizedObjects _logic);

if (isNull _aaaObj) then {
    // Fallback: spawn AAA at module position
    private _spawnPos = getPosATL _logic;
    _spawnPos set [2, 0];
    _aaaObj = createVehicle [_fallbackVehicle, _spawnPos, [], 0, "CAN_COLLIDE"];
    if (isNull _aaaObj) exitWith {
        systemChat format ["[AAA Module] ERROR: Failed to spawn vehicle %1", _fallbackVehicle];
        format ["[Module AmbientAAA] ERROR: Failed to spawn vehicle %1", _fallbackVehicle] spawn OKS_fnc_LogDebug;
    };
    _aaaObj setDir (getDir _logic);
    format ["[Module AmbientAAA] Spawned AAA: %1 at %2", _fallbackVehicle, _spawnPos] spawn OKS_fnc_LogDebug;
} else {
    format ["[Module AmbientAAA] Using synced vehicle: %1 (%2) at %3", typeOf _aaaObj, _aaaObj, getPosATL _aaaObj] spawn OKS_fnc_LogDebug;
};

// --- Build args and call core script ---
// fn_Ambient_AAA params: [arty, side, isHMG, Range, Radar, Rof, TimeBetweenShots]
private _args = [
    _aaaObj,
    _side,
    _isHMG,
    _range,
    _radar,
    _rof,
    _timeBetweenShots
];

format ["[Module AmbientAAA] Executing with args: %1", _args] spawn OKS_fnc_LogDebug;

_args spawn OKS_fnc_Ambient_AAA;

// Clean up module logic
deleteVehicle _logic;
