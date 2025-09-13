params ["_Vehicle", "_PreviousVehicle", "_DispersionInMeters"];
private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug",false];

if(_ConvoyDebug) then {
	format [
		"[CONVOY] Checking and adjusting speed for %1; prev=%2; target dispersion=%3m (band: %4–%5m)",
		_Vehicle,
		_PreviousVehicle,
		_DispersionInMeters,
		(_DispersionInMeters * 0.5),
		(_DispersionInMeters * 1.5)
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
	_LowerLimit = _DispersionInMeters * 0.5; // too close threshold
	_UpperLimit = _DispersionInMeters * 1.5; // too far threshold

	// Too close: slow down
	if (_Distance < _LowerLimit) then {
		_NewSpeed = (_SpeedKph * 0.25);
		_NewSpeedMps = _NewSpeed / 3.6;
		_Vehicle limitSpeed _NewSpeed;
		_Vehicle forceSpeed _NewSpeedMps;
		if(_ConvoyDebug) then {
			format [
				"[CONVOY] %1 Too close (%2m < %3m) - Decreasing speed to %4 kph from %5 kph",
				_Vehicle,
				_Distance,
				_LowerLimit,
				_NewSpeed,
				_SpeedKph
			] spawn OKS_fnc_LogDebug;
		};
		sleep 0.5;
		continue;
	};

	// Too far: speed up
	if (_Distance > _UpperLimit) then {
		_NewSpeed = (_SpeedKph * 1.25);
		_NewSpeedMps = _NewSpeed / 3.6;
		_Vehicle limitSpeed _NewSpeed;
		_Vehicle forceSpeed _NewSpeedMps;
		if(_ConvoyDebug) then {
			format [
				"[CONVOY] %1 Too far (%2m > %3m) - Increasing speed to %4 kph from %5 kph",
				_Vehicle,
				_Distance,
				_UpperLimit,
				_NewSpeed,
				_SpeedKph
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
			"[CONVOY] %1 Dispersion acceptable (%2m within %3–%4m) - Maintaining %5 kph",
			_Vehicle,
			_Distance,
			_LowerLimit,
			_UpperLimit,
			_NewSpeed
		] spawn OKS_fnc_LogDebug;
	};
	sleep 0.5;
	continue;
};