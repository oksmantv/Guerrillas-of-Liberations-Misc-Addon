

// Created by Oksman
/*

		[Base Object, SpawnObject, Trigger, Side , "Helicopter Classname","Type Of Insert",[NumberOfGroups,%ofVehicleCargoSpace], RespawnTimer, RandomDistanceLz, RefreshRate, RespawnCount] spawn OKS_fnc_Airbase;

		Script Parameters:
    	Base Object - If this object is destroyed the camp will no longer spawn attacks, use something that can be destroyed such as trucks, tents, buildings etc.
		SpawnObject - Set down a small object (box of matches / helipad) and face the direction you want the vehicle/group to spawn in
		Trigger - Set up a trigger used to define the hunting space for these reinforcements, set it to Any Players and repeatable for best effect.
		Side - The side of the faction you wanted spawned
		Classname - The classname of the helicopter to spawn
		Type of Insert - Unload/Paradrop (Unload makes the helicopter land, while Paradrop is paradrop, unloadthenpatrol lands the infantry then send the helicopter to patrol)
		[
			Number of Groups - This is the amount of groups/teams you want the troops to be split into.
			Procentage of Cargo Space - This takes a scalar value and estimates a procentage of the cargo slots available in the helicopter. If a helicopter has 10 seats and the procentage is at 0.5 (50%) then 5 enemies will be spawned. Use 1 for 100% and 0.1-0.9 for 10% - 90%.
		]
		RespawnTimer - How long to wait before the next wave of reinforcements can be spawned, this is in seconds.
		RandomDistanceLz - How far away from the player the helicopter will spawn, this is in meters.
		RefreshRate - How often the script will check for players in the trigger area, this is in seconds.

		Examples on code:
		[Object_1,Spawn_1,Trigger_1,EAST,"O_Heli_Light_02_dynamicLoadout_F","Unload",[2,1], 900, 100, 90, 5] spawn OKS_fnc_Airbase;


		Step-by-Step Guide:
		You need two objects, you need a base object and a spawn object. Place down a destructible object and name it 'Object_1'
		(When this object is destroyed, the "base" is destroyed thus it will not spawn more units)

		Next create a spawn object and name it 'Spawn_1', this could be any object but I suggest using a tiny object such as 'Box of matches'. This is the object the helicopter will use to spawn on top of.
		(You can also use a helipad but this will make AI helicopters land on these spawns if the base is within or close to the trigger area.)

		You now need a Trigger, create a trigger and name it Trigger_1. Set the activation to "Any Players" and set it to "Repeatable". All this is chosen in the trigger properties (Double-click the trigger).
		(This is now the trigger area the enemy spawned units will hunt inside, this means if players are detected within this trigger, they will start spawning units and start hunting. When they leave the AI will cease hunting and cease spawning.)

		You now have all the necessary editor placed objects to use the code. You have a base object, spawn object and a trigger. Now open your spawnList.sqf and paste the following:
		[Object_1, Spawn_1, Trigger_1,EAST,"O_Heli_Light_02_unarmed_F","Unload",[2,1],900, 100, 90, 5] spawn OKS_fnc_Airbase;

		The final properties in the bracket above is:
		Side, Helicopter Classname, 		Type of Insert, [Number of Groups, Procentage of Cargo Space].
		EAST  "O_Heli_Light_02_unarmed_F"	"Unload"		[2, 1]

		These are the properties you have to change to match whatever you need. Now when you activate your spawnList case through the standard triggers, your base will initiate. To have them spawn in, you need to be detected by the enemy side and reach a knowsAbout value above 3.5. Get into CQB with the enemy and this should activate the hunting bases.

*/

if (!isServer) exitWith {false};		// Ensures only server

params [
    "_Object",                    // 0: Base Object that can be destroyed to stop reinforcements
    "_SpawnPos",                  // 1: Helipad at Airbase that spawns helicopters
    "_ReinforcementZone",         // 2: Zone that AI will reinforce if contested by players
    "_Side",                      // 3: Side of Helicopter Reinforcements
    "_Classname",                 // 4: Helicopter Classname
    ["_Type","unload"],                   // 5: "unload" or "drop" or "unloadthenpatrol"
    ["_Troops",[2,0.5]],                  // 6: [ProcentageofCargoSpace, NumberOfTeamsToSplitInto]
    ["_AirbaseRespawnTimer", 900],        // 7: Timer until allowed to respawn another wave
    ["_AirbaseRandomDistanceLZ", 200],    // 8: Distance from player for HLS
    ["_AirbaseRefreshRate", 30],          // 9: Refresh timer
    ["_AirbaseRespawnCount", 4]           // 10: How many waves of reinforcements
];

_PlayerTarget = objNull;

Private ["_EgressPos","_playerHunted","_VehicleClassName","_VehicleClassNameArray","_SelectedClassname"];
private _Debug = missionNamespace getVariable ["GOL_Hunt_Debug", false];
_type = toLower _type;

#include "fn_Airdrop_Settings.sqf"

While {Alive _Object && _AirbaseRespawnCount > 0} do {
	_playerHunted = [];
	if(typeName _Classname == "ARRAY") then {
		_SelectedClassname = selectRandom _Classname
	} else {
		_SelectedClassname = _Classname;
	};

	_Heli = CreateVehicle [_SelectedClassname, [0,0,100], [], 0, "CAN_COLLIDE"];
	_Heli enableSimulation false;
	_Heli allowDamage false;
	_EmptyCargoSeats = (_Heli emptyPositions "Cargo");
	_UnitsPerGroup = round ( (round (_EmptyCargoSeats * (_Troops select 1))) / (_Troops select 0) );	// # OF GROUPS = (_Units select 0)  ||  % OF CARGO = (_Units select 1)
	_SpareIndex = ( (round (_EmptyCargoSeats * (_Troops select 1))) - (_UnitsPerGroup * (_Troops select 0)) );
	deleteVehicle _Heli;

	_ThirdSide = independent;
	if(_Side == independent) then {
		_ThirdSide = east;
	};

	{
		_PlayerSide = missionNameSpace getVariable ["GOL_Friendly_Side",(side group player)];
		_KnownPlayerToOriginalSide = ((_Side knowsAbout _X > 3.5 || _Side knowsAbout vehicle _X > 3.5) && (isTouchingGround (vehicle _X)));
		_KnownPlayerToThirdSideAndIsEnemy = ((_ThirdSide getFriend _PlayerSide) < 0.6 && (_ThirdSide knowsAbout _X > 3.5 || _ThirdSide knowsAbout vehicle _X > 3.5) && (isTouchingGround (vehicle _X)));
		if (_KnownPlayerToOriginalSide || _KnownPlayerToThirdSideAndIsEnemy)
		then
		{
			_playerHunted pushBackUnique _X; sleep 0.5;
		};
	} foreach (list _ReinforcementZone);

	sleep 2;
	if(_Debug) then {
		format["[AIRBASE] Looking for Players in %1..",_ReinforcementZone] call OKS_fnc_LogDebug;
	};

	if (count _playerHunted != 0) then {
		waitUntil {
			sleep 5;
			if(_Debug) then {
				format["[AIRBASE] Waiting on clearance at spawn position.."] call OKS_fnc_LogDebug;
			};
			(getPos _SpawnPos) nearEntities ["AirVehicle", 25] isEqualTo []
		};
		if(_Debug) then {
			format["[AIRBASE] Spawn Clear & Found player %1 in %2",_ReinforcementZone,_playerHunted] call OKS_fnc_LogDebug;
		};

		_CurrentHuntCount = missionNamespace getVariable ["GOL_CurrentHuntCount",[]];
		_MaxCount = missionNameSpace getVariable ["GOL_Hunt_MaxCount",1];
		_AliveCurrentCount = _CurrentHuntCount select {alive _X};
		_AliveNumber = count _AliveCurrentCount;

		if((_AliveNumber + (_SpareIndex + 1)) <= _MaxCount) then {
			_AirbaseRespawnCount = _AirbaseRespawnCount - 1;
			_PlayerTarget = _playerHunted call BIS_fnc_selectRandom;
			_CalculatedIngress = _PlayerTarget getPos [Random 360,_AirbaseRandomDistanceLZ+(Random _AirbaseRandomDistanceLZ)];
			sleep 5;

			if(_type == "random") then {
				_type = ["unloadthenpatrol","unload","paradrop","paradropandpatrol"] call BIS_fnc_selectRandom;
			};

			switch (toLower _type) do {
				case "unloadthenpatrol": {
					if(_Debug) then {
						"AirBase Running Unload then Patrol" call OKS_fnc_LogDebug;
					};
					[_Side, _SelectedClassname, true, "unload", _SpawnPos, _CalculatedIngress, _EgressPos, _Troops, [_CalculatedIngress],False,true,_ReinforcementZone] spawn OKS_fnc_AirDrop;
				};
				case "unload": {
					if(_Debug) then {
						"AirBase Running Unload" call OKS_fnc_LogDebug;
					};					
					[_Side, _SelectedClassname, False, "unload", _SpawnPos, _CalculatedIngress, _EgressPos, _Troops, [_CalculatedIngress],False,true,_ReinforcementZone] spawn OKS_fnc_AirDrop;
				};
				case "paradrop": {
					if(_Debug) then {
						"AirBase Running Paradrop" call OKS_fnc_LogDebug;
					};					
					[_Side, _SelectedClassname, False, "paradrop", _SpawnPos, _CalculatedIngress, _EgressPos, _Troops, [_CalculatedIngress],False,true,_ReinforcementZone] spawn OKS_fnc_AirDrop;
				};
				case "paradropthenpatrol": {
					if(_Debug) then {
						"AirBase Running Paradrop then Patrol" call OKS_fnc_LogDebug;
					};					
					[_Side, _SelectedClassname, true, "paradrop", _SpawnPos, _CalculatedIngress, _EgressPos, _Troops, [_CalculatedIngress],False,true,_ReinforcementZone] spawn OKS_fnc_AirDrop;
				};								
			};
			if(_Debug) then {
				"Airbase Helicopter Spawned.." call OKS_fnc_LogDebug;
			};		
			_Time = _AirbaseRespawnTimer + (Random _AirbaseRespawnTimer);
			sleep _Time;
		};
	}
	else
	{
		sleep (_AirbaseRefreshRate + (random _AirbaseRefreshRate));
	};
};

if(!alive _Object) then {
	if(_Debug) then {
		format["%1 Base Destroyed - Script Ending",_Object] call OKS_fnc_LogDebug;
	};			
};

if(alive _Object) then {
	if(_Debug) then {
		format["Enemy Respawns Left: %1 - Script Ending.",_AirbaseRespawnCount] call OKS_fnc_LogDebug;
	};			
};