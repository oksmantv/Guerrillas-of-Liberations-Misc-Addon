/*
	OKS_fnc_DroneDisruptor_Fired
	
	Handles firing of drone disruptor pistol.
	Performs cone-based detection, kills drone crew, creates electrical effects.
	
	Parameters (from fired EH):
	0: OBJECT - Unit who fired
	1: STRING - Weapon fired
	2: STRING - Muzzle fired
	3: STRING - Fire mode
	4: STRING - Ammo type
	5: STRING - Magazine type
	6: OBJECT - Projectile
	
	Returns:
	Nothing
	
	Example:
	[player, "OKS_DroneDisruptor_Pistol", "this", "Single", "OKS_Ammo_DisruptorPulse", "OKS_Mag_DroneDisruptor", objNull] call OKS_fnc_DroneDisruptor_Fired;
*/

params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

// TEST: Always log to confirm event handler is working
systemChat "DISRUPTOR FIRED EVENT TRIGGERED!";
diag_log "===== DISRUPTOR FIRED EVENT TRIGGERED =====";

// Only process disruptor weapon
if (_weapon != "OKS_DroneDisruptor_Pistol") exitWith {
	systemChat format ["Wrong weapon: %1", _weapon];
};

// Master debug check
private _masterDebug = missionNamespace getVariable ["GOL_Drones_MasterDebug", false];
private _disruptorDebug = missionNamespace getVariable ["GOL_Disruptor_Debug", false];

if (_masterDebug && _disruptorDebug) then {
	systemChat format ["[DISRUPTOR] Fired by %1", name _unit];
	diag_log format ["[DISRUPTOR] Fired by %1 | Weapon: %2 | Ammo: %3", name _unit, _weapon, _ammo];
};

// Get firing parameters
private _shooterPos = eyePos _unit;
private _aimDir = vectorDir _unit;
private _aimPitch = (_unit weaponDirection _weapon) select 2;

// Disruptor settings - check for range-boost antenna
private _baseRange = 500; // meters base range
private _maxRange = _baseRange;

// Check if long-range antenna is attached (+250m range boost)
private _muzzleItem = primaryWeaponItems _unit select 0;
if (_weapon == handgunWeapon _unit) then {
	_muzzleItem = handgunItems _unit select 0;
};
if (_muzzleItem == "OKS_Disruptor_Antenna") then {
	_maxRange = _baseRange + 250; // 750m total with antenna
	if (_masterDebug && _disruptorDebug) then {
		systemChat "[DISRUPTOR] Long-range antenna detected: +250m range boost";
	};
};

private _coneAngle = 10; // degrees (both horizontal and vertical)

if (_masterDebug && _disruptorDebug) then {
	systemChat format ["[DISRUPTOR] Aim direction: %1 | Pitch: %2", _aimDir, _aimPitch];
	systemChat format ["[DISRUPTOR] Effective range: %1m | Cone: %2°", _maxRange, _coneAngle];
};

// Find all air units within range
private _nearbyDrones = _unit nearEntities [["Air"], _maxRange];

if (_masterDebug && _disruptorDebug) then {
	systemChat format ["[DISRUPTOR] Found %1 air units within range", count _nearbyDrones];
	diag_log format ["[DISRUPTOR] Nearby air units: %1", _nearbyDrones];
};

private _closestHit = objNull;
private _closestDist = 999999;
private _closestAngle = 0;
private _closestPitch = 0;

// BALANCE: Find closest valid target in cone (one shot, one kill)
{
	private _drone = _x;
	
	// CRITICAL: Only target UAVs, not manned aircraft
	if !(unitIsUAV _drone) then { continue };
	
	private _dronePos = getPosASL _drone;
	
	// Vector from shooter to drone
	private _toDrone = _dronePos vectorDiff _shooterPos;
	private _distance = vectorMagnitude _toDrone;
	
	if (_masterDebug && _disruptorDebug) then {
		private _inTerminal = _drone getVariable ["GOL_InTerminalPhase", false];
		private _isDisabled = _drone getVariable ["OKS_Drone_Disabled", false];
		diag_log format ["[DISRUPTOR] Found drone: %1 | Type: %2 | Distance: %3m | InTerminal: %4 | AlreadyDisabled: %5", 
			_drone, typeOf _drone, round _distance, _inTerminal, _isDisabled];
	};
	
	// Skip if zero distance
	if (_distance < 1) then { continue };
	
	// Normalize direction vector
	private _toDroneDir = _toDrone vectorMultiply (1 / _distance);
	
	// Calculate angle between aim direction and drone direction
	private _dotProduct = (_aimDir vectorDotProduct _toDroneDir);
	private _angleToTarget = acos (_dotProduct max -1 min 1); // Clamp to prevent NaN
	
	// Calculate vertical angle difference
	private _targetPitch = asin ((_toDroneDir select 2) max -1 min 1);
	private _pitchDiff = abs(_targetPitch - _aimPitch);
	
	// Check if drone is in terminal phase (diving attack)
	private _inTerminalPhase = _drone getVariable ["GOL_InTerminalPhase", false];
	
	// Distance-scaled cone with terminal phase bonus
	private _effectiveConeAngle = switch (true) do {
		case (_inTerminalPhase && _distance < 100): { 30 };  // Terminal + close: very large cone (diving, fast)
		case (_inTerminalPhase): { 25 };                      // Terminal + far: large cone (hard to track)
		case (_distance < 50): { 20 };                        // Close range: easy to hit
		case (_distance < 100): { 15 };                       // Medium range: moderate
		default { 10 };                                        // Far range: precision required
	};
	
	if (_masterDebug && _disruptorDebug) then {
		diag_log format ["[DISRUPTOR] Checking %1 | Distance: %2m | Angle: %3° | PitchDiff: %4° | MaxCone: %5° | Terminal: %6", 
			typeOf _drone, round _distance, round _angleToTarget, round _pitchDiff, _effectiveConeAngle, _inTerminalPhase];
	};
	
	// Check if within cone and closer than previous candidates
	if (_angleToTarget <= _effectiveConeAngle && _pitchDiff <= _effectiveConeAngle && _distance < _closestDist) then {
		_closestHit = _drone;
		_closestDist = _distance;
		_closestAngle = _angleToTarget;
		_closestPitch = _pitchDiff;
		
		if (_masterDebug && _disruptorDebug) then {
			diag_log format ["[DISRUPTOR] Valid target found | Drone: %1 | Distance: %2m | Angle: %3° | PitchDiff: %4°", 
				typeOf _drone, _distance, _angleToTarget, _pitchDiff];
		};
	} else {
		if (_masterDebug && _disruptorDebug) then {
			diag_log format ["[DISRUPTOR] MISS: %1 | Distance: %2m | Angle: %3° (max %4°) | PitchDiff: %5° (max %6°)", 
				typeOf _drone, round _distance, round _angleToTarget, _effectiveConeAngle, round _pitchDiff, _effectiveConeAngle];
		};
	};
} forEach _nearbyDrones;

// Apply effects only to the closest valid target (one shot, one kill)
if (!isNull _closestHit) then {
	if (_masterDebug && _disruptorDebug) then {
		systemChat format ["[DISRUPTOR] HIT: %1 at %2m", typeOf _closestHit, round _closestDist];
		diag_log format ["[DISRUPTOR] HIT CONFIRMED | Drone: %1 | Distance: %2m | Angle: %3° | PitchDiff: %4°", 
			typeOf _closestHit, _closestDist, _closestAngle, _closestPitch];
	};
	
	// Mark drone as disabled - terminal guidance scripts should check this
	_closestHit setVariable ["OKS_Drone_Disabled", true, true];
	
	if (_masterDebug && _disruptorDebug) then {
		systemChat format ["[DISRUPTOR] Set OKS_Drone_Disabled on %1 | Variable now: %2", typeOf _closestHit, _closestHit getVariable ["OKS_Drone_Disabled", false]];
		diag_log format ["[DISRUPTOR] Drone disabled flag set | Drone: %1 | Variable check: %2", _closestHit, _closestHit getVariable ["OKS_Drone_Disabled", false]];
	};
	
	// Kill the crew (standard UAV disable method)
	{
		deleteVehicle _x;
	} forEach crew _closestHit;
	
	// CRITICAL: Kill thrust and create tumbling fall effect
	private _currentVel = velocity _closestHit;
	private _reducedVel = _currentVel vectorMultiply 0.2;  // Keep 20% forward momentum
	private _fallVel = [(_reducedVel select 0), (_reducedVel select 1), -5];  // Add downward velocity
	_closestHit setVelocity _fallVel;
	
	if (_masterDebug && _disruptorDebug) then {
		diag_log format ["[DISRUPTOR] Killed thrust for %1 | Old vel: %2 | New vel: %3", _closestHit, _currentVel, _fallVel];
	};
	
	// Create electrical spark effect at drone position
	[_closestHit, _shooterPos, _masterDebug, _disruptorDebug] spawn {
		params ["_drone", "_shooterPos", "_masterDebug", "_disruptorDebug"];
		
		if (_masterDebug && _disruptorDebug) then {
			diag_log "[DISRUPTOR] Spawning electrical effects...";
		};
		
		// Lightning/spark effect
		private _dronePos = getPosASL _drone;
		
		// Create light effect (electric flash)
		private _light = "#lightpoint" createVehicleLocal (ASLToAGL _dronePos);
		_light setLightBrightness 10;
		_light setLightColor [0.5, 0.5, 1]; // Blue-white electric color
		_light setLightAmbient [0.3, 0.3, 0.8];
		_light setLightIntensity 5000;
		
		// Spark particles
		private _source = "#particlesource" createVehicleLocal (ASLToAGL _dronePos);
		_source setParticleParams [
			["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48],
			"", "Billboard", 1, 0.3,
			[0, 0, 0], [0, 0, 0], 0, 1.5, 1, 0,
			[0.1, 0.2], 
			[[1, 1, 1, 0.5], [1, 1, 1, 0.3], [1, 1, 1, 0]],
			[1000], 0.1, 0.05, "", "", _drone
		];
		_source setDropInterval 0.01;
		
		// Custom drone impact sound - place your .ogg file at: OKS_GOL_Misc\Sounds\drone_hit.ogg
		playSound3D ["\OKS_GOL_Misc\Sounds\drone_hit.ogg", _drone, false, _dronePos, 2, 1, 150];
		
		if (_masterDebug && _disruptorDebug) then {
			diag_log "[DISRUPTOR] Played electrical sound and created effects";
		};
		
		// Cleanup after effect
		sleep 0.5;
		deleteVehicle _light;
		deleteVehicle _source;
	};
};

// Final summary
if (_masterDebug && _disruptorDebug) then {
	if (!isNull _closestHit) then {
		systemChat format ["[DISRUPTOR] Successfully hit: %1 at %2m", typeOf _closestHit, round _closestDist];
	} else {
		systemChat "[DISRUPTOR] No drones hit - outside cone or out of range";
	};
	
	diag_log format ["[DISRUPTOR] Summary | Hit: %1 | Drones checked: %2 | Closest hit: %3m", 
		(!isNull _closestHit), count _nearbyDrones, round _closestDist];
};
