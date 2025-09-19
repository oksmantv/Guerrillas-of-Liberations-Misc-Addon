/*
	Function: OKS_fnc_Hostage
	Description: Creates hostage rescue scenario with units that need to be freed from captivity
	
	Parameters:
	0: _UnitsOrGroupOrArray - Units to be set as hostages (OBJECT, GROUP, or ARRAY)
	1: _TaskParent - Parent task ID (STRING) [Optional]
	2: _TaskOnStart - Whether to create task immediately or on completion (BOOL) [Optional, default: false]
	
	Example Usage:
	[Group HVT_1] spawn OKS_fnc_Hostage;
	[Group HVT_1, "ParentTask", true] spawn OKS_fnc_Hostage;
*/

if(!isServer) exitWith {};

Private _HostageDebug = missionNamespace getVariable ["GOL_HVT_Debug",false];

	Params [
		["_UnitsOrGroupOrArray",[],[[],grpNull,objNull]],
		["_TaskParent",nil,[""]],
		["_TaskOnStart",false,[false]]
	];

	if(_HostageDebug) then {
		format["[HOSTAGE TASK] fn_Hostage started with params: Units=%1, TaskParent=%2, TaskOnStart=%3", _UnitsOrGroupOrArray, _TaskParent, _TaskOnStart] spawn OKS_fnc_LogDebug;
	};

	Private ["_Units","_ExfilPosition","_TaskDescription"];
	if(typeName _UnitsOrGroupOrArray == "OBJECT") then {
		_Units = [_UnitsOrGroupOrArray];
		group _UnitsOrGroupOrArray setVariable ["acex_headless_blacklist",true,true];
		if(_HostageDebug) then {
			format["[HOSTAGE TASK] Processing single unit: %1", name _UnitsOrGroupOrArray] spawn OKS_fnc_LogDebug;
		};
	};
	if(typeName _UnitsOrGroupOrArray == "GROUP") then {
		_Units = units _UnitsOrGroupOrArray;
		_UnitsOrGroupOrArray setVariable ["acex_headless_blacklist",true,true];
		if(_HostageDebug) then {
			format["[HOSTAGE TASK] Processing group with %1 units", count _Units] spawn OKS_fnc_LogDebug;
		};
	};
	if(typeName _UnitsOrGroupOrArray == "ARRAY") then {
		_Units = _UnitsOrGroupOrArray;
		(Group (_Units select 0)) setVariable ["acex_headless_blacklist",true,true];
		if(_HostageDebug) then {
			format["[HOSTAGE TASK] Processing array with %1 units", count _Units] spawn OKS_fnc_LogDebug;
		};
	};

	{
		if(_HostageDebug) then {
			format["[HOSTAGE TASK] %1 set to captive hostage.", name _X] spawn OKS_fnc_LogDebug;
		};
		_X disableAI "MOVE";
		_X setUnitPos "UP";
		_X setCaptive true;
		[_X, true] call ACE_captives_fnc_setHandcuffed;
		removeAllWeapons _X;
		removeGoggles _X;
		removeBackpack _X;
		removeHeadgear _X;
		_X addGoggles "G_Blindfold_01_black_F";

		_X spawn {
			waitUntil {sleep 1; !(_this getVariable ["ace_captives_isHandcuffed", true]) || !Alive _this};
			if(alive _this) then {
				removeGoggles _this;
			};			
		};			
		_X setVariable ["GOL_IsStatic",true,true];
		_X setVariable ["GOL_HVT",true,true];
	} forEach _Units;
	
	Private _TaskId = format["HostageTask_%1",(random 9999)];
	Private _TaskArray = _TaskId;
	if(!isNil "_TaskParent") then {
		_TaskArray = [_TaskId,_TaskParent]
	};

	_TaskPosition = [0, 0, 0];
	{
		_TaskPosition = _TaskPosition vectorAdd (getPosWorld _x);
	} forEach _Units;
	_TaskPosition = _TaskPosition vectorMultiply (1 / (count _Units));		

	if(_TaskOnStart) then {
		_TaskDescription = format["You have been tasked with rescuing the hostages, there are %1 in total. Once released, leave them and move on with your mission.",count _Units];
		[
			true,
			_TaskArray,
			[
				_TaskDescription,
				"Rescued Hostages",
				"Rescue"
			],
			_TaskPosition,
			"CREATED",
			-1,
			false,
			"help"
		] call BIS_fnc_taskCreate;	
		
		if(_HostageDebug) then {
			format["[HOSTAGE TASK] Task created at start with ID: %1, Position: %2, Units: %3", _TaskId, _TaskPosition, count _Units] spawn OKS_fnc_LogDebug;
		};
	};

	waitUntil {sleep 5; {(_X getVariable ["ace_captives_isHandcuffed", true])} count _Units == 0 || {!Alive _X} count _Units == count _Units};
	if({!Alive _X} count _Units == count _Units) exitWith {
		// Fail
		if(_HostageDebug) then {
			format["[HOSTAGE TASK] All hostages died - FAILED"] spawn OKS_fnc_LogDebug;
		};

		if(_TaskOnStart) then {
			[_TaskId, "FAILED", true] call BIS_fnc_taskSetState;	
		} else {
			_TaskDescription = format["You have failed to rescue the hostages, there were %1 in total.",count _Units];
			[
				true,
				_TaskArray,
				[
					_TaskDescription,
					"Hostage Rescue",
					"Rescue"
				],
				_TaskPosition,
				"FAILED",
				-1,
				true,
				"help"
			] call BIS_fnc_taskCreate;	
			
			if(_HostageDebug) then {
				format["[HOSTAGE TASK] Task created on failure with ID: %1", _TaskId] spawn OKS_fnc_LogDebug;
			};
		}	
	};

	// Succeeded
	if(_HostageDebug) then {
		format["[HOSTAGE TASK] Hostages rescued successfully - SUCCEEDED"] spawn OKS_fnc_LogDebug;
	};

	if(_TaskOnStart) then {
		[_TaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;			
	} else {
		_TaskDescription = format["You have rescued the hostages, there are %1 alive out of %2 in total. Leave them and move on with your mission.",{Alive _X} count _Units,count _Units];
		[
			true,
			_TaskArray,
			[
				_TaskDescription,
				"Hostage Rescue",
				"Rescue"
			],
			_TaskPosition,
			"SUCCEEDED",
			-1,
			true,
			"help"
		] call BIS_fnc_taskCreate;	
		
		if(_HostageDebug) then {
			format["[HOSTAGE TASK] Task created on success with ID: %1", _TaskId] spawn OKS_fnc_LogDebug;
		};
	};
