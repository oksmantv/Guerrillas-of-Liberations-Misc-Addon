	// OKS_Rescue_Friendly
	// [6,3,getPos house1,east,true,["lot","large","fatal"]] spawn OKS_fnc_Rescue_Friendly;
	// [5,1,getPos player,east,true,["lot","large","fatal"]] spawn OKS_fnc_Rescue_Friendly;
	if(!isServer) exitWith {};

	Params ["_NumberInfantry","_NumberOfCasualties","_Position","_Side","_ShouldCreateTasks","_Severity",["_Parent",nil,[""]],["_RushPositions",nil,[[]]]];
	Private ["_Building","_GarrisonPositions","_GarrisonMaxSize","_Unit","_Casualties","_sideMarker","_GroupMarker","_startmarker"];
	Private _Debug_Variable = false;
	_Settings = [_Side] call OKS_fnc_Task_Settings;
	_Settings Params ["_Leaders","_Units"];

	switch (typeName _Position) do {
		case "ARRAY": { 
			_Building = nearestBuilding _Position;
		};
		case "OBJECT": {
			_Building = _Position;
			_Position = getPos _Building;
		};
		default { 
			false
		};
	};

	_Building setVariable ["OKS_IsObjective",true];
	_GarrisonMaxSize = Count ([_Building] call BIS_fnc_buildingPositions);

	switch (_Side) do {
		case west:{
			_sideMarker = "ColorBlufor";
			_GroupMarker = "b_inf";
		};
		case east:{
			_sideMarker = "ColorOpfor";
			_GroupMarker = "o_inf";
		};
		case independent:{
			_sideMarker = "ColorIndependent";
			_GroupMarker = "n_inf";
		};
		default{
			_sideMarker = "colorBlack";
			_GroupMarker = "b_inf";
		}
	};
	_startmarker = createMarker [format ["oks_rescue_marker_%1",str round(random 80000 + random 9999)],_Position, 0];
	_startmarker setMarkerType _GroupMarker;
	_startmarker setMarkerColor _sideMarker;
	_startmarker setMarkerSize [0.6,0.6];
	_startmarker setMarkerShape "ICON";

		// If Garrison is too big for Building, set to max size.
		if(_NumberInfantry >= _GarrisonMaxSize) then {
			_NumberInfantry = _GarrisonMaxSize;
		};

		// Create the Garrison Group
		_Group = CreateGroup _Side;
		_startmarker setMarkerText (format["%1",[str _Group, 7] call BIS_fnc_trimString]);

		_Task = format["OKS_RESCUETASK_%1",(round(random 99999))];
		Private _SubTasks = [];
		Private _TaskArray = [];
		if(!isNil "_Parent") then {
			_TaskArray = [_Task,_Parent];
		} else {
			_TaskArray = [_Task];
		};

		// Create Main Task
		[true, _TaskArray, [format["We have recieved reports from %1 that they have some casualties that are unable to exfil. They have requested support to stabilize their casualties at this <font color='#84e4ff'><marker name = '%2'>position</marker></font color>. Treat the casualties and stabilize the situation, they do not require relocation.",[str _Group, 2] call BIS_fnc_trimString,_startmarker], format["Treat %1 Casualties",[str _Group, 7] call BIS_fnc_trimString], "Casualties"], _Building,"CREATED",-1, false,"heal", false] call BIS_fnc_taskCreate;
		//[true, [_Task], [format["Callsign %3, a squad of infantry located in the area around this <font color='#84e4ff'><marker name = '%1'>location</marker></font color>. They have requested an escort to reach their new <font color='#84e4ff'><marker name = '%2'>positition</marker></font color>. Talk to the Squad leader when you are ready to assist.",_startmarker,_endmarker,[str _Group, 2] call BIS_fnc_trimString], "Escort Squad", "Escort"], _SelectedLeader,"CREATED",-1, false,"help", false] call BIS_fnc_taskCreate;

		for "_i" from 1 to _NumberInfantry do
		{
			Private "_Unit";
			if ( (count (units _Group)) == 0 ) then
			{
				_Unit = _Group CreateUnit [(_Leaders call BIS_FNC_selectRandom), _Position, [], 0, "NONE"];
				_Unit setRank "SERGEANT";
			} else {
				_Unit = _Group CreateUnit [(_Units call BIS_FNC_selectRandom), _Position getPos [(random 8),(random 360)], [], 0, "NONE"];
				_Unit setRank "PRIVATE";
			};
			if(_Debug_Variable) then {SystemChat format ["%1 Pos %2",group _unit,getPos _Unit]};
			_Unit disableAI "PATH";
			_Unit setCaptive true;
			_Unit setCombatMode "BLUE";
			[_Unit] remoteExec ["OKS_Fnc_MoveAI",0];

			if(_Side isNotEqualTo civilian) then {
				_Unit setUnitPos (selectRandom ["UP","MIDDLE"]);
			};

			sleep 0.2;
		};
		 /* Arguments:
			 * 0: The building(s) nearest this position are used <POSITION>
			 * 1: Limit the building search to those type of building <ARRAY>
			 * 2: Units that will be garrisoned <ARRAY>
			 * 3: Radius to fill building(s) <SCALAR> (default: 50)
			 * 4: 0: even filling, 1: building by building, 2: random filling <SCALAR> (default: 0)
			 * 5: True to fill building(s) from top to bottom <BOOL> (default: false) (note: only works with filling mode 0 and 1)
			 * 6: Teleport units <BOOL> (default: false)
		 */
		private _type = typeOf nearestBuilding (getPos (leader _group));
		_Building setVariable ["OKS_isGarrisoned",true];

		if(_Debug_Variable) then {
			SystemChat format ["Compound at %1 Units: %2 Range: %3",_Position,count units _Group,_Range];
			//SystemChat format ["Houses to setVariable: %1",_Houses];
		};

		waitUntil {sleep 5; !(isNil "ace_ai_fnc_garrison") && !(isNil "OKS_fnc_EnablePath")};
		[_Position, [_type], units _Group, 5, 1, false, true] remoteExec ["ace_ai_fnc_garrison",0];
		sleep 2;
		[_Group] remoteExec ["OKS_fnc_SetStatic",0];
		_Casualties = [];
		sleep 2;
		For "_i" from 1 to _NumberOfCasualties do {
			_Casualties pushBackUnique (selectRandom units _Group);
		};
		Private _Count = _NumberOfCasualties;

		waitUntil { sleep 10; {_X distance _Building < 100 && vehicle _X == _X} count AllPlayers >= 1 || {Alive _X} count units _Group < 1};
		if({Alive _X} count units _Group < 1) exitWith {
			[_Task,"FAILED"] call BIS_fnc_taskSetState;
		};

		if(!isNil "_RushPositions") then {
			_trigger = createTrigger ["EmptyDetector", getPos (leader _Group)];
			_trigger setTriggerArea [0, 0, 0, true];
			_trigger setTriggerActivation ["LOGIC", "PRESENT", true];
			_trigger setTriggerStatements ["this", format["(%1 call BIS_fnc_taskCompleted)",_Task], ""];		
			{
				[getPos _X,"rush",2,independent,((_x distance (leader _Group)) + 250),[],_trigger] spawn OKS_fnc_Lambs_Spawner;
			} foreach _RushPositions;
		};

		{_X setCaptive false; _X setCombatMode "RED"} foreach units _Group;
		waitUntil { sleep 10; {_X distance _Building < 50} count AllPlayers >= 1 || {Alive _X} count units _Group < 1};

		private _tier1 = 0;
		private _tier2 = 0;
		{

			if({Alive _X} count units _Group < 1) exitWith {
				[_Task,"FAILED"] call BIS_fnc_taskSetState;
			};
			private _Status = (selectRandom _Severity);
			private _TextStatus = "";
			[_X,_Status] spawn OKS_fnc_MedicalDamage;

			switch (_Status) do{
				case "lot": {
					_tier2 = _tier2 + 1;
					_TextStatus = "The casualty has lost a lot of blood and require medical attention, if not treated soon he may go into cardiac arrest."
				};
				case "large": {
					_tier2 = _tier2 + 1;
					_TextStatus = "The casualty has lost a large amount of blood and require medical attention, he will most likely go into cardiac arrest if not stabilized soon."
				};
				case "fatal": {
					_tier1 = _tier1 + 1;
					_TextStatus = "The casualty has lost a fatal amount of blood and require immediate medical attention, he is in cardiac arrest currently, time is extremely short."
				};
				default {
					_TextStatus = "We do not have a clear picture of the status of the casualty."
				}
			};
			_Count = _Count - 1;
			_SubTaskID = _Task + "_" + (str _Count);
			SystemChat str _SubTaskID;
			_SubTasks pushBackUnique _SubTaskID;
			[true, [_SubTaskID,_Task], [format["You have a casualty to stabilize. %1",_TextStatus], "Stabilize Casualty", "Casualty"], objNull,"CREATED",-1, false,"heal", false] call BIS_fnc_taskCreate;
			[_X,_SubTaskID] spawn OKS_fnc_MedicalCheck;

		} foreach _Casualties;
		[leader _Group,format["1-1 this is%1, we have taken casualties. Requesting Immediate medical attention, We have %2 Tier 1s, and %3 Tier 2s. %1 out.",(format["%1",[str _Group, 7] call BIS_fnc_trimString]),_Tier1,_Tier2]] remoteExec ["sideChat",0];

		if({Alive _X} count units _Group < 1) exitWith {
			[_Task,"FAILED"] call BIS_fnc_taskSetState;
		};

		waitUntil {
			sleep 5;
			({_X call BIS_fnc_taskState isEqualTo "SUCCEEDED" || _X call BIS_fnc_taskState isEqualTo "FAILED"} count _SubTasks == count _SubTasks || {Alive _X} count units _Group < 1)
		};

		if({_X call BIS_fnc_taskState isEqualTo "FAILED"} count _SubTasks == count _SubTasks) then {
			[_Task,"FAILED"] call BIS_fnc_taskSetState;
		} else {
			[_Task,"SUCCEEDED"] call BIS_fnc_taskSetState;
			[leader _Group,format["1-1 this is%1, our casualties are stable. Thanks for the assist, out.",(format["%1",[str _Group, 7] call BIS_fnc_trimString])]] remoteExec ["sideChat",0];
		};



