/// Sets up missile warning system for a vehicle
/// [_Vehicle] call OKS_fnc_SetupMissileWarning;

params ["_Vehicle"];

if (_Vehicle getVariable ["GOL_MissileWarning_Setup", false]) exitWith {};
_Vehicle setVariable ["GOL_MissileWarning_Setup", true];

if (missionNamespace getVariable ["GOL_MissileWarning_Enabled", false]) then {
	_Vehicle addEventHandler ["Fired", {
		params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
		// Config-based smoke detection: any ammo with simulation=shotSmoke or smokeColor entries
		private _ammoConfig = configFile >> "CfgAmmo" >> _ammo;
		private _isSmoke = getText (_ammoConfig >> "simulation") == "shotSmoke" ||
		                   count (getArray (_ammoConfig >> "smokeColor")) > 0;
		private _debug = missionNamespace getVariable ["GOL_MissileWarning_Debug", false];
		if (_debug) then {
			format ["[MISSILEWARNING] Fired | Weapon: %1 | Ammo: %2 | IsSmoke: %3", _weapon, _ammo, _isSmoke] call OKS_fnc_LogDebug;
		};
		if (_isSmoke) then {
			if (_debug) then {
				format ["[MISSILEWARNING] Smoke confirmed, starting cover timer on: %1", _unit] call OKS_fnc_LogDebug;
			};

			_unit spawn {
				params ["_unit"];
				private _position = getPos _unit;
				private _debug = missionNamespace getVariable ["GOL_MissileWarning_Debug", false];
				sleep 1.5;
				_unit setVariable ["GOL_FiredSmoke", true, true];
				private _timeout = 8;
				waitUntil { sleep 1; _timeout = _timeout - 1; getPos _unit distance2D _position > 30 || _timeout <= 0 };
				_unit setVariable ["GOL_FiredSmoke", false, true];
				if (_debug) then {
					format ["[MISSILEWARNING] Smoke cover removed for: %1", _unit] call OKS_fnc_LogDebug;
				};
			};
		};
	}];

	_Vehicle addEventHandler ["IncomingMissile", {
		params ["_target", "_ammo", "_vehicle", "_instigator", "_missile"];

		private _debug = missionNamespace getVariable ["GOL_MissileWarning_Debug", false];
		if (_debug) then {
			format ["[MISSILEWARNING] Incoming Round: %1", _ammo] call OKS_fnc_LogDebug;
		};

		// Config-based guidance detection: missile responds to guidance if any of these are set
		// - gainFactor: used by RHS/mod ATGMs for SACLOS and other manual-guidance systems
		// - maneuvrability: used by vanilla Arma 3 ATGMs for auto-guidance turn rate
		// - correctionFactor: supplementary guidance correction (some mods use this alone)
		// - missileManualControlCone: SACLOS control cone; > 0 means operator-guidable
		private _ammoConfig = configFile >> "CfgAmmo" >> _ammo;
		private _gainFactor              = getNumber (_ammoConfig >> "gainFactor");
		private _maneuvrability          = getNumber (_ammoConfig >> "maneuvrability");
		private _correctionFactor        = getNumber (_ammoConfig >> "correctionFactor");
		private _missileManualControlCone = getNumber (_ammoConfig >> "missileManualControlCone");
		private _isGuided = _gainFactor > 0 || _maneuvrability > 0 || _correctionFactor > 0 || _missileManualControlCone > 0;
		private _alreadyActive = _target getVariable ["GOL_MissileWarning", false];
		if (_debug) then {
			format ["[MISSILEWARNING] IncomingMissile | Ammo: %1 | Guided: %2 | GainFactor: %3 | Maneuvrability: %4 | CorrectionFactor: %5 | ManualControlCone: %6 | AlreadyActive: %7 | MissileOwner: %8",
				_ammo,
				_isGuided,
				_gainFactor,
				_maneuvrability,
				_correctionFactor,
				_missileManualControlCone,
				_alreadyActive,
				owner _missile
			] call OKS_fnc_LogDebug;
		};
		if (_isGuided && !_alreadyActive) then {
			if (_debug) then {
				format ["[MISSILEWARNING] Dispatching | CrewCount: %1 | MissileOwner: %2", count crew _target, owner _missile] call OKS_fnc_LogDebug;
			};
			// Set flag immediately to prevent double-triggering before remoteExec arrives
			_target setVariable ["GOL_MissileWarning", true, true];
			// UI warning runs on all crew machines
			[_target, _missile, _instigator] remoteExec ["OKS_fnc_MissileWarning", crew _target];
			// Deflect runs only on the machine that owns the missile (setVelocity requires locality)
			[_target, _missile, _instigator] remoteExec ["OKS_fnc_MissileDeflect", owner _missile];
		} else {
			if (_debug) then {
				format ["[MISSILEWARNING] Skipped | Guided: %1 | AlreadyActive: %2", _isGuided, _alreadyActive] call OKS_fnc_LogDebug;
			};
		};
	}];
};