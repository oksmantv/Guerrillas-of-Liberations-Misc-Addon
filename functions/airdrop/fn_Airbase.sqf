

// Created by Oksman
/*

		[Base Object, SpawnObject, Trigger, Side , "Helicopter Classname","Type Of Insert",[NumberOfGroups,%ofVehicleCargoSpace]] spawn OKS_fnc_Airbase;

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

		Examples on code:
		[Object_1,Spawn_1,Trigger_1,EAST,"O_Heli_Light_02_dynamicLoadout_F","Unload",[2,1]] spawn OKS_fnc_Airbase;


		Step-by-Step Guide:
		You need two objects, you need a base object and a spawn object. Place down a destructible object and name it 'Object_1'
		(When this object is destroyed, the "base" is destroyed thus it will not spawn more units)

		Next create a spawn object and name it 'Spawn_1', this could be any object but I suggest using a tiny object such as 'Box of matches'. This is the object the helicopter will use to spawn on top of.
		(You can also use a helipad but this will make AI helicopters land on these spawns if the base is within or close to the trigger area.)

		You now need a Trigger, create a trigger and name it Trigger_1. Set the activation to "Any Players" and set it to "Repeatable". All this is chosen in the trigger properties (Double-click the trigger).
		(This is now the trigger area the enemy spawned units will hunt inside, this means if players are detected within this trigger, they will start spawning units and start hunting. When they leave the AI will cease hunting and cease spawning.)

		You now have all the necessary editor placed objects to use the code. You have a base object, spawn object and a trigger. Now open your spawnList.sqf and paste the following:
		[Object_1, Spawn_1, Trigger_1,EAST,"O_Heli_Light_02_unarmed_F","Unload",[2,1]] spawn OKS_fnc_Airbase;

		The final properties in the bracket above is:
		Side, Helicopter Classname, 		Type of Insert, [Number of Groups, Procentage of Cargo Space].
		EAST  "O_Heli_Light_02_unarmed_F"	"Unload"		[2, 1]

		These are the properties you have to change to match whatever you need. Now when you activate your spawnList case through the standard triggers, your base will initiate. To have them spawn in, you need to be detected by the enemy side and reach a knowsAbout value above 3.5. Get into CQB with the enemy and this should activate the hunting bases.

*/

if (!isServer) exitWith {false};		// Ensures only server

_Object = _this select 0; // Base Object that can be destroyed to stop reinforcements
_SpawnPos = _this select 1; // Helipad at Airbase that spawns helicopters
_ReinforcementZone = _this select 2; // Zone that AI will reinforce if contested by players
_OKS_Side = _this select 3; // Side of Helicopter Reinforcements
_Classname = _this select 4; // Helicopter Classname
_Type = _this select 5; // "Unload" or "Drop"
_Troops = _this select 6; // [2,1] - [ProcentageofCargoSpace,NumberOfTeamsToSplitInto]
_PlayerTarget = objNull;

Private ["_AirbaseRespawnTimer","_AirbaseRandomDistanceLZ","_AirbaseRefreshRate","_AirbaseRespawnCount","_EgressPos","_playerHunted","_OKS_Side","_VehicleClassName","_VehicleClassNameArray"];
Private _Side = _OKS_Side;
_type = toLower _type;

#include "fn_Airdrop_Settings.sqf"

if(typeName _Classname == "ARRAY") then {
	_Classname = selectRandom _Classname
};
_Heli = CreateVehicle [_Classname, [0,0,0], [], 0, "CAN_COLLIDE"];
_Heli enableSimulation false;
_Heli allowDamage false;
_EmptyCargoSeats = (_Heli emptyPositions "Cargo");
_UnitsPerGroup = round ( (round (_EmptyCargoSeats * (_Troops select 1))) / (_Troops select 0) );	// # OF GROUPS = (_Units select 0)  ||  % OF CARGO = (_Units select 1)
_SpareIndex = ( (round (_EmptyCargoSeats * (_Troops select 1))) - (_UnitsPerGroup * (_Troops select 0)) );
deleteVehicle _Heli;

While {Alive _Object && _AirbaseRespawnCount > 0 } do {

	_playerHunted = [];

	{
		if (([_ReinforcementZone, _x] call BIS_fnc_inTrigger) && (_OKS_Side knowsAbout _X > 3.5 || _OKS_Side knowsAbout vehicle _X > 3.5) && (isTouchingGround (vehicle _X)))
		then
		{
			_playerHunted pushBackUnique _X; sleep 0.5;
		};
	} foreach (AllPlayers - (Entities "HeadlessClient_F"));

	sleep 2;
	SystemChat str _playerHunted;

	if (count _playerHunted != 0) then {
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
				_type = ["unloadthenpatrol","unload","slingdrop","fastrope"] call BIS_fnc_selectRandom;
			};

			switch (_type) do {
				case "unloadthenpatrol": {
					SystemChat "Running Unload then Patrol";
					[_OKS_Side, _Classname, true, _Type, _SpawnPos, _CalculatedIngress, _EgressPos, _Troops, [_CalculatedIngress],False,true,_ReinforcementZone] spawn OKS_fnc_AirDrop;
				};
				case "unload": {
					SystemChat "Running Unload";
					[_OKS_Side, _Classname, False, _Type, _SpawnPos, _CalculatedIngress, _EgressPos, _Troops, [_CalculatedIngress],False,true,_ReinforcementZone] spawn OKS_fnc_AirDrop;
				};
			};

			SystemChat "Helicopter Spawned...";
			_Time = _AirbaseRespawnTimer + (Random _AirbaseRespawnTimer);
			sleep _Time;
		};
	}
	else
	{
		sleep _AirbaseRefreshRate;
	};

};

if(!alive _Object) then {
	SystemChat format["%1 Base Destroyed - Script Ending",_Object];
};

if(alive _Object) then {
	SystemChat format["Enemy Respawns Left: %1 - Script Ending.",_AirbaseRespawnCount];
};