

// Created by Oksman
/*

	[Base, SpawnPos, HuntZone, Waves, RespawnDelay, Side, SpawnConfig, RefreshRate, ShouldDeployFlare, WaypointBehaviour] spawn OKS_fnc_HuntBase;

	Script Parameters:
		Base              - Destructible object. When destroyed, no further waves spawn.
		SpawnPos          - Small object defining the spawn position and direction (face in the direction vehicles should spawn).
		HuntZone          - Trigger defining the hunt area (set to "Any Players", repeatable).
		Waves             - Maximum number of waves (0–999). Scaled by GOL_ForceMultiplier at runtime.
		RespawnDelay      - Seconds between waves. Scaled by GOL_ResponseMultiplier.
		Side              - Faction side of spawned units (east, west, independent).
		SpawnConfig       - Defines what to spawn each wave. See types below.
		RefreshRate       - Seconds between player detection checks. Lower = faster response.
		ShouldDeployFlare - (Optional) Fire illumination flares at night. Default: true.
		WaypointBehaviour - (Optional) AI waypoint behaviour string. Default: "AWARE" for infantry, "SAFE" for vehicles.

	SpawnConfig Types:

		SCALAR  — Spawn N infantry in one group.
		          6

		STRING  — Spawn one specific vehicle (crewed by the faction).
		          "CUP_O_BTR40_MG_TKM"

		ARRAY   — Random selection pool. ONE entry is picked randomly per wave.
		          Each entry is either a STRING (single vehicle) or an ARRAY (convoy definition).

		  Flat array of strings → random pick, one vehicle chosen per wave:
		          ["CUP_O_T72_TK", "CUP_O_T55_TK", "CUP_O_BMP2_TK"]

		  Single convoy option (always selected, all vehicles spawn in one group):
		          [["CUP_O_T72_TK", "CUP_O_BMP2_TK"]]

		  Convoy with random vehicle slots (inner array = pick one from alternatives):
		          [[["CUP_O_T72_TK","CUP_O_T55_TK"], "CUP_O_BMP2_TK"]]
		          → first vehicle is randomly T72 or T55, second is always BMP2

		  Multiple convoy options, one chosen per wave:
		          [["CUP_O_T72_TK","CUP_O_BMP2_TK"], ["CUP_O_T55_TK","CUP_O_BTR40_TK"]]
		          → each wave spawns either convoy A or convoy B

		  Mixed pool (convoy option AND single vehicle option):
		          [["CUP_O_T72_TK","CUP_O_BMP2_TK"], "CUP_O_BRDM2_HQ_TK"]
		          → each wave either spawns the T72+BMP2 convoy, or a single BRDM2

	Convoy behaviour:
		- All convoy vehicles are placed in one AI group and hunt together.
		- Vehicles are spaced 20 m apart behind the spawn object, aligned to its facing direction.
		- Transport vehicles (no gunner seats) are automatically filled with cargo infantry,
		  capped by GOL_MaxCargoSeats.
		- The group moves in COLUMN formation.

	Examples:

		Infantry:
		[Object_1, Spawn_1, HuntTrigger_1, 10, 300, EAST, 6, 60] spawn OKS_fnc_HuntBase;

		Single specific vehicle:
		[Object_1, Spawn_1, HuntTrigger_1, 10, 450, EAST, "UK3CB_ARD_O_BMP1", 30] spawn OKS_fnc_HuntBase;

		Random vehicle pick (one of three, chosen per wave):
		[Object_1, Spawn_1, HuntTrigger_1, 10, 450, EAST, ["UK3CB_ARD_O_T72BM","UK3CB_ARD_O_T72A","UK3CB_ARD_O_T72B"], 30] spawn OKS_fnc_HuntBase;

		Fixed convoy (tank always leads, IFV follows):
		[Object_1, Spawn_1, HuntTrigger_1, 6, 600, EAST, [["UK3CB_ARD_O_T72BM","UK3CB_ARD_O_BMP1"]], 120] spawn OKS_fnc_HuntBase;

		Convoy with random lead vehicle:
		[Object_1, Spawn_1, HuntTrigger_1, 6, 600, EAST, [[["UK3CB_ARD_O_T72BM","UK3CB_ARD_O_T72A"], "UK3CB_ARD_O_BMP1"]], 120] spawn OKS_fnc_HuntBase;

		Mixed pool — two convoy options plus one solo vehicle, one chosen per wave:
		[Object_1, Spawn_1, HuntTrigger_1, 8, 600, EAST, [["UK3CB_ARD_O_T72BM","UK3CB_ARD_O_BMP1"], ["UK3CB_ARD_O_T72A","UK3CB_ARD_O_BMP2"], "UK3CB_ARD_O_Ural_Zu23"], 120] spawn OKS_fnc_HuntBase;

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
	["_SpawnConfig", 0, ["",0,[]]],	// SCALAR = infantry count | STRING = vehicle class | ARRAY of strings = random pick | ARRAY with nested arrays = convoy group
	["_RefreshRate", 0, [0]],
	["_ShouldDeployFlare",false,[true]],
	["_WaypointBehaviour",nil,[""]]
];

private _oks_multiplier = missionNamespace getVariable ["GOL_SpawnMultiplier", 100];
private _oks_blacklisted = missionNamespace getVariable ["GOL_SpawnMultiplier_Blacklist_HuntBase", false];
private _oks_applyMultiplier = (_oks_multiplier < 100) && {!_oks_blacklisted};
if (_oks_applyMultiplier && { _SpawnConfig isEqualType 0 }) then {
	_SpawnConfig = (ceil (_SpawnConfig * _oks_multiplier / 100)) max 1;
};

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

if(typeName _SpawnConfig == "SCALAR" && isNil "_WaypointBehaviour") then {
	_WaypointBehaviour = "AWARE";
};
if(typeName _SpawnConfig != "SCALAR" && isNil "_WaypointBehaviour") then {
	_WaypointBehaviour = "SAFE";
};
if(isNil "_WaypointBehaviour") then {
	_WaypointBehaviour = "SAFE";
};

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
				if(typeName _SpawnConfig == "SCALAR") then
				{
					private _unitCount = _SpawnConfig * _ForceMultiplier;
					_Waves = _Waves - 1;
					if(!isNil "_CurrentHuntCount") then {
						_AliveCurrentCount = _CurrentHuntCount select {alive _X};
					} else {
						_AliveCurrentCount = 0
					};
					_AliveNumber = count _AliveCurrentCount;
					private _MaxCount = missionNameSpace getVariable ["GOL_Hunt_MaxCount",40];
					if(_MaxCount >= (_AliveNumber + _unitCount)) then {

						_Group = CreateGroup _Side;
						for "_i" from 1 to _unitCount do
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
					} else {
						if(_Debug) then {
							"[HUNT] Max Units Reached - Not Spawning" call OKS_fnc_LogDebug;
						};
					}
				};

				if(typeName _SpawnConfig == "STRING" || typeName _SpawnConfig == "ARRAY") then {
					_AliveNumber = count (_CurrentHuntCount select {alive _X});

					// If _SpawnConfig is an ARRAY, pick one entry at random.
					// Each entry is either a STRING (single vehicle) or an ARRAY (convoy definition).
					// Within a convoy array, each position is STRING (fixed class) or ARRAY (random pick from alternatives).
					private _selectedEntry = if (typeName _SpawnConfig == "ARRAY") then {
						_SpawnConfig call BIS_fnc_selectRandom
					} else {
						_SpawnConfig
					};

					if (typeName _selectedEntry == "STRING") then {
						// SINGLE VEHICLE MODE
						if((_MaxCount * _ForceMultiplier) >= _AliveNumber) then {
							_Waves = _Waves - 1;
							waitUntil {
								sleep 10;
								if(_Debug) then {
									"[HUNT] Waiting for clearance near _Spawn" spawn OKS_fnc_LogDebug;
								};
								(getPos _SpawnPos nearEntities ["LandVehicle", 15]) isEqualTo []
							};

							_Vehicle = CreateVehicle [_selectedEntry, _SpawnPos, [], 0, "CAN_COLLIDE"];
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
										_CurrentHuntCount = missionNamespace getVariable ["GOL_CurrentHuntCount",[]];
										_CurrentHuntCount pushBackUnique _Unit;
										missionNamespace setVariable ["GOL_CurrentHuntCount",_CurrentHuntCount];

									for "_i" from 1 to (_CargoSeats - 1) do
									{
										Private "_Unit";
										_Unit = _Group CreateUnit [(_Units call BIS_FNC_selectRandom), [0,0,50], [], 0, "NONE"];
										_Unit setRank "PRIVATE";
										_CurrentHuntCount = missionNamespace getVariable ["GOL_CurrentHuntCount",[]];
										_CurrentHuntCount pushBackUnique _Unit;
										missionNamespace setVariable ["GOL_CurrentHuntCount",_CurrentHuntCount];
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
						} else {
							if(_Debug) then {
								"[HUNT] Max Units Reached - Not Spawning" call OKS_fnc_LogDebug;
							};
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

					if (typeName _selectedEntry == "ARRAY") then {
						// CONVOY MODE: spawn all vehicles in the selected entry as one group.
						// Each position: STRING = fixed class, ARRAY of strings = random pick for that slot.
						if((_MaxCount * _ForceMultiplier) >= _AliveNumber) then {
							_Waves = _Waves - 1;
							private _convoyDir = getDir _SpawnPos;
							private _convoyBase = getPosWorld _SpawnPos;
							private _convoyGroup = grpNull;

							{
								private _convoyIdx = _forEachIndex;
								private _vehicleDef = _x;
								private _vehClass = "";
								if (typeName _vehicleDef == "STRING") then {
									_vehClass = _vehicleDef;
								} else {
									_vehClass = _vehicleDef call BIS_fnc_selectRandom;
								};
								private _vehPos = [
									(_convoyBase select 0) + ((_convoyIdx * 20) * sin(_convoyDir + 180)),
									(_convoyBase select 1) + ((_convoyIdx * 20) * cos(_convoyDir + 180)),
									0
								];

								waitUntil {
									sleep 5;
									(_vehPos nearEntities ["LandVehicle", 15]) isEqualTo []
								};

								private _convoyVehicle = createVehicle [_vehClass, _vehPos, [], 0, "CAN_COLLIDE"];
								_convoyVehicle setDir _convoyDir;

								if (isNull _convoyGroup) then {
									_convoyGroup = [_convoyVehicle, _Side] call OKS_fnc_AddVehicleCrew;
								} else {
									private _tempGroup = [_convoyVehicle, _Side] call OKS_fnc_AddVehicleCrew;
									(units _tempGroup) join _convoyGroup;
									if (count units _tempGroup == 0) then { deleteGroup _tempGroup };
								};

								if (_convoyVehicle emptyPositions "gunner" == 0 && _convoyVehicle emptyPositions "cargo" > 0) then {
									private _cargoSeats = ([typeOf _convoyVehicle, true] call BIS_fnc_crewCount) - ([typeOf _convoyVehicle, false] call BIS_fnc_crewCount);
									if (_cargoSeats > _MaxCargoSeats) then { _cargoSeats = _MaxCargoSeats };
									for "_i" from 1 to _cargoSeats do {
										private _cargoUnit = _convoyGroup createUnit [(_Units call BIS_fnc_selectRandom), [0,0,50], [], 0, "NONE"];
										_cargoUnit setRank "PRIVATE";
										_cargoUnit moveInCargo _convoyVehicle;
										_CurrentHuntCount pushBackUnique _cargoUnit;
									};
								};

								{ _CurrentHuntCount pushBackUnique _x } forEach (crew _convoyVehicle);

								if (_Debug) then {
									format ["[HUNT] Convoy vehicle %1 spawned: %2", _convoyIdx + 1, _vehClass] call OKS_fnc_LogDebug;
								};

								if (_convoyIdx < (count _selectedEntry - 1)) then { sleep 2 };
							} forEach _selectedEntry;

							missionNamespace setVariable ["GOL_CurrentHuntCount", _CurrentHuntCount];
							[_convoyGroup, _SkillVariables, _Skill] spawn OKS_fnc_SetSkill;
							_convoyGroup allowFleeing 0;
							_convoyGroup setFormation "COLUMN";
							_convoyGroup setVariable ["OKS_Hunt_Formation", "COLUMN"];

							if (_Debug) then {
								format ["[HUNT] Convoy formed with %1 units", count units _convoyGroup] call OKS_fnc_LogDebug;
							};

							sleep 5;
							if (count units _convoyGroup > 1) then {
								[_convoyGroup, nil, _HuntZone, 0, 30, 0, {}, _WaypointBehaviour] spawn OKS_fnc_HuntRun;
							};
						} else {
							if(_Debug) then {
								"[HUNT] Max Units Reached - Not Spawning" call OKS_fnc_LogDebug;
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


