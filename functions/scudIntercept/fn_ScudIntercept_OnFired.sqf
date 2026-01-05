/*
	Fired EH handler.

	Creates a circular "target area" marker (150m, diagonal lines) and a task to intercept the missile.
	Task follows the missile until:
	- Intercepted (proxy vehicle killed) => SUCCEEDED
	- Missile impacts (projectile disappears without proxy-killed) => FAILED
	- Missile altitude <= -20m (ATL) => FAILED

	Expects the launcher to have these variables set before firing:
	- OKS_ScudIntercept_targetPos (ATL position array)
	- OKS_ScudIntercept_taskOwners (default: true / global)
	- OKS_ScudIntercept_taskMeta [title, description]
	- OKS_ScudIntercept_doTask (bool)
*/

if (!isServer) exitWith {};

params ["_launcherVehicle", "_weaponClassname", "_muzzle", "_mode", "_ammoClassname", "_magazineClassname", "_projectile", "_launcherGunner"];
if (isNull _launcherVehicle || isNull _projectile) exitWith {};

private _targetPositionATL = _launcherVehicle getVariable ["OKS_ScudIntercept_targetPos", []];
if (_targetPositionATL isEqualTo []) exitWith {};
private _targetObject = _launcherVehicle getVariable ["OKS_ScudIntercept_targetObj", objNull];

// Store target position on projectile for later proxy-kill evaluation
_projectile setVariable ["OKS_ScudIntercept_targetPos", _targetPositionATL, true];

private _debugEnabled = missionNamespace getVariable ["GOL_ScudIntercept_Debug", true];
private _logDebug = {
	params ["_msg"]; 
	if !(missionNamespace getVariable ["GOL_ScudIntercept_Debug", true]) exitWith {};
	private _chat = missionNamespace getVariable ["GOL_ScudIntercept_DebugChat", false];
	[format ["[SCUDINT] %1", _msg], _chat, !_chat, true] call OKS_fnc_LogDebug;
};

private _zeusEnabled = missionNamespace getVariable ["GOL_ScudIntercept_DebugZeus", true];
private _fnc_addToZeus = {
	params ["_obj"]; 
	if (isNull _obj) exitWith {};
	if !(missionNamespace getVariable ["GOL_ScudIntercept_DebugZeus", true]) exitWith {};
	{
		_x addCuratorEditableObjects [[_obj], true];
	} forEach allCurators;
};

if (_debugEnabled) then {
	[format ["OnFired | veh=%1 type=%2 weapon=%3 ammo=%4 projectile=%5 gunner=%6", _launcherVehicle, typeOf _launcherVehicle, _weaponClassname, _ammoClassname, _projectile, _launcherGunner]] call _logDebug;
	private _attachedNow = attachedObjects _projectile;
	[format ["OnFired | proj netId=%1 local=%2 attachedNow=%3 types=%4", netId _projectile, local _projectile, count _attachedNow, _attachedNow apply {typeOf _x}]] call _logDebug;
};

private _owners = _launcherVehicle getVariable ["OKS_ScudIntercept_taskOwners", true];
private _createTask = _launcherVehicle getVariable ["OKS_ScudIntercept_doTask", true];
private _meta = _launcherVehicle getVariable ["OKS_ScudIntercept_taskMeta", ["Intercept Missile", "Intercept the incoming missile before it impacts."]];

private _proxyClassname = missionNamespace getVariable ["GOL_ScudIntercept_ProxyClassname", "cmc_intercept_cruiseMissile"]; // from CMC intercept

// Proxy spawning is unconditional (intercept should never be a "fake task").
// If caller didn't set meta, try to infer SCUD vs Cruise Missile for better task readability
if (_meta isEqualTo ["Intercept Missile", "Intercept the incoming missile before it impacts."]) then {
	private _kind = _launcherVehicle getVariable ["OKS_ScudIntercept_kind", "Missile"];
	_meta = [format ["Intercept %1", _kind], format ["Intercept the incoming %1 before it impacts.", _kind]];
};
_meta params [
	["_title", "Intercept Missile", [""]],
	["_desc", "Intercept the incoming missile before it impacts.", [""]]
];

private _stamp = floor (diag_tickTime * 1000);
private _taskId = format ["OKS_SCUDINT_%1_%2", netId _launcherVehicle, _stamp];

// Global inbound warning (optional)
if (!isNil "OKS_fnc_Chat") then {
	private _grid = mapGridPosition _targetPositionATL;
	private _kind = _launcherVehicle getVariable ["OKS_ScudIntercept_kind", "missile"];
	private _msg = format ["1st Platoon be advised, %1 inbound towards your position. Estimated impact near GRID %2.", _kind, _grid];
	["HQ", "side", _msg] remoteExec ["OKS_fnc_Chat", 0];
};

// If task/marker is disabled, still enforce missile guidance but skip task UI.

if (!_createTask) exitWith {
	[_projectile, _taskId, _targetPositionATL, _targetObject] spawn {
		params ["_projectile", "_taskId", "_targetPositionATL", "_targetObject"]; 
		private _impactRadiusMeters = 150;
		private _lastPosATL = getPosATL _projectile;
		private _minimumDistanceMeters = 1e10;
		sleep 0.1;
		while {!(isNull _projectile)} do {
			private _pos = getPosATL _projectile;
			_lastPosATL = _pos;
			private _dist = _pos distance2D _targetPositionATL;
			if (_dist < _minimumDistanceMeters) then { _minimumDistanceMeters = _dist; };
			if ((_pos select 2) <= -20) exitWith {
				private _reached = (_minimumDistanceMeters <= _impactRadiusMeters) || {((_pos distance2D _targetPositionATL) <= _impactRadiusMeters)};
				missionNamespace setVariable [format ["OKS_ScudIntercept_reachedTarget_%1", _taskId], _reached, true];
			};
			sleep 0.1;
		};
		private _reached = (_minimumDistanceMeters <= _impactRadiusMeters) || {(_lastPosATL distance2D _targetPositionATL) <= _impactRadiusMeters};
		missionNamespace setVariable [format ["OKS_ScudIntercept_reachedTarget_%1", _taskId], _reached, true];
		if (!isNull _targetObject) then { deleteVehicle _targetObject; };
	};
};

// Create target area marker (circular + diagonal lines)
private _markerName = format ["OKS_SCUD_TARGET_%1_%2", netId _launcherVehicle, _stamp];
private _m = createMarker [_markerName, _targetPositionATL];
_m setMarkerShape "ELLIPSE";
_m setMarkerBrush "DiagGrid";
_m setMarkerSize [250, 250];
_m setMarkerAlpha 0.6;
_m setMarkerColor "ColorRed";

// Border marker (same size, red)
private _markerBorder = format ["%1_BORDER", _markerName];
private _mb = createMarker [_markerBorder, _targetPositionATL];
_mb setMarkerShape "ELLIPSE";
_mb setMarkerBrush "Border";
_mb setMarkerSize [250, 250];
_mb setMarkerAlpha 0.9;
_mb setMarkerColor "ColorRed";

// Warning icon marker
private _markerWarn = format ["%1_WARN", _markerName];
private _mw = createMarker [_markerWarn, _targetPositionATL];
_mw setMarkerShape "ICON";
_mw setMarkerType "mil_warning";
_mw setMarkerSize [0.3, 0.3];
_mw setMarkerColor "ColorRed";
_mw setMarkerText "Missile Strike";
_mw setMarkerAlpha 1;

private _markerNames = [_markerName, _markerBorder, _markerWarn];

// Ensure we have a real, lockable proxy vehicle (CMC may or may not have attached one).
private _proxy = objNull;
private _attachedNow = attachedObjects _projectile;
private _vehCandidatesNow = _attachedNow select { _x isKindOf "AllVehicles" };
_proxy = _vehCandidatesNow param [0, objNull];

if (isNull _proxy) then {
	private _chosenClass = _proxyClassname;
	// Many AA turrets will refuse to engage targets that are not Air-kind (even if tracked).
	// If the requested proxy class is not Air, switch to a side-appropriate Air proxy so AI can engage naturally.
	if ((isClass (configFile >> "CfgVehicles" >> _chosenClass)) && {!(_chosenClass isKindOf "Air")}) then {
		_chosenClass = switch (side _launcherVehicle) do {
			case west: {"B_UAV_01_F"};
			case east: {"O_UAV_01_F"};
			case resistance: {"I_UAV_01_F"};
			default {"B_UAV_01_F"};
		};
	};
	if (!isClass (configFile >> "CfgVehicles" >> _chosenClass)) then {
		_chosenClass = switch (side _launcherVehicle) do {
			case west: {"B_UAV_01_F"};
			case east: {"O_UAV_01_F"};
			case resistance: {"I_UAV_01_F"};
			default {"B_UAV_01_F"};
		};
	};
	if (isClass (configFile >> "CfgVehicles" >> _chosenClass)) then {
		private _pos = getPosASL _projectile;
		_proxy = createVehicle [_chosenClass, ASLToATL _pos, [], 0, "FLY"];
		_proxy allowDamage true;
		_proxy setPosASL _pos;
		_proxy attachTo [_projectile, [0,0,0]];
		private _crewType = switch (side _launcherVehicle) do {
			case east: { "O_UAV_AI" };
			case west: { "B_UAV_AI" };
			case resistance: { "I_UAV_AI" };
			default { "E_UAV_AI" };
		};
		private _crewGroup = createGroup (side _launcherVehicle);
		private _unit = _crewGroup createUnit [_crewType, [0,0,0], [], 0, "CAN_COLLIDE"];
		_unit moveInAny _proxy;
		_unit setCaptive false;
		_proxy engineOn true;
		_proxy setVehicleTIPars [1, 1, 1];
		if (_debugEnabled) then {
			[format ["Proxy spawned | class=%1 (requested=%2) proxy=%3 crewType=%4", _chosenClass, _proxyClassname, _proxy, _crewType]] call _logDebug;
		};
	} else {
		if (_debugEnabled) then { [format ["ERROR: No proxy class available (requested=%1)", _proxyClassname]] call _logDebug; };
	};
};

if (isNull _proxy) exitWith {
	// No proxy means no interceptable target; do not create a misleading task.
	if (_debugEnabled) then { ["Intercept aborted: proxy could not be created"] call _logDebug; };
	{ if (_x != "") then { deleteMarker _x; }; } forEach _markerNames;
	if (!isNull _targetObject) then { deleteVehicle _targetObject; };
};

// Create the task with the PROXY VEHICLE as destination so it auto-follows.
[_owners, _taskId, [_desc, _title, _markerName], _proxy, "CREATED", 1, true, "danger"] call BIS_fnc_taskCreate;

if (_zeusEnabled) then {
	[_projectile] call _fnc_addToZeus;
	[_proxy] call _fnc_addToZeus;
};

_projectile setVariable ["OKS_ScudIntercept_taskId", _taskId];
_projectile setVariable ["OKS_ScudIntercept_marker", _markerName];
_projectile setVariable ["OKS_ScudIntercept_markers", _markerNames];

// Register proxy immediately (no waiting) and hook Killed => success.
missionNamespace setVariable [format ["OKS_ScudIntercept_proxy_%1", _taskId], _proxy, true];

private _activeProxies = missionNamespace getVariable ["OKS_ScudIntercept_activeProxies", []];
_activeProxies pushBackUnique _proxy;
missionNamespace setVariable ["OKS_ScudIntercept_activeProxies", _activeProxies, true];

_proxy setVariable ["OKS_ScudIntercept_taskId", _taskId];
_proxy setVariable ["OKS_ScudIntercept_markers", _markerNames];
_proxy setVariable ["OKS_ScudIntercept_targetPos", _projectile getVariable ["OKS_ScudIntercept_targetPos", []], true];
_proxy setVariable ["OKS_ScudIntercept_successMinDist", missionNamespace getVariable ["GOL_ScudIntercept_SuccessMinDistanceMeters", 50], true];

// Store target object so EHs can clean it up when finishing.
_proxy setVariable ["OKS_ScudIntercept_targetObj", _targetObject];

// Intercept should ALWAYS neutralize the real projectile once the proxy takes any damage.
// This is intentionally aggressive: any hit that registers damage is considered a successful intercept attempt.
private _fnc_finishIntercept = {
	params ["_proxy", ["_reason", "", [""]]];
	if (isNull _proxy) exitWith {};

	// Debounce (HandleDamage can fire many times)
	if (_proxy getVariable ["OKS_ScudIntercept_neutralized", false]) exitWith {};
	_proxy setVariable ["OKS_ScudIntercept_neutralized", true];

	private _taskId = _proxy getVariable ["OKS_ScudIntercept_taskId", ""]; 
	if (_taskId isEqualTo "") exitWith {};

	private _targetPos = _proxy getVariable ["OKS_ScudIntercept_targetPos", []];
	private _minDist = _proxy getVariable ["OKS_ScudIntercept_successMinDist", 50];
	private _tooLate = false;
	if !(_targetPos isEqualTo []) then {
		_tooLate = ((getPosATL _proxy) distance2D _targetPos) <= _minDist;
	};

	private _fnc_spawnNeutralizeExplosion = {
		params [
			["_class", "SmallSecondary", [""]],
			["_posASL", [0,0,0], [[]], 3]
		];

		private _resolved = _class;
		private _cfgAmmo = configFile >> "CfgAmmo" >> _resolved;
		private _cfgVeh = configFile >> "CfgVehicles" >> _resolved;
		if (!(isClass _cfgAmmo) && {!(isClass _cfgVeh)}) then {
			_resolved = "SmallSecondary";
			_cfgAmmo = configFile >> "CfgAmmo" >> _resolved;
			_cfgVeh = configFile >> "CfgVehicles" >> _resolved;
		};

		private _obj = objNull;
		// If it's ammo, spawn and forcibly detonate.
		if (isClass _cfgAmmo) then {
			_obj = createVehicle [_resolved, _posASL, [], 0, "CAN_COLLIDE"];
			if (!isNull _obj) then {
				triggerAmmo _obj;
				// Cleanup if it lingers
				[_obj] spawn { params ["_o"]; sleep 0.2; if (!isNull _o) then { deleteVehicle _o; }; };
			};
		} else {
			// Vehicle/effect classes generally "do their thing" on creation.
			_obj = createVehicle [_resolved, _posASL, [], 0, "CAN_COLLIDE"];
			[_obj] spawn { params ["_o"]; sleep 0.2; if (!isNull _o) then { deleteVehicle _o; }; };
		};
	};

	// Always neutralize the real projectile (if still present)
	private _proj = attachedTo _proxy;
	if (!isNull _proj) then {
		private _posASL = getPosASL _proj;
		deleteVehicle _proj;
		private _explClass = missionNamespace getVariable ["GOL_ScudIntercept_NeutralizeExplosionClass", "SmallSecondary"]; 
		[_explClass, _posASL] call _fnc_spawnNeutralizeExplosion;
	};

	if (_tooLate) then {
		missionNamespace setVariable [format ["OKS_ScudIntercept_success_%1", _taskId], false, true];
		[_taskId, "FAILED", true] call BIS_fnc_taskSetState;
	} else {
		missionNamespace setVariable [format ["OKS_ScudIntercept_success_%1", _taskId], true, true];
		[_taskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
	};

	// Remove target reference object (created by LaunchAI) immediately
	private _targetObject = _proxy getVariable ["OKS_ScudIntercept_targetObj", objNull];
	if (!isNull _targetObject) then { deleteVehicle _targetObject; };

	// Best-effort debug
	if (missionNamespace getVariable ["GOL_ScudIntercept_Debug", true]) then {
		if !(isNil "OKS_fnc_LogDebug") then {
			private _chat = missionNamespace getVariable ["GOL_ScudIntercept_DebugChat", false];
			[format ["[SCUDINT] Intercept finish | reason=%1 task=%2 tooLate=%3", _reason, _taskId, _tooLate], _chat, !_chat, true] call OKS_fnc_LogDebug;
		};
	};
};

// Store finish handler before any damage EH can run.
_proxy setVariable ["OKS_ScudIntercept_fnc_finish", _fnc_finishIntercept];

_proxy addEventHandler ["HandleDamage", {
	params ["_proxy", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
	if (!isServer) exitWith { _damage };
	if (_damage > 0) then {
		[_proxy, "damaged"] spawn (_proxy getVariable ["OKS_ScudIntercept_fnc_finish", {}]);
	};
	_damage
}];

_proxy addEventHandler ["Killed", {
	params ["_proxy"]; 
	if (!isServer) exitWith {};
	[_proxy, "killed"] spawn (_proxy getVariable ["OKS_ScudIntercept_fnc_finish", {}]);
}];


// Follow/update loop
[_projectile, _taskId, _markerNames, _targetPositionATL, _targetObject] spawn {
	params ["_projectile", "_taskId", "_markerNames", "_targetPositionATL", "_targetObject"]; 
	private _debugEnabled = missionNamespace getVariable ["GOL_ScudIntercept_Debug", true];
	private _logDebug = {
		params ["_msg"]; 
		if !(missionNamespace getVariable ["GOL_ScudIntercept_Debug", true]) exitWith {};
		private _chat = missionNamespace getVariable ["GOL_ScudIntercept_DebugChat", false];
		[format ["[SCUDINT] %1", _msg], _chat, !_chat, true] call OKS_fnc_LogDebug;
	};
	private _impactRadiusMeters = 150;
	private _lastPosATL = getPosATL _projectile;
	private _minimumDistanceMeters = 1e10;
	private _startTimeSeconds = time;
	sleep 0.1;
	while {true} do {
		private _state = [_taskId] call BIS_fnc_taskState;
		if (_state in ["SUCCEEDED", "FAILED", "CANCELED"]) exitWith {
			{ if (_x != "") then { deleteMarker _x; }; } forEach _markerNames;
			private _proxyObject = missionNamespace getVariable [format ["OKS_ScudIntercept_proxy_%1", _taskId], objNull];
			if (!isNull _proxyObject) then {
				private _activeProxies = missionNamespace getVariable ["OKS_ScudIntercept_activeProxies", []];
				_activeProxies = _activeProxies - [_proxyObject];
				missionNamespace setVariable ["OKS_ScudIntercept_activeProxies", _activeProxies, true];
				deleteVehicle _proxyObject;
			};
			if (!isNull _targetObject) then { deleteVehicle _targetObject; };
		};

		if (isNull _projectile) exitWith {
			private _success = missionNamespace getVariable [format ["OKS_ScudIntercept_success_%1", _taskId], false];
			private _proxyObject = missionNamespace getVariable [format ["OKS_ScudIntercept_proxy_%1", _taskId], objNull];
			if (_success) then {
				[_taskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
				if (_debugEnabled) then { ["Projectile ended: SUCCESS (proxy killed)"] call _logDebug; };
			} else {
				private _reached = (_minimumDistanceMeters <= _impactRadiusMeters) || {((_lastPosATL distance2D _targetPositionATL) <= _impactRadiusMeters)};
				missionNamespace setVariable [format ["OKS_ScudIntercept_reachedTarget_%1", _taskId], _reached, true];
				[_taskId, "FAILED", true] call BIS_fnc_taskSetState;
				if (_debugEnabled) then { [format ["Projectile ended: FAILED (no proxy kill) | minDist=%1", _minimumDistanceMeters]] call _logDebug; };
			};
			{ if (_x != "") then { deleteMarker _x; }; } forEach _markerNames;
			if (!isNull _proxyObject) then {
				private _activeProxies = missionNamespace getVariable ["OKS_ScudIntercept_activeProxies", []];
				_activeProxies = _activeProxies - [_proxyObject];
				missionNamespace setVariable ["OKS_ScudIntercept_activeProxies", _activeProxies, true];
				deleteVehicle _proxyObject;
			};
			if (!isNull _targetObject) then { deleteVehicle _targetObject; };
		};

		private _pos = getPosATL _projectile;
		_lastPosATL = _pos;
		private _dist = _pos distance2D _targetPositionATL;
		if (_dist < _minimumDistanceMeters) then { _minimumDistanceMeters = _dist; };

		if ((_pos select 2) <= -20) exitWith {
			private _reached = (_minimumDistanceMeters <= _impactRadiusMeters) || {(_pos distance2D _targetPositionATL) <= _impactRadiusMeters};
			missionNamespace setVariable [format ["OKS_ScudIntercept_reachedTarget_%1", _taskId], _reached, true];
			[_taskId, "FAILED", true] call BIS_fnc_taskSetState;
			{ if (_x != "") then { deleteMarker _x; }; } forEach _markerNames;
			private _proxyObject = missionNamespace getVariable [format ["OKS_ScudIntercept_proxy_%1", _taskId], objNull];
			if (!isNull _proxyObject) then {
				private _activeProxies = missionNamespace getVariable ["OKS_ScudIntercept_activeProxies", []];
				_activeProxies = _activeProxies - [_proxyObject];
				missionNamespace setVariable ["OKS_ScudIntercept_activeProxies", _activeProxies, true];
				deleteVehicle _proxyObject;
			};
			if (!isNull _targetObject) then { deleteVehicle _targetObject; };
		};

		private _updateIntervalSeconds = if ((time - _startTimeSeconds) < 8) then {0.1} else {0.5};
		sleep _updateIntervalSeconds;
	};
};
