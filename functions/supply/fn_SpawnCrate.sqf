/*
    OKS_fnc_spawnCrate
    Spawns a crate at a safe position near the target object.

    Usage:
        [_target, "CrateClassName"] call OKS_fnc_spawnCrate;

    Params:
        _target: OBJECT - The object at whose position the crate will spawn (e.g., the supply station).
        _crateClass: STRING - The class name of the crate to spawn.

	Returns:
		_Crate: OBJECT - The created crate.
*/

params ["_target", "_crateClass"];

// Safety checks
if (isNull _target) exitWith { diag_log "OKS_fnc_spawnCrate: Target is null!"; };
if (typeName _crateClass != "STRING") exitWith { diag_log "OKS_fnc_spawnCrate: Crate class must be a string!"; };

private _center = getPosATL _target;
private _dir = getDir _target;
private _safePos = [_center, 0, 10, 2, 0, 0, 0] call BIS_fnc_findSafePos;
private _crate = objNull;

if (count _safePos == 0) then {
    _crate = createVehicle [_crateClass, _center, [], 0, "NONE"];
} else {
	_crate = createVehicle [_crateClass, _safePos, [], 0, "CAN_COLLIDE"];
};

_crate setDir _dir;
_crate spawn {
    sleep 3;
    [_this, true, [0,1,1], 0, true, true] call ace_dragging_fnc_setCarryable;
};
_crate
