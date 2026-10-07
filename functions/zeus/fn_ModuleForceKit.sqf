/*
    OKS_fnc_ModuleForceKit

    Zeus module - forces a unit's gear to refresh as a specific role/kit.

    Drop this module directly onto a unit in Zeus (curator attach) - or draw
    a sync line to one or more units - to force-refresh their kit. The role
    is baked into the module's config (one module class per role, via the
    "OKS_ForceKit_Role" property) and applied through the framework's
    GW_Gear_Fnc_Handler. Runs once on placement, then deletes itself.

    Usage: Driven automatically by the engine's module system, not intended
    to be called directly.

    Arguments:
    0: Logic <OBJECT> - the module logic object
    1: Units <ARRAY> - synchronized units (engine-provided)
    2: Activated <BOOL>

    Return Value: NO

    Public: NO
*/

params [
    ["_logic", objNull, [objNull]],
    ["_units", [], [[]]],
    ["_activated", true, [true]]
];

if (isNull _logic) exitWith {};
if !(_activated) exitWith {};

private _role = getText (configFile >> "CfgVehicles" >> (typeOf _logic) >> "OKS_ForceKit_Role");

if (_role isEqualTo "") exitWith {
    deleteVehicle _logic;
};

private _targets = [];

private _attached = attachedTo _logic;
if !(isNull _attached) then {
    _targets pushBackUnique _attached;
};

{
    if (_x isKindOf "CAManBase") then {
        _targets pushBackUnique _x;
    };
} forEach (synchronizedObjects _logic);

{
    if (_x isKindOf "CAManBase") then {
        _targets pushBackUnique _x;
    };
} forEach _units;

if (_targets isEqualTo []) exitWith {
    hint "GOL Gear - Force kit: No unit attached or synced to this module.";
    deleteVehicle _logic;
};

{
    if (local _x) then {
        [_x, _role] call GW_Gear_Fnc_Handler;
    } else {
        [_x, _role] remoteExec ["GW_Gear_Fnc_Handler", _x];
    };
} forEach _targets;

deleteVehicle _logic;
