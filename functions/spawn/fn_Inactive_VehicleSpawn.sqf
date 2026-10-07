/* OKS Inactive VehicleSpawn

	Creates a locked vehicle and crew. The crew is fully blind (disableAI "ALL") and
	stays put until activation, which happens automatically (based on Delay Type) or
	manually by setting a variable on the returned vehicle:

		_vehicle setVariable ["Inactive_VehicleSpawn", true, true];

	The manual variable trigger is always checked as an override, regardless of
	Delay Type.

	Params:
	0 - Position - Array Position, Object or Marker
	1 - Direction - Number Degrees, nil if using marker or object
	2 - Vehicle classname
	3 - Enemy Side - Side
	4 - Delay Value - meaning depends on Delay Type:
		"timer"     - Number, seconds to wait before activation (default 600)
		"condition" - Code (or String to compile), evaluated each cycle, activates on true
		"reaction"  - Number, knowsAbout threshold that triggers activation (default 3.9). Since
			the crew is blind, this checks every other unit on the vehicle's side for
			knowledge of a player above the threshold, sustained for 30 consecutive seconds
	5 - Delay Type - "timer", "condition" or "reaction" (default "timer")
	6 - Action - "static", "hunt", "patrol" or "move" upon activation
	7 - Range - Range used by "hunt" and "patrol"
	8 - Move Position - Array Position, Object or Marker. Only used when Action is "move"
	9 - Move Behaviour - String, waypoint behaviour used when Action is "move" (default "SAFE")

	Returns:
	Object - The created vehicle.

	Example:
	_vehicle = [position_1, nil, "UK3CB_ARD_O_T55", east, 20, "timer", "hunt", 500] call OKS_fnc_Inactive_VehicleSpawn;
	_vehicle = [position_1, nil, "UK3CB_ARD_O_T55", east, [], "condition", "move", 0, movePos_1, "AWARE"] call OKS_fnc_Inactive_VehicleSpawn;
	_vehicle setVariable ["Inactive_VehicleSpawn", true, true]; // manual activation override
 */

params [
	"_Position",
	["_Direction", nil, [0]],
	["_VehicleType", "", [""]],
	["_Side", east, [sideUnknown]],
	["_DelayValue", 600, [0, "", {}]],
	["_DelayType", "timer", [""]],
	["_Action", "hunt", [""]],
	["_Range", 500, [0]],
	["_MovePosition", [], [[], objNull, ""]],
	["_MoveBehaviour", "SAFE", [""]]
];

private _deleteObject = objNull;

switch (typeName _Position) do {
	case "OBJECT": { _deleteObject = _Position; _Direction = getDir _Position; _Position = getPosATL _Position; };
	case "STRING": { _Direction = markerDir _Position; _Position = getMarkerPos _Position; };
	default {};
};

if (!isNull _deleteObject) then {
	deleteVehicle _deleteObject;
};

private _vehicle = createVehicle [_VehicleType, _Position, [], 0, "CAN_COLLIDE"];
_vehicle setDir (if (!isNil "_Direction") then { _Direction } else { random 360 });

private _group = [_vehicle, _Side, 0, 0, true] call OKS_fnc_AddVehicleCrew;
_vehicle lock true;
_vehicle setVariable ["Inactive_VehicleSpawn", false, true];

[_vehicle, _group, _Side, _DelayValue, _DelayType, _Action, _Range, _MovePosition, _MoveBehaviour] spawn {
	params ["_vehicle", "_group", "_side", "_delayValue", "_delayType", "_action", "_range", "_movePosition", "_moveBehaviour"];

	private _conditionCode = if (_delayType == "condition") then {
		if (typeName _delayValue == "STRING") then { compile _delayValue } else { _delayValue }
	} else {
		{ false }
	};

	// The crew is blind (disableAI "ALL") while dormant, so it cannot build its own
	// knowsAbout. "reaction" instead checks whether any other unit on _side knows
	// about a player above the threshold, sustained for 30 consecutive seconds.
	private _reactionThreshold = if (_delayType == "reaction" && { typeName _delayValue == "SCALAR" }) then { _delayValue } else { 3.9 };
	private _reactionSustainSeconds = 30;
	private _reactionStreak = 0;
	private _timerValue = if (_delayType == "timer" && { typeName _delayValue == "SCALAR" }) then { _delayValue } else { 600 };

	private _currentTime = 0;
	private _reasonEnemyPresence = false;

	sleep 5;
	{ _x disableAI "ALL" } forEach units _group;

	waitUntil {
		sleep 10;
		_currentTime = _currentTime + 10;

		private _manualTrigger = _vehicle getVariable ["Inactive_VehicleSpawn", false];

		private _delayTrigger = switch (_delayType) do {
			case "condition": { call _conditionCode };
			case "reaction": {
				private _sideAware = false;
				{
					private _player = _x;
					private _maxKnowledge = 0;
					{
						if (side _x == _side && { !(_x in units _group) }) then {
							private _knowledge = _x knowsAbout _player;
							if (_knowledge > _maxKnowledge) then { _maxKnowledge = _knowledge };
						};
					} forEach allUnits;
					if (_maxKnowledge > _reactionThreshold) exitWith { _sideAware = true };
				} forEach allPlayers;

				_reactionStreak = if (_sideAware) then { _reactionStreak + 1 } else { 0 };
				_reasonEnemyPresence = _reactionStreak >= _reactionSustainSeconds;
				_reasonEnemyPresence
			};
			default { _currentTime >= _timerValue };
		};

		!alive _vehicle || _manualTrigger || _delayTrigger
	};

	if (!alive _vehicle) exitWith {};
	if ({ alive _x && { [_x] call ace_common_fnc_isAwake } } count units _group == 0) exitWith {};

	if (_reasonEnemyPresence) then {
		systemChat "Crew Activated by Enemy Presence.";
	} else {
		systemChat "Crew Activated.";
	};
	_vehicle engineOn true;
	_vehicle lock false;
	{ _x enableAI "ALL" } forEach units _group;

	sleep (random [10,15,20]);

	// Initiate Action
	switch (_action) do {

		case "hunt": {
			/*
				* Arguments:
				* 0: Group performing action, either unit <OBJECT> or group <GROUP>
				* 1: Range of tracking, default is 500 meters <NUMBER>
				* 2: Delay of cycle, default 15 seconds <NUMBER>
				* 3: Area the AI Camps in, default [] <ARRAY>
				* 4: Center Position, if no position or Empty Array is given it uses the Group as Center and updates the position every Cycle, default [] <ARRAY>
				* 5: Only Players, default true <BOOL>
				* 6: enable dynamic reinforcement <BOOL>
				* 7: Enable Flare <BOOL> or <NUMBER> where 0 disabled, 1 enabled (if Units cant fire it them self a flare is created via createVehicle), 2 Only if Units can Fire UGL them self
			*/
			waitUntil { sleep 1; !(isNil "lambs_wp_fnc_taskHunt") };
			[_group, _range, 30, [], [], true, false, false] remoteExec ["lambs_wp_fnc_taskHunt", 0];
		};

		case "patrol": {
			private _area = createTrigger ["EmptyDetector", getPos _vehicle];
			_area setTriggerArea [_range, _range, 0, false];
			[_area, _group, 4] spawn OKS_fnc_Vehicle_Waypoints;
		};

		case "move": {
			private _movePos = switch (typeName _movePosition) do {
				case "OBJECT": { getPosATL _movePosition };
				case "STRING": { getMarkerPos _movePosition };
				default { _movePosition };
			};
			private _wp = _group addWaypoint [_movePos, 0];
			_wp setWaypointType "SAD";
			_wp setWaypointBehaviour _moveBehaviour;
		};

		default {
			private _currentDriver = driver _vehicle;
			if (!isNull _currentDriver) then {
				[[_currentDriver], { params ["_unit"]; _unit disableAI "PATH"; doStop _unit; }] remoteExec ["BIS_fnc_call", 0];
				_vehicle engineOn true;
			};
		};
	};
};

_vehicle
