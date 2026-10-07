/*
    M6 Mortar - Add Unpack Actions
    Adds ACE self-actions for unpacking 60mm ammo when in M6 mortar
    
    Called via Extended_GetIn_EventHandlers when player enters UK3CB_BAF_Static_M6
    Removes any existing actions first to prevent duplicates
    Actions are removed when player exits vehicle
    
    Extended GetIn params: [vehicle, position, unit, turret]
*/

params ["_vehicle", "_position", "_unit", "_turret"];

if (!hasInterface || !local _unit) exitWith {};

// Add Fired event handler to vehicle if it doesn't already have one
private _hasHandler = _vehicle getVariable ["OKS_M6_HasFiredHandler", false];
if (!_hasHandler) then {
    private _firedID = _vehicle addEventHandler ["Fired", {
        params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
        
        // Call combined handler (params already match Extended_FiredBIS format)
        _this call OKS_fnc_M6_Fired_Combined_Handler;
    }];
    
    _vehicle setVariable ["OKS_M6_VehicleFiredID", _firedID];
    _vehicle setVariable ["OKS_M6_HasFiredHandler", true];
};

// Check if this unit already has M6 actions (don't remove on exit, just check here)
private _actionsExist = _unit getVariable ["OKS_M6_ActionsInitialized", false];
if (_actionsExist) exitWith {};

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

// Mark this unit as having M6 actions (never cleared - conditions handle visibility)
_unit setVariable ["OKS_M6_ActionsInitialized", true];
