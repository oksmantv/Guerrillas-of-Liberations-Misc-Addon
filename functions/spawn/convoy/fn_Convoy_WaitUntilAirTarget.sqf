private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug",false];

// Input: array of convoy vehicles (objects)
params ["_VehicleArray"];
if (_VehicleArray isEqualTo [] || isNull (_VehicleArray select 0)) exitWith {};
if (_ConvoyDebug) then {
	format [
		"[CONVOY_AIR] Air handler started. Vehicles: %1",
		count _VehicleArray
	] spawn OKS_fnc_LogDebug;
};

// Helper: detect enemy air within radius of any convoy vehicle
private _isEnemy = {
	params ["_sideA", "_sideB"];
	// Arma: getFriend < 0.6 typically considered enemies
	(_sideA getFriend _sideB) < 0.6
};

// Build set of convoy crew groups from vehicle drivers
private _ConvoyGroups = [];
{
	private _Group = group driver _x;
	if (!isNull _Group) then { _ConvoyGroups pushBackUnique _Group; };
} forEach _VehicleArray;

private _ConvoySide = side (group driver (_VehicleArray select 0));

// Air targets we have explicitly ignored after destruction/disable
private _IgnoredAir = [];

// Tunables (override via missionNamespace if desired)
private _PullOffMaxSlope = missionNamespace getVariable ["GOL_Convoy_PullOffMaxSlopeDeg", 15];
private _PullOffMinRoadDist = missionNamespace getVariable ["GOL_Convoy_PullOffMinRoadDist", 20];
private _MergeGapMin = missionNamespace getVariable ["GOL_Convoy_MergeGapMin", 80];
private _MergeGapTimeout = missionNamespace getVariable ["GOL_Convoy_MergeGapTimeout", 30];
private _SpeedRampStep = missionNamespace getVariable ["GOL_Convoy_SpeedRampStepKph", 10];
private _SpeedRampInterval = missionNamespace getVariable ["GOL_Convoy_SpeedRampInterval", 1];

// Use target knowledge: any known enemy air target within 500m
private _findEnemyAir = {
	private _AirVehicles = [];
	{
		private _Leader = leader _x;
		if (!isNull _Leader) then {
			private _Targets = _Leader targets [true, 500, [sideEnemy]];
			{
				if (alive _x) then {
					private _Veh = vehicle _x;
					if (!isNull _Veh && (_Veh isKindOf "AIR") && !(_Veh isKindOf "ParachuteBase") && (canMove _Veh)) then {
						_AirVehicles pushBackUnique _Veh;
					};
				};
			} forEach _Targets;
		};
	} forEach _ConvoyGroups;

	// Fallback: proximity-based detection if knowledge is empty (e.g., CARELESS/BLUE)
	{
		private _Near = _x nearEntities ["Air", 500];
		{
			if (alive _x && (canMove _x) && !(_x isKindOf "ParachuteBase")) then {
				private _Pilot = driver _x;
				if (isNull _Pilot && (count crew _x > 0)) then { _Pilot = (crew _x) select 0; };
				if (!isNull _Pilot) then {
					private _AirSide = side _Pilot;
					if ([_ConvoySide, _AirSide] call _isEnemy) then {
						_AirVehicles pushBackUnique _x;
					};
				};
			};
		} forEach _Near;
	} forEach _VehicleArray;
	// Exclude air targets we have marked to ignore
	_AirVehicles = _AirVehicles - _IgnoredAir;
	_AirVehicles
};

while { true } do {
	// If convoy is gone, stop the handler
	if ((({ !isNull _x && alive _x } count _VehicleArray) == 0)) exitWith {};

	// Refresh convoy groups (crew can change between engagements)
	_ConvoyGroups = [];
	{
		private _Group = group driver _x;
		if (!isNull _Group) then { _ConvoyGroups pushBackUnique _Group; };
	} forEach _VehicleArray;

	// Wait for an enemy air target within 500m of any convoy vehicle
	waitUntil {
		sleep 0.5;
		(count (call _findEnemyAir)) > 0
	};

private _airInitial = call _findEnemyAir;
private _airPrev = +_airInitial;
if (_ConvoyDebug) then {
	private _nearestAirDist = 1e9;
	private _nearestAir = objNull;
	{
		private _d = (_VehicleArray select 0) distance _x;
		if (_d < _nearestAirDist) then { _nearestAirDist = _d; _nearestAir = _x; };
	} forEach _airInitial;
	format [
		"[CONVOY_AIR] Detected %1 hostile air targets. Nearest: %2 at %3m",
		count _airInitial,
		_nearestAir,
		round _nearestAirDist
	] spawn OKS_fnc_LogDebug;
};

// Select a suitable AA vehicle using a scoring heuristic
private _selectAAVehicle = {
	private _BestVeh = objNull;
	private _BestScore = -1e9;
	private _DebugScores = [];
	{
	if (isNull _x || !alive _x || !canMove _x) then { continue };
		private _Class = toLower (typeOf _x);
		private _Cfg = configFile >> "CfgVehicles" >> typeOf _x;
		private _Weapons = getArray (_Cfg >> "weapons");
		private _HasGunner = (count (fullCrew [_x, "gunner", true])) > 0;
		private _HasRadar = (getNumber (_Cfg >> "radarType")) > 0;
		// Sensor component-based radar check: ActiveRadarSensorComponent > AirTarget exists
		private _RadarComp = _Cfg >> "Components" >> "SensorsManagerComponent" >> "Components" >> "ActiveRadarSensorComponent";
		private _HasActiveRadarComponent = isClass _RadarComp;
		private _HasAirTargetClass = if (_HasActiveRadarComponent) then { isClass (_RadarComp >> "AirTarget") } else { false };
		private _IsTank = _x isKindOf "Tank_F";
		private _IsKnownAA = (
			(_x isKindOf "APC_Tracked_01_AA_F") ||
			(_x isKindOf "APC_Tracked_02_AA_F") ||
			{(_Class find "aa") >= 0} ||
			{(_Class find "tigris") >= 0} ||
			{(_Class find "cheetah") >= 0} ||
			{(_Class find "zsu") >= 0} ||
			{(_Class find "zu23") >= 0} ||
			{(_Class find "shilka") >= 0}
		);
		// Weapon heuristics: missiles/aa/autocannon strongly favored
		private _HasAAMissiles = false;
		private _HasAAAutoCannon = false;
		{
			private _w = toLower _x;
			if (((_w find "missile") >= 0) || ((_w find "aa") >= 0)) then { _HasAAMissiles = true; };
			if (((_w find "autocannon") >= 0) || ((_w find "35mm") >= 0) || ((_w find "gatling") >= 0)) then { _HasAAAutoCannon = true; };
		} forEach _Weapons;

		// Ammo-aware check: ensure there is some AA-relevant ammo left
		private _AmmoAAAny = false;
		private _magsFull = magazinesAmmoFull _x;
		{
			private _m = _x;
			private _magClass = "";
			private _ammoLeft = 0;
			if (_m isEqualType []) then {
				if ((count _m) > 0) then { _magClass = toLower (_m select 0); };
				if ((count _m) > 1) then { _ammoLeft = _m select 1; };
			};
			if ((_ammoLeft > 0) && (
				(_magClass find "titan") >= 0 ||
				(_magClass find "aa") >= 0 ||
				(_magClass find "autocannon") >= 0 ||
				(_magClass find "35mm") >= 0 ||
				(_magClass find "fla") >= 0 ||
				(_magClass find "zeus") >= 0
			)) exitWith { _AmmoAAAny = true; };
		} forEach _magsFull;

		private _Score = 0;
		if (_IsKnownAA) then { _Score = _Score + 1000; };
		if (_HasRadar) then { _Score = _Score + 400; };
		if (_HasActiveRadarComponent) then { _Score = _Score + 450; };
		if (_HasAirTargetClass) then { _Score = _Score + 300; };
		if (_HasAAMissiles) then { _Score = _Score + 400; };
		if (_HasAAAutoCannon) then { _Score = _Score + 250; };
		if (_AmmoAAAny) then { _Score = _Score + 150; };
		if (((_HasAAMissiles || _HasAAAutoCannon)) && !_AmmoAAAny) then { _Score = _Score - 600; };
		if (_HasGunner) then { _Score = _Score + 50; };
		if (_IsTank) then { _Score = _Score - 300; };

		_DebugScores pushBack [
			typeOf _x,
			_Score,
			[
				"KnownAA", _IsKnownAA,
				"RadarType", _HasRadar,
				"ActiveRadarComp", _HasActiveRadarComponent,
				"AirTarget", _HasAirTargetClass,
				"AAMissiles", _HasAAMissiles,
				"AAAutoCannon", _HasAAAutoCannon,
				"AmmoAAAny", _AmmoAAAny,
				"HasGunner", _HasGunner,
				"IsTank", _IsTank
			]
		];
		if (_Score > _BestScore) then { _BestScore = _Score; _BestVeh = _x; };
	} forEach _VehicleArray;

	if (_ConvoyDebug) then {
		// Sort by score (index 1) ascending for readable logging
		private _sorted = [_DebugScores, [], { _x select 1 }, "ASCEND"] call BIS_fnc_sortBy;
		private _top = if ((count _sorted) > 0) then { _sorted select ((count _sorted) - 1) } else { [] };
		format [
			"[CONVOY_AIR] AA selection scores (sorted): %1 | picked=%2 score=%3 | top=%4",
			_sorted,
			typeOf _BestVeh,
			_BestScore,
			_top
		] spawn OKS_fnc_LogDebug;
	};

	// If best score is very low, avoid picking a bad candidate when possible
	if (_BestScore < 200) exitWith { objNull };
	_BestVeh
};

private _aaVeh = call _selectAAVehicle;
if (isNull _aaVeh) then {
	if (_ConvoyDebug) then { "[CONVOY_AIR] No suitable AA vehicle found in convoy" spawn OKS_fnc_LogDebug; };
	sleep 5;
	continue;
};

if (_ConvoyDebug) then {
	format [
		"[CONVOY_AIR] Selected AA vehicle: %1",
		_aaVeh
	] spawn OKS_fnc_LogDebug;
};

// Store pending waypoints (from current index onward)
private _grp = group (driver _aaVeh);
private _wpCount = count (waypoints _grp);
private _curIdx = currentWaypoint _grp; // Arma uses 0-based indices for waypoints
private _storedWPs = [];
// Capture from current index onward using indices and getWPPos to avoid [0,0,0]
for "_i" from _curIdx to (_wpCount - 1) do {
	private _wp = (waypoints _grp) select _i;
	private _pos = getWPPos [_grp, _i];
	_storedWPs pushBack [
		_pos,
		waypointType _wp,
		waypointCompletionRadius _wp,
		waypointSpeed _wp,
		waypointBehaviour _wp,
		waypointFormation _wp,
		waypointCombatMode _wp,
		waypointStatements _wp
	];
};
// Remove the pending waypoints we just stored
for "_i" from (_wpCount - 1) to _curIdx step -1 do {
	deleteWaypoint [_grp, _i];
};
if (_ConvoyDebug) then {
	format ["[CONVOY_AIR] Stored %1 pending waypoints for %2", count _storedWPs, _aaVeh] spawn OKS_fnc_LogDebug;
};

// Compute a pull-off point: 50m ahead of the AA vehicle, then offset to the clearer side by 15m if possible
private _vehPos = getPosATL _aaVeh;
private _vehDir = getDir _aaVeh;
private _posAhead = [
	(_vehPos select 0) + 50 * (sin _vehDir),
	(_vehPos select 1) + 50 * (cos _vehDir),
	(_vehPos select 2)
];
private _isClear = {
	params ["_posATL"];
	private _terr = nearestTerrainObjects [_posATL, ["TREE","BUSH","ROCK","WALL","HOUSE","BUILDING"], 7, false, true];
	private _objs = nearestObjects [_posATL, ["House","Wall","Building","Car","Tank","StaticWeapon","Thing"], 7];
	(count _terr + count _objs) == 0
};

private _isOffRoad = {
	params ["_posATL"];
	!(isOnRoad _posATL)
};

private _isFlat = {
	params ["_posATL"];
	if (surfaceIsWater _posATL) exitWith { false };
	private _n = surfaceNormal _posATL;
	private _slopeDeg = acos (_n select 2); // 0 = flat, higher = steeper
	_slopeDeg <= _PullOffMaxSlope
};

private _leftDir = _vehDir - 90;
private _rightDir = _vehDir + 90;
private _leftPos = [(_posAhead select 0) + 35 * (sin _leftDir), (_posAhead select 1) + 35 * (cos _leftDir), _posAhead select 2];
private _rightPos = [(_posAhead select 0) + 35 * (sin _rightDir), (_posAhead select 1) + 35 * (cos _rightDir), _posAhead select 2];
private _pullPos = if ((([_leftPos] call _isClear) && ([_leftPos] call _isFlat))) then {_leftPos} else { if ((([_rightPos] call _isClear) && ([_rightPos] call _isFlat))) then {_rightPos} else {_posAhead} };

// Ensure minimum distance from nearest road by pushing further laterally if needed
private _ensureMinRoadDistance = {
	params ["_pos","_latDir"];
	private _res = _pos;
	private _nearest = [_pos, 50] call BIS_fnc_nearestRoad;
	private _ok = false;
	if (!isNull _nearest) then {
		private _rdPos = getPosATL _nearest;
		private _dist = _res distance2D _rdPos;
		if (_dist >= _PullOffMinRoadDist) exitWith { _ok = true; };
		private _steps = [5,10,15,20,25,30,35,40,45,50];
		{
			private _cand = [(_res select 0) + _x * (sin _latDir), (_res select 1) + _x * (cos _latDir), _res select 2];
			private _nr = [_cand, 50] call BIS_fnc_nearestRoad;
			private _nrPos = if (isNull _nr) then { [1e9,1e9,0] } else { getPosATL _nr };
			private _okRoad = (_cand distance2D _nrPos) >= _PullOffMinRoadDist;
			if (_okRoad && ([_cand] call _isOffRoad) && ([_cand] call _isClear) && ([_cand] call _isFlat)) exitWith { _res = _cand; _ok = true; };
		} forEach _steps;
	};
	_res
};
// If pull-off equals current location (no offset possible), force a short forward move to avoid blocking
if (_pullPos distance2D _vehPos < 6) then {
	private _posShortAhead = [
		(_vehPos select 0) + 20 * (sin _vehDir),
		(_vehPos select 1) + 20 * (cos _vehDir),
		(_vehPos select 2)
	];
	private _leftShort = [(_posShortAhead select 0) + 25 * (sin _leftDir), (_posShortAhead select 1) + 25 * (cos _leftDir), _posShortAhead select 2];
	private _rightShort = [(_posShortAhead select 0) + 25 * (sin _rightDir), (_posShortAhead select 1) + 25 * (cos _rightDir), _posShortAhead select 2];
	_pullPos = if ([_leftShort] call _isClear) then {_leftShort} else { if ([_rightShort] call _isClear) then {_rightShort} else {_posShortAhead} };
};

// Extra nudge further off-road along the chosen lateral direction if possible (adds ~10m more margin)
if (!(_pullPos isEqualTo _posAhead)) then {
	private _useLeft = (_pullPos distance2D _leftPos) <= (_pullPos distance2D _rightPos);
	private _nudgeDir = if (_useLeft) then {_leftDir} else {_rightDir};
	private _nudged = [
		(_pullPos select 0) + 10 * (sin _nudgeDir),
		(_pullPos select 1) + 10 * (cos _nudgeDir),
		(_pullPos select 2)
	];
	if ((([_nudged] call _isClear) && ([_nudged] call _isFlat))) then { _pullPos = _nudged; };
	// Enforce minimum distance from road after nudge
	_pullPos = [_pullPos, _nudgeDir] call _ensureMinRoadDistance;
};

// Ensure the pull-off is not on the road; if it is, step laterally further until off-road or try the other side
if (isOnRoad _pullPos) then {
	private _tryDir = if ((_pullPos distance2D _leftPos) <= (_pullPos distance2D _rightPos)) then { _leftDir } else { _rightDir };
	private _fixed = false;
	{
		private _cand = [
			(_pullPos select 0) + _x * (sin _tryDir),
			(_pullPos select 1) + _x * (cos _tryDir),
			(_pullPos select 2)
		];
	if ((([_cand] call _isClear) && ([_cand] call _isOffRoad) && ([_cand] call _isFlat))) exitWith { _pullPos = _cand; _fixed = true; };
	} forEach [5,10,15,20,25,30];
	if (!_fixed) then {
		// Try opposite lateral
		private _altDir = if (_tryDir isEqualTo _leftDir) then { _rightDir } else { _leftDir };
		{
			private _cand2 = [
				(_pullPos select 0) + _x * (sin _altDir),
				(_pullPos select 1) + _x * (cos _altDir),
				(_pullPos select 2)
			];
			if ((([_cand2] call _isClear) && ([_cand2] call _isOffRoad) && ([_cand2] call _isFlat))) exitWith { _pullPos = _cand2; _fixed = true; };
		} forEach [5,10,15,20,25,30];
	};
	if (!_fixed) then {
		// Last resort: move a bit further forward and re-check lateral 15m
		private _pa = [
			(_pullPos select 0) + 15 * (sin _vehDir),
			(_pullPos select 1) + 15 * (cos _vehDir),
			(_pullPos select 2)
		];
		private _candL = [(_pa select 0) + 15 * (sin _leftDir), (_pa select 1) + 15 * (cos _leftDir), _pa select 2];
		private _candR = [(_pa select 0) + 15 * (sin _rightDir), (_pa select 1) + 15 * (cos _rightDir), _pa select 2];
		if ((([_candL] call _isClear) && ([_candL] call _isOffRoad) && ([_candL] call _isFlat))) then { _pullPos = _candL; _fixed = true; };
		if (!_fixed && ((([_candR] call _isClear) && ([_candR] call _isOffRoad) && ([_candR] call _isFlat)))) then { _pullPos = _candR; _fixed = true; };
		if (!_fixed) then { _pullPos = _pa; };
	};
	// Enforce minimum distance from road after lateral stepping
	private _finalLat = if ((_pullPos distance2D _leftPos) <= (_pullPos distance2D _rightPos)) then { _leftDir } else { _rightDir };
	_pullPos = [_pullPos, _finalLat] call _ensureMinRoadDistance;
	if (_ConvoyDebug) then {
		format ["[CONVOY_AIR] Pull-off adjusted off-road. Pos: %1", _pullPos] spawn OKS_fnc_LogDebug;
	};
};
if (_ConvoyDebug) then {
	private _side = if (_pullPos isEqualTo _leftPos) then {"left"} else { if (_pullPos isEqualTo _rightPos) then {"right"} else {"ahead"} };
	format [
		"[CONVOY_AIR] Pull-off point chosen to the %1. Pos: %2",
		_side,
		_pullPos
	] spawn OKS_fnc_LogDebug;
};

// Add temporary waypoint to pull-off point
private _wpTemp = _grp addWaypoint [_pullPos, 0];
_wpTemp setWaypointType "MOVE";
_wpTemp setWaypointCompletionRadius 6;
// Travel conservatively to avoid stopping/engaging on the road
_wpTemp setWaypointBehaviour "AWARE";
_wpTemp setWaypointCombatMode "YELLOW";
{ 
	_x disableAI "AUTOCOMBAT";
	_x disableAI "TARGET";
	_x disableAI "AUTOTARGET";
	_x doTarget objNull;
	_x doWatch objNull;
} forEach (units _grp);
// Hard hold fire while moving to pull-off
_grp setCombatMode "BLUE";
// Unlock AA speed for the pull-off movement
if (!isNull _aaVeh && {canMove _aaVeh}) then { _aaVeh limitSpeed 999; _aaVeh forceSpeed -1; };

// Mark AA engagement to prevent generic ambush handler from interfering
_aaVeh setVariable ["OKS_Convoy_AAEngaging", true, true];

// Travel to the pull-off
waitUntil {
	sleep 0.5;
	isNull _aaVeh || !canMove _aaVeh || (_aaVeh distance _pullPos < 10)
};
if (!isNull _aaVeh && canMove _aaVeh) then {
	// If still on road, issue a small lateral nudge waypoint to get off the road
	private _vehHere = getPosATL _aaVeh;
	if (isOnRoad _vehHere) then {
		private _useLeft = (_pullPos distance2D [(_vehHere select 0) + (sin _leftDir), (_vehHere select 1) + (cos _leftDir)]) <=
						   (_pullPos distance2D [(_vehHere select 0) + (sin _rightDir), (_vehHere select 1) + (cos _rightDir)]);
		private _nDir = if (_useLeft) then { _leftDir } else { _rightDir };
		private _off = [(_vehHere select 0) + 12 * (sin _nDir), (_vehHere select 1) + 12 * (cos _nDir), _vehHere select 2];
		private _wpTemp2 = _grp addWaypoint [_off, 0];
		_wpTemp2 setWaypointType "MOVE";
		_wpTemp2 setWaypointCompletionRadius 4;
		_wpTemp2 setWaypointBehaviour "AWARE";
		_wpTemp2 setWaypointCombatMode "YELLOW";
		if (_ConvoyDebug) then { "[CONVOY_AIR] Pull-off on road; issuing extra nudge off-road" spawn OKS_fnc_LogDebug; };
		waitUntil { sleep 0.5; isNull _aaVeh || !canMove _aaVeh || (!isOnRoad (getPosATL _aaVeh)) || (_aaVeh distance _off < 5) };
	};
	// Now hold and engage
	{ 
		_x enableAI "TARGET";
		_x enableAI "AUTOTARGET";
		_x enableAI "AUTOCOMBAT"; 
	} forEach (units _grp);
	_grp setBehaviour "COMBAT";
	_grp setCombatMode "RED";
	_aaVeh limitSpeed 0; _aaVeh forceSpeed 0;
	if (_ConvoyDebug) then { format ["[CONVOY_AIR] %1 reached pull-off and is engaging air targets", _aaVeh] spawn OKS_fnc_LogDebug; };
};

// Wait until: no enemy air remains AND nearest convoy vehicle is at least 100m away,
// or a clear-sky timeout passes (grace restore)
private _NoAirSince = -1;
private _EngageStart = time;
waitUntil {
	sleep 1;
	private _airNow = call _findEnemyAir;
	// Mark destroyed/disabled air targets to be ignored going forward and clear targeting state
	{
		private _t = _x;
		if (!isNull _t && ((!alive _t) || (!canMove _t))) then {
			if (!(_t in _IgnoredAir)) then {
				_IgnoredAir pushBack _t;
				{
					_x ignoreTarget _t;
					_x doTarget objNull;
					_x doWatch objNull;
					_x reveal [_t, 0];
					// Clear any residual target memory if supported
					_x forgetTarget _t;
				} forEach (units _grp);
				if (_ConvoyDebug) then {
					format ["[CONVOY_AIR] Ignoring destroyed/disabled air target: %1", _t] spawn OKS_fnc_LogDebug;
				};
			};
		};
	} forEach _airPrev;
	_airPrev = +_airNow;
	// Track time since skies became clear
	if ((count _airNow) == 0) then {
		if (_NoAirSince < 0) then { _NoAirSince = time; };
	} else {
		_NoAirSince = -1;
	};

	// Compute nearest distance to OTHER convoy vehicles (exclude AA itself)
	private _nearestDist = 1e9;
	{
		if (!isNull _x && (_x != _aaVeh)) then {
			_nearestDist = _nearestDist min (_aaVeh distance _x);
		};
	} forEach _VehicleArray;

	// If nothing else in array (edge case), allow immediate restore
	if (_nearestDist isEqualTo 1e9) then { _nearestDist = 10000; };

	private _clearAndSpaced = ((count _airNow) == 0) && (_nearestDist >= 100);
	private _timeout = (_NoAirSince >= 0) && ((time - _NoAirSince) > 30);
	private _hardTimeout = (time - _EngageStart) > 90;

	if (_ConvoyDebug) then {
		format [
			"[CONVOY_AIR] Waiting to restore: air=%1 nearest=%2m clearAndSpaced=%3 timeout=%4 hardTimeout=%5 (since=%6)",
			count _airNow,
			round _nearestDist,
			_clearAndSpaced,
			_timeout,
			_hardTimeout,
			_NoAirSince
		] spawn OKS_fnc_LogDebug;
	};
	_clearAndSpaced || _timeout || _hardTimeout
};

// Restore: remove temporary waypoint, recreate stored ones, clear AA flag
private _finalCount = count (waypoints _grp);
for "_i" from (_finalCount - 1) to 0 step -1 do { deleteWaypoint [_grp, _i]; };

{
	_x params ["_pos","_type","_cr","_spd","_beh","_form","_cm","_stmts"];
	private _wp = _grp addWaypoint [_pos, 0];
	_wp setWaypointType _type;
	_wp setWaypointCompletionRadius _cr;
	_wp setWaypointSpeed _spd;
	_wp setWaypointBehaviour _beh;
	_wp setWaypointFormation _form;
	_wp setWaypointCombatMode _cm;
	_wp setWaypointStatements _stmts;
} forEach _storedWPs;
if (_ConvoyDebug) then {
	format ["[CONVOY_AIR] Restored %1 waypoints for %2", count _storedWPs, _aaVeh] spawn OKS_fnc_LogDebug;
};

_aaVeh setVariable ["OKS_Convoy_AAEngaging", false, true];
if (!isNull _aaVeh && {canMove _aaVeh}) then { _aaVeh limitSpeed 999; _aaVeh forceSpeed -1; };

// Reinsert AA vehicle at tail and start its speed logic behind previous tail
private _leadVeh = _VehicleArray select 0;
private _arr = _leadVeh getVariable ["OKS_Convoy_VehicleArray", _VehicleArray];
// Remove AA if present, then append
private _idxAA = _arr find _aaVeh;
if (_idxAA >= 0) then { _arr deleteAt _idxAA; };
_arr pushBack _aaVeh;
_leadVeh setVariable ["OKS_Convoy_VehicleArray", _arr, true];
if (_ConvoyDebug) then {
	format ["[CONVOY_AIR] Appended %1 as tail vehicle. Convoy size now: %2", _aaVeh, count _arr] spawn OKS_fnc_LogDebug;
};

if ((count _arr) > 1) then {
	private _prevTail = _arr select ((count _arr) - 2);
	// Apply AA vehicle's own stored speed/disp or use base from prevTail
	private _speedKphAA = _aaVeh getVariable ["OKS_LimitSpeedBase", (_prevTail getVariable ["OKS_LimitSpeedBase", 40])];
	private _dispAA = _aaVeh getVariable ["OKS_Convoy_Dispersion", (_prevTail getVariable ["OKS_Convoy_Dispersion", 25])];
	_aaVeh setVariable ["OKS_LimitSpeedBase", _speedKphAA, true];
	_aaVeh setVariable ["OKS_Convoy_Dispersion", _dispAA, true];
	// Enforce a merge gap before accelerating, then ramp speed to avoid collisions
	[_aaVeh, _prevTail, _dispAA, _MergeGapMin, _MergeGapTimeout, _SpeedRampStep, _SpeedRampInterval] spawn {
		params ["_aaVeh","_prevTail","_dispAA","_gapMin","_gapTimeout","_stepKph","_interval"];
		private _t0 = time;
		waitUntil {
			sleep 0.5;
			isNull _aaVeh || !canMove _aaVeh || (_aaVeh distance _prevTail) >= _gapMin || ((time - _t0) > _gapTimeout)
		};
		if (isNull _aaVeh || !canMove _aaVeh) exitWith {};
		// Start with a gentle speed, then ramp up to base
		private _base = _aaVeh getVariable ["OKS_LimitSpeedBase", 40];
		private _cur = 10 max 0; // 10 kph start
		while { _cur < _base && {alive _aaVeh} && {canMove _aaVeh} } do {
			_aaVeh limitSpeed _cur; _aaVeh forceSpeed _cur;
			sleep _interval;
			_cur = _cur + _stepKph;
		};
		// Hand control back to convoy speed controller
		_aaVeh forceSpeed -1; _aaVeh limitSpeed 999;
		[_aaVeh, _prevTail, _dispAA] spawn OKS_fnc_Convoy_CheckAndAdjustSpeeds;
	};
};
if (_ConvoyDebug) then { "[CONVOY_AIR] AA vehicle rejoined convoy and waypoints restored" spawn OKS_fnc_LogDebug; };

// Refresh lead vehicle pointer on all convoy vehicles
{
	_x setVariable ["OKS_Convoy_LeadVehicle", _leadVeh, true];
} forEach _arr;
// Loop will continue to wait for the next interception
};