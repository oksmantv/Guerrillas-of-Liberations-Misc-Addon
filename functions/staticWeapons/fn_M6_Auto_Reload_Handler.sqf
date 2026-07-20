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

params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammoType", "_magazine", "_projectile"];

private _magDisplayName = getText (configFile >> "CfgMagazines" >> _magazine >> "displayName");

format ["[M6 Auto-Reload] Fired: vehicle=%1, weapon=%2, magazine=%3", typeOf _vehicle, _weapon, _magazine] spawn OKS_fnc_LogDebug;

private _gunner = gunner _vehicle;
if (isNull _gunner) exitWith {
	"[M6 Auto-Reload] EXIT: Gunner is null" spawn OKS_fnc_LogDebug;
};

if (!local _gunner) exitWith {
	format ["[M6 Auto-Reload] EXIT: Gunner not local (local=%1)", local _gunner] spawn OKS_fnc_LogDebug;
};

// Find nearby containers and weapon holders within 10m
private _nearbyContainers = nearestObjects [_vehicle, ["GroundWeaponHolder", "ReammoBox_F"], 10];
format ["[M6 Auto-Reload] Nearby containers: %1", count _nearbyContainers] spawn OKS_fnc_LogDebug;

if (count _nearbyContainers == 0) exitWith {
	"[M6 Auto-Reload] EXIT: No nearby containers" spawn OKS_fnc_LogDebug;
};

// Check if gunner has space for one magazine in inventory
private _canAddMag = _gunner canAdd [_magazine, 1, true];
format ["[M6 Auto-Reload] canAdd check: %1 (loadBackpack=%2)", _canAddMag, loadBackpack _gunner] spawn OKS_fnc_LogDebug;

if !(_canAddMag) exitWith {
	"[M6 Auto-Reload] EXIT: No inventory space" spawn OKS_fnc_LogDebug;
};

// Search containers for matching magazine
private _foundMatch = false;
{
	private _container = _x;
	private _containerMags = magazinesAmmoCargo _container;
	format ["[M6 Auto-Reload] Checking container %1 with %2 magazines", typeOf _container, count _containerMags] spawn OKS_fnc_LogDebug;
	
	{
		_x params ["_magClass", "_ammoCount"];
		
		if (_magClass == _magazine) then {
			systemChat format ["Picked up %1", _magDisplayName];
			hint format ["Picked up\n%1", _magDisplayName];
			format ["[M6 Auto-Reload] SUCCESS: Adding %1 (%2 rounds) to gunner", _magClass, _ammoCount] spawn OKS_fnc_LogDebug;
			
			// Add magazine to gunner
			_gunner addMagazine [_magClass, _ammoCount];
			
			// Remove from container
			_container addMagazineAmmoCargo [_magClass, -1, _ammoCount];
			
			_foundMatch = true;
			breakTo "main";
		};
	} forEach _containerMags;
	
} forEach _nearbyContainers;

if (!_foundMatch) then {
	format ["[M6 Auto-Reload] No matching magazine found. Looking for: %1", _magazine] spawn OKS_fnc_LogDebug;
};

