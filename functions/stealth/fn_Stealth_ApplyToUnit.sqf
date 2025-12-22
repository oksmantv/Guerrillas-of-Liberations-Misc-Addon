/*
	Function: OKS_fnc_Stealth_ApplyToUnit
	
	Description:
		Automatically applies appropriate stealth scripts to AI units based on their properties.
		- Static units (no waypoints or GOL_IsStatic = true) become sentries
		- Patrol units (with waypoints, not in vehicles) get tracker and talk scripts
		- Units with STEALTH behaviour are skipped
	
	Parameter(s):
		0: OBJECT - The unit to apply stealth scripts to
	
	Returns:
		BOOL - True if any stealth script was applied
	
	Example:
		[_unit] call OKS_fnc_Stealth_ApplyToUnit;
*/

if (!isServer && hasInterface) exitWith {false}; // Skip on clients, allow on server (even with interface) and HC

params [
	["_unit", objNull, [objNull]]
];

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];

if (_debug) then {
	format ["[STEALTH] ApplyToUnit called for %1 (group: %2)", _unit, groupId group _unit] spawn OKS_fnc_LogDebug;
};

// Validation
if (isNull _unit || !alive _unit || isPlayer _unit) exitWith {false};

// Wait briefly to see if unit gets into a vehicle (in case they're still boarding)
private _timeoutStart = time;
private _timeout = 5; // Wait up to 5 seconds
waitUntil {
	sleep 0.5;
	(vehicle _unit != _unit) || // Unit is in vehicle
	(!alive _unit) || // Unit died
	(time - _timeoutStart > _timeout) // Timeout expired
};

// Exit if unit died during wait
if (!alive _unit) exitWith {false};

// Check if unit is in a vehicle (crew member)
if (vehicle _unit != _unit) then {
	private _veh = vehicle _unit;
	
	// Check if vehicle alert already applied
	if (_veh getVariable ["OKS_Vehicle_Alert_Applied", false]) exitWith {
		if (_debug) then {
			format ["[STEALTH] Vehicle %1 already has alert applied, skipping unit %2", typeOf _veh, _unit] spawn OKS_fnc_LogDebug;
		};
		_unit setVariable ["OKS_Stealth_Applied", true, true];
		false
	};
	
	// Check if this unit is actual crew (not passenger)
	private _role = assignedVehicleRole _unit;
	private _isCrew = false;
	if (count _role > 0) then {
		private _roleType = _role select 0;
		if (_roleType in ["driver", "gunner", "commander", "turret"]) then {
			_isCrew = true;
		};
	};
	
	if (_isCrew) then {
		// Mark unit and vehicle as processed
		_unit setVariable ["OKS_Stealth_Applied", true, true];
		_unit setVariable ["OKS_Vehicle_Crew_Applied", true, true];
		
		private _enemyFaction = missionNamespace getVariable ["GOL_OKS_Enemy_Faction", east];
		private _huntRange = missionNamespace getVariable ["GOL_OKS_Hunt_Range", 500];
		
		// Spawn vehicle alert script
		[_veh, _enemyFaction, false, 500, _huntRange] spawn OKS_fnc_Stealth_Enemy_Vehicle;
		
		if (_debug) then {
			format ["[STEALTH] Applied Vehicle Alert to %1 (crew member: %2)", typeOf _veh, _unit] spawn OKS_fnc_LogDebug;
		};
		true
	} else {
		// Passenger, not crew - skip
		if (_debug) then {
			format ["[STEALTH] Unit %1 is passenger in vehicle, skipping", _unit] spawn OKS_fnc_LogDebug;
		};
		false
	}
};

private _group = group _unit;
private _enemyFaction = missionNamespace getVariable ["GOL_OKS_Enemy_Faction", east];

// Only apply to enemy faction units
if (side _group != _enemyFaction) exitWith {
	if (_debug) then {
		format ["[STEALTH] Unit %1 side %2 doesn't match faction %3, skipping", _unit, side _group, _enemyFaction] spawn OKS_fnc_LogDebug;
	};
	false
};

// Skip if unit already processed
if (_unit getVariable ["OKS_Stealth_Applied", false]) exitWith {
	if (_debug) then {
		format ["[STEALTH] Unit %1 already processed, skipping", _unit] spawn OKS_fnc_LogDebug;
	};
	false
};

// Skip civilians
if (side _group == civilian) exitWith {false};

// Check if group has STEALTH behaviour (don't apply if stealthy)
private _waypointCount = count waypoints _group;
private _hasStealthWaypoint = false;
if (_waypointCount > 0) then {
	for "_i" from 0 to (_waypointCount - 1) do {
		private _wp = [_group, _i];
		if (waypointBehaviour _wp == "STEALTH") then {
			_hasStealthWaypoint = true;
		};
	};
};
if (_hasStealthWaypoint || behaviour leader _group == "STEALTH") exitWith {
	_unit setVariable ["OKS_Stealth_Applied", true, true];
	if (_debug) then {
		format ["[STEALTH] Skipped %1 - group has STEALTH waypoint/behaviour", _unit] spawn OKS_fnc_LogDebug;
	};
	false
};

// Determine if unit is static
private _isStatic = _group getVariable ["GOL_IsStatic", false];
private _hasWaypoints = (count waypoints _group) > 1; // > 1 because groups have default spawn waypoint

// If no waypoints or explicitly marked static, make it a sentry
if (!_hasWaypoints || _isStatic) then {
	// Set flag IMMEDIATELY to prevent race conditions
	_unit setVariable ["OKS_Stealth_Applied", true, true];
	
	private _chanceForRadio = missionNamespace getVariable ["GOL_OKS_Sentry_ChanceForRadio", 0.25];
	private _requiresRadio = missionNamespace getVariable ["GOL_OKS_Sentry_RequiresRadio", true];
	private _huntRange = missionNamespace getVariable ["GOL_OKS_Hunt_Range", 500];
	
	[_unit, _enemyFaction, _chanceForRadio, _requiresRadio, false, 500, _huntRange] spawn OKS_fnc_Stealth_Enemy_Sentry;
	if (_debug) then {
		format ["[STEALTH] Applied Sentry to static unit %1 (hasWaypoints: %2, isStatic: %3, chanceRadio: %4, requiresRadio: %5, huntRange: %6)", _unit, _hasWaypoints, _isStatic, _chanceForRadio, _requiresRadio, _huntRange] spawn OKS_fnc_LogDebug;
	};
	true
} else {
	// Set flag IMMEDIATELY to prevent race conditions
	_unit setVariable ["OKS_Stealth_Applied", true, true];
	
	// Unit has waypoints and is patrolling
	private _trackerEnabled = missionNamespace getVariable ["GOL_OKS_Tracker", false];
	private _talkEnabled = missionNamespace getVariable ["GOL_OKS_Enemy_Talk", false];
	
	// Apply tracker script if enabled
	if (_trackerEnabled && !(_group getVariable ["OKS_Tracker_Applied", false]) && behaviour leader _group != "SAFE") then {
		[_group] spawn OKS_fnc_Stealth_Tracker;
		_group setVariable ["OKS_Tracker_Applied", true, true];
		if (_debug) then {
			format ["[STEALTH] Applied Tracker to patrol group %1", groupId _group] spawn OKS_fnc_LogDebug;
		};
	};
	
	// Apply talk script if enabled
	if (_talkEnabled && !(_group getVariable ["OKS_Talk_Applied", false])) then {
		[_group] spawn OKS_fnc_Stealth_Enemy_Talk;
		_group setVariable ["OKS_Talk_Applied", true, true];
		if (_debug) then {
			format ["[STEALTH] Applied Talk to patrol group %1", groupId _group] spawn OKS_fnc_LogDebug;
		};
	};
	
	true
};
