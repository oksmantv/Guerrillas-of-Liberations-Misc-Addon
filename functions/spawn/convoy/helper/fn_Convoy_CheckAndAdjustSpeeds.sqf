params ["_Vehicle", "_PreviousVehicle", "_DispersionInMeters"]; 
private _ConvoySpeedDebug = missionNamespace getVariable ["GOL_Convoy_Speed_Debug", false];
private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug", false];

if(_ConvoySpeedDebug) then {
	format [
		"[CONVOY-SPEED-ADJUST] Adjusting %1; prev=%2; D=%3m | thresholds: DC=%4m, C=%5m, F=%6m, DF=%7m",
		_Vehicle,
		_PreviousVehicle,
		_DispersionInMeters,
		(_DispersionInMeters * 0.3),
		(_DispersionInMeters * 0.5),
		(_DispersionInMeters * 1.5),
		(_DispersionInMeters * 2.0)
	] spawn OKS_fnc_LogDebug;
};

waitUntil {
	sleep 0.5;
	{behaviour _X isEqualTo "CARELESS"} count crew _Vehicle > 0
};
while { {behaviour _X isEqualTo "CARELESS"} count crew _Vehicle > 0 } do {
	// Calculate waypoint and distance to waypoint for stuck vehicle logic
	private _group = group _Vehicle;
	private _wpIdx = currentWaypoint _group;
	private _wpPos = waypointPosition [_group, _wpIdx];
	private _distToWp = _Vehicle distance _wpPos;

	// Stuck vehicle detection and nudge using sendSimpleCommand
	private _stuckTimer = _Vehicle getVariable ["OKS_Convoy_StuckTimer", -1];
	private _wpType = waypointType [_group, _wpIdx];
	if (_wpType != "HOLD" && _distToWp <= 20) then {
		private _currentSpeed = vectorMagnitude (velocity _Vehicle);
		if (_currentSpeed < 5) then {
			if (_stuckTimer < 0) then { _stuckTimer = time; _Vehicle setVariable ["OKS_Convoy_StuckTimer", _stuckTimer]; };
			if ((time - _stuckTimer) > 2) then {
				_Vehicle sendSimpleCommand "STOPTURNING";
				_Vehicle sendSimpleCommand "FORWARD";
				if (_ConvoyDebug) then {
					format ["[CONVOY-NUDGE] %1 stuck near WP, issued sendSimpleCommand FORWARD (speed=%.2f)", _Vehicle, _currentSpeed] spawn OKS_fnc_LogDebug;
				};
				// Restore speed after nudge
				private _restoreSpeed = _Vehicle getVariable ["OKS_LimitSpeedBase", 20];
				_Vehicle limitSpeed _restoreSpeed;
				_Vehicle forceSpeed (_restoreSpeed / 3.6);
				_Vehicle setVariable ["OKS_Convoy_StuckTimer", time];
			};
		} else {
			_Vehicle setVariable ["OKS_Convoy_StuckTimer", -1];
		};
	} else {
		_Vehicle setVariable ["OKS_Convoy_StuckTimer", -1];
	};
	private _SpeedKph = _Vehicle getVariable ["OKS_LimitSpeedBase", 20];

	// Rebind leader if the current one is AA-engaging or disabled/cannot move
	private _convoyLeaderVehicle = _PreviousVehicle;
	if (!isNull _convoyLeaderVehicle) then {
		private _isLeaderEngagingAA = _convoyLeaderVehicle getVariable ["OKS_Convoy_AAEngaging", false];
		private _isLeaderDisabled = (isNull _convoyLeaderVehicle) || {!(alive _convoyLeaderVehicle)} || {!(canMove _convoyLeaderVehicle)};
		if (_isLeaderEngagingAA || _isLeaderDisabled) then {
			// Find a new leader ahead from convoy array stored on lead vehicle
			private _leadConvoyVehicle = _Vehicle getVariable ["OKS_Convoy_LeadVehicle", objNull];
			if (!isNull _leadConvoyVehicle) then {
				private _convoyVehicleArray = _leadConvoyVehicle getVariable ["OKS_Convoy_VehicleArray", []];
				private _vehicleArrayIndex = _convoyVehicleArray find _Vehicle;
				if (_vehicleArrayIndex > 0) then {
					// Attempt to bind to the nearest valid vehicle ahead (vehicleArrayIndex-1, vehicleArrayIndex-2, ...)
					private _newLeaderVehicle = objNull;
					for "_searchIndex" from (_vehicleArrayIndex - 1) to 0 step -1 do {
						private _candidateLeaderVehicle = _convoyVehicleArray select _searchIndex;
						if (!isNull _candidateLeaderVehicle 
							&& {alive _candidateLeaderVehicle} 
							&& {canMove _candidateLeaderVehicle} 
							&& {!(_candidateLeaderVehicle getVariable ["OKS_Convoy_AAEngaging", false])}
						) exitWith { _newLeaderVehicle = _candidateLeaderVehicle };
					};
					if (!isNull _newLeaderVehicle) then {
						if (_ConvoyDebug) then {
							private _rebindReason = if (_isLeaderEngagingAA) then {"AA-engaging"} else {"disabled"};
							format [
								"[CONVOY-REBINDED] %1 -> %2 (reason: %3)",
								_Vehicle,
								_newLeaderVehicle,
								_rebindReason
							] spawn OKS_fnc_LogDebug;
						};
						_convoyLeaderVehicle = _newLeaderVehicle; _PreviousVehicle = _newLeaderVehicle;

						// PATCH: Reassign the follower of the AA vehicle to follow the AA vehicle's previous leader
						// Only applies if the disabled/AA vehicle is not the lead vehicle
						if (_vehicleArrayIndex < (count _convoyVehicleArray) - 1) then {
							private _followerVehicle = _convoyVehicleArray select (_vehicleArrayIndex + 1);
							if (!isNull _followerVehicle) then {
								_followerVehicle setVariable ["OKS_Convoy_Leader", _newLeaderVehicle, true];
								if (_ConvoyDebug) then {
									format [
										"[CONVOY-FOLLOWER-REBINDED] %1 now follows %2 after AA/disabled event",
										_followerVehicle,
										_newLeaderVehicle
									] spawn OKS_fnc_LogDebug;
								};
							};
						};
					};
				};
			};
		};
	};
	
	// Lead vehicle: keep base speed
	if (isNull _convoyLeaderVehicle) then {
		private _NewSpeedMps = _SpeedKph / 3.6;
		_Vehicle limitSpeed _SpeedKph;
		_Vehicle forceSpeed _NewSpeedMps;
		sleep 1;
		continue;
	};

	// PATCH: Dynamically increase dispersion near waypoints, reset when waypoint is cleared (per-vehicle variable)
	private _group = group _Vehicle;
	private _wpIdx = currentWaypoint _group;
	private _wpPos = waypointPosition [_group, _wpIdx];
	private _distToWp = _Vehicle distance _wpPos;
	// Dispersion logic: ensure original value is respected and only increased near waypoint
	private _dispMod = 1;
	// Waypoint-level suppression: description tag indicates no near-WP dispersion increase
	private _wpDesc = waypointDescription [_group, _wpIdx];
	private _suppressNearWp = (toUpper _wpDesc) find "OKS_SUPPRESS_DISPERSION" >= 0;
	private _dispersionOriginal = _DispersionInMeters;
	private _lastWpIdx = _Vehicle getVariable ["OKS_Convoy_LastWaypointIdx", _wpIdx];
	// If suppression is tagged on the waypoint, do not enlarge dispersion near wp
	if (!_suppressNearWp) then {
		if (_distToWp <= 200) then { _dispMod = 1.5; };
	};
	// Reset dispersion when waypoint index changes (waypoint cleared)
	if (_wpIdx != _lastWpIdx) then {
		_dispMod = 1;
		_Vehicle setVariable ["OKS_Convoy_LastWaypointIdx", _wpIdx];
		if (_ConvoyDebug) then {
		format ["[CONVOY-DISPERSION-RESET] %1 cleared WP, dispersion reset to %2m (param=%3m)", _Vehicle, _dispersionOriginal, _dispersionOriginal] spawn OKS_fnc_LogDebug;
		};
	} else {
		_Vehicle setVariable ["OKS_Convoy_LastWaypointIdx", _wpIdx];
	};
	private _DispersionInMeters = _dispersionOriginal * _dispMod;
	if (_ConvoyDebug && {_dispMod > 1}) then {
	format ["[CONVOY-DISPERSION-INCREASED] %1 near WP (%2m): dispersion increased to %3m (param=%4m)", _Vehicle, _distToWp, _DispersionInMeters, _dispersionOriginal] spawn OKS_fnc_LogDebug;
	};

	private _Distance = _Vehicle distance _convoyLeaderVehicle;
	private _DangerClose = _DispersionInMeters * 0.5;    	// Very close
	private _Close = _DispersionInMeters * 0.75;       	// Close
	private _Far = _DispersionInMeters * 1.5;          	// Far
	private _DangerFar = _DispersionInMeters * 2.0;    	// Very far

	// 1) Very close: strong slow-down (crawl)
	if (_Distance < _DangerClose) then {
		private _NewSpeed = (_SpeedKph * 0.25) max 5;
		private _NewSpeedMps = _NewSpeed / 3.6;
		_Vehicle limitSpeed _NewSpeed;
		_Vehicle forceSpeed _NewSpeedMps;
		if(_ConvoySpeedDebug) then {
			private _vehicleName = if (!isNull _Vehicle) then { GetText (configFile >> "CfgVehicles" >> (typeOf _Vehicle) >> "displayName") } else { str _Vehicle };
			private _leaderName = if (!isNull _convoyLeaderVehicle) then { GetText (configFile >> "CfgVehicles" >> (typeOf _convoyLeaderVehicle) >> "displayName") } else { "UNKNOWN" };
			format [
				"[CONVOY-SPEED-VERY-CLOSE] %1 follows %2 (%3m < %4m) -> %5 kph",
				_vehicleName, _leaderName, _Distance, _DangerClose, _NewSpeed
			] spawn OKS_fnc_LogDebug;
		};
		sleep 0.5;
		continue;
	};

	// 2) Close: moderate slow-down
	if (_Distance < _Close) then {
		private _NewSpeed = (_SpeedKph * 0.6) max 10;
		private _NewSpeedMps = _NewSpeed / 3.6;
		_Vehicle limitSpeed _NewSpeed;
		_Vehicle forceSpeed _NewSpeedMps;
		if(_ConvoySpeedDebug) then {
			private _vehicleName = if (!isNull _Vehicle) then { GetText (configFile >> "CfgVehicles" >> (typeOf _Vehicle) >> "displayName") } else { str _Vehicle };
			private _leaderName = if (!isNull _convoyLeaderVehicle) then { GetText (configFile >> "CfgVehicles" >> (typeOf _convoyLeaderVehicle) >> "displayName") } else { "UNKNOWN" };
			format [
				"[CONVOY-SPEED-CLOSE] %1 follows %2 (%3m < %4m) -> %5 kph",
				_vehicleName, _leaderName, _Distance, _Close, _NewSpeed
			] spawn OKS_fnc_LogDebug;
		};
		sleep 0.5;
		continue;
	};

	// 3) Very far: strong catch-up
	if (_Distance > _DangerFar) then {
		private _NewSpeed = (_SpeedKph * 1.5);
		private _NewSpeedMps = _NewSpeed / 3.6;
		_Vehicle limitSpeed _NewSpeed;
		_Vehicle forceSpeed _NewSpeedMps;
		if(_ConvoySpeedDebug) then {
			private _vehicleName = if (!isNull _Vehicle) then { GetText (configFile >> "CfgVehicles" >> (typeOf _Vehicle) >> "displayName") } else { str _Vehicle };
			private _leaderName = if (!isNull _convoyLeaderVehicle) then { GetText (configFile >> "CfgVehicles" >> (typeOf _convoyLeaderVehicle) >> "displayName") } else { "UNKNOWN" };
			format [
				"[CONVOY-SPEED-VERY-FAR] %1 follows %2 (%3m > %4m) -> %5 kph",
				_vehicleName, _leaderName, _Distance, _DangerFar, _NewSpeed
			] spawn OKS_fnc_LogDebug;
		};
		sleep 0.5;
		continue;
	};

	// 4) Far: modest catch-up
	if (_Distance > _Far) then {
		private _NewSpeed = (_SpeedKph * 1.25);
		private _NewSpeedMps = _NewSpeed / 3.6;
		_Vehicle limitSpeed _NewSpeed;
		_Vehicle forceSpeed _NewSpeedMps;
		if(_ConvoySpeedDebug) then {
			private _vehicleName = if (!isNull _Vehicle) then { GetText (configFile >> "CfgVehicles" >> (typeOf _Vehicle) >> "displayName") } else { str _Vehicle };
			private _leaderName = if (!isNull _convoyLeaderVehicle) then { GetText (configFile >> "CfgVehicles" >> (typeOf _convoyLeaderVehicle) >> "displayName") } else { "UNKNOWN" };
			format [
				"[CONVOY-SPEED-FAR] %1 follows %2 (%3m > %4m) -> %5 kph",
				_vehicleName, _leaderName, _Distance, _Far, _NewSpeed
			] spawn OKS_fnc_LogDebug;
		};
		sleep 0.5;
		continue;
	};

	// Within acceptable band: maintain base speed
	private _NewSpeed = _SpeedKph;
	private _NewSpeedMps = _NewSpeed / 3.6;
	_Vehicle limitSpeed _NewSpeed;
	_Vehicle forceSpeed _NewSpeedMps;
	if(_ConvoySpeedDebug) then {
	private _vehicleName = if (!isNull _Vehicle) then { GetText (configFile >> "CfgVehicles" >> (typeOf _Vehicle) >> "displayName") } else { str _Vehicle };
	private _leaderName = if (!isNull _convoyLeaderVehicle) then { GetText (configFile >> "CfgVehicles" >> (typeOf _convoyLeaderVehicle) >> "displayName") } else { "UNKNOWN" };
		format [
			"[CONVOY-SPEED-OK] %1 follows %2 (%3m in %4–%5m) -> %6 kph",
			_vehicleName, _leaderName, _Distance, _Close, _Far, _NewSpeed
		] spawn OKS_fnc_LogDebug;
	};
	sleep 0.5;
	continue;
};