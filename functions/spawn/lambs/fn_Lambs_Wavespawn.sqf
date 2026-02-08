/*
	OKS_Lambs_Wavespawn
	[SpawnPosOrPositionsInArray,UnitsPerWave,AmountOfWaves,DelayPerWave,TypeOfWP,Side,Range,"VariableNameSetTrueUponAllClear"] spawn OKS_fnc_Lambs_Wavespawn;
	[[getPos spawn_1,getPos spawn_2],5,2,120,"hunt",east,1500,"WaveSpawn1Destroyed"] spawn OKS_fnc_Lambs_Wavespawn;
*/

 	if(!isServer) exitWith {};

	[[attack_1,attack_2,attack_3,attack_4,attack_5,attack_6,attack_7],2,3,180,"rush",east,1500,"Wave1Complete"] spawn OKS_fnc_Lambs_Wavespawn;

	Params [
		"_SpawnPos",
		"_UnitsPerWave",
		"_AmountOfWaves",
		"_DelayPerWave",
		["_LambsType","rush",[""]],
		["_Side",east,[sideUnknown]],
		["_Range",1500,[-1]],
		["_Variable","Rush_WaveSpawn_Variable",[""]]
	];

	private ["_RandomPos","_Center","_AllSpawnedUnits","_SpawnThreads"];
	_AllSpawnedUnits = [];
	_SpawnThreads = [];

	_Settings = [_Side] call OKS_fnc_Dynamic_Settings;
	_Settings Params ["_UnitArray","_SideMarker","_SideColor","_Vehicles","_Civilian","_Trigger"];

	for "_i" from 1 to _AmountOfWaves do {
		if(typeName _SpawnPos == "ARRAY") then {
			if(typeName (_SpawnPos select 0) == "SCALAR") then {
				_SpawnThreads pushBack ([_SpawnPos,_Side,_UnitsPerWave,_UnitArray,_AllSpawnedUnits,_Range,_LambsType] spawn OKS_fnc_Lambs_Wavespawn_Code);
			} else {
				{
					_SpawnThreads pushBack ([_X,_Side,_UnitsPerWave,_UnitArray,_AllSpawnedUnits,_Range,_LambsType] spawn OKS_fnc_Lambs_Wavespawn_Code);				
				} forEach _SpawnPos;
			};
		} else {
			// Keep it dynamic: pass the object through so moving it in Eden changes future waves.
			_SpawnThreads pushBack ([_SpawnPos,_Side,_UnitsPerWave,_UnitArray,_AllSpawnedUnits,_Range,_LambsType] spawn OKS_fnc_Lambs_Wavespawn_Code);
		};
		
		if(_i != _AmountOfWaves) then {
			// Wait for all spawns in this wave to complete before starting delay
			{waitUntil {scriptDone _x}} forEach _SpawnThreads;
			_SpawnThreads = [];
			
			private _ResponseMultiplier = missionNameSpace getVariable ["GOL_ResponseMultiplier",1];
			sleep (_DelayPerWave * _ResponseMultiplier);
		};	
		format ["[LambsWave] Wavespawn Current Count: %1",count _AllSpawnedUnits] spawn OKS_fnc_LogDebug;
	};

	// Wait for final wave spawns to complete
	{waitUntil {scriptDone _x}} forEach _SpawnThreads;

	// Done when no spawned unit remains both alive AND awake.
	waitUntil { sleep 5; {alive _x && ([_x] call ace_common_fnc_isAwake)} count _AllSpawnedUnits < 1};
	missionNamespace setVariable [_Variable, true, true];
	"[LambsWave] Rush Wavespawner Ended." spawn OKS_fnc_LogDebug;

