/*
	OKS_fnc_SteerVehicleToTarget

	Guides a vehicle by directly setting its orientation and velocity toward a target.
	This is not waypoint-based AI navigation; it behaves more like a simple guidance law.

	Returns:
		true if the vehicle reached the target distance, otherwise false.

	Example:
		null = [myDrone, myTargetObject, 70, 15, 0.2, 60, [0,0,0.6], "ASL", true] spawn OKS_fnc_SteerVehicleToTarget;
*/

params [
	["_vehicle", objNull, [objNull]],
	["_target", objNull, [objNull, []]],
	["_speedKilometersPerHour", 70, [0]],
	["_stopDistanceMeters", 30, [0]],
	["_updateIntervalSeconds", 0.2, [0]],
	["_maximumTimeSeconds", 60, [0]],
	["_targetPositionOffset", [0,0,0], [[]]],
	["_targetPositionSpace", "ASL", [""]],
	["_shouldSetVectorDirection", true, [true]],
	// If true, _targetPositionOffset is treated as [right, forward, up] relative to the approach direction.
	// If false (default), _targetPositionOffset is world-space [x,y,z] meters.
	["_targetOffsetIsRelativeToDirection", false, [true]],
	// Optional: if > 0, probe this many meters ahead (toward target) and exit when it's over land.
	["_landScanAheadDistanceMeters", -1, [0]]
];

if (isNull _vehicle) exitWith {false};

// Guardrails: keep this function safe even if called with bad parameters.
// Prevents infinite loops / server perf issues from maximumTimeSeconds <= 0 and updateIntervalSeconds <= 0.
if (_speedKilometersPerHour <= 0) then { _speedKilometersPerHour = 70; };
if (_stopDistanceMeters <= 0) then { _stopDistanceMeters = 1; };
_updateIntervalSeconds = _updateIntervalSeconds max 0.01;
if (_maximumTimeSeconds <= 0) then { _maximumTimeSeconds = 60; };
_maximumTimeSeconds = _maximumTimeSeconds min 300;

_vehicle engineOn true;

private _speedMetersPerSecond = _speedKilometersPerHour / 3.6;
private _startTimeSeconds = diag_tickTime;

private _getTargetPositionASL = {
	params ["_originPositionASL", "_targetValue", "_offsetVector", "_positionSpace", "_targetOffsetIsRelativeToDirection"];

	private _targetPositionASL = [0,0,0];
	if (_targetValue isEqualType objNull) then {
		if (isNull _targetValue) exitWith {[0,0,0]};
		_targetPositionASL = getPosASL _targetValue;
	} else {
		if !(_targetValue isEqualType []) exitWith {[0,0,0]};
		_targetPositionASL = _targetValue;
		if (_positionSpace isEqualTo "ATL") then {
			_targetPositionASL = ATLToASL _targetPositionASL;
		};
	};

	if (!_targetOffsetIsRelativeToDirection) exitWith {
		_targetPositionASL vectorAdd _offsetVector
	};

	private _directionVector = _originPositionASL vectorFromTo _targetPositionASL;
	private _directionVectorNormalized = vectorNormalized _directionVector;
	private _upVector = [0,0,1];
	private _rightVector = _directionVectorNormalized vectorCrossProduct _upVector;
	private _rightVectorMagnitude = vectorMagnitude _rightVector;
	if (_rightVectorMagnitude < 0.001) then {
		_rightVector = [1,0,0];
	} else {
		_rightVector = _rightVector vectorMultiply (1 / _rightVectorMagnitude);
	};

	private _relativeRightMeters = _offsetVector param [0,0];
	private _relativeForwardMeters = _offsetVector param [1,0];
	private _relativeUpMeters = _offsetVector param [2,0];

	private _relativeOffsetWorld = [0,0,0];
	_relativeOffsetWorld = _relativeOffsetWorld vectorAdd (_rightVector vectorMultiply _relativeRightMeters);
	_relativeOffsetWorld = _relativeOffsetWorld vectorAdd (_directionVectorNormalized vectorMultiply _relativeForwardMeters);
	_relativeOffsetWorld = _relativeOffsetWorld vectorAdd (_upVector vectorMultiply _relativeUpMeters);

	_targetPositionASL vectorAdd _relativeOffsetWorld
};

while {alive _vehicle} do {
	private _elapsedSeconds = diag_tickTime - _startTimeSeconds;
	if (_maximumTimeSeconds > 0 && {_elapsedSeconds > _maximumTimeSeconds}) exitWith {false};

	private _originPositionASL = getPosASL _vehicle;
	private _targetPositionASL = [_originPositionASL, _target, _targetPositionOffset, _targetPositionSpace, _targetOffsetIsRelativeToDirection] call _getTargetPositionASL;

	private _distanceMeters = _vehicle distance _targetPositionASL;
	if (_distanceMeters <= _stopDistanceMeters) exitWith {true};

	private _directionVector = _originPositionASL vectorFromTo _targetPositionASL;
	private _directionVectorNormalized = vectorNormalized _directionVector;

	// Optional land-ahead scan. Useful for beaching when the target is inland.
	if (_landScanAheadDistanceMeters > 0) then {
		private _aheadPositionASL = _originPositionASL vectorAdd (_directionVectorNormalized vectorMultiply _landScanAheadDistanceMeters);
		private _aheadPositionATL = ASLToATL _aheadPositionASL;
		_aheadPositionATL set [2, 0];
		if !(surfaceIsWater _aheadPositionATL) exitWith {true};
	};

	if (_shouldSetVectorDirection) then {
		private _lateralVector = _directionVectorNormalized vectorCrossProduct [0,0,1];
		private _lateralVectorMagnitude = vectorMagnitude _lateralVector;
		if (_lateralVectorMagnitude < 0.001) then {
			_lateralVector = [1,0,0];
		} else {
			_lateralVector = _lateralVector vectorMultiply (1 / _lateralVectorMagnitude);
		};

		private _upVector = _lateralVector vectorCrossProduct _directionVectorNormalized;
		private _upVectorNormalized = vectorNormalized _upVector;
		_vehicle setVectorDirAndUp [_directionVectorNormalized, _upVectorNormalized];
	};

	_vehicle setVelocity (_directionVectorNormalized vectorMultiply _speedMetersPerSecond);

	sleep _updateIntervalSeconds;
};

false
