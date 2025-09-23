/// Sets up missile warning system for a vehicle
/// [_Vehicle] call OKS_fnc_SetupMissileWarning;

params ["_Vehicle"];

if(missionNamespace getVariable ["GOL_MissileWarning_Enabled",false]) then {
	_Vehicle addEventHandler ["Fired", {
		params ["_unit", "_weapon", "_magazine", "_projectile"];
		_SmokeLaunchers = ["SmokeLauncher_ACV","SmokeLauncher", "rhsusf_weap_M250"];
		if(_weapon in _SmokeLaunchers) then {
			_Debug = missionNamespace getVariable ["GOL_MissileWarning_Debug", false];

			if(_Debug) then {
				format["[MISSILEWARNING] Crew launched smoke: %1",_unit] call OKS_fnc_LogDebug;
			};
			
			_unit spawn {
				params ["_unit"];
				_Position = getpos _unit;
				sleep 1.5;
				_unit setVariable ["GOL_FiredSmoke", true, true];
				_Debug = missionNamespace getVariable ["GOL_MissileWarning_Debug", false];

				_Timeout = 8;
				waitUntil { sleep 1; _Timeoout = _Timeout - 1; getPos _unit distance2d _Position > 30 || _Timeout <= 0 };
				
				_unit setVariable ["GOL_FiredSmoke", false, true];
				if(_Debug) then {
					format["[MISSILEWARNING] Smoke cover removed for: %1",_unit] call OKS_fnc_LogDebug;
				};
			};
		};
	}];

	_Vehicle addEventHandler ["IncomingMissile", {
		params ["_target", "_ammo", "_vehicle", "_instigator", "_missile"];

		_Debug = missionNamespace getVariable ["GOL_MissileWarning_Debug", false];
		if(_Debug) then {
			format["[MISSILEWARNING] Incoming Round: %1",_ammo] call OKS_fnc_LogDebug;
		};
	
		_atgmAmmo = [
			"rhs_ammo_9m115","rhs_ammo_9m131m","rhs_ammo_9m120","rhs_ammo_9m119",
			"rhs_ammo_9m113m","rhs_ammo_TOW2A_AT","rhs_ammo_9m117m","rhs_ammo_9m14m",
			"rhs_ammo_9m131f"
		];
		if(_ammo in _atgmAmmo && !(_target getVariable ["GOL_MissileWarning", false])) then {
			if(_Debug) then {
				format["[MISSILEWARNING] Matching Round: %1",_ammo] call OKS_fnc_LogDebug;
			};
			[_target,_missile,_instigator] remoteExec ["OKS_fnc_MissileWarning", crew _target];
		} else {
			if(_Debug) then {
				format["[MISSILEWARNING] No Match %1: %2 - Active: %3",_ammo, _ammo in _atgmAmmo, _target getVariable ["GOL_MissileWarning", false]] call OKS_fnc_LogDebug;
			};
		};
	}];
};