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
if (count _nearbyContainers == 0) exitWith {};

// Check if gunner has space for one magazine in inventory
private _canAddMag = _gunner canAdd [_magazine, 1, true];
if !(_canAddMag) exitWith {};

// Search containers for matching magazine
private _foundMatch = false;
{
	private _container = _x;
	private _containerMags = magazinesAmmoCargo _container;
	
	{
		_x params ["_magClass", "_ammoCount"];
		
		if (_magClass == _magazineClass && _ammoCount > 0) then {
			systemChat format ["✓ Picked up %1", _magDisplayName];
			hint format ["Picked up\n%1", _magDisplayName];
			
			// Add magazine to gunner
			_gunner addMagazine [_magClass, _ammoCount];
			
			// Remove from container
			_container addMagazineAmmoCargo [_magClass, -1, _ammoCount];
			
			_foundMatch = true;
			breakTo "main";
		};
	} forEach _containerMags;
	
} forEach _nearbyContainers;

