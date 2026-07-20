/*
    M6 Mortar - Add Unpack Actions
    Adds ACE self-actions for unpacking 60mm ammo when in M6 mortar
    
    Called when player enters UK3CB_BAF_Static_M6
    Removes any existing actions first to prevent duplicates
    Actions are removed when player exits vehicle
    
    params ["_unit"];
*/

params ["_unit"];

if (!hasInterface || !local _unit) exitWith {};

// Check if this unit already has M6 actions (don't remove on exit, just check here)
private _actionsExist = _unit getVariable ["OKS_M6_ActionsInitialized", false];

if (_actionsExist) exitWith {
    [format ["M6 GetIn: Unit already has actions, skipping"], true] spawn OKS_fnc_LogDebug;
};

[format ["M6 GetIn: Adding actions to unit for first time"], true] spawn OKS_fnc_LogDebug;

private _actionHE = [
    "OKS_Unpack_60mm_HE_Vehicle",
    "Unpack 60mm HE",
    "\OKS_GOL_Misc\Data\UI\60mm_HE.paa",
    {
        [_player] call OKS_fnc_Unpack_60mm_HE_Code;
    },
    {
        ('GOL_Packed_60mm_HE' in (itemsWithMagazines _player)) &&
        ((typeOf vehicle _player) == "UK3CB_BAF_Static_M6") &&
        ((loadBackpack _player + 4 * (getNumber (configFile >> 'CfgMagazines' >> 'UK3CB_BAF_1Rnd_60mm_Mo_Shells' >> 'mass'))) <= (getContainerMaxLoad (backpack _player)))
    }
] call ace_interact_menu_fnc_createAction;

private _actionHEAB = [
    "OKS_Unpack_60mm_HEAB_Vehicle",
    "Unpack 60mm HEAB",
    "\OKS_GOL_Misc\Data\UI\60mm_HEAB.paa",
    {
        [_player] call OKS_fnc_Unpack_60mm_HEAB_Code;
    },
    {
        ('GOL_Packed_60mm_HEAB' in (itemsWithMagazines _player)) &&
        ((typeOf vehicle _player) == "UK3CB_BAF_Static_M6") &&
        ((loadBackpack _player + 4 * (getNumber (configFile >> 'CfgMagazines' >> 'UK3CB_BAF_1Rnd_60mm_Mo_AB_Shells' >> 'mass'))) <= (getContainerMaxLoad (backpack _player)))
    }
] call ace_interact_menu_fnc_createAction;

private _actionSmoke = [
    "OKS_Unpack_60mm_Smoke_Vehicle",
    "Unpack 60mm Smoke",
    "\OKS_GOL_Misc\Data\UI\60mm_Smoke.paa",
    {
        [_player] call OKS_fnc_Unpack_60mm_Smoke_Code;
    },
    {
        ('GOL_Packed_60mm_Smoke' in (itemsWithMagazines _player)) &&
        ((typeOf vehicle _player) == "UK3CB_BAF_Static_M6") &&
        ((loadBackpack _player + 4 * (getNumber (configFile >> 'CfgMagazines' >> 'UK3CB_BAF_1Rnd_60mm_Mo_Smoke_White' >> 'mass'))) <= (getContainerMaxLoad (backpack _player)))
    }
] call ace_interact_menu_fnc_createAction;

private _actionFlare = [
    "OKS_Unpack_60mm_Flare_Vehicle",
    "Unpack 60mm Flare",
    "\OKS_GOL_Misc\Data\UI\60mm_Flare.paa",
    {
        [_player] call OKS_fnc_Unpack_60mm_Flare_Code;
    },
    {
        ('GOL_Packed_60mm_Flare' in (itemsWithMagazines _player)) &&
        ((typeOf vehicle _player) == "UK3CB_BAF_Static_M6") &&
        ((loadBackpack _player + 4 * (getNumber (configFile >> 'CfgMagazines' >> 'UK3CB_BAF_1Rnd_60mm_Mo_Flare_White' >> 'mass'))) <= (getContainerMaxLoad (backpack _player)))
    }
] call ace_interact_menu_fnc_createAction;

// Add actions to player and store the returned action paths
private _actionPathHE = [_unit, 1, ["ACE_SelfActions", "ACE_Equipment"], _actionHE] call ace_interact_menu_fnc_addActionToObject;
private _actionPathHEAB = [_unit, 1, ["ACE_SelfActions", "ACE_Equipment"], _actionHEAB] call ace_interact_menu_fnc_addActionToObject;
private _actionPathSmoke = [_unit, 1, ["ACE_SelfActions", "ACE_Equipment"], _actionSmoke] call ace_interact_menu_fnc_addActionToObject;
private _actionPathFlare = [_unit, 1, ["ACE_SelfActions", "ACE_Equipment"], _actionFlare] call ace_interact_menu_fnc_addActionToObject;

[format ["Added actions, paths: %1, %2, %3, %4", _actionPathHE, _actionPathHEAB, _actionPathSmoke, _actionPathFlare], true] spawn OKS_fnc_LogDebug;

// Mark this unit as having M6 actions (never cleared - conditions handle visibility)
_unit setVariable ["OKS_M6_ActionsInitialized", true];
