
/*
	[convoy_3] call OKS_fnc_Convoy_SetupHerringbone;
	[convoy_3] execVM "fn_Convoy_SetupHerringbone.sqf";
	
	Parameters:
	- _ParkingMode: String enum controlling how vehicles park at the end waypoint
		"alternate"   - Vehicles alternate left/right sides of the road (herringbone)
		"successive"  - Both sides of each road segment are filled before moving to the next
		"convoystop"  - Vehicles stop on the road in convoy order (no lateral offset)
		"offroad"     - Vehicles form a single-file line from the end object using its direction, spaced by _Spacing
		Backwards compatible: false = "alternate", true = "successive" (deprecated)
	- _Spacing: Number - distance between vehicles in offroad mode (default: 35)
	
	Examples:
	[convoy_3, false, true, false, "alternate"] call OKS_fnc_Convoy_SetupHerringbone;
	[convoy_3, false, true, false, "successive"] call OKS_fnc_Convoy_SetupHerringbone;
	[convoy_3, false, true, false, "convoystop"] call OKS_fnc_Convoy_SetupHerringbone;
	[convoy_3, false, true, false, "offroad", 40] call OKS_fnc_Convoy_SetupHerringbone;
*/

params ["_EndWP", "_FirstWaypoint", ["_PreferLeft", true], ["_IsReserveSlot", false, [false]], ["_ParkingMode", "alternate", [false, ""]], ["_Spacing", 35, [0]]];

// --- Normalise legacy bool values to enum strings ---
if (_ParkingMode isEqualType false) then {
	private _legacyVal = _ParkingMode;
	_ParkingMode = if (_legacyVal) then { "successive" } else { "alternate" };
	private _warnMsg = format [
		"[CONVOY-HERRINGBONE WARNING] Boolean parking parameter (last parameter) is DEPRECATED. Change to string enum: '%1'. (false='alternate', true='successive', or use 'convoystop')",
		_ParkingMode
	];
	diag_log _warnMsg;
	systemChat _warnMsg;
};
_ParkingMode = toLower _ParkingMode;
if !(_ParkingMode in ["alternate", "successive", "convoystop", "offroad"]) then {
	_ParkingMode = "alternate";
};

private _cutterClass = "Land_ClutterCutter_large_F";

private _travelDirection = getDir _EndWP;
private _originDirection = _travelDirection - 180;

// --- Offroad: single-file line from end object using its direction, no road logic ---
if (_ParkingMode == "offroad") exitWith {
	private _endPos = getPosATL _EndWP;
	private _facingDir = _travelDirection;
	private _backDir = _facingDir - 180; // direction extending behind the end object

	// Track how many vehicles have been placed using a counter on the end object
	private _slotIndex = _EndWP getVariable ["OKS_Convoy_OffroadIndex", 0];

	// Lead vehicle parks at the end position itself
	private _slotPosition = if (_slotIndex == 0) then {
		[_endPos select 0, _endPos select 1, 0]
	} else {
		[
			(_endPos select 0) + (_slotIndex * _Spacing) * (sin _backDir),
			(_endPos select 1) + (_slotIndex * _Spacing) * (cos _backDir),
			0
		]
	};

	// Obstacle nudge: if blocked, try lateral offsets (left then right, up to 15m)
	if ([_slotPosition, 7] call OKS_fnc_Convoy_IsBlocked) then {
		private _leftDir = _facingDir - 90;
		private _rightDir = _facingDir + 90;
		private _nudged = false;
		{
			private _dist = _x;
			{
				private _nudgeDir = _x;
				private _candidate = [
					(_slotPosition select 0) + _dist * (sin _nudgeDir),
					(_slotPosition select 1) + _dist * (cos _nudgeDir),
					0
				];
				if (!([_candidate, 7] call OKS_fnc_Convoy_IsBlocked)) exitWith {
					_slotPosition = _candidate;
					_nudged = true;
				};
			} forEach [_leftDir, _rightDir];
			if (_nudged) exitWith {};
		} forEach [5, 10, 15];

		if (!_nudged && missionNamespace getVariable ["GOL_Convoy_Debug", false]) then {
			format ["[CONVOY-HERRINGBONE] %1: could not nudge slot %2 clear of obstacles", _ParkingMode, _slotIndex] spawn OKS_fnc_LogDebug;
		};
	};

	_EndWP setVariable ["OKS_Convoy_OffroadIndex", _slotIndex + 1, false];

	// Place visual indicators
	private _DebugObjects = missionNamespace getVariable ["GOL_Convoy_Markers_Debug", false];
	if (_DebugObjects) then {
		private _arrow = createVehicle ["Sign_Arrow_Direction_Yellow_F", _slotPosition, [], 0, "CAN_COLLIDE"];
		_arrow setPosATL _slotPosition;
		_arrow setDir _facingDir;
	};

	private _cutter = createVehicle [_cutterClass, _slotPosition, [], 0, "CAN_COLLIDE"];
	_cutter setPosATL _slotPosition;
	_cutter setVariable ["GOL_Convoy_Cutter", true, false];

	if (missionNamespace getVariable ["GOL_Convoy_Debug", false]) then {
		format ["[CONVOY-HERRINGBONE] offroad: slot %1 at %2 (spacing: %3m)", _slotIndex, _slotPosition, _Spacing] spawn OKS_fnc_LogDebug;
	};

	[_slotPosition, _PreferLeft]
};

private _nearestRoad = [getPosATL _EndWP, 100] call BIS_fnc_nearestRoad;

// If the end waypoint isn't near a road, avoid road commands (engine will spam "Road not found").
// Try a wider radius once, then fall back to using the end waypoint position directly.
if (isNull _nearestRoad) then {
	_nearestRoad = [getPosATL _EndWP, 500] call BIS_fnc_nearestRoad;
};

if (isNull _nearestRoad) exitWith {
	private _fallbackPos = getPosATL _EndWP;
	_fallbackPos set [2, 0];
	if (missionNamespace getVariable ["GOL_Convoy_Debug", false]) then {
		format ["[CONVOY-HERRINGBONE] No road near EndWP %1. Using fallback pos %2", _EndWP, _fallbackPos] spawn OKS_fnc_LogDebug;
	};
	[_fallbackPos, _PreferLeft]
};

if (_FirstWaypoint) exitWith {
	private _centerATL = getPos _nearestRoad;
	private _roadDirection = _travelDirection;
	private _roadInformation = getRoadInfo _nearestRoad;
	if ((count _roadInformation) > 4) then {
		private _roadDirectionFromInfo = _roadInformation select 4;
		if (_roadDirectionFromInfo isEqualType 0) then { _roadDirection = _roadDirectionFromInfo; };
	};

	[_nearestRoad, false] call OKS_fnc_Convoy_PlaceDebugObject;
	
	private _DebugObjects = missionNamespace getVariable ["GOL_Convoy_Markers_Debug", false];
	if (_DebugObjects) then {
		private _arrowLead = createVehicle ["Sign_Arrow_Direction_Green_F", _centerATL, [], 0, "CAN_COLLIDE"];
		_arrowLead setPosATL _centerATL;
		_arrowLead setDir _roadDirection;
	};

	private _cutterLead = createVehicle [_cutterClass, _centerATL, [], 0, "CAN_COLLIDE"];
	_cutterLead setPosATL _centerATL;
	_cutterLead setVariable ["GOL_Convoy_Cutter", true, false];
	_EndWP setVariable ["OKS_Convoy_LastRoad", _nearestRoad, false];
	
	// Store the lead vehicle's road for dual-side filling
	if (_ParkingMode == "successive") then {
		_EndWP setVariable ["OKS_Convoy_LeadRoad", _nearestRoad, false];
	};

	[_centerATL, _PreferLeft]
};

private _cutterRadius = 5;
private _minimumSpacing = missionNamespace getVariable ["GOL_Convoy_HerringboneSpacingMin", 35];
private _maximumRoadHops = 30;
private _lastUsedRoad = _EndWP getVariable ["OKS_Convoy_LastRoad", objNull];
private _currentRoad = if (!isNull _lastUsedRoad) then { _lastUsedRoad } else { _nearestRoad };
private _selectedRoad = objNull;

// Road selection logic differs by parking mode
if (_ParkingMode == "successive") then {
	diag_log format ["[DEBUG] DUAL-SIDE MODE: lastRoad=%1", _lastUsedRoad];
	// DUAL-SIDE FILLING: Check if last used road still has available sides first
	private _leadVehicleRoad = _EndWP getVariable ["OKS_Convoy_LeadRoad", objNull];
	
	// First check if we can reuse the last road (if it's not the lead road and has space)
	diag_log format ["[DEBUG] Reuse conditions: lastRoad=%1 leadRoad=%2 isNull=%3 isEqual=%4", 
		_lastUsedRoad, _leadVehicleRoad, isNull _lastUsedRoad, (_lastUsedRoad isEqualTo _leadVehicleRoad)];
	if (!isNull _lastUsedRoad && !(_lastUsedRoad isEqualTo _leadVehicleRoad)) then {
		private _roadSideInfo = _EndWP getVariable [format ["OKS_Road_Side_%1", _lastUsedRoad], []];
		private _leftUsed = if (count _roadSideInfo > 0) then { _roadSideInfo select 0 } else { false };
		private _rightUsed = if (count _roadSideInfo > 1) then { _roadSideInfo select 1 } else { false };
		private _leftBlocked = if (count _roadSideInfo > 2) then { _roadSideInfo select 2 } else { false };
		private _rightBlocked = if (count _roadSideInfo > 3) then { _roadSideInfo select 3 } else { false };
		
		private _leftOccupied = _leftUsed || _leftBlocked;
		private _rightOccupied = _rightUsed || _rightBlocked;
		private _roadHasSpace = !(_leftOccupied && _rightOccupied);
		
		private _cuttersNearLast = nearestObjects [_lastUsedRoad, [_cutterClass], _cutterRadius];
		private _isLastOccupied = !(_cuttersNearLast isEqualTo []);
		
		// For dual-side filling, we want to allow reuse if there's space on the other side
		// So we skip the spacing check - the road center spacing should be sufficient
		private _isLastTooClose = false; // Allow reuse for dual-side filling
		
		diag_log format ["[DEBUG] Reuse check: occ:%1 close:%2 space:%3 L-used:%4 R-used:%5", _isLastOccupied, _isLastTooClose, _roadHasSpace, _leftUsed, _rightUsed];
		if (!_isLastOccupied && !_isLastTooClose && _roadHasSpace) then {
			_selectedRoad = _lastUsedRoad; // Reuse last road for second vehicle
			diag_log format ["[DEBUG] REUSING last road %1 (L-occ:%2 R-occ:%3)", _lastUsedRoad, _leftOccupied, _rightOccupied];
		};
	};
	
	// If we couldn't reuse the last road, find next available road
	if (isNull _selectedRoad) then {
		for "_roadHopIndex" from 1 to _maximumRoadHops do {
			private _candidateRoad = [_currentRoad, _originDirection] call OKS_fnc_Convoy_NearestRoadTowardsOrigin;
			if (isNull _candidateRoad) exitWith {
				"[ConvoyHerringbone] No forward road found." spawn OKS_fnc_LogDebug;
			};

			private _directionToCandidate = (getPosWorld _currentRoad) getDir (getPosWorld _candidateRoad);
			private _directionDifference = abs ((_directionToCandidate - _originDirection + 540) % 360 - 180);
			if (_directionDifference > 100) exitWith {};

			private _isLeadRoad = (!isNull _leadVehicleRoad && {_candidateRoad isEqualTo _leadVehicleRoad});
			if (_isLeadRoad) then {
				_currentRoad = _candidateRoad;
			} else {
				// Check if road has available sides for dual-side filling
				private _roadSideInfo = _EndWP getVariable [format ["OKS_Road_Side_%1", _candidateRoad], []];
				private _leftUsed = if (count _roadSideInfo > 0) then { _roadSideInfo select 0 } else { false };
				private _rightUsed = if (count _roadSideInfo > 1) then { _roadSideInfo select 1 } else { false };
				private _leftBlocked = if (count _roadSideInfo > 2) then { _roadSideInfo select 2 } else { false };
				private _rightBlocked = if (count _roadSideInfo > 3) then { _roadSideInfo select 3 } else { false };
				
				private _leftOccupied = _leftUsed || _leftBlocked;
				private _rightOccupied = _rightUsed || _rightBlocked;
				private _roadHasSpace = !(_leftOccupied && _rightOccupied);
				
				private _cuttersNearCandidate = nearestObjects [_candidateRoad, [_cutterClass], _cutterRadius];
				private _isCandidateOccupied = !(_cuttersNearCandidate isEqualTo []);
				private _cuttersNearCandidateSpacing = nearestObjects [_candidateRoad, [_cutterClass], _minimumSpacing];
				private _isCandidateTooClose = !(_cuttersNearCandidateSpacing isEqualTo []);

				if (!_isCandidateOccupied && !_isCandidateTooClose && _roadHasSpace) exitWith {
					_selectedRoad = _candidateRoad;
					format ["[ConvoyHerringbone] FOUND new road %1 (L-occ:%2 R-occ:%3)", _candidateRoad, _leftOccupied, _rightOccupied] spawn OKS_fnc_LogDebug;
				};
				_currentRoad = _candidateRoad;
			};
		};
	};
} else {
	diag_log "[DEBUG] ALTERNATING MODE";
	// TRADITIONAL ALTERNATING: Use original logic
	for "_roadHopIndex" from 1 to _maximumRoadHops do {
		private _candidateRoad = [_currentRoad, _originDirection] call OKS_fnc_Convoy_NearestRoadTowardsOrigin;
		if (isNull _candidateRoad) exitWith {
			systemChat "No forward road found.";
		};

		private _directionToCandidate = (getPosWorld _currentRoad) getDir (getPosWorld _candidateRoad);
		private _directionDifference = abs ((_directionToCandidate - _originDirection + 540) % 360 - 180);
		if (_directionDifference > 100) exitWith {};

		private _cuttersNearCandidate = nearestObjects [_candidateRoad, [_cutterClass], _cutterRadius];
		private _isCandidateOccupied = !(_cuttersNearCandidate isEqualTo []);
		private _cuttersNearCandidateSpacing = nearestObjects [_candidateRoad, [_cutterClass], _minimumSpacing];
		private _isCandidateTooClose = !(_cuttersNearCandidateSpacing isEqualTo []);

		if (!_isCandidateOccupied && !_isCandidateTooClose) exitWith {
			_selectedRoad = _candidateRoad;
		};
	_currentRoad = _candidateRoad;
	};
};

if (isNull _selectedRoad) exitWith {
	"[ConvoyHerringbone] No suitable road found after 30 hops." spawn OKS_fnc_LogDebug;
	[[0, 0, 0], _PreferLeft]
};

_EndWP setVariable ["OKS_Convoy_LastRoad", _selectedRoad, false];

private _roadPosition = getPosATL _selectedRoad;
private _roadDirection = _travelDirection;
private _roadInformation = getRoadInfo _selectedRoad;
if ((count _roadInformation) > 4) then {
	private _roadDirectionFromInfo = _roadInformation select 4;
	if (_roadDirectionFromInfo isEqualType 0) then { _roadDirection = _roadDirectionFromInfo; };
};

[_selectedRoad, false] call OKS_fnc_Convoy_PlaceDebugObject;

// --- Convoystop: park on road center, no lateral offset ---
if (_ParkingMode == "convoystop") exitWith {
	private _slotPosition = getPosATL _selectedRoad;
	_slotPosition set [2, 0];

	private _DebugObjects = missionNamespace getVariable ["GOL_Convoy_Markers_Debug", false];
	if (_DebugObjects) then {
		private _arrow = createVehicle ["Sign_Arrow_Direction_Green_F", _slotPosition, [], 0, "CAN_COLLIDE"];
		_arrow setPosATL _slotPosition;
		_arrow setDir _roadDirection;
	};

	private _cutter = createVehicle [_cutterClass, _slotPosition, [], 0, "CAN_COLLIDE"];
	_cutter setPosATL _slotPosition;
	_cutter setVariable ["GOL_Convoy_Cutter", true, false];

	if (missionNamespace getVariable ["GOL_Convoy_Debug", false]) then {
		format ["[CONVOY-HERRINGBONE] convoystop: road %1 at %2", _selectedRoad, _slotPosition] spawn OKS_fnc_LogDebug;
	};

	[_slotPosition, _PreferLeft]
};

// Determine which side to use for dual-side filling
private _actualSidePreference = _PreferLeft;
if (_ParkingMode == "successive") then {
	// For dual-side filling, track which sides have been used on this specific road
	private _roadSideInfo = _EndWP getVariable [format ["OKS_Road_Side_%1", _selectedRoad], []];
	
	// _roadSideInfo format: [leftUsed, rightUsed, leftBlocked, rightBlocked]
	private _leftUsed = if (count _roadSideInfo > 0) then { _roadSideInfo select 0 } else { false };
	private _rightUsed = if (count _roadSideInfo > 1) then { _roadSideInfo select 1 } else { false };
	private _leftBlocked = if (count _roadSideInfo > 2) then { _roadSideInfo select 2 } else { false };
	private _rightBlocked = if (count _roadSideInfo > 3) then { _roadSideInfo select 3 } else { false };
	
	// Check for obstacles if we haven't already determined the sides are blocked
	if (!_leftBlocked || !_rightBlocked) then {
		// Test left side for obstacles
		if (!_leftBlocked) then {
			private _leftTestPos = [getPos _selectedRoad, _roadDirection, true] call OKS_fnc_Convoy_MakeSlot;
			private _leftSlotPos = _leftTestPos select 0;
			private _leftIsBlocked = [_leftSlotPos] call OKS_fnc_Convoy_IsBlocked;
			if (_leftIsBlocked) then {
				_leftBlocked = true;
			};
		};
		
		// Test right side for obstacles  
		if (!_rightBlocked) then {
			private _rightTestPos = [getPos _selectedRoad, _roadDirection, false] call OKS_fnc_Convoy_MakeSlot;
			private _rightSlotPos = _rightTestPos select 0;
			private _rightIsBlocked = [_rightSlotPos] call OKS_fnc_Convoy_IsBlocked;
			if (_rightIsBlocked) then {
				_rightBlocked = true;
			};
		};
	};
	
	// Combine usage and blocking - a side is "occupied" if used OR blocked
	private _leftOccupied = _leftUsed || _leftBlocked;
	private _rightOccupied = _rightUsed || _rightBlocked;
	
	// Decide which side to place this vehicle - prioritize filling both sides
	diag_log format ["[DEBUG] Side logic: L-occ:%1 R-occ:%2 ParkingMode:%3", _leftOccupied, _rightOccupied, _ParkingMode];
	if (!_leftOccupied && !_rightOccupied) then {
		// Neither side occupied - start with left (true)
		_actualSidePreference = true;
		diag_log "[DEBUG] → Choosing LEFT (neither occupied)";
	} else {
		if (_leftOccupied && !_rightOccupied) then {
			// Left occupied, right free - use right to fill both sides
			_actualSidePreference = false;
			diag_log "[DEBUG] → Choosing RIGHT (left occupied, right free)";
		} else {
			if (!_leftOccupied && _rightOccupied) then {
				// Right occupied, left free - use left
				_actualSidePreference = true;
				diag_log "[DEBUG] → Choosing LEFT (right occupied, left free)";
			} else {
				// Both sides occupied - this road is full (shouldn't happen with proper road selection)
				_actualSidePreference = _PreferLeft; // fallback
				diag_log "[DEBUG] → FALLBACK (both occupied)";
			};
		};
	};
	
	// Update the tracking for this road (mark used side, preserve blocking info)
	private _newLeftUsed = _leftUsed;
	private _newRightUsed = _rightUsed;
	if (_actualSidePreference) then {
		_newLeftUsed = true;
	} else {
		_newRightUsed = true;
	};
	_EndWP setVariable [format ["OKS_Road_Side_%1", _selectedRoad], [_newLeftUsed, _newRightUsed, _leftBlocked, _rightBlocked], false];
	
	// DEBUG: Show what's happening
	diag_log format ["[DEBUG] Road %1: L-used:%2 R-used:%3 L-blocked:%4 R-blocked:%5 → Placed on %6", 
		_selectedRoad, _newLeftUsed, _newRightUsed, _leftBlocked, _rightBlocked, 
		if (_actualSidePreference) then {"LEFT"} else {"RIGHT"}];
};

// Use positioning logic with enhanced dispersion for dual-side filling
private _slotPositionArray = [getPos _selectedRoad, _roadDirection, _actualSidePreference] call OKS_fnc_Convoy_MakeSlot;
private _slotPosition = _slotPositionArray select 0;

// Add extra dispersion for successive filling to prevent stacking
if (_ParkingMode == "successive") then {
	private _extraDispersion = 10; // Additional 10 meters dispersion
	private _sideMultiplier = if (_actualSidePreference) then { -1 } else { 1 }; // Left = -1, Right = +1
	private _sideDirection = _roadDirection + (_sideMultiplier * 90); // Perpendicular to road
	
	// Move position further away from road center
	private _dispersedPosition = [
		(_slotPosition select 0) + _extraDispersion * (sin _sideDirection),
		(_slotPosition select 1) + _extraDispersion * (cos _sideDirection),
		(_slotPosition select 2)
	];
	
	// Check if the dispersed position is blocked
	private _isDispersedBlocked = [_dispersedPosition] call OKS_fnc_Convoy_IsBlocked;
	
	if (!_isDispersedBlocked) then {
		_slotPosition = _dispersedPosition;
		diag_log format ["[DEBUG] Applied extra dispersion: moved %1m further from road", _extraDispersion];
	} else {
		diag_log "[DEBUG] Extra dispersion blocked by terrain - using standard position";
	};
};

// Place visual indicators
private _DebugObjects = missionNamespace getVariable ["GOL_Convoy_Markers_Debug", false];
if (_DebugObjects) then {
	private _arrow = createVehicle ["Sign_Arrow_Direction_Blue_F", _slotPosition, [], 0, "CAN_COLLIDE"];
	_arrow setPosATL _slotPosition;
	_arrow setDir _roadDirection;
};

private _cutter = createVehicle [_cutterClass, _slotPosition, [], 0, "CAN_COLLIDE"];
_cutter setPosATL _slotPosition;
_cutter setVariable ["GOL_Convoy_Cutter", true, false];

[_slotPosition, _actualSidePreference]


