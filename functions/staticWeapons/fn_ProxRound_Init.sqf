/*
 * OKS_fnc_ProxRound_Init
 *
 * Client-side initialisation for the IFV autocannon proximity fuse system.
 *
 * Sets up GetInMan / GetOutMan player event handlers (via CBA_fnc_addPlayerEventHandler,
 * which re-attaches automatically after respawn) and CBA keybinds for adjusting the
 * gunner's absolute proximity-fuse range. The Alt + mouse-wheel bindings only handle
 * input while the local player is an active proximity-fuse gunner.
 *
 * Ammo is auto-detected at fire time (see OKS_fnc_ProxRound_FiredHandler):
 *   caliber >= OKS_ProxRound_Calibre (default 4, approx. 20 mm+)
 *   AND indirectHit > 0 (HE / HEAB / HEDP — excludes pure AP / APFSDS)
 *
 * The fuse distance is taken from the weapon's current zeroing at the
 * instant the round leaves the barrel.
 *
 * Called from: XEH_postInit_Global.sqf (hasInterface block)
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 */

if (!hasInterface) exitWith {};

// Default calibre threshold — override per mission via OKS_ProxRound_Calibre = X
if (isNil "OKS_ProxRound_Calibre") then { OKS_ProxRound_Calibre = 4; };

// CBA supports mouse wheel bindings using 0xF8 (up) and 0xF9 (down).
[
    "GOL Custom Controls",
    "OKS_ProxRound_IncreaseRange",
    ["Increase Proximity Fuse Range", "Alt + mouse wheel up: increase the active proximity-fuse range by 1 metre."],
    { [1] call OKS_fnc_ProxRound_AdjustRange; },
    {},
    [0xF8, [false, false, true]],
    false
] call CBA_fnc_addKeybind;

[
    "GOL Custom Controls",
    "OKS_ProxRound_DecreaseRange",
    ["Decrease Proximity Fuse Range", "Alt + mouse wheel down: decrease the active proximity-fuse range by 1 metre."],
    { [-1] call OKS_fnc_ProxRound_AdjustRange; },
    {},
    [0xF9, [false, false, true]],
    false
] call CBA_fnc_addKeybind;

// CBA dispatches wheel keybinds but does not pass their return value back to the
// engine's MouseZChanged EH. Consume the two default bindings here, but only while
// they are still configured as Alt + wheel and proximity rounds are active. A player
// who rebinds either action retains normal wheel behaviour on the default input.
["MouseZChanged", {
    params ["", "_wheelDelta"];

    private _action = if (_wheelDelta < 0) then {
        "OKS_ProxRound_IncreaseRange"
    } else {
        "OKS_ProxRound_DecreaseRange"
    };
    private _defaultKey = if (_wheelDelta < 0) then { 0xF8 } else { 0xF9 };
    private _binding = ["GOL Custom Controls", _action] call CBA_fnc_getKeybind;
    private _usesDefaultBinding = [_defaultKey, [false, false, true]] in (_binding param [8, []]);

    private _vehicle = vehicle player;
    _usesDefaultBinding &&
    {_vehicle != player} &&
    {gunner _vehicle == player} &&
    {_vehicle getVariable ["OKS_ProxRound_Capable", false]} &&
    {_vehicle getVariable ["OKS_ProxRound_Active", false]}
}] call CBA_fnc_addDisplayHandler;

// GetInMan fires on the local player's machine whenever they board any vehicle.
// CBA_fnc_addPlayerEventHandler re-attaches automatically after respawn.
["GetInMan", {
    params ["_unit", "_role", "_vehicle", "_turret"];

    // Static weapons (M6 mortar etc.) are never proximity-capable
    if (_vehicle isKindOf "StaticWeapon") exitWith {};

    // A previous vehicle's manually selected range must never carry over.
    _unit setVariable ["OKS_ProxRound_Range", -1];

    // fn_Mechanized already added persistent actions + a server-side FiredEH.
    // Nothing to do here for Mechanized vehicles.
    if (_vehicle getVariable ["OKS_ProxRound_Capable", false]) exitWith {};

    // --- Fallback for non-Mechanized vehicles (singleplayer / hosted only) ---
    // FiredEH added locally only works when the client also holds vehicle locality
    // (i.e. singleplayer or hosted server). On a dedicated server the vehicle is
    // server-local and local _vehicle is false on the client, so FiredHandler exits.
    private _capable = (allTurrets _vehicle) findIf {
        private _mag = "";
        {
            if (_x isEqualType "" && _x != "" && isClass (configFile >> "CfgMagazines" >> _x))
                exitWith { _mag = _x; };
        } forEach (weaponState [_vehicle, _x]);
        if (_mag isEqualTo "") then {
            false
        } else {
            private _ammo = getText (configFile >> "CfgMagazines" >> _mag >> "ammo");
            (getNumber (configFile >> "CfgAmmo" >> _ammo >> "indirectHit") > 0) &&
            (getNumber (configFile >> "CfgAmmo" >> _ammo >> "explosive")   > 0)
        }
    } >= 0;
    if (!_capable) exitWith {};

    // Fired EH — local to this client; fires on whichever machine holds vehicle locality
    private _firedID = _vehicle addEventHandler ["Fired", {_this call OKS_fnc_ProxRound_FiredHandler}];
    _unit setVariable ["OKS_ProxRound_FiredEH_ID", _firedID];
    _unit setVariable ["OKS_ProxRound_LastVeh",    _vehicle];

    // Scroll-wheel toggle actions — condition restricts visibility to the gunner seat
    private _enID = _vehicle addAction [
        "<t color='#FFB300'>Proximity Fuse: </t><img image='\a3\ui_f\data\IGUI\Cfg\Actions\ico_OFF_ca.paa' size='1'/>",
        {
            (_this select 0) setVariable ["OKS_ProxRound_Active", true, true];
            (_this select 1) setVariable ["OKS_ProxRound_Range", -1];
        },
        nil, 1.5, true, true, "",
        "!(vehicle _this getVariable ['OKS_ProxRound_Active', false]) && gunner (vehicle _this) == _this"
    ];
    private _disID = _vehicle addAction [
        "<t color='#66FF66'>Proximity Fuse: </t><img image='\a3\ui_f\data\IGUI\Cfg\Actions\ico_ON_ca.paa' size='1'/>",
        {
            (_this select 0) setVariable ["OKS_ProxRound_Active", false, true];
            (_this select 1) setVariable ["OKS_ProxRound_Range", -1];
        },
        nil, 1.5, true, true, "",
        "(vehicle _this getVariable ['OKS_ProxRound_Active', false]) && gunner (vehicle _this) == _this"
    ];
    _unit setVariable ["OKS_ProxRound_Actions", [_enID, _disID]];

}] call CBA_fnc_addPlayerEventHandler;

// GetOutMan resets the fuse toggle when the gunner leaves.
// For the non-Mechanized fallback path it also removes the locally-added FiredEH and actions.
["GetOutMan", {
    params ["_unit", "_role", "_vehicle", "_turret"];

    // Always reset fuse so the next gunner starts with it off.
    _vehicle setVariable ["OKS_ProxRound_Active", false, true];
    _unit setVariable ["OKS_ProxRound_Range", -1];

    // Fallback cleanup only — guard skips Mechanized vehicles (FiredEH_ID never set).
    private _firedID = _unit getVariable ["OKS_ProxRound_FiredEH_ID", -1];
    if (_firedID < 0) exitWith {};

    _vehicle removeEventHandler ["Fired", _firedID];
    {_vehicle removeAction _x} forEach (_unit getVariable ["OKS_ProxRound_Actions", []]);

    _unit setVariable ["OKS_ProxRound_FiredEH_ID", -1];
    _unit setVariable ["OKS_ProxRound_LastVeh",    objNull];
    _unit setVariable ["OKS_ProxRound_Actions",    []];

}] call CBA_fnc_addPlayerEventHandler;
