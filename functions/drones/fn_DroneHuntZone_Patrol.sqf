/*
	OKS_fnc_DroneHuntZone_Patrol

	Manages drone patrol behavior: waypoint updates, unstuck detection, and patrol looping.
	Called when no target is found to maintain search pattern.

	Parameters:
		0: OBJECT - Drone vehicle
		1: GROUP - Drone group
		2: OBJECT - Drone controller unit (driver/pilot)
		3: ARRAY - Waypoint reference (from addWaypoint)
		4: ARRAY - Zone center position ATL [x,y,z]
		5: NUMBER - Zone radius in meters
		6: NUMBER - Patrol altitude in meters
		7: NUMBER - Last stuck check time (diag_tickTime)
		8: ARRAY - Last stuck position ATL [x,y,z]

	Returns:
		ARRAY - [lastStuckCheckTime, lastStuckPosition] - Updated values for next iteration

	Example:
		(_this call OKS_fnc_DroneHuntZone_Patrol) params ["_lastStuckCheckTime", "_lastStuckPos"];
*/

params [
	["_droneVehicle", objNull, [objNull]],
	["_droneGroup", grpNull, [grpNull]],
	["_droneControllerUnit", objNull, [objNull]],
	["_patrolWaypoint", [], [[]]],
	["_zoneCenterPositionATL", [0,0,0], [[]]],
	["_zoneRadiusMeters", 750, [0]],
	["_patrolAltitudeMeters", 40, [0]],
	["_lastStuckCheckTimeSeconds", 0, [0]],
	["_lastStuckPositionATL", [0,0,0], [[]]]
];

private _newStuckCheckTime = _lastStuckCheckTimeSeconds;
private _newStuckPosition = _lastStuckPositionATL;

if (isNull _droneGroup || {_patrolWaypoint isEqualTo []}) exitWith {
	[_newStuckCheckTime, _newStuckPosition]
};

// Unstuck detection: if drone hasn't moved in 12 seconds, reassert waypoint
if (diag_tickTime - _lastStuckCheckTimeSeconds > 12) then {
	private _posATL = getPosATL _droneVehicle;
	private _movedMeters = _posATL distance _lastStuckPositionATL;
	
	if (_movedMeters < 3 && {speed _droneVehicle < 2}) then {
		_droneGroup setCurrentWaypoint _patrolWaypoint;
		if (!isNull _droneControllerUnit) then {
			_droneControllerUnit doMove (waypointPosition _patrolWaypoint);
		};
	};
	
	_newStuckCheckTime = diag_tickTime;
	_newStuckPosition = _posATL;
};

// Waypoint refresh: generate new random position when approaching current waypoint
private _currentWaypointPositionATL = waypointPosition _patrolWaypoint;
private _distanceToWaypointMeters = _droneVehicle distance _currentWaypointPositionATL;

if (_distanceToWaypointMeters < 200) then {
	// Generate random position within zone at patrol altitude
	private _randomAngle = random 360;
	private _randomRadius = random _zoneRadiusMeters;
	private _newPatrolPositionATL = _zoneCenterPositionATL getPos [_randomRadius, _randomAngle];
	_newPatrolPositionATL set [2, _patrolAltitudeMeters];
	
	// Update waypoint
	_patrolWaypoint setWaypointPosition [_newPatrolPositionATL, 0];
	_patrolWaypoint setWaypointType "MOVE";
	_patrolWaypoint setWaypointSpeed "FULL";
	_patrolWaypoint setWaypointBehaviour "AWARE";
	_patrolWaypoint setWaypointCombatMode "RED";
	
	_droneGroup setCurrentWaypoint _patrolWaypoint;
	if (!isNull _droneControllerUnit) then {
		_droneControllerUnit doMove (waypointPosition _patrolWaypoint);
	};
};

[_newStuckCheckTime, _newStuckPosition]
