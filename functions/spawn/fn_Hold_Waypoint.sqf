/*
	OKS_Hold_Waypoint
	[SpawnPosOrObject,ArrayOrObject,UnitOrClassname,Side] spawn OKS_fnc_Hold_Waypoint;
*/

 	if(!isServer) exitWith {};

	Params [
		["_Spawn",objNull,[objNull,[]]],
		["_TargetWaypoint",objNull,[[],objNull]],
		["_ClassnameOrNumber",5,[0,""]],
		["_Side",east,[sideUnknown]]
	];
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




