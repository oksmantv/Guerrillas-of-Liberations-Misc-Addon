	// OKS_fnc_EnablePath
	// [_Group,0.3,10] spawn OKS_fnc_EnablePath;

	Params [
		"_Group",
		["_Chance",(missionNamespace getVariable ["Static_Enable_Chance", 0.4]),[0]],
		["_Sleep",(missionNamespace getVariable ["Static_Enable_Refresh", 60]),[0]]
	];
	Private ["_Units","_Unit"];
	if(_group getVariable ["OKS_EnablePath_Active",false]) exitWith {
		// Exit if already enabled on Group level.
	};

 	Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
	if(_Debug) then {
		format["%1 ran code for OKS_fnc_EnablePath, Chance: %2, Time: %3",_Group,_Chance,_Sleep] spawn OKS_fnc_LogDebug;
	};
	
	_group setVariable ["OKS_EnablePath_Active",true,true];
	while{{Alive _X} count units _Group > 0} do {
			_AIUnits = units _Group select {
				!(isPlayer _x) && {alive _x || [_x] call ace_common_fnc_isAwake}
			};
			_Players = allPlayers - entities "HeadlessClient_F";
			_ClosestAI = [_AIUnits, [], {
				private _ai = _x;
				if ((count _Players) == 0) then {
					1e39
				} else {
					_ai distance ([_Players, _ai] call BIS_fnc_nearestPosition)
				}
			}, "ASCEND"] call BIS_fnc_sortBy select 0;

		if(!(isNull _ClosestAI)) then {
			_closePlayers = (_ClosestAI nearEntities [["Man"], 15]) select {
				(side _X != (side _Group)) &&
				((side _Group) getFriend (side _X) <= 0.6) &&
				isPlayer _X &&
				(side _Group) knowsAbout _X > 2.5
			};

			if(!(_closePlayers isEqualTo [])) then {
				if(_Debug) then { format ["Players Near Garrison - %1",_closePlayers]};
				if(Random 1 <= _Chance) then {
					_Unit = selectRandom _AIUnits;

					If(isNull (ObjectParent _Unit)) then {

						_newGroup = createGroup (side _Unit);
						_Unit joinAs [_newGroup,0];
						[_Unit,selectRandom ["moveUp_1","moveUp_2","advance","OnTheWay_1"],_Debug] remoteExec ["OKS_Fnc_JBOY_Speak",0]; 

						[_Unit, "PATH"] remoteExec ["enableAI",0];

						//waitUntil {sleep 1; !isNil "lambs_wp_fnc_taskRush"};	
						//[_newGroup,200,15,[],getPos _Unit,true] remoteExec ["lambs_wp_fnc_taskRush",0];

						if(_Debug) then { format ["Garrison Unit Detached: %1",_Unit] spawn OKS_fnc_LogDebug;};
					} else {
						if(_Debug) then { format ["Ignored (Unit in Vehicle): %1",_Unit] spawn OKS_fnc_LogDebug;};
					};
				};
			};
		};
 		sleep _Sleep;
	};

