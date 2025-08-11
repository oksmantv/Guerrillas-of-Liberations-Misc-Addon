
params ["_target","_missile"];

private _Debug = missionNamespace getVariable ["GOL_MissileWarning_Debug", false];
private _ticks = 50; // change gradually over 50 frames (~0.5-1sec)

if (_Debug) then {
	"[MISSILEWARNING] Waiting for Smoke or Missile destruction.." call OKS_fnc_LogDebug;
};	

waitUntil { sleep 0.1; _target getVariable ["GOL_FiredSmoke", false] || !alive _missile };
if(!alive _missile) exitWith {
	if (_Debug) then {
		"[MISSILEWARNING] Missile Deflect: Missile already destroyed" call OKS_fnc_LogDebug;
	};
};

if(_Debug) then {
	"[MISSILEWARNING] Missile Deflect" call OKS_fnc_LogDebug;
};

for "_i" from 0 to _ticks do {
	if (!alive _missile) exitWith {};

	private _currentVel = velocity _missile;          // [vx, vy, vz]
	private _downVel    = [0, 0, -50];                // Downward force
	private _newVel     = [
		(_currentVel select 0) * (1 - _i/_ticks) + (_downVel select 0) * (_i/_ticks),
		(_currentVel select 1) * (1 - _i/_ticks) + (_downVel select 1) * (_i/_ticks),
		(_currentVel select 2) * (1 - _i/_ticks) + (_downVel select 2) * (_i/_ticks)
	];
	_missile setVelocity _newVel;

	sleep 0.15; // update every 20ms for smoothness
};

waitUntil {sleep 0.1; !Alive _missile};

if(_Debug) then {
	"[MISSILEWARNING] Missile Destroyed" call OKS_fnc_LogDebug;
};
