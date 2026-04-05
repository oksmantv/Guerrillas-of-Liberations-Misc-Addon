/*
    OKS_fnc_ModuleRadar

    Module function for OKS_Module_Radar.
    Called by the engine when the module activates (immediate or via synced trigger).

    Sync a crewed radar vehicle to use it directly. If no vehicle is synced,
    one is spawned from the fallback classname at the module position.
    The radar vehicle MUST have crew — the core script exits if unmanned.

    Standard module signature: [_logic, _units, _activated]
*/

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (isNull _logic) exitWith {};
if (hasInterface && !isServer) exitWith {};

// --- Read module attributes ---
private _fallbackVehicle  = _logic getVariable ["FallbackVehicle", "O_Radar_System_02_F"];
private _aaaClassnamesStr = _logic getVariable ["AAAClassnames", "rhsgref_ins_zsu234"];
private _shareDistance     = _logic getVariable ["ShareDistance", 2000];
private _maxRangeAAA       = _logic getVariable ["MaxRangeAAA", 2500];
private _minimumAltitude   = _logic getVariable ["MinimumAltitude", 100];
private _delay             = _logic getVariable ["Delay", 0];

// --- Parse comma-separated classnames ---
private _aaaClassnames = [];
{
    private _s = _x trim [" ", 0] trim [" ", 1];
    if (_s != "") then { _aaaClassnames pushBack _s; };
} forEach (_aaaClassnamesStr splitString ",;");
if (_aaaClassnames isEqualTo []) then {
    _aaaClassnames = ["rhsgref_ins_zsu234"];
};

// --- Delay ---
if (_delay > 0) then { sleep _delay; };

// --- Resolve synced radar vehicle ---
private _radarObj = objNull;
{
    if (!(_x isKindOf "Logic") && !(_x isKindOf "EmptyDetector")) then {
        _radarObj = _x;
    };
} forEach (synchronizedObjects _logic);

if (isNull _radarObj) then {
    // Fallback: spawn radar at module position
    private _spawnPos = getPosATL _logic;
    _spawnPos set [2, 0];
    _radarObj = createVehicle [_fallbackVehicle, _spawnPos, [], 0, "CAN_COLLIDE"];
    if (isNull _radarObj) exitWith {
        format ["[Module Radar] ERROR: Failed to spawn vehicle %1", _fallbackVehicle] spawn OKS_fnc_LogDebug;
    };
    _radarObj setDir (getDir _logic);
    format ["[Module Radar] Spawned radar: %1 at %2", _fallbackVehicle, _spawnPos] spawn OKS_fnc_LogDebug;
} else {
    format ["[Module Radar] Using synced vehicle: %1 (%2) at %3", typeOf _radarObj, _radarObj, getPosATL _radarObj] spawn OKS_fnc_LogDebug;
};

// --- Build args and call core script ---
private _args = [
    _radarObj,
    _aaaClassnames,
    _shareDistance,
    _maxRangeAAA,
    _minimumAltitude
];

format ["[Module Radar] Executing with args: %1", _args] spawn OKS_fnc_LogDebug;

_args spawn OKS_fnc_Radar;

// Clean up module logic
deleteVehicle _logic;
