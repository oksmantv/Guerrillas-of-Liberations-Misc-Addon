/*
	OKS_Attack_SpawnGroup
	[this,Trigger_1,"O_APC_Wheeled_02_rcws_v2_F",5,east,500] spawn OKS_fnc_Mechanized_Spawn;
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
		_VehicleType = selectRandom _VehicleType;
		_Vehicle = CreateVehicle [_Classname,_Spawn];
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

	systemChat str _Infantry;
	systemChat str _Crew;

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

	[_CrewGroup,_InfantryGroup,_Vehicle] spawn OKS_fnc_Follow_Squad;