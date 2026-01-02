/*
	Simplest usage:
	[launcher, targetPosATL_or_objectOrTrigger, crewSide, prepTime, doTask] spawn OKS_fnc_ScudIntercept_LaunchAI;

	Full usage:
	[launcher, targetPosATL_or_objectOrTrigger, crewSide, prepTime, allowedWeapons, weaponToFire, turretPath, doTask] spawn OKS_fnc_ScudIntercept_LaunchAI;

	Server-side helper to "prepare" a SCUD/VLS-style launcher and fire it.
	Also arms the intercept+task system by storing context on the launcher.

	Notes:
	- This does NOT try to magically solve aiming for every mod. It will:
	  - Call known AI functions if they exist (RHS)
	  - Otherwise fall back to BIS_fnc_fire with provided weapon/turret.
*/

if (!isServer) exitWith {false};

params [
	["_launcherVehicle", objNull, [objNull]],
	["_target", [], [[], objNull]],
	["_launcherSide", east, [sideUnknown]],
	["_preparationTimeSeconds", 15, [0]],
	["_allowedWeaponClassnames", [], [[]]],
	["_weaponClassnameToFire", "", [""]],
	["_weaponTurretPath", [-1], [[]]],
	["_createTask", true, [true]]
];

if (isNull _launcherVehicle) exitWith {false};

private _targetPositionATL = [];
if (_target isEqualType []) then {
	_targetPositionATL = _target;
} else {
	if (isNull _target) exitWith {false};
	// Trigger (EmptyDetector) => pick player cluster center; otherwise just use object position.
	if ((typeOf _target) isEqualTo "EmptyDetector") then {
		_targetPositionATL = [_target] call OKS_fnc_ScudIntercept_PickTargetPos;
		if (isNil "_targetPositionATL") exitWith {false};
	} else {
		_targetPositionATL = getPosATL _target;
	};
};

if (_targetPositionATL isEqualTo []) exitWith {false};

private _dbg = missionNamespace getVariable ["GOL_ScudIntercept_Debug", true];
private _fnc_dbg = {
	params ["_msg"]; 
	if !(missionNamespace getVariable ["GOL_ScudIntercept_Debug", true]) exitWith {};
	private _chat = missionNamespace getVariable ["GOL_ScudIntercept_DebugChat", false];
	// Default: RPT only (silent) to avoid systemChat garbling under spam
	[format ["[SCUDINT] %1", _msg], _chat, !_chat, true] call OKS_fnc_LogDebug;
};

// Resolve unknown side early (we need it for target-side selection)
if (_launcherSide isEqualTo sideUnknown) then {
	private _sideNum = getNumber (configFile >> "CfgVehicles" >> typeOf _launcherVehicle >> "side");
	switch (_sideNum) do {
		case 0: {_launcherSide = east;};
		case 1: {_launcherSide = west;};
		case 2: {_launcherSide = independent;};
		case 3: {_launcherSide = civilian;};
		default {_launcherSide = east;};
	};
};

// Store context for the Fired EH
_launcherVehicle setVariable ["OKS_ScudIntercept_targetPos", _targetPositionATL, true];
// Task should be visible to all players
_launcherVehicle setVariable ["OKS_ScudIntercept_taskOwners", true, true];

// Task meta differs for SCUD vs Cruise Missile
private _launcherVehicleType = typeOf _launcherVehicle;
private _kind = "Missile";
if (_launcherVehicleType in ["rhs_9k79", "rhs_9k79_K", "rhs_9k79_B"]) then { _kind = "SCUD"; };
if (_launcherVehicleType isEqualTo "B_Ship_MRLS_01_F") then { _kind = "Cruise Missile"; };
_launcherVehicle setVariable ["OKS_ScudIntercept_kind", _kind, true];
private _taskTitle = format ["Intercept %1", _kind];
private _taskDesc = format ["Intercept the incoming %1 before it impacts.", _kind];
_launcherVehicle setVariable ["OKS_ScudIntercept_taskMeta", [_taskTitle, _taskDesc], true];
_launcherVehicle setVariable ["OKS_ScudIntercept_doTask", _createTask, true];

if (_dbg) then {
	[format ["TaskMeta set | kind=%1 title=%2 createTask=%3", _kind, _taskTitle, _createTask]] call _fnc_dbg;
};

// Create/refresh a lockable target object at the target position.
// Some vertical-launch systems will go straight up unless an actual target object is designated.
private _oldTargetObject = _launcherVehicle getVariable ["OKS_ScudIntercept_targetObj", objNull];
if (!isNull _oldTargetObject) then { deleteVehicle _oldTargetObject; };

// Use CBA invisible target vehicles as remote targets for sensor-based targeting.
// Important: many AI/sensor weapons won't engage friendly targets, so the target must be ENEMY to the launcher side.
private _fnc_pickEnemySide = {
	params ["_launcherSide"]; 
	private _candidates = [west, east, independent] select { _x != _launcherSide };
	if (_candidates isEqualTo []) exitWith {east};
	private _best = _candidates select 0;
	private _bestScore = _launcherSide getFriend _best;
	{
		private _s = _launcherSide getFriend _x;
		if (_s < _bestScore) then {
			_bestScore = _s;
			_best = _x;
		};
	} forEach _candidates;
	_best
};

private _targetSide = [_launcherSide] call _fnc_pickEnemySide;

if (_dbg) then {
	private _fw = _launcherSide getFriend west;
	private _fe = _launcherSide getFriend east;
	private _fi = _launcherSide getFriend independent;
	[format ["Target side pick | launcherSide=%1 friends(w/e/i)=%2/%3/%4 -> targetSide=%5", _launcherSide, _fw, _fe, _fi, _targetSide]] call _fnc_dbg;
};

private _fnc_targetClassForSide = {
	params ["_side"]; 
	private _pfx = "CBA" + "_";
	switch (_side) do {
		case west: {_pfx + "B_InvisibleTargetVehicle"};
		case east: {_pfx + "O_InvisibleTargetVehicle"};
		case independent: {_pfx + "I_InvisibleTargetVehicle"};
		default {_pfx + "O_InvisibleTargetVehicle"};
	};
};

private _targetVehicleClassname = [_targetSide] call _fnc_targetClassForSide;
if (!isClass (configFile >> "CfgVehicles" >> _targetVehicleClassname)) exitWith {
	if (_dbg) then { [format ["ERROR: Missing %1 (CBA invisible targets required)", _targetVehicleClassname]] call _fnc_dbg; };
	false
};

private _targetObject = createVehicle [_targetVehicleClassname, _targetPositionATL, [], 0, "NONE"];
_targetObject setPosATL _targetPositionATL;
_targetObject allowDamage false;

if (_dbg) then {
	[format ["Target created | class=%1 obj=%2 side=%3", _targetVehicleClassname, _targetObject, _targetSide]] call _fnc_dbg;
};

_launcherVehicle setVariable ["OKS_ScudIntercept_targetObj", _targetObject, true];

// Default allowed weapon hints per platform (best-effort)
if (_allowedWeaponClassnames isEqualTo []) then {
	switch (true) do {
		case (_launcherVehicleType in ["rhs_9k79", "rhs_9k79_K", "rhs_9k79_B"]): { _allowedWeaponClassnames = ["RHS_9M79_1Launcher"]; };
		case (_launcherVehicleType isEqualTo "B_Ship_MRLS_01_F"): { _allowedWeaponClassnames = ["weapon_VLS_01"]; };
		default { _allowedWeaponClassnames = []; };
	};
};

// Make sure our Fired EH exists
[_launcherVehicle, _allowedWeaponClassnames] call OKS_fnc_ScudIntercept_RegisterLauncher;

// Choose weapon BEFORE any wait/prep (RHS launch logic expects a live gunner early)
if (_weaponClassnameToFire isEqualTo "") then {
	private _weaponCandidates = _allowedWeaponClassnames;
	if (_weaponCandidates isEqualTo []) then { _weaponCandidates = weapons _launcherVehicle; };
	_weaponClassnameToFire = _weaponCandidates param [0, ""]; 
};

// Create/seat ONE dumb gunner BEFORE any sleep.
_launcherVehicle enableSimulationGlobal true;
_launcherVehicle lock 0;

// Clean out any wrong-side crew first.
{ if (side _x != _launcherSide) then { deleteVehicle _x; }; } forEach (crew _launcherVehicle);

if (isNull (gunner _launcherVehicle)) then {
	private _launcherGunnerGroup = createGroup [_launcherSide, true];
	private _launcherGunnerUnitClass = switch (_launcherSide) do {
		case west: {"B_Soldier_F"};
		case east: {"O_Soldier_F"};
		case independent: {"I_Soldier_F"};
		case civilian: {"C_man_1"};
		default {"B_Soldier_F"};
	};
	private _launcherGunnerUnit = _launcherGunnerGroup createUnit [_launcherGunnerUnitClass, getPosATL _launcherVehicle, [], 0, "NONE"];
	_launcherGunnerUnit allowFleeing 0;
	_launcherGunnerUnit setBehaviour "CARELESS";
	_launcherGunnerUnit setCombatMode "BLUE";
	_launcherGunnerUnit disableAI "ALL";
	_launcherGunnerUnit assignAsGunner _launcherVehicle;
	_launcherGunnerUnit moveInGunner _launcherVehicle;
};

// Lock it (keep players out; keep AI seated)
_launcherVehicle lock 2;

if (_dbg) then {
	[format ["Crew | weapon=%1 driver=%2 gunner=%3", _weaponClassnameToFire, driver _launcherVehicle, gunner _launcherVehicle]] call _fnc_dbg;
};

// RHS: start preparation immediately, then wait _prepTime before launch.
private _rhsPrepared = false;
if (_launcherVehicleType in ["rhs_9k79", "rhs_9k79_K", "rhs_9k79_B"]) then {
	if (!isNil "RHS_fnc_ss21_AI_prepare") then {
		[_launcherVehicle, 1] call RHS_fnc_ss21_AI_prepare;
		_rhsPrepared = true;
		if (_dbg) then { ["RHS Prepare Begun"] call _fnc_dbg; };
	};
};

// Let it "take its time"
if (_preparationTimeSeconds > 0) then {
	sleep _preparationTimeSeconds;
};

private _fnc_fireWeaponAtPos = {
	params ["_launcherVehicle", "_weaponClassname", "_weaponTurretPath", "_targetPositionATL", "_targetObject", "_launcherSide"]; 
	if (isNull _launcherVehicle || {_weaponClassname isEqualTo ""} || {_targetPositionATL isEqualTo []}) exitWith {false};

	if (_dbg) then {
		[format ["FireAtPos | veh=%1 weapon=%2 turret=%3 targetObj=%4 side=%5", _launcherVehicle, _weaponClassname, _weaponTurretPath, _targetObject, _launcherSide]] call _fnc_dbg;
	};

	// Ensure the weapon exists on that turret (best-effort)
	private _weps = _launcherVehicle weaponsTurret _weaponTurretPath;
	if ((_weps find _weaponClassname) < 0) then {
		_launcherVehicle addWeaponTurret [_weaponClassname, _weaponTurretPath];
	};

	// Select weapon on turret
	_launcherVehicle selectWeaponTurret [_weaponClassname, _weaponTurretPath];

	// Some launcher weapons are configured as artillery; try the artillery API first (coordinate targeting)
	private _shooter = objNull;
	if (_weaponTurretPath isEqualTo [-1]) then {
		_shooter = driver _launcherVehicle;
	} else {
		_shooter = _launcherVehicle turretUnit _weaponTurretPath;
	};
	if (!isNull _shooter) then {
		private _mag = _launcherVehicle currentMagazineTurret _weaponTurretPath;
		if (_mag isEqualTo "") then {
			_mag = (_launcherVehicle magazinesTurret _weaponTurretPath) param [0, ""];
		};
		if (_mag != "") then {
			_shooter doArtilleryFire [_targetPositionATL, _mag, 1];
		};
	};

	private _tgt = _targetObject;
	if (isNull _tgt) exitWith {false};

	// VLS-style: make the target a confirmed sensor target for the firing side (best-effort)
	if (!isNil "_launcherSide") then {
		_launcherSide reportRemoteTarget [_tgt, 5000];
		_tgt confirmSensorTarget [_launcherSide, true];
		if (_dbg) then {
			[format ["SensorTarget confirmed | launcherSide=%1 target=%2", _launcherSide, _tgt]] call _fnc_dbg;
		};
	};

	// Try vehicle-level fire next
	_launcherVehicle fireAtTarget [_tgt, _weaponClassname];
	if (_dbg) then {
		[format ["fireAtTarget issued | veh=%1 target=%2 weapon=%3", _launcherVehicle, _tgt, _weaponClassname]] call _fnc_dbg;
	};

	// Also try AI doFire (some platforms need a turret unit)
	if (!isNull _shooter) then {
		_shooter reveal [_tgt, 4];
		_shooter doTarget _tgt;
		_shooter doFire _tgt;
		_shooter fireAtTarget [_tgt, _weaponClassname];
	};
	true
};

private _fnc_waitForFiredEh = {
	params ["_launcherVehicle", "_sinceStamp", ["_timeoutSeconds", 5, [0]]];
	private _deadline = diag_tickTime + _timeoutSeconds;
	waitUntil {
		sleep 0.1;
		(diag_tickTime > _deadline) || { (_launcherVehicle getVariable ["OKS_ScudIntercept_lastFiredStamp", -1]) > _sinceStamp }
	};
	(_launcherVehicle getVariable ["OKS_ScudIntercept_lastFiredStamp", -1]) > _sinceStamp
};

// Known turret fallback hints (some launchers report turret [0] in Fired EH)
if (_weaponTurretPath isEqualTo [-1]) then {
	switch (_launcherVehicleType) do {
		case "rhs_9k79": { _weaponTurretPath = [0]; };
		case "rhs_9k79_K": { _weaponTurretPath = [0]; };
		case "rhs_9k79_B": { _weaponTurretPath = [0]; };
		case "B_Ship_MRLS_01_F": { _weaponTurretPath = [0]; };
		default {};
	};
};

// If the caller specified an explicit weapon to fire, make sure the Fired EH only triggers for that.
if (_allowedWeaponClassnames isEqualTo [] && {_weaponClassnameToFire != ""}) then {
	_allowedWeaponClassnames = [_weaponClassnameToFire];
};



// Known launch flows (best-effort)
switch (true) do {
	// RHS SS-21 (9K79)
	case (_launcherVehicleType in ["rhs_9k79", "rhs_9k79_K", "rhs_9k79_B"]): {
		private _since = diag_tickTime;
		private _postPreparationDelaySeconds = 5;
		if (_rhsPrepared) then { sleep _postPreparationDelaySeconds; };
		if (_dbg) then { [format ["RHS launch | prepared=%1 prepDelay=%2", _rhsPrepared, _postPreparationDelaySeconds]] call _fnc_dbg; };
		if (isNil "RHS_fnc_ss21_AI_launch") exitWith {false};
		[_launcherVehicle, _targetPositionATL] call RHS_fnc_ss21_AI_launch;
		if (_dbg) then {
			private _ok = [_launcherVehicle, _since, 6] call _fnc_waitForFiredEh;
			[format ["Launch -> FiredEH observed=%1 lastWeapon=%2 lastProj=%3", _ok, _launcherVehicle getVariable ["OKS_ScudIntercept_lastFiredWeapon", ""], _launcherVehicle getVariable ["OKS_ScudIntercept_lastFiredProjectile", objNull]]] call _fnc_dbg;
		};
		true
	};

	// Vanilla ship MRLS
	case (_launcherVehicleType isEqualTo "B_Ship_MRLS_01_F"): {
		if (_weaponClassnameToFire isEqualTo "") exitWith {false};
		private _since = diag_tickTime;
		[_launcherVehicle, _weaponClassnameToFire, _weaponTurretPath, _targetPositionATL, _targetObject, _launcherSide] call _fnc_fireWeaponAtPos;
		if (_dbg) then {
			private _ok = [_launcherVehicle, _since, 5] call _fnc_waitForFiredEh;
			[format ["Launch -> FiredEH observed=%1 lastWeapon=%2 lastProj=%3", _ok, _launcherVehicle getVariable ["OKS_ScudIntercept_lastFiredWeapon", ""], _launcherVehicle getVariable ["OKS_ScudIntercept_lastFiredProjectile", objNull]]] call _fnc_dbg;
		};
		true
	};

	// Generic fallback
	default {
		if (_weaponClassnameToFire isEqualTo "") exitWith {false};
		private _since = diag_tickTime;
		[_launcherVehicle, _weaponClassnameToFire, _weaponTurretPath, _targetPositionATL, _targetObject, _launcherSide] call _fnc_fireWeaponAtPos;
		if (_dbg) then {
			private _ok = [_launcherVehicle, _since, 5] call _fnc_waitForFiredEh;
			[format ["Launch -> FiredEH observed=%1 lastWeapon=%2 lastProj=%3", _ok, _launcherVehicle getVariable ["OKS_ScudIntercept_lastFiredWeapon", ""], _launcherVehicle getVariable ["OKS_ScudIntercept_lastFiredProjectile", objNull]]] call _fnc_dbg;
		};
		true
	};
};
