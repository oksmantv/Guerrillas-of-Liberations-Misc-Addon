/*
	How to use:
	[this,["rhsgref_ins_zsu234"],200,2500,100] spawn OKS_fnc_Radar;
*/


params [
	["_Radar",objNull,[objNull,[]]],
	["_VehicleClassnames",[],[[]]],
	["_ShareDistance",2000,[0]],
	["_MaxRangeAAA",2500,[0]],
	["_MinimumAltitude",100,[0]],
	["_Debug",(missionNamespace getVariable ["GOL_AA_Debug",false]),[false]]
];

if (isNull _Radar) exitWith {};

private _radarCrew = crew _Radar;
if (_radarCrew isEqualTo []) exitWith {};

private _radarUnit = _radarCrew select 0;
_radarUnit allowDamage false;

private _logDebug = {
	params ["_message"]; 
	if (!_Debug) exitWith {};
	private _full = format ["[RADAR] %1", _message];
	// Prefer OKS debug pipeline when core debug is enabled, otherwise still write to RPT.
	if (missionNamespace getVariable ["GOL_Core_Debug", false]) then {
		_full spawn OKS_fnc_LogDebug;
	} else {
		diag_log _full;
	};
};

if (_Debug) then {
	[format ["Started | radar=%1 type=%2 shareDist=%3 maxRangeAAA=%4 minAlt=%5 AAAClasses=%6", _Radar, typeOf _Radar, _ShareDistance, _MaxRangeAAA, _MinimumAltitude, _VehicleClassnames]] call _logDebug;
};

// Improve datalink-style sharing (cheap; does not scan the world)
_Radar setVehicleReportOwnPosition true;
_Radar setVehicleReportRemoteTargets true;
_Radar setVehicleReceiveRemoteTargets true;

private _resolveTurretPathForGunner = {
	params ["_vehicle", "_gunner"];
	if (isNull _vehicle || {isNull _gunner}) exitWith { [] };

	private _turretPath = [];
	private _role = assignedVehicleRole _gunner;
	if ((count _role) > 0) then {
		private _roleName = _role select 0;
		switch (_roleName) do {
			case "Turret": {
				if ((count _role) > 1) then {
					_turretPath = _role select 1;
				};
			};
			case "Gunner": {
				// Many static weapons report just "Gunner"; main turret is typically [0]
				_turretPath = [0];
			};
			default {};
		};
	};

	// Fallback: find the turret path whose turretUnit matches this gunner
	if ((count _turretPath) == 0) then {
		private _turrets = allTurrets [_vehicle, true];
		private _index = _turrets findIf { (_vehicle turretUnit _x) isEqualTo _gunner };
		if (_index >= 0) then {
			_turretPath = _turrets select _index;
		} else {
			// Last resort: if there is exactly one turret, assume it's the one we want
			if ((count _turrets) == 1) then {
				_turretPath = _turrets select 0;
			};
		};
	};

	_turretPath
};

while {Alive _Radar} do {
	_radarUnit moveInAny _Radar;

	// Cruise missile proxies can fly very low; don't gate them with the general air MinimumAltitude.
	private _proxyMinimumAltitude = 0;
	private _proxyRangeMultiplier = 2;

	// Prefer OKS missile proxy vehicles via registry (fast; avoids world scanning)
	private _activeProxies = missionNamespace getVariable ["OKS_ScudIntercept_activeProxies", []];
	// Prune dead/null entries occasionally
	_activeProxies = _activeProxies select { !isNull _x && {alive _x} };
	missionNamespace setVariable ["OKS_ScudIntercept_activeProxies", _activeProxies, true];

	private _missileTargets = _activeProxies select {
		private _inRange = (_Radar distance _x) <= (_MaxRangeAAA * _proxyRangeMultiplier);
		private _highEnoughForProxy = ((getPosATL _x) select 2) >= _proxyMinimumAltitude;
		_inRange && _highEnoughForProxy
	};

	// Fallback to radar sensor targets (air) when no missile proxies are present
	private _airTargets = (
		(_Radar targets [true]) select {
			private _candidateVehicle = vehicle _x;
			private _isAir = _x isKindOf "Air";
			private _candidateAlive = alive _candidateVehicle;
			private _candidateHighEnough = ((getPosATL _candidateVehicle) select 2) >= _MinimumAltitude;
			_isAir && _candidateAlive && _candidateHighEnough
		}
	) apply { vehicle _x };

	private _targets = _missileTargets + (_airTargets - _missileTargets);

	// Find AAA assets around the radar that should be assisted
	private _aaaVehicles = (_Radar nearEntities ["LandVehicle", _ShareDistance]) select {
		(typeOf _x) in _VehicleClassnames
	};

	// Periodic summary so we can confirm radar sees proxies and AAA is in range
	private _lastSummary = _Radar getVariable ["OKS_Radar_lastSummary", -1];
	if (_Debug && {(diag_tickTime - _lastSummary) > 10}) then {
		_Radar setVariable ["OKS_Radar_lastSummary", diag_tickTime];
		[format [
			"Loop | activeProxies=%1 missileTargets=%2 airTargets=%3 combined=%4 aaaVehicles=%5 minAltAir=%6 minAltProxy=%7",
			count _activeProxies,
			count _missileTargets,
			count _airTargets,
			count _targets,
			count _aaaVehicles,
			_MinimumAltitude,
			_proxyMinimumAltitude
		]] call _logDebug;

		// Debug why proxies aren't being selected (distance/altitude)
		if ((count _activeProxies) > 0 && (count _missileTargets) == 0) then {
			private _max = (count _activeProxies) min 3;
			for "_i" from 0 to (_max - 1) do {
				private _proxy = _activeProxies select _i;
				private _alt = (getPosATL _proxy) select 2;
				private _dist = _Radar distance _proxy;
				private _taskId = _proxy getVariable ["OKS_ScudIntercept_taskId", ""]; 
				[format ["ProxyProbe | type=%1 taskId=%2 dist=%3 altATL=%4", typeOf _proxy, _taskId, round _dist, _alt]] call _logDebug;
			};
		};
	};

	{
		private _aaa = _x;
		private _aaaGunner = gunner _aaa;
		private _aaaSide = side _aaa;
		if (!isNull _aaaGunner) then {
			_aaaSide = side (group _aaaGunner);
		};

		// Improve datalink-style sharing for AAA assets too
		_aaa setVehicleReportRemoteTargets true;
		_aaa setVehicleReceiveRemoteTargets true;

		{
			private _target = _x;
			if (isNull _target) then {
				continue;
			};
			if (!alive _target) then {
				continue;
			};
			private _isProxyTarget = (_target getVariable ["OKS_ScudIntercept_taskId", ""]) != "";
			private _maxRangeForTarget = _MaxRangeAAA;
			if (_isProxyTarget) then {
				_maxRangeForTarget = _MaxRangeAAA * _proxyRangeMultiplier;
			};
			if ((_aaa distance _target) > _maxRangeForTarget) then {
				continue;
			};

			// Only assist against enemies
			private _targetSide = sideUnknown;
			private _targetCrew = crew _target;
			if !(_targetCrew isEqualTo []) then {
				_targetSide = side (group (_targetCrew select 0));
			} else {
				private _cfgSide = getNumber (configFile >> "CfgVehicles" >> typeOf _target >> "side");
				_targetSide = switch (_cfgSide) do {
					case 0: { east };
					case 1: { west };
					case 2: { resistance };
					default { civilian };
				};
			};
			if ((_aaaSide getFriend _targetSide) > 0.6) then {
				continue;
			};

			private _radarKnowledge = _Radar knowsAbout _target;
			if (!local _aaa) then {
				// Best-effort only: AI AAA is normally server-local. If it isn't, this script should run where the AAA is local.
				if (_Debug) then {
					[format ["Skipped (AAA not local) | aaa=%1 type=%2 owner=%3", _aaa, typeOf _aaa, owner _aaa]] call _logDebug;
				};
				continue;
			};

			// Share knowledge and force target selection
			if (!isNull _aaaGunner) then {
				// Make sure gunner AI is allowed to engage
				_aaaGunner enableAI "TARGET";
				_aaaGunner enableAI "AUTOTARGET";
				(group _aaaGunner) setCombatMode "RED";
				(group _aaaGunner) setBehaviourStrong "COMBAT";
				(group _aaaGunner) allowFleeing 0;
				_aaaGunner reveal [_target, _radarKnowledge];
				_aaaGunner doTarget _target;
				_aaaGunner doFire _target;
				// More forceful orders (often helps vehicle turrets actually commit)
				_aaaGunner commandTarget _target;
				_aaaGunner commandFire _target;
			} else {
				_aaa reveal [_target, _radarKnowledge];
				_aaa doTarget _target;
			};
			private _assignedAfter = if (!isNull _aaaGunner) then { assignedTarget _aaaGunner } else { assignedTarget _aaa };

			// Log when we actually tell an AAA to engage.
			if (_Debug) then {
				private _lastEngageLog = _aaa getVariable ["OKS_Radar_lastEngageLog", -1];
				if ((diag_tickTime - _lastEngageLog) > 2) then {
					_aaa setVariable ["OKS_Radar_lastEngageLog", diag_tickTime];
					private _taskId = _target getVariable ["OKS_ScudIntercept_taskId", ""]; 
					private _distance = _aaa distance _target;
					private _canFire = canFire _aaa;
					private _turretPath = if (!isNull _aaaGunner) then { [_aaa, _aaaGunner] call _resolveTurretPathForGunner } else { [] };
					private _turretWeapon = if ((count _turretPath) > 0) then { _aaa currentWeaponTurret _turretPath } else { currentWeapon _aaa };
					// weaponState [vehicle, turretPath] gives turret state; weaponState unit often reports the infantry weapon.
					private _weaponState = if ((count _turretPath) > 0) then { weaponState [_aaa, _turretPath] } else { weaponState _aaa };
					[format [
						"Engage | aaa=%1 gunner=%2 target=%3 taskId=%4 dist=%5/%6 kb=%7 aaaSide=%8 targetSide=%9 assigned=%10 canFire=%11 turretPath=%12 turretWeapon=%13 weaponState=%14",
						typeOf _aaa,
						if (isNull _aaaGunner) then {"<none>"} else {typeOf _aaaGunner},
						typeOf _target,
						_taskId,
						round _distance,
						round _maxRangeForTarget,
						_radarKnowledge,
						_aaaSide,
						_targetSide,
						if (isNull _assignedAfter) then {"<null>"} else {typeOf _assignedAfter},
						_canFire,
						_turretPath,
						_turretWeapon,
						_weaponState
					]] call _logDebug;
				};
			};
		} forEach _targets;
	} forEach _aaaVehicles;

	if ((count _aaaVehicles) > 0 && (count _targets) > 0) then {
		// Keep assisting reasonably frequently without forcing firing.
		sleep 2;
	} else {
		sleep 10;
	};
};

_radarUnit allowDamage true;
