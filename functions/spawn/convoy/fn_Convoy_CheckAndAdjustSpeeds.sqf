params ["_Vehicle", "_PreviousVehicle", "_DispersionInMeters"];
private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug",false];

if(_ConvoyDebug) then {
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
	_SpeedKph = _Vehicle getVariable ["OKS_LimitSpeedBase", 20];
	
	// Lead vehicle: keep base speed
	if (isNull _PreviousVehicle) then {
		_NewSpeedMps = _SpeedKph / 3.6;
		_Vehicle limitSpeed _SpeedKph;
		_Vehicle forceSpeed _NewSpeedMps;
		sleep 1;
		continue;
	};
	_Distance = _Vehicle distance _PreviousVehicle;
	_DangerClose = _DispersionInMeters * 0.5;  	 // Very close
	_Close = _DispersionInMeters * 0.75;       	 // Close
	_Far = _DispersionInMeters * 1.5;          	 // Far
	_DangerFar = _DispersionInMeters * 2.0;   	 // Very far

	// 1) Very close: strong slow-down (crawl)
	if (_Distance < _DangerClose) then {
		_NewSpeed = (_SpeedKph * 0.25) max 5;
		_NewSpeedMps = _NewSpeed / 3.6;
		_Vehicle limitSpeed _NewSpeed;
		_Vehicle forceSpeed _NewSpeedMps;
		if(_ConvoyDebug) then {
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
		_NewSpeed = (_SpeedKph * 0.6) max 10;
		_NewSpeedMps = _NewSpeed / 3.6;
		_Vehicle limitSpeed _NewSpeed;
		_Vehicle forceSpeed _NewSpeedMps;
		if(_ConvoyDebug) then {
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
		_NewSpeed = (_SpeedKph * 1.5);
		_NewSpeedMps = _NewSpeed / 3.6;
		_Vehicle limitSpeed _NewSpeed;
		_Vehicle forceSpeed _NewSpeedMps;
		if(_ConvoyDebug) then {
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
		_NewSpeed = (_SpeedKph * 1.25);
		_NewSpeedMps = _NewSpeed / 3.6;
		_Vehicle limitSpeed _NewSpeed;
		_Vehicle forceSpeed _NewSpeedMps;
		if(_ConvoyDebug) then {
			format [
				"[CONVOY] %1 FAR (%2m > %3m) -> %4 kph (base=%5)",
				_Vehicle, _Distance, _Far, _NewSpeed, _SpeedKph
			] spawn OKS_fnc_LogDebug;
		};
		sleep 0.5;
		continue;
	};

	// Within acceptable band: maintain base speed
	_NewSpeed = _SpeedKph;
	_NewSpeedMps = _NewSpeed / 3.6;
	_Vehicle limitSpeed _NewSpeed;
	_Vehicle forceSpeed _NewSpeedMps;
	if(_ConvoyDebug) then {
		format [
			"[CONVOY] %1 OK (%2m in %3–%4m) -> maintain %5 kph",
			_Vehicle, _Distance, _Close, _Far, _NewSpeed
		] spawn OKS_fnc_LogDebug;
	};
	sleep 0.5;
	continue;
};