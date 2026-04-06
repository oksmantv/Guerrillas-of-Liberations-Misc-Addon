/*
	OKS_fnc_SAM_FIRED

	Spawned by the Fired EH in OKS_fnc_SAM.
	The EH already disabled the gunner's targeting AI and set isReloading (inline).
	This handler does: ammo tracking, projectile tracking, network slot release,
	ROF cooldown, reload.

	The gunner stays locked until the main loop authorises the next shot.
*/

params ["_Object", "_projectile"];

private _SAM       = _Object getVariable "SAM_Name";
private _RateOfFire = _Object getVariable "SAM_ROF";
private _Ammo      = _Object getVariable "SAM_Ammo";
private _AmmoFull  = _Object getVariable "SAM_Ammo_Full";
private _ReloadRate = _Object getVariable "SAM_RR";

private _tgtId = _Object getVariable ["SAM_LockedTargetId", ""];

_Ammo = _Ammo - 1;
_SAM setVariable ["SAM_Ammo", _Ammo];
private _fireTime = diag_tickTime;
diag_log format ["[SAM] FIRED | launcher=%1 target=%2 ammo=%3", _SAM, _tgtId, _Ammo];

// --- ROF cooldown value ---
private _cooldown = _RateOfFire + (random _RateOfFire);
diag_log format ["[SAM] Cooldown %1s | launcher=%2", round _cooldown, _SAM];

// --- Track missile until it terminates (hit/miss/expired) ---
// Network slot stays reserved while the projectile is alive
if (_tgtId != "" && {!isNull _projectile}) then {
	diag_log format ["[SAM] Tracking projectile %1 | launcher=%2 target=%3",
		_projectile, _SAM, _tgtId];
	waitUntil { sleep 0.5; !alive _projectile || isNull _projectile };
	// Release network slot now that missile is gone
	private _cur = OKS_SAM_Network getOrDefault [_tgtId, 0];
	_cur = (_cur - 1) max 0;
	if (_cur <= 0) then {
		OKS_SAM_Network deleteAt _tgtId;
	} else {
		OKS_SAM_Network set [_tgtId, _cur];
	};
	diag_log format ["[SAM] Missile terminated — network slot released | launcher=%1 target=%2 remaining=%3",
		_SAM, _tgtId, _cur];
} else {
	// Projectile null or no target — release slot immediately
	if (_tgtId != "") then {
		private _cur = OKS_SAM_Network getOrDefault [_tgtId, 0];
		_cur = (_cur - 1) max 0;
		if (_cur <= 0) then { OKS_SAM_Network deleteAt _tgtId; } else { OKS_SAM_Network set [_tgtId, _cur]; };
		diag_log format ["[SAM] Projectile null — network slot released immediately | launcher=%1 target=%2 remaining=%3",
			_SAM, _tgtId, _cur];
	};
};

// --- Sleep remaining cooldown after missile terminated ---
private _elapsed = diag_tickTime - _fireTime;
private _remaining = (_cooldown - _elapsed) max 0;
diag_log format ["[SAM] Remaining cooldown | total=%1s elapsed=%2s remaining=%3s | launcher=%4",
	round _cooldown, round _elapsed, round _remaining, _SAM];
if (_remaining > 0) then { sleep _remaining; };

// --- Full magazine reload ---
if (_Ammo < 1) then {
	diag_log format ["[SAM] Magazine empty — reloading | launcher=%1 reloadRate=%2", _SAM, _ReloadRate];
	sleep (_ReloadRate * 4);
	_SAM setVariable ["SAM_Ammo", _AmmoFull];
	diag_log format ["[SAM] Reload complete | launcher=%1 ammo=%2", _SAM, _AmmoFull];
};

// --- Ready for next shot (main loop will unlock gunner when appropriate) ---
diag_log format ["[SAM] Ready | launcher=%1 ammo=%2", _SAM, _SAM getVariable "SAM_Ammo"];
_SAM setVariable ["isReloading", false];