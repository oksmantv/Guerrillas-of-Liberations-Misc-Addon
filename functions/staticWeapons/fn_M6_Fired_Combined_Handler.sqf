/*
 * OKS_fnc_M6_Fired_Combined_Handler
 * 
 * Combined Fired event handler for M6 mortar
 * Handles both auto-reload from nearby containers and flare altitude deployment
 * 
 * Called automatically via Extended_Fired_EventHandlers in config.cpp
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

params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammoType", "_magazine", "_projectile", ["_gunner", objNull]];

// Handle magazine parameter - can be string (classname) or array [classname, ammo]
private _magazineClass = if (_magazine isEqualType "") then {_magazine} else {
	if (_magazine isEqualType []) then {_magazine select 0} else {str _magazine}
};

// Flare altitude deployment system
if (_ammoType == "OKS_60mm_Flare_Dummy" || _magazineClass == "UK3CB_BAF_1Rnd_60mm_Mo_Flare_White") then {
	_this spawn OKS_fnc_M6_Flare_Altitude_Deploy;
};



// Auto-reload from nearby containers
_this call OKS_fnc_M6_Auto_Reload_Handler;

