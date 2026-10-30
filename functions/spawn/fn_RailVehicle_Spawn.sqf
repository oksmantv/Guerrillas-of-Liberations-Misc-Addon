/*
    Function: OKS_fnc_RailVehicle_Spawn

    Description:
        Spawns a ground vehicle with crew and optional cargo infantry, then initiates
        rail-guided movement along a predefined waypoint path via OKS_fnc_RailMove.
        Cargo is created in a separate group from the crew, which is critical for
        convoy-style dismount logic to work correctly (prevents the driver/gunner from
        dismounting). The driver can optionally be replaced with a non-combat agent
        (controlled via GOL_RailMove_UseAgentDriver) that ignores targets and autocombat,
        ensuring reliable pathfinding along the rail route. The deployment style parameter
        is passed to the convoy dismount tasking system for post-arrival behaviour.

    Parameters:
        0: _spawn           - OBJECT or ARRAY - Spawn position object or [x,y,z] ATL position
        1: _vehicleClass    - STRING          - Vehicle classname (e.g. "O_APC_Wheeled_02_rcws_v2_F")
        2: _side            - SIDE            - Faction side for spawned units (default: east)
        3: _cargoCount      - NUMBER          - Number of cargo infantry to spawn (default: 0)
        4: _speedLimitKph   - NUMBER          - Speed limit in km/h for rail movement (default: 35)
        5: _waypoints       - ARRAY           - Waypoints for OKS_fnc_RailMove (objects, positions, or markers)
        6: _deploymentStyle - STRING          - Deployment behaviour passed to dismount tasking (default: "rush")

    Returns:
        ARRAY - [vehicle, crewGroup, cargoGroup]

    Example:
        [this, "O_APC_Wheeled_02_rcws_v2_F", east, 8, 35, [wp1, wp2, wp3], "rush"] spawn OKS_fnc_RailVehicle_Spawn;
*/

if (!isServer) exitWith { [objNull, grpNull, grpNull] };

params [
	["_spawn", objNull, [objNull, []]],
	["_vehicleClass", "", [""]],
	["_side", east, [sideUnknown]],
	["_cargoCount", 0, [0]],
	["_speedLimitKph", 35, [0]],
	["_waypoints", [], [[]]],
	["_deploymentStyle", "rush", [""]]
];

private _oks_multiplier = missionNamespace getVariable ["GOL_SpawnMultiplier", 100];
private _oks_blacklisted = missionNamespace getVariable ["GOL_SpawnMultiplier_Blacklist_RailVehicle", false];
private _oks_applyMultiplier = (_oks_multiplier < 100) && {!_oks_blacklisted};
if (_oks_applyMultiplier && { _cargoCount > 0 }) then {
	_cargoCount = (ceil (_cargoCount * _oks_multiplier / 100)) max 3;
};

private _railDebug = missionNamespace getVariable ["GOL_RailMove_Debug", false];

if (_vehicleClass isEqualTo "") exitWith { [objNull, grpNull, grpNull] };

private _posATL = [0,0,0];
private _dir = random 360;
if (_spawn isEqualType objNull) then {
	_posATL = getPosATL _spawn;
	_dir = getDir _spawn;
} else {
	_posATL = _spawn;
};

private _vehicle = createVehicle [_vehicleClass, _posATL, [], 0, "NONE"];
_vehicle setDir _dir;
_vehicle setPosATL _posATL;

// Spawn crew only; cargo is spawned in a separate group.
private _crewGroup = [_vehicle, _side, 0, 0] call OKS_fnc_AddVehicleCrew;
{ [_x] remoteExec ["GW_SetDifficulty_fnc_setSkill", 0]; } forEach units _crewGroup;

// Replace the driver with an agent that ignores combat/targets.
private _oldDriver = driver _vehicle;
private _driverAgent = objNull;
private _useAgentDriver = missionNamespace getVariable ["GOL_RailMove_UseAgentDriver", false];

if (!isNull _oldDriver && {!_useAgentDriver}) then {
	// Non-agent "don't care" driver: keep a normal unit so it can drive reliably.
	_oldDriver setBehaviour "AWARE";
	_oldDriver setCombatMode "BLUE";
	_oldDriver allowFleeing 0;
	_oldDriver disableAI "AUTOCOMBAT";
	_oldDriver disableAI "TARGET";
	_oldDriver disableAI "AUTOTARGET";
	_oldDriver disableAI "COVER";
	_oldDriver disableAI "SUPPRESSION";
	_oldDriver enableAttack false;
};

if (!isNull _oldDriver && {_useAgentDriver}) then {
	private _settings = [_side] call OKS_fnc_Dynamic_Settings;
	_settings params ["_unitArray"]; // other returns are not needed here
	_unitArray params ["_leaders", "_units"]; // leaders currently unused

	private _driverClass = if (count _units > 0) then {_units call BIS_fnc_selectRandom} else {typeOf _oldDriver};
	_driverAgent = createAgent [_driverClass, _posATL, [], 0, "NONE"];
	_driverAgent setDir _dir;
	_driverAgent setPosATL _posATL;

	_driverAgent setBehaviour "AWARE";
	_driverAgent setCombatMode "BLUE";
	_driverAgent allowFleeing 0;
	_driverAgent disableAI "AUTOCOMBAT";
	_driverAgent disableAI "TARGET";
	_driverAgent disableAI "AUTOTARGET";
	_driverAgent disableAI "COVER";
	_driverAgent disableAI "SUPPRESSION";
	_driverAgent enableAttack false;

	// Agents are not guaranteed to be able to drive unless they are part of a group.
	// Try to attach it to the existing crew group before seating it.
	[_driverAgent] joinSilent _crewGroup;

	moveOut _oldDriver;
	_driverAgent moveInDriver _vehicle;
	sleep 0.05;
	if (driver _vehicle == _driverAgent) then {
		deleteVehicle _oldDriver;
	} else {
		// Fallback: keep the original driver, drop the agent.
		if (_railDebug) then {
			format ["[RAILSPAWN] Agent driver failed to take control for %1 (%2). Keeping normal driver.", _vehicle, typeOf _vehicle] spawn OKS_fnc_LogDebug;
		};
		deleteVehicle _driverAgent;
		_driverAgent = objNull;
		_oldDriver moveInDriver _vehicle;
	};
};

if (_railDebug) then {
	format [
		"[RAILSPAWN] veh=%1 type=%2 side=%3 pos=%4 dir=%.0f crewGroup=%5 crew=%6 driver=%7 agentDrv=%8 cargoReq=%9 wps=%10 speedLimit=%11 deploy=%12",
		_vehicle,
		typeOf _vehicle,
		_side,
		_posATL,
		_dir,
		_crewGroup,
		count (units _crewGroup),
		driver _vehicle,
		_driverAgent,
		_cargoCount,
		count _waypoints,
		_speedLimitKph,
		_deploymentStyle
	] spawn OKS_fnc_LogDebug;
};

private _cargoGroup = grpNull;
if (_cargoCount > 0) then {
	private _cargoSeatCount = ([typeOf _vehicle, true] call BIS_fnc_crewCount) - ([typeOf _vehicle, false] call BIS_fnc_crewCount);
	if (_cargoSeatCount > 0) then {
		private _countToSpawn = _cargoCount min _cargoSeatCount;
		private _settings = [_side] call OKS_fnc_Dynamic_Settings;
		_settings params ["_unitArray"]; // other returns are not needed here
		_unitArray params ["_leaders", "_units"]; // leaders currently unused

		_cargoGroup = createGroup _side;
		for "_i" from 1 to _countToSpawn do {
			private _unitClass = _units call BIS_fnc_selectRandom;
			private _unit = _cargoGroup createUnit [_unitClass, [0,0,0], [], 0, "NONE"];
			_unit moveInCargo _vehicle;
		};
		{ [_x] remoteExec ["GW_SetDifficulty_fnc_setSkill", 0]; } forEach units _cargoGroup;
	} else {
		if (_railDebug) then {
			format ["[RAILSPAWN] %1 has no cargo seats (requested %2)", _vehicleClass, _cargoCount] spawn OKS_fnc_LogDebug;
		};
	};
};

// Store groups/agent on the vehicle so RailMove can dismount/task the intended units.
_vehicle setVariable ["OKS_RailMove_crewGroup", _crewGroup, true];
_vehicle setVariable ["OKS_RailMove_cargoGroup", _cargoGroup, true];
_vehicle setVariable ["OKS_RailMove_driverAgent", _driverAgent, true];

// Ensure the driver is the group leader so movement orders are not overridden by a commander/gunner under contact.
private _driverNow = driver _vehicle;
if (!isNull _driverNow) then {
	// Put the driver in its own group so group combat mode doesn't suppress turret AI.
	private _driverGroup = group _driverNow;
	if (!isNull _driverGroup && {count (units _driverGroup) > 1}) then {
		_driverGroup = createGroup _side;
		[_driverNow] joinSilent _driverGroup;
	};
	if (!isNull _driverGroup) then { _driverGroup selectLeader _driverNow; };
	_vehicle setEffectiveCommander _driverNow;
	_driverNow setBehaviourStrong "AWARE";
	_driverNow setUnitCombatMode "BLUE";
	_driverNow allowFleeing 0;
	_driverNow disableAI "AUTOCOMBAT";
	_driverNow disableAI "TARGET";
	_driverNow disableAI "AUTOTARGET";
	_driverNow enableAttack false;
	_driverNow action ["TurnIn", _vehicle];
};

// Allow turret and cargo/FFV units to actually engage.
private _gunnerNow = gunner _vehicle;
private _commanderNow = commander _vehicle;
{
	if (!isNull _x) then {
		_x enableAttack true;
		_x enableAI "TARGET";
		_x enableAI "AUTOTARGET";
		_x enableAI "AUTOCOMBAT";
		_x setBehaviourStrong "AWARE";
	};
} forEach [_gunnerNow, _commanderNow];
if (!isNull _cargoGroup) then {
	_cargoGroup setCombatMode "RED";
	_cargoGroup setSpeedMode "FULL";
	{ _x enableAttack true; _x enableAI "TARGET"; _x enableAI "AUTOTARGET"; _x enableAI "AUTOCOMBAT"; _x setBehaviourStrong "AWARE"; } forEach units _cargoGroup;
};

// Start scripted rail movement.
[_vehicle, _speedLimitKph, _waypoints, _deploymentStyle] spawn OKS_fnc_RailMove;

[_vehicle, _crewGroup, _cargoGroup]
