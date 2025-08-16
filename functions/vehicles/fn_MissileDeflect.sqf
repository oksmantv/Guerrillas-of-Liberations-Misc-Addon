
params ["_target","_missile","_instigator"];

private _Debug = missionNamespace getVariable ["GOL_MissileDeflect_Debug", false];
private _ticks = 100; // change gradually over 50 frames (~0.5-1sec)
private _angleMax = 60; // max angle to deflect missile
private _inDeadlyRange = false;
if (_Debug) then {
	"[MISSILEDEFLECT] Waiting for Smoke or Missile destruction.." call OKS_fnc_LogDebug;
};	

_GetDirectionAndAngle = {
	params ["_target","_missile"];
	private ["_direction","_angleMax"];
	private _angleMax = 60; // max angle to deflect missile
	private _direction = getDir _target;
    private _dirToMissile = _target getDir _missile;
	_vehicleClass = typeOf _target;
	if(_vehicleClass find "RHS_M2A" != -1 || _vehicleClass find "APC_tracked_03_cannon_F" != -1 || _vehicleClass find "B_MBT_01" != -1) then {
		// M2 Bradley or Warrior or Merkava
		_angleMax = 60;
		private _output = [_target, [0]] call ace_common_fnc_getTurretDirection;
		private _dirVector = _output select 1;

		private _dx = _dirVector select 0;
		private _dy = _dirVector select 1;
		_direction = (_dx atan2 _dy + 360) % 360;

		// Get turret position in world space
		private _turretPos = _target selectionPosition "otocVez";
		private _turretWorldPos = _target modelToWorld _turretPos;
		_dirToMissile = _turretWorldPos getDir (getPosWorld _missile);

		if (_Debug) then {
			"[MISSILEDEFLECT] Turret based Direction selected" call OKS_fnc_LogDebug;
		};			
	};
	if(_vehicleClass find "I_APC_Wheeled_03_cannon_F" != -1) then {
		_angleMax = 90;
	};
	if(_vehicleClass find "I_MBT_03_cannon_F" != -1) then {
		_angleMax = 180;
	};

	_return = [_direction, _angleMax,_dirToMissile];
	_return;
};

waitUntil {
    sleep 0.1;

	_returnArray = [_target, _missile] call _GetDirectionAndAngle;
	_returnArray params ["_vehicleDir", "_angleMax", "_dirToMissile"];
	private _firedSmoke = _target getVariable ["GOL_FiredSmoke", false];

    // Calculate angular difference (-180 to +180)
    private _angleDiff = ((_dirToMissile - _vehicleDir + 540) % 360) - 180;

    // Missile is within ±60° of the vehicle's facing
    private _missileInFront = (abs _angleDiff) <= _angleMax;

    if (_Debug) then {
        _DebugMessage = format [
            "[MISSILEDEFLECT] Smoke: %1 | Frontal Arc: %2 | Dir To Missile: %3 | AngleDiff: %4 | VehicleDir: %5",
			_firedSmoke,
            _missileInFront,
            _dirToMissile,
            _angleDiff,
            _vehicleDir
        ];
		_DebugMessage call OKS_fnc_LogDebug;
    };

	if(_missile distance2d _target < 100) then {
		_inDeadlyRange = true;
	};

    // Condition to break waitUntil
    (_firedSmoke && _missileInFront && _missile distance2d _instigator > 100) || (!alive _missile || (_inDeadlyRange && _missile distance2d _target > 100))
};
if(!alive _missile || (_inDeadlyRange && _missile distance2d _target > 100)) exitWith {
	if (_Debug) then {
		"[MISSILEDEFLECT] Missile passed or destroyed" call OKS_fnc_LogDebug;
	};
	_target setVariable ["GOL_MissileWarning", false, true];
};

if(_Debug) then {
	"[MISSILEDEFLECT] Missile Deflected" call OKS_fnc_LogDebug;
};

for "_i" from 0 to _ticks do {
    if (!alive _missile) exitWith {};
	private _currentVel = velocity _missile; // [vx, vy, vz]

	// Add random horizontal and vertical deviation
	private _deviation = [
		(random 2 - 1) * 1.5, // X axis: left/right
		(random 2 - 1) * 1.5, // Y axis: forward/back
		(random 2 - 1) * 2.5    // Z axis: up/down (stronger effect)
	];
	private _newVel = [
		(_currentVel select 0) + (_deviation select 0),
		(_currentVel select 1) + (_deviation select 1),
		(_currentVel select 2) + (_deviation select 2)
	];
	_missile setVelocity _newVel;

	if(_Debug) then {
		format ["[MISSILEDEFLECT] Missile Adjusted | Current Vel: %1 | New Vel: %2",_currentVel,_newVel] call OKS_fnc_LogDebug;
	};

    sleep 0.075;
};

waitUntil {sleep 0.1; !Alive _missile};

if(_Debug) then {
	"[MISSILEDEFLECT] Missile Destroyed" call OKS_fnc_LogDebug;
};
