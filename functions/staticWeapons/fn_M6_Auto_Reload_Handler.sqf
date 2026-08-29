/*
    M6 Mortar Auto-Reload Handler  
    Fired event handler that auto-loads ammo from nearby containers/ground
    
    Called automatically when M6 mortar fires
    Searches for matching ammo in nearby GroundWeaponHolders/containers
    Adds one round to gunner's inventory if space available
    Provides user feedback via systemChat and hint
    Logs debug info via OKS_fnc_LogDebug (requires GOL_Core_Debug enabled)
    
    params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammoType", "_magazine", "_projectile"];
*/

params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammoType", "_magazine", "_projectile", ["_gunner", objNull]];

// Handle magazine parameter - can be string (classname), array [classname, ammo], or object
private _magazineClass = if (_magazine isEqualType "") then {
    _magazine
} else {
    if (_magazine isEqualType []) then {
        _magazine select 0
    } else {
        str _magazine
    }
};
private _magDisplayName = getText (configFile >> "CfgMagazines" >> _magazineClass >> "displayName");

// Get gunner from vehicle if not provided in params
if (isNull _gunner) then {
	_gunner = gunner _vehicle;
};

if (isNull _gunner || !local _gunner) exitWith {};

// Find nearby containers and weapon holders within 10m
private _nearbyContainers = nearestObjects [_vehicle, ["GroundWeaponHolder", "ReammoBox_F"], 10];

// Search containers for matching magazine
private _foundMatch = false;
if (count _nearbyContainers > 0) then {
	// Check if gunner has space for one magazine in inventory
	private _canAddMag = _gunner canAdd [_magazineClass, 1, true];
	if (_canAddMag) then {
		{
			private _container = _x;
			private _containerMags = magazinesAmmoCargo _container;
			
			{
				_x params ["_magClass", "_ammoCount"];
				
				if (_magClass == _magazineClass && _ammoCount > 0) then {
					private _uMax  = if (uniform _gunner != "") then { getContainerMaxLoad (uniform _gunner) } else { 0 };
					private _vMax  = if (vest _gunner != "") then { getContainerMaxLoad (vest _gunner) } else { 0 };
					private _bpMax = if (backpack _gunner != "") then { getContainerMaxLoad (backpack _gunner) } else { 0 };
					private _totalMax  = _uMax + _vMax + _bpMax;
					private _totalLoad = (loadUniform _gunner) * _uMax + (loadVest _gunner) * _vMax + (loadBackpack _gunner) * _bpMax;
					private _pct = if (_totalMax > 0) then { round (_totalLoad / _totalMax * 100) } else { 0 };
					private _pctStr = str _pct + "% Inventory Usage";
					systemChat format ["✓ Picked up %1. %2.", _magDisplayName, _pctStr];
					hint format ["Picked up\n%1\n%2", _magDisplayName, _pctStr];
					
					// Add magazine to gunner
					_gunner addMagazine [_magClass, _ammoCount];
					
					// Remove from container
					_container addMagazineAmmoCargo [_magClass, -1, _ammoCount];
					
					_foundMatch = true;
					breakTo "main";
				};
			} forEach _containerMags;
			
		} forEach _nearbyContainers;
	};
};

// If no ground ammo found, check if gunner ran out and can auto-unpack
if (!_foundMatch) then {
	private _hasRoundsLeft = _magazineClass in magazines _gunner;
	if (!_hasRoundsLeft) then {
		private _packedItem = switch (_magazineClass) do {
			case "UK3CB_BAF_1Rnd_60mm_Mo_Shells":      { "GOL_Packed_60mm_HE" };
			case "UK3CB_BAF_1Rnd_60mm_Mo_AB_Shells":   { "GOL_Packed_60mm_HEAB" };
			case "UK3CB_BAF_1Rnd_60mm_Mo_Smoke_White": { "GOL_Packed_60mm_Smoke" };
			case "UK3CB_BAF_1Rnd_60mm_Mo_Flare_White": { "GOL_Packed_60mm_Flare" };
			default { "" };
		};
		if (_packedItem != "" && _packedItem in (itemsWithMagazines _gunner)) then {
			private _unpackFn = switch (_packedItem) do {
				case "GOL_Packed_60mm_HE":    { OKS_fnc_Unpack_60mm_HE_Code };
				case "GOL_Packed_60mm_HEAB":  { OKS_fnc_Unpack_60mm_HEAB_Code };
				case "GOL_Packed_60mm_Smoke": { OKS_fnc_Unpack_60mm_Smoke_Code };
				case "GOL_Packed_60mm_Flare": { OKS_fnc_Unpack_60mm_Flare_Code };
				default { {} };
			};
			systemChat format ["Out of %1 - auto-unpacking...", trim _magDisplayName];
			[_gunner] call _unpackFn;
		};
	};
};

