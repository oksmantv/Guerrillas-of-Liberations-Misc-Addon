
params ["_target","_missile","_instigator"];

private _Debug = missionNamespace getVariable ["GOL_MissileWarning_Debug", false];
private _ticks = 100; // change gradually over 50 frames (~0.5-1sec)

if (_Debug) then {
	"[MISSILEDEFLECT] Waiting for Smoke or Missile destruction.." call OKS_fnc_LogDebug;
};	

waitUntil {
    sleep 0.1;

    private _vehicleDir = getDir _target;
    private _dirToMissile = _target getDir _missile;
	private _firedSmoke = _target getVariable ["GOL_FiredSmoke", false];

    // Calculate angular difference (-180 to +180)
    private _angleDiff = ((_dirToMissile - _vehicleDir + 540) % 360) - 180;

    // Missile is within ±70° of the vehicle's facing
    private _missileInFront = (abs _angleDiff) <= 70;

    if (_Debug) then {
        format [
            "[MISSILEDEFLECT] Smoke: %1 | Frontal Arc: %2 | Dir To Missile: %3 | AngleDiff: %4 | VehicleDir: %5",
			_firedSmoke,
            _missileInFront,
            _dirToMissile,
            _angleDiff,
            _vehicleDir
        ] call OKS_fnc_LogDebug;
    };

    // Condition to break waitUntil
    (_firedSmoke && _missileInFront) || {!alive _missile}
};
if(!alive _missile) exitWith {
	if (_Debug) then {
		"[MISSILEDEFLECT] Missile already destroyed" call OKS_fnc_LogDebug;
	};
};

if(_Debug) then {
	"[MISSILEDEFLECT] Missile Deflected" call OKS_fnc_LogDebug;
};

for "_i" from 0 to _ticks do {
    if (!alive _missile) exitWith {};

	private _currentVel = velocity _missile; // [vx, vy, vz]
	// Add random horizontal and vertical deviation
	private _deviation = [
		(_random - 5) * 3, // X axis: left/right
		(random 2 - 1) * 3, // Y axis: forward/back
		(random 2 - 1) * 4    // Z axis: up/down (stronger effect)
	];
	private _newVel = [
		(_currentVel select 0) + (_deviation select 0),
		(_currentVel select 1) + (_deviation select 1),
		(_currentVel select 2) + (_deviation select 2)
	];
	_missile setVelocity _newVel;

	if(_Debug) then {
		format ["[MISSILEDEFLECT] Missile Adjusted - %1 | Vel: %2",_random,_newVel] call OKS_fnc_LogDebug;
	};

    sleep 0.05;
};

waitUntil {sleep 0.1; !Alive _missile};

if(_Debug) then {
	"[MISSILEDEFLECT] Missile Destroyed" call OKS_fnc_LogDebug;
};
