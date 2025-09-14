
params ["_convoyVehicleArray"];
private _isConvoyDebugEnabled = missionNamespace getVariable ["GOL_Convoy_Debug", false];
if (_convoyVehicleArray isEqualTo [] || isNull (_convoyVehicleArray select 0)) exitWith {};
if (_isConvoyDebugEnabled) then {
	format [
		"[CONVOY_AIR] Air handler started. Vehicles: %1",
		count _convoyVehicleArray
	] spawn OKS_fnc_LogDebug;
};
private _convoyCrewGroups = [];
{
	private _crewGroup = group driver _x;
	if (!isNull _crewGroup) then { _convoyCrewGroups pushBackUnique _crewGroup; };
} forEach _convoyVehicleArray;

private _convoySide = side (group driver (_convoyVehicleArray select 0));
private _ignoredAirTargets = [];
private _pullOffMaxSlopeDeg = missionNamespace getVariable ["GOL_Convoy_PullOffMaxSlopeDeg", 15];
private _pullOffMinRoadDist = missionNamespace getVariable ["GOL_Convoy_PullOffMinRoadDist", 20];
private _mergeGapMin = missionNamespace getVariable ["GOL_Convoy_MergeGapMin", 80];
private _mergeGapTimeout = missionNamespace getVariable ["GOL_Convoy_MergeGapTimeout", 30];
private _speedRampStepKph = missionNamespace getVariable ["GOL_Convoy_SpeedRampStepKph", 10];
private _speedRampInterval = missionNamespace getVariable ["GOL_Convoy_SpeedRampInterval", 1];


while { true } do {
	if ((({ !isNull _x && alive _x } count _convoyVehicleArray) == 0)) exitWith {};

	_convoyCrewGroups = [];
	{
		private _crewGroup = group driver _x;
		if (!isNull _crewGroup) then { _convoyCrewGroups pushBackUnique _crewGroup; };
	} forEach _convoyVehicleArray;

	waitUntil {
		sleep 0.5;
		(count ([_convoyCrewGroups, _convoyVehicleArray, _convoySide, _ignoredAirTargets] call OKS_fnc_Convoy_FindEnemyAirTargets)) > 0
	};

	private _initialDetectedAirTargets = [_convoyCrewGroups, _convoyVehicleArray, _convoySide, _ignoredAirTargets] call OKS_fnc_Convoy_FindEnemyAirTargets;
	private _previousDetectedAirTargets = +_initialDetectedAirTargets;
	if (_isConvoyDebugEnabled) then {
		private _nearestAirTargetDistance = 1e9;
		private _nearestAirTarget = objNull;
		{
			private _distanceToAirTarget = (_convoyVehicleArray select 0) distance _x;
			if (_distanceToAirTarget < _nearestAirTargetDistance) then { _nearestAirTargetDistance = _distanceToAirTarget; _nearestAirTarget = _x; };
		} forEach _initialDetectedAirTargets;
		format [
			"[CONVOY_AIR] Detected %1 hostile air targets. Nearest: %2 at %3m",
			count _initialDetectedAirTargets,
			_nearestAirTarget,
			round _nearestAirTargetDistance
		] spawn OKS_fnc_LogDebug;
	};

	private _aaVehicle = [_convoyVehicleArray, _isConvoyDebugEnabled] call OKS_fnc_Convoy_SelectAAVehicle;
	if (isNull _aaVehicle) then {
		if (_isConvoyDebugEnabled) then { "[CONVOY_AIR] No suitable AA vehicle found in convoy" spawn OKS_fnc_LogDebug; };
		sleep 5;
		continue;
	};

	if (_isConvoyDebugEnabled) then {
		format [
			"[CONVOY_AIR] Selected AA vehicle: %1",
			_aaVehicle
		] spawn OKS_fnc_LogDebug;
	};

	// Store pending waypoints (from current index onward)
	private _aaGroup = group (driver _aaVehicle);
	private _waypointCount = count (waypoints _aaGroup);
	private _currentWaypointIndex = currentWaypoint _aaGroup; // Arma uses 0-based indices for waypoints
	private _storedWaypoints = [];
	// Capture from current index onward using indices and getWPPos to avoid [0,0,0]
	for "_i" from _currentWaypointIndex to (_waypointCount - 1) do {
		private _waypoint = (waypoints _aaGroup) select _i;
		private _waypointPos = getWPPos [_aaGroup, _i];
		_storedWaypoints pushBack [
			_waypointPos,
			waypointType _waypoint,
			waypointCompletionRadius _waypoint,
			waypointSpeed _waypoint,
			waypointBehaviour _waypoint,
			waypointFormation _waypoint,
			waypointCombatMode _waypoint,
			waypointStatements _waypoint
		];
	};
	// Remove the pending waypoints we just stored
	for "_i" from (_waypointCount - 1) to _currentWaypointIndex step -1 do {
		deleteWaypoint [_aaGroup, _i];
	};
	if (_isConvoyDebugEnabled) then {
		format ["[CONVOY_AIR] Stored %1 pending waypoints for %2", count _storedWaypoints, _aaVehicle] spawn OKS_fnc_LogDebug;
	};

	// Compute a pull-off point: 50m ahead of the AA vehicle, then offset to the clearer side by 15m if possible
	private _aaVehiclePos = getPosATL _aaVehicle;
	private _aaVehicleDir = getDir _aaVehicle;
	private _posAhead = [
		(_aaVehiclePos select 0) + 50 * (sin _aaVehicleDir),
		(_aaVehiclePos select 1) + 50 * (cos _aaVehicleDir),
		(_aaVehiclePos select 2)
	];

	private _leftDir = _aaVehicleDir - 90;
	private _rightDir = _aaVehicleDir + 90;
	private _leftPos = [(_posAhead select 0) + 35 * (sin _leftDir), (_posAhead select 1) + 35 * (cos _leftDir), _posAhead select 2];
	private _rightPos = [(_posAhead select 0) + 35 * (sin _rightDir), (_posAhead select 1) + 35 * (cos _rightDir), _posAhead select 2];
	private _pullOffPos = if ((!([_leftPos, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_leftPos, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) then {_leftPos} else { if ((!([_rightPos, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_rightPos, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) then {_rightPos} else {_posAhead} };

	// If pull-off equals current location (no offset possible), force a short forward move to avoid blocking
	if (_pullOffPos distance2D _aaVehiclePos < 6) then {
		private _posShortAhead = [
			(_aaVehiclePos select 0) + 20 * (sin _aaVehicleDir),
			(_aaVehiclePos select 1) + 20 * (cos _aaVehicleDir),
			(_aaVehiclePos select 2)
		];
		private _leftShort = [(_posShortAhead select 0) + 25 * (sin _leftDir), (_posShortAhead select 1) + 25 * (cos _leftDir), _posShortAhead select 2];
		private _rightShort = [(_posShortAhead select 0) + 25 * (sin _rightDir), (_posShortAhead select 1) + 25 * (cos _rightDir), _posShortAhead select 2];
		_pullOffPos = if (!([_leftShort, 7] call OKS_fnc_Convoy_IsBlocked)) then {_leftShort} else { if (!([_rightShort, 7] call OKS_fnc_Convoy_IsBlocked)) then {_rightShort} else {_posShortAhead} };
	};

	// Extra nudge further off-road along the chosen lateral direction if possible (adds ~10m more margin)
	if (!(_pullOffPos isEqualTo _posAhead)) then {
		private _useLeft = (_pullOffPos distance2D _leftPos) <= (_pullOffPos distance2D _rightPos);
		private _nudgeDir = if (_useLeft) then {_leftDir} else {_rightDir};
		private _nudged = [
			(_pullOffPos select 0) + 10 * (sin _nudgeDir),
			(_pullOffPos select 1) + 10 * (cos _nudgeDir),
			(_pullOffPos select 2)
		];
		if ((!([_nudged, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_nudged, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) then { _pullOffPos = _nudged; };
		// Enforce minimum distance from road after nudge
		_pullOffPos = [_pullOffPos, _nudgeDir, _pullOffMinRoadDist] call OKS_fnc_Convoy_EnsureMinRoadDistance;
	};

	// Ensure the pull-off is not on the road; if it is, step laterally further until off-road or try the other side
	if (isOnRoad _pullOffPos) then {
		private _tryDir = if ((_pullOffPos distance2D _leftPos) <= (_pullOffPos distance2D _rightPos)) then { _leftDir } else { _rightDir };
		private _fixed = false;
		{
			private _candidate = [
				(_pullOffPos select 0) + _x * (sin _tryDir),
				(_pullOffPos select 1) + _x * (cos _tryDir),
				(_pullOffPos select 2)
			];
		if ((!([_candidate, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_candidate] call OKS_fnc_Convoy_IsOffRoad) && ([_candidate, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) exitWith { _pullOffPos = _candidate; _fixed = true; };
		} forEach [5,10,15,20,25,30];
		if (!_fixed) then {
			// Try opposite lateral
			private _altDir = if (_tryDir isEqualTo _leftDir) then { _rightDir } else { _leftDir };
			{
				private _candidate2 = [
					(_pullOffPos select 0) + _x * (sin _altDir),
					(_pullOffPos select 1) + _x * (cos _altDir),
					(_pullOffPos select 2)
				];
				if ((!([_candidate2, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_candidate2] call OKS_fnc_Convoy_IsOffRoad) && ([_candidate2, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) exitWith { _pullOffPos = _candidate2; _fixed = true; };
			} forEach [5,10,15,20,25,30];
		};
		if (!_fixed) then {
			// Last resort: move a bit further forward and re-check lateral 15m
			private _posAheadFurther = [
				(_pullOffPos select 0) + 15 * (sin _aaVehicleDir),
				(_pullOffPos select 1) + 15 * (cos _aaVehicleDir),
				(_pullOffPos select 2)
			];
			private _candidateLeft = [(_posAheadFurther select 0) + 15 * (sin _leftDir), (_posAheadFurther select 1) + 15 * (cos _leftDir), _posAheadFurther select 2];
			private _candidateRight = [(_posAheadFurther select 0) + 15 * (sin _rightDir), (_posAheadFurther select 1) + 15 * (cos _rightDir), _posAheadFurther select 2];
		if ((!([_candidateLeft, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_candidateLeft] call OKS_fnc_Convoy_IsOffRoad) && ([_candidateLeft, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) then { _pullOffPos = _candidateLeft; _fixed = true; };
		if (!_fixed && (!([_candidateRight, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_candidateRight] call OKS_fnc_Convoy_IsOffRoad) && ([_candidateRight, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) then { _pullOffPos = _candidateRight; _fixed = true; };
			if (!_fixed) then { _pullOffPos = _posAheadFurther; };
		};
		// Enforce minimum distance from road after lateral stepping
		private _finalLatDir = if ((_pullOffPos distance2D _leftPos) <= (_pullOffPos distance2D _rightPos)) then { _leftDir } else { _rightDir };
		_pullOffPos = [_pullOffPos, _finalLatDir, _pullOffMinRoadDist] call OKS_fnc_Convoy_EnsureMinRoadDistance;
		if (_isConvoyDebugEnabled) then {
			format ["[CONVOY_AIR] Pull-off adjusted off-road. Pos: %1", _pullOffPos] spawn OKS_fnc_LogDebug;
		};
	};
	if (_isConvoyDebugEnabled) then {
		private _side = if (_pullOffPos isEqualTo _leftPos) then {"left"} else { if (_pullOffPos isEqualTo _rightPos) then {"right"} else {"ahead"} };
		format [
			"[CONVOY_AIR] Pull-off point chosen to the %1. Pos: %2",
			_side,
			_pullOffPos
		] spawn OKS_fnc_LogDebug;
	};

	// Add temporary waypoint to pull-off point
	private _tempWaypoint = _aaGroup addWaypoint [_pullOffPos, 0];
	_tempWaypoint setWaypointType "MOVE";
	_tempWaypoint setWaypointCompletionRadius 6;
	// Travel conservatively to avoid stopping/engaging on the road
	_tempWaypoint setWaypointBehaviour "AWARE";
	_tempWaypoint setWaypointCombatMode "YELLOW";
	{ 
		_x disableAI "AUTOCOMBAT";
		_x disableAI "TARGET";
		_x disableAI "AUTOTARGET";
		_x doTarget objNull;
		_x doWatch objNull;
	} forEach (units _aaGroup);
	// Hard hold fire while moving to pull-off
	_aaGroup setCombatMode "BLUE";
	// Unlock AA speed for the pull-off movement
	if (!isNull _aaVehicle && {canMove _aaVehicle}) then { _aaVehicle limitSpeed 999; _aaVehicle forceSpeed -1; };

	// Mark AA engagement to prevent generic ambush handler from interfering
	_aaVehicle setVariable ["OKS_Convoy_AAEngaging", true, true];

	// Travel to the pull-off
	waitUntil {
		sleep 0.5;
		isNull _aaVehicle || !canMove _aaVehicle || (_aaVehicle distance _pullOffPos < 10)
	};
	if (!isNull _aaVehicle && canMove _aaVehicle) then {
		// If still on road, issue a small lateral nudge waypoint to get off the road
		private _aaVehicleHere = getPosATL _aaVehicle;
		if (isOnRoad _aaVehicleHere) then {
			private _useLeft = (_pullOffPos distance2D [(_aaVehicleHere select 0) + (sin _leftDir), (_aaVehicleHere select 1) + (cos _leftDir)]) <=
							(_pullOffPos distance2D [(_aaVehicleHere select 0) + (sin _rightDir), (_aaVehicleHere select 1) + (cos _rightDir)]);
			private _nudgeDir = if (_useLeft) then { _leftDir } else { _rightDir };
			private _offRoadPos = [(_aaVehicleHere select 0) + 12 * (sin _nudgeDir), (_aaVehicleHere select 1) + 12 * (cos _nudgeDir), _aaVehicleHere select 2];
			private _tempWaypoint2 = _aaGroup addWaypoint [_offRoadPos, 0];
			_tempWaypoint2 setWaypointType "MOVE";
			_tempWaypoint2 setWaypointCompletionRadius 4;
			_tempWaypoint2 setWaypointBehaviour "AWARE";
			_tempWaypoint2 setWaypointCombatMode "YELLOW";
			if (_isConvoyDebugEnabled) then { "[CONVOY_AIR] Pull-off on road; issuing extra nudge off-road" spawn OKS_fnc_LogDebug; };
			waitUntil { sleep 0.5; isNull _aaVehicle || !canMove _aaVehicle || (!isOnRoad (getPosATL _aaVehicle)) || (_aaVehicle distance _offRoadPos < 5) };
		};
		// Now hold and engage
		{ 
			_x enableAI "TARGET";
			_x enableAI "AUTOTARGET";
			_x enableAI "AUTOCOMBAT"; 
		} forEach (units _aaGroup);
		_aaGroup setBehaviour "COMBAT";
		_aaGroup setCombatMode "RED";
		_aaVehicle limitSpeed 0; _aaVehicle forceSpeed 0;
		if (_isConvoyDebugEnabled) then { format ["[CONVOY_AIR] %1 reached pull-off and is engaging air targets", _aaVehicle] spawn OKS_fnc_LogDebug; };
	};

	// Wait until: no enemy air remains AND nearest convoy vehicle is at least 100m away,
	// or a clear-sky timeout passes (grace restore)
	private _noAirSince = -1;
	private _engageStartTime = time;
	waitUntil {
		sleep 1;
		private _currentAirTargets = [_convoyCrewGroups, _convoyVehicleArray, _convoySide, _ignoredAirTargets] call OKS_fnc_Convoy_FindEnemyAirTargets;
		// Mark destroyed/disabled air targets to be ignored going forward and clear targeting state
		{
			private _airTarget = _x;
			if (!isNull _airTarget && ((!alive _airTarget) || (!canMove _airTarget))) then {
				if (!(_airTarget in _ignoredAirTargets)) then {
					_ignoredAirTargets pushBack _airTarget;
					{
						_x ignoreTarget _airTarget;
						_x doTarget objNull;
						_x doWatch objNull;
						_x reveal [_airTarget, 0];
						// Clear any residual target memory if supported
						_x forgetTarget _airTarget;
					} forEach (units _aaGroup);
					if (_isConvoyDebugEnabled) then {
						format ["[CONVOY_AIR] Ignoring destroyed/disabled air target: %1", _airTarget] spawn OKS_fnc_LogDebug;
					};
				};
			};
		} forEach _previousDetectedAirTargets;
		_previousDetectedAirTargets = +_currentAirTargets;
		// Track time since skies became clear
		if ((count _currentAirTargets) == 0) then {
			if (_noAirSince < 0) then { _noAirSince = time; };
		} else {
			_noAirSince = -1;
		};

		// Compute nearest distance to OTHER convoy vehicles (exclude AA itself)
		private _nearestConvoyDist = 1e9;
		{
			if (!isNull _x && (_x != _aaVehicle)) then {
				_nearestConvoyDist = _nearestConvoyDist min (_aaVehicle distance _x);
			};
		} forEach _convoyVehicleArray;

		// If nothing else in array (edge case), allow immediate restore
		if (_nearestConvoyDist isEqualTo 1e9) then { _nearestConvoyDist = 10000; };

		private _clearAndSpaced = ((count _currentAirTargets) == 0) && (_nearestConvoyDist >= 100);
		private _timeout = (_noAirSince >= 0) && ((time - _noAirSince) > 30);
		private _hardTimeout = (time - _engageStartTime) > 90;

		if (_isConvoyDebugEnabled) then {
			format [
				"[CONVOY_AIR] Waiting to restore: air=%1 nearest=%2m clearAndSpaced=%3 timeout=%4 hardTimeout=%5 (since=%6)",
				count _currentAirTargets,
				round _nearestConvoyDist,
				_clearAndSpaced,
				_timeout,
				_hardTimeout,
				_noAirSince
			] spawn OKS_fnc_LogDebug;
		};
		_clearAndSpaced || _timeout || _hardTimeout
	};

	// Restore: remove temporary waypoint, recreate stored ones, clear AA flag
	private _finalWaypointCount = count (waypoints _aaGroup);
	for "_i" from (_finalWaypointCount - 1) to 0 step -1 do { deleteWaypoint [_aaGroup, _i]; };
	{
		_x params ["_pos","_type","_cr","_spd","_beh","_form","_cm","_stmts"];
		private _wp = _aaGroup addWaypoint [_pos, 0];
		_wp setWaypointType _type;
		_wp setWaypointCompletionRadius _cr;
		_wp setWaypointSpeed _spd;
		_wp setWaypointBehaviour _beh;
		_wp setWaypointFormation _form;
		_wp setWaypointCombatMode _cm;
		_wp setWaypointStatements _stmts;
	} forEach _storedWaypoints;
	if (_isConvoyDebugEnabled) then {
		format ["[CONVOY_AIR] Restored %1 waypoints for %2", count _storedWaypoints, _aaVehicle] spawn OKS_fnc_LogDebug;
	};

	_aaVehicle setVariable ["OKS_Convoy_AAEngaging", false, true];
	if (!isNull _aaVehicle && {canMove _aaVehicle}) then {
		_aaVehicle limitSpeed 999;
		_aaVehicle forceSpeed -1;
		_aaVehicle setBehaviour "CARELESS";
		if (_isConvoyDebugEnabled) then {
			format ["[CONVOY_AIR] AA vehicle %1 restored to CARELESS mode after engagement", _aaVehicle] spawn OKS_fnc_LogDebug;
		};
	};

	// Reinsert AA vehicle at tail and start its speed logic behind previous tail
	private _leadVehicle = _convoyVehicleArray select 0;
	private _convoyArray = _leadVehicle getVariable ["OKS_Convoy_VehicleArray", _convoyVehicleArray];
	// Remove AA if present, then append
	private _aaVehicleIdx = _convoyArray find _aaVehicle;
	if (_aaVehicleIdx >= 0) then { _convoyArray deleteAt _aaVehicleIdx; };
	_convoyArray pushBack _aaVehicle;
	_leadVehicle setVariable ["OKS_Convoy_VehicleArray", _convoyArray, true];
	if (_isConvoyDebugEnabled) then {
		format ["[CONVOY_AIR] Appended %1 as tail vehicle. Convoy size now: %2", _aaVehicle, count _convoyArray] spawn OKS_fnc_LogDebug;
	};

	if ((count _convoyArray) > 1) then {
		private _previousTailVehicle = _convoyArray select ((count _convoyArray) - 2);
		// Apply AA vehicle's own stored speed/dispersion or use base from previous tail
		private _aaVehicleSpeedKph = _aaVehicle getVariable ["OKS_LimitSpeedBase", (_previousTailVehicle getVariable ["OKS_LimitSpeedBase", 40])];
		private _aaVehicleDispersion = _aaVehicle getVariable ["OKS_Convoy_Dispersion", (_previousTailVehicle getVariable ["OKS_Convoy_Dispersion", 25])];
		_aaVehicle setVariable ["OKS_LimitSpeedBase", _aaVehicleSpeedKph, true];
		_aaVehicle setVariable ["OKS_Convoy_Dispersion", _aaVehicleDispersion, true];

		// Align AA group's current waypoint to the leader's current waypoint to avoid aiming for an old mid-column WP
		private _leadGroup = group driver _leadVehicle;
		private _aaGroupCurrent = group driver _aaVehicle;
		private _leadCurrentWaypoint = currentWaypoint _leadGroup;
		private _aaGroupWaypointCount = count (waypoints _aaGroupCurrent);
		if (_aaGroupWaypointCount > 0) then {
			if (_leadCurrentWaypoint < 1) then { _leadCurrentWaypoint = 1; };
			if (_leadCurrentWaypoint > _aaGroupWaypointCount) then { _leadCurrentWaypoint = _aaGroupWaypointCount; };
			_aaGroupCurrent setCurrentWaypoint [_aaGroupCurrent, _leadCurrentWaypoint];
			if (_isConvoyDebugEnabled) then {
				format ["[CONVOY_AIR] Synced AA current WP to leader: idx %1 (AA has %2 WPs)", _leadCurrentWaypoint, _aaGroupWaypointCount] spawn OKS_fnc_LogDebug;
			};
		};

		// Detect a halted convoy (simple check: leader barely moving)
		private _isConvoyMoving = (vectorMagnitude (velocity _leadVehicle)) > 0.8;

		if (_isConvoyMoving) then {
			// Enforce a merge gap before accelerating, then ramp speed to avoid collisions
			[_aaVehicle, _previousTailVehicle, _aaVehicleDispersion, _mergeGapMin, _mergeGapTimeout, _speedRampStepKph, _speedRampInterval] spawn OKS_fnc_Convoy_AAMergeGapHandler;
			_aaVehicle forceSpeed -1;
			_aaVehicle limitSpeed 999;
			[_aaVehicle, _previousTailVehicle, _aaVehicleDispersion] spawn OKS_fnc_Convoy_CheckAndAdjustSpeeds;
		} else {
			// Convoy is halted: park AA at tail and hold. Your convoy controller will release it when movement resumes.
			if (!isNull _aaVehicle && {canMove _aaVehicle}) then {
				_aaVehicle limitSpeed 0;
				_aaVehicle forceSpeed 0;
			};
			if (_isConvoyDebugEnabled) then {
				"[CONVOY_AIR] Convoy halted; AA parked at tail and holding. Ramp deferred." spawn OKS_fnc_LogDebug;
			};
		}
	};
	if (_isConvoyDebugEnabled) then { "[CONVOY_AIR] AA vehicle rejoined convoy and waypoints restored" spawn OKS_fnc_LogDebug; };

	// Refresh lead vehicle pointer on all convoy vehicles
	{
		_x setVariable ["OKS_Convoy_LeadVehicle", _leadVehicle, true];
	} forEach _convoyArray;
	// Loop will continue to wait for the next interception
};