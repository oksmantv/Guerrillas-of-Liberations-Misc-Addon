/*
	Function: OKS_fnc_SeizeAsset

	Description:
		Creates a seize task for an asset. Players hold-action the asset to seize it.
		On completion the asset is locked and the task succeeds. If the asset is
		destroyed first, the task fails.

	Parameters:
		0: _Object            - OBJECT - The asset to be seized (required)
		1: _TaskParent        - STRING - Parent task ID (default: "" = none)
		2: _ShowPosition      - BOOL   - Show asset position on the map (default: true)
		3: _PopUpNotification - BOOL   - Show task popup notifications (default: true)

	Returns:
		Nothing

	Example:
		[asset_1] spawn OKS_fnc_SeizeAsset;
		[asset_1, "Task_Main", false] spawn OKS_fnc_SeizeAsset;
*/

if (!isServer) exitWith {};

params [
	["_Object", objNull, [objNull]],
	["_TaskParent", "", [""]],
	["_ShowPosition", true, [true]],
	["_PopUpNotification", true, [true]]
];

if (isNull _Object || {!alive _Object}) exitWith {};
if (_Object getVariable ["OKS_SeizeAsset_TaskId", ""] isNotEqualTo "") exitWith {};

private _TaskId = format ["OKS_SeizeAsset_%1", netId _Object];
private _DisplayName = [configFile >> "CfgVehicles" >> typeOf _Object] call BIS_fnc_displayName;
private _TaskData = if (_TaskParent isEqualTo "") then {_TaskId} else {[_TaskId, _TaskParent]};
private _Position = if (_ShowPosition) then {getPosATL _Object} else {objNull};

_Object setVariable ["OKS_SeizeAsset_TaskId", _TaskId, true];
_Object setVariable ["OKS_SeizeAsset_Seized", false, true];

[
	true,
	_TaskData,
	[
		format ["You have been tasked with securing and seizing a valuable asset. The asset, a %1, is present in the area of operations. Find it, secure it, and lock it. Use the hold-action to seize it.", _DisplayName],
		format ["Seize %1", _DisplayName],
		""
	],
	_Position,
	"AUTOASSIGNED",
	-1,
	_PopUpNotification,
	"use"
] call BIS_fnc_taskCreate;

// Hold action on every client (and JIP while the object exists). Completion only flags the object, the server loop below handles task state.
[
	_Object,
	format ["<t color='#7ccaff'>Seize %1</t>", _DisplayName],
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa",
	"alive _target && {_this distance _target < 6} && {!(_target getVariable ['OKS_SeizeAsset_Seized', false])}",
	"_caller distance _target < 6",
	{},
	{},
	{
		params ["_target"];
		_target setVariable ["OKS_SeizeAsset_Seized", true, true];
	},
	{},
	[],
	5,
	10,
	true,
	false
] remoteExec ["BIS_fnc_holdActionAdd", 0, _Object];

waitUntil {
	sleep 2;
	!alive _Object || {_Object getVariable ["OKS_SeizeAsset_Seized", false]}
};

if (alive _Object) then {
	// Lock must run where the object is local
	[_Object, 2] remoteExecCall ["lock", _Object];
	[_TaskId, "SUCCEEDED", _PopUpNotification] call BIS_fnc_taskSetState;
} else {
	[_TaskId, "FAILED", _PopUpNotification] call BIS_fnc_taskSetState;
};
