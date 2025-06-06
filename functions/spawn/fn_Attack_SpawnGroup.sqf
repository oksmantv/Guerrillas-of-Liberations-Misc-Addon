/*
	OKS_Attack_SpawnGroup
	[_this,player,4,east,true,500] spawn OKS_fnc_Attack_SpawnGroup;
	[SpawnPosOrObject,ArrayOrObject,UnitOrClassname,Side,ShouldAddStepWaypoint,RangeOfFallbackHuntScript] spawn OKS_fnc_Attack_SpawnGroup;
*/

 	if(!isServer) exitWith {};

	Params [
		["_Spawn",objNull,[objNull,[]]],
		["_TargetWaypoint",nil,[[],objNull]],
		["_ClassnameOrNumber",5,[0,""]],
		["_Side",east,[sideUnknown]],
		["_StepWaypoint",false,[false]],
		["_RangeOfFallbackHunt",1000,[0]]
	];
	Private ["_Dir"];
	
	if(typeName _Spawn == "OBJECT") then {
		_Dir = getDir _Spawn;
		_Spawn = getPos _Spawn;
	} else {
		_Dir = random 360;
	};

	if(!isNil "_TargetWaypoint") then {
		if(typeName _TargetWaypoint == "OBJECT") then {
			_TargetWaypoint = getPos _TargetWaypoint;
		};
	};

	Private ["_Group"];
	waitUntil {sleep 1; !isNil "OKS_fnc_Dynamic_Settings"};
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
	if(isNil "_TargetWaypoint") exitWith { 			
		waitUntil {sleep 1; !(isNil "lambs_wp_fnc_taskHunt")};
		[_Group, _RangeOfFallbackHunt, 30, [], [], true,false,false] remoteExec ["lambs_wp_fnc_taskHunt",0];
	};
	
	/// Give Attack SAD Waypoint
	if(_StepWaypoint && typeName _TargetWaypoint == "OBJECT") then {
		_PreWaypointPos = _TargetWaypoint getPos [((_Spawn distance _TargetWaypoint) / 2), _TargetWaypoint getDir _Spawn];
		_WP1 = _Group addWaypoint [_PreWaypointPos,25];
		_WP1 setWaypointType "MOVE";

		_WP2 = _Group addWaypoint [_TargetWaypoint,25];
		_WP2 setWaypointType "SAD";		
	} else {
		if(typeName _TargetWaypoint == "ARRAY") then {
			if(typeName (_TargetWaypoint select 0) == "SCALAR") exitWith {
				
				if(_StepWaypoint) then {
					_PreWaypointPos = _TargetWaypoint getPos [((_Spawn distance _TargetWaypoint) / 2), _TargetWaypoint getDir _Spawn];
					_WP = _Group addWaypoint [_PreWaypointPos,-1];
					_WP setWaypointType "MOVE";
				};

				_WP2 = _Group addWaypoint [_TargetWaypoint,25];
				_WP2 setWaypointType "SAD";						
			};

			{
				if(_TargetWaypoint find _X == (count _TargetWaypoint - 1)) then {
					_WP = _Group addWaypoint [_X,-1];
					_WP setWaypointType "SAD";
				} else {
					_WP = _Group addWaypoint [_X,-1];
					_WP setWaypointType "MOVE";					
				}
			} foreach _TargetWaypoint;
		} else {
			_WP2 = _Group addWaypoint [_TargetWaypoint,25];
			_WP2 setWaypointType "SAD";
		}
	};



