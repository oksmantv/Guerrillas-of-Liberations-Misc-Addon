/*
    Fired event handler for visible CM flares.
    Detects GOL visible flare projectiles and requests local light attachment
    on all clients to guarantee strong ground illumination.
*/

params [
    ["_unit", objNull, [objNull]],
    ["_weapon", "", [""]],
    ["_muzzle", "", [""]],
    ["_mode", "", [""]],
    ["_ammo", "", [""]],
    ["_magazine", "", [""]],
    ["_projectile", objNull, [objNull]],
    ["_gunner", objNull, [objNull]]
];

if (_ammo != "GOL_40mm_Flare_White_air") exitWith {};
if (isNull _projectile) exitWith {};

if (_projectile getVariable ["GOL_VisibleFlareLightAttached", false]) exitWith {};
_projectile setVariable ["GOL_VisibleFlareLightAttached", true, true];

private _id = netId _projectile;
if (_id == "") exitWith {
    [_projectile] call OKS_fnc_VisibleFlareAttachLight;
};

[_id] remoteExecCall ["OKS_fnc_VisibleFlareAttachLight", 0, false];
