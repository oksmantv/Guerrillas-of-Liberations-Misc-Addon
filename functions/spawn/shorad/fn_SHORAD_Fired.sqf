/*
	OKS_fnc_SHORAD_Fired

	Spawned by the Fired EH in OKS_fnc_SHORAD.
	The EH already stripped the magazine from the turret (inline).
	This handler does: network slot tracking, ammo tracking, ROF cooldown, reload.

	The next missile is loaded after the cooldown expires.
*/

params ["_vehicle", "_firedTurret", "_gunner", "_projectile"];

private _reloadTime  = _vehicle getVariable ["SHORAD_ReloadTime", 10];
private _magClass    = _vehicle getVariable ["SHORAD_MagazineClass", ""];
private _turretKey   = format ["SHORAD_Ammo_%1", _firedTurret];
private _turretKeyFull = format ["SHORAD_AmmoFull_%1", _firedTurret];
private _reloadingKey = format ["SHORAD_isReloading_%1", _firedTurret];
private _fireCountKey = format ["SHORAD_FireCount_%1", _firedTurret];

// Increment fire counter
private _fireCount = (_vehicle getVariable [_fireCountKey, 0]) + 1;
_vehicle setVariable [_fireCountKey, _fireCount];

// isReloading already set in the Fired EH (unscheduled) to prevent watchdog race

// --- Network slot reservation (using assignedTarget) ---
private _maxPerTarget = missionNamespace getVariable ["OKS_SAM_MaxMissilesPerTarget", 3];
private _tgtId = "";
private _targetType = "NONE";

if (!isNull _gunner) then {
	private _target = assignedTarget _gunner;
	if (!isNull _target && {_target isKindOf "AIR"}) then {
		_tgtId = str (getObjectID _target);
		_targetType = typeOf _target;
		private _cur = OKS_SAM_Network getOrDefault [_tgtId, 0];
		if (_cur >= _maxPerTarget) then {
			diag_log format ["[SHORAD] WARNING — fired while target saturated! | vehicle=%1 target=%2 (%3) id=%4 activeSlots=%5 cap=%6 networkState=%7",
				_vehicle, _targetType, _target, _tgtId, _cur, _maxPerTarget, OKS_SAM_Network];
		};
		OKS_SAM_Network set [_tgtId, _cur + 1];
		diag_log format ["[SHORAD] Network slot reserved | vehicle=%1 target=%2 (%3) id=%4 slots=%5/%6 networkState=%7",
			_vehicle, _targetType, _target, _tgtId, _cur + 1, _maxPerTarget, OKS_SAM_Network];
	} else {
		diag_log format ["[SHORAD] No valid air target for network | vehicle=%1 gunner=%2 assignedTarget=%3 isAir=%4",
			_vehicle, _gunner, _target, if (isNull _target) then {"NULL"} else {_target isKindOf "AIR"}];
	};
} else {
	diag_log format ["[SHORAD] Gunner is null — cannot track target | vehicle=%1", _vehicle];
};

// --- Decrement ammo ---
private _currentAmmo = _vehicle getVariable [_turretKey, 0];
_currentAmmo = _currentAmmo - 1;
_vehicle setVariable [_turretKey, _currentAmmo];
private _fireTime = diag_tickTime;
// Fire-to-fire diagnostic: actual time between consecutive fires per turret
private _lastFireKey = format ["SHORAD_LastFire_%1", _firedTurret];
private _lastFire = _vehicle getVariable [_lastFireKey, 0];
private _fireToFire = if (_lastFire > 0) then { diag_tickTime - _lastFire } else { -1 };
_vehicle setVariable [_lastFireKey, diag_tickTime];

diag_log format ["[SHORAD] FIRED #%1 | vehicle=%2 (%3) turret=%4 ammo=%5/%6 target=%7 (%8) fire-to-fire=%9s reloadTimeSetting=%10",
	_fireCount, _vehicle, typeOf _vehicle, _firedTurret, _currentAmmo,
	_vehicle getVariable [_turretKeyFull, 4], _targetType, _tgtId,
	if (_fireToFire > 0) then {round _fireToFire} else {"FIRST"},
	_reloadTime];

// --- Track missile until it terminates (hit/miss/expired) ---
// Network slot stays reserved until the projectile is gone
if (_tgtId != "" && {!isNull _projectile}) then {
	diag_log format ["[SHORAD] Tracking projectile %1 | vehicle=%2 target=%3",
		_projectile, _vehicle, _tgtId];
	waitUntil { sleep 0.5; !alive _projectile || isNull _projectile };
	// Release network slot now that missile is gone
	private _cur = OKS_SAM_Network getOrDefault [_tgtId, 0];
	_cur = (_cur - 1) max 0;
	if (_cur <= 0) then {
		OKS_SAM_Network deleteAt _tgtId;
	} else {
		OKS_SAM_Network set [_tgtId, _cur];
	};
	diag_log format ["[SHORAD] Missile terminated — network slot released | vehicle=%1 target=%2 remaining=%3",
		_vehicle, _tgtId, _cur];
} else {
	if (_tgtId != "") then {
		private _cur = OKS_SAM_Network getOrDefault [_tgtId, 0];
		_cur = (_cur - 1) max 0;
		if (_cur <= 0) then { OKS_SAM_Network deleteAt _tgtId; } else { OKS_SAM_Network set [_tgtId, _cur]; };
		diag_log format ["[SHORAD] Projectile null — network slot released immediately | vehicle=%1 target=%2 remaining=%3",
			_vehicle, _tgtId, _cur];
	};
};

// --- ROF cooldown (remaining time after missile terminated) ---
// If missile terminated quickly, enforce minimum cooldown.
// If missile flew longer than cooldown, no extra wait needed.
private _cooldown = _reloadTime + (random (_reloadTime * 0.5));
private _elapsed = diag_tickTime - _fireTime;
private _remaining = (_cooldown - _elapsed) max 0;
diag_log format ["[SHORAD] Cooldown | total=%1s elapsed=%2s remaining=%3s | vehicle=%4 turret=%5",
	round _cooldown, round _elapsed, round _remaining, _vehicle, _firedTurret];
if (_remaining > 0) then { sleep _remaining; };

// --- Full magazine reload if empty ---
if (_currentAmmo < 1) then {
	private _fullAmmo = _vehicle getVariable [_turretKeyFull, 4];
	diag_log format ["[SHORAD] Magazine empty — full reload | vehicle=%1 turret=%2 reloadTime=%3",
		_vehicle, _firedTurret, _reloadTime * 4];
	sleep (_reloadTime * 4);
	_vehicle setVariable [_turretKey, _fullAmmo];
	diag_log format ["[SHORAD] Reload complete | vehicle=%1 turret=%2 ammo=%3", _vehicle, _firedTurret, _fullAmmo];
};

// --- Re-arm: load 1 missile back onto the turret ---
// Network check: don't re-arm if gunner's current target is already saturated.
// The watchdog loop will re-arm later when a slot opens.
if (alive _vehicle) then {
	private _blocked = false;
	private _occupant = _vehicle turretUnit _firedTurret;
	if (!isNull _occupant) then {
		private _tgt = assignedTarget _occupant;
		if (!isNull _tgt && {_tgt isKindOf "AIR"}) then {
			private _id = str (getObjectID _tgt);
			private _inFlight = OKS_SAM_Network getOrDefault [_id, 0];
			if (_inFlight >= _maxPerTarget) then {
				_blocked = true;
				diag_log format ["[SHORAD] Re-arm blocked — target saturated | vehicle=%1 turret=%2 target=%3 slots=%4/%5",
					_vehicle, _firedTurret, typeOf _tgt, _inFlight, _maxPerTarget];
			};
		};
	};

	if (!_blocked) then {
		_vehicle addMagazineTurret [_magClass, _firedTurret];
		diag_log format ["[SHORAD] Re-armed | vehicle=%1 turret=%2 ammo=%3/%4 totalFired=%5 turretMags=%6",
			_vehicle, _firedTurret, _vehicle getVariable [_turretKey, 0],
			_vehicle getVariable [_turretKeyFull, 4], _fireCount,
			_vehicle magazinesTurret _firedTurret];
	};
};

_vehicle setVariable [_reloadingKey, false];
diag_log format ["[SHORAD] Ready for next shot | vehicle=%1 turret=%2 networkState=%3",
	_vehicle, _firedTurret, OKS_SAM_Network];
