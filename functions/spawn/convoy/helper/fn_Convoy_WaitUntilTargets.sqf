
params ["_ConvoyArray"];
private _ConvoyTargetDebug = missionNamespace getVariable ["GOL_Convoy_Target_Debug", false];

if (_ConvoyArray isEqualTo [] || {isNull (_ConvoyArray select 0)}) exitWith {};

// Tunables for this gate; now wired to CBA settings
private _spottingRange = missionNamespace getVariable ["OKS_Convoy_SpottingRange", 400];
private _minimumTargets = missionNamespace getVariable ["OKS_Convoy_MinimumTargets", 1];
private _lockingTime = missionNamespace getVariable ["OKS_Convoy_LockingTime", 3];
private _minimumIdentification = missionNamespace getVariable ["OKS_Convoy_MinimumIdentification", 0.5];

// Scan pacing / load shedding (reduces periodic stutter by spreading work)
private _scanInterval = missionNamespace getVariable ["OKS_Convoy_TargetScanInterval", 1.5];
private _scanJitter = missionNamespace getVariable ["OKS_Convoy_TargetScanJitter", 0.8];
private _vehiclesPerTick = floor (missionNamespace getVariable ["OKS_Convoy_TargetScanVehiclesPerTick", 1]);
private _detectorStride = floor (missionNamespace getVariable ["OKS_Convoy_TargetScanStride", 3]);
private _maxCandidatesPerVehicle = floor (missionNamespace getVariable ["OKS_Convoy_TargetScanMaxCandidatesPerVehicle", 6]);
private _maxRuntime = missionNamespace getVariable ["OKS_Convoy_TargetScanMaxRuntime", 900];

_scanInterval = _scanInterval max 0.1;
_scanJitter = _scanJitter max 0;
_vehiclesPerTick = (_vehiclesPerTick max 1) min 10;
_detectorStride = (_detectorStride max 1) min 10;
_maxCandidatesPerVehicle = (_maxCandidatesPerVehicle max 1) min 50;

if(hasInterface && isServer) then {
	_minimumTargets = 1; // Override for editor testing
	"[CONVOY] Editor Detected - Convoy will trigger on 1 ground target." spawn OKS_fnc_LogDebug;
};

// Local LOS helper (kept self-contained)
private _hasLOS = {
	params ["_observerUnit", "_target", "_spottingRange"];
	if (isNull _observerUnit || isNull _target) exitWith { false };
	if (!alive _observerUnit || !alive _target) exitWith { false };

	// Cheap accept: if the observer already has strong ID and target is within range,
	// avoid expensive geometry checks.
	if ((_observerUnit knowsAbout _target) > 2 && {(_observerUnit distance2D _target) < _spottingRange}) exitWith { true };

	private _eyePosObserver = eyePos _observerUnit;
	private _eyePosTarget = eyePos _target;
	private _TargetsInLine = lineIntersectsSurfaces [_eyePosObserver, _eyePosTarget, _observerUnit, _target, true, 1, "GEOM", "VIEW", false];
	private _VisibilityValue = [objNull, "FIRE"] checkVisibility [_eyePosObserver, _eyePosTarget];
	(isNil "_TargetsInLine" || {_TargetsInLine isEqualTo []}) && (_VisibilityValue > 0.3)
};

// Hostility check relative to observer's group side
private _isHostile = {
	params ["_observerVehicle", "_unit"];
	private _observerUnit = effectiveCommander _observerVehicle;
	if (isNull _observerUnit) then { _observerUnit = driver _observerVehicle; };
	if (isNull _observerUnit) exitWith { false };
	(side (group _observerUnit) getFriend (side (group _unit))) < 0.6
};

private _steadySince = -1;
private _scanIndex = floor (random (count _ConvoyArray));
private _startTime = time;

// De-sync multiple convoys so their scans don't spike on the same frame.
sleep (random _scanInterval);

while { (time - _startTime) <= _maxRuntime } do {
	private _active = _ConvoyArray select {
		!isNull _x
		&& {alive _x}
		&& {canMove _x}
		&& {!(_x getVariable ["GOL_ConvoyAmbushed", false])}
	};
	if (_active isEqualTo []) exitWith {};

	// Only relevant while the convoy is still in CARELESS.
	private _carelessCount = 0;
	{
		if ( ({behaviour _x isEqualTo "CARELESS"} count (crew _x)) > 0 ) then { _carelessCount = _carelessCount + 1; };
	} forEach _active;
	if (_carelessCount == 0) exitWith {};

	sleep (_scanInterval + (random _scanJitter));

	private _confirmedTotal = 0;
	private _closeThreat = false;

	// Build a list of detector candidates spread across the convoy.
	// If the convoy is short (<= 3 vehicles), only the lead scans.
	private _detectorCandidates = [];
	if ((count _active) <= 3) then {
		_detectorCandidates pushBack (_active select 0);
	} else {
		for "_idx" from 0 to ((count _active) - 1) step _detectorStride do {
			_detectorCandidates pushBack (_active select _idx);
		};
	};

	// Scan a capped number of detectors per tick (round-robin across the detector list).
	private _toScan = [];
	private _detCount = count _detectorCandidates;
	private _take = (_vehiclesPerTick min _detCount) max 1;
	for "_i" from 0 to (_take - 1) do {
		_scanIndex = (_scanIndex + 1) % _detCount;
		_toScan pushBack (_detectorCandidates select _scanIndex);
	};

	{
		private _observerVeh = _x;
		private _observerUnit = effectiveCommander _observerVeh;
		if (isNull _observerUnit) then { _observerUnit = driver _observerVeh; };
		if (isNull _observerUnit) then { continue; };

		if (_observerVeh getVariable ["OKS_Convoy_Casualties", false]) then { _lockingTime = 0; };

		private _targetCandidates = _observerVeh targets [true, _spottingRange, []];
		private _checked = 0;
		{
			if (_checked >= _maxCandidatesPerVehicle) exitWith {};
			private _target = _x;
			if (
				alive _target
				&& { !(vehicle _target isKindOf "AIR") }
				&& { [_observerVeh, _target] call _isHostile }
				&& { (_observerUnit knowsAbout _target) >= _minimumIdentification }
			) then {
				_checked = _checked + 1;
				if ([_observerUnit, _target, _spottingRange] call _hasLOS) then {
					_confirmedTotal = _confirmedTotal + 1;
					if ((_observerUnit distance2D _target) <= 50) then { _closeThreat = true; };
					if (_confirmedTotal >= _minimumTargets) then {
						_observerVeh setVariable ["GOL_Convoy_TargetsConfirmed", true, true];
					};
					if (_ConvoyTargetDebug) then {
						format ["[Convoy-Target] %1 confirmed target: %2 (knowsAbout: %3)", _observerVeh, _target, (_observerUnit knowsAbout _target)] spawn OKS_fnc_LogDebug;
					};
				};
			};
		} forEach _targetCandidates;
	} forEach _toScan;

	if (_ConvoyTargetDebug && (_confirmedTotal > 0 || _closeThreat)) then {
		format ["[Convoy-Target] ConfirmedTotal: %1, CloseThreat: %2", _confirmedTotal, _closeThreat] spawn OKS_fnc_LogDebug;
	};

	private _enough = (_confirmedTotal >= _minimumTargets);
	if (_enough) then {
		if (_steadySince < 0) then { _steadySince = time; };
	} else {
		_steadySince = -1;
	};

	private _spottingRangeReady = _enough && ((time - _steadySince) >= _lockingTime);
	if (_spottingRangeReady || _closeThreat) then {
		if (_ConvoyTargetDebug) then {
			"[Convoy-Target] Detected sustained ground threat. Enabling Combat." spawn OKS_fnc_LogDebug;
		};

		private _detectors = _active select { _x getVariable ["GOL_Convoy_TargetsConfirmed", false] };
		{
			private _dispersion = _x getVariable ["OKS_Convoy_Dispersion", 50];
			_dispersion = _dispersion * 1.5;
			[_x, _ConvoyArray, _dispersion] call OKS_fnc_Convoy_ProximityCombatFill;
			_x setVariable ["GOL_Convoy_TargetsConfirmed", false, true];
		} forEach _detectors;

		// Reset locking window for the next potential cluster.
		_steadySince = -1;
	};
};

