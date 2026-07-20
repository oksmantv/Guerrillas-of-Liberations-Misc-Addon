/*
    M6 Mortar - Remove Unpack Actions
    Removes ACE self-actions for unpacking 60mm ammo
    
    Called when player exits UK3CB_BAF_Static_M6
    
    params ["_unit"];
*/

params ["_unit"];

if (!hasInterface || !local _unit) exitWith {};

// No need to remove actions - they're player-specific and conditions will hide them when dismounted
// Just log for debugging
[format ["M6 GetOut: Player exited (actions remain, hidden by conditions)"], true] spawn OKS_fnc_LogDebug;
