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

private _center = [0,0,0];
private _dir = getDir _player;
private _safePos = [_center, 0, 10, 2, 0, 0, 0] call BIS_fnc_findSafePos;
_crate = createVehicle [_crateClass, _safePos, [], 0, "CAN_COLLIDE"];
_crate allowDamage false;
_crate setDir _dir;
_crate disableCollisionWith _target;
[_crate, _player] spawn {
    Params ["_crate", "_player"];
    sleep 0.1;
    private _offset = [0, 1.5, 0];
    if(typeOf _crate in ["",""]) then {
        _offset = [0,2.5,0];
    };
    _crate setPosATL (_player modelToWorld _offset);
    waitUntil {0.1; _crate distance _player < 5};
    [_player, _crate] call ace_dragging_fnc_startCarry;
    sleep 3;
    _crate allowDamage true;
};

_crate
