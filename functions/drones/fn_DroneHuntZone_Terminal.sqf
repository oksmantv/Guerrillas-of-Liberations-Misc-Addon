/*
	OKS_fnc_DroneHuntZone_Terminal

	Executes terminal guidance phase: two-stage flight (horizontal then dive), ballistic mode, comprehensive logging.
	Handles the final approach from terminal start distance to impact.

	Parameters:
		0: OBJECT - Drone vehicle
		1: OBJECT - Drone controller unit
		2: OBJECT - Target object
		3: NUMBER - Cruise speed in km/h
		4: NUMBER - Terminal start distance in meters (for logging)
		5: NUMBER - Terminal aim offset radius in meters (miss chance)
		6: NUMBER - Detonation distance in meters
		7: STRING - Explosion classname
		8: CODE - Log debug function reference
		9: NUMBER - Patrol altitude in meters (horizontal phase altitude)

	Returns:
		BOOL - True if detonated during terminal phase, false otherwise

	Example:
		private _detonated = [_drone, _controller, _target, 70, 100, 10, 5, "OKS_Drone_Warhead_Medium", _logDebug, 40] call OKS_fnc_DroneHuntZone_Terminal;
*/

params [
	["_droneVehicle", objNull, [objNull]],
	["_droneControllerUnit", objNull, [objNull]],
	["_hostileTarget", objNull, [objNull]],
	["_cruiseSpeedKilometersPerHour", 70, [0]],
	["_terminalStartDistanceMeters", 100, [0]],
	["_terminalAimOffsetRadiusMeters", 10, [0]],
	["_detonationDistanceMeters", 5, [0]],
	["_explosionClassName", "OKS_Drone_Warhead_Medium", [""]],
	["_logDebug", {}, [{}]],
	["_patrolAltitudeMeters", 40, [0]]
];

// Force low altitude for terminal run
_droneVehicle flyInHeight 3;

// Calculate randomized aim point with miss chance
private _aimAngleDegrees = random 360;
private _aimRadiusMeters = random _terminalAimOffsetRadiusMeters;
private _aimOffsetRelativeToDirection = [
	(sin _aimAngleDegrees) * _aimRadiusMeters,  // Right (full range)
	-(abs(cos _aimAngleDegrees)) * _aimRadiusMeters,  // Forward (always negative = short of target)
	0  // Ground level
];

// Lock aim point for entire run (prevents oscillation)
private _terminalAimASL = [_droneVehicle, _hostileTarget, _aimOffsetRelativeToDirection] call OKS_fnc_DroneHelper_GetAimPoint;
[_droneVehicle, format ["Terminal aimpoint locked | aimASL=%1 offsetDist=%2m", _terminalAimASL, vectorMagnitude _aimOffsetRelativeToDirection]] call _logDebug;

// Terminal guidance parameters
private _speedMetersPerSecond = _cruiseSpeedKilometersPerHour / 3.6;
private _stopSteeringDistanceMeters = _droneVehicle getVariable ["OKS_StopSteeringDistance", 50];
_stopSteeringDistanceMeters = (_stopSteeringDistanceMeters max 0) min 200;
private _diveDistanceMeters = 40;  // Keep current altitude until final 40m dive
private _terminalStartAltitudeASL = (getPosASL _droneVehicle) select 2;  // Maintain current altitude during horizontal phase

[_droneVehicle, format ["Terminal phases | horizontal=%1m to %2m, dive=%3m to 0m, ballistic=%4m to 0m, startAltASL=%5m", 
	_terminalStartDistanceMeters, _diveDistanceMeters, _diveDistanceMeters, _stopSteeringDistanceMeters, _terminalStartAltitudeASL]] call _logDebug;

// Terminal state
private _ballisticMode = false;
private _ballisticDirectionNormalized = [0,0,0];
private _terminalMaxTimeSeconds = 15;
private _terminalStartTimeSeconds = diag_tickTime;
private _didDetonateOnImpact = false;
private _lastTerminalTickLogTimeSeconds = -1;
private _lastJammerCheckTime = diag_tickTime;

// Mark drone as in terminal phase (for disruptor detection)
_droneVehicle setVariable ["GOL_InTerminalPhase", true, true];

// Terminal guidance loop
while {alive _droneVehicle && {!(_droneVehicle getVariable ["OKS_Drone_Disabled", false])} && {diag_tickTime - _terminalStartTimeSeconds < _terminalMaxTimeSeconds}} do {		// Early exit check for disruptor hits
		if (_droneVehicle getVariable ["OKS_Drone_Disabled", false]) exitWith {
			[_droneVehicle, "Terminal aborted | disruptor hit detected"] call _logDebug;
			private _vel = velocity _droneVehicle;
			private _fallVel = [(_vel select 0) * 0.2, (_vel select 1) * 0.2, -5];
			_droneVehicle setVelocity _fallVel;  // Tumbling fall instead of instant stop
		};
			// Re-check for jammers every 1 second
	if (_stopSteeringDistanceMeters < 100 && {diag_tickTime - _lastJammerCheckTime >= 1}) then {
		_lastJammerCheckTime = diag_tickTime;
		private _dronePos = getPosATL _droneVehicle;
		private _jammerRange = missionNamespace getVariable ["GOL_Jammer_EffectRange", 350];
		[_droneVehicle, format ["Jammer re-scan | dronePos=%1 currentBallisticDist=%2m", _dronePos, _stopSteeringDistanceMeters]] call _logDebug;
		private _nearbyJammers = [_dronePos, _jammerRange, "OKS_DroneJammer"] call OKS_fnc_DroneJammer_GetNearbyCarriers;
		if !(_nearbyJammers isEqualTo []) then {
			_stopSteeringDistanceMeters = 100;
			_droneVehicle setVariable ["OKS_StopSteeringDistance", 100];
			private _jammerDetails = _nearbyJammers apply {format ["%1@%2m", _x, round (_droneVehicle distance _x)]};
			[_droneVehicle, format ["JAMMER DETECTED IN FLIGHT | carriers=%1 details=%2 | ballistic distance: 50m->100m", count _nearbyJammers, _jammerDetails]] call _logDebug;
		} else {
			[_droneVehicle, "Jammer re-scan | no jammers detected"] call _logDebug;
		};
	};

	// Force low flight (UAV AI can climb)
	_droneVehicle flyInHeight 3;

	private _distToTarget2DNow = _droneVehicle distance2D _hostileTarget;

	// Enter ballistic mode at stop steering distance
	if (!_ballisticMode && {_distToTarget2DNow <= _stopSteeringDistanceMeters}) then {
		_ballisticMode = true;
		private _currentDroneASL = getPosASL _droneVehicle;
		_ballisticDirectionNormalized = vectorNormalized (_currentDroneASL vectorFromTo _terminalAimASL);
		if ((vectorMagnitude _ballisticDirectionNormalized) < 0.001) then {
			_ballisticDirectionNormalized = vectorNormalized (velocity _droneVehicle);
		};
		[_droneVehicle, format ["Terminal BALLISTIC START | dist2D=%1 dir=%2", _distToTarget2DNow, _ballisticDirectionNormalized]] call _logDebug;
	};

	// Ballistic mode: maintain orientation while pushing forward
	if (_ballisticMode) then {
		// Keep drone oriented toward aim point during ballistic phase
		_droneVehicle setVectorDirAndUp [_ballisticDirectionNormalized, [0,0,1]];
		_droneVehicle setVelocity (_ballisticDirectionNormalized vectorMultiply _speedMetersPerSecond);
	} else {
		// Two-stage guidance: horizontal then dive
		private _originASL = getPosASL _droneVehicle;
		private _targetAimASL = _terminalAimASL;
		private _wasHorizontal = (_distToTarget2DNow > _diveDistanceMeters);

		// Stage 1: Horizontal at entry altitude
		if (_distToTarget2DNow > _diveDistanceMeters) then {
			_targetAimASL = [_terminalAimASL select 0, _terminalAimASL select 1, _terminalStartAltitudeASL];
		};

		// Calculate direction and set velocity
		private _directionVector = _originASL vectorFromTo _targetAimASL;
		private _directionVectorNormalized = vectorNormalized _directionVector;
		private _nowHorizontal = (_distToTarget2DNow > _diveDistanceMeters);

		// Log dive phase transition
		if (_wasHorizontal && !_nowHorizontal) then {
			private _currentAltASL = _originASL select 2;
			private _targetAimAltASL = _targetAimASL select 2;
			[_droneVehicle, format ["Terminal DIVE PHASE START | dist=%1m currentAltASL=%2m aimAltASL=%3m deltaZ=%4m", 
				_distToTarget2DNow, _currentAltASL, _targetAimAltASL, _currentAltASL - _targetAimAltASL]] call _logDebug;
		};

		// Apply steering with stable orientation
		if ((vectorMagnitude _directionVectorNormalized) > 0.001) then {
			// Use simple level flight orientation - drone points toward target, up is world up
			_droneVehicle setVectorDirAndUp [_directionVectorNormalized, [0,0,1]];
			_droneVehicle setVelocity (_directionVectorNormalized vectorMultiply _speedMetersPerSecond);
		};
	};

	// Comprehensive debug logging with detonation checks
	if ((missionNamespace getVariable ["GOL_Drones_MasterDebug", false]) && (missionNamespace getVariable ["GOL_Drones_Debug", false]) && {diag_tickTime - _lastTerminalTickLogTimeSeconds > 0.75}) then {
		_lastTerminalTickLogTimeSeconds = diag_tickTime;
		private _dist2D = _distToTarget2DNow;
		private _droneASL = getPosASL _droneVehicle;
		private _altATL = (getPosATL _droneVehicle) select 2;
		private _distToAim = _droneASL distance _terminalAimASL;
		private _distToAim2D = _droneASL distance2D _terminalAimASL;
		private _vel = velocity _droneVehicle;
		private _speed = vectorMagnitude _vel;
		private _velNorm = vectorNormalized _vel;
		private _droneDir = vectorDir _droneVehicle;
		private _droneUp = vectorUp _droneVehicle;
		private _phase = if (_ballisticMode) then {"BALLISTIC"} else {if (_dist2D > _diveDistanceMeters) then {"HORIZONTAL"} else {"DIVE"}};
		private _disabledFlag = _droneVehicle getVariable ["OKS_Drone_Disabled", false];
		[_droneVehicle, format ["Terminal tick | phase=%1 distTarget=%2m distAim=%3m(%4m 2D) altATL=%5m speed=%6m/s velDir=%7 droneDir=%8 droneUp=%9 touching=%10 disabled=%11", 
			_phase, _dist2D, _distToAim, _distToAim2D, _altATL, _speed toFixed 1, _velNorm, _droneDir, _droneUp, isTouchingGround _droneVehicle, _disabledFlag]] call _logDebug;
		
		// Proximity detonation check
		private _distToTarget3DNow = _droneVehicle distance _hostileTarget;
		if (_distToTarget3DNow <= _detonationDistanceMeters) exitWith {
			[_droneVehicle, format ["Detonate (terminal proximity) | dist3D=%1 dist2D=%2 altATL=%3", _distToTarget3DNow, _distToTarget2DNow, (getPosATL _droneVehicle select 2)]] call _logDebug;
			[_droneVehicle, _droneControllerUnit, _explosionClassName, _logDebug] call OKS_fnc_DroneHuntZone_Detonate;
			_didDetonateOnImpact = true;
		};
		
		// Ground impact detonation
		if (isTouchingGround _droneVehicle) exitWith {
			[_droneVehicle, "Terminal impact detected | detonating"] call _logDebug;
			[_droneVehicle, _droneControllerUnit, _explosionClassName, _logDebug] call OKS_fnc_DroneHuntZone_Detonate;
			_didDetonateOnImpact = true;
		};
	};

	sleep 0.05;
};

// Clear terminal phase flag when guidance ends
_droneVehicle setVariable ["GOL_InTerminalPhase", false, true];

if (!_didDetonateOnImpact) then {
	[_droneVehicle, format ["Terminal timeout | dist=%1m", if (isNull _droneVehicle) then {-1} else {_droneVehicle distance _hostileTarget}]] call _logDebug;
};

_didDetonateOnImpact
