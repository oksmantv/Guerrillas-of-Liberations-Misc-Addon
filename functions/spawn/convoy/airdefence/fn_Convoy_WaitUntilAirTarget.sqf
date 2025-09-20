
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
private _pullOffMinRoadDist = missionNamespace getVariable ["GOL_Convoy_PullOffMinRoadDist", 10];
private _mergeGapMin = missionNamespace getVariable ["GOL_Convoy_MergeGapMin", 80];
private _mergeGapTimeout = missionNamespace getVariable ["GOL_Convoy_MergeGapTimeout", 30];
private _speedRampStepKph = missionNamespace getVariable ["GOL_Convoy_SpeedRampStepKph", 10];
private _speedRampInterval = missionNamespace getVariable ["GOL_Convoy_SpeedRampInterval", 1];


while { ({_x getVariable ['OKS_Convoy_Stopped', false]} count _convoyVehicleArray) != count _convoyVehicleArray } do {
	if (({!isNull _x && alive _x} count _convoyVehicleArray) == 0) exitWith {};

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

	// Calculate checkpoint position for convoy passing detection BEFORE AA moves
	// Set checkpoint ahead of AA's position in convoy direction, not at AA's position
	private _aaPos = getPosATL _aaVehicle;
	private _aaDir = getDir _aaVehicle;
	private _checkpointPos = _aaPos vectorAdd [50 * sin _aaDir, 50 * cos _aaDir, 0]; // 50m ahead of AA
	_aaVehicle setVariable ["OKS_AA_CheckpointPos", _checkpointPos];
	_aaVehicle setVariable ["OKS_AA_VehiclesPassed", []];
	// Store original convoy array before AA gets detached
	_aaVehicle setVariable ["OKS_AA_OriginalConvoyArray", +_convoyVehicleArray];

	if (_isConvoyDebugEnabled) then {
		format ["[CONVOY_AIR] Checkpoint position set at %1 for convoy passing detection", _checkpointPos] spawn OKS_fnc_LogDebug;
	};

	// Immediately reveal all detected air targets to AA group for faster engagement
	{
		private _airTarget = _x;
		if (!isNull _airTarget && {alive _airTarget}) then {
			_aaVehicle reveal [_airTarget, 4];
			{
				_x reveal [_airTarget, 4];
			} forEach (crew _aaVehicle);
			if (_isConvoyDebugEnabled) then {
				format ["[CONVOY_AIR] Pre-revealed air target %1 to AA vehicle/group", _airTarget] spawn OKS_fnc_LogDebug;
			};
		};
	} forEach _initialDetectedAirTargets;

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

	// Compute a pull-off point: 50m ahead of the AA vehicle, then offset to the clearer side by ~18m if possible
	private _aaVehiclePos = getPosATL _aaVehicle;
	private _aaVehicleDir = getDir _aaVehicle;
	private _posAhead = [
		(_aaVehiclePos select 0) + 50 * (sin _aaVehicleDir),
		(_aaVehiclePos select 1) + 50 * (cos _aaVehicleDir),
		(_aaVehiclePos select 2)
	];

	private _leftDir = _aaVehicleDir - 90;
	private _rightDir = _aaVehicleDir + 90;
	// Increased lateral range by ~30% from the reduced baseline
	private _leftPos = [(_posAhead select 0) + 22.75 * (sin _leftDir), (_posAhead select 1) + 22.75 * (cos _leftDir), _posAhead select 2];
	private _rightPos = [(_posAhead select 0) + 22.75 * (sin _rightDir), (_posAhead select 1) + 22.75 * (cos _rightDir), _posAhead select 2];
	private _pullOffPos = if ((!([_leftPos, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_leftPos, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) then {_leftPos} else { if ((!([_rightPos, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_rightPos, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) then {_rightPos} else {_posAhead} };

	// If pull-off equals current location (no offset possible), force a short forward move to avoid blocking
	if (_pullOffPos distance2D _aaVehiclePos < 6) then {
		private _posShortAhead = [
			(_aaVehiclePos select 0) + 20 * (sin _aaVehicleDir),
			(_aaVehiclePos select 1) + 20 * (cos _aaVehicleDir),
			(_aaVehiclePos select 2)
		];
		// Increased short lateral by ~30%
		private _leftShort = [(_posShortAhead select 0) + 16.25 * (sin _leftDir), (_posShortAhead select 1) + 16.25 * (cos _leftDir), _posShortAhead select 2];
		private _rightShort = [(_posShortAhead select 0) + 16.25 * (sin _rightDir), (_posShortAhead select 1) + 16.25 * (cos _rightDir), _posShortAhead select 2];
		_pullOffPos = if (!([_leftShort, 7] call OKS_fnc_Convoy_IsBlocked)) then {_leftShort} else { if (!([_rightShort, 7] call OKS_fnc_Convoy_IsBlocked)) then {_rightShort} else {_posShortAhead} };
	};

	// Extra nudge further off-road along the chosen lateral direction if possible (adds ~5m more margin)
	if (!(_pullOffPos isEqualTo _posAhead)) then {
		private _useLeft = (_pullOffPos distance2D _leftPos) <= (_pullOffPos distance2D _rightPos);
		private _nudgeDir = if (_useLeft) then {_leftDir} else {_rightDir};
		private _nudged = [
			(_pullOffPos select 0) + 6.5 * (sin _nudgeDir),
			(_pullOffPos select 1) + 6.5 * (cos _nudgeDir),
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
		} forEach [5,10,15,20,25];
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
			} forEach [5,10,15,20,25];
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
	_tempWaypoint setWaypointCompletionRadius 8;
	_tempWaypoint setWaypointSpeed "FULL";
    if (_isConvoyDebugEnabled) then {
        format ["[CONVOY_AIR] Assigned pull-off waypoint to AA vehicle %1 at %2", _aaVehicle, _pullOffPos] spawn OKS_fnc_LogDebug;
    };
	if (!isNull _aaVehicle && {canMove _aaVehicle}) then {
		_aaVehicle setVariable ["OKS_Convoy_AAEngaging", true, true];
		if (_isConvoyDebugEnabled) then {
			format ["[CONVOY_AIR] AA vehicle %1 set to engaging (pull-off)", _aaVehicle] spawn OKS_fnc_LogDebug;
		};
		// Put group into AWARE/YELLOW now so per-vehicle speed governor (which runs in CARELESS) yields
		_aaGroup setBehaviour "AWARE";
		_aaGroup setCombatMode "YELLOW";
		// Ensure movement AI is enabled and off-road movement is allowed
		{
			_x enableAI "PATH";
			_x enableAI "MOVE";
		} forEach (units _aaGroup);
		private _drv = driver _aaVehicle;
		if (!isNull _drv) then { _drv forceFollowRoad false; };
	};

	// Travel conservatively to avoid stopping/engaging on the road
	_tempWaypoint setWaypointBehaviour "AWARE";
	_tempWaypoint setWaypointCombatMode "YELLOW";
	{ 
		// Disable all combat systems during travel to prevent roadblock firing
		_x disableAI "AUTOCOMBAT";
		_x disableAI "TARGET";
		_x disableAI "AUTOTARGET";
		_x doTarget objNull;
		_x doWatch objNull;
	} forEach (units _aaGroup);
	// Hold fire while moving to pull-off
	_aaGroup setCombatMode "BLUE"; // Blue = Hold fire

	// Unlock AA speed for the pull-off movement
	if (!isNull _aaVehicle && {canMove _aaVehicle}) then {
		_aaVehicle limitSpeed 999; _aaVehicle forceSpeed -1; 
		if (_isConvoyDebugEnabled) then {
			format ["[CONVOY_AIR] forceSpeed -1 applied (AA pull-off) to %1", _aaVehicle] spawn OKS_fnc_LogDebug;
		};
		// Issue an explicit doMove as a fallback in case waypoint driving stalls
		private _drv = driver _aaVehicle;
		if (!isNull _drv) then { _drv doMove _pullOffPos; };
		_aaVehicle doMove _pullOffPos;
	};

	// Travel to the pull-off with a timeout fail-safe
	private _pullOffTimeout = missionNamespace getVariable ["GOL_Convoy_AAPullOffTimeout", 45];
	private _skipDistanceDelay = missionNamespace getVariable ["GOL_Convoy_AAPullOffSkipDelay", 10]; // max delay before skipping distance check
	private _pullOffStartTime = time;
	private _lastHeartbeat = time;
	waitUntil {
		sleep 0.5;
		// After _skipDistanceDelay seconds, stop waiting on the precise distance and proceed to engage
		private _done = isNull _aaVehicle
			|| !canMove _aaVehicle
			|| (_aaVehicle distance _pullOffPos < 10)
			|| ((time - _pullOffStartTime) > _skipDistanceDelay)
			|| ((time - _pullOffStartTime) > _pullOffTimeout);
		if (_isConvoyDebugEnabled && {!_done} && {(time - _lastHeartbeat) > 5}) then {
			_lastHeartbeat = time;
			format ["[CONVOY_AIR] En-route to pull-off. Distance=%1m, Elapsed=%2s", round (_aaVehicle distance _pullOffPos), round (time - _pullOffStartTime)] spawn OKS_fnc_LogDebug;
		};
		_done
	};
	private _elapsedPullOff = time - _pullOffStartTime;
	private _timedOutShort = (!isNull _aaVehicle && {canMove _aaVehicle} && (_elapsedPullOff > _skipDistanceDelay));
	private _timedOutLong = (!isNull _aaVehicle && {canMove _aaVehicle} && (_elapsedPullOff > _pullOffTimeout));
	private _timedOutToPullOff = _timedOutShort || _timedOutLong;
	if (_isConvoyDebugEnabled) then {
		if (_timedOutToPullOff) then {
			private _mode = if (_timedOutLong) then { format ["timeout-long (%1s)", _pullOffTimeout] } else { format ["skip-distance (%1s)", _skipDistanceDelay] };
			format ["[CONVOY_AIR] Pull-off %1. Using current vicinity to engage. Pos: %2", _mode, getPosATL _aaVehicle] spawn OKS_fnc_LogDebug;
		} else {
			format ["[CONVOY_AIR] AA vehicle %1 reached pull-off at %2", _aaVehicle, _pullOffPos] spawn OKS_fnc_LogDebug;
		};
	};
	if (!isNull _aaVehicle) then {
		// Enable full engagement capabilities now that we're in position
		{ 
			_x enableAI "TARGET";
			_x enableAI "AUTOTARGET";
			_x enableAI "AUTOCOMBAT"; 
		} forEach (crew _aaVehicle);
		_aaGroup setBehaviour "COMBAT";
		_aaGroup setCombatMode "RED";

		_aaVehicle limitSpeed 0; _aaVehicle forceSpeed 0;
		if (_isConvoyDebugEnabled) then { format ["[CONVOY_AIR] %1 in position and engaging air targets with full combat capabilities", _aaVehicle] spawn OKS_fnc_LogDebug; };
	};

	// Wait until: no enemy air remains AND nearest convoy vehicle is at least 100m away,
	// or a clear-sky timeout passes (grace restore)
	private _noAirSince = -1;
	private _engageStartTime = time;
	private _allVehiclesPassed = false;
	private _timeout = false;
	private _hardTimeout = false;
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

		// Two-stage convoy passing detection:
		// Stage 1: Vehicles must pass through checkpoint (< 30m from AA original position = passed through)
		// Stage 2: Vehicles must be clear of AA vehicle (> 30m = safe distance)
		// Only check vehicles that are BEHIND the AA vehicle in convoy order
		private _checkpointPos = _aaVehicle getVariable ["OKS_AA_CheckpointPos", []];
		private _vehiclesPassed = _aaVehicle getVariable ["OKS_AA_VehiclesPassed", []];
		
		// Find AA vehicle's position in convoy array to only check vehicles behind it
		// Use original convoy array from when AA was selected, not current array (AA might be detached)
		private _originalConvoyArray = _aaVehicle getVariable ["OKS_AA_OriginalConvoyArray", _convoyVehicleArray];
		private _aaIndex = _originalConvoyArray find _aaVehicle;
		private _vehiclesBehindAA = [];
		if (_aaIndex >= 0) then {
			for "_i" from (_aaIndex + 1) to ((count _originalConvoyArray) - 1) do {
				_vehiclesBehindAA pushBack (_originalConvoyArray select _i);
			};
		} else {
			// Fallback: if AA not found in original array, use all vehicles behind current position
			private _currentAAIndex = _convoyVehicleArray find _aaVehicle;
			if (_currentAAIndex >= 0) then {
				for "_i" from (_currentAAIndex + 1) to ((count _convoyVehicleArray) - 1) do {
					_vehiclesBehindAA pushBack (_convoyVehicleArray select _i);
				};
			};
		};
		
		_allVehiclesPassed = true;
		private _closestConvoyDist = 1e9;
		private _closestVehicle = objNull;
		private _vehicleDistances = [];
		{
			if (!isNull _x && (_x != _aaVehicle)) then {
				private _dist = _aaVehicle distance _x; // Distance from current AA position for final spacing
				private _checkpointDist = _x distance _checkpointPos; // Distance from checkpoint for passage detection
				_vehicleDistances pushBack [_x, _dist];
				
				// Only process vehicles that are behind the AA in convoy order
				if (_x in _vehiclesBehindAA) then {
					// Stage 1: Check if vehicle passed through checkpoint area
					// Generous detection: vehicle is within 30m of the AA's original position
					if (!(_x in _vehiclesPassed) && (_checkpointDist < 30)) then {
						_vehiclesPassed pushBack _x;
						_aaVehicle setVariable ["OKS_AA_VehiclesPassed", _vehiclesPassed];
						if (_isConvoyDebugEnabled) then {
							format ["[CONVOY_AIR] Vehicle %1 passed checkpoint", _x] spawn OKS_fnc_LogDebug;
						};
					};
					
					// Stage 2: For vehicles that passed checkpoint, check if they're clear (>100m)
					if (_x in _vehiclesPassed) then {
						if (_dist < 60) then {
							_allVehiclesPassed = false;
						};
					} else {
						// Vehicle hasn't even passed checkpoint yet
						_allVehiclesPassed = false;
					};
				};
				// Note: vehicles ahead of AA don't affect _allVehiclesPassed
				
				if (_dist < _closestConvoyDist) then {
					_closestConvoyDist = _dist;
					_closestVehicle = _x;
				};
			};
		} forEach _convoyVehicleArray;

		// If no other vehicles in array (edge case), allow immediate restore
		if (_closestConvoyDist isEqualTo 1e9) then { 
			_closestConvoyDist = 10000; 
			_allVehiclesPassed = true;
		};

		private _clearAndSpaced = ((count _currentAirTargets) == 0) && _allVehiclesPassed;
		_timeout = (_noAirSince >= 0) && ((time - _noAirSince) > 30) && _allVehiclesPassed && (_closestConvoyDist > 60); // Only timeout if all vehicles have passed AND are far enough
		_hardTimeout = (time - _engageStartTime) > 180;

		if (_isConvoyDebugEnabled) then {
			// Enhanced debug - only show vehicles that are still causing delays
			private _vehiclesNotPassed = 0;
			private _pendingVehicles = [];
			private _aaGroupName = groupId (group (driver _aaVehicle));
			private _checkpointPassedCount = count _vehiclesPassed;
			private _vehiclesBehindAACount = count _vehiclesBehindAA;
			
			// Build list of pending vehicles in convoy order (only ones behind AA)
			{
				private _veh = _x;
				if (_veh in _vehiclesBehindAA) then {
					private _dist = _aaVehicle distance _veh;
					private _passedCheckpoint = (_veh in _vehiclesPassed);
					private _checkpointDist = _veh distance _checkpointPos;
					private _displayName = getText (configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName");
					
					// Only track vehicles that are still causing delays
					if (!_passedCheckpoint) then {
						_vehiclesNotPassed = _vehiclesNotPassed + 1;
						_pendingVehicles pushBack format ["%1 (approaching checkpoint: %2m)", _displayName, round _checkpointDist];
					} else {
						if (_dist < 60) then {
							_vehiclesNotPassed = _vehiclesNotPassed + 1;
							_pendingVehicles pushBack format ["%1 (too close: %2m)", _displayName, round _dist];
						};
						// Don't show vehicles that are properly spaced
					};
				};
			} forEach _originalConvoyArray;
			
			private _closestGroupName = if (!isNull _closestVehicle) then { groupId (group (driver _closestVehicle)) } else { "NULL" };
			
			// Only log if there are pending vehicles or every 10 seconds for status
			private _logThis = (_vehiclesNotPassed > 0) || ((round time) % 10 == 0);
			if (_logThis) then {
				if (_vehiclesNotPassed > 0) then {
					format [
						"[CONVOY_AIR] AA '%1' waiting for %2 vehicles: %3",
						_aaGroupName,
						_vehiclesNotPassed,
						_pendingVehicles joinString ", "
					] spawn OKS_fnc_LogDebug;
				} else {
					format [
						"[CONVOY_AIR] AA '%1': All vehicles clear - No Targets =%2 Timeout=%3 HardTimeout=%4",
						_aaGroupName,
						(count _currentAirTargets == 0),
						_timeout,
						_hardTimeout
					] spawn OKS_fnc_LogDebug;
				};
			};
		};
		_clearAndSpaced || _timeout || _hardTimeout
	};

	// Add minimum 15-second wait after all vehicles have passed before rejoining convoy
	if (_allVehiclesPassed && !_timeout && !_hardTimeout) then {
		private _minimumWaitTime = 15;
		private _allPassedTime = time;
		if (_isConvoyDebugEnabled) then {
			format ["[CONVOY_AIR] All vehicles passed - waiting minimum %1 seconds before rejoining convoy", _minimumWaitTime] spawn OKS_fnc_LogDebug;
		};
		sleep _minimumWaitTime;
		if (_isConvoyDebugEnabled) then {
			format ["[CONVOY_AIR] Minimum wait completed - proceeding to rejoin convoy"] spawn OKS_fnc_LogDebug;
		};
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
        format ["[CONVOY_AIR] AA vehicle %1 finished engagement and waypoints restored", _aaVehicle] spawn OKS_fnc_LogDebug;
    };

	// Check if reserve slots are available and valid before assigning
	private _leadVeh = _aaVehicle getVariable ["", objNull];
	private _reserveQueue = if (!isNull _leadVeh) then { _leadVeh getVariable ["OKS_Convoy_ReserveQueue", []] } else { [] };
	private _reserveAssigned = false;
	
	if ((count _reserveQueue) > 0) then {
		// Reserve slots exist, try to assign one
		_reserveAssigned = [_aaVehicle] call OKS_fnc_Convoy_AssignReserveWaypoint;
		if (_isConvoyDebugEnabled) then {
			format ["[CONVOY_AIR] Reserve waypoint assignment result for %1: %2", _aaVehicle, _reserveAssigned] spawn OKS_fnc_LogDebug;
		};
	} else {
		// No reserve slots available, AA will use original waypoints to rejoin behind convoy
		if (_isConvoyDebugEnabled) then {
			format ["[CONVOY_AIR] No reserve slots available for %1, using original waypoints to rejoin convoy", _aaVehicle] spawn OKS_fnc_LogDebug;
		};
	};

	if (!isNull _aaVehicle && {canMove _aaVehicle}) then {
		_aaVehicle setVariable ["OKS_Convoy_AAEngaging", false, true];
		if (_isConvoyDebugEnabled) then {
			format ["[CONVOY_AIR] AA vehicle %1 set to not engaging (waypoints restored)", _aaVehicle] spawn OKS_fnc_LogDebug;
		};
		
		// Reactivate waitUntilCombat logic for AA vehicle now that AA engagement is finished
		// This creates a self-patching loop: each AA completion re-spawns combat monitor
		private _aaGroup = group (driver _aaVehicle);
		if (_isConvoyDebugEnabled) then {
			private _aaGroupName = groupId _aaGroup;

			format ["[CONVOY_AIR] Reactivating waitUntilCombat for AA group '%1' vehicle %2", 
				_aaGroupName, _aaVehicle] spawn OKS_fnc_LogDebug;
		};
		
		// Re-spawn the waitUntilCombat logic for this AA vehicle
		// This is resilient because the air defense loop will re-spawn it each time AA completes
		[_aaVehicle, _aaGroup] spawn OKS_fnc_Convoy_WaitUntilCombat;
	};
	if (!isNull _aaVehicle && {canMove _aaVehicle}) then {
		_aaVehicle limitSpeed 999;
		_aaVehicle forceSpeed -1;
		if (_isConvoyDebugEnabled) then {
			format ["[CONVOY_AIR] forceSpeed -1 applied (AA post-engagement) to %1", _aaVehicle] spawn OKS_fnc_LogDebug;
		};
		// Reset group back to convoy travel posture so speed governor can take over
		_aaGroup setBehaviour "CARELESS";
		_aaGroup setCombatMode "BLUE";
		_aaGroup setSpeedMode "NORMAL";
		{
			// Keep AA dumb during rejoin phase per design: disable targeting subsystems
			_x disableAI "TARGET";
			_x disableAI "AUTOTARGET";
			_x disableAI "AUTOCOMBAT";
			// Ensure movement subsystems are enabled for rejoin
			_x enableAI "PATH";
			_x enableAI "MOVE";
			_x enableAI "FSM";
			_x doTarget objNull;
			_x doWatch objNull;
		} forEach (crew _aaVehicle);
		if (_isConvoyDebugEnabled) then {
			format ["[CONVOY_AIR] AA group set to CARELESS/BLUE and targeting disabled for rejoin", _aaVehicle] spawn OKS_fnc_LogDebug;
		};
		
		// Wait until AA vehicle is within max dispersion range of last convoy vehicle before reapplying speed logic
		private _leader = (_convoyVehicleArray select 0);
		private _convoyArray = _leader getVariable ["OKS_Convoy_VehicleArray", _convoyVehicleArray];
		if ((count _convoyArray) > 1) then {
			private _lastVehicleIdx = (count _convoyArray) - 2;
			private _leaderVehicle = _convoyArray select _lastVehicleIdx;
			private _aaVehicleDispersion = _aaVehicle getVariable ["OKS_Convoy_Dispersion", (_leaderVehicle getVariable ["OKS_Convoy_Dispersion", 25])];
			waitUntil {
				sleep 0.5;
				isNull _aaVehicle || !canMove _aaVehicle || (_aaVehicle distance _leaderVehicle) <= _aaVehicleDispersion
			};
		};
	};

	// Reinsert AA vehicle at tail
	private _leadVehicle = _convoyVehicleArray select 0;
	private _convoyArray = _leadVehicle getVariable ["OKS_Convoy_VehicleArray", _convoyVehicleArray];
	private _aaVehicleIdx = _convoyArray find _aaVehicle;
	if (_aaVehicleIdx >= 0) then { _convoyArray deleteAt _aaVehicleIdx; };
	_convoyArray pushBack _aaVehicle;
	{
		_x setVariable ["OKS_Convoy_VehicleArray", _convoyArray, true];
	} forEach _convoyVehicleArray;
	if (_isConvoyDebugEnabled) then {
		format ["[CONVOY_AIR] Appended %1 as tail vehicle. Convoy size now: %2", _aaVehicle, count _convoyArray] spawn OKS_fnc_LogDebug;
	};
	if ((count _convoyArray) > 1) then {
		// Determine the tail leader excluding the AA vehicle itself (works even if AA is still in array)
		private _tempConvoy = +_convoyArray;
		private _aaIdx = _tempConvoy find _aaVehicle;
		if (_aaIdx >= 0) then { _tempConvoy deleteAt _aaIdx; };
		private _leaderVehicle = if ((count _tempConvoy) > 0) then { _tempConvoy select ((count _tempConvoy) - 1) } else { objNull };
		
		if (_isConvoyDebugEnabled) then {
			// Get group names for better debugging
			private _aaGroupName = groupId (group (driver _aaVehicle));
			private _leaderGroupName = if (!isNull _leaderVehicle) then { groupId (group (driver _leaderVehicle)) } else { "NULL" };
			private _leaderDisplayName = if (!isNull _leaderVehicle) then { getText (configFile >> "CfgVehicles" >> (typeOf _leaderVehicle) >> "displayName") } else { "NULL" };
			format ["[CONVOY_AIR] Group assignment: AA group '%1' will follow leader group '%2' (%3)", 
				_aaGroupName, _leaderGroupName, _leaderDisplayName] spawn OKS_fnc_LogDebug;
			
			// Store debugging variables on the AA vehicle for easy inspection
			_aaVehicle setVariable ["DEBUG_AssignedLeader", _leaderVehicle, true];
			_aaVehicle setVariable ["DEBUG_ConvoyArray", _convoyArray, true];
			_aaVehicle setVariable ["DEBUG_TempConvoy", _tempConvoy, true];
			_aaVehicle setVariable ["DEBUG_AAGroupName", _aaGroupName, true];
			_aaVehicle setVariable ["DEBUG_LeaderGroupName", _leaderGroupName, true];
		};
		
		private _aaVehicleSpeedKph = _aaVehicle getVariable ["OKS_LimitSpeedBase", (_leaderVehicle getVariable ["OKS_LimitSpeedBase", 40])];
		private _aaVehicleDispersion = _aaVehicle getVariable ["OKS_Convoy_Dispersion", (_leaderVehicle getVariable ["OKS_Convoy_Dispersion", 25])];
		_aaVehicle setVariable ["OKS_LimitSpeedBase", _aaVehicleSpeedKph, true];
		_aaVehicle setVariable ["OKS_Convoy_Dispersion", _aaVehicleDispersion, true];
		// Immediately clamp speed to base to avoid surge past the convoy while governor spins up
		_aaVehicle limitSpeed (_aaVehicleSpeedKph max 10);
		_aaVehicle forceSpeed ((_aaVehicleSpeedKph max 10) / 3.6);
		_aaVehicle setVariable ["OKS_ForceSpeedActive", true, true];
		[_aaVehicle, _leaderVehicle, _aaVehicleDispersion] spawn OKS_fnc_Convoy_CheckAndAdjustSpeeds;
		if (_isConvoyDebugEnabled) then {
			format ["[CONVOY_AIR] Speed governor started for AA vehicle %1 following leader %2", _aaVehicle, _leaderVehicle] spawn OKS_fnc_LogDebug;
		};
		// Only unlock speed if merging/engaging (handled elsewhere)
	};

	// Refresh convoy leader pointer on all convoy vehicles
	{
		_x setVariable ["OKS_Convoy_FrontLeader", _leadVehicle, true];
	} forEach _convoyArray;
	// Loop will continue to wait for the next interception
};