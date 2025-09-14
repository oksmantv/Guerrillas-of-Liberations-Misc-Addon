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
	private _Distance = _Vehicle distance _leader;
	private _DangerClose = _DispersionInMeters * 0.5;   	// Very close
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