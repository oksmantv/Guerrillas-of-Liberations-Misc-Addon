/*
    OKS_fnc_ModuleArtyFire

    Module function for OKS_Module_ArtyFire.
    Called by the engine when the module activates (immediate or via synced trigger).

    Sync an artillery vehicle to use it directly. If no vehicle is synced,
    one is spawned from the fallback classname at the module position.
    Sync an OKS_Module_ArtyTarget for the impact position.

    Standard module signature: [_logic, _units, _activated]
*/

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (isNull _logic) exitWith {};
if (hasInterface && !isServer) exitWith {};

// --- Read module attributes ---
private _sideStr        = _logic getVariable ["Side", "east"];
private _fallbackVehicle = _logic getVariable ["FallbackVehicle", "rhs_2s1_tv"];
private _rounds         = _logic getVariable ["Rounds", 7];
private _rearmTime      = _logic getVariable ["RearmTime", 300];
private _reloadTime     = _logic getVariable ["ReloadTime", 30];
private _fullCrewStr    = _logic getVariable ["FullCrew", "no"];
private _delay          = _logic getVariable ["Delay", 0];

// --- Resolve side ---
private _side = switch (toLower _sideStr) do {
    case "west":        { west };
    case "east":        { east };
    case "independent": { independent };
    default             { east };
};

// --- Resolve full crew bool ---
private _fullCrew = (toLower _fullCrewStr) == "yes";

// --- Delay ---
if (_delay > 0) then { sleep _delay; };

// --- Resolve synced objects ---
private _syncedTarget = objNull;
private _syncedVehicle = objNull;
{
    if (typeOf _x == "OKS_Module_ArtyTarget") then {
        _syncedTarget = _x;
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
    format ["[Module ArtyFire] Using synced vehicle: %1 (%2) at %3", typeOf _syncedVehicle, _syncedVehicle, getPosATL _syncedVehicle] spawn OKS_fnc_LogDebug;
} else {
    private _spawnPos = getPosATL _logic;
    _spawnPos set [2, 0];
    _artyObj = createVehicle [_fallbackVehicle, _spawnPos, [], 0, "CAN_COLLIDE"];
    if (isNull _artyObj) exitWith {
        format ["[Module ArtyFire] ERROR: Failed to spawn vehicle %1", _fallbackVehicle] spawn OKS_fnc_LogDebug;
    };
    _artyObj setDir (getDir _logic);
    format ["[Module ArtyFire] Spawned artillery: %1 at %2", _fallbackVehicle, _spawnPos] spawn OKS_fnc_LogDebug;
};

// --- Resolve target position ---
if (isNull _syncedTarget) then {
    systemChat "[ArtyFire Module] Missing synchronized ArtyTarget — sync an OKS_Module_ArtyTarget to define the impact position.";
    "[Module ArtyFire] ERROR: No synced ArtyTarget found" spawn OKS_fnc_LogDebug;
};
private _targetPos = if (!isNull _syncedTarget) then {
    getPosATL _syncedTarget
} else {
    getPosATL _logic
};
_targetPos set [2, 0];

// --- Build args and call core script ---
private _args = [
    _side,
    _artyObj,
    _targetPos,
    _rounds,
    _rearmTime,
    _reloadTime,
    _fullCrew
];

format ["[Module ArtyFire] Executing with args: %1", _args] spawn OKS_fnc_LogDebug;

_args spawn OKS_fnc_ArtyFire;

// Clean up target module if present
if (!isNull _syncedTarget) then {
    deleteVehicle _syncedTarget;
};

// Clean up module logic
deleteVehicle _logic;
