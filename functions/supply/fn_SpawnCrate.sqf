/*
    OKS_fnc_spawnCrate
    Spawns a crate at a safe position near the target object.

    Usage:
        [_target, "CrateClassName"] call OKS_fnc_spawnCrate;

    Params:
        _target: OBJECT - The object at whose position the crate will spawn (e.g., the supply station).
        _crateClass: STRING - The class name of the crate to spawn.
        _player: OBJECT (optional) - The player who requested the crate spawn. Default is the first playable unit.
	Returns:
		_Crate: OBJECT - The created crate.
*/

params ["_target", "_crateClass", "_player"];

// Safety checks
if (isNull _target) exitWith { diag_log "OKS_fnc_spawnCrate: Target is null!"; };
if (typeName _crateClass != "STRING") exitWith { diag_log "OKS_fnc_spawnCrate: Crate class must be a string!"; };

private _center = getPosATL _target;
private _dir = getDir _player;
private _safePos = [_center, 0, 10, 2, 0, 0, 0] call BIS_fnc_findSafePos;
private _crate = objNull;

if (count _safePos == 0) then {
    _crate = createVehicle [_crateClass, _center, [], 0, "NONE"];
} else {
	_crate = createVehicle [_crateClass, _safePos, [], 0, "CAN_COLLIDE"];
};

_crate setDir _dir;

if(_crateClass in [
    "GOL_MobileServiceStation",
    "GOL_MedicalResupply_WEST","GOL_TeamResupplybox_WEST","GOL_SpecialistResupplybox_WEST",
    "GOL_MedicalResupply_EAST","GOL_TeamResupplybox_EAST","GOL_SpecialistResupplybox_EAST"
]) then {
    [_crate, _player] spawn {
        Params ["_crate", "_player"];
        _crate disableCollisionWith _crate;
        _crate allowDamage false;
        sleep 0.1;
        _crate setPosATL (_player modelToWorld [0,1.5,0]);
        sleep 0.1;
        [_player, _crate] call ace_dragging_fnc_startCarry;
        sleep 3;
        _crate allowDamage true;
    };
};

_crate
