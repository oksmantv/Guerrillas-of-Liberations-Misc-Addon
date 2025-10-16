/*
	Params:
	1 - Object - Spawn Position
	2 - Object - First Waypoint
	3 - Object - Final Waypoint (Where they spread out in the area)
	4 - Side
	5 - Vehicle Array
		1 - Integer - Count of Vehicles
		2 - Array of Classnames or String
		3 - Integer M/S Speed
		4 - Dispersion
	6 - Troop Array
		1 - Bool - Should spawn troop in cargo
		2 - Integer - Max Number of Soldiers per vehicle
	7 - Convoy Array (Array that gets filled with convoy units)
	8 - Should be forced to careless (No reaction from Convoy)
	9 - Should be deleted on reaching final waypoint
	10 - Dismount Behaviour - Array of Types of waypoints for dismounts
	Options: ["rush", "defend", "patrol", "assault", "hunt"]
		Default: ["rush"]

	[convoy_1,convoy_2,convoy_3,east,[4,["rhs_btr60_msv"], 6, 25],[true,6],[], false, false] spawn OKS_fnc_Convoy_Spawn;
*/

if(!isServer) exitWith {};

Params [
	["_Spawn",objNull,[objNull]],
	["_Waypoint",objNull,[objNull,[]]],
	["_End",objNull,[objNull]],
	["_Side",east,[sideUnknown]],
	["_VehicleParams",[],[[]]],
	["_CargoParams",[],[[]]],
	["_ConvoyGroupArray",[],[[]]],
	["_ForcedCareless",false,[false]],
	["_DeleteAtFinalWP",false,[false]],
	["_DismountBehaviour", ["rush"], [[]]]
];

Private ["_Vehicles", "_Classname"];
private _VehicleArray = [];
private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug", false];
private _NextPreferLeft = true;

_VehicleParams Params [
	["_Count", 4, [0]], 
	["_Vehicles",["UK3CB_ARD_O_BMP1"],[[]]], 
	["_SpeedKph", 35, [0]], 
	["_DispersionInMeters", 50, [0]]
];
_CargoParams Params [
	["_ShouldHaveCargo", true, [false]],
	["_CargoCount", 4, [0]]
];
if (isNil "_ConvoyGroupArray") then {
	_ConvoyGroupArray = [];
};


private _ReserveQueue = [];
for "_i" from 0 to ((_Count - 1) + 4) do {

	if(_i >= _Count) then {
		_herringBoneResult = [_End, false, _NextPreferLeft, true] call OKS_fnc_Convoy_SetupHerringBone;
		private _endPosition = if (_herringBoneResult isEqualType []) then { _herringBoneResult select 0 } else { getPos _End };
		private _actualIsLeft = if (_herringBoneResult isEqualType [] && {count _herringBoneResult > 1}) then { _herringBoneResult select 1 } else { _NextPreferLeft };
		_NextPreferLeft = !_actualIsLeft;

		// Check for duplicate positions (road capacity exceeded)
		private _isDuplicate = false;
		{
			_x params ["_existingPos", "_occupied"];
			if (_endPosition distance _existingPos < 5) exitWith {
				_isDuplicate = true;
			};
		} forEach _ReserveQueue;

		if (_isDuplicate) then {
			if (_ConvoyDebug) then {
				format ["[WARNING] Convoy cannot fit on end waypoint road. Reduce vehicles or pick a longer stretch of road. Position: %1", _endPosition] spawn OKS_fnc_LogDebug;
			};
		} else {
			_ReserveQueue pushBack [_endPosition, false]; // [position, isOccupied]
			// Debug: Log reserve position creation
			if (_ConvoyDebug) then {
				format ["[CONVOY-SPAWN] Created reserve position %1 at %2 (left: %3)", count _ReserveQueue - 1, _endPosition, _actualIsLeft] spawn OKS_fnc_LogDebug;
			};
		};

		continue;
	};

	waitUntil {
		sleep 1;
		if (_ConvoyDebug) then {
			"[CONVOY-WAIT-CLEARANCE] near _Spawn" spawn OKS_fnc_LogDebug;
		};
		(getPos _Spawn nearEntities ["LandVehicle", _DispersionInMeters]) isEqualTo []
	};
	if (_ConvoyDebug) then {
		"[CONVOY-SPAWN] Vehicle spawning" spawn OKS_fnc_LogDebug;
	};

	if (_Vehicles isNotEqualTo []) then {
		_Classname = _Vehicles select 0;
		_Vehicles deleteAt 0;
		if (_ConvoyDebug) then {
			format ["[CONVOY-VEHICLE-CLASS] %1 Remaining: %2", _Classname, _Vehicles] spawn OKS_fnc_LogDebug;
		}
	};
	_Vehicle = CreateVehicle [_Classname, getPos _Spawn];
	_Vehicle setVariable ["OKS_ForceSpeedActive", true, true];
	_Vehicle setVariable ["OKS_LimitSpeedBase", _SpeedKph, true];
	_Vehicle setDir (getDir _Spawn);
	_Vehicle setVehicleLock "LOCKED";
	_VehicleArray pushBack _Vehicle;

	private _PreviousVehicle = objNull;
	private _CargoGroup = grpNull;
	if (count _VehicleArray > 1) then {
		_PreviousVehicle = _VehicleArray select (_i - 1);
	};
	// Set immediate leader for formation following (objNull for front vehicle)
	_Vehicle setVariable ["OKS_Convoy_ImmediateLeader", _PreviousVehicle, true];
	// Debug variables for troubleshooting
	_Vehicle setVariable ["DEBUG_SpawnImmediateLeader", _PreviousVehicle, true];
	_Vehicle setVariable ["DEBUG_LastUpdated", time, true];
	[_Vehicle, _PreviousVehicle, _DispersionInMeters] spawn OKS_fnc_Convoy_CheckAndAdjustSpeeds;

	_Group = createGroup [_Side, true];
	_CargoGroup = createGroup [_Side, true];
	if (_ConvoyDebug) then {
		format ["[CONVOY-GROUP] %1 Side: %2", _Group, _Side] spawn OKS_fnc_LogDebug;
	};

	private _crewSlots = 0;
	if ((_Vehicle emptyPositions "driver" > 0) && (_Vehicle emptyPositions "gunner" == 0) && (_Vehicle emptyPositions "commander" == 0)) then {
		_crewSlots = 1;
	};

	private _addCargoCommander = (_crewSlots == 1);
	_Group = [_Vehicle, _Side, _crewSlots, 0, true, _addCargoCommander] call OKS_fnc_AddVehicleCrew;
	_Vehicle limitSpeed _SpeedKph;
	_NewSpeedMps = _SpeedKph / 3.6;
	_Vehicle forceSpeed _NewSpeedMps;

	_Group setBehaviour "CARELESS";
	_Group setCombatMode "BLUE";
	private _waypointObject = _Waypoint;
	private _waypointGroup = _Group;
	private _waypointArray = [];
	if(typeName _Waypoint isEqualTo "ARRAY") then {
		_waypointArray = _Waypoint;
	} else {
		_waypointArray = [_Waypoint];
	};

	{
		private _waypoint = _waypointGroup addWaypoint [getPos _waypointObject, 0];
		_waypoint setWaypointType "MOVE";
	} foreach _waypointArray;

	private _isFirstVehicle = (_i == 0);
	private _herringBoneResult = [_End, _isFirstVehicle, _NextPreferLeft] call OKS_fnc_Convoy_SetupHerringBone;
	private _endPosition = if (_herringBoneResult isEqualType []) then { _herringBoneResult select 0 } else { getPos _End };
	private _actualIsLeft = if (_herringBoneResult isEqualType [] && {count _herringBoneResult > 1}) then { _herringBoneResult select 1 } else { _NextPreferLeft };
	_NextPreferLeft = !_actualIsLeft;

	private _endWaypointGroup = _Group;
	private _endWaypoint = _endWaypointGroup addWaypoint [_endPosition, 1];
	_endWaypoint setWaypointType "MOVE";
	// Tag end waypoint to suppress dispersion increase near destination (waypoint-level indicator)
	_endWaypoint setWaypointDescription "OKS_SUPPRESS_DISPERSION";

	if (_DeleteAtFinalWP) then {
		_endWaypoint setWaypointCompletionRadius 200;
		_endWaypoint setWaypointStatements ["true", "{ _unit = this; if(_unit != _X) then {deleteVehicle _X}}foreach crew (vehicle this); deleteVehicle (objectParent this); deleteVehicle (this); "];
	} else {
		_endWaypoint setWaypointCompletionRadius 2;
		_endWaypoint setWaypointStatements ["true", "{_x setBehaviour 'COMBAT'; _x setCombatMode 'RED';} foreach units this; (vehicle this) setVariable ['OKS_Convoy_Stopped', true, true];"];
	};

	// Check if vehicle type contains any blacklisted strings
	_Blacklist = ["zu23"];
	private _vehicleType = toLower (typeOf _Vehicle);
	private _isBlacklisted = false;
	{
		if (_vehicleType find (toLower _x) >= 0) exitWith {
			_isBlacklisted = true;
		};
	} forEach _Blacklist;
	
    if(_ShouldHaveCargo && !_isBlacklisted) then {
		_CargoGroup = [_Vehicle, _Side, -1, _CargoCount, true] call OKS_fnc_AddVehicleCrew;
    };
	_CargoGroup setBehaviour "CARELESS"; _CargoGroup setCombatMode "BLUE";
    _ConvoyGroupArray pushBackUnique _Group; _ConvoyGroupArray pushBackUnique _CargoGroup;

	if(_ForcedCareless) then {
		_Vehicle setCaptive true;
		{_X setCaptive true; _X setBehaviour "CARELESS"; _X setCombatMode "BLUE"; } foreach units _Group;
		{_X setCaptive true; _X setBehaviour "CARELESS"; _X setCombatMode "BLUE"; } foreach units _CargoGroup;
		_Vehicle setBehaviour "CARELESS"; _Vehicle setCombatMode "BLUE";
	} else {
		[_Vehicle, _Group, _CargoGroup, selectRandom _DismountBehaviour] spawn OKS_fnc_Convoy_WaitUntilCombat;
	};

	{[_x] remoteExec ["GW_SetDifficulty_fnc_setSkill",0]} foreach units _Group;
	{[_x] remoteExec ["GW_SetDifficulty_fnc_setSkill",0]} foreach units _CargoGroup; 
};

_LeadVehicle = _VehicleArray select 0;
{
	_x setVariable ["OKS_Convoy_FrontLeader", _LeadVehicle, true];
	_x setVariable ["OKS_Convoy_VehicleArray", _VehicleArray, true];
} forEach _VehicleArray;


[_LeadVehicle] call OKS_fnc_Convoy_InitIntendedSlots;
_primarySlots = _LeadVehicle getVariable ["OKS_Convoy_PrimarySlotCount", count _VehicleArray];
_reserveSlots = count _ReserveQueue;
_endPos = _End;

// Publish the final reserve queue to all vehicles (only once, after loop)
{
	_x setVariable ["OKS_Convoy_ReserveQueue", _ReserveQueue, true];
} forEach _VehicleArray;

// Debug: Log final reserve queue
if (_ConvoyDebug) then {
	private _debugQueue = [];
	{
		_x params ["_pos", "_occupied"];
		_debugQueue pushBack format ["Index %1: %2", _forEachIndex, _pos];
	} forEach _ReserveQueue;
	format ["[CONVOY-SPAWN] Final reserve queue (%1 positions): %2", count _ReserveQueue, _debugQueue joinString " | "] spawn OKS_fnc_LogDebug;
};

//[_LeadVehicle, _ReserveQueue] spawn OKS_fnc_Convoy_MonitorReserveActivation;
//[_LeadVehicle, _endPos, _primarySlots, _reserveSlots] spawn OKS_fnc_Convoy_LeadArrivalMonitor;
[_VehicleArray] spawn OKS_fnc_Convoy_WaitUntilCasualties;
[_VehicleArray] spawn OKS_fnc_Convoy_WaitUntilTargets;

// Only start air defense if dedicated AA vehicles (without cargo seats) are available
private _dedicatedAACount = [_VehicleArray] call OKS_fnc_Convoy_CheckDedicatedAAAvailable;
if (_dedicatedAACount > 0) then {
	if (_ConvoyDebug) then {
		format [
			"[CONVOY-SPAWN] Starting air defense system with %1 dedicated AA vehicles",
			_dedicatedAACount
		] spawn OKS_fnc_LogDebug;
	};
	
	// Wait for cargo loading to complete before starting AA system
	if (_ShouldHaveCargo) then {
		if (_ConvoyDebug) then {
			"[CONVOY-SPAWN] Waiting for cargo loading completion before starting AA system" spawn OKS_fnc_LogDebug;
		};
		sleep 3; // Allow cargo loading to complete
	};
	
	// Initialize AA availability states for all vehicles
	{
		_x setVariable ["OKS_AA_Available", true, true];
	} forEach _VehicleArray;
	
	[_VehicleArray] spawn OKS_fnc_Convoy_WaitUntilAirTarget;
} else {
	if (_ConvoyDebug) then {
		"[CONVOY-SPAWN] No dedicated AA vehicles available. Air defense system disabled for this convoy." spawn OKS_fnc_LogDebug;
	};
};

{
	deleteVehicle _x
} forEach (nearestObjects [_End, ["Land_ClutterCutter_large_F"], 500] select {
	_x getVariable ["GOL_Convoy_Cutter", false]
});