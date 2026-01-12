/*
	OKS_fnc_DroneHelper_GetAimPoint
	
	Calculates terminal aim point with LOS blocking detection and randomized miss offset.
	if LOS is blocked, aims at blocking surface. if clear, applies directional offset for miss chance.
	
	Parameters:
	0: OBJECT - Drone vehicle
	1: OBJECT - Target object
	2: ARRAY - Aim offset relative to approach direction [right, forward, up] in meters
	- Right: positive = right, negative = left
	- Forward: negative = short of target (prevents overshoot), positive = beyond target
	- Up: vertical offset (typically 0 for ground impact)
	
	Returns:
	ARRAY - Aim point position ASL [x, y, z]
	
	Example:
	    5m right, 3m short of target, ground level
	private _aimASL = [_drone, _target, [5, -3, 0]] call OKS_fnc_DroneHelper_GetAimPoint;
*/

params [
	["_droneVehicle", objNull, [objNull]],
	["_targetObject", objNull, [objNull]],
	["_aimOffsetRelativeToDirection", [0, 0, 0], [[]]]
];

if (isNull _droneVehicle || {
	isNull _targetObject
}) exitWith {
	[0, 0, 0]
};

private _originASL = getPosASL _droneVehicle;
private _targetASL = getPosASL _targetObject;

// Check for LOS blocking (terrain, buildings, vehicles)
private _hits = lineIntersectsSurfaces [
	_originASL,
	_targetASL,
	_droneVehicle,
	_targetObject,
	true,
	1,
	"GEOM",
	"NONE"
];

// if blocked, aim at blocking surface for guaranteed impact
if (_hits isEqualType [] && {
	(count _hits) > 0
}) exitWith {
	private _firstHit = _hits select 0;
	_firstHit param [0, [0, 0, 0]]
};

// LOS clear: Calculate aim point with directional offset at terrain level
private _terrainHeightASL = getTerrainHeightASL [_targetASL select 0, _targetASL select 1];
private _aimGroundASL = [_targetASL select 0, _targetASL select 1, _terrainHeightASL];

// Build directional coordinate system
private _directionVector = _originASL vectorFromTo _aimGroundASL;
private _directionVectorNormalized = vectorNormalized _directionVector;
private _upVector = [0, 0, 1];

// Calculate right vector (perpendicular to direction)
private _rightVector = _directionVectorNormalized vectorCrossProduct _upVector;
private _rightVectorMagnitude = vectorMagnitude _rightVector;
if (_rightVectorMagnitude < 0.001) then {
	_rightVector = [1, 0, 0];  // Fallback for vertical approaches
} else {
	_rightVector = _rightVector vectorMultiply (1 / _rightVectorMagnitude);
};

// apply offset in directional coordinate system
private _relRightMeters = _aimOffsetRelativeToDirection param [0, 0];
private _relForwardMeters = _aimOffsetRelativeToDirection param [1, 0];
private _relUpMeters = _aimOffsetRelativeToDirection param [2, 0];

private _relativeOffsetWorld = [0, 0, 0];
_relativeOffsetWorld = _relativeOffsetWorld vectorAdd (_rightVector vectorMultiply _relRightMeters);
_relativeOffsetWorld = _relativeOffsetWorld vectorAdd (_directionVectorNormalized vectorMultiply _relForwardMeters);
_relativeOffsetWorld = _relativeOffsetWorld vectorAdd (_upVector vectorMultiply _relUpMeters);

_aimGroundASL vectorAdd _relativeOffsetWorld