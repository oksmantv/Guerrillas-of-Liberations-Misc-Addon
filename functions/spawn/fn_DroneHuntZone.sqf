/*
	OKS_fnc_DroneHuntZone

	Spawns a drone at a given position, then patrols a target zone until it finds a hostile target.
	The drone will fly using normal AI movement (waypoints / doMove) to enter the area and loiter while scanning.
	When a target is found the drone AI-approaches, and within 125m it picks a random aim point near the target and
	switches to terminal guidance using OKS_fnc_SteerVehicleToTarget (setVectorDirAndUp + setVelocity).

	The random aim point introduces a chance to miss.

	Example:
		null = [
		[1000,1000,10],
		"targetMarker",
		"O_UAV_01_F",
		east,
		1000,
		60,
		70,
		15,
		"AUTO"
	] spawn OKS_fnc_DroneHuntZone;
*/

params [
	["_spawnPosition", [0,0,0], [[], objNull]],
	["_targetZone", "", ["", [], objNull]],
	["_droneClassName", "", [""]],
	["_droneSide", east, [sideUnknown]],
	["_targetZoneRadiusMeters", 750, [0]],
	["_searchTimeoutSeconds", 300, [0]],
	["_cruiseSpeedKilometersPerHour", 70, [0]],
	["_detonationDistanceMeters", 12, [0]],
	// Detonation ammo class. Use "AUTO" (default) to mimic FPV_UA behavior when available.
	["_explosionClassName", "AUTO", [""]]
];

private _shouldLogDebug = ((missionNamespace getVariable ["GOL_Core_Debug", false]) && (missionNamespace getVariable ["GOL_Drones_Debug", false]));

private _logDebug = {
	params ["_droneVehicle", "_message", ["_shouldWriteToChat", false, [false]]];
	private _shouldLogDebug = ((missionNamespace getVariable ["GOL_Core_Debug", false]) && (missionNamespace getVariable ["GOL_Drones_Debug", false]));
	if (!_shouldLogDebug) exitWith {};
	if (isNil "OKS_fnc_LogDebug") exitWith {};
	private _logPrefix = if (isNull _droneVehicle) then {
		"[DRONEHUNT]"
	} else {
		format ["[DRONEHUNT:%1]", netId _droneVehicle]
	};
	[format ["%1 %2", _logPrefix, _message], _shouldWriteToChat, true, true] call OKS_fnc_LogDebug;
};

private _normalizePositionATL = {
	params ["_positionOrObject"];
	if (_positionOrObject isEqualType objNull) exitWith {
		if (isNull _positionOrObject) then {[0,0,0]} else {getPosATL _positionOrObject}
	};
	if (_positionOrObject isEqualType []) exitWith {
		if ((count _positionOrObject) < 3) then {[_positionOrObject param [0,0], _positionOrObject param [1,0], 0]} else {_positionOrObject}
	};
	[0,0,0]
};

private _getZoneCenterATL = {
	params ["_zoneValue"];

	if (_zoneValue isEqualType "") exitWith {
		if (_zoneValue isEqualTo "") then {[0,0,0]} else {getMarkerPos _zoneValue}
	};
	if (_zoneValue isEqualType objNull) exitWith {
		if (isNull _zoneValue) then {[0,0,0]} else {getPosATL _zoneValue}
	};
	if (_zoneValue isEqualType []) exitWith {
		[_zoneValue] call _normalizePositionATL
	};
	[0,0,0]
};

private _getZoneRadiusMeters = {
	params ["_zoneValue", "_fallbackRadiusMeters"];

	if (_zoneValue isEqualType "" && {_zoneValue != ""}) exitWith {
		private _markerSize = getMarkerSize _zoneValue;
		(_markerSize select 0) max (_markerSize select 1)
	};

	if (_zoneValue isEqualType objNull && {!isNull _zoneValue}) exitWith {
		// If a trigger is provided, prefer its configured area (so resizing in Eden works).
		if (_zoneValue isKindOf "EmptyDetector") then {
			private _triggerArea = triggerArea _zoneValue;
			if (_triggerArea isEqualType [] && {(count _triggerArea) >= 2}) then {
				(_triggerArea select 0) max (_triggerArea select 1)
			} else {
				_fallbackRadiusMeters
			};
		} else {
			_fallbackRadiusMeters
		};
	};

	_fallbackRadiusMeters
};

private _spawnPositionATL = [_spawnPosition] call _normalizePositionATL;
private _zoneCenterPositionATL = [_targetZone] call _getZoneCenterATL;
private _zoneRadiusMeters = [_targetZone, _targetZoneRadiusMeters] call _getZoneRadiusMeters;

private _zoneTriggerObject = if (_targetZone isEqualType objNull && {!isNull _targetZone} && {_targetZone isKindOf "EmptyDetector"}) then {_targetZone} else {objNull};

[objNull, format ["Init | spawn=%1 targetZone=%2(%3) zoneCenterATL=%4 zoneRadius=%5 searchTimeout=%6 cruiseKPH=%7 detonateDist=%8 explosion=%9", _spawnPositionATL, _targetZone, typeName _targetZone, _zoneCenterPositionATL, _zoneRadiusMeters, _searchTimeoutSeconds, _cruiseSpeedKilometersPerHour, _detonationDistanceMeters, _explosionClassName]] call _logDebug;
if (!isNull _zoneTriggerObject) then {
	private _triggerArea = triggerArea _zoneTriggerObject;
	[objNull, format ["Zone trigger detected | trigger=%1 triggerArea=%2", _zoneTriggerObject, _triggerArea]] call _logDebug;
};

if (_droneSide isEqualTo sideUnknown) then { _droneSide = east; };

private _sideKey = switch (_droneSide) do {
	case west: {"BLUFOR"};
	case east: {"OPFOR"};
	case independent: {"INDEPENDENT"};
	default {"BLUFOR"};
};

// If no classname override is provided, use the per-side AT FPV drone classname defined via CBA options.
if (_droneClassName isEqualTo "") then {
	_droneClassName = missionNamespace getVariable [format ["GOL_DroneATClass_%1", _sideKey], "B_UAFPV_PG7VL_AT"];
};

[objNull, format ["Resolved | droneSide=%1 sideKey=%2 droneClassName=%3", _droneSide, _sideKey, _droneClassName]] call _logDebug;

private _droneVehicle = createVehicle [_droneClassName, _spawnPositionATL, [], 0, "NONE"];
if (isNull _droneVehicle) exitWith {objNull};

_droneVehicle setPosATL _spawnPositionATL;

createVehicleCrew _droneVehicle;
_droneVehicle engineOn true;

[_droneVehicle, format ["Spawned | droneVehicle=%1 crewCount=%2", _droneVehicle, count crew _droneVehicle]] call _logDebug;

// FPV_UA runs UA_fnc_fpv_droneInit on init, which does `_uav disableAI "ALL"`.
// That is correct for player-controlled FPV drones, but for this script we need AI control.
// Re-enable AI shortly after spawn (once the mod init has run) so repeated calls keep working.
[_droneVehicle, _logDebug] spawn {
	params ["_droneVehicle", "_logDebug"];
	sleep 0.2;
	if (isNull _droneVehicle) exitWith {};
	_droneVehicle enableAI "ALL";
	{
		_x enableAI "ALL";
	} forEach crew _droneVehicle;
	[_droneVehicle, "AI re-enabled after spawn"] call _logDebug;
};

private _startTimeSeconds = diag_tickTime;

private _patrolAltitudeMeters = 60;
private _terminalStartDistanceMeters = 125;
private _terminalAimOffsetRadiusMeters = 12;

private _getDroneControllerUnit = {
	params ["_vehicle"];

	private _driverUnit = driver _vehicle;
	if (!isNull _driverUnit) exitWith {_driverUnit};

	private _crewUnits = crew _vehicle;
	_crewUnits param [0, objNull]
};

private _droneControllerUnit = [_droneVehicle] call _getDroneControllerUnit;
private _droneGroup = if (!isNull _droneControllerUnit) then {group _droneControllerUnit} else {grpNull};

[_droneVehicle, format ["Controller | controllerUnit=%1 group=%2", _droneControllerUnit, _droneGroup]] call _logDebug;

if (!isNull _droneGroup) then {
	_droneGroup setBehaviourStrong "AWARE";
	_droneGroup setCombatMode "RED";
	_droneGroup setSpeedMode "FULL";
	_droneGroup allowFleeing 0;
};

_droneVehicle flyInHeight _patrolAltitudeMeters;

private _selectHostileTarget = {
	params ["_droneVehicle", "_zoneCenterPositionATL", "_zoneRadiusMeters", "_droneSide", "_zoneTriggerObject", "_logDebug"];

	private _targetCandidates = [];
	private _filterHostile = {
		params ["_candidateObjects", "_droneSide", "_zoneTriggerObject"];
		_candidateObjects select {
			alive _x
			&& {(_droneSide getFriend side _x) == 0}
			&& {isNull _zoneTriggerObject || {_x inArea _zoneTriggerObject}}
		}
	};

	// Priority 1: armored vehicles
	private _armoredCandidatesAll = (_zoneCenterPositionATL nearEntities [["Tank", "Wheeled_APC_F", "APC_Tracked_01_base_F", "APC_Tracked_02_base_F"], _zoneRadiusMeters]);
	_targetCandidates = [_armoredCandidatesAll, _droneSide, _zoneTriggerObject] call _filterHostile;
	if !(_targetCandidates isEqualTo []) exitWith {selectRandom _targetCandidates};

	// Priority 2: any land vehicle
	private _landVehicleCandidatesAll = (_zoneCenterPositionATL nearEntities [["LandVehicle"], _zoneRadiusMeters]);
	_targetCandidates = [_landVehicleCandidatesAll, _droneSide, _zoneTriggerObject] call _filterHostile;
	if !(_targetCandidates isEqualTo []) exitWith {selectRandom _targetCandidates};

	// Priority 3: infantry and static weapons
	private _infantryCandidatesAll = (_zoneCenterPositionATL nearEntities [["Man", "StaticWeapon"], _zoneRadiusMeters]);
	_targetCandidates = [_infantryCandidatesAll, _droneSide, _zoneTriggerObject] call _filterHostile;
	if !(_targetCandidates isEqualTo []) exitWith {selectRandom _targetCandidates};

	// Debug detail: log counts and a few sample friend values.
	if (!isNil "_logDebug") then {
		[_droneVehicle, format ["Scan | armored=%1 landVehicles=%2 infantryOrStatic=%3", count _armoredCandidatesAll, count _landVehicleCandidatesAll, count _infantryCandidatesAll]] call _logDebug;
		private _sampleObjects = (_armoredCandidatesAll + _landVehicleCandidatesAll + _infantryCandidatesAll);
		_sampleObjects = _sampleObjects select {alive _x};
		_sampleObjects resize ((count _sampleObjects) min 5);
		{
			private _friendValue = _droneSide getFriend side _x;
			[_droneVehicle, format ["Scan sample | obj=%1 type=%2 side=%3 friend=%4 inArea=%5", _x, typeOf _x, side _x, _friendValue, (isNull _zoneTriggerObject) || {_x inArea _zoneTriggerObject}]] call _logDebug;
		} forEach _sampleObjects;
	};

	objNull
};

private _getRandomPatrolPositionATL = {
	params ["_zoneCenterPositionATL", "_zoneRadiusMeters", "_altitudeMeters"];

	private _patrolPositionATL = _zoneCenterPositionATL getPos [random _zoneRadiusMeters, random 360];
	_patrolPositionATL set [2, _altitudeMeters];
	_patrolPositionATL
};

private _setPatrolWaypointToPosition = {
	params ["_waypoint", "_patrolPositionATL"];

	_waypoint setWaypointPosition [_patrolPositionATL, 0];
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointSpeed "FULL";
	_waypoint setWaypointBehaviour "AWARE";
	_waypoint setWaypointCombatMode "RED";
};

private _triggerFpvDetonation = {
	params ["_droneVehicle", "_droneControllerUnit", "_explosionClassName", "_logDebug"];
	if (isNull _droneVehicle) exitWith {};

	private _explosionClassNameLower = toLower _explosionClassName;
	private _useAutomaticDetonation = (_explosionClassName == "") || {_explosionClassNameLower == "auto"};

	// FPV_UA drones handle warhead logic via UA_fnc_fpv_onDestroy.
	// Calling it directly avoids cases where setDamage does not trigger the EH quickly (or at all) and prevents
	// the drone from "spinning" on the ground while terminal steering continues.
	if (_useAutomaticDetonation) exitWith {
		[_droneVehicle, "Detonation | using FPV_UA default (UA_fnc_fpv_onDestroy)"] call _logDebug;
		if (!isNil "UA_fnc_fpv_onDestroy") then {
			[_droneVehicle] call UA_fnc_fpv_onDestroy;
		} else {
			_droneVehicle setDamage 1;
		};
	};

	private _detonationAmmoClassName = _explosionClassName;

	if (!isClass (configFile >> "CfgAmmo" >> _detonationAmmoClassName)) exitWith {
		[_droneVehicle, format ["Detonation ammo missing | requested=%1 | falling back to FPV_UA default", _detonationAmmoClassName]] call _logDebug;
		if (!isNil "UA_fnc_fpv_onDestroy") then {
			[_droneVehicle] call UA_fnc_fpv_onDestroy;
		} else {
			_droneVehicle setDamage 1;
		};
	};

	private _instigatorUnit = (UAVControl _droneVehicle) param [0, objNull];
	private _killerUnit = if (!isNull _droneControllerUnit) then {_droneControllerUnit} else {driver _droneVehicle};

	[_droneVehicle, format ["Detonation | ammo=%1 killer=%2 instigator=%3", _detonationAmmoClassName, _killerUnit, _instigatorUnit]] call _logDebug;

	private _detonationAmmoObject = createVehicle [_detonationAmmoClassName, _droneVehicle modelToWorld [0, 0, 0]];
	_detonationAmmoObject setVectorDirAndUp [vectorDir _droneVehicle, vectorUp _droneVehicle];

	[_detonationAmmoObject, [_killerUnit, _instigatorUnit]] remoteExec ["setShotParents", 2];
	[_detonationAmmoObject, true] remoteExec ["hideObjectGlobal", 2];

	deleteVehicle _droneVehicle;

	if (!isNil "CBA_fnc_waitUntilAndExecute") then {
		[
			{
				_this params ["_detonationAmmoObject", "_shotParents"];
				(getShotParents _detonationAmmoObject) isEqualTo _shotParents
			},
			{
				_this params ["_detonationAmmoObject"];
				triggerAmmo _detonationAmmoObject;
			},
			[_detonationAmmoObject, [_killerUnit, _instigatorUnit]]
		] call CBA_fnc_waitUntilAndExecute;
	} else {
		triggerAmmo _detonationAmmoObject;
	};
};

// Create a single patrol waypoint that we keep updating.
private _patrolWaypoint = [];
if (!isNull _droneGroup) then {
	_patrolWaypoint = _droneGroup addWaypoint [_zoneCenterPositionATL, 0];
	private _initialPatrolPositionATL = [_zoneCenterPositionATL, _zoneRadiusMeters, _patrolAltitudeMeters] call _getRandomPatrolPositionATL;
	[_patrolWaypoint, _initialPatrolPositionATL] call _setPatrolWaypointToPosition;
};


// Search loop: patrol using AI waypoints and scan until a target is found or timeout occurs.
private _lastScanLogTimeSeconds = -1;
while {alive _droneVehicle} do {
	private _elapsedSeconds = diag_tickTime - _startTimeSeconds;
	if (_searchTimeoutSeconds > 0 && {_elapsedSeconds > _searchTimeoutSeconds}) exitWith {};

	if (_shouldLogDebug && {diag_tickTime - _lastScanLogTimeSeconds > 10}) then {
		_lastScanLogTimeSeconds = diag_tickTime;
		[_droneVehicle, format ["Patrol | dronePos=%1 droneAltATL=%2", getPosATL _droneVehicle, (getPosATL _droneVehicle) select 2]] call _logDebug;
	};

	private _hostileTarget = [_droneVehicle, _zoneCenterPositionATL, _zoneRadiusMeters, _droneSide, _zoneTriggerObject, _logDebug] call _selectHostileTarget;
	if (!isNull _hostileTarget) exitWith {
		[_droneVehicle, format ["Target acquired | target=%1 type=%2 side=%3 dist=%4", _hostileTarget, typeOf _hostileTarget, side _hostileTarget, _droneVehicle distance _hostileTarget]] call _logDebug;
		// Attack approach: use AI movement until close, then do a single terminal "send it" run.
		private _attackTimeoutSeconds = 120;
		private _attackStartTimeSeconds = diag_tickTime;
		private _didDetonateThisAttack = false;

		while {alive _droneVehicle && {alive _hostileTarget}} do {
			private _attackElapsedSeconds = diag_tickTime - _attackStartTimeSeconds;
			if (_attackTimeoutSeconds > 0 && {_attackElapsedSeconds > _attackTimeoutSeconds}) exitWith {};

			private _distanceToTargetMeters = _droneVehicle distance _hostileTarget;
			private _distanceToTarget2DMeters = _droneVehicle distance2D _hostileTarget;
			if (_distanceToTarget2DMeters <= _terminalStartDistanceMeters) exitWith {};

			private _targetPositionATL = getPosATL _hostileTarget;
			_targetPositionATL set [2, _patrolAltitudeMeters];

			if (!isNull _droneControllerUnit) then {
				_droneControllerUnit doMove _targetPositionATL;
			};

			if (_shouldLogDebug && {(_attackElapsedSeconds % 5) < 0.6}) then {
				[_droneVehicle, format ["Approach | dist3D=%1 dist2D=%2 droneAltATL=%3 targetPosATL=%4", _distanceToTargetMeters, _distanceToTarget2DMeters, (getPosATL _droneVehicle select 2), _targetPositionATL]] call _logDebug;
			};

			sleep 0.5;
		};

		if (alive _droneVehicle && {alive _hostileTarget} && {(_droneVehicle distance2D _hostileTarget) <= _terminalStartDistanceMeters}) then {
			[_droneVehicle, format ["Terminal start | dist3D=%1 dist2D=%2", _droneVehicle distance _hostileTarget, _droneVehicle distance2D _hostileTarget]] call _logDebug;

			// Allow the drone to actually dive onto the target during the terminal run.
			_droneVehicle flyInHeight 5;
			private _targetPositionASL = getPosASL _hostileTarget;
			private _aimAngleDegrees = random 360;
			private _aimRadiusMeters = random _terminalAimOffsetRadiusMeters;
			private _aimOffsetVector = [
				(sin _aimAngleDegrees) * _aimRadiusMeters,
				(cos _aimAngleDegrees) * _aimRadiusMeters,
				0
			];

			private _terminalAimPositionASL = _targetPositionASL vectorAdd _aimOffsetVector;
			_terminalAimPositionASL set [2, (_terminalAimPositionASL select 2) + 0.6];

			[_droneVehicle, format ["Terminal aim | targetASL=%1 aimASL=%2 offset=%3", _targetPositionASL, _terminalAimPositionASL, _aimOffsetVector]] call _logDebug;

			// Terminal guidance toward a single randomized aim point (introduces miss chance).
			// Run steering in a separate thread so we can detect impact and detonate immediately.
			private _terminalSteerScript = [_droneVehicle, _terminalAimPositionASL, _cruiseSpeedKilometersPerHour] spawn {
				params ["_droneVehicle", "_terminalAimPositionASL", "_cruiseSpeedKilometersPerHour"];
				[_droneVehicle, _terminalAimPositionASL, _cruiseSpeedKilometersPerHour, 2, 0.05, 8, [0,0,0], "ASL", true] call OKS_fnc_SteerVehicleToTarget;
			};

			private _didDetonateOnImpact = false;
			while {alive _droneVehicle && {!scriptDone _terminalSteerScript}} do {
				if (isTouchingGround _droneVehicle) exitWith {
					terminate _terminalSteerScript;
					[_droneVehicle, "Terminal impact detected | detonating"] call _logDebug;
					[_droneVehicle, _droneControllerUnit, _explosionClassName, _logDebug] call _triggerFpvDetonation;
					_didDetonateOnImpact = true;
					_didDetonateThisAttack = true;
				};
				sleep 0.05;
			};

			if (!_didDetonateOnImpact) then {
				waitUntil {sleep 0.01; scriptDone _terminalSteerScript || isNull _droneVehicle};
				[_droneVehicle, format ["Terminal steer finished | distToTarget=%1", if (isNull _droneVehicle) then {-1} else {_droneVehicle distance _hostileTarget}]] call _logDebug;
			};

			// If we detonated on impact (or the drone got deleted), don't do any proximity checks.
			if (_didDetonateOnImpact || {isNull _droneVehicle} || {!alive _droneVehicle}) then {
				_didDetonateThisAttack = true;
			};
		};

		if (!_didDetonateThisAttack && {alive _droneVehicle}) then {
			// Detonation only when actually close to the target.
			// Prefer true 3D proximity; if using 2D proximity, require low altitude so it won't detonate while still cruising.
			private _distanceToTargetMeters = _droneVehicle distance _hostileTarget;
			private _distanceToTarget2DMeters = _droneVehicle distance2D _hostileTarget;
			private _droneAltitudeATL = getPosATL _droneVehicle select 2;
			private _isCloseEnough3D = _distanceToTargetMeters <= _detonationDistanceMeters;
			private _isCloseEnough2DAndLow = (_distanceToTarget2DMeters <= _detonationDistanceMeters) && {_droneAltitudeATL < 10};

			if (_isCloseEnough3D || {_isCloseEnough2DAndLow}) then {
				[_droneVehicle, format ["Detonate | dist3D=%1 dist2D=%2 droneAltATL=%3", _distanceToTargetMeters, _distanceToTarget2DMeters, _droneAltitudeATL]] call _logDebug;
				[_droneVehicle, _droneControllerUnit, _explosionClassName, _logDebug] call _triggerFpvDetonation;
				_didDetonateThisAttack = true;
			} else {
				[_droneVehicle, format ["No detonation | dist3D=%1 dist2D=%2 droneAltATL=%3 detonateDist=%4", _distanceToTargetMeters, _distanceToTarget2DMeters, _droneAltitudeATL, _detonationDistanceMeters]] call _logDebug;
			};
		};
	};

	// No target found: update the patrol waypoint occasionally.
	if (!isNull _droneGroup && {!(_patrolWaypoint isEqualTo [])}) then {
		private _currentWaypointPositionATL = waypointPosition _patrolWaypoint;
		private _distanceToWaypointMeters = _droneVehicle distance _currentWaypointPositionATL;
		if (_distanceToWaypointMeters < 200) then {
			private _newPatrolPositionATL = [_zoneCenterPositionATL, _zoneRadiusMeters, _patrolAltitudeMeters] call _getRandomPatrolPositionATL;
			[_patrolWaypoint, _newPatrolPositionATL] call _setPatrolWaypointToPosition;
			[_droneVehicle, format ["Patrol waypoint updated | newPosATL=%1", _newPatrolPositionATL]] call _logDebug;
		};
	};

	sleep 1;
};

if (isNull _droneVehicle) then {objNull} else {_droneVehicle}
