/*
	Adds an ACE interaction action to a Mobile Service Station object,
	allowing players to rearm nearby UK3CB vehicles via cargo magazines.

	Called from server-side setup using remoteExec (client-side only).

	[_crate] remoteExecCall ["OKS_fnc_AddMSSRearm3CBAction", 0, _crate];
*/

params ["_crate"];

if (!hasInterface) exitWith {};
if (isNull _crate) exitWith {};
if (!alive _crate) exitWith {};

if (_crate getVariable ["OKS_MSS_Rearm3CB_ActionAdded", false]) exitWith {};
_crate setVariable ["OKS_MSS_Rearm3CB_ActionAdded", true];

waitUntil {
	sleep 0.5;
	!isNil "ace_interact_menu_fnc_createAction" &&
	!isNil "ace_interact_menu_fnc_addActionToObject" &&
	!isNil "ace_interact_menu_fnc_createVehiclesActions"
};

// We want to fill/extend the original ACE Rearm "Take ammo" action instead of adding
// a second empty holder. So we capture it (if present), remove it, and re-add a combined
// action under the same original action name: "ace_rearm_takeAmmo".

private _origTakeAmmoAction = [];
private _timeoutAt = diag_tickTime + 5;
waitUntil {
	sleep 0.1;
	private _actions = _crate getVariable ["ace_interact_menu_actions", []];
	private _idx = _actions findIf {
		private _action = _x # 0;
		private _path = _x # 1;
		(_path isEqualTo ["ACE_MainActions"]) && {(_action # 0) isEqualTo "ace_rearm_takeAmmo"}
	};
	if (_idx > -1) then {
		_origTakeAmmoAction = (_actions # _idx) # 0;
	};
	(!(_origTakeAmmoAction isEqualTo [])) || {diag_tickTime > _timeoutAt}
};

// Clean up any previous custom holder we might have added in older iterations.
private _actionsNow = _crate getVariable ["ace_interact_menu_actions", []];
_actionsNow = _actionsNow select {
	private _action = _x # 0;
	private _id = _action # 0;
	!(_id in ["OKS_Rearm3CBVehicle"])
};
_crate setVariable ["ace_interact_menu_actions", _actionsNow];

private _origCondition = if (_origTakeAmmoAction isEqualTo []) then {nil} else {_origTakeAmmoAction # 4};
private _origInsertChildren = if (_origTakeAmmoAction isEqualTo []) then {nil} else {_origTakeAmmoAction # 5};

private _condition = {
	params ["_target", "_player", "_params"];
	if (isNull _target || {!alive _target}) exitWith {false};
	if (!(_target getVariable ["ace_rearm_isSupplyVehicle", false])) exitWith {false};

	private _radius = missionNamespace getVariable ["ACE_rearm_distance", 20];
	private _vehicles = nearestObjects [_target, ["LandVehicle", "Helicopter", "Plane"], _radius];
	private _has3CB = (_vehicles findIf { alive _x && { (typeOf _x find "UK3CB_BAF") == 0 } }) > -1;

	private _hasAce = false;
	if (!isNil "_origCondition") then {
		_hasAce = [_target, _player, _params] call _origCondition;
	};

	_has3CB || _hasAce
};

private _insertChildren = {
	params ["_target", "_player", "_params"];

	private _radius = missionNamespace getVariable ["ACE_rearm_distance", 20];
	private _vehicles = nearestObjects [_target, ["LandVehicle", "Helicopter", "Plane"], _radius];
	_vehicles = _vehicles select { alive _x && { (typeOf _x find "UK3CB_BAF") == 0 } };

	private _statement = {
		params ["_target", "_player", "_vehicle"]; // _target is the service station; _vehicle is action parameter
		[10, [_vehicle, _player], {
			(_this select 0) params ["_vehicle", "_player"];
			[_vehicle, _player] remoteExecCall ["OKS_fnc_Rearm3CBVehicle", 2];
		}, {}, "[3CB] Rearming..."] call ace_common_fnc_progressBar;
	};

	private _children3CB = [];
	if !(_vehicles isEqualTo []) then {
		_children3CB = [_vehicles, _statement, _target] call ace_interact_menu_fnc_createVehiclesActions;
	};

	private _childrenAce = [];
	if (!isNil "_origInsertChildren") then {
		_childrenAce = [_target, _player, _params] call _origInsertChildren;
		if (!(_childrenAce isEqualType [])) then { _childrenAce = []; };
	};

	_children3CB + _childrenAce
};

// If the original ACE action isn't present yet, fall back to adding our custom action.
private _actionId = if (_origTakeAmmoAction isEqualTo []) then {"OKS_Rearm3CBVehicle"} else {"ace_rearm_takeAmmo"};
private _actionTitle = if (_origTakeAmmoAction isEqualTo []) then {"Rearm 3CB Vehicle"} else {_origTakeAmmoAction # 1};
private _actionIcon = if (_origTakeAmmoAction isEqualTo []) then {"\A3\ui_f\data\IGUI\Cfg\Actions\reammo_ca.paa"} else {_origTakeAmmoAction # 2};

private _action = [
	_actionId,
	_actionTitle,
	_actionIcon,
	{},
	_condition,
	_insertChildren
] call ace_interact_menu_fnc_createAction;

// If ACE already added its own takeAmmo, remove it from this object and replace it.
if (!(_origTakeAmmoAction isEqualTo [])) then {
	private _actions = _crate getVariable ["ace_interact_menu_actions", []];
	_actions = _actions select {
		private _a = _x # 0;
		private _p = _x # 1;
		!((_p isEqualTo ["ACE_MainActions"]) && {(_a # 0) isEqualTo "ace_rearm_takeAmmo"})
	};
	_crate setVariable ["ace_interact_menu_actions", _actions];
};

[_crate, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
