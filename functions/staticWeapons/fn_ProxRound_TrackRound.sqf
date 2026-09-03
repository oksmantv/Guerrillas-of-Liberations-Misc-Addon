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
_args params ["_projectile", "_muzzlePos", "_range", "_ammoType", ["_weaponClass", "", [""]]];

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

    // Weapons whose rounds don't reliably trigger on the invisible canister interceptor.
    // Keyed on weapon classname — one entry covers all vehicle variants using that cannon.
    // Add classnames here as new calibres/platforms are confirmed (check RPT for weapon=%1).
    private _noCanisterList = [
        "rhs_weap_2a42",        // vanilla RHS BMP-2DM
        "GOL_weap_2a42_HE",     // GOL custom HE-only variant
        "autocannon_30mm",      // vanilla A3 30mm (Lynx, Mora, etc.)
        "autocannon_30mm_CTWS"  // vanilla A3 30mm CTWS (AMV-7)
    ];
    private _noCanister = _weaponClass in _noCanisterList;

    // AGL-based mine power scaling — compute before detonation path so no-canister
    // can decide whether to delete the round (only delete if a mine will actually spawn).
    private _terrainH = getTerrainHeightASL [_detonatePos select 0, _detonatePos select 1];
    private _agl = (_detonatePos select 2) - _terrainH;

    private _mineClass = "";
    if (_range < 100) then {
        // Short range: only spawn mine if close to the ground (avoid wasted frag above cover)
        if (_agl <= 5) then { _mineClass = "OKS_ProxMine_40mm_AP_Short" };
    } else {
        _mineClass = switch (true) do {
            case (_agl > 15): { "" };                           // Too high — skip mine entirely
            case (_agl > 10): { "OKS_ProxMine_40mm_AP_High" };  // 10-15m — 25% power
            case (_agl > 5):  { "OKS_ProxMine_40mm_AP_Med" };   // 5-10m  — 50% power
            default           { "OKS_ProxMine_40mm_AP" };        // <= 5m  — full power
        };
    };

    if (_noCanister) then {
        if (_mineClass != "") then {
            // Only delete the round when a mine will replace it visually.
            // If AGL check skips the mine, let the round continue naturally.
            deleteVehicle _projectile;
            private _spawnClass = _mineClass + "_FX";
            private _primer = createMine [_spawnClass, ASLToATL _detonatePos, [], 0];
            _primer setPosASL _detonatePos;
            _primer setDamage 1;
            diag_log format ["[TRACKROUND] No-canister detonation: class=%1 agl=%2m", _spawnClass, _agl];
        } else {
            diag_log format ["[TRACKROUND] No-canister: AGL too high (%1m) — round continues", _agl];
        };
    } else {
        // Interceptor — always blocks the round; native HE explosion provides the visual.
        private _wallPos = _currentPos vectorAdd (_dir vectorMultiply 0.5);
        private _wall = createVehicle ["Land_CanisterFuel_F", ASLToATL _wallPos, [], 0, "FLY"];
        _wall setPosASL _wallPos;
        _wall setObjectTextureGlobal [0, ""];
        [{deleteVehicle (_this select 0)}, [_wall], 0.1] call CBA_fnc_waitAndExecute;

        if (_mineClass != "") then {
            private _primer = createMine [_mineClass, ASLToATL _detonatePos, [], 0];
            _primer setPosASL _detonatePos;
            _primer setDamage 1;
            diag_log format ["[TRACKROUND] Canister detonation: class=%1 agl=%2m", _mineClass, _agl];
        } else {
            diag_log format ["[TRACKROUND] Canister only — AGL too high for mine (%1m)", _agl];
        };
    };

    diag_log format ["[TRACKROUND] Complete: weapon=%1 agl=%2m noCanister=%3", _weaponClass, _agl, _noCanister];
};
