params ["_Vehicle", "_PreviousVehicle", "_DispersionInMeters"]; 
private _ConvoySpeedDebug = missionNamespace getVariable ["GOL_Convoy_Speed_Debug", false];
private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug", false];

if(_ConvoySpeedDebug) then {
	format [
		"[CONVOY] Adjusting %1; prev=%2; D=%3m | thresholds: DC=%4m, C=%5m, F=%6m, DF=%7m",
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
	if (_distToWp <= 20) then {
		if ((vectorMagnitude (velocity _Vehicle)) < 0.5) then {
			if (_stuckTimer < 0) then { _stuckTimer = time; _Vehicle setVariable ["OKS_Convoy_StuckTimer", _stuckTimer]; };
			if ((time - _stuckTimer) > 2) then {
				_Vehicle sendSimpleCommand "STOPTURNING";
				_Vehicle sendSimpleCommand "FORWARD";
				if (_ConvoyDebug) then {
					format ["[CONVOY] Nudge: %1 stuck near WP, issued sendSimpleCommand FORWARD", _Vehicle] spawn OKS_fnc_LogDebug;
				};
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
	private _leader = _PreviousVehicle;
	if (!isNull _leader) then {
		private _engagingAA = _leader getVariable ["OKS_Convoy_AAEngaging", false];
		private _disabled = (isNull _leader) || {!(alive _leader)} || {!(canMove _leader)};
		if (_engagingAA || _disabled) then {
			// Find a new leader ahead from convoy array stored on lead vehicle
			private _leadVeh = _Vehicle getVariable ["OKS_Convoy_LeadVehicle", objNull];
			if (!isNull _leadVeh) then {
				private _arr = _leadVeh getVariable ["OKS_Convoy_VehicleArray", []];
				private _idx = _arr find _Vehicle;
				if (_idx > 0) then {
					// Attempt to bind to the nearest valid vehicle ahead (idx-1, idx-2, ...)
					private _newLeader = objNull;
					for "_j" from (_idx - 1) to 0 step -1 do {
						private _cand = _arr select _j;
						if (!isNull _cand 
							&& {alive _cand} 
							&& {canMove _cand} 
							&& {!(_cand getVariable ["OKS_Convoy_AAEngaging", false])}
						) exitWith { _newLeader = _cand };
					};
					if (!isNull _newLeader) then {
						if (_ConvoyDebug) then {
							private _reason = if (_engagingAA) then {"AA-engaging"} else {"disabled"};
							format [
								"[CONVOY] Rebinding leader for %1 -> %2 (reason: %3)",
								_Vehicle,
								_newLeader,
								_reason
							] spawn OKS_fnc_LogDebug;
						};
						_leader = _newLeader; _PreviousVehicle = _newLeader;

						// PATCH: Reassign the follower of the AA vehicle to follow the AA vehicle's previous leader
						// Only applies if the disabled/AA vehicle is not the lead vehicle
						if (_idx < (count _arr) - 1) then {
							private _follower = _arr select (_idx + 1);
							if (!isNull _follower) then {
								_follower setVariable ["OKS_Convoy_Leader", _newLeader, true];
								if (_ConvoyDebug) then {
									format [
										"[CONVOY] Follower %1 now follows %2 after AA/disabled event",
										_follower,
										_newLeader
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
	if (isNull _leader) then {
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
	private _dispMod = 1;
	private _dispersionOriginal = _DispersionInMeters;
	private _lastWpIdx = _Vehicle getVariable ["OKS_Convoy_LastWaypointIdx", _wpIdx];
	if (_distToWp <= 200) then { _dispMod = 1.5; };
	// Reset dispersion when waypoint index changes (waypoint cleared)
	if (_wpIdx != _lastWpIdx) then {
		_dispMod = 1;
		_Vehicle setVariable ["OKS_Convoy_LastWaypointIdx", _wpIdx];
		if (_ConvoyDebug) then {
			format ["[CONVOY] %1 cleared WP, dispersion reset to %2m", _Vehicle, _dispersionOriginal] spawn OKS_fnc_LogDebug;
		};
	} else {
		_Vehicle setVariable ["OKS_Convoy_LastWaypointIdx", _wpIdx];
	};
	private _DispersionInMeters = _dispersionOriginal * _dispMod;
	if (_ConvoyDebug && {_dispMod > 1}) then {
		format ["[CONVOY] %1 near WP (%2m): dispersion increased to %3m", _Vehicle, _distToWp, _DispersionInMeters] spawn OKS_fnc_LogDebug;
	};

	private _Distance = _Vehicle distance _leader;
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
			format [
				"[CONVOY] %1 VERY CLOSE (%2m < %3m) -> %4 kph (base=%5)",
				_Vehicle, _Distance, _DangerClose, _NewSpeed, _SpeedKph
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
			format [
				"[CONVOY] %1 CLOSE (%2m < %3m) -> %4 kph (base=%5)",
				_Vehicle, _Distance, _Close, _NewSpeed, _SpeedKph
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
			format [
				"[CONVOY] %1 VERY FAR (%2m > %3m) -> %4 kph (base=%5)",
				_Vehicle, _Distance, _DangerFar, _NewSpeed, _SpeedKph
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
			format [
				"[CONVOY] %1 FAR (%2m > %3m) -> %4 kph (base=%5)",
				_Vehicle, _Distance, _Far, _NewSpeed, _SpeedKph
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
		format [
			"[CONVOY] %1 OK (%2m in %3–%4m) -> maintain %5 kph",
			_Vehicle, _Distance, _Close, _Far, _NewSpeed
		] spawn OKS_fnc_LogDebug;
	};
	sleep 0.5;
	continue;
};