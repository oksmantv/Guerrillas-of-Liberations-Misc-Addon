/*
 * OKS_fnc_ProxRound_TrackRound
 *
 * CBA per-frame handler that tracks a single autocannon HE projectile
 * and detonates it when it has travelled the zeroing distance from the
 * muzzle position captured at time of fire.
 *
 * Detonation is achieved via setDamage 1, which lets the engine handle
 * the explosion, fragmentation, and effects using the round's own config.
 * If ACE frag is loaded, the projectile is blacklisted first to prevent
 * double-fragmentation.
 *
 * The handler removes itself when the round detonates naturally (hit
 * something before reaching fuse distance), or when fuse distance is met.
 *
 * Called from: CBA_fnc_addPerFrameHandler (started by OKS_fnc_ProxRound_FiredHandler)
 *
 * Arguments:
 * _args  : [projectile <OBJECT>, muzzlePos <ARRAY>, range <NUMBER>]
 * _handle: PFH handle <NUMBER>
 *
 * Return Value:
 * None
 */

params ["_args", "_handle"];
_args params ["_projectile", "_muzzlePos", "_range", "_ammoType"];

// Round hit something naturally before reaching fuse distance — stop tracking
if (isNull _projectile || {!alive _projectile}) exitWith {
    diag_log format ["[TRACKROUND] EXIT: proj gone (null=%1) | handle=%2", isNull _projectile, _handle];
    [_handle] call CBA_fnc_removePerFrameHandler;
};

private _currentPos = getPosASLVisual _projectile;
private _dist = _currentPos vectorDistance _muzzlePos;

// Detonate when the round has travelled the zeroing distance
if (_dist >= _range) then {
    [_handle] call CBA_fnc_removePerFrameHandler;

    diag_log format ["[TRACKROUND] DETONATING | dist=%1 range=%2 ammo=%3", _dist, _range, _ammoType];

    // Interpolate exact detonation position: project from muzzle along flight direction
    // for exactly _range metres, correcting for up-to-one-frame overshoot.
    private _dir = _muzzlePos vectorFromTo _currentPos;
    private _detonatePos = _muzzlePos vectorAdd (_dir vectorMultiply _range);

    // Interceptor — tiny fuel canister placed directly in the round's flight path.
    // setObjectTextureGlobal [""] makes the model invisible while keeping geo LOD (collision).
    // Object is cleaned up 0.1s after creation (round has already impacted by then).
    private _wallPos = _currentPos vectorAdd (_dir vectorMultiply 0.5);
    private _wall = createVehicle ["Land_CanisterFuel_F", ASLToATL _wallPos, [], 0, "FLY"];
    _wall setPosASL _wallPos;
    _wall setObjectTextureGlobal [0, ""];
    [{deleteVehicle (_this select 0)}, [_wall], 0.1] call CBA_fnc_waitAndExecute;

    // Custom APERS charge — full power at range, reduced at <100m to prevent ACE frag lag spike.
    private _shotParents = getShotParents _projectile;
    private _mineClass = if (_range < 100) then {"OKS_ProxMine_AP_Short"} else {"OKS_ProxMine_AP"};
    private _primer = createMine [_mineClass, ASLToATL _detonatePos, [], 0];
    _primer setPosASL _detonatePos;
    _primer setDamage 1;

    diag_log format ["[TRACKROUND] Detonation: wall=%1 primer=%2 pos=%3", _wall, _primer, _detonatePos];
};
