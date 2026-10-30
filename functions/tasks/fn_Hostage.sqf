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
		["_TaskOnStart",false,[false]],
		["_ExitPosition", [], [[], objNull,""]]
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
		_x switchMove "acts_aidlpsitmstpssurwnondnon04";
		removeAllWeapons _X;
		removeGoggles _X;
		removeBackpack _X;
		removeHeadgear _X;
		_X addGoggles "G_Blindfold_01_black_F";

		[_X,_ExitPosition] spawn {
			_this params ["_X","_exitPos"];
			waitUntil {sleep 1; animationState _X != "acts_aidlpsitmstpssurwnondnon_loop" || !Alive _X};
			if(alive _X) then {
				removeGoggles _X;
			};
			if(_exitPos isNotEqualTo []) then {
				_trueExitPos = [];
				_X enableAI "ALL";
				_X allowFleeing 0;
				_X setCaptive false;
				if(typeName _exitPos == "ARRAY") then {
					_X doMove _exitPos;
					_trueExitPos = _exitPos;
				} else {
					if(typeName _exitPos == "OBJECT") then {
						_X doMove (getPos _exitPos);
						_trueExitPos = getPos _exitPos;
					} else {
						_X doMove (getMarkerPos _exitPos);
						_trueExitPos = getMarkerPos _exitPos;
					};
				};

				waitUntil { !Alive _X || (_X distance _trueExitPos < 10) };
				deleteVehicle _X;
			};
		};			
		_X setVariable ["GOL_IsStatic",true,true];
		_X setVariable ["GOL_HVT",true,true];

		[
			_X,																// Object the action is attached to
			"Release Prisoner",													// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdaction_unbind_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdaction_unbind_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 3",									// Condition for the action to be shown
			"_caller distance _target < 3",									// Condition for the action to progress
			{},																// Code executed when action starts
			{},																// Code executed on every progress tick
			{ 
				params ["_target", "_caller", "_actionId"];
				[
					_target,
					"Acts_AidlPsitMstpSsurWnonDnon_out"						// Code executed on completion
				] remoteExec ["playMove",0];			
			},							
			{},																// Code executed on interrupted
			[],																// Arguments passed to the scripts as _this select 3
			1,																// Action duration in seconds
			0,																// Priority
			true,															// Remove on completion
			false															// Show in unconscious state
		] remoteExec ["BIS_fnc_holdActionAdd", 0, true];					// MP-compatible implementation
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
		_TaskDescription = format["You have been tasked with rescuing the hostages, there are %1 in total. Free them using the hold action (default: spacebar)",count _Units];
		[
			true,
			_TaskArray,
			[
				_TaskDescription,
				"Rescue Hostages",
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

	waitUntil {
		sleep 5;
		{animationState _X == "acts_aidlpsitmstpssurwnondnon_loop"} count _Units == 0 
		|| {!Alive _X} count _Units == count _Units
	};

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
