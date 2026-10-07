/*  CUSTOM_fnc_VLS imported by Sokkada
 *
 * Parameters:
 *   _sideFriendly      - Side: VLS friendly side (e.g. west, east, resistance, civilian, etc.)
 *   _sideEnemy         - Side: VLS enemy side (e.g. west, east, resistance, civilian, etc.)
 *   _artilleryVehicle  – Object: VLS vehicle
 *   _operator          – Object: VLS gunner unit
 *   _targetLocation    – Array: Location that will be fired at (object)
 *   _magazineClass     – String: Classname of the ammo magazine (["magazine_Missiles_Cruise_01_x18","magazine_Missiles_Cruise_01_Cluster_x18","18Rnd_CruiseMissile_80_Mag","18Rnd_CruiseMissile_155_Mag","18Rnd_CruiseMissile_PS_Mag"])
 *   _rounds            – Number: Number of rounds to fire
 *   _delayBetweenRounds - Number: Delay (in seconds) between each round
 *   _delayBeforeDelete  - Number: Delay (in seconds) from a missile is fired until it is deleted
 * 
 *   Example: [west, east, vls_1, gunner vls_1, vlstarget_1, "magazine_Missiles_Cruise_01_x18", 2, 4, 30] spawn OKS_fnc_VLS_SimpleLaunchAndDelete;
 *
 */

params [
	["_sideFriendly", west, [sideUnknown]],
	["_sideEnemy", east, [sideUnknown]],
	["_artilleryVehicle", objNull, [objNull]],
	["_operator", objNull, [objNull]],
	["_targetLocation", objNull, [objNull]],
	["_magazineClass", "magazine_Missiles_Cruise_01_x18", [""]], // ["magazine_Missiles_Cruise_01_x18","magazine_Missiles_Cruise_01_Cluster_x18","18Rnd_CruiseMissile_80_Mag","18Rnd_CruiseMissile_155_Mag","18Rnd_CruiseMissile_PS_Mag"]
	["_rounds", 1, [0]],
	["_delayBetweenRounds", 2, [0]],
	["_delayBeforeDelete", 30, [0]]
];

if (_sideFriendly == sideUnknown) exitWith { hint "Friendly side missing" };
if (_sideEnemy == sideUnknown) exitWith { hint "Enemy side missing" };

if (isNull _artilleryVehicle) exitWith { hint "VLS vehicle missing" };
if (isNull _operator) exitWith { hint "Operator (gunner) missing" };

if (isNull _targetLocation) exitWith { hint "Target location missing" };

_artilleryVehicle setVariable ["CUSTOM_VLS_DelayBeforeDelete", _delayBeforeDelete, false];

// Ensure operator is behaving as intended
_operator allowFleeing 0;
_operator setBehaviour "CARELESS";
_operator setCombatMode "BLUE";
_operator disableAI "ALL";
_operator assignAsGunner _artilleryVehicle;
_operator moveInGunner _artilleryVehicle;

// Set up event handlers for cleanup
_artilleryVehicle addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

	[_unit, _projectile] spawn {
		params ["_unit", "_projectile"];
		
		private _delayBeforeDelete = _unit getVariable ["CUSTOM_VLS_DelayBeforeDelete", 10];

		sleep _delayBeforeDelete;
		
		deleteVehicle _projectile;
	};
}];

// Load munition type
_artilleryVehicle loadMagazine [[0], "weapon_VLS_01", _magazineClass];

sleep 2;

for "_i" from 1 to _rounds do {
	_sideFriendly reportRemoteTarget [_targetLocation, 5000];
	_artilleryVehicle confirmSensorTarget [_sideFriendly, true];
	_artilleryVehicle fireAtTarget [_targetLocation, "weapon_VLS_01"];
	
	sleep _delayBetweenRounds;
};
