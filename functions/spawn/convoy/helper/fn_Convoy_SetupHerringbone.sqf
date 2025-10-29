
/*
	[convoy_3] call OKS_fnc_Convoy_SetupHerringbone;
	[convoy_3] execVM "fn_Convoy_SetupHerringbone.sqf";
	
	New Parameters:
	- _FillBothSides: When true, fills both sides of the road before moving to next road segment
	
	Examples:
	[convoy_3, false, true, false, true] call OKS_fnc_Convoy_SetupHerringbone; // Fill both sides
	[convoy_3, false, true, false, false] call OKS_fnc_Convoy_SetupHerringbone; // Alternate sides (default)
*/

params ["_EndWP", "_FirstWaypoint", ["_PreferLeft", true], ["_IsReserveSlot", false, [false]], ["_FillBothSides", false, [false]]];
private _cutterClass = "Land_ClutterCutter_large_F";

private _travelDirection = getDir _EndWP;
private _originDirection = _travelDirection - 180;
private _nearestRoad = [getPosATL _EndWP, 100] call BIS_fnc_nearestRoad;

if (_FirstWaypoint) exitWith {
	private _centerATL = getPos _nearestRoad;
	private _roadDirection = _travelDirection;
	private _roadInformation = getRoadInfo _nearestRoad;
	if ((count _roadInformation) > 4) then {
		private _roadDirectionFromInfo = _roadInformation select 4;
		if (_roadDirectionFromInfo isEqualType 0) then { _roadDirection = _roadDirectionFromInfo; };
	};

	[_nearestRoad, false] call OKS_fnc_Convoy_PlaceDebugObject;

	private _arrowLead = createVehicle ["Sign_Arrow_Direction_Green_F", _centerATL, [], 0, "CAN_COLLIDE"];
	_arrowLead setPosATL _centerATL;
	_arrowLead setDir _roadDirection;

	private _cutterLead = createVehicle [_cutterClass, _centerATL, [], 0, "CAN_COLLIDE"];
	_cutterLead setPosATL _centerATL;
	_cutterLead setVariable ["GOL_Convoy_Cutter", true, false];
	_EndWP setVariable ["OKS_Convoy_LastRoad", _nearestRoad, false];
	
	// Store the lead vehicle's road for dual-side filling
	if (_FillBothSides) then {
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

// Road selection logic differs for dual-side vs alternating mode
if (_FillBothSides) then {
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
				systemChat "No forward road found.";
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
					systemChat format ["[DEBUG] FOUND new road %1 (L-occ:%2 R-occ:%3)", _candidateRoad, _leftOccupied, _rightOccupied];
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
	systemChat "No suitable road found after 30 hops.";
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

// Determine which side to use for dual-side filling
private _actualSidePreference = _PreferLeft;
if (_FillBothSides) then {
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
	diag_log format ["[DEBUG] Side logic: L-occ:%1 R-occ:%2 FillBoth:%3", _leftOccupied, _rightOccupied, _FillBothSides];
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

// Add extra dispersion for dual-side filling to prevent stacking
if (_FillBothSides) then {
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
private _arrow = createVehicle ["Sign_Arrow_Direction_Blue_F", _slotPosition, [], 0, "CAN_COLLIDE"];
_arrow setPosATL _slotPosition;
_arrow setDir _roadDirection;

private _cutter = createVehicle [_cutterClass, _slotPosition, [], 0, "CAN_COLLIDE"];
_cutter setPosATL _slotPosition;
_cutter setVariable ["GOL_Convoy_Cutter", true, false];

[_slotPosition, _actualSidePreference]


