/*
	OKS_fnc_DroneHuntZone_Attack
	
	Manages drone attack approach phase: AI movement, progressive altitude descent, and proximity detonation.
	Handles the phase between target acquisition and terminal guidance entry.
	
	Parameters:
	0: OBJECT - Drone vehicle
	1: OBJECT - Drone controller unit (driver/pilot)
	2: OBJECT - Target object
	3: NUMBER - Patrol altitude in meters (starting altitude)
	4: NUMBER - Terminal start distance in meters (when to switch to terminal guidance)
	5: NUMBER - Detonation distance in meters (proximity trigger)
	6: STRING - Explosion className
	7: CODE - log debug function reference
	
	Returns:
	BOOL - true if detonated during approach, false otherwise
	
	Example:
	private _detonated = [_drone, _controller, _target, 40, 100, 5, "OKS_Drone_Warhead_Medium", _logDebug] call OKS_fnc_DroneHuntZone_Attack;
*/

params [
	["_droneVehicle", objNull, [objNull]],
	["_droneControllerUnit", objNull, [objNull]],
	["_hostileTarget", objNull, [objNull]],
	["_patrolAltitudeMeters", 40, [0]],
	["_terminalStartDistanceMeters", 100, [0]],
	["_detonationDistanceMeters", 5, [0]],
	["_explosionClassName", "OKS_Drone_Warhead_Medium", [""]],
	["_logDebug", {}, [{}]]
];

private _shouldLogDebug = (missionNamespace getVariable ["GOL_Drones_MasterDebug", false]) && (missionNamespace getVariable ["GOL_Drones_Debug", false]);
private _didDetonate = false;

// Progressive altitude descent thresholds
private _approachDesiredAltitudeMeters = _patrolAltitudeMeters;
private _distanceToTarget2DMeters = _droneVehicle distance2D _hostileTarget;
private _distanceToTargetMeters = _droneVehicle distance _hostileTarget;

// Check if already in detonation range
if (_distanceToTargetMeters <= _detonationDistanceMeters) exitWith {
	[_droneVehicle, format ["Detonate (approach immediate) | dist3D=%1 dist2D=%2", _distanceToTargetMeters, _distanceToTarget2DMeters]] call _logDebug;
	[_droneVehicle, _droneControllerUnit, _explosionClassName, _logDebug] call OKS_fnc_DroneHuntZone_Detonate;
	true
};

// Check if in terminal zone
if (_distanceToTarget2DMeters <= _terminalStartDistanceMeters) exitWith {
	false  // Let terminal guidance handle it
};

// Calculate progressive descent altitude
// Keep higher until closer to terminal to avoid terrain
if (_distanceToTarget2DMeters < 600) then {
	_approachDesiredAltitudeMeters = _approachDesiredAltitudeMeters min 35;
};
if (_distanceToTarget2DMeters < 350) then {
	_approachDesiredAltitudeMeters = _approachDesiredAltitudeMeters min 30;
};
if (_distanceToTarget2DMeters < 200) then {
	_approachDesiredAltitudeMeters = _approachDesiredAltitudeMeters min 25;
};

_droneVehicle flyInHeight _approachDesiredAltitudeMeters;

// set target position at descent altitude
private _targetPositionATL = getPosATL _hostileTarget;
_targetPositionATL set [2, _approachDesiredAltitudeMeters];

if (!isNull _droneControllerUnit) then {
	_droneControllerUnit doMove _targetPositionATL;
};

if (_shouldLogDebug) then {
	[_droneVehicle, format ["Approach | dist3D=%1 dist2D=%2 desiredAlt=%3 droneAltATL=%4", _distanceToTargetMeters, _distanceToTarget2DMeters, _approachDesiredAltitudeMeters, (getPosATL _droneVehicle select 2)]] call _logDebug;
};

false