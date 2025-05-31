Params ["_SpawnPos","_Side","_UnitsPerWave","_UnitArray","_AllSpawnedUnits","_Range","_LambsType"];

_UnitArray Params ["_Leaders","_Units","_Officer"];
private _ForceMultiplier = missionNameSpace getVariable ["GOL_ForceMultiplier",1];
_Group = CreateGroup _Side;
_Group setVariable ["acex_headless_blacklist",true,true];
for "_i" from 1 to round(_UnitsPerWave * _ForceMultiplier) do
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
	sleep 1;
};

{
	[_x] remoteExec ["GW_SetDifficulty_fnc_setSkill"];
	_AllSpawnedUnits pushBackUnique _X;
} foreach units _Group;

sleep 5;
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
		waitUntil {sleep 1; !(isNil "lambs_wp_fnc_taskHunt")};
		[_Group, _Range, 30, [], [], true,false,false] remoteExec ["lambs_wp_fnc_taskHunt",0];
	};
	case "creep":{
		/* 
			* Arguments:
			* 0: Group performing action, either unit <OBJECT> or group <GROUP>
			* 1: Range of tracking, default is 500 meters <NUMBER>
			* 2: Delay of cycle, default 15 seconds <NUMBER>
			* 3: Area the AI Camps in, default [] <ARRAY>
			* 4: Center Position, if no position or Empty Array is given it uses the Group as Center and updates the position every Cycle, default [] <ARRAY>
			* 5: Only Players, default true <BOOL>
		*/
		waitUntil {sleep 1; !(isNil "lambs_wp_fnc_taskCreep")};
		[_Group, _Range, 30, [], [], true] remoteExec ["lambs_wp_fnc_taskCreep",0];
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