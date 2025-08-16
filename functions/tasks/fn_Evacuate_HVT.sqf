/*
	Function: OKS_fnc_Evacuate_HVT

	Description:
	Handles the evacuation of a High-Value Target (HVT) by a specified group to a designated exfiltration site.

	Parameters:
	0: Group | Array | Unit - The units that will be set to HVTs.
	1: Array - The position of the exfiltration site where the HVT will be evacuated. If _HelicopterEvac is set to true, it will mark the landing site, if off it will land the task completion site. (Type: Array or Position)
	2: Side - The side (faction) of the evacuating helicopter. (Type: Side)
	3: Boolean - Whether the evacuation should be done by AI Helicopter. (Type: Boolean)
	4: String - The parent task ID to which this task will be linked. (Type: String)
	5: Boolean - Whether the HVTs should be set as captive. If true, they will be set to captive and will not fight back. (Type: Boolean)
	6: Boolean - Whether the task should be created in the "ASSIGNED" state immediately. If true, the task will be created and set to "ASSIGNED" state. (Type: Boolean)

	Example Usage:
	[Group HVT_1, getPos ExfilSite_1, west, false, nil] spawn OKS_fnc_Evacuate_HVT;
*/

if(!isServer) exitWith {};

	Params [
		["_UnitsOrGroupOrArray",[],[[],grpNull,objNull]],
		["_ExfilSite",[0,0,0],[[],objNull]],
		["_Side",west,[sideUnknown]],
		["_HelicopterEvac",false,[false]],
		["_ParentTask","",[""]],
		["_IsCaptive",true,[true]],
		["_TaskOnStart",false,[false]]
	];

	Private ["_Units","_ExfilPosition","_TaskDescription"];
	if(typeName _UnitsOrGroupOrArray == "OBJECT") then {
		_Units = [_UnitsOrGroupOrArray];
		group _UnitsOrGroupOrArray setVariable ["acex_headless_blacklist",true,true];
	};
	if(typeName _UnitsOrGroupOrArray == "GROUP") then {
		_Units = units _UnitsOrGroupOrArray;
		_UnitsOrGroupOrArray setVariable ["acex_headless_blacklist",true,true];
	};
	if(typeName _UnitsOrGroupOrArray == "ARRAY") then {
		_Units = _UnitsOrGroupOrArray;
		(Group (_Units select 0)) setVariable ["acex_headless_blacklist",true,true];
	};
	if(typeName _ExfilSite == "OBJECT") then {
		_ExfilPosition = getPos _ExfilSite;
	} else {
		_ExfilPosition = _ExfilSite;
	};

	{
		_x setVariable ["GOL_SurrenderEnabled",true,true];
		_x setVariable ["GOL_HVT",true,true];
		if([_X] call GW_Common_Fnc_getSide != civilian) then {
			waitUntil {sleep 1; primaryWeapon _X != ""};
			removeAllWeapons _X;
		};	

		if(_isCaptive) then {		
			format["[HVT TASK] %1 set to captive HVT.", name _X] call OKS_fnc_LogDebug;
			_X disableAI "ALL";
			_X setUnitPos "MIDDLE";
			_X setCaptive true;

			waitUntil {sleep 2; _X getVariable ["GW_Gear_Applied",false]};
			removeAllWeapons _X;
			removeGoggles _X;
			removeBackpack _X;
			removeHeadgear _X;
			_X addGoggles "G_Blindfold_01_black_F";
			_X playMove "acts_aidlpsitmstpssurwnondnon04";

			_X spawn {
				waitUntil {sleep 1; _this getVariable ["ace_captives_isHandcuffed", false] || !Alive _this};
				if(alive _this) then {
					removeGoggles _this;
				};			
			};			
		} else {
			format["[HVT TASK] %1 set to hostile HVT.", name _X] call OKS_fnc_LogDebug;
			_X disableAI "PATH";
			if(!isNil "OKS_fnc_Surrender") then {
				[_x, 0.5, 0.25, 50, 25, true, true, 25, true] spawn OKS_fnc_Surrender;
			};
		};
		_X setVariable ["GOL_IsStatic",true,true];
	} forEach _Units;
	
	Private _TaskId = format["RescueHVTTask_%1",(random 9999)];

	waitUntil {sleep 5; {_X getVariable ["ace_captives_isHandcuffed", false]} count _Units > 0 || {!Alive _X} count _Units == count _Units || _TaskOnStart};

	Private _TaskState = "ASSIGNED";
	if({!Alive _X} count _Units == count _Units) then {
		_TaskState = "FAILED";
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

	if(_TaskState == "FAILED") exitWith {false};

	waitUntil {sleep 15; {!Alive _X || _X distance _ExfilPosition < 100 && vehicle _X == _x} count _Units == count _Units};

	if(_HelicopterEvac) then {
		if({!Alive _X} count _Units == count _Units) exitWith {
			// Fail
			[_TaskId, "FAILED", true] call BIS_fnc_taskSetState;			
		};

		["hq","side","Be advised, extraction helicopter is inbound for your HVTs. Load them up when it arrives, HQ out"] remoteExec ["OKS_fnc_Chat",0];
		[_Side,"",["helicopter_Spawn",_ExfilPosition,"helicopter_despawn","helicopter_despawn"],false] execVM "Scripts\NEKY_PickUp\NEKY_PickUp.sqf";

		waitUntil{sleep 15; {!Alive _X || (ObjectParent _X) isKindOf "Helicopter"} count _Units == count _Units};
	};

	if({!Alive _X} count _Units == count _Units) exitWith {
		// Fail
		[_TaskId, "FAILED", true] call BIS_fnc_taskSetState;		
	};

	// Succeeded
	[_TaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;		
		
