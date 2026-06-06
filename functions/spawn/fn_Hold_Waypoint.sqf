/*
    Function: OKS_fnc_Hold_Waypoint

    Description:
        Spawns an infantry group or crewed vehicle at a position and assigns a HOLD
        waypoint at the target location. The group is set to SAFE behaviour with RED
        combat mode, meaning they will hold position but engage threats that appear.
        Unit classnames are pulled from OKS_fnc_Dynamic_Settings based on the specified
        side. If a number is passed, that many infantry are spawned; if a classname
        string is given, a vehicle is created and crewed; if an array of classnames
        is passed, one is randomly selected and spawned. Skill levels are set via
        GW_SetDifficulty_fnc_setSkill. Infantry units also receive suppression if
        GOL_Suppression_Enabled is active.

    Parameters:
        0: _Spawn           - OBJECT or ARRAY        - Spawn position object or [x,y,z] position
        1: _TargetWaypoint  - OBJECT or ARRAY        - Target HOLD waypoint position or object
        2: _ClassnameOrNumber - NUMBER, STRING, or ARRAY - Infantry count, vehicle classname, or array of classnames (default: 5)
        3: _Side            - SIDE                   - Faction side for the group (default: east)

    Returns:
        Nothing

    Example:
        // Hold with 5 infantry
        [spawnObj, holdPos_1, 5, east] spawn OKS_fnc_Hold_Waypoint;

        // Hold with a vehicle
        [spawnObj, holdPos_1, "O_APC_Wheeled_02_rcws_v2_F", east] spawn OKS_fnc_Hold_Waypoint;
*/

 	if(!isServer) exitWith {};

	Params [
		["_Spawn",objNull,[objNull,[]]],
		["_TargetWaypoint",objNull,[[],objNull]],
		["_ClassnameOrNumber",5,[0,""]],
		["_Side",east,[sideUnknown]]
	];

	private _oks_multiplier = missionNamespace getVariable ["GOL_SpawnMultiplier", 100];
	private _oks_blacklisted = missionNamespace getVariable ["GOL_SpawnMultiplier_Blacklist_HoldWaypoint", false];
	private _oks_applyMultiplier = (_oks_multiplier < 100) && {!_oks_blacklisted};
	if (_oks_applyMultiplier && { _ClassnameOrNumber isEqualType 0 }) then {
		_ClassnameOrNumber = (_ClassnameOrNumber * _oks_multiplier / 100) max 1;
	};

	Private ["_Dir"];
	
	if(typeName _Spawn == "OBJECT") then {
		_Dir = getDir _Spawn;
		_Spawn = getPos _Spawn;
	} else {
		_Dir = random 360;
	};
	if(typeName _TargetWaypoint == "OBJECT") then {
		_TargetWaypoint = getPos _TargetWaypoint;
	};

	Private ["_Group"];
	waitUntil {sleep 1; !isNil "GOL_fnc_Dynamic_Settings"};
	_Settings = [_Side] call OKS_fnc_Dynamic_Settings;
	_Settings Params ["_UnitArray","_SideMarker","_SideColor","_Vehicles","_Civilian","_Trigger"];
	_UnitArray Params ["_Leaders","_Units","_Officer"];
	
	if(typeName _ClassnameOrNumber == "SCALAR") then {
		_Group = CreateGroup _Side;
		for "_i" from 1 to (_ClassnameOrNumber) do
		{
			Private "_Unit";
			if ( (count (units _Group)) == 0 ) then
			{
				_Unit = _Group CreateUnit [(_Leaders call BIS_FNC_selectRandom), _Spawn getPos [5,(random 360)], [], 0, "NONE"];
				_Unit setRank "SERGEANT";
			} else {
				_Unit = _Group CreateUnit [(_Units call BIS_FNC_selectRandom), _Spawn getPos [5,(random 360)], [], 0, "NONE"];
				_Unit setRank "PRIVATE";
			};
			sleep 0.5;
		};

		private _Suppression_Enabled = missionNamespace getVariable ["GOL_Suppression_Enabled",true];
		if(_Suppression_Enabled) then {
			{[_X] remoteExec ["GOL_Suppressed",0]} foreach units _group;
		};	
	};
	if(typeName _ClassnameOrNumber == "STRING") then {
		_Vehicle = CreateVehicle [_ClassnameOrNumber,_Spawn];
		_Vehicle setDir _Dir;
		_Group = [_Vehicle,_Side] call OKS_fnc_AddVehicleCrew;
	};
	if(typeName _ClassnameOrNumber == "ARRAY") then {
		_ClassnameOrNumber = selectRandom _ClassnameOrNumber;
		_Vehicle = CreateVehicle [_Classname,_Spawn];
		_Vehicle setDir _Dir;
		_Group = [_Vehicle,_Side] call OKS_fnc_AddVehicleCrew;
	};
	sleep 1;
	{[_x] remoteExec ["GW_SetDifficulty_fnc_setSkill",0]} foreach units _Group;
	if(isNil "_Group") exitWith {false};
	
	_WP = _Group addWaypoint [_TargetWaypoint,0];
	_WP setWaypointType "HOLD";
	_WP setWaypointBehaviour "SAFE";
	_WP setWaypointCombatMode "RED";	




