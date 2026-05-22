/*
	OKS_fnc_Convoy_TaskTracker

	Creates and dynamically maintains a BIS task tied to a convoy.
	- Task description is generated from force composition (vehicle tier, count,
	  unit count) and the heaviest asset's display name.
	- End-point is geolocated against the nearest named location.
	- Task position silently follows the convoy's current front leader.
	- Condition enum controls title, icon, and completion logic.

	Designed to be used with CALL, not spawn. The task is created synchronously;
	the monitoring loop is spawned internally. Returns the task ID string.

	Params:
	1 - Array  - Vehicle array (live convoy vehicles, shared reference)
	2 - Array  - Task array: [taskParent, showPosition, showNotification, taskCondition]
	             taskParent      : String (parent task id, may be "" for none)
	             showPosition    : Bool   (show task marker on map)
	             showNotification: Bool   (notification on create / final state)
	             taskCondition   : String ("destroy" | "intercept")
	3 - Object - End waypoint object (used for geolocation)
	4 - Array  - Convoy group array (all groups created by the convoy, used for accurate unit counting)
	5 - String - (Optional) Pre-generated task ID. Pass from OKS_fnc_Convoy_Spawn so the
	             caller receives the ID before the convoy body runs. Leave "" to auto-generate.

	Returns:
		String - The BIS task ID. Task is created before this function returns.
		Monitoring loop runs in a separate thread.

	Example:
	private _taskId = [_VehicleArray, ["", true, true, "destroy"], _End, _ConvoyGroupArray] call OKS_fnc_Convoy_TaskTracker;
	waitUntil { sleep 5; taskState _taskId in ["SUCCEEDED", "FAILED"] };
*/

if (!isServer) exitWith { "" };

params [
	["_VehicleArray", [], [[]]],
	["_TaskArray", [], [[]]],
	["_EndObject", objNull, [objNull]],
	["_ConvoyGroupArray", [], [[]]],
	["_PresetTaskId", "", [""]]
];

if (_VehicleArray isEqualTo []) exitWith { "" };
if (isNull _EndObject) exitWith { "" };

_TaskArray params [
	["_TaskParent", "", [""]],
	["_ShowPosition", true, [false]],
	["_ShowNotification", false, [false]],
	["_TaskCondition", "destroy", [""]]
];

_TaskCondition = toLower _TaskCondition;

// --- Helpers ---------------------------------------------------------------

private _fnc_aliveVehicles = {
	_VehicleArray select { alive _x }
};

// Count all alive units across every convoy group (crew + cargo + dismounted).
// Using _ConvoyGroupArray instead of crew _x because:
//   - crew _x excludes cargo passengers
//   - after dismount, infantry leave vehicles but stay in their group
private _fnc_aliveCrewCount = {
	private _totalAlive = 0;
	{
		if (!isNull _x) then {
			{ if (alive _x) then { _totalAlive = _totalAlive + 1 }; } forEach (units _x);
		};
	} forEach _ConvoyGroupArray;
	_totalAlive
};

private _fnc_sizeLabel = {
	params ["_unitCount"];
	switch (true) do {
		case (_unitCount < 8):  { "Fire Team" };
		case (_unitCount < 21): { "Squad" };
		case (_unitCount < 46): { "Platoon" };
		case (_unitCount < 91): { "Company" };
		default                 { "Battalion Element" };
	};
};

private _fnc_vehicleCountLabel = {
	params ["_vehicleCount"];
	switch (true) do {
		case (_vehicleCount < 3): { "small element" };
		case (_vehicleCount < 7): { "vehicle column" };
		default                   { "convoy" };
	};
};

// Tier + heaviest asset (Tank > APC > any). Returns [tierPrefix, heaviestVehicle].
private _fnc_resolveTier = {
	private _heaviestTank = objNull;
	private _heaviestApc  = objNull;
	{
		if (alive _x) then {
			if (isNull _heaviestTank && {_x isKindOf "Tank"}) then { _heaviestTank = _x; };
			if (isNull _heaviestApc  && {_x isKindOf "APC"})  then { _heaviestApc  = _x; };
		};
	} forEach _VehicleArray;

	if (!isNull _heaviestTank) exitWith { ["Armored",    _heaviestTank] };
	if (!isNull _heaviestApc)  exitWith { ["Mechanized", _heaviestApc] };

	private _firstAliveVehicle = (_VehicleArray select { alive _x }) param [0, objNull];
	if (isNull _firstAliveVehicle) exitWith { ["", objNull] };
	["", _firstAliveVehicle]
};

private _fnc_displayName = {
	params ["_vehicle"];
	if (isNull _vehicle) exitWith { "unknown asset" };
	getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName")
};

// Geolocation string for end position.
// Searches settlements and airfields separately, picks the closest match,
// and formats the proximity string based on type.
private _fnc_locationString = {
	params ["_pos"];

	private _settlementLocs = nearestLocations [_pos, ["NameVillage","NameCity","NameCityCapital","NameLocal","Name","fakeTown"], 2000];
	private _airportLocs    = nearestLocations [_pos, ["Airport"], 3000];

	private _bestName     = "";
	private _bestDist     = 999999;
	private _bestIsAirport = false;

	if (_settlementLocs isNotEqualTo []) then {
		private _nearestSettlement = _settlementLocs select 0;
		private _settlementDist = _pos distance2D (locationPosition _nearestSettlement);
		if (_settlementDist < _bestDist) then {
			_bestName      = text _nearestSettlement;
			_bestDist      = _settlementDist;
			_bestIsAirport = false;
		};
	};

	if (_airportLocs isNotEqualTo []) then {
		private _nearestAirport = _airportLocs select 0;
		private _airportDist = _pos distance2D (locationPosition _nearestAirport);
		if (_airportDist < _bestDist) then {
			_bestName      = text _nearestAirport;
			_bestDist      = _airportDist;
			_bestIsAirport = true;
		};
	};

	if (_bestName isEqualTo "") exitWith { format ["grid %1", mapGridPosition _pos] };

	if (_bestIsAirport) then {
		switch (true) do {
			case (_bestDist < 500):  { format ["%1 Airfield", _bestName] };
			default                  { format ["near %1 Airfield", _bestName] };
		};
	} else {
		switch (true) do {
			case (_bestDist < 250):  { format ["the village of %1", _bestName] };
			case (_bestDist < 500):  { format ["outside %1", _bestName] };
			case (_bestDist < 1000): { format ["the outskirts of %1", _bestName] };
			default                  { format ["near the village of %1", _bestName] };
		};
	};
};

// --- Compose initial description ------------------------------------------

private _endPos = getPos _EndObject;
private _locString = [_endPos] call _fnc_locationString;

private _aliveCrew = call _fnc_aliveCrewCount;
private _sizeLabel = [_aliveCrew] call _fnc_sizeLabel;

private _vehAlive = call _fnc_aliveVehicles;
private _vehCountLabel = [count _vehAlive] call _fnc_vehicleCountLabel;

(call _fnc_resolveTier) params ["_tierPrefix", "_heaviest"];
private _heaviestName = [_heaviest] call _fnc_displayName;

private _aaArray = (_VehicleArray select 0) getVariable ["OKS_Convoy_AAArray", []];
private _aaSuffix = if (count _aaArray > 0) then { ", including air defense assets" } else { "" };

// Force label: "Armored Platoon" / "Mechanized Squad Vehicle Column" / "Squad Convoy"
private _forceLabel = "";
if (_tierPrefix isEqualTo "") then {
	_forceLabel = format ["%1 %2", _sizeLabel, _vehCountLabel];
} else {
	_forceLabel = format ["%1 %2", _tierPrefix, _sizeLabel];
};

// Title: "Armored Convoy", "Intercept Mechanized Convoy", "Convoy" etc.
private _convoyTypeLabel = if (_tierPrefix isEqualTo "") then { "Convoy" } else { format ["%1 Convoy", _tierPrefix] };
private _title = "";
private _icon  = "";
switch (_TaskCondition) do {
	case "intercept": {
		_title = format ["Intercept %1", _convoyTypeLabel];
		_icon  = "run";
	};
	default {
		_TaskCondition = "destroy";
		_title = _convoyTypeLabel;
		_icon  = "target";
	};
};

// Use "An" before vowel-starting tier prefixes (e.g. "An armored platoon")
private _article = if (_tierPrefix isEqualTo "") then { "A" } else {
	private _firstChar = toLower (_tierPrefix select [0, 1]);
	if (_firstChar in ["a","e","i","o","u"]) then { "An" } else { "A" }
};
private _verb = if (_TaskCondition == "intercept") then { "Intercept" } else { "Destroy" };
private _description = format [
	"%1 %2, spearheaded by a %3, is moving toward %4%5. %6 the convoy before it reaches its destination.",
	_article, toLower _forceLabel, _heaviestName, _locString, _aaSuffix, _verb
];

// --- Create task ----------------------------------------------------------

private _taskId = if (_PresetTaskId isEqualTo "") then {
	format ["OKS_ConvoyTask_%1_%2", round (random 99999), round (diag_tickTime * 1000)]
} else { _PresetTaskId };
private _taskData = if (_TaskParent isEqualTo "") then { _taskId } else { [_taskId, _TaskParent] };

private _initialPos = if (!isNull _heaviest) then { getPos _heaviest } else { _endPos };

[
	true,
	_taskData,
	[_description, _title, _title],
	_initialPos,
	"AUTOASSIGNED",
	-1,
	_ShowNotification,
	_icon,
	_ShowPosition
] call BIS_fnc_taskCreate;

// --- Tracking loop (spawned — runs in its own thread) ----------------------

[_taskId, _VehicleArray, _ConvoyGroupArray, _TaskCondition, _ShowNotification, _locString, _aaSuffix,
_fnc_aliveVehicles, _fnc_aliveCrewCount, _fnc_sizeLabel, _fnc_resolveTier, _fnc_displayName] spawn {
params [
	"_taskId", "_VehicleArray", "_ConvoyGroupArray", "_TaskCondition",
	"_ShowNotification", "_locString", "_aaSuffix",
	"_fnc_aliveVehicles", "_fnc_aliveCrewCount", "_fnc_sizeLabel",
	"_fnc_resolveTier", "_fnc_displayName"
];

private _arrivalApplied = false;
private _lastTrackedPos = [];  // Only push position update when convoy moved meaningfully

while {true} do {
	private _aliveVehicles = _VehicleArray select { alive _x };
	private _crewAlive = call _fnc_aliveCrewCount;

	// Exit conditions per task type
	if (_TaskCondition == "destroy") then {
		if ((_aliveVehicles isEqualTo []) && (_crewAlive == 0)) exitWith {
			[_taskId, "SUCCEEDED", _ShowNotification] call BIS_fnc_taskSetState;
		};
	};

	if (_TaskCondition == "intercept") then {
		private _ambushedIndex = _VehicleArray findIf { _x getVariable ["GOL_ConvoyAmbushed", false] };
		private _anyDestroyed = (count _VehicleArray) > (count _aliveVehicles);
		if ((_ambushedIndex >= 0) || _anyDestroyed) exitWith {
			[_taskId, "SUCCEEDED", _ShowNotification] call BIS_fnc_taskSetState;
		};

		private _allStopped = (_VehicleArray isNotEqualTo []) && {(_VehicleArray findIf { !(_x getVariable ["OKS_Convoy_Stopped", false]) }) == -1};
		if (_allStopped) exitWith {
			[_taskId, "FAILED", _ShowNotification] call BIS_fnc_taskSetState;
		};
	};

	// Position priority: FrontLeader > first alive vehicle > first alive unit
	private _trackPos = [];
	private _frontLeaderVehicle = (_VehicleArray select 0) getVariable ["OKS_Convoy_FrontLeader", objNull];
	if (!isNull _frontLeaderVehicle && {alive _frontLeaderVehicle}) then {
		_trackPos = getPos _frontLeaderVehicle;
	} else {
		if (_aliveVehicles isNotEqualTo []) then {
			_trackPos = getPos (_aliveVehicles select 0);
		} else {
			private _aliveCrewUnit = objNull;
			{
				{ if (alive _x) exitWith { _aliveCrewUnit = _x; }; } forEach (crew _x);
				if (!isNull _aliveCrewUnit) exitWith {};
			} forEach _VehicleArray;
			if (!isNull _aliveCrewUnit) then { _trackPos = getPos _aliveCrewUnit; };
		};
	};

	if (_trackPos isNotEqualTo []) then {
		// Only update when convoy has moved >75m — prevents BIS task system from
		// spamming "task assigned" notifications on every position push.
		if (_lastTrackedPos isEqualTo [] || { _trackPos distance2D _lastTrackedPos > 75 }) then {
			_lastTrackedPos = _trackPos;
			[_taskId, _trackPos, false] call BIS_fnc_taskSetDestination;
		};
	};

	// Destroy-task arrival mutation (once)
	if ((_TaskCondition == "destroy") && (!_arrivalApplied)) then {
		private _allStopped = (_VehicleArray isNotEqualTo []) && {(_VehicleArray findIf { !(_x getVariable ["OKS_Convoy_Stopped", false]) }) == -1};
		if (_allStopped) then {
			_arrivalApplied = true;

			// Recompute heaviest in case original was destroyed
			(call _fnc_resolveTier) params ["_currentTierPrefix", "_currentHeaviestVehicle"];
			private _currentHeaviestName = [_currentHeaviestVehicle] call _fnc_displayName;
			private _currentSizeLabel = [call _fnc_aliveCrewCount] call _fnc_sizeLabel;

			private _eliminateTitle = if (_currentTierPrefix isEqualTo "") then {
				format ["Eliminate %1 — %2", _currentSizeLabel, _currentHeaviestName]
			} else {
				format ["Eliminate %1 %2 — %3", _currentTierPrefix, _currentSizeLabel, _currentHeaviestName]
			};

			private _newDescription = format [
				"The convoy has arrived at %1 and dismounted. Eliminate the remaining %2, spearheaded by a %3%4.",
				_locString,
				toLower (if (_currentTierPrefix isEqualTo "") then { _currentSizeLabel } else { format ["%1 %2", _currentTierPrefix, _currentSizeLabel] }),
				_currentHeaviestName,
				_aaSuffix
			];

			[_taskId, "danger"] call BIS_fnc_taskSetType;
			[_taskId, [_newDescription, _eliminateTitle, _eliminateTitle]] call BIS_fnc_taskSetDescription;
		};
	};

	sleep 5;
};
};

_taskId
