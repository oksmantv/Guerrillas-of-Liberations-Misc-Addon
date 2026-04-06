/*
	OKS_fnc_SAM

	Networked SAM launcher — engages air targets detected by a linked radar.
	A global network (OKS_SAM_Network) limits the total in-flight missiles
	per target across ALL SAM and SHORAD launchers so they don't spam
	everything at once.

	Max missiles per target is read from the CBA setting
	OKS_SAM_MaxMissilesPerTarget (GOL SAM > Network). The parameter is
	kept for backward compatibility but the CBA value takes priority.

	Fire control works by disabling the gunner's TARGET + AUTOTARGET AI.
	The AI physically cannot select or engage anything. When the main loop
	authorises a shot, it enables targeting, reveals the target, and commands
	the gunner to fire. The Fired EH immediately disables targeting again.
	This keeps full ammo and correct model visuals (missiles visible on rail).

	[SAMLAUNCHER, RADAR, RATEOFFIRE, AMMO, RELOADRATE, MINIMUMALT, MAXRANGE] spawn OKS_fnc_SAM;
	[this, radar_1, 20, 4, 30, 100, 3000] spawn OKS_fnc_SAM;
*/

params [
	"_SAM",
	"_Radar",
	["_RateOfFire", 20, [0]],
	["_Ammo", 4, [0]],
	["_ReloadRate", 20, [0]],
	["_MinimumAltitude", 100, [0]],
	["_MaxRange", 3000, [0]],
	["_MaxMissilesPerTarget", -1, [0]]
];

// CBA setting takes priority; parameter kept for backward compatibility
private _maxPerTarget = missionNamespace getVariable ["OKS_SAM_MaxMissilesPerTarget", 3];
if (_MaxMissilesPerTarget > 0) then { _maxPerTarget = _MaxMissilesPerTarget; };

diag_log format ["[SAM] Init | launcher=%1 radar=%2 ROF=%3 ammo=%4 reload=%5 minAlt=%6 maxRange=%7 maxPerTarget=%8",
	_SAM, _Radar, _RateOfFire, _Ammo, _ReloadRate, _MinimumAltitude, _MaxRange, _maxPerTarget];

// --- Initialise global SAM network (once per mission) ---
if (isNil "OKS_SAM_Network") then {
	OKS_SAM_Network = createHashMap;
	diag_log "[SAM] Network initialised (OKS_SAM_Network)";
};

// --- Setup GOL SAM Weapon ---
// Config-level turret already has our weapon for GOL classes.
// Runtime swap handles non-GOL vehicles or ensures clean state.
private _turretPath = [0]; // MainTurret
{
	_SAM removeWeaponTurret [_x, _turretPath];
} forEach (_SAM weaponsTurret _turretPath);
{
	_SAM removeMagazineTurret [_x, _turretPath];
} forEach (_SAM magazinesTurret _turretPath);
_SAM addMagazineTurret ["gol_magazine_Missile_s750_x4", _turretPath];
_SAM addWeaponTurret ["gol_weapon_s750Launcher", _turretPath];

// Log animation sources so we can identify tube animations
diag_log format ["[SAM] AnimationSources | launcher=%1 type=%2 sources=%3",
	_SAM, typeOf _SAM, animationNames _SAM];

// Allow radar data in so the AI builds knowledge, but it can't act on it.
_SAM setVehicleReceiveRemoteTargets true;

sleep 2;

// --- Lock the gunner down ---
private _gunner = gunner _SAM;
if (isNull _gunner) then {
	private _crew = crew _SAM;
	if (count _crew > 0) then { _gunner = _crew select 0; };
};

if (isNull _gunner) exitWith {
	diag_log format ["[SAM] ERROR — no gunner found | launcher=%1", _SAM];
};

_gunner disableAI "TARGET";
_gunner disableAI "AUTOTARGET";
(group _gunner) setCombatMode "GREEN";
diag_log format ["[SAM] Gunner locked | gunner=%1 launcher=%2", _gunner, _SAM];

_SAM setVariable ["SAM_Name", _SAM];
_SAM setVariable ["SAM_Gunner", _gunner];
_SAM setVariable ["SAM_ROF", _RateOfFire];
_SAM setVariable ["SAM_Ammo_Full", _Ammo];
_SAM setVariable ["SAM_Ammo", _Ammo];
_SAM setVariable ["SAM_RR", _ReloadRate];
_SAM setVariable ["SAM_MaxPerTarget", _maxPerTarget];

// Fired EH — runs unscheduled (immediate). Breaks engagement via ignoreTarget.
// Magazine stays loaded so missile tubes remain visually filled.
_SAM addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
	private _g = _unit getVariable ["SAM_Gunner", objNull];
	if (!isNull _g) then {
		_g disableAI "TARGET";
		_g disableAI "AUTOTARGET";
		// Tell AI to ignore this target — breaks the fire chain instantly
		private _tgt = _unit getVariable ["SAM_LockedTarget", objNull];
		if (!isNull _tgt) then { (group _g) ignoreTarget [_tgt, true]; };
		(group _g) setCombatMode "GREEN";
	};

	// If already reloading, this is a leaked round — don't spawn another handler
	if (_unit getVariable ["isReloading", false]) exitWith {
		diag_log format ["[SAM] Fired EH (leaked round ignored) | launcher=%1", _unit];
	};

	_unit setVariable ["isReloading", true];
	diag_log format ["[SAM] Fired EH | launcher=%1 — engagement broken (ignoreTarget), reloading=true", _unit];
	[_unit, _projectile] spawn OKS_fnc_SAM_FIRED;
}];

diag_log format ["[SAM] Ready | launcher=%1", _SAM];

while {alive _SAM && {alive _gunner}} do {

	// Skip while reloading/cooling down
	if (_SAM getVariable ["isReloading", false]) then {
		sleep 2;
		continue;
	};

	private _nearbyTargets = (_Radar targets [true, _MaxRange]) select {
		_x isKindOf "AIR" && { alive _x } && { (getPos _x select 2) >= _MinimumAltitude }
	};

	if (count _nearbyTargets > 0) then {
		// Find a target under the network missile cap
		private _validTarget = objNull;
		{
			private _tgtId = str (getObjectID _x);
			private _inFlight = OKS_SAM_Network getOrDefault [_tgtId, 0];
			if (_inFlight < _maxPerTarget) exitWith {
				_validTarget = _x;
			};
		} forEach _nearbyTargets;

		if (!isNull _validTarget) then {
			private _tgtId = str (getObjectID _validTarget);

			// Reserve network slot before authorising the shot
			private _cur = OKS_SAM_Network getOrDefault [_tgtId, 0];
			OKS_SAM_Network set [_tgtId, _cur + 1];

			_SAM setVariable ["SAM_LockedTarget", _validTarget];
			_SAM setVariable ["SAM_LockedTargetId", _tgtId];

			diag_log format ["[SAM] Authorising shot | launcher=%1 target=%2 id=%3 slots=%4/%5",
				_SAM, typeOf _validTarget, _tgtId, _cur + 1, _maxPerTarget];

			// UNLOCK the gunner — let it engage this specific target
			// Undo ignoreTarget from previous engagement
			(group _gunner) ignoreTarget [_validTarget, false];
			_gunner enableAI "TARGET";
			_gunner enableAI "AUTOTARGET";
			(group _gunner) setCombatMode "RED";
			(group _gunner) setBehaviourStrong "COMBAT";
			_gunner reveal [_validTarget, 4];
			_gunner doTarget _validTarget;
			_gunner doFire _validTarget;
			_gunner commandTarget _validTarget;
			_gunner commandFire _validTarget;

			// Wait for the Fired EH to lock the gunner back down, or timeout
			private _waitStart = diag_tickTime;
			waitUntil {
				sleep 0.5;
				(_SAM getVariable ["isReloading", false])
				|| { !alive _SAM }
				|| { !alive _validTarget }
				|| { (diag_tickTime - _waitStart) > 15 }
			};

			// If the AI never fired (timeout), lock it back down and release slot
			if !(_SAM getVariable ["isReloading", false]) then {
				_gunner disableAI "TARGET";
				_gunner disableAI "AUTOTARGET";
				(group _gunner) setCombatMode "GREEN";
				private _c = OKS_SAM_Network getOrDefault [_tgtId, 0];
				_c = (_c - 1) max 0;
				if (_c <= 0) then { OKS_SAM_Network deleteAt _tgtId; } else { OKS_SAM_Network set [_tgtId, _c]; };
				diag_log format ["[SAM] Timeout — no shot taken | launcher=%1 released slot for %2", _SAM, _tgtId];
			};
		} else {
			diag_log format ["[SAM] Holding fire — all targets at cap | launcher=%1 targets=%2", _SAM, count _nearbyTargets];
		};
	};

	sleep 5;
};

diag_log format ["[SAM] Loop ended (dead) | launcher=%1", _SAM];