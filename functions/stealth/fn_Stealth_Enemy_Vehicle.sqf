/*
	Function: OKS_fnc_Stealth_Enemy_Vehicle
	
	Description:
	Monitors vehicle crews for player detection and triggers hunt responses.
	When a crew member detects a player, the vehicle radios for support and fires a flare.
	Only applies to actual crew members (driver, gunner, commander), not passengers.
	
	Parameter(s):
	0: OBJECT - Vehicle to monitor
	1: SIDE - Side of the vehicle (default: east)
	2: BOOL - Should set nearby groups to hunt (default: false)
	3: NUMBER - Range to find hunter groups (default: 500)
	4: NUMBER - Hunt tracking range (default: 500)
	5: STRING (Optional) - Variable name to set to true when player detected
	
	Returns:
	Nothing
	
	Example:
	[_vehicle, east, true, 1000, 500] spawn OKS_fnc_Stealth_Enemy_Vehicle;
	[_vehicle, independent, true, 800, 600, "Hunt_1"] spawn OKS_fnc_Stealth_Enemy_Vehicle;
*/

if (!isServer) exitWith {};

params [
	["_Vehicle", objNull, [objNull]],
	["_Side", east, [sideUnknown]],
	["_ShouldSetNearbyToHunt", false, [true]],
	["_NearbyHunterRange", 500, [0]],
	["_HuntRange", 500, [0]],
	["_Variable", nil, [""]]
];

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];

// Validation
if (isNull _Vehicle) exitWith {
	if (_debug) then {
		"[STEALTH] Vehicle is null, exiting" spawn OKS_fnc_LogDebug;
	};
};

// Check if already applied to this vehicle
if (_Vehicle getVariable ["OKS_Vehicle_Alert_Applied", false]) exitWith {
	if (_debug) then {
		format ["[STEALTH] Vehicle alert already applied to %1, exiting", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
};

// Set flag on vehicle
_Vehicle setVariable ["OKS_Vehicle_Alert_Applied", true, true];

if (_debug) then {
	format ["[STEALTH] Vehicle alert initialized for %1 (Side: %2)", typeOf _Vehicle, _Side] spawn OKS_fnc_LogDebug;
};

// Get actual crew members (exclude cargo passengers)
private _GetCrewMembers = {
	params ["_veh"];
	private _crewList = [];
	{
		private _role = assignedVehicleRole _x;
		if (count _role > 0) then {
			private _roleType = _role select 0;
			if (_roleType in ["driver", "gunner", "commander", "turret"]) then {
				_crewList pushBack _x;
			};
		};
	} forEach crew _veh;
	_crewList
};

// Set flag on all crew members
private _initialCrew = [_Vehicle] call _GetCrewMembers;
{
	_x setVariable ["OKS_Vehicle_Crew_Applied", true, true];
} forEach _initialCrew;

if (_debug) then {
	format ["[STEALTH] Monitoring %1 crew members in %2", count _initialCrew, typeOf _Vehicle] spawn OKS_fnc_LogDebug;
};

// Wait for any crew member to detect a player
waitUntil {
	sleep 2;
	
	// Exit if vehicle destroyed
	if (!alive _Vehicle || damage _Vehicle >= 1) exitWith {
		if (_debug) then {
			format ["[STEALTH] Vehicle %1 destroyed, exiting alert script", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
		};
		true
	};
	
	private _currentCrew = [_Vehicle] call _GetCrewMembers;
	
	// Exit if no crew members alive
	if (count _currentCrew == 0) exitWith {
		if (_debug) then {
			format ["[STEALTH] Vehicle %1 has no crew, exiting alert script", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
		};
		true
	};
	
	// Check if any crew member has detected a player
	private _detected = false;
	{
		private _crewMember = _x;
		{
			if (_crewMember knowsAbout _x > 3.99) exitWith {
				_detected = true;
			};
		} forEach allPlayers;
		if (_detected) exitWith {};
	} forEach _currentCrew;
	
	_detected
};

// Exit early if vehicle was destroyed or has no crew
if (!alive _Vehicle || damage _Vehicle >= 1) exitWith {};
private _currentCrew = [_Vehicle] call _GetCrewMembers;
if (count _currentCrew == 0) exitWith {};

diag_log format ["OKS Stealth: Vehicle %1 crew detected player", typeOf _Vehicle];

// Determine sound based on nationality setting
private _Nationality = missionNamespace getVariable ["GOL_OKS_Enemy_Nationality", "russian"];
private _SoundFolder = "";

switch (_Nationality) do {
	case "russian": {
		_SoundFolder = "russian";
	};
	case "arabic": {
		_SoundFolder = "arabic";
	};
	case "vietnamese": {
		_SoundFolder = "vietnamese";
	};
	default {
		_SoundFolder = "russian";
	};
};

// 10 second delay before calling for support
sleep 10;

// Final check: vehicle alive, not destroyed, and at least one crew member alive and conscious
if (!alive _Vehicle || damage _Vehicle >= 1) exitWith {
	if (_debug) then {
		format ["[STEALTH] Vehicle %1 destroyed during delay, exiting", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
};

private _finalCrew = [_Vehicle] call _GetCrewMembers;
private _hasConsciousCrew = false;
private _consciousCrew = objNull;

{
	if (alive _x && [_x] call ace_common_fnc_isAwake) exitWith {
		_hasConsciousCrew = true;
		_consciousCrew = _x;
	};
} forEach _finalCrew;

if (!_hasConsciousCrew) exitWith {
	if (_debug) then {
		format ["[STEALTH] Vehicle %1 has no conscious crew, cannot call for support", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
};

// Check if crew is still in vehicle
if (vehicle _consciousCrew != _Vehicle) exitWith {
	if (_debug) then {
		format ["[STEALTH] Crew member %1 not in vehicle, cannot use radio", _consciousCrew] spawn OKS_fnc_LogDebug;
	};
};

if (_debug) then {
	format ["[STEALTH] Vehicle %1 calling for reinforcements", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
};

// Radio call for reinforcements (250m range)
private _RadioFileName = "";
private _LastSound = _Vehicle getVariable ["OKS_Last_Call_Sound", ""];

switch (_Nationality) do {
	case "russian": {
		private _RandomNum = floor(random 3) + 1;
		_RadioFileName = "ru-call-" + str _RandomNum;
		// Prevent same sound twice in a row
		while { _RadioFileName == _LastSound } do {
			_RandomNum = floor(random 3) + 1;
			_RadioFileName = "ru-call-" + str _RandomNum;
		};
	};
	case "arabic": {
		// Arabic radio calls not yet implemented
		_RadioFileName = "";
	};
	case "vietnamese": {
		private _RandomNum = floor(random 5) + 1;
		_RadioFileName = "vn-call-" + str _RandomNum;
		// Prevent same sound twice in a row
		while { _RadioFileName == _LastSound } do {
			_RandomNum = floor(random 5) + 1;
			_RadioFileName = "vn-call-" + str _RandomNum;
		};
	};
	default {
		private _RandomNum = floor(random 3) + 1;
		_RadioFileName = "ru-call-" + str _RandomNum;
		// Prevent same sound twice in a row
		while { _RadioFileName == _LastSound } do {
			_RandomNum = floor(random 3) + 1;
			_RadioFileName = "ru-call-" + str _RandomNum;
		};
	};
};

_Vehicle setVariable ["OKS_Last_Call_Sound", _RadioFileName, true];

if (_RadioFileName != "") then {
	playSound3D [format ["\OKS_GOL_Misc\Sounds\Talk\%1\%2.wav", _SoundFolder, _RadioFileName], _Vehicle, false, getPosASL _Vehicle, 5, 1, 250];
};

// Set optional variable to true
if (!isNil "_Variable") then {
	diag_log format ["OKS Stealth: %1 set to true", _Variable];
	call compile format ["%1 = true;
	publicVariable '%1'", _Variable];
};

// Activate nearby hunter groups (same as sentry system)
if (_ShouldSetNearbyToHunt isEqualType _Side) exitWith {
	diag_log format ["OKS Stealth: Broken variables for vehicle: %1. Exiting..", typeOf _Vehicle];
};

if (!(isNil "lambs_wp_fnc_taskHunt") && _ShouldSetNearbyToHunt) then {
	private _EnemyGroups = [];
	{
		if (side _x == _Side && leader _x distance2D _Vehicle < _NearbyHunterRange) then {
			_EnemyGroups pushBackUnique _x
		}
	} forEach allGroups;

	{
		if (!(_x getVariable ["LAMBS_HUNTING", false]) && !(_x getVariable ["GOL_IsStatic", false])) then {
			_x setVariable ["LAMBS_HUNTING", true, true];
			_x setBehaviour "AWARE";
			_x setSpeedMode "FULL";
			{
				[_x, "FSM"] remoteExec ["disableAI", 0]
			} forEach units _x;
			[_x, _HuntRange, 15, [], getPos _Vehicle, true, false, true] remoteExec ["lambs_wp_fnc_taskHunt", 0];
		};
	} forEach _EnemyGroups;
} else {
	private _EnemyGroups = [];
	{
		if (side _x == _Side &&
		leader _x distance2D _Vehicle < _NearbyHunterRange &&
		!(_x getVariable ["LAMBS_HUNTING", false]) &&
		!(_x getVariable ["GOL_IsStatic", false])) then {
			_EnemyGroups pushBackUnique _x
		}
	} forEach allGroups;

	{
		if (!(_x getVariable ["LAMBS_HUNTING", false]) && !(_x getVariable ["GOL_IsStatic", false])) then {
			private _Group = _x;
			_Group setVariable ["LAMBS_HUNTING", true, true];
			_Group setBehaviour "AWARE";
			_Group setSpeedMode "FULL";
			{
				_x disableAI "FSM";
				_x enableAttack false
			} forEach units _Group;

			diag_log format ["OKS Stealth: %1 responding to vehicle alert from %2", _Group, typeOf _Vehicle];

			while { (count (waypoints _Group)) > 0 } do {
				deleteWaypoint ((waypoints _Group) select 0);
			};

			private _DetectedPlayer = selectRandom (allPlayers select {
				(getPos _Vehicle) distance _x < 200 && _Side knowsAbout _x > 3.5
			});

			if (isNil "_DetectedPlayer") then {
				_DetectedPlayer = _consciousCrew
			};

			private _WP = _Group addWaypoint [getPos _DetectedPlayer, 30];
			_WP setWaypointBehaviour "AWARE";
			_WP setWaypointSpeed "FULL";

			// Flare - spawn below aircraft or at standard height
			private _Position = getPosATL _Vehicle;
			private _FlareHeight = 140;
			
			if (_Vehicle isKindOf "Air") then {
				// For aircraft, spawn flare a few meters below
				_FlareHeight = ((_Position select 2) - 10) max 0;
			} else {
				_FlareHeight = (_Position select 2) + 140;
			};
			
			private _Temp = createVehicle ["F_40mm_Red", [(_Position select 0), (_Position select 1), _FlareHeight], [], 20, "CAN_COLLIDE"];
			_Temp setVelocity [0, 0, -10];
			sleep 3;
			playSound3D ["A3\Sounds_F\weapons\Flare_Gun\flaregun_2_shoot.wss", _Vehicle, false, [(_Position select 0), (_Position select 1), (_Position select 2)], 8, 1, 300];
			_Group setVariable ["OKS_isTracking", true, true];

			[_Group, _WP, _DetectedPlayer, _NearbyHunterRange] spawn {
				params ["_Group", "_WP", "_DetectedPlayer", "_NearbyHunterRange"];
				waitUntil {
					sleep 5;
					{
						_x distance (getWPPos _WP) < 25
					} count units _Group > 0
				};

				[_Group, getPos _DetectedPlayer, _NearbyHunterRange, 5, [], true, true] call lambs_wp_fnc_taskPatrol;
				_Group setVariable ["OKS_isTracking", false, true];
			};
		}
	} forEach _EnemyGroups;
};
