// [_target, _caller, _id, _args] call OKS_fnc_M230_SwapAmmo;
// Called by addAction on the pilot's machine.
// _args: [targetMag, currentMag]
// Saves current round count, then swaps the M230 pylon to the target ammo type
// while restoring the previously saved count for that type.

params ["_target", "_caller", "_id", "_args"];
_args params ["_targetMag", "_currentMag"];

// Locate the pylon that currently has the active magazine (0-based index)
private _pylons = getPylonMagazines _target;
private _currentIdx = _pylons find _currentMag;

if (_currentIdx == -1) exitWith {
	systemChat "M230: Could not locate pylon — swap aborted.";
};

// Persist current round count before unloading
private _currentAmmoKey = format ["GOL_M230_%1_Ammo", if (_currentMag == "GOL_PylonWeapon_M230_HE") then {"HE"} else {"AP"}];
private _targetAmmoKey  = format ["GOL_M230_%1_Ammo", if (_targetMag  == "GOL_PylonWeapon_M230_HE") then {"HE"} else {"AP"}];

private _currentAmmo = _target ammo "GOL_weapon_M230_ChainGun";

// Rearm detection: if the live pylon is at max capacity, ACE Rearm (or equivalent)
// has replenished this vehicle — reset the stored count for the inactive type as well
// so the pilot receives a full belt on next swap rather than a stale reduced count.
private _maxAmmo = getNumber (configFile >> "CfgMagazines" >> _currentMag >> "count");
if (_currentAmmo >= _maxAmmo) then {
	_target setVariable [_targetAmmoKey, _maxAmmo, true];
};

_target setVariable [_currentAmmoKey, _currentAmmo, true];

// Retrieve saved count for target type; 300 = never loaded before (full belt)
private _targetAmmo = _target getVariable [_targetAmmoKey, 300];

if (_targetAmmo <= 0) exitWith {
	systemChat "M230: No rounds remaining for that ammo type.";
};

// Execute setPylonLoadOut on the machine where the vehicle is local.
// Index is 1-based. addAmmo=false — we manage ammo counts manually via variables.
[_target, _currentIdx + 1, _targetMag, _targetAmmo] remoteExec ["OKS_fnc_M230_SetPylon", _target];


