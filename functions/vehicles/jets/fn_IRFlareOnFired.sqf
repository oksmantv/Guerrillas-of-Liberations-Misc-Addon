/*
    Fired class event handler.
    Detects GOL IR flare projectiles and requests local IR light attachment
    on all clients, so both UGL and CM-fired rounds use the same effect.
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

if (_ammo != "GOL_40mm_Flare_ir_Subtle") exitWith {};
if (isNull _projectile) exitWith {};

if (_projectile getVariable ["GOL_IRFlareLightAttached", false]) exitWith {};
_projectile setVariable ["GOL_IRFlareLightAttached", true, true];

private _id = netId _projectile;
if (_id == "") exitWith {
    [_projectile] call OKS_fnc_IRFlareAttachLight;
};

[_id] remoteExecCall ["OKS_fnc_IRFlareAttachLight", 0, false];
