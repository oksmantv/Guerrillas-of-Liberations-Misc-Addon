/*
	OKS_fnc_RailMove

	Forces a ground vehicle to drive "on rails" through an array of waypoints.
	Uses setDriveOnPath to make the AI driver follow a scripted path.
	This is intended for "keep driving regardless of enemies" while turret AI engages normally.

	Params:
	0: OBJECT - Vehicle
	1: NUMBER - Speed limit in km/h
	2: ARRAY  - Waypoints (positions/objects/markers). Processed from index 0 -> end.
	3: STRING - Deployment style for dismount tasks.
	          If vehicle has cargo, cargo groups are dismounted using convoy logic:
	          [_cargoGroup, _vehicle, _deploymentStyle, true, false] spawn OKS_fnc_Convoy_DismountAndTaskCode;
	
	Behaviour:
	- Vehicle is driven by setDriveOnPath along the waypoint path.
	- If stuck/unable to move, vehicle stops and dismounts:
	  - If cargo exists: cargo dismounts using convoy behaviour.
	  - If no cargo: the crew dismounts and is tasked using convoy behaviour.
	- If the route finishes:
	  - If cargo exists: vehicle stops and deploys cargo using convoy behaviour.
	  - If no cargo: vehicle stops but does not dismount.

	Example:
		[veh1, 35, [wp1, wp2, wp3], "rush"] spawn OKS_fnc_RailMove;

	Note:
	- Should be executed where the vehicle is local (typically server).
*/

params [
	["_vehicle", objNull, [objNull]],
	["_speedLimitKph", 35, [0]],
	["_waypoints", [], [[]]],
	["_deploymentStyle", "rush", [""]]
];

if (isNull _vehicle) exitWith {scriptNull};
if (_waypoints isEqualTo []) exitWith {scriptNull};

private _railDebug = missionNamespace getVariable ["GOL_RailMove_Debug", false];
private _useForceSpeed = missionNamespace getVariable ["GOL_RailMove_UseForceSpeed", true];

if (!local _vehicle) exitWith {
	// Best-effort: run where the vehicle is local.
	[_vehicle, _speedLimitKph, _waypoints, _deploymentStyle] remoteExec ["OKS_fnc_RailMove", _vehicle];
	scriptNull
};

if (!canMove _vehicle) exitWith {scriptNull};

// Driver can briefly be null right after spawning crew. Wait a short moment.
private _driver = objNull;
private _t0 = diag_tickTime;
waitUntil {
	sleep 0.1;
	_driver = driver _vehicle;
	(!isNull _driver) || {(diag_tickTime - _t0) > 3}
};
if (isNull _driver) exitWith {
	if (_railDebug) then {
		format ["[RAILMOVE] Abort: no driver for %1 (type=%2)", _vehicle, typeOf _vehicle] spawn OKS_fnc_LogDebug;
	};
	scriptNull
};

private _resolveWaypointPosATL = {
	params ["_wp"];
	if (_wp isEqualType objNull) exitWith { getPosATL _wp };
	if (_wp isEqualType []) exitWith { _wp };
	if (_wp isEqualType "") exitWith { getMarkerPos _wp };
	[0,0,0]
};

private _getCargoGroups = {
	params ["_veh"];
	private _explicitCargoGroup = _veh getVariable ["OKS_RailMove_cargoGroup", grpNull];
	if (!isNull _explicitCargoGroup && {count (units _explicitCargoGroup) > 0}) exitWith {[_explicitCargoGroup]};
	private _passengerGroup = _veh getVariable ["OKS_RailMove_passengerGroup", grpNull];
	if (!isNull _passengerGroup && {count (units _passengerGroup) > 0}) exitWith {[_passengerGroup]};
	private _cargoUnits = (crew _veh) select {
		alive _x && { (assignedVehicleRole _x) param [0, ""] isEqualTo "cargo" }
	};
	private _cargoGroups = [];
	{
		private _g = group _x;
		if (!isNull _g && {(_cargoGroups find _g) < 0}) then {
			_cargoGroups pushBack _g;
		};
	} forEach _cargoUnits;
	_cargoGroups
};

private _hasCargo = {count ([_vehicle] call _getCargoGroups) > 0};

// Setup to encourage "driver keeps driving" while gunners can engage.
_vehicle engineOn true;
_vehicle limitSpeed (_speedLimitKph max 5);
if (_useForceSpeed) then {
	_vehicle forceSpeed ((_speedLimitKph max 5) / 3.6);
} else {
	_vehicle forceSpeed -1;
};

// Ensure the driver is actually allowed to path and move.
_driver enableAI "PATH";
_driver enableAI "MOVE";
_driver enableAI "FSM";

// Keep the driver's decision making "out" of combat so it doesn't brake/stop.
private _dg = group _driver;
if (!isNull _dg) then { _dg selectLeader _driver; };
_vehicle setEffectiveCommander _driver;
_vehicle useAISteeringComponent true;

_driver setBehaviourStrong "AWARE";
_driver setUnitCombatMode "BLUE";
_driver action ["TurnIn", _vehicle];

_driver disableAI "AUTOCOMBAT";
_driver disableAI "TARGET";
_driver disableAI "AUTOTARGET";
_driver enableAttack false;

{
	if (_x != _driver) then {
		_x enableAttack true;
	};
} forEach (crew _vehicle);

private _stuckStart = -1;
private _lastPosATL = getPosATL _vehicle;
private _lastProgressAt = diag_tickTime;

private _handleStuckOrDisabled = {
	params ["_veh", "_drv", "_deploymentStyle"];

	// Stop following any scripted path.
	_veh setDriveOnPath [];
	if (!isNull _drv) then { doStop _drv; };

	_veh limitSpeed 0;
	_veh forceSpeed 0;
	_veh setVehicleLock "UNLOCKED";

	private _cargoGroups = [_veh] call _getCargoGroups;
	if (count _cargoGroups > 0) then {
		{
			[_x, _veh, _deploymentStyle, true, false] spawn OKS_fnc_Convoy_DismountAndTaskCode;
		} forEach _cargoGroups;
	} else {
		// No cargo groups: dismount all crew groups (driver may be in its own group).
		private _crewGroups = [];
		{
			private _g = group _x;
			if (!isNull _g && {(_crewGroups find _g) < 0}) then {
				_crewGroups pushBack _g;
			};
		} forEach ((crew _veh) select {alive _x});
		{
			[_x, _veh, _deploymentStyle, true, false] spawn OKS_fnc_Convoy_DismountAndTaskCode;
		} forEach _crewGroups;
	};
};

private _arrivalRadiusMeters = missionNamespace getVariable ["GOL_RailMove_ArrivalRadiusMeters", 25];
private _turnDeadzoneDeg = 8;
private _turnHardDeg = 25;
private _minSpeedForNotStuck = (missionNamespace getVariable ["GOL_RailMove_MinSpeedForNotStuck", 2.5]);
private _stuckAfterSeconds = missionNamespace getVariable ["GOL_RailMove_StuckAfterSeconds", 12];

if (_railDebug) then {
	format [
		"[RAILMOVE] Start veh=%1 type=%2 local=%3 driver=%4 group=%5 speedLimit=%6 wps=%7 deploy=%8",
		_vehicle,
		typeOf _vehicle,
		local _vehicle,
		_driver,
		group _driver,
		_speedLimitKph,
		count _waypoints,
		_deploymentStyle
	] spawn OKS_fnc_LogDebug;
};

private _scriptHandle = [_vehicle, _driver, _speedLimitKph, _waypoints, _deploymentStyle] spawn {
	params ["_vehicle", "_driver", "_speedLimitKph", "_waypoints", "_deploymentStyle"];
	private _railDebug = missionNamespace getVariable ["GOL_RailMove_Debug", false];
	private _useForceSpeed = missionNamespace getVariable ["GOL_RailMove_UseForceSpeed", true];

	private _resolveWaypointPosATL = {
		params ["_wp"];
		if (_wp isEqualType objNull) exitWith { getPosATL _wp };
		if (_wp isEqualType []) exitWith { _wp };
		if (_wp isEqualType "") exitWith { getMarkerPos _wp };
		[0,0,0]
	};

	private _getCargoGroups = {
		params ["_veh"];
		private _explicitCargoGroup = _veh getVariable ["OKS_RailMove_cargoGroup", grpNull];
		if (!isNull _explicitCargoGroup && {count (units _explicitCargoGroup) > 0}) exitWith {[_explicitCargoGroup]};
		private _passengerGroup = _veh getVariable ["OKS_RailMove_passengerGroup", grpNull];
		if (!isNull _passengerGroup && {count (units _passengerGroup) > 0}) exitWith {[_passengerGroup]};
		private _cargoUnits = (crew _veh) select {
			alive _x && { (assignedVehicleRole _x) param [0, ""] isEqualTo "cargo" }
		};
		private _cargoGroups = [];
		{
			private _g = group _x;
			if (!isNull _g && {(_cargoGroups find _g) < 0}) then {
				_cargoGroups pushBack _g;
			};
		} forEach _cargoUnits;
		_cargoGroups
	};

	private _handleStuckOrDisabled = {
		params ["_veh", "_drv", "_deploymentStyle"];

		_veh setDriveOnPath [];
		if (!isNull _drv) then { doStop _drv; };

		_veh limitSpeed 0;
		_veh forceSpeed 0;
		_veh setVehicleLock "UNLOCKED";

		private _cargoGroups = [_veh] call _getCargoGroups;
		if (count _cargoGroups > 0) then {
			{
				[_x, _veh, _deploymentStyle, true, false] spawn OKS_fnc_Convoy_DismountAndTaskCode;
			} forEach _cargoGroups;
		} else {
			private _crewGroups = [];
			{
				private _g = group _x;
				if (!isNull _g && {(_crewGroups find _g) < 0}) then {
					_crewGroups pushBack _g;
				};
			} forEach ((crew _veh) select {alive _x});
			{
				[_x, _veh, _deploymentStyle, true, false] spawn OKS_fnc_Convoy_DismountAndTaskCode;
			} forEach _crewGroups;
		};
	};

	_vehicle engineOn true;
	_vehicle limitSpeed (_speedLimitKph max 5);
	if (_useForceSpeed) then {
		_vehicle forceSpeed ((_speedLimitKph max 5) / 3.6);
	} else {
		_vehicle forceSpeed -1;
	};

	_driver enableAI "PATH";
	_driver enableAI "MOVE";
	_driver enableAI "FSM";
	// Split the driver into its own group so group combat settings don't suppress gunners/FFV.
	private _driverSide = side _driver;
	private _driverGroup = group _driver;
	if (!isNull _driverGroup && {count (units _driverGroup) > 1}) then {
		_driverGroup = createGroup _driverSide;
		[_driver] joinSilent _driverGroup;
	};
	if (!isNull _driverGroup) then { _driverGroup selectLeader _driver; };
	_vehicle setEffectiveCommander _driver;
	_driver setBehaviourStrong "AWARE";
	_driver setUnitCombatMode "BLUE";
	_driver action ["TurnIn", _vehicle];
	_driver disableAI "AUTOCOMBAT";
	_driver disableAI "TARGET";
	_driver disableAI "AUTOTARGET";
	_driver enableAttack false;

	// Ensure gunners/FFV/cargo can still engage.
	private _gunner = gunner _vehicle;
	private _commander = commander _vehicle;
	private _passengerUnits = (crew _vehicle) select {
		alive _x && {_x != _driver} && {_x != _gunner} && {_x != _commander}
	};
	if (count _passengerUnits > 0) then {
		private _passengerGroup = _vehicle getVariable ["OKS_RailMove_cargoGroup", grpNull];
		if (isNull _passengerGroup) then { _passengerGroup = _vehicle getVariable ["OKS_RailMove_passengerGroup", grpNull]; };
		if (isNull _passengerGroup) then {
			_passengerGroup = createGroup _driverSide;
			_vehicle setVariable ["OKS_RailMove_passengerGroup", _passengerGroup, true];
		};
		{ [_x] joinSilent _passengerGroup; } forEach _passengerUnits;
		_passengerGroup setCombatMode "RED";
		_passengerGroup setSpeedMode "FULL";
		{ _x enableAttack true; _x enableAI "TARGET"; _x enableAI "AUTOTARGET"; _x enableAI "AUTOCOMBAT"; _x setBehaviourStrong "AWARE"; } forEach _passengerUnits;
	};
	private _turretUnits = [];
	if (!isNull _gunner) then { _turretUnits pushBack _gunner; };
	if (!isNull _commander && {_commander != _gunner}) then { _turretUnits pushBack _commander; };
	{
		_x enableAttack true;
		_x enableAI "TARGET";
		_x enableAI "AUTOTARGET";
		_x enableAI "AUTOCOMBAT";
		_x setBehaviourStrong "AWARE";
	} forEach _turretUnits;
	private _turretGroup = if (count _turretUnits > 0) then { group (_turretUnits select 0) } else { grpNull };
	if (!isNull _turretGroup) then {
		_turretGroup setCombatMode "RED";
		_turretGroup setSpeedMode "FULL";
	};

	private _arrivalRadiusMeters = missionNamespace getVariable ["GOL_RailMove_ArrivalRadiusMeters", 25];
	private _minSpeedForNotStuck = (missionNamespace getVariable ["GOL_RailMove_MinSpeedForNotStuck", 2.5]);
	private _stuckAfterSeconds = missionNamespace getVariable ["GOL_RailMove_StuckAfterSeconds", 12];

	private _lastPosATL = getPosATL _vehicle;
	private _lastProgressAt = diag_tickTime;
	private _stuckStart = -1;
	private _lastLogAt = -1;
	private _lastSteerCmd = "";

	private _pathPositions = [];
	{
		private _p = [_x] call _resolveWaypointPosATL;
		if !(_p isEqualTo [0,0,0]) then {
			_pathPositions pushBack _p;
		};
	} forEach _waypoints;
	if (_pathPositions isEqualTo []) exitWith {
		if (_railDebug) then { format ["[RAILMOVE] Abort: no valid waypoint positions"] spawn OKS_fnc_LogDebug; };
	};

	{
		if (!alive _vehicle || isNull _vehicle) exitWith {};
		if (!canMove _vehicle || !alive _driver || isNull _driver) exitWith {
			if (_railDebug) then {
				format [
					"[RAILMOVE] Abort mid-route: canMove=%1 aliveVeh=%2 aliveDrv=%3 veh=%4 drv=%5",
					canMove _vehicle,
					alive _vehicle,
					alive _driver,
					_vehicle,
					_driver
				] spawn OKS_fnc_LogDebug;
			};
			[_vehicle, _driver, _deploymentStyle] call _handleStuckOrDisabled;
		};

		private _targetPosATL = _x;

		if (_railDebug) then {
			format ["[RAILMOVE] Segment %1/%2 target=%3", (_forEachIndex + 1), count _pathPositions, _targetPosATL] spawn OKS_fnc_LogDebug;
		};

		// Drive to this waypoint using setDriveOnPath (re-issue with remaining path).
		private _remainingPath = _pathPositions select [_forEachIndex, (count _pathPositions) - _forEachIndex];
		_vehicle setDriveOnPath _remainingPath;
		_driver doMove _targetPosATL;
		if (!isNull (group _driver)) then { (group _driver) setSpeedMode "FULL"; };
		// Re-assert leadership/unit combat mode in case contact changed things.
		private _dg2 = group _driver;
		if (!isNull _dg2) then { _dg2 selectLeader _driver; };
		_vehicle setEffectiveCommander _driver;
		_driver setBehaviourStrong "AWARE";
		_driver setUnitCombatMode "BLUE";
		_driver action ["TurnIn", _vehicle];

		_stuckStart = -1;
		_lastPosATL = getPosATL _vehicle;
		_lastProgressAt = diag_tickTime;

		while {alive _vehicle && canMove _vehicle && alive _driver && !isNull _driver} do {
			private _dist2D = _vehicle distance2D _targetPosATL;
			if (_dist2D <= _arrivalRadiusMeters) exitWith {};

			private _now = diag_tickTime;

			// Keep speed clamped.
			_vehicle limitSpeed (_speedLimitKph max 5);
			if (_useForceSpeed) then {
				_vehicle forceSpeed ((_speedLimitKph max 5) / 3.6);
			} else {
				_vehicle forceSpeed -1;
			};
			_vehicle engineOn true;
			if (isEngineOn _vehicle isEqualTo false) then { _vehicle engineOn true; };
			// If contact/AI state overrides leader, take it back.
			private _dg3 = group _driver;
			if (!isNull _dg3 && {leader _dg3 != _driver}) then { _dg3 selectLeader _driver; };
			if ((effectiveCommander _vehicle) != _driver) then { _vehicle setEffectiveCommander _driver; };
			_driver setUnitCombatMode "BLUE";
			_driver action ["TurnIn", _vehicle];
			// Some AI states can cancel movement orders; re-assert destination occasionally.
			if ((_now - _lastLogAt) > 4) then {
				_driver doMove _targetPosATL;
			};

			// Periodic debug (non-spam): log every ~2s, or when steering command changes.
			if (_railDebug) then {
				if ((_lastLogAt < 0) || {(_now - _lastLogAt) > 2}) then {
					_lastLogAt = _now;
					private _d = (round (_dist2D * 10)) / 10;
					private _s = (round ((speed _vehicle) * 10)) / 10;
					private _g = group _driver;
					private _cm = if (isNull _g) then {"NONE"} else {combatMode _g};
					private _sm = if (isNull _g) then {"NONE"} else {speedMode _g};
					format [
						"[RAILMOVE] tick seg=%1 dist=%2 speed=%3 pos=%4 target=%5 cmd=%6 beh=%7 cm=%8 sm=%9",
						(_forEachIndex + 1),
						_d,
						_s,
						getPosATL _vehicle,
						_targetPosATL,
						currentCommand _driver,
						behaviour _driver,
						_cm,
						_sm
					] spawn OKS_fnc_LogDebug;
				};
			};

			private _posNowATL = getPosATL _vehicle;
			private _movedMeters = _posNowATL distance2D _lastPosATL;
			if (_movedMeters > 1) then {
				_lastPosATL = _posNowATL;
				_lastProgressAt = _now;
			};

			private _vehSpeed = speed _vehicle;
			private _noProgressTooLong = (_now - _lastProgressAt) >= _stuckAfterSeconds;
			private _slow = _vehSpeed < _minSpeedForNotStuck;

			if (_slow && _noProgressTooLong && {_dist2D > (_arrivalRadiusMeters + 10)}) exitWith {
				if (_railDebug) then {
					private _d = (round (_dist2D * 10)) / 10;
					private _s = (round ((speed _vehicle) * 10)) / 10;
					private _np = (round (((_now - _lastProgressAt)) * 10)) / 10;
					format [
						"[RAILMOVE] STUCK seg=%1 dist=%2 speed=%3 noProgressFor=%4s pos=%5",
						(_forEachIndex + 1),
						_d,
						_s,
						_np,
						getPosATL _vehicle
					] spawn OKS_fnc_LogDebug;
				};
				[_vehicle, _driver, _deploymentStyle] call _handleStuckOrDisabled;
			};

			sleep 0.5;
		};
	} forEach _pathPositions;

	// Finished the route: stop, and only deploy cargo if any.
	_vehicle setDriveOnPath [];
	_vehicle limitSpeed 0;
	_vehicle forceSpeed 0;
	_vehicle setVehicleLock "UNLOCKED";
	if (_railDebug) then {
		format ["[RAILMOVE] Finished route veh=%1 type=%2", _vehicle, typeOf _vehicle] spawn OKS_fnc_LogDebug;
	};

	private _cargoGroups = [_vehicle] call _getCargoGroups;
	if (count _cargoGroups > 0) then {
		{
			[_x, _vehicle, _deploymentStyle, true, false] spawn OKS_fnc_Convoy_DismountAndTaskCode;
		} forEach _cargoGroups;
	};
};

_scriptHandle
