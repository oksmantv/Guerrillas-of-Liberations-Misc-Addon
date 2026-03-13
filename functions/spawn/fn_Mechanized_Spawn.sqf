/*
    Function: OKS_fnc_Mechanized_Spawn

    Description:
        Spawns a crewed vehicle (APC/IFV) with infantry cargo at a position. After spawning,
        the vehicle is locked and units are split into a crew group (driver/gunner/commander)
        and an infantry group (cargo passengers). The crew group is sent hunting toward a
        trigger zone via OKS_fnc_HuntRun. The script then waits until any unit enters COMBAT
        behaviour, at which point the hunt is disabled, the vehicle unlocks, and infantry
        dismounts. Once all cargo has exited, the infantry group receives a LAMBS taskHunt
        within the specified range. The vehicle is then re-locked and begins following the
        infantry via OKS_fnc_Follow_Squad, creating a coordinated mechanized assault pattern.
        Skill levels are set via GW_SetDifficulty_fnc_setSkill. If an array of classnames is
        passed as the vehicle type, one is randomly selected.

    Parameters:
        0: _Spawn          - OBJECT or ARRAY - Spawn position object or [x,y,z] position
        1: _HuntTrigger    - OBJECT          - Trigger zone for initial vehicle hunt behaviour
        2: _VehicleType    - STRING or ARRAY - Vehicle classname or array of classnames (one selected randomly)
        3: _InfantryNumber - NUMBER          - Number of infantry units to spawn as cargo (default: 5)
        4: _Side           - SIDE            - Faction side (default: east)
        5: _Range          - NUMBER          - LAMBS hunt range in meters after dismount (default: 2000)

    Returns:
        Nothing

    Example:
        [this, Trigger_1, "O_APC_Wheeled_02_rcws_v2_F", 5, east, 500] spawn OKS_fnc_Mechanized_Spawn;

        // With random vehicle selection
        [this, Trigger_1, ["O_APC_Wheeled_02_rcws_v2_F", "O_APC_Tracked_02_cannon_F"], 6, east, 1000] spawn OKS_fnc_Mechanized_Spawn;
*/

 	if(!isServer) exitWith {};

	Params [
		["_Spawn",objNull,[objNull,[]]],
		["_HuntTrigger",objNull,[objNull]],
		["_VehicleType","",[[],""]],
		["_InfantryNumber",5,[0]],
		["_Side",east,[sideUnknown]],
		["_Range",2000,[0]]
	];
	Private ["_Dir"];
	
	if(typeName _Spawn == "OBJECT") then {
		_Dir = getDir _Spawn;
		_Spawn = getPos _Spawn;
	} else {
		_Dir = random 360;
	};

	Private ["_Group","_Vehicle"];
	if(typeName _VehicleType == "STRING") then {
		_Vehicle = CreateVehicle [_VehicleType,_Spawn];
		_Vehicle setDir _Dir;
		_Group = [_Vehicle,_Side,0,_InfantryNumber] call OKS_fnc_AddVehicleCrew;
	};
	if(typeName _VehicleType == "ARRAY") then {
		private _chosenClass = selectRandom _VehicleType;
		_Vehicle = CreateVehicle [_chosenClass,_Spawn];
		_Vehicle setDir _Dir;
		_Group = [_Vehicle,_Side,0,_InfantryNumber] call OKS_fnc_AddVehicleCrew;
	};
	sleep 1;
	{[_x] remoteExec ["GW_SetDifficulty_fnc_setSkill",0]} foreach units _Group;
	if(isNil "_Group") exitWith {false};

	_Vehicle lock true;

	_CrewGroup = createGroup _side;
	_InfantryGroup = createGroup _side;
	_Infantry = (units _Group) select {gunner _vehicle != _X || driver _vehicle != _X  || commander _vehicle != _X};
	_Crew = (units _Group) select {gunner _vehicle == _X || driver _vehicle == _X  || commander _vehicle == _X};

	(format ["Mechanized_Spawn: Infantry=%1", _Infantry]) call OKS_fnc_LogDebug;
	(format ["Mechanized_Spawn: Crew=%1", _Crew]) call OKS_fnc_LogDebug;

	_Infantry join grpNull;
	_Infantry join _InfantryGroup;
	_Crew join grpNull;
	_Crew join _CrewGroup;
	
	[_CrewGroup, nil, _HuntTrigger, 0, 30] spawn OKS_fnc_HuntRun;

	waitUntil {sleep 5; {behaviour _X == "COMBAT"} count units _CrewGroup > 0 || {behaviour _X == "COMBAT"} count units _InfantryGroup > 0};
	_CrewGroup setVariable ["Disable_Hunt",true,true];
	_CrewGroup setVariable ["NEKY_Hunt_GroupEnabled",true,true];

	for "_i" from count waypoints _CrewGroup - 1 to 0 step -1 do
	{
		deleteWaypoint [_CrewGroup, _i];
	};		

	_Vehicle lock false;
	_Vehicle forceSpeed 0;
	_InfantryGroup leaveVehicle _Vehicle;
	{
		unassignVehicle _X;	
	} foreach units _InfantryGroup;

	waitUntil {sleep 5; count (fullCrew [_Vehicle, "cargo", false]) == 0};
	[_InfantryGroup,_Range,10,[],[],false] remoteExec ["lambs_wp_fnc_taskHunt",0];
	sleep 10;
	_Vehicle lock true;
	_InfantryGroup setBehaviour "AWARE";
	[_CrewGroup,_InfantryGroup,_Vehicle] spawn OKS_fnc_Follow_Squad;