/*
    Drops all weapons (primary, handgun, launcher) with their attachments and loaded magazines/items.
    Usage: [unit] spawn OKS_fnc_ThrowWeaponsOnGround;
*/

params ["_unit"];
if (isNull _unit) exitWith {};

private _direction = getDir _unit;
private _dropPosition = _unit getPos [0.5, _direction];
private _dropAltitude = getPosATL _unit select 2;

// Only execute on server for MP safety
if (!isServer) exitWith {
    [_unit] remoteExec ["OKS_fnc_ThrowWeaponsOnGround", 2];
};

// Wait for reload animation to finish (optional)
waitUntil {
    private _anim = animationState _unit;
    !(_anim find "reload" > -1)
};

// Create the ground weapon holder at the drop position
private _groundHolder = createVehicle ["GroundWeaponHolder", [0,0,0], [], 0, "NONE"];
_groundHolder setPosATL [_dropPosition select 0, _dropPosition select 1, _dropAltitude];

// Assume _unit and _groundHolder are defined and valid
// --- Primary Weapon: Drop with attachments (no magazine, no items)
private _primaryWeapon = primaryWeapon _unit;
if (_primaryWeapon != "") then {
    private _attachments = _unit weaponAccessories _primaryWeapon;
    private _magazine = selectRandom ([_primaryWeapon] call BIS_fnc_compatibleMagazines);
    _attachments params ["_silencer","_pointer","_optics","_bipod"];
    _groundHolder addWeaponWithAttachmentsCargoGlobal [[_primaryWeapon, _silencer, _pointer, _optics, [_magazine, random 30], [], ""], 1];
};

// --- Handgun: Drop with no attachments
private _handgunWeapon = handgunWeapon _unit;
if (_handgunWeapon != "") then {
    private _attachments = _unit weaponAccessories _handgunWeapon;
    private _magazine = selectRandom ([_handgunWeapon] call BIS_fnc_compatibleMagazines);
    _attachments params ["_silencer","_pointer","_optics","_bipod"];
    _groundHolder addWeaponWithAttachmentsCargoGlobal [[_handgunWeapon, _silencer, _pointer, _optics, [_magazine, random 30], [], ""], 1];
};

// --- Launcher: Drop with no attachments
private _launcherWeapon = secondaryWeapon _unit;
if (_launcherWeapon != "") then {
    private _attachments = _unit weaponAccessories _launcherWeapon;
    private _magazine = selectRandom ([_launcherWeapon] call BIS_fnc_compatibleMagazines);
    _attachments params ["_silencer","_pointer","_optics","_bipod"];
    _groundHolder addWeaponWithAttachmentsCargoGlobal [[_launcherWeapon, _silencer, _pointer, _optics, [_magazine, 1], [], ""], 1];
};

// Remove all weapons, magazines, and items from the unit
removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;

// Debug message
private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];
if(_surrenderDebug) then {
    format ["[DEBUG] %1 dropped all weapons and gear.", name _unit]  remoteExec ["systemChat",0];
};