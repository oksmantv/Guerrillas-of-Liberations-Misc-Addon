/*
	Enemy AI Ignore Player Air Targets - Shared Manager

	Single loop that services every group registered by OKS_fnc_Ignore_PlayerAir
	(registry: missionNamespace "GOL_IgnorePlayerAir_Registry"). Replaces the old
	one-spawned-loop-per-group design. The scheduler time-slices the work across frames.

	Started automatically by OKS_fnc_Ignore_PlayerAir, exits by itself once the registry is empty.

	Per group, per poll:
	  - Mount status is derived from a single `vehicle` pass over the alive units.
	  - AA detection (magazine scan) and convoy/playable exemptions are CACHED. They are only
	    re-run when the group's vehicle composition changes, or every _cacheTime seconds
	    (covers soldiers picking up/dropping AA launchers while dismounted).
	  - Distance is measured from:
	      Vehicle groups  -> nearest mounted vehicle.
	      Infantry groups -> dense core of the group (mean position, refined once to units within
	                         _clusterRadius of that mean) so a single straggler does not skew the range.
	  - Logging only happens when GOL_Enemy_IgnorePlayerAir_DetailedDebug is enabled.
*/

private _enabled = "enabled";
private _dynamic = "dynamic";
private _disabled = "disabled";
private _cacheTime = 60;
private _emptyGrace = 60;
private _clusterRadiusSqr = 75 * 75;

// Unique vehicles of all players currently in an aircraft.
private _getAircraft = {
	params [["_aliveOnly", true]];
	private _list = (allPlayers - entities "HeadlessClient_F") select {
		(!_aliveOnly || { alive _x }) && { vehicle _x isKindOf "Air" }
	};
	_list = _list apply { vehicle _x };
	_list arrayIntersect _list
};

// Un-ignore everything for a group, flag it inactive and queue it for removal from the registry.
private _release = {
	params ["_group", "_remove", "_reason"];
	{ _group ignoreTarget [_x, false]; } forEach ([false] call _getAircraft);
	_group setVariable ["GOL_IgnorePlayerAir_Active", false, true];
	_remove pushBack _group;
	format ["[Ignore Player Air Targets] Group %1 released - %2", _group, _reason] spawn OKS_fnc_LogDebug;
};

while { true } do {
	private _registry = missionNamespace getVariable ["GOL_IgnorePlayerAir_Registry", []];
	if (_registry isEqualTo []) exitWith {};

	private _mode = ["GOL_Enemy_IgnorePlayerAir"] call CBA_settings_fnc_get;
	if (_mode isEqualType []) then { _mode = _mode param [0, _disabled]; };
	private _pollingTime = (["GOL_Enemy_IgnorePlayerAir_PollTime"] call CBA_settings_fnc_get) max 0.5;

	if (_mode isEqualTo _disabled) exitWith {
		private _dummy = [];
		{ [_x, _dummy, "disabled via CBA Settings"] call _release; } forEach _registry;
		missionNamespace setVariable ["GOL_IgnorePlayerAir_Registry", []];
		"[Ignore Player Air Targets] Disabled via CBA Settings, manager exiting." spawn OKS_fnc_LogDebug;
	};

	private _rangeInfantry = ["GOL_Enemy_IgnorePlayerAir_MaxRange"] call CBA_settings_fnc_get;
	private _rangeVehicle = ["GOL_EnemyVehicle_IgnorePlayerAir_MaxRange"] call CBA_settings_fnc_get;
	private _rangeAAA = ["GOL_EnemyVehicle_IgnorePlayerAir_MaxRange_AAA"] call CBA_settings_fnc_get;
	private _ignoreDelay = ["GOL_Enemy_IgnorePlayerAir_IgnoreDelay"] call CBA_settings_fnc_get;
	private _debug = missionNamespace getVariable ["GOL_Enemy_IgnorePlayerAir_DetailedDebug", false];

	private _aircraftList = [true] call _getAircraft;
	private _remove = [];

	{
		private _group = _x;

		if (isNull _group || { !(_group getVariable ["GOL_IgnorePlayerAir_Active", false]) }) then {
			_remove pushBack _group;
			continue;
		};

		// Groups created empty (GroupCreated fires before units are added) get a grace period.
		private _alive = (units _group) select { alive _x };
		if (_alive isEqualTo []) then {
			private _emptySince = _group getVariable "GOL_IPA_emptySince";
			if (isNil "_emptySince") then {
				_emptySince = time;
				_group setVariable ["GOL_IPA_emptySince", _emptySince];
			};
			if (time - _emptySince > _emptyGrace) then {
				[_group, _remove, "no alive units"] call _release;
			};
			continue;
		};
		_group setVariable ["GOL_IPA_emptySince", nil];

		// Mount status - one pass.
		private _vehicles = _alive apply { vehicle _x };
		private _mounted = _vehicles select { !(_x isKindOf "CAManBase") };
		_mounted = _mounted arrayIntersect _mounted;
		private _isVehicle = _mounted isNotEqualTo [];

		private _leaderVeh = vehicle leader _group;
		private _vehicleClass = "";
		if (_isVehicle) then {
			_vehicleClass = typeOf (if (_leaderVeh in _mounted) then { _leaderVeh } else { _mounted select 0 });
		};

		// Static weapons use their own targeting logic.
		if (_vehicleClass != "" && { _vehicleClass isKindOf "Static" }) then {
			[_group, _remove, "using a static weapon"] call _release;
			continue;
		};

		// Cached checks: AA scan, convoy and playable-slot exemptions.
		private _cache = _group getVariable "GOL_IPA_cache";
		if (isNil "_cache" || { !((_cache select 0) isEqualTo _vehicles) || { time >= (_cache select 1) } }) then {
			if (_vehicles findIf { _x getVariable ["OKS_Convoy_Active", false] } > -1) then {
				[_group, _remove, "belongs to an active convoy with its own air targeting"] call _release;
				continue;
			};
			if (_alive findIf { _x in switchableUnits } > -1) then {
				[_group, _remove, "contains a playable slot"] call _release;
				continue;
			};

			// AA detection by "AA" token in ammo classname (see git history for why other heuristics were dropped).
			// Covers mounted vehicles AND dismounted soldiers (`vehicle _x` == `_x` when dismounted).
			private _isAA = false;
			{
				{
					private _ammoClass = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
					if (_ammoClass != "" && { "aa" in (toLower _ammoClass splitString "_") }) exitWith { _isAA = true; };
				} forEach (magazines _x);
				if (_isAA) exitWith {};
			} forEach (_vehicles arrayIntersect _vehicles);

			_cache = [_vehicles, time + _cacheTime, _isAA];
			_group setVariable ["GOL_IPA_cache", _cache];
		};
		private _isAA = _cache select 2;

		// "enabled" mode has no range logic to give AA groups - they keep their own targeting.
		if (_isAA && { _mode != _dynamic }) then {
			[_group, _remove, "AA-equipped - uses its own targeting logic"] call _release;
			continue;
		};

		if (_aircraftList isEqualTo []) then { continue; };

		if (_mode isEqualTo _enabled) then {
			{ _group ignoreTarget [_x, true]; } forEach _aircraftList;
			continue;
		};

		// ---- Dynamic mode ----
		private _range = if (_isAA) then { _rangeAAA } else { if (_isVehicle) then { _rangeVehicle } else { _rangeInfantry } };
		private _rangeType = if (_isAA) then { "AAA" } else { if (_isVehicle) then { "Vehicle" } else { "Infantry" } };

		// Reference point(s) distance is measured from.
		private _refs = [];
		if (_isVehicle) then {
			_refs = _mounted;
		} else {
			private _count = count _alive;
			private _positions = _alive apply { getPosWorld _x };
			private _cx = 0;
			private _cy = 0;
			{ _cx = _cx + (_x select 0); _cy = _cy + (_x select 1); } forEach _positions;
			_cx = _cx / _count;
			_cy = _cy / _count;
			if (_count > 2) then {
				// Refine once: re-centre on the units that sit near the mean (the dense core).
				private _core = _positions select {
					(((_x select 0) - _cx) ^ 2) + (((_x select 1) - _cy) ^ 2) <= _clusterRadiusSqr
				};
				private _coreCount = count _core;
				if (_coreCount > 0 && { _coreCount < _count }) then {
					_cx = 0;
					_cy = 0;
					{ _cx = _cx + (_x select 0); _cy = _cy + (_x select 1); } forEach _core;
					_cx = _cx / _coreCount;
					_cy = _cy / _coreCount;
				};
			};
			_refs = [[_cx, _cy, 0]];
		};

		private _lastInRange = _group getVariable "GOL_IPA_lastInRange";
		if (isNil "_lastInRange") then {
			_lastInRange = createHashMap;
			_group setVariable ["GOL_IPA_lastInRange", _lastInRange];
		};

		{
			private _aircraft = _x;
			private _netId = netId _aircraft;
			private _currentRange = round (selectMin (_refs apply { _x distance2D _aircraft }));

			if (_currentRange < _range) then {
				_lastInRange set [_netId, time];
				_group ignoreTarget [_aircraft, false];
				if (_debug) then {
					format ["[Ignore Player Air Targets] Group %1 engaging %2 - Range %3/%4 (%5 range)", _group, typeOf _aircraft, _currentRange, _range, _rangeType] spawn OKS_fnc_LogDebug;
				};
			} else {
				// Grace period keeps fast/low flybys engageable between polls.
				private _lastTime = _lastInRange getOrDefault [_netId, -1];
				if (_lastTime < 0 || { (time - _lastTime) > _ignoreDelay }) then {
					_lastInRange deleteAt _netId;
					_group ignoreTarget [_aircraft, true];
					if (_debug) then {
						format ["[Ignore Player Air Targets] Group %1 ignoring %2 - Range %3/%4 (%5 range)", _group, typeOf _aircraft, _currentRange, _range, _rangeType] spawn OKS_fnc_LogDebug;
					};
				} else {
					if (_debug) then {
						format ["[Ignore Player Air Targets] Group %1 grace period for %2 - Range %3/%4 (%5 range), %6s left", _group, typeOf _aircraft, _currentRange, _range, _rangeType, round (_ignoreDelay - (time - _lastTime))] spawn OKS_fnc_LogDebug;
					};
				};
			};
		} forEach _aircraftList;
	} forEach _registry;

	if (_remove isNotEqualTo []) then {
		missionNamespace setVariable [
			"GOL_IgnorePlayerAir_Registry",
			(missionNamespace getVariable ["GOL_IgnorePlayerAir_Registry", []]) - _remove
		];
	};

	sleep _pollingTime;
};
