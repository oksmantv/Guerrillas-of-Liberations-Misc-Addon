// / Adjusts damage on player vehicles to reduce hull hitpoint damage by 75%
// / [_Vehicle] call OKS_fnc_AdjustPlayerVehicleDamage;

params ["_Vehicle"];

if (hasInterface && !isServer) exitWith {};

Private _Debug = missionNamespace getVariable ["GOL_PlayerVehicle_Debug", false];
Private _PlayerVehicleDamageDebug = missionNamespace getVariable ["GOL_PlayerVehicleDamage_Debug", false];

if (_PlayerVehicleDamageDebug) then {
	format["[PLAYER-VEHICLE-DAMAGE] Processing damage adjustment for vehicle: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
};

if (isNull _Vehicle) exitWith {
	if (_Debug) then {
		format ["AdjustPlayerVehicleDamage Script, Vehicle was null. Exiting.."] spawn OKS_fnc_LogDebug;
	};
	if (_PlayerVehicleDamageDebug) then {
		format["[PLAYER-VEHICLE-DAMAGE] Vehicle is null, exiting"] spawn OKS_fnc_LogDebug;
	};
};

// private function to check if vehicle qualifies for damage reduction
private _fnc_shouldApplyDamageReduction = {
	params ["_vehicle"];
	(
		["FV432", typeOf _vehicle] call BIS_fnc_inString ||
		["BTR60", typeOf _vehicle] call BIS_fnc_inString ||
		["BTR70", typeOf _vehicle] call BIS_fnc_inString ||
		["BTR80", typeOf _vehicle] call BIS_fnc_inString ||
		["BMP1", typeOf _vehicle] call BIS_fnc_inString ||
		["BMP2", typeOf _vehicle] call BIS_fnc_inString ||
		["BMP3", typeOf _vehicle] call BIS_fnc_inString ||
		["BMD", typeOf _vehicle] call BIS_fnc_inString ||
		["M1126", typeOf _vehicle] call BIS_fnc_inString ||
		["AAV", typeOf _vehicle] call BIS_fnc_inString ||
		["LAV25", typeOf _vehicle] call BIS_fnc_inString ||
		["SPRUT", typeOf _vehicle] call BIS_fnc_inString
	)
};

// Check if this is a specific vehicle type that should get damage reduction
private _shouldApplyDamageReduction = [_Vehicle] call _fnc_shouldApplyDamageReduction;
if (_shouldApplyDamageReduction) then {
	if (_PlayerVehicleDamageDebug) then {
		format["[PLAYER-VEHICLE-DAMAGE] Vehicle %1 qualifies for damage reduction", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
};

if (!_shouldApplyDamageReduction) exitWith {
	if (_Debug) then {
		format["AdjustPlayerVehicleDamage - %1 not eligible for damage reduction", [configFile >> "CfgVehicles" >> typeOf _Vehicle] call BIS_fnc_displayName] spawn OKS_fnc_LogDebug;
	};
	if (_PlayerVehicleDamageDebug) then {
		format["[PLAYER-VEHICLE-DAMAGE] Vehicle %1 not eligible for damage reduction, exiting", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
};

// set armor to default value (cannot exceed 1)
_Vehicle setVehicleArmor 1;

if (_PlayerVehicleDamageDebug) then {
	format["[PLAYER-VEHICLE-DAMAGE] Setting up damage reduction for vehicle: %1 | Armor set to 100%", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
};

if (_Debug) then {
	format["AdjustPlayerVehicleDamage enabled on %1 - Armor set to 100%", [configFile >> "CfgVehicles" >> typeOf _Vehicle] call BIS_fnc_displayName] spawn OKS_fnc_LogDebug;
};

_Vehicle addEventHandler ["HandleDamage",
	{
		params ["_unit", "_selection", "_newDamage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit"];
		private _isSpallDamage = (_projectile find "spall" != -1);
		private _isPenetratorDamage = (_projectile find "penetrator" != -1);
		
		// If it's spall or penetrator damage, ignore it completely
		if (_isSpallDamage) exitWith {
			Private _PlayerVehicleDamageDebug = missionNamespace getVariable ["GOL_PlayerVehicleDamage_Debug", false];
			if (_PlayerVehicleDamageDebug) then {
				//format["[PLAYER-VEHICLE-DAMAGE] SPALL DETECTED - Ignoring damage for %1 | Projectile: %2", typeOf _unit, _projectile] spawn OKS_fnc_LogDebug;
			};
			private _currentDamage = if (_hitPoint == "") then {damage _unit} else {_unit getHitPointDamage _hitPoint};
			_currentDamage
		};
		Private _Debug = missionNamespace getVariable ["GOL_PlayerVehicle_Debug", false];
		Private _PlayerVehicleDamageDebug = missionNamespace getVariable ["GOL_PlayerVehicleDamage_Debug", false];

		// Exits
		if !(alive _unit) exitWith {};
		// Apply damage reduction to ALL components (removed selective filtering)

		if (_PlayerVehicleDamageDebug) then {
			format["[PLAYER-VEHICLE-DAMAGE] Handling damage for %1 | HitPoint: %2 | Damage: %3 | Source: %4", typeOf _unit, _hitPoint, _newDamage, typeOf _source] spawn OKS_fnc_LogDebug;
		};

		// damage reduction multiplier - balanced for survivability vs gameplay
		private _damageMultiplier = 0.3;  // 70% reduction for normal components
		
		// Cosmetic components that barely matter - use string contains for flexibility
		private _isCosmeticComponent = (
			(_hitPoint find "svetlo" != -1) ||
			(_hitPoint find "periscope" != -1)
		);
		
		// Critical components that can cause explosions need extra protection
		private _criticalComponents = ["hithull", "hitengine", "hitfuel", "hitgun"];
		private _isCritical = (toLower _hitPoint) in _criticalComponents;
		
		if (_isCosmeticComponent) then {
			_damageMultiplier = 0.05; // 95% reduction for cosmetic components
		} else {
			if (_isCritical) then {
				_damageMultiplier = 0.2; // 80% reduction for critical components
			};
		};

		// Ensure armor stays at default
		if (getNumber(configFile >> "CfgVehicles" >> typeOf _unit >> "armor") > 0) then {
			_unit setVehicleArmor 1.0;
		};

		// Calculate damage
		private _oldDamage = _unit getVariable [format["GOL_oldDamage_%1", _hitPoint], 0];
		private _addedDamage = _newDamage - _oldDamage;

		if (_addedDamage <= 0) exitWith {_oldDamage}; // Return stored damage if no new damage

		// Clamp added damage between 0 and 1.0 (no negative damage, max 1.0 per hit)
		_addedDamage = (_addedDamage max 0) min 1.0;

		// apply damage reduction
		_finalDamage = _oldDamage + (_addedDamage * _damageMultiplier);

		if (_PlayerVehicleDamageDebug) then {
			private _multiplierText = if (_isCosmeticComponent) then {"0.05 (COSMETIC)"} else {if (_isCritical) then {"0.2 (CRITICAL)"} else {"0.3 (NORMAL)"}};
			format["[PLAYER-VEHICLE-DAMAGE] Damage calculation for %1 | HitPoint: %2 | Multiplier: %3 | Old: %4 | Added: %5 | Final: %6", typeOf _unit, _hitPoint, _multiplierText, _oldDamage, _addedDamage, _finalDamage] spawn OKS_fnc_LogDebug;
		};

		if (ToLower _hitpoint == "hithull") then {
			if (_Debug) then {
				format ["AdjustPlayerVehicleDamage - Hull Hit | Old: %3 | Added: %1 | Reduced: %4 | Final: %2", _addedDamage, _finalDamage, _oldDamage, (_addedDamage * _damageMultiplier)] spawn OKS_fnc_LogDebug;
			};
		};

		_unit setVariable [format["GOL_oldDamage_%1", _hitPoint], _finalDamage];

		_finalDamage = _finalDamage min 1.0;
		_finalDamage
	}
];