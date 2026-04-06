/*
	OKS_fnc_SHORAD

	Networked SHORAD (Short Range Air Defence) — rate-limits IR missile fire
	on vehicles with mixed armament (cannons + missiles).

	Instead of disabling AI targeting (which would block cannons), this script
	replaces all native missile weapons with the unified GOL SHORAD IR launcher
	and controls ammo: the vehicle only has 1 missile loaded at a time.
	After firing, the Fired EH strips the magazine and this loop re-loads
	after the cooldown. Cannons are never touched.

	The global network (OKS_SAM_Network) limits total in-flight missiles
	per target across ALL SAM and SHORAD launchers.

	[VEHICLE, MISSILETYPE, AMMO, RELOADTIME] spawn OKS_fnc_SHORAD;
	[this, "medium", 4, 10] spawn OKS_fnc_SHORAD;

	Missile types: "light" (high flare susceptibility), "medium" (balanced), "heavy" (low flare susceptibility)
*/

params [
	"_vehicle",
	["_missileType", "medium", [""]],
	["_ammo", 4, [0]],
	["_reloadTime", 10, [0]]
];

diag_log format ["[SHORAD] Init | vehicle=%1 (%2) type=%3 ammo=%4 reload=%5",
	_vehicle, typeOf _vehicle, _missileType, _ammo, _reloadTime];

// --- Initialise global SAM network (once per mission) ---
if (isNil "OKS_SAM_Network") then {
	OKS_SAM_Network = createHashMap;
	diag_log "[SHORAD] Network initialised (OKS_SAM_Network)";
};

// --- Resolve magazine classname from type ---
private _magazineClass = switch (toLower _missileType) do {
	case "light":  { "gol_magazine_shorad_light_x1" };
	case "heavy":  { "gol_magazine_shorad_heavy_x1" };
	default        { "gol_magazine_shorad_medium_x1" };
};

private _weaponClass = "gol_weapon_shorad_ir";

diag_log format ["[SHORAD] Config resolved | magazine=%1 weapon=%2 | vehicle=%3",
	_magazineClass, _weaponClass, _vehicle];

// --- Scan all turrets, replace missile weapons with GOL SHORAD ---
private _modifiedTurrets = [];
private _allTurrets = allTurrets _vehicle;
diag_log format ["[SHORAD] Turret scan | vehicle=%1 totalTurrets=%2 turretPaths=%3",
	_vehicle, count _allTurrets, _allTurrets];
{
	private _turretPath = _x;
	private _weapons = _vehicle weaponsTurret _turretPath;
	private _hadMissile = false;

	diag_log format ["[SHORAD] Scanning turret %1 | weapons=%2 magazines=%3 | vehicle=%4",
		_turretPath, _weapons, _vehicle magazinesTurret _turretPath, _vehicle];

	{
		private _weapon = _x;
		// Skip if it's already our custom weapon
		if (_weapon == _weaponClass) then { continue; };

		// Check if this weapon fires missiles
		private _compatMags = compatibleMagazines _weapon;
		private _isMissile = false;
		{
			private _ammoClass = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
			if (_ammoClass isKindOf "MissileBase") exitWith { _isMissile = true; };
		} forEach _compatMags;

		diag_log format ["[SHORAD]   Weapon check | %1 isMissile=%2 compatMags=%3",
			_weapon, _isMissile, _compatMags];

		if (_isMissile) then {
			// Remove only magazines compatible with this missile weapon
			private _missileCompatMags = compatibleMagazines _weapon;
			{
				if (_x in _missileCompatMags) then {
					_vehicle removeMagazineTurret [_x, _turretPath];
				};
			} forEach (_vehicle magazinesTurret _turretPath);

			// Remove the weapon itself
			_vehicle removeWeaponTurret [_weapon, _turretPath];
			_hadMissile = true;
			diag_log format ["[SHORAD] Removed missile weapon %1 from turret %2 | vehicle=%3",
				_weapon, _turretPath, _vehicle];
		};
	} forEach _weapons;

	if (_hadMissile) then {
		// Add our custom launcher to this turret (no magazine yet — watchdog arms it
		// after the network check so we don't bypass the per-target cap)
		_vehicle addWeaponTurret [_weaponClass, _turretPath];
		_modifiedTurrets pushBack _turretPath;
		diag_log format ["[SHORAD] Added %1 to turret %2 (unarmed) | vehicle=%3",
			_weaponClass, _turretPath, _vehicle];
	};
} forEach (allTurrets _vehicle);

if (count _modifiedTurrets == 0) exitWith {
	diag_log format ["[SHORAD] ERROR — no missile turrets found | vehicle=%1 (%2) allTurrets=%3",
		_vehicle, typeOf _vehicle, allTurrets _vehicle];
};

// --- Store state on the vehicle ---
_vehicle setVariable ["SHORAD_WeaponClass", _weaponClass];
_vehicle setVariable ["SHORAD_MagazineClass", _magazineClass];
_vehicle setVariable ["SHORAD_ReloadTime", _reloadTime];
_vehicle setVariable ["SHORAD_Turrets", _modifiedTurrets];

// Per-turret ammo tracking
{
	_vehicle setVariable [format ["SHORAD_Ammo_%1", _x], _ammo];
	_vehicle setVariable [format ["SHORAD_AmmoFull_%1", _x], _ammo];
	_vehicle setVariable [format ["SHORAD_FireCount_%1", _x], 0];
} forEach _modifiedTurrets;

sleep 1;

// --- Fired EH — catches missile shots, strips magazine, spawns cooldown ---
_vehicle addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

	private _magClass = _unit getVariable ["SHORAD_MagazineClass", ""];

	// Check by magazine — weapon name can differ from classname for turret weapons
	if (_magazine != _magClass) exitWith {
		// Log non-SHORAD fire events at debug level so we can diagnose
		if (_ammo isKindOf "MissileBase") then {
			diag_log format ["[SHORAD] DEBUG — missile fired but NOT our magazine | vehicle=%1 weapon=%2 magazine=%3 ammo=%4 expectedMag=%5",
				_unit, _weapon, _magazine, _ammo, _magClass];
		};
	};

	// Find which turret fired by checking which turret the gunner occupies
	private _turrets = _unit getVariable ["SHORAD_Turrets", []];
	private _firedTurret = [];
	{
		private _turretOccupant = _unit turretUnit _x;
		if (!isNull _turretOccupant && {_turretOccupant == _gunner}) exitWith {
			_firedTurret = _x;
		};
	} forEach _turrets;

	// Safety: strip all SHORAD magazines from the fired turret immediately
	if !(_firedTurret isEqualTo []) then {
		{
			if (_x == _magClass) then {
				_unit removeMagazineTurret [_x, _firedTurret];
			};
		} forEach (_unit magazinesTurret _firedTurret);
	};

	// Set reloading flag HERE (unscheduled/immediate) to prevent watchdog
	// from re-arming before the spawned handler starts
	if !(_firedTurret isEqualTo []) then {
		_unit setVariable [format ["SHORAD_isReloading_%1", _firedTurret], true];
	};

	diag_log format ["[SHORAD] Fired EH | vehicle=%1 weapon=%2 magazine=%3 ammo=%4 turret=%5 gunner=%6",
		_unit, _weapon, _magazine, _ammo, _firedTurret, _gunner];

	[_unit, _firedTurret, _gunner, _projectile] spawn OKS_fnc_SHORAD_Fired;
}];

diag_log format ["[SHORAD] Ready | vehicle=%1 (%2) turrets=%3 type=%4 ammo=%5 maxPerTarget=%6",
	_vehicle, typeOf _vehicle, _modifiedTurrets, _missileType, _ammo,
	missionNamespace getVariable ["OKS_SAM_MaxMissilesPerTarget", 3]];

// --- Watchdog: arms turrets when ammo > 0 and network cap allows ---
// Random stagger so multiple SHORAD vehicles don't all check at the same frame
private _stagger = random 4;
diag_log format ["[SHORAD] Watchdog starting in %1s | vehicle=%2", round _stagger, _vehicle];
sleep _stagger;

private _maxPerTarget = missionNamespace getVariable ["OKS_SAM_MaxMissilesPerTarget", 3];
while {alive _vehicle} do {
	_maxPerTarget = missionNamespace getVariable ["OKS_SAM_MaxMissilesPerTarget", 3];
	{
		private _turretPath = _x;
		if !(_vehicle getVariable [format ["SHORAD_isReloading_%1", _turretPath], false]) then {
			private _currentAmmo = _vehicle getVariable [format ["SHORAD_Ammo_%1", _turretPath], 0];
			if (_currentAmmo > 0) then {
				private _hasMag = _magazineClass in (_vehicle magazinesTurret _turretPath);
				if (!_hasMag) then {
					// Network check: don't re-arm if current target is saturated
					private _blocked = false;
					private _occupant = _vehicle turretUnit _turretPath;
					if (!isNull _occupant) then {
						private _tgt = assignedTarget _occupant;
						if (!isNull _tgt && {_tgt isKindOf "AIR"}) then {
							private _tgtId = str (getObjectID _tgt);
							private _inFlight = OKS_SAM_Network getOrDefault [_tgtId, 0];
							if (_inFlight >= _maxPerTarget) then {
								_blocked = true;
								diag_log format ["[SHORAD] Watchdog held — target saturated | vehicle=%1 turret=%2 target=%3 slots=%4/%5",
									_vehicle, _turretPath, typeOf _tgt, _inFlight, _maxPerTarget];
							};
						};
					};
					if (!_blocked) then {
						_vehicle addMagazineTurret [_magazineClass, _turretPath];
						diag_log format ["[SHORAD] Watchdog re-armed turret %1 | vehicle=%2 ammo=%3",
							_turretPath, _vehicle, _currentAmmo];
					};
				};
			};
		};
	} forEach _modifiedTurrets;
	sleep 5;
};

diag_log format ["[SHORAD] Loop ended (dead) | vehicle=%1 (%2)", _vehicle, typeOf _vehicle];
