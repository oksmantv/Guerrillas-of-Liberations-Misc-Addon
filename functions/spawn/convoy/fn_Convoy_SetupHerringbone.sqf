
/*
	[convoy_3] call OKS_fnc_Convoy_WaitUntilCasualties;
	[convoy_3] execVM "fn_Convoy_SetupHerringbone.sqf";
*/

params ["_EndWP","_FirstWaypoint", ["_PreferLeft", true]];
private _ValidRoad = objNull;
private _cutterClass = "Land_ClutterCutter_large_F";
private _PlaceDebugObject = {
	Params ["_Road"];
	_DebugObjects = true;

	if(_DebugObjects) then {
		_Arrow = createVehicle ["Sign_Arrow_F", [getPos _Road select 0, getPos _Road select 1, 1], [], 0, "CAN_COLLIDE"];
	};
};

_TravelDirection = getDir _EndWP;
_OriginDirection = _TravelDirection - 180;
private _nearestRoad = [getPosATL _EndWP, 15] call BIS_fnc_nearestRoad;
// Helper to build a slot 15m to side at ±45°, with obstacle flip (ATL positions)
private _makeSlot = {
	params ["_centerATL", "_roadDir", "_preferLeft"];

	systemChat str [_centerATL, _roadDir, _preferLeft];
	// left=-1, right=+1
	private _sideSignPref = 1;
	if (_preferLeft) then { _sideSignPref = -1 };
	systemChat str _sideSignPref;
	private _sideDir = _roadDir + (_sideSignPref * 90);
	private _posPrefATL = [
		(_centerATL select 0) + 15 * (sin _sideDir),
		(_centerATL select 1) + 15 * (cos _sideDir),
		(_centerATL select 2)
	];
	private _dirPref = _roadDir + (_sideSignPref * 45);

	// Obstacle check: terrain + objects within 7m
	private _isBlocked = {
		params ["_posATL"];
		private _terr = nearestTerrainObjects [_posATL, ["TREE","BUSH","ROCK","WALL","HOUSE","BUILDING"], 7, false, true];
		private _objs = nearestObjects [_posATL, ["House","Wall","Building","Car","Tank","StaticWeapon","Thing"], 7];
		(count _terr + count _objs) > 0
	};

	private _useLeft = _preferLeft;
	private _slotPosATL = _posPrefATL;
	private _slotDir = _dirPref;

	if ([_posPrefATL] call _isBlocked) then {
		private _sideSignAlt = -_sideSignPref;
		private _sideDirAlt = _roadDir + (_sideSignAlt * 90);
		private _posAltATL = [
			(_centerATL select 0) + 15 * (sin _sideDirAlt),
			(_centerATL select 1) + 15 * (cos _sideDirAlt),
			(_centerATL select 2)
		];
		private _dirAlt = _roadDir + (_sideSignAlt * 45);
		if (!([_posAltATL] call _isBlocked)) then {
			_useLeft = !_preferLeft;
			_slotPosATL = _posAltATL;
			_slotDir = _dirAlt;
		};
	};

	[_slotPosATL, _slotDir, _useLeft]
};

if(_FirstWaypoint) exitWith {
	private _centerATL = getPos _nearestRoad;
	private _roadDir = _TravelDirection;
	private _ri = getRoadInfo _nearestRoad;
	if ((count _ri) > 4) then {
		private _d = _ri select 4;
		if (_d isEqualType 0) then { _roadDir = _d; };
	};
	private _slot0 = [_centerATL, _roadDir, _PreferLeft] call _makeSlot;
	private _posATL0 = _slot0 select 0;
	private _dir0 = _slot0 select 1;
	[_nearestRoad] call _PlaceDebugObject;
	private _arrow0 = createVehicle ["Sign_Arrow_F", _posATL0, [], 0, "CAN_COLLIDE"];
	_arrow0 setPosATL _posATL0;
	_arrow0 setDir _dir0;
	[_posATL0, (_slot0 select 2)]
};

private _NearestRoadTowardsOrigin = {

	// Pick connected road in the direction of _OriginDirection
	params ["_nearestRoad"];

	private _posNearest = getPosWorld _nearestRoad;
	private _connectedRoads = (roadsConnectedTo _nearestRoad);
	private _DebugObjects = true;
	private _bestRoad = objNull;
	private _bestDiff = 1e9;

	{
		private _dirTo = _posNearest getDir (getPosWorld _x);
		private _diff = abs ((_dirTo - _OriginDirection + 540) % 360 - 180);

		if (_diff < _bestDiff) then {
			_bestDiff = _diff;
			_bestRoad = _x;
		};
	} forEach _connectedRoads;

	private _forwardRoad = _bestRoad;
	private _forwardDir = if (!isNull _forwardRoad) then { _posNearest getDir (getPosWorld _forwardRoad) } else { _OriginDirection };

	_forwardRoad;
};

private _cutterRadius = 5;
private _spacingMin = 25;
private _maxHops = 30;

private _currentRoad = _nearestRoad;
private _selectedRoad = objNull;


for "_i" from 1 to _maxHops do {
	private _candidate = [_currentRoad] call _NearestRoadTowardsOrigin;
	if (isNull _candidate) exitWith {
		systemChat format ["No forward road found."];
	};

	private _dirTo = (getPosWorld _currentRoad) getDir (getPosWorld _candidate);
	private _diff = abs ((_dirTo - _OriginDirection + 540) % 360 - 180);
	if (_diff > 100) exitWith {};

	private _cutters5 = nearestObjects [_candidate, [_cutterClass], _cutterRadius];
	private _occupied = !(_cutters5 isEqualTo []);
	private _cutters25 = nearestObjects [_candidate, [_cutterClass], _spacingMin];
	private _tooClose = !(_cutters25 isEqualTo []);

	if (!_occupied && !_tooClose) exitWith {
		_selectedRoad = _candidate;
	};

	_currentRoad = _candidate;
};

if (isNull _selectedRoad) then {
	[getPos _nearestRoad, _PreferLeft]
} else {
	private _posATL_cutter = getPos _selectedRoad;
	private _cutter = createVehicle [_cutterClass, _posATL_cutter, [], 0, "CAN_COLLIDE"];
	_cutter setPosATL _posATL_cutter;
	_cutter setVariable ["GOL_Convoy_Cutter", true, false];

	private _confirm5 = nearestObjects [_selectedRoad, [_cutterClass], _cutterRadius];
	private _confirm25 = nearestObjects [_selectedRoad, [_cutterClass], _spacingMin];
	[_selectedRoad] call _PlaceDebugObject;

	private _stopDir = (getPosWorld _currentRoad) getDir (getPosWorld _selectedRoad);
	private _centerATL = getPos _selectedRoad;
	private _slot = [_centerATL, _stopDir, _PreferLeft] call _makeSlot;
	_slot params ["_slotPosATL", "_slotDir", "_isLeft"];

	private _arrow = createVehicle ["Sign_Arrow_F", _slotPosATL, [], 0, "CAN_COLLIDE"];
	_arrow setPosATL _slotPosATL;
	_arrow setDir _slotDir;
	[_slotPosATL, _isLeft]
};


