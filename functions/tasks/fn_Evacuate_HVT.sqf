/*
	Function: OKS_fnc_Evacuate_HVT

	Description:
	Handles the evacuation of a High-Value Target (HVT) by a specified group to a designated exfiltration site.

	Parameters:
	0: Group | Array | Unit - The units that will be set to HVTs.
	1: Array - The position of the exfiltration site where the HVT will be evacuated. If _HelicopterEvac is set to true, it will mark the landing site, if off it will land the task completion site. (Type: Array or Trigger or Object)
	2: Side - The side (faction) of the evacuating helicopter. (Type: Side)
	3: Boolean - Whether the evacuation should be done by AI Helicopter. (Type: Boolean)
	4: String - The parent task ID to which this task will be linked. (Type: String)
	5: Boolean - Whether the HVTs should be set as captive. If true, they will be set to captive and will not fight back. (Type: Boolean)
	6: Boolean - Whether the task should be created in the "ASSIGNED" state immediately. If true, the task will be created and set to "ASSIGNED" state. (Type: Boolean)

	Example Usage:
	[Group HVT_1, getPos ExfilSite_1, west, false, nil, true, false] spawn OKS_fnc_Evacuate_HVT;
*/

if(!isServer) exitWith {};

Private _HVTDebug = missionNamespace getVariable ["GOL_HVT_Debug",false];

Params [
	["_UnitsOrGroupOrArray",[],[[],grpNull,objNull]],
	["_ExfilSite",[0,0,0],[[],objNull]],
	["_Side",west,[sideUnknown]],
	["_HelicopterEvac",false,[false]],
	["_ParentTask","",[""]],
	["_IsCaptive",true,[true]],
	["_TaskOnStart",false,[false]],
	["_CustomDescription",nil,[""]]
];

if(_HVTDebug) then {
	format["[HVT TASK] fn_Evacuate_HVT started with params: Units=%1, ExfilSite=%2, Side=%3, HelicopterEvac=%4, ParentTask=%5, IsCaptive=%6, TaskOnStart=%7, CustomDescription=%8", _UnitsOrGroupOrArray, _ExfilSite, _Side, _HelicopterEvac, _ParentTask, _IsCaptive, _TaskOnStart, _CustomDescription] call OKS_fnc_LogDebug;
};

Private ["_Units","_ExfilPosition","_TaskDescription"];
if(typeName _UnitsOrGroupOrArray == "OBJECT") then {
	_Units = [_UnitsOrGroupOrArray];
	group _UnitsOrGroupOrArray setVariable ["acex_headless_blacklist",true,true];
	if(_HVTDebug) then {
		format["[HVT TASK] Processing single unit: %1", name _UnitsOrGroupOrArray] call OKS_fnc_LogDebug;
	};
};
if(typeName _UnitsOrGroupOrArray == "GROUP") then {
	_Units = units _UnitsOrGroupOrArray;
	_UnitsOrGroupOrArray setVariable ["acex_headless_blacklist",true,true];
	if(_HVTDebug) then {
		format["[HVT TASK] Processing group with %1 units", count _Units] call OKS_fnc_LogDebug;
	};
};
if(typeName _UnitsOrGroupOrArray == "ARRAY") then {
	_Units = _UnitsOrGroupOrArray;
	(Group (_Units select 0)) setVariable ["acex_headless_blacklist",true,true];
	if(_HVTDebug) then {
		format["[HVT TASK] Processing array with %1 units", count _Units] call OKS_fnc_LogDebug;
	};
};
if(typeName _ExfilSite == "OBJECT") then {
	_ExfilPosition = getPos _ExfilSite;
	if(_HVTDebug) then {
		format["[HVT TASK] Exfil site is object at position %1", _ExfilPosition] call OKS_fnc_LogDebug;
	};
} else {
	_ExfilPosition = _ExfilSite;
	if(_HVTDebug) then {
		format["[HVT TASK] Exfil site is position %1", _ExfilPosition] call OKS_fnc_LogDebug;
	};
};

{
	_x setVariable ["GOL_SurrenderEnabled",true,true];
	_x setVariable ["GOL_HVT",true,true];
	if([_X] call GW_Common_Fnc_getSide != civilian) then {
		waitUntil {sleep 1; primaryWeapon _X != ""};
		removeAllWeapons _X;
	};	

	if(_isCaptive) then {		
		if(_HVTDebug) then {
			format["[HVT TASK] %1 set to captive HVT.", name _X] call OKS_fnc_LogDebug;
		};
		_X disableAI "MOVE";
		_X disableAI "AUTOTARGET";
		_X disableAI "TARGET";
		_X setUnitPos "MIDDLE";
		_X setCaptive true;
		_X spawn {
			waitUntil {sleep 2; _this getVariable ["GW_Gear_appliedGear",false]};
			removeAllWeapons _this;
			removeGoggles _this;
			removeBackpack _this;
			removeHeadgear _this;
			_this addGoggles "G_Blindfold_01_black_F";
			_this playMove "acts_aidlpsitmstpssurwnondnon04";

			waitUntil {sleep 1; _this getVariable ["ace_captives_isHandcuffed", false] || !Alive _this};
			if(alive _this) then {
				removeGoggles _this;
			};			
		};			
	} else {
		if(_HVTDebug) then {
			format["[HVT TASK] %1 set to hostile HVT.", name _X] call OKS_fnc_LogDebug;
		};
		_X disableAI "PATH";
		if(!isNil "OKS_fnc_Surrender") then {
			[_x, 0.5, 0.25, 50, 25, true, true, 25, true] spawn OKS_fnc_Surrender;
		};
	};
	_X setVariable ["GOL_IsStatic",true,true];
} forEach _Units;

if(_HVTDebug) then {
	format["[HVT TASK] Finished processing %1 HVT units. IsCaptive=%2", count _Units, _IsCaptive] call OKS_fnc_LogDebug;
};

Private _TaskId = format["RescueHVTTask_%1",(random 9999)];

waitUntil {sleep 1; {_X getVariable ["ace_captives_isHandcuffed", false]} count _Units > 0 || {!Alive _X} count _Units == count _Units || _TaskOnStart};

if(_HVTDebug) then {
	format["[HVT TASK] Wait condition met. Handcuffed units: %1, Dead units: %2, TaskOnStart: %3", {_X getVariable ["ace_captives_isHandcuffed", false]} count _Units, {!Alive _X} count _Units, _TaskOnStart] call OKS_fnc_LogDebug;
};

Private _TaskState = "ASSIGNED";
if({!Alive _X} count _Units == count _Units) then {
	_TaskState = "FAILED";
	if(_HVTDebug) then {
		format["[HVT TASK] All HVTs are dead, setting task to FAILED"] call OKS_fnc_LogDebug;
	};
};

private _markerName = format ["OKS_ExfilSite_%1", round (random 99999)];
private _exfilMarker = createMarker [_markerName, _ExfilPosition];
private _descriptionText = "You have found HVTs to extract";
if(_TaskOnStart) then {
	_descriptionText = "You have been tasked with finding and extracting HVTs";
};

if(_HelicopterEvac) then {
	_TaskDescription = format["%2, there are %1 in total. Transport them to the <marker name='%3'>exfil site</marker> and await the helicopter that will extract them.",count _Units,_descriptionText,_exfilMarker];
} else {
	_TaskDescription = format["%2, there are %1 in total. Transport them to the <marker name='%3'>exfil site</marker>.",count _Units,_descriptionText,_exfilMarker];
};

if(!isNil "_CustomDescription") then {
	_TaskDescription = _CustomDescription;
	if(_HVTDebug) then {
		format["[HVT TASK] Custom task description applied: %1", _CustomDescription] call OKS_fnc_LogDebug;
	};	
};

_TaskArray = [_TaskId];
if(!isNil "_ParentTask") then {
	_TaskArray pushBack _ParentTask;
};

_UnitsArray = _Units;
_TaskPosition = [0, 0, 0];
{
	_TaskPosition = _TaskPosition vectorAdd (getPosWorld _x);
} forEach _UnitsArray;
_TaskPosition = _TaskPosition vectorMultiply (1 / (count _UnitsArray));	

[
	true,
	_TaskArray,
	[
		_TaskDescription,
		"Extract HVT",
		"Extract"
	],
	_TaskPosition,
	_TaskState,
	-1,
	true,
	"exit",
	false
] call BIS_fnc_taskCreate;

if(_HVTDebug) then {
	format["[HVT TASK] Task created with ID: %1, State: %2, Position: %3", _TaskId, _TaskState, _TaskPosition] call OKS_fnc_LogDebug;
};

if(_TaskState == "FAILED") exitWith {false};

// Use inArea if exfil is a trigger, otherwise use distance
private _isTrigger = (typeName _ExfilSite == "OBJECT") && {triggerArea _ExfilSite isEqualType []};
waitUntil {
	sleep 15;
	{
		!Alive _X ||
		(
			if (_isTrigger) then {
				_X inArea _ExfilSite && vehicle _X == _X
			} else {
				_X distance _ExfilPosition < 100 && vehicle _X == _X
			}
		)
	} count _Units == count _Units
};

if(_HVTDebug) then {
	format["[HVT TASK] Units reached exfil site. HelicopterEvac: %1", _HelicopterEvac] call OKS_fnc_LogDebug;
};

if(_HelicopterEvac) then {
	if({!Alive _X} count _Units == count _Units) exitWith {
		// Fail
		if(_HVTDebug) then {
			format["[HVT TASK] All HVTs died before helicopter extraction - FAILED"] call OKS_fnc_LogDebug;
		};
		[_TaskId, "FAILED", true] call BIS_fnc_taskSetState;			
	};

	if(_HVTDebug) then {
		format["[HVT TASK] Calling helicopter for extraction"] call OKS_fnc_LogDebug;
	};
	["hq","side","Be advised, extraction helicopter is inbound for your HVTs. Load them up when it arrives, HQ out"] remoteExec ["OKS_fnc_Chat",0];
	[_Side,"",["helicopter_Spawn",_ExfilPosition,"helicopter_despawn","helicopter_despawn"],false] execVM "Scripts\NEKY_PickUp\NEKY_PickUp.sqf";

	waitUntil{sleep 15; {!Alive _X || (ObjectParent _X) isKindOf "Helicopter"} count _Units == count _Units};
	if(_HVTDebug) then {
		format["[HVT TASK] HVTs loaded into helicopter or died"] call OKS_fnc_LogDebug;
	};
};

if({!Alive _X} count _Units == count _Units) exitWith {
	// Fail
	if(_HVTDebug) then {
		format["[HVT TASK] All HVTs died during final phase - FAILED"] call OKS_fnc_LogDebug;
	};
	[_TaskId, "FAILED", true] call BIS_fnc_taskSetState;		
};

// Succeeded
if(_HVTDebug) then {
	format["[HVT TASK] Mission completed successfully - SUCCEEDED"] call OKS_fnc_LogDebug;
};
[_TaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;		
		
