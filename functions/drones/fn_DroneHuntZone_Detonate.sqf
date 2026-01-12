/*
	OKS_fnc_DroneHuntZone_Detonate
	
	Triggers FPV drone detonation using either FPV_UA default or custom ammo.
	Handles missile spawning, momentum transfer, and shot parent attribution.
	
	Parameters:
	0: OBJECT - Drone vehicle
	1: OBJECT - Drone controller unit (for kill attribution)
	2: STRING - Explosion classname ("AUTO" for FPV_UA default, or custom CfgAmmo class)
	3: CODE - (Optional) log debug function reference
	
	Returns:
	BOOL - true if detonation was triggered, false if failed
	
	Example:
	[_drone, _controller, "AUTO"] call OKS_fnc_DroneHuntZone_Detonate;
	[_drone, _controller, "OKS_Drone_Warhead_Large"] call OKS_fnc_DroneHuntZone_Detonate;
*/

params [
	["_droneVehicle", objNull, [objNull]],
	["_droneControllerUnit", objNull, [objNull]],
	["_explosionClassName", "AUTO", [""]],
	["_logDebug", {}, [{}]]
];

if (isNull _droneVehicle) exitWith {
	false
};

private _explosionClassNameLower = toLower _explosionClassName;
private _useAutomaticDetonation = (_explosionClassName == "") || {
	_explosionClassNameLower == "auto"
};

// FPV_UA default detonation
if (_useAutomaticDetonation) exitWith {
	if (!isNil "UA_fnc_fpv_onDestroy") then {
		[_droneVehicle] call UA_fnc_fpv_onDestroy;
		true
	} else {
		_droneVehicle setDamage 1;
		true
	}
};

// Verify custom ammo class exists
private _detonationAmmoClassName = _explosionClassName;
if (!isClass (configFile >> "CfgAmmo" >> _detonationAmmoClassName)) exitWith {
	// Fallback to FPV_UA default
	if (!isNil "UA_fnc_fpv_onDestroy") then {
		[_droneVehicle] call UA_fnc_fpv_onDestroy;
	} else {
		_droneVehicle setDamage 1;
	};
	true
};

// Custom ammo detonation (FPV_UA-compatible pattern)
private _killer = if (!isNull _droneControllerUnit) then {
	_droneControllerUnit
} else {
	driver _droneVehicle
};
private _instigator = (UAVControl _droneVehicle) param [0, objNull];

// Capture drone state before deletion
private _dronePositionASL = getPosASL _droneVehicle;
private _droneVelocity = velocity _droneVehicle;
private _droneDir = vectorDir _droneVehicle;
private _droneUp = vectorUp _droneVehicle;

// Delete drone to prevent physics conflicts
deleteVehicle _droneVehicle;

// spawn missile at captured position with momentum
private _missile = createVehicle [_detonationAmmoClassName, ASLToATL _dronePositionASL, [], 0, "CAN_COLLIDE"];
_missile setPosASL _dronePositionASL;
_missile setVectorDirAndUp [_droneDir, _droneUp];
_missile setVelocity _droneVelocity;
_missile setMissileTarget objNull;
_missile setMissileTargetPos [0, 0, 0];

// set shot parents for kill attribution
[_missile, [_killer, _instigator]] remoteExec ["setShotParents", 2];

// Wait for shot parents to sync, then trigger
if (!isNil "CBA_fnc_waitUntilAndExecute") then {
	[
		{
			params ["_missile", "_shotParents"];
			(getShotParents _missile) isEqualTo _shotParents
		},
		{
			params ["_missile"];
			if (!isNull _missile) then {
				triggerAmmo _missile;
			};
		},
		[_missile, [_killer, _instigator]]
	] call CBA_fnc_waitUntilAndExecute;
} else {
	// Fallback without CBA
	[{
		params ["_missile"];
		if (!isNull _missile) then {
			triggerAmmo _missile;
		};
	}, [_missile], 0.05] call CBA_fnc_waitAndExecute;
};

true