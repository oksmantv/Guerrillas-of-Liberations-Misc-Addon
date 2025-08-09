/*
	OKS_Lambs_SpawnGroup
	[SpawnPos,"rush",UnitsPerBase,Side,Range,[]] spawn OKS_fnc_Lambs_SpawnGroup;
	[SpawnPos,"rush",VehicleArray,Side,Range,[]] spawn OKS_fnc_Lambs_SpawnGroup;

	_VehicleArray = [[vehicleClassname], CrewSelect, CargoCount];
	[VehicleClassname] // Array of Vehicle classnames (Random Select)
	CrewSelect // 0 = full crew, 1 = driver only, 2 = gunner only, 3 = commander only
	CargoCount // Amount of Infantry in Cargo

	Types = "hunt", "creep", "ambushattack", "ambushrush", "ambushhunt", "ambushcqb" or "rush"
	_Range for tracking range, and ambush trigger range.
	
*/

 	if(!isServer) exitWith {};

	Params ["_SpawnPos","_LambsType",["_InfantryCountOrVehicleArray",5,[0,[]]],["_Side",east,[sideUnknown]],["_Range",1500,[0]],["_Array",[],[[]]]];
	private ["_RandomPos","_Center","_Direction","_Position"];

	private _KnowsAboutTargets = {
		params ["_Group","_Range"];

		_NearPlayers = AllPlayers select {_X distance (leader _Group) < _Range};
		_KnowsAboutTarget = (count(_Group targets [true, _Range]) > 0) OR ({(side _Group) knowsAbout _X > 3.5} count _NearPlayers > 0);
		[_KnowsAboutTarget,_NearPlayers]
	};

	_Settings = [_Side] call OKS_fnc_Dynamic_Settings;
	_Settings Params ["_UnitArray","_SideMarker","_SideColor","_Vehicles","_Civilian","_Trigger"];
	_UnitArray Params ["_Leaders","_Units","_Officer"];
	_Group = CreateGroup _Side;
	_Group setVariable ["acex_headless_blacklist",true,true];

	private _GetDirToNearestPlayer = {
		params ["_OriginPosition"];

		// Filter out headless clients and non-human players
		private _realPlayers = allPlayers - entities "HeadlessClient_F";

		// Sort players by proximity to _unit
		private _sortedPlayers = [_realPlayers, [], { _OriginPosition distance _x }, "ASCEND"] call BIS_fnc_sortBy;

		// Get nearest player and direction
		private _nearestPlayer = _sortedPlayers select 0;
		private _direction = _OriginPosition getDir _nearestPlayer;

		_direction
	};

	if(typeName _SpawnPos == "OBJECT") then {
		_Direction = getDir _SpawnPos;
		_Position = getPosATL _SpawnPos;
	} else {
		_Direction = [_SpawnPos] call _GetDirToNearestPlayer;
		_Position = _SpawnPos;
	};

	if(typeName _InfantryCountOrVehicleArray == "ARRAY") then {
		_InfantryCountOrVehicleArray params ["_VehicleTypes","_CargoCount"];
		_Group = [_Position,_Direction, selectRandom _VehicleTypes, _Side, 0, _CargoCount] call OKS_fnc_CreateVehicleWithCrew;
	};
	if(typeName _InfantryCountOrVehicleArray == "SCALAR") then {
		for "_i" from 1 to (_InfantryCountOrVehicleArray) do
		{
			Private "_Unit";
			if ( (count (units _Group)) == 0 ) then
			{
				_Unit = _Group CreateUnit [(_Leaders call BIS_FNC_selectRandom), _SpawnPos getPos [(5+(random 5)),(random 360)], [], 0, "NONE"];
				_Unit setRank "SERGEANT";
			} else {
				if(count (units _Group) == 1) then {
					_Unit = _Group CreateUnit [(_Units select 0), _SpawnPos getPos [(5+(random 5)),(random 360)], [], 0, "NONE"];
				} else {
					_Unit = _Group CreateUnit [(_Units call BIS_FNC_selectRandom), _SpawnPos getPos [(5+(random 5)),(random 360)], [], 0, "NONE"];
				};			
				_Unit setRank "PRIVATE";
			};
			sleep 0.5;
		};
	};
	sleep 5;
	if(count units _Group == 0) exitWith {
		"Lambs SpawnGroup did not spawn any units. Possibly wrong parameter use." spawn OKS_fnc_LogDebug;
	};

	{[_x] remoteExec ["GW_SetDifficulty_fnc_setSkill"]; _Array pushBackUnique _X } foreach units _Group;
	Call Compile Format ["PublicVariable '%1'",_Array];
	switch (toLower _LambsType) do {
		case "hunt": {
			/* 
				* Arguments:
				* 0: Group performing action, either unit <OBJECT> or group <GROUP>
				* 1: Range of tracking, default is 500 meters <NUMBER>
				* 2: Delay of cycle, default 15 seconds <NUMBER>
				* 3: Area the AI Camps in, default [] <ARRAY>
				* 4: Center Position, if no position or Empty Array is given it uses the Group as Center and updates the position every Cycle, default [] <ARRAY>
				* 5: Only Players, default true <BOOL>
				* 6: enable dynamic reinforcement <BOOL>
				* 7: Enable Flare <BOOL> or <NUMBER> where 0 disabled, 1 enabled (if Units cant fire it them self a flare is created via createVehicle), 2 Only if Units can Fire UGL them self
			*/	
			[_Group, _Range, 30, [], [], true,false,false] remoteExec ["lambs_wp_fnc_taskHunt",0];
		};
		case "creep":{
			{_X setUnitPos "DOWN"; _X setBehaviour "STEALTH"; _X setCombatMode "GREEN"; } foreach units _Group;
			waitUntil {sleep 5; ([_Group,_Range] call _KnowsAboutTargets) select 0};
			/* 
				* Arguments:
				* 0: Group performing action, either unit <OBJECT> or group <GROUP>
				* 1: Range of tracking, default is 500 meters <NUMBER>
				* 2: Delay of cycle, default 15 seconds <NUMBER>
				* 3: Area the AI Camps in, default [] <ARRAY>
				* 4: Center Position, if no position or Empty Array is given it uses the Group as Center and updates the position every Cycle, default [] <ARRAY>
				* 5: Only Players, default true <BOOL>
			*/
			[_Group, _Range, 30, [], [], true] remoteExec ["lambs_wp_fnc_taskCreep",0];
			{_X setUnitPos "AUTO"; _X setBehaviour "AWARE"; _X setCombatMode "RED"; } foreach units _Group;
		};
		case "ambushattack": {		
			{_X setBehaviour "STEALTH"; _X setCombatMode "YELLOW"; } foreach units _Group;
			waitUntil {sleep 5; ([_Group,_Range] call _KnowsAboutTargets) select 0};
			{_X setBehaviour "AWARE"; _X setCombatMode "RED"; } foreach units _Group;
			_SADWaypoint = _Group addWaypoint [getPos (([_Group,_Range] call _KnowsAboutTargets) select 1),0];
			_SADWaypoint setWaypointType "SAD";
		};

		case "ambushrush": {		
			{_X setBehaviour "STEALTH"; _X setCombatMode "YELLOW"; } foreach units _Group;
			waitUntil {sleep 5; ([_Group,_Range] call _KnowsAboutTargets) select 0};
			{_X setBehaviour "AWARE"; _X setCombatMode "RED"; } foreach units _Group;
			[_Group,_Range,10,[],[],false] remoteExec ["lambs_wp_fnc_taskRush",0];	
		};

		case "ambushhunt":{		
			{_X setBehaviour "STEALTH"; _X setCombatMode "YELLOW"; } foreach units _Group;
			waitUntil {sleep 5; ([_Group,_Range] call _KnowsAboutTargets) select 0};
			{_X setBehaviour "AWARE"; _X setCombatMode "RED"; } foreach units _Group;
			[_Group, _Range, 30, [], [], true,false,false] remoteExec ["lambs_wp_fnc_taskHunt",0];
		};

		case "ambushcqb":{		
			{_X setBehaviour "STEALTH"; _X setCombatMode "YELLOW"; _X disableAI "PATH"; _X setUnitPos "MIDDLE"; } foreach units _Group;
			[_SpawnPos, nil, units _Group, 15, 1, false, true] call ace_ai_fnc_garrison;
			waitUntil {sleep 5; ([_Group,_Range] call _KnowsAboutTargets) select 0};
			{_X setBehaviour "AWARE"; _X setCombatMode "RED"; _X enableAI "PATH"; _X setUnitPos "AUTO"; } foreach units _Group;
			[_Group,_Range,10,[],[],false] remoteExec ["lambs_wp_fnc_taskRush",0];
		};		

		default {
			/* 
				Arguments:
				0: Group performing action, either unit <OBJECT> or group <GROUP>
				1: Range of tracking, default is 500 meters <NUMBER>
				2: Delay of cycle, default 15 seconds <NUMBER>
				3: Area the AI Camps in, default [] <ARRAY>
				4: Center Position, if no position or Empty Array is given it uses the Group as Center and updates the position every Cycle, default [] <ARRAY>
				5: Only Players, default true <BOOL>
			*/

			waitUntil {sleep 1; !isNil "lambs_wp_fnc_moduleRush"};
			[_Group,_Range,10,[],[],false] remoteExec ["lambs_wp_fnc_taskRush",0];	
		};
	};

