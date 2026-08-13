// [_vehicle, _targetType] call OKS_fnc_M230_SetPylon;
// Executes on the machine where _vehicle is local (remoteExec'd from OKS_fnc_M230_SwapAmmo).
//
// Ammo tracking relies on per-class Fired EH counters (GOL_M230_<magClass>_Fired)
// incremented by fn_HeliActions.sqf. Remaining = configCount - firedCount per class.
// This avoids `ammo "weapon"` which returns the TOTAL across all pylons sharing the
// same pylonWeapon — not usable for per-pylon tracking.
//
// Rearm detection: if the actual vehicle total exceeds what fired counters predict,
// the vehicle was rearmed externally → reset the current-type fired counters.

params ["_vehicle", "_targetType"];

private _HE_mags = ["GOL_PylonWeapon_M230_HE", "GOL_PylonWeapon_M230_HE_L"];
private _AP_mags = ["GOL_PylonWeapon_M230_AP", "GOL_PylonWeapon_M230_AP_L"];

private _currentType = if (_targetType == "AP") then {"HE"} else {"AP"};
private _currentMags = if (_currentType == "HE") then {_HE_mags} else {_AP_mags};
private _pilot = driver _vehicle;

// Find all pylon indices (0-based) currently loaded with the currentType
private _pylons = getPylonMagazines _vehicle;
private _matchingIndices = [];
{ if (_x in _currentMags) then { _matchingIndices pushBack _forEachIndex; }; } forEach _pylons;

diag_log format ["[M230] === SWAP TRIGGERED: %1 -> %2 ===", _currentType, _targetType];
diag_log format ["[M230] Full pylon list: %1", _pylons];
diag_log format ["[M230] Matching indices (0-based): %1", _matchingIndices];
diag_log format ["[M230] ammo 'weapon' reported by engine (combined total): %1", _vehicle ammo "GOL_weapon_M230_ChainGun"];

// Log current fired counters for all 4 M230 mag classes
{
	private _f = _vehicle getVariable [format ["GOL_M230_%1_Fired", _x], 0];
	diag_log format ["[M230] Fired counter | %1 = %2 rounds fired", _x, _f];
} forEach (_HE_mags + _AP_mags);

if (_matchingIndices isEqualTo []) exitWith {
	diag_log "[M230] ERROR: No M230 pylons found — swap aborted.";
	["M230: No M230 pylon found — swap aborted."] remoteExec ["systemChat", _pilot];
};

// Rearm detection: compare actual total on vehicle with what fired counters predict.
// `ammo "weapon"` returns the combined total across all pylons sharing the same pylonWeapon.
// If actual > expected, a rearm/resupply occurred → reset current-type fired counters.
private _expectedCurrent = 0;
private _currentClassList = [];
{
	private _magClass = _pylons select _x;
	private _maxC = getNumber (configFile >> "CfgMagazines" >> _magClass >> "count");
	private _fired = _vehicle getVariable [format ["GOL_M230_%1_Fired", _magClass], 0];
	_expectedCurrent = _expectedCurrent + ((_maxC - _fired) max 0);
	_currentClassList pushBackUnique _magClass;
} forEach _matchingIndices;

private _actualCurrent = _vehicle ammo "GOL_weapon_M230_ChainGun";
diag_log format ["[M230] Rearm check | expected=%1  actual=%2  rearmed=%3", _expectedCurrent, _actualCurrent, str (_actualCurrent > _expectedCurrent)];
if (_actualCurrent > _expectedCurrent) then {
	// Rearmed — reset fired counters for current-type classes only
	{ _vehicle setVariable [format ["GOL_M230_%1_Fired", _x], 0, true]; } forEach _currentClassList;
	diag_log format ["[M230] Rearm detected — reset fired counters for: %1", _currentClassList];
};

// Build swap data: for each pylon, compute targetType remaining from fired counters.
// Preserves pod size: HE <-> AP, HE_L <-> AP_L.
private _targetTotal = 0;
private _swapData = [];
{
	private _pylonIdx = _x;
	private _pylonMag = _pylons select _pylonIdx;
	private _isLarge = _pylonMag in ["GOL_PylonWeapon_M230_HE_L", "GOL_PylonWeapon_M230_AP_L"];

	private _thisMag = if (_targetType == "HE") then {
		if (_isLarge) then {"GOL_PylonWeapon_M230_HE_L"} else {"GOL_PylonWeapon_M230_HE"}
	} else {
		if (_isLarge) then {"GOL_PylonWeapon_M230_AP_L"} else {"GOL_PylonWeapon_M230_AP"}
	};

	private _targetMax = getNumber (configFile >> "CfgMagazines" >> _thisMag >> "count");
	private _firedCount = _vehicle getVariable [format ["GOL_M230_%1_Fired", _thisMag], 0];
	private _remaining = (_targetMax - _firedCount) max 0;
	_targetTotal = _targetTotal + _remaining;
	_swapData pushBack [_pylonIdx + 1, _thisMag, _remaining]; // index 1-based for setPylonLoadOut

	diag_log format ["[M230] Pylon %1 | loading: %2 | max=%3 fired=%4 remaining=%5", _pylonIdx, _thisMag, _targetMax, _firedCount, _remaining];
} forEach _matchingIndices;

diag_log format ["[M230] Target total to restore: %1", _targetTotal];

if (_targetTotal <= 0) exitWith {
	diag_log format ["[M230] EXIT: target type %1 has 0 rounds remaining.", _targetType];
	["M230: No rounds remaining for that ammo type."] remoteExec ["systemChat", _pilot];
};

// Recompute summary totals for both types from fired counters (broadcast for action conditions).
// These are the totals used by addAction conditions in fn_HeliActions.sqf.
private _HE_Total = 0;
{ private _maxC = getNumber (configFile >> "CfgMagazines" >> _x >> "count");
  _HE_Total = _HE_Total + ((_maxC - (_vehicle getVariable [format ["GOL_M230_%1_Fired", _x], 0])) max 0);
} forEach _HE_mags;
private _AP_Total = 0;
{ private _maxC = getNumber (configFile >> "CfgMagazines" >> _x >> "count");
  _AP_Total = _AP_Total + ((_maxC - (_vehicle getVariable [format ["GOL_M230_%1_Fired", _x], 0])) max 0);
} forEach _AP_mags;
_vehicle setVariable ["GOL_M230_HE_Total", _HE_Total, true];
_vehicle setVariable ["GOL_M230_AP_Total", _AP_Total, true];

diag_log format ["[M230] Summary totals | HE_Total=%1  AP_Total=%2", _HE_Total, _AP_Total];

// DEBUG hint — remove once confirmed working
[format ["M230 swap to %1: data=%2 | HE=%3 AP=%4", _targetType, _swapData, _HE_Total, _AP_Total]] remoteExec ["hint", _pilot];

// Apply: load pylons at config-full count, then reduce each to the saved remaining count.
// setMagazineTurretAmmo targets each class independently (HE and HE_L are different classes).
// Turret [-1] = driver/pilot — pylon weapons reside here, not in gunner turret [0].
diag_log "[M230] Applying setPylonLoadOut (addAmmo=true)...";
{ _x params ["_idx", "_mag"]; _vehicle setPylonLoadOut [_idx, _mag, true]; } forEach _swapData;

diag_log "[M230] Applying setMagazineTurretAmmo [-1]...";
{ _x params ["_idx", "_mag", "_count"];
  diag_log format ["[M230]   setMagazineTurretAmmo [%1, %2, [-1]]", _mag, _count];
  _vehicle setMagazineTurretAmmo [_mag, _count, [-1]];
} forEach _swapData;

private _engineAmmoOnePylon = _vehicle ammo "GOL_weapon_M230_ChainGun";
// NOTE: ammo "weapon" returns ONE active pylon's count, not the combined total.
// With two pylons both set to X each, ammo "weapon" = X (not 2X).
// Expected per-pylon = _targetTotal / count _swapData.
private _expectedPerPylon = _targetTotal / (count _swapData);
diag_log format ["[M230] Post-apply: ammo 'weapon' (one pylon)=%1  expected per pylon=%2  total expected=%3", _engineAmmoOnePylon, _expectedPerPylon, _targetTotal];
diag_log "[M230] === SWAP COMPLETE ===";
