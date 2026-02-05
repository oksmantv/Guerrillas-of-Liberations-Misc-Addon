/*
	OKS_fnc_DroneHuntZone
	
	Spawns a kamikaze drone that patrols a zone and attacks hostile targets with terminal guidance.
	Orchestrates patrol, target selection, attack approach, terminal guidance, and detonation.
	
	Parameters:
	0: ARRAY/OBJECT - spawn position ATL or spawn object
	1: STRING/ARRAY/OBJECT - Target zone (marker name, position, or trigger object)
	2: STRING - Drone className (empty string for auto-detection based on side)
	3: side - Drone side (default: east)
	4: NUMBER - Target zone radius in meters (default: 1000, fallback if zone doesn't define radius)
	5: NUMBER - Search timeout in seconds (default: 60, 0 for infinite)
	6: NUMBER - Cruise speed in km/h (default: 70)
	7: NUMBER - Detonation distance in meters (default: 5)
	8: STRING - Explosion classname (default: "OKS_Drone_Warhead_Medium", "AUTO" for FPV_UA default)
	
	Returns:
	OBJECT - Spawned drone vehicle, or objNull if spawn failed
	
	Example:
	[
		[1000, 1000, 10], 
		"targetMarker", 
		"O_UAV_01_F", 
		east, 
		1000, 
		60, 
		70, 
		5, 
		"AUTO"
	] spawn OKS_fnc_DroneHuntZone;
*/

params [
	["_spawnPosition", [0, 0, 0], [[], objNull]],
	["_targetZone", "", ["", [], objNull]],
	["_droneClassName", "", [""]],
	["_droneSide", east, [sideUnknown]],
	["_targetZoneRadiusMeters", 1000, [0]],
	["_searchTimeoutSeconds", 300, [0]],
	["_cruiseSpeedKilometersPerHour", 70, [0]],
	["_detonationDistanceMeters", 5, [0]],
	["_explosionClassName", "OKS_Drone_Warhead_Medium", [""]]
];

// Debug logging setup
private _shouldLogDebug = (missionNamespace getVariable ["GOL_Drones_MasterDebug", false]) && (missionNamespace getVariable ["GOL_Drones_Debug", false]);
private _logDebug = {
	params ["_droneVehicle", "_message"];
	private _shouldLogDebug = (missionNamespace getVariable ["GOL_Drones_MasterDebug", false]) && (missionNamespace getVariable ["GOL_Drones_Debug", false]);
	if (!_shouldLogDebug || {
		isNil "OKS_fnc_LogDebug"
	}) exitWith {};
	private _logPrefix = if (isNull _droneVehicle) then {
		"[DRONEHUNT]"
	} else {
		format ["[DRONEHUNT:%1]", netId _droneVehicle]
	};
	[format ["%1 %2", _logPrefix, _message], false, true, true] call OKS_fnc_LogDebug;
};

// Log debug status and check countermeasure debug flags
if (_shouldLogDebug) then {
	[objNull, "Debug mode ENABLED | GOL_Drones_MasterDebug=true + GOL_Drones_Debug=true"] call _logDebug;
	private _detectorDebugEnabled = (missionNamespace getVariable ["GOL_Detector_Debug", false]);
	[objNull, format ["Detector debug: %1 | Enable with: GOL_Detector_Debug=true", _detectorDebugEnabled]] call _logDebug;
} else {
	"[DroneHunt] Debug disabled. Set GOL_Drones_MasterDebug=true + GOL_Drones_Debug=true for logs." spawn OKS_fnc_LogDebug;
	"[DroneHunt] Detector logs: Also enable GOL_Detector_Debug in addition to master debug." spawn OKS_fnc_LogDebug;
};

// Normalize input parameters using helpers
private _spawnPositionATL = [_spawnPosition] call OKS_fnc_DroneHelper_NormalizePos;
([_targetZone, _targetZoneRadiusMeters] call OKS_fnc_DroneHelper_GetZoneInfo) params ["_zoneCenterPositionATL", "_zoneRadiusMeters"];
private _zoneTriggerObject = if (_targetZone isEqualType objNull && {
	!isNull _targetZone
} && {
	_targetZone isKindOf "EmptyDetector"
}) then {
	_targetZone
} else {
	objNull
};

[objNull, format ["Init | spawn=%1 zone=%2 center=%3 radius=%4 searchTimeout=%5 cruiseKPH=%6 detonateDist=%7 explosion=%8",
_spawnPositionATL, _targetZone, _zoneCenterPositionATL, _zoneRadiusMeters, _searchTimeoutSeconds, _cruiseSpeedKilometersPerHour, _detonationDistanceMeters, _explosionClassName]] call _logDebug;

// Resolve drone className from side if not specified
if (_droneSide isEqualTo sideUnknown) then {
	_droneSide = east
};
if (_droneClassName isEqualTo "") then {
	private _sideKey = switch (_droneSide) do {
		case west: {
			"BLUFOR"
		};
		case east: {
			"OPFOR"
		};
		case independent: {
			"INDEPENDENT"
		};
		default {
			"BLUFOR"
		};
	};
	_droneClassName = missionNamespace getVariable [format ["GOL_DroneATClass_%1", _sideKey], "B_UAFPV_AT"];
};

// spawn drone
private _droneVehicle = createVehicle [_droneClassName, _spawnPositionATL, [], 0, "FLY"];
if (isNull _droneVehicle) exitWith {
	[objNull, format ["Spawn failed | classname=%1", _droneClassName]] call _logDebug;
	objNull
};

_droneVehicle setPosATL _spawnPositionATL;
createVehicleCrew _droneVehicle;
_droneVehicle engineOn true;

[_droneVehicle, format ["Spawned | class=%1 crew=%2", _droneClassName, count crew _droneVehicle]] call _logDebug;

// Night chemlight
if (sunOrMoon < 0.5) then {
	private _chemlight = "Chemlight_red" createVehicle [0, 0, 0];
	_chemlight attachTo [_droneVehicle, [0, 0, 0]];
};

// Re-enable AI after FPV_UA disables it
[_droneVehicle, _logDebug] spawn {
	params ["_droneVehicle", "_logDebug"];
	for "_i" from 1 to 5 do {
		sleep 0.2;
		if (isNull _droneVehicle) exitWith {};
		{
			_x enableAI "ALL"
		} forEach crew _droneVehicle;
		if (_i == 1) then {
			_droneVehicle setAutonomous true
		};
	};
	[_droneVehicle, "AI re-enabled after spawn"] call _logDebug;
};

// Configuration
private _startTimeSeconds = diag_tickTime;
private _patrolAltitudeMeters = 40;
private _terminalStartDistanceMeters = 100;
private _terminalAimOffsetRadiusMeters = 25;

// Setup drone group and controller
private _droneControllerUnit = if (!isNull (driver _droneVehicle)) then {
	driver _droneVehicle
} else {
	(crew _droneVehicle) param [0, objNull]
};
private _droneGroup = if (!isNull _droneControllerUnit) then {
	group _droneControllerUnit
} else {
	grpNull
};

if (!isNull _droneGroup) then {
	_droneGroup setBehaviourStrong "AWARE";
	_droneGroup setCombatMode "RED";
	_droneGroup setSpeedMode "FULL";
	_droneGroup allowFleeing 0;
};

_droneVehicle flyInHeight _patrolAltitudeMeters;

// Create initial patrol waypoint
private _patrolWaypoint = [];
if (!isNull _droneGroup) then {
	_patrolWaypoint = _droneGroup addWaypoint [_zoneCenterPositionATL, 0];
	private _randomAngle = random 360;
	private _randomRadius = random _zoneRadiusMeters;
	private _initialPatrolPosATL = _zoneCenterPositionATL getPos [_randomRadius, _randomAngle];
	_initialPatrolPosATL set [2, _patrolAltitudeMeters];

	_patrolWaypoint setWaypointPosition [_initialPatrolPosATL, 0];
	_patrolWaypoint setWaypointType "MOVE";
	_patrolWaypoint setWaypointSpeed "FULL";
	_patrolWaypoint setWaypointBehaviour "AWARE";
	_patrolWaypoint setWaypointCombatMode "RED";

	_droneGroup setCurrentWaypoint _patrolWaypoint;
	if (!isNull _droneControllerUnit) then {
		_droneControllerUnit doMove (waypointPosition _patrolWaypoint);
	};
};

// Patrol state
private _lastScanLogTimeSeconds = -1;
private _lastStuckCheckTimeSeconds = diag_tickTime;
private _lastStuckPositionATL = getPosATL _droneVehicle;

// Main patrol loop
while { alive _droneVehicle } do {
	private _elapsedSeconds = diag_tickTime - _startTimeSeconds;
	if (_searchTimeoutSeconds > 0 && {
		_elapsedSeconds > _searchTimeoutSeconds
	}) exitWith {};

	// Periodic scan logging
	if (_shouldLogDebug && {
		diag_tickTime - _lastScanLogTimeSeconds > 10
	}) then {
		_lastScanLogTimeSeconds = diag_tickTime;
		[_droneVehicle, format ["Patrol | pos=%1 alt=%2", getPosATL _droneVehicle, (getPosATL _droneVehicle) select 2]] call _logDebug;
	};

	// Target scan
	private _hostileTarget = [_droneVehicle, _zoneCenterPositionATL, _zoneRadiusMeters, _droneSide, _zoneTriggerObject] call OKS_fnc_DroneHelper_SelectTarget;

	if (!isNull _hostileTarget) then {
		[_droneVehicle, format ["Target acquired | target=%1 type=%2 dist=%3", _hostileTarget, typeOf _hostileTarget, _droneVehicle distance _hostileTarget]] call _logDebug;

		// Attack loop
		private _attackTimeoutSeconds = 120;
		private _attackStartTimeSeconds = diag_tickTime;
		private _didDetonateThisAttack = false;
		private _terminalAttempts = 0;
		private _maxTerminalAttempts = 3;
		private _stopSteeringDistanceMeters = 50;

		while {
			alive _droneVehicle && {
				alive _hostileTarget
			} && {
				!_didDetonateThisAttack
			}
		} do {
			private _attackElapsedSeconds = diag_tickTime - _attackStartTimeSeconds;
			if (_attackTimeoutSeconds > 0 && _attackElapsedSeconds > _attackTimeoutSeconds) exitWith {};

			private _distanceToTarget2DMeters = _droneVehicle distance2D _hostileTarget;

			// Attack approach phase
			private _detonatedInApproach = [
				_droneVehicle,
				_droneControllerUnit,
				_hostileTarget,
				_patrolAltitudeMeters,
				_terminalStartDistanceMeters,
				_detonationDistanceMeters,
				_explosionClassName,
				_logDebug
			] call OKS_fnc_DroneHuntZone_Attack;

			if (_detonatedInApproach) exitWith { _didDetonateThisAttack = true };

			// Terminal zone entry
			if (_distanceToTarget2DMeters <= _terminalStartDistanceMeters) then {
				_terminalAttempts = _terminalAttempts + 1;
				[_droneVehicle, format ["Terminal start | attempt=%1/%2", _terminalAttempts, _maxTerminalAttempts]] call _logDebug;

				// Terminal attempt limit check
				if (_terminalAttempts > _maxTerminalAttempts) exitWith {
					private _droneAltATL = (getPosATL _droneVehicle) select 2;
					if (_distanceToTarget2DMeters <= _detonationDistanceMeters && {
						_droneAltATL < 20
					}) then {
						[_droneVehicle, format ["Detonate (forced) | dist2D=%1 alt=%2", _distanceToTarget2DMeters, _droneAltATL]] call _logDebug;
						[_droneVehicle, _droneControllerUnit, _explosionClassName, _logDebug] call OKS_fnc_DroneHuntZone_Detonate;
						_didDetonateThisAttack = true;
					};
				};

				// Jammer check on first terminal entry
				if (_terminalAttempts == 1) then {
				private _dronePos = getPosATL _droneVehicle;
				private _jammerRange = missionNamespace getVariable ["GOL_Jammer_EffectRange", 350];
				[_droneVehicle, format ["Jammer scan | dronePos=%1 scanRadius=%2m", _dronePos, _jammerRange]] call _logDebug;
				private _nearbyJammers = [_dronePos, _jammerRange, "OKS_DroneJammer"] call OKS_fnc_DroneJammer_GetNearbyCarriers;
				if !(_nearbyJammers isEqualTo []) then {
					_stopSteeringDistanceMeters = 100;
					private _jammerDetails = _nearbyJammers apply {format ["%1@%2m", _x, round (_droneVehicle distance _x)]};
						[_droneVehicle, "Jammer scan | no jammers detected | ballistic distance: 50m"] call _logDebug;
					};
				};

				// Terminal guidance execution
				private _detonatedInTerminal = [
					_droneVehicle,
					_droneControllerUnit,
					_hostileTarget,
					_cruiseSpeedKilometersPerHour,
					_terminalStartDistanceMeters,
					_terminalAimOffsetRadiusMeters,
					_detonationDistanceMeters,
					_explosionClassName,
					_logDebug,
					_patrolAltitudeMeters,
					_stopSteeringDistanceMeters
				] call OKS_fnc_DroneHuntZone_Terminal;

				if (!_detonatedInTerminal) then {
					[_droneVehicle, format ["Terminal finished | distToTarget=%1", if (isNull _droneVehicle) then {
						-1
					} else {
						_droneVehicle distance _hostileTarget
					}]] call _logDebug;
				};

				// if we detonated on impact (or the drone got deleted), skip proximity checks
				if (_detonatedInTerminal || isNull _droneVehicle || !alive _droneVehicle) then {
					_didDetonateThisAttack = true;
				} else {
					// Proximity detonation after terminal run
					private _postDistance3D = _droneVehicle distance _hostileTarget;
					private _postDistance2D = _droneVehicle distance2D _hostileTarget;
					private _droneAltitudeATL = getPosATL _droneVehicle select 2;
					private _isCloseEnough3D = _postDistance3D <= _detonationDistanceMeters;
					private _isCloseEnough2DAndLow = (_postDistance2D <= _detonationDistanceMeters) && (_droneAltitudeATL < 20);

					if (_isCloseEnough3D || _isCloseEnough2DAndLow) then {
						[_droneVehicle, format ["Detonate (post-terminal) | dist3D=%1 dist2D=%2 droneAltATL=%3", _postDistance3D, _postDistance2D, _droneAltitudeATL]] call _logDebug;
						[_droneVehicle, _droneControllerUnit, _explosionClassName, _logDebug] call OKS_fnc_DroneHuntZone_Detonate;
						_didDetonateThisAttack = true;
					} else {
						[_droneVehicle, format ["Missed run | dist3D=%1 dist2D=%2 droneAltATL=%3 | re-attempting", _postDistance3D, _postDistance2D, _droneAltitudeATL]] call _logDebug;
					};
				};
			};

			sleep 0.5;
		};

		if (!_didDetonateThisAttack) then {
			[_droneVehicle, format ["Attack ended | detonated=%1 targetAlive=%2", _didDetonateThisAttack, alive _hostileTarget]] call _logDebug;
		};
	};
	
	(
		[
			_droneVehicle,
			_droneGroup,
			_droneControllerUnit,
			_patrolWaypoint,
			_zoneCenterPositionATL,
			_zoneRadiusMeters,
			_patrolAltitudeMeters,
			_lastStuckCheckTimeSeconds,
			_lastStuckPositionATL
		] call OKS_fnc_DroneHuntZone_Patrol
	) params ["_lastStuckCheckTimeSeconds", "_lastStuckPositionATL"];

	sleep 1;
};

if (isNull _droneVehicle) then {
	objNull
} else {
	_droneVehicle
}