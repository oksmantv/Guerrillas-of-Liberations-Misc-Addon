/*
 * OKS_fnc_M6_Flare_Altitude_Deploy
 * 
 * Tracks 60mm flare dummy projectile and spawns actual flare at 300-350m altitude.
 * Called from Fired event handler when flare dummy is fired.
 * 
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Weapon <STRING>
 * 2: Muzzle <STRING>
 * 3: Mode <STRING>
 * 4: Ammo <STRING>
 * 5: Magazine <STRING>
 * 6: Projectile <OBJECT>
 * 
 * Return Value:
 * None
 */

params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammoType", "_magazine", "_projectile"];

// Only process our dummy flare round
if (_ammoType != "OKS_60mm_Flare_Dummy") exitWith {};

// Check GOL_IRFlaresEnabled setting to determine flare type
private _useIR = missionNamespace getVariable ["GOL_IRFlaresEnabled", false];
private _flareClass = if (_useIR) then {
	"OKS_60mm_Flare_IR_Spawned"
} else {
	"OKS_60mm_Flare_Spawned"
};

// Randomize deployment altitude: 300-350m AGL
private _deployAltitude = 300 + random 50;

["M6 Flare: Tracking projectile for altitude deployment", true, false, false] spawn OKS_fnc_LogDebug;

// Track projectile altitude - wait for ascending above target, then descending through it
[{
	params ["_args", "_handle"];
	_args params ["_projectile", "_deployAltitude", "_reachedPeak"];
	
	// Exit if projectile deleted or hit ground
	if (isNull _projectile || {!alive _projectile}) exitWith {
		[_handle] call CBA_fnc_removePerFrameHandler;
		["M6 Flare: Projectile destroyed before deployment", true, false, false] spawn OKS_fnc_LogDebug;
	};
	
	private _pos = getPosATL _projectile;
	private _altitude = _pos select 2;
	private _vel = velocity _projectile;
	private _verticalVel = _vel select 2;
	
	// Phase 1: Wait until projectile ascends above deployment altitude
	if (!_reachedPeak && {_altitude >= _deployAltitude}) then {
		_args set [2, true];  // Mark that we've reached above target altitude
		["M6 Flare: Projectile reached target altitude, waiting for descent", true, false, false] spawn OKS_fnc_LogDebug;
	};
	
	// Phase 2: Deploy when descending back through deployment altitude
	if (_reachedPeak && {_altitude <= _deployAltitude} && {_verticalVel < 0}) then {
		[_handle] call CBA_fnc_removePerFrameHandler;
		
		// Get flare class from args
		private _flareClass = _args select 3;
		
		// Spawn actual flare at projectile position
		private _flare = createVehicle [_flareClass, _pos, [], 0, "NONE"];
		_flare setVelocity _vel;
		_flare setDir (direction _projectile);
		
		// Delete dummy projectile
		deleteVehicle _projectile;
		
		[format ["M6 Flare: Deployed at %1m AGL (descending)", round _altitude], true, false, false] spawn OKS_fnc_LogDebug;
	};
	
}, 0.1, [_projectile, _deployAltitude, false, _flareClass]] call CBA_fnc_addPerFrameHandler;
