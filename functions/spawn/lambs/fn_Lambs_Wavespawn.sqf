/*
	OKS_Lambs_Wavespawn
	[SpawnPosOrPositionsInArray,UnitsPerWave,AmountOfWaves,DelayPerWave,TypeOfWP,Side,Range,"VariableNameSetTrueUponAllClear"] spawn OKS_fnc_Lambs_Wavespawn;
	[[getPos spawn_1,getPos spawn_2],5,2,120,"hunt",east,1500,"WaveSpawn1Destroyed"] spawn OKS_fnc_Lambs_Wavespawn;
*/

 	if(!isServer) exitWith {};

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
	private ["_RandomPos","_Center","_AllSpawnedUnits"];
	_AllSpawnedUnits = [];

	_Settings = [_Side] call OKS_fnc_Dynamic_Settings;
	_Settings Params ["_UnitArray","_SideMarker","_SideColor","_Vehicles","_Civilian","_Trigger"];

	for "_i" from 1 to _AmountOfWaves do {
		if(typeName _SpawnPos == "ARRAY") then {
			if(typeName (_SpawnPos select 0) == "SCALAR") then {
				[_SpawnPos,_Side,_UnitsPerWave,_UnitArray,_AllSpawnedUnits,_Range,_LambsType] spawn OKS_fnc_Lambs_WaveSpawn_Code;
			} else {
				{
					[_X,_Side,_UnitsPerWave,_UnitArray,_AllSpawnedUnits,_Range,_LambsType] spawn OKS_fnc_Lambs_WaveSpawn_Code;				
				} forEach _SpawnPos;
			};
		} else {
			[getPos _SpawnPos,_Side,_UnitsPerWave,_UnitArray,_AllSpawnedUnits,_Range,_LambsType] spawn OKS_fnc_Lambs_WaveSpawn_Code;
		};
		
		if(_i != _AmountOfWaves) then {
			private _ResponseMultiplier = missionNameSpace getVariable ["GOL_ResponseMultiplier",1];
			sleep (_DelayPerWave * _ResponseMultiplier);
		};	
		SystemChat format ["Wavespawn Current Count: %1",count _AllSpawnedUnits];
	};

	waitUntil { sleep 5; {Alive _X || [_X] call ace_common_fnc_isAwake} count _AllSpawnedUnits < 1};
	Call Compile Format ["%1 = True; PublicVariable '%1'",_Variable];
	SystemChat "Rush Wavespawner Ended.";

