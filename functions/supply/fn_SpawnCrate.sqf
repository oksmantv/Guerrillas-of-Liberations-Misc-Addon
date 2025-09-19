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

private _dir = getDir _player;
_crate = createVehicle [_crateClass, getPosASL _target, [], 0, "NONE"];
_crate allowDamage false;
_crate hideObjectGlobal true;
_crate setDir _dir;
_crate disableCollisionWith _target;
[_crate, _player, _target] spawn {
    Params ["_crate", "_player", "_target"];
    sleep 0.1;
    private _offset = [0, 1.5, 0];
    if((typeOf _crate) in ["GOL_SquadResupplybox_WEST","GOL_SquadResupplybox_EAST"]) exitWith {
        _checkPos = _target getPos [5, _player getDir _target];
        _safePos = [_checkPos, 3, 4, (sizeof (typeof _crate) + 0.5), 0, 0.5, 0] call BIS_fnc_findSafePos;
        _safePos = ATLToASL _safePos;
        _safePos set [2, 0.05];
        _crate setPosASL _safePos;
        sleep 3;
        _crate allowDamage true;
    };
    _crate setPosASL (_player modelToWorldWorld _offset);
    waitUntil {0.1; _crate distance _player < 5};
    [_player, _crate] call ace_dragging_fnc_startCarry;
    _crate hideObjectGlobal false;
    sleep 3;
    _crate allowDamage true;
};

_crate
