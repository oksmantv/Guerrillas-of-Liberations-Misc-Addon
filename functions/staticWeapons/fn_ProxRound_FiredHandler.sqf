/*
 * OKS_fnc_ProxRound_FiredHandler
 *
 * Fired event handler for the IFV autocannon proximity fuse system.
 *
 * Runs on the local machine (client or server) that currently holds
 * vehicle locality. Checks whether the round qualifies for proximity
 * detonation and, if so, records the muzzle position and zeroing distance
 * at the instant of fire, then starts a CBA per-frame tracker.
 *
 * Qualifying rounds must satisfy both:
 *   caliber >= OKS_ProxRound_Calibre  (default 4, approx. 20 mm+)
 *   indirectHit > 0                   (HE / HEAB / HEDP; excludes pure AP / APFSDS)
 *
 * Called from: Fired EH added by OKS_fnc_ProxRound_Init
 *
 * Arguments:
 * Fired EH params — [vehicle, weapon, muzzle, mode, ammo, magazine, projectile, gunner]
 *
 * Return Value:
 * None
 */

params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

private _debug = missionNamespace getVariable ["OKS_ProxRound_Debug", false];
if (_debug) then {
    diag_log format ["[PROXROUND] FiredEH called | veh=%1 ammo=%2 local_gunner=%3 active=%4 zeroing=%5",
        typeOf _vehicle, _ammo, local _gunner,
        _vehicle getVariable ["OKS_ProxRound_Active", false],
        currentZeroing _gunner];
};

// Only process on the machine where the gunner is local.
// The projectile simulation lives on the same machine as its firer.
// In SP this is always the local machine; on dedi the server exits here
// and the gunner's client (where the EH was also added) processes it.
if !(local _gunner) exitWith {
    if (_debug) then { diag_log "[PROXROUND] EXIT: gunner not local"; };
};

// Proximity fuse must be explicitly enabled by the gunner
if !(_vehicle getVariable ["OKS_ProxRound_Active", false]) exitWith {
    if (_debug) then { diag_log "[PROXROUND] EXIT: fuse not active"; };
};

// --- Ammo auto-detection ---

// Must produce area damage — excludes pure AP / APFSDS (indirectHit = 0)
if (getNumber (configFile >> "CfgAmmo" >> _ammo >> "indirectHit") <= 0) exitWith {
    if (_debug) then { diag_log format ["[PROXROUND] EXIT: indirectHit=0 for %1", _ammo]; };
};

// Must have an explosive charge — excludes APFSDS that has non-zero indirectHit in config
if (getNumber (configFile >> "CfgAmmo" >> _ammo >> "explosive")   <= 0) exitWith {
    if (_debug) then { diag_log format ["[PROXROUND] EXIT: explosive=0 for %1", _ammo]; };
};

// Weapon class ignore list — missiles, ATGMs, and launchers whose rounds pass the
// ammo filters but must never be proximity-fused (they are self-guided or unrelated).
private _ignoredWeapons = [
    "rhs_weap_9m113",       // BMP-2DM Konkurs ATGM
    "rhs_weap_9m113m"       // Konkurs-M variant
];
if (_weapon in _ignoredWeapons) exitWith {
    if (_debug) then { diag_log format ["[PROXROUND] EXIT: weapon %1 in ignore list", _weapon]; };
};

// --- Absolute fuse distance ---
// Default to the current vanilla FCS zeroing until the gunner scroll-adjusts a range.
// A fresh laser-designator shot clears that manual selection and stores its new range.
private _range = _gunner getVariable ["OKS_ProxRound_Range", -1];
if (_range < 1) then {
    _range = currentZeroing _gunner;
};
_range = round _range;
if (_range <= 0) exitWith {
    if (_debug) then { diag_log "[PROXROUND] EXIT: zeroing=0 — lase target first (T)"; };
};

if (_debug) then {
    diag_log format ["[PROXROUND] Tracking round | ammo=%1 range=%2m projectile=%3", _ammo, _range, _projectile];
};

// Capture muzzle position at the instant of fire (ASL, local projectile is accurate here)
private _muzzlePos = getPosASLVisual _projectile;

// Queue this round for the one shared local tracker. A separate PFH for every round
// caused high-rate cannon bursts to create many concurrent callbacks each frame.
private _trackedRounds = missionNamespace getVariable ["OKS_ProxRound_TrackedRounds", []];
_trackedRounds pushBack [_projectile, _muzzlePos, _range, _ammo, _weapon];
missionNamespace setVariable ["OKS_ProxRound_TrackedRounds", _trackedRounds];

if ((missionNamespace getVariable ["OKS_ProxRound_TrackerPFH", -1]) < 0) then {
    private _trackerPFH = [{_this call OKS_fnc_ProxRound_TrackRound}, 0, []] call CBA_fnc_addPerFrameHandler;
    missionNamespace setVariable ["OKS_ProxRound_TrackerPFH", _trackerPFH];
};
