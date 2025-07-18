

// Created by Oksman
/*

		[Base Object, SpawnObject, Trigger, Number Of Waves,Respawn Delay,Side,Number of Soldiers / Vehicle Classname,Refresh Rate] spawn OKS_fnc_HuntBase;

		Script Parameters:
    	Base Object - If this object is destroyed the camp will no longer spawn attacks, use something that can be destroyed such as trucks, tents, buildings etc.
		SpawnObject - Set down a small object (box of matches) and face the direction you want the vehicle/group to spawn in
		Trigger - Set up a trigger used to define the hunting space for these reinforcements, set it to Any Players and repeatable for best effect.
		Number of Waves - Select number of waves using a SCALAR value (0-999)
		Respawn Delay - Select in seconds how long between spawns and respawns of waves
		Side - The side of the faction you wanted spawned
		Soldiers or Classname - SCALAR or ARRAY - If you select numbers there will be X amount of soldiers in 1 group. If you input a string Example: "CUP_O_BTR40_MG_TKM" you will get this vehicle crewed by the faction the vehicle is      based on. If you want to have a randomly selected vehicle you can input an Array with strings, example: ["CUP_O_MTLB_pk_TK_MILITIA","CUP_O_BTR40_MG_TKM","CUP_O_Ural_ZU23_TKM","CUP_O_BTR90_RU"]
		Refresh Rate - Time in seconds you want the script to refresh their knowledge of Players inside the hunt zone, quickens the response with shorter refresh, but increases slightly in the performance cost.

		Examples on code:
		[Object_1, Spawn_1, HuntTrigger_1, 10, 300,EAST,6,60] spawn OKS_fnc_HuntBase;
		[Object_1, Spawn_1, HuntTrigger_1, 10, 450,EAST,"CUP_O_BTR40_MG_TKM",30] spawn OKS_fnc_HuntBase;
		[Object_1, Spawn_1, HuntTrigger_1, 10, 450,EAST,["CUP_O_MTLB_pk_TK_MILITIA","CUP_O_BTR40_MG_TKM","CUP_O_Ural_ZU23_TKM","CUP_O_BTR90_RU"],30] spawn OKS_fnc_HuntBase;

		Step-by-Step Guide:
		You need two objects, you need a base object and a spawn object. Place down a destructible object and name it 'Object_1'
		(When this object is destroyed, the "base" is destroyed thus it will not spawn more units)

		Next create a spawn object and name it 'Spawn_1', this could be any object but I suggest using a tiny object such as 'Grass Cutter (Small)'. This is the object the units/vehicle will use to spawn on top of.
		(You can also use a invisible helipad but this will make AI helicopters land on these spawns in some occasions, so not recommended.)

		You now need a Trigger, create a trigger and name it HuntTrigger_1. Set the activation to "Any Players" and set it to "Repeatable". All this is chosen in the trigger properties (Double-click the trigger).
		(This is now the trigger area the enemy spawned units will hunt inside, this means if players are detected within this trigger, they will start spawning units and start hunting. When they leave the AI will cease hunting and cease spawning.)

		You now have all the necessary editor placed objects to use the code. You have a base object, spawn object and a trigger. Now open your spawnList.sqf and paste the following:
		[Object_1, Spawn_1, HuntTrigger_1, 10,300,EAST,6,30] spawn NEKY_Hunt_HuntBase;

		The final properties in the bracket above is:
		Number of Waves, Respawn Delay, Side, Soldiers and Refresh Rate.
		10				 300			EAST  6			   30

		These are the properties you have to change to match whatever you need. Now when you activate your spawnList case through the standard triggers, your base will initiate. To have them spawn in, you need to be detected by the enemy side and reach a knowsAbout value above 3.5. Get into CQB with the enemy and this should activate the hunting bases.

*/

if (!isServer) exitWith {false};	// Ensures only server


Params
[
	["_Base", ObjNull, [ObjNull]],
	["_SpawnPos", ObjNull, [ObjNull]],
	["_HuntZone", ObjNull, [ObjNull]],
	["_Waves", 0, [0]],
	["_RespawnDelay", 0, [0]],
	["_Side", East, [sideUnknown]],
	["_Soldiers", 0, ["",0,[]]],
	["_RefreshRate", 0, [0]],
	["_ShouldDeployFlare",true,[true]],
	["_WaypointBehaviour","SAFE",[""]]
];

Private ["_Group","_Leaders","_Units","_Vehicle","_VehicleClass",
"_MaxCargoSeats","_Trigger","_MaxUnits","_KnowsAboutValue",
"_DetectDelay","_ShouldDeployFlare","_CurrentHuntCount","_AliveCurrentCount"];

sleep 5;
_IsNight = false;
_Settings = [_Side] call OKS_fnc_Hunt_Settings;
_Settings Params ["_MinDistance","_UpdateFreqSettings","_SkillVariables","_Skill","_Leaders","_Units","_MaxCargoSeats","_HeliClass", "_PilotClasses", "_CrewClasses"];

private _Debug = missionNamespace getVariable ["GOL_Hunt_Debug", false];
private _ForceMultiplier = missionNameSpace getVariable ["GOL_ForceMultiplier",1];
private _ResponseMultiplier = missionNameSpace getVariable ["GOL_ResponseMultiplier",1];
private _MaxCount = missionNameSpace getVariable ["GOL_Hunt_MaxCount",1];
private _ResponseMultiplier = missionNameSpace getVariable ["GOL_ResponseMultiplier",1];

_Trigger = createTrigger ["EmptyDetector", getPosWorld _SpawnPos, false];
_Trigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
_Trigger setTriggerArea [300, 300, 0, false];

_EyeCheck = createVehicle ["Land_ClutterCutter_small_F", [getPos _SpawnPos select 0,getPos _SpawnPos select 1,(getPos _SpawnPos select 2) + 3], [], 0, "CAN_COLLIDE"];
_EyeCheck hideObject true;
_EyeCheck enableSimulation false;


while {alive _Base && (_Waves * _ForceMultiplier) > 0} do
{
	_CurrentHuntCount = missionNamespace getVariable ["GOL_CurrentHuntCount",[]];
	_ForceMultiplier = missionNameSpace getVariable ["GOL_ForceMultiplier",1];
	_ResponseMultiplier = missionNameSpace getVariable ["GOL_ResponseMultiplier",1];
	_MaxCount = missionNameSpace getVariable ["GOL_Hunt_MaxCount",1];
	_ResponseMultiplier = missionNameSpace getVariable ["GOL_ResponseMultiplier",1];	
	
	if ((dayTime > 04.30) and (dayTime < 19.30)) then {_KnowsAboutValue = 3.6} else {_KnowsAboutValue = 3.975; _IsNight = true;};
	
	if(_Debug) then {
		format["[HUNT] Looking for Players in %1..",_HuntZone] call OKS_fnc_LogDebug;
	};

	_ThirdSide = independent;
	if(_Side == independent) then {
		_ThirdSide = east;
	};

	_PlayerKnownToSpawner = ({
		((_Side knowsAbout _X > _KnowsAboutValue || _Side knowsAbout vehicle _X > _KnowsAboutValue) && isTouchingGround (vehicle _X) && (isPlayer _X)) ||
		((_ThirdSide knowsAbout _X > _KnowsAboutValue || _ThirdSide knowsAbout vehicle _X > _KnowsAboutValue) && isTouchingGround (vehicle _X) && (isPlayer _X) && _ThirdSide getFriend (side group _X) < 0.6 ) 
	} count list _HuntZone > 0);
	if(_PlayerKnownToSpawner) then {
		_DetectDelay = round((_RefreshRate * _ResponseMultiplier) + (Random _RefreshRate * _ResponseMultiplier));
		if(_Debug) then {
			format["[HUNT] Players detected in %1 - Delay %2 seconds",_HuntZone,_DetectDelay] call OKS_fnc_LogDebug;
		};
		sleep _DetectDelay;

		//SystemChat str [({isTouchingGround (vehicle _X) && (isPlayer _X) && [objNull, "VIEW"] checkVisibility [eyePos _X, getPosASL _EyeCheck] >= 0.6} count AllPlayers < 1),({isTouchingGround (vehicle _X) && (isPlayer _X)} count list _Trigger < 1)];

		if( {isTouchingGround (vehicle _X) && (isPlayer _X) && [objNull, "VIEW"] checkVisibility [eyePos _X, getPosASL _EyeCheck] >= 0.6} count AllPlayers > 0 || {isTouchingGround (vehicle _X) && (isPlayer _X)} count list _Trigger > 0 ) then {
			if({isTouchingGround (vehicle _X) && isPlayer _X} count list _Trigger > 0) exitWith {
				if(_Debug) then {
					"[HUNT] Players Nearby - Exiting Script" call OKS_fnc_LogDebug;
				};
			};
		}
		else
		{
			_PlayerKnownToSpawner = ({
				((_Side knowsAbout _X > _KnowsAboutValue || _Side knowsAbout vehicle _X > _KnowsAboutValue) && isTouchingGround (vehicle _X) && (isPlayer _X)) ||
				((_ThirdSide knowsAbout _X > _KnowsAboutValue || _ThirdSide knowsAbout vehicle _X > _KnowsAboutValue) && isTouchingGround (vehicle _X) && (isPlayer _X) && _ThirdSide getFriend (side group _X) < 0.6 ) 
			} count list _HuntZone > 0);
			if(_PlayerKnownToSpawner) then {
				if(_Debug) then {
					format["[HUNT] Players confirmed in %1",_HuntZone] call OKS_fnc_LogDebug;
				};
				
				if(_ShouldDeployFlare && _IsNight) then {
					_flare = "F_20mm_Red" createvehicle ((_Base) ModelToWorld [0,0,500]); 
					_flare setVelocity [0,0,-10];
				};
				if(typeName _Soldiers == "SCALAR") then
				{
					_Soldiers = _Soldiers * _ForceMultiplier;
					_Waves = _Waves - 1;
					if(!isNil "_CurrentHuntCount") then {
						_AliveCurrentCount = _CurrentHuntCount select {alive _X};
					} else {
						_AliveCurrentCount = 0
					};
					_AliveNumber = count _AliveCurrentCount;
					private _MaxCount = missionNameSpace getVariable ["GOL_Hunt_MaxCount",40];
					if(_MaxCount >= (_AliveNumber + _Soldiers)) then {

						_Group = CreateGroup _Side;
						for "_i" from 1 to _Soldiers do
						{
							Private "_Unit";
							if ( (count (units _Group)) == 0 ) then
							{
								_Unit = _Group CreateUnit [(_Units call BIS_FNC_selectRandom), _SpawnPos, [], 0, "NONE"];
								_Unit setRank "SERGEANT";
								if(!isNil "_CurrentHuntCount") then {
									_CurrentHuntCount = missionNamespace getVariable ["GOL_CurrentHuntCount",[]];
									_CurrentHuntCount pushBackUnique _Unit;
									missionNamespace setVariable ["GOL_CurrentHuntCount",_CurrentHuntCount];
								};
							} else {
								_Unit = _Group CreateUnit [(_Units call BIS_FNC_selectRandom), _SpawnPos, [], 0, "NONE"];
								_Unit setRank "PRIVATE";
								if(!isNil "_CurrentHuntCount") then {
									_CurrentHuntCount = missionNamespace getVariable ["GOL_CurrentHuntCount",[]];
									_CurrentHuntCount pushBackUnique _Unit;
									missionNamespace setVariable ["GOL_CurrentHuntCount",_CurrentHuntCount];
								};
							};
						};

						//SystemChat str [_Skill,_SkillVariables,_Group];
						[_Group, _SkillVariables, _Skill] spawn OKS_fnc_SetSkill;
						_Group AllowFleeing 0;

						sleep 1;
						[_Group, nil, _HuntZone, 0, 30, 0, {}, _WaypointBehaviour] spawn OKS_fnc_HuntRun;
					};
				};

				if(typeName _Soldiers == "STRING" || typeName _Soldiers == "ARRAY") then {
					_AliveNumber  = count (_CurrentHuntCount select {alive _X});
					if((_MaxCount * _ForceMultiplier) >= _AliveNumber) then {
						_Waves = _Waves - 1;
						waitUntil {
							sleep 10;
							if(_Debug) then {
								"[HUNT] Waiting for clearance near _Spawn" spawn OKS_fnc_LogDebug;
							};
							(getPos _SpawnPos nearEntities ["LandVehicle", 15]) isEqualTo []
						};

						if(typeName _Soldiers == "ARRAY") then {
							_VehicleClass = _Soldiers call BIS_fnc_selectRandom;
							_Vehicle = CreateVehicle [_VehicleClass, _SpawnPos, [], 0, "CAN_COLLIDE"];
						}
						else
						{
							_Vehicle = CreateVehicle [_Soldiers, _SpawnPos, [], 0, "CAN_COLLIDE"];
						};

						_Vehicle setDir getDir _SpawnPos;
						if((_Vehicle emptyPositions "gunner" == 0)) then {
							if(_Debug) then {
								"[HUNT] Vehicle is a transport" call OKS_fnc_LogDebug;
							};
							_CargoSeats = ([TypeOf _Vehicle,true] call BIS_fnc_crewCount) - (["TypeOf _Vehicle",false] call BIS_fnc_crewCount);
							if(_CargoSeats > _MaxCargoSeats) then { _CargoSeats = _MaxCargoSeats };

							_AliveCurrentCount = _CurrentHuntCount select {alive _X};
							_AliveNumber = count _AliveCurrentCount;

							if((_AliveNumber + (_CargoSeats + 1)) <= _MaxCount && _Vehicle emptyPositions "cargo" > 0) then {
									_Group = [_Vehicle,_Side] call OKS_fnc_AddVehicleCrew;
									if(_Debug) then {
										"[HUNT] Creating Transport Cargo..." call OKS_fnc_LogDebug;
									};
									_Unit = _Group CreateUnit [(_Units call BIS_FNC_selectRandom), [0,0,50], [], 0, "NONE"];
									_Unit setRank "SERGEANT";
									_Unit MoveInCargo _Vehicle;
									_Group selectLeader _Unit;
									_CurrentHuntCount = missionNamespace getVariable ["CurrentHuntCount",[]];
									_CurrentHuntCount pushBackUnique _Unit;
									missionNamespace setVariable ["CurrentHuntCount",_CurrentHuntCount];

								for "_i" from 1 to (_CargoSeats - 1) do
								{
									Private "_Unit";
									_Unit = _Group CreateUnit [(_Units call BIS_FNC_selectRandom), [0,0,50], [], 0, "NONE"];
									_Unit setRank "PRIVATE";
									_CurrentHuntCount = missionNamespace getVariable ["CurrentHuntCount",[]];
									_CurrentHuntCount pushBackUnique _Unit;
									missionNamespace setVariable ["CurrentHuntCount",_CurrentHuntCount];
									_Unit MoveInCargo _Vehicle;
								};
								_Group setVariable ["GW_Performance_autoDelete", false, true];
								[_Group, _SkillVariables, _Skill] spawn OKS_fnc_SetSkill;
								_Group AllowFleeing 0;
							};
						}
						else
						{
							_Group = [_Vehicle,_Side] call OKS_fnc_AddVehicleCrew; 
						};

						{_CurrentHuntCount pushBackUnique _X} foreach crew _Vehicle;
					};
					sleep 5;
					if(!isNil "_Group") then {
						if(count units _Group > 1) then {
							[_Group, nil, _HuntZone, 0, 30, 0, {}, _WaypointBehaviour] spawn OKS_fnc_HuntRun;
						} else {
							deleteVehicle driver _Vehicle;
							deleteVehicle _vehicle;
							if(_Debug) then {
								"[HUNT] Only Driver Active - Removing Vehicle.." call OKS_fnc_LogDebug;
							};							
						};
					};
				};

				sleep 5;
				_AliveNumber = count (_CurrentHuntCount select {alive _X});
				sleep (_RespawnDelay * _ResponseMultiplier);
			};
		};
	}
	else
	{
		sleep (_RefreshRate * _ResponseMultiplier);
	};

};

if(!alive _Base) exitWith {
	if(_Debug) then {
	 	"[HUNT] Base Destroyed - Exiting Script" call OKS_fnc_LogDebug;
	};
	 deleteVehicle _Base;
};
if(_Waves == 0) exitWith { 
	if(_Debug) then {
	 	"[HUNT] Waves Depleted - Exiting Script" call OKS_fnc_LogDebug;
	};
	deleteVehicle _Base;
};


