
params ["_target","_missile","_instigator"];

private _debug = missionNamespace getVariable ["GOL_MissileDeflect_Debug", false];
private _ticks = 40; // active steering for ~3 s (40 × 0.075 s); converges well before impact
private _angleMax = 60; // max angle to deflect missile
private _inDeadlyRange = false;
if (_debug) then {
	"[MISSILEDEFLECT] Waiting for Smoke or Missile destruction.." call OKS_fnc_LogDebug;
	format ["[MISSILEDEFLECT] INIT | Target: %1 | MissileType: %2 | Instigator: %3 | MissileLocal: %4 | MissileOwner: %5",
		_target, typeOf _missile, _instigator, local _missile, owner _missile
	] call OKS_fnc_LogDebug;
};
private _waitTick = 0;

_GetDirectionAndAngle = {
	params ["_target","_missile"];
	private _angleMax = 60; // max angle to deflect missile
	private _direction = getDir _target;
    private _dirToMissile = _target getDir _missile;
	private _vehicleClass = typeOf _target;
	if (_vehicleClass find "RHS_M2A" != -1 || _vehicleClass find "APC_tracked_03_cannon_F" != -1 || _vehicleClass find "B_MBT_01" != -1) then {
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

		if (_debug) then {
			"[MISSILEDEFLECT] Turret based Direction selected" call OKS_fnc_LogDebug;
		};			
	};
	if (_vehicleClass find "I_APC_Wheeled_03_cannon_F" != -1) then {
		_angleMax = 90;
	};
	if (_vehicleClass find "I_MBT_03_cannon_F" != -1) then {
		_angleMax = 180;
	};

	[_direction, _angleMax, _dirToMissile]
};

waitUntil {
    _waitTick = _waitTick + 1;
    sleep 0.1;

	private _returnArray = [_target, _missile] call _GetDirectionAndAngle;
	_returnArray params ["_vehicleDir", "_angleMax", "_dirToMissile"];
	private _firedSmoke = _target getVariable ["GOL_FiredSmoke", false];

    // Calculate angular difference (-180 to +180)
    private _angleDiff = ((_dirToMissile - _vehicleDir + 540) % 360) - 180;

    // Missile is within ±angleMax° of the vehicle's facing
    private _missileInFront = (abs _angleDiff) <= _angleMax;

	private _dist2DTarget     = _missile distance2D _target;
	private _dist2DInstigator = _missile distance2D _instigator;

    if (_debug) then {
        format [
            "[MISSILEDEFLECT][T%1] Smoke:%2 | InFront:%3 | AngleDiff:%4 | VehicleDir:%5 | Dist2DTarget:%6 | Dist2DInstigator:%7 | DeadlyRange:%8 | MissileAlive:%9",
			_waitTick, _firedSmoke, _missileInFront, _angleDiff, _vehicleDir,
			_dist2DTarget, _dist2DInstigator, _inDeadlyRange, alive _missile
        ] call OKS_fnc_LogDebug;
    };

	if (_dist2DTarget < 100) then {
		_inDeadlyRange = true;
	};

    // Break if: smoke active + missile in arc + past shooter | OR missile gone/passed
    (_firedSmoke && _missileInFront && _dist2DInstigator > 100) || (!alive _missile || (_inDeadlyRange && _dist2DTarget > 100))
};
private _exitByFail = !alive _missile || (_inDeadlyRange && _missile distance2D _target > 100);
if (_debug) then {
	format [
		"[MISSILEDEFLECT] EXIT after %1 ticks | DeflectTriggered:%2 | MissileAlive:%3 | InDeadlyRange:%4 | GOL_FiredSmoke:%5 | Dist2DTarget:%6",
		_waitTick, !_exitByFail, alive _missile, _inDeadlyRange,
		_target getVariable ["GOL_FiredSmoke", false],
		_missile distance2D _target
	] call OKS_fnc_LogDebug;
};
if (_exitByFail) exitWith {
	if (_debug) then {
		"[MISSILEDEFLECT] Missile passed or destroyed — no deflect applied" call OKS_fnc_LogDebug;
	};
};

if (_debug) then {
	"[MISSILEDEFLECT] Missile Deflected" call OKS_fnc_LogDebug;
};

// --- Compute miss point: above and to one shoulder of the vehicle ---
// The target point is offset perpendicular to the missile's approach direction
// (horizontal) and above the vehicle, so the missile arcs over the shoulder.
private _initVel = velocity _missile;
private _initSpeed = sqrt (
	(_initVel select 0)^2 + (_initVel select 1)^2 + (_initVel select 2)^2
) max 1;

// Horizontal perpendicular to approach: cross(vel_norm, world_up) = [vy, -vx, 0]
private _nVx = (_initVel select 0) / _initSpeed;
private _nVy = (_initVel select 1) / _initSpeed;
private _sideLen = sqrt (_nVy^2 + _nVx^2) max 0.001;
private _sideX = _nVy / _sideLen;
private _sideY = (-_nVx) / _sideLen;

private _sideDir = if (random 1 > 0.5) then {1} else {-1};
private _heightOffset  = 5 + random 5;  // 5-10 m above vehicle
private _lateralOffset = 3 + random 4;  // 3-7 m to the side

private _missOffset = [
	_sideX * _lateralOffset * _sideDir,
	_sideY * _lateralOffset * _sideDir,
	_heightOffset
];

if (_debug) then {
	format ["[MISSILEDEFLECT] Miss offset: lateral %1 m, height %2 m", _lateralOffset * _sideDir, _heightOffset] call OKS_fnc_LogDebug;
};

// setVelocity only has effect on the machine where the missile is local.
// SetupMissileWarning already remoteExec'd this function to owner _missile,
// but guard here as a safety net in case locality transferred mid-flight.
if (local _missile) then {
	// Disable SACLOS guidance: clear the operator's target so the engine stops
	// applying corrective forces that would fight our velocity steering.
	if (local _instigator) then {
		private _gunner = gunner _instigator;
		if (!isNull _gunner) then {
			_gunner doTarget objNull;
			_gunner commandTarget objNull;
		};
		_instigator doTarget objNull;
	};
	if (_debug) then { "[MISSILEDEFLECT] Guidance cleared - beginning steering loop" call OKS_fnc_LogDebug; };

	// Each tick: steer velocity toward the miss point using lerp.
	// lerpT = 0.3 with 0.025 s sleep → fast enough to overcome residual guidance,
	// slow enough to produce a smooth arc rather than a snap.
	private _lerpT = 0.3;
	for "_i" from 0 to _ticks do {
		if (!alive _missile) exitWith {};
		private _curVel = velocity _missile;
		private _curSpeed = sqrt (
			(_curVel select 0)^2 + (_curVel select 1)^2 + (_curVel select 2)^2
		) max 1;

		// Miss point tracks vehicle position in case it moves.
		// Scale the offset by current distance so the angular deflection stays constant
		// throughout the approach: atan(offset * scale / dist) = atan(offset / 50) = ~6°.
		// Without scaling, offset is tiny vs range and the arc only appears in the last ~50 m.
		private _vehiclePos = getPosWorld _target;
		private _missilePos = getPosWorld _missile;
		private _distToVehicle = (_missilePos distance _vehiclePos) max 1;
		private _scale = (_distToVehicle / 50) min 8;  // cap at 8× for very long shots
		private _missPoint = [
			(_vehiclePos select 0) + (_missOffset select 0) * _scale,
			(_vehiclePos select 1) + (_missOffset select 1) * _scale,
			(_vehiclePos select 2) + (_missOffset select 2) * _scale
		];

		// Direction from missile to miss point
		private _dx = (_missPoint select 0) - (_missilePos select 0);
		private _dy = (_missPoint select 1) - (_missilePos select 1);
		private _dz = (_missPoint select 2) - (_missilePos select 2);
		private _d = sqrt (_dx^2 + _dy^2 + _dz^2) max 0.001;

		// Desired velocity: same speed as now, aimed at miss point
		private _desiredVel = [
			(_dx / _d) * _curSpeed,
			(_dy / _d) * _curSpeed,
			(_dz / _d) * _curSpeed
		];

		// Lerp current velocity toward desired — smooth arc, not an instant heading snap
		_missile setVelocity [
			(_curVel select 0) * (1 - _lerpT) + (_desiredVel select 0) * _lerpT,
			(_curVel select 1) * (1 - _lerpT) + (_desiredVel select 1) * _lerpT,
			(_curVel select 2) * (1 - _lerpT) + (_desiredVel select 2) * _lerpT
		];

		// Exit once the missile is flying away from the vehicle horizontally — it has
		// already passed the target zone, further steering would only chase it backwards.
		private _toVehicleX = (_vehiclePos select 0) - (_missilePos select 0);
		private _toVehicleY = (_vehiclePos select 1) - (_missilePos select 1);
		private _toVehicleLen = sqrt (_toVehicleX^2 + _toVehicleY^2) max 0.001;
		private _velDotVehicle = ((_curVel select 0) * (_toVehicleX / _toVehicleLen))
		                       + ((_curVel select 1) * (_toVehicleY / _toVehicleLen));

		if (_debug) then {
			format ["[MISSILEDEFLECT] Tick %1 | Speed: %2 | MissDir: [%3,%4,%5] | VehicleDot: %6",
				_i, _curSpeed, (_dx/_d), (_dy/_d), (_dz/_d), _velDotVehicle] call OKS_fnc_LogDebug;
		};

		if (_velDotVehicle < 0) exitWith {
			if (_debug) then { "[MISSILEDEFLECT] Missile past target — coasting" call OKS_fnc_LogDebug; };
		};

		sleep 0.025;
	};
} else {
	if (_debug) then {
		"[MISSILEDEFLECT] Missile not local on this machine - deflect skipped" call OKS_fnc_LogDebug;
	};
};

waitUntil {sleep 0.1; !alive _missile};

if (_debug) then {
	"[MISSILEDEFLECT] Missile Destroyed" call OKS_fnc_LogDebug;
};
