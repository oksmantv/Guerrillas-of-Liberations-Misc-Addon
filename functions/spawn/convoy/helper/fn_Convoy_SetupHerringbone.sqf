
/*
	[convoy_3] call OKS_fnc_Convoy_SetupHerringbone;
	[convoy_3] execVM "fn_Convoy_SetupHerringbone.sqf";
*/

params ["_EndWP", "_FirstWaypoint", ["_PreferLeft", true], ["_IsReserveSlot", false, [false]]];
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

	[_centerATL, _PreferLeft]
};

private _cutterRadius = 5;
private _minimumSpacing = missionNamespace getVariable ["GOL_Convoy_HerringboneSpacingMin", 35];
private _maximumRoadHops = 30;
private _lastUsedRoad = _EndWP getVariable ["OKS_Convoy_LastRoad", objNull];
private _currentRoad = if (!isNull _lastUsedRoad) then { _lastUsedRoad } else { _nearestRoad };
private _selectedRoad = objNull;

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


if (isNull _selectedRoad) then {
	// Fallback: use nearest road and slot logic for consistent return
	private _fallbackSlot = [getPos _nearestRoad, _travelDirection, _PreferLeft] call OKS_fnc_Convoy_MakeSlot;
	_fallbackSlot params ["_slotPosATL", "_slotDirection", "_isLeft"];
	[_slotPosATL, _isLeft, _IsReserveSlot]
} else {
	private _cutterPositionATL = getPos _selectedRoad;
	private _cutterObject = createVehicle [_cutterClass, _cutterPositionATL, [], 0, "CAN_COLLIDE"];
	_cutterObject setPosATL _cutterPositionATL;
	_cutterObject setVariable ["GOL_Convoy_Cutter", true, false];

	private _cuttersNearSelectedRoad = nearestObjects [_selectedRoad, [_cutterClass], _cutterRadius];
	private _cuttersNearSelectedRoadSpacing = nearestObjects [_selectedRoad, [_cutterClass], _minimumSpacing];
	private _leadVehicle = _selectedRoad getVariable ["OKS_Convoy_LeadVehicle", objNull];
	if (_IsReserveSlot) then {
		[_selectedRoad, true] call OKS_fnc_Convoy_PlaceDebugObject;
	} else {
		[_selectedRoad, false] call OKS_fnc_Convoy_PlaceDebugObject;
	};

	private _stopDirection = (getPosWorld _currentRoad) getDir (getPosWorld _selectedRoad);
	private _centerATL = getPos _selectedRoad;
	private _slot = [_centerATL, _stopDirection, _PreferLeft] call OKS_fnc_Convoy_MakeSlot;
	_slot params ["_slotPosATL", "_slotDirection", "_isLeft"];

	private _debugMarkersEnabled = missionNamespace getVariable ["GOL_Convoy_Markers_Debug", false];
	if (_debugMarkersEnabled) then {
		private _arrowSlot = createVehicle ["Sign_Arrow_Direction_F", _slotPosATL, [], 0, "CAN_COLLIDE"];
		_arrowSlot setPosATL _slotPosATL;
		_arrowSlot setDir _slotDirection;
	};

	_EndWP setVariable ["OKS_Convoy_LastRoad", _selectedRoad, false];
	[_slotPosATL, _isLeft, _IsReserveSlot]
};


