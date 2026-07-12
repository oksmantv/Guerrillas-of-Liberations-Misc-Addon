/*
	[_aircraft] call OKS_fnc_AircraftFlareSupportInit;

	Server-side setup that additively injects GOL support flare launcher
	weapons and magazines into aircraft. Existing CM weapons are preserved,
	so native cycle/deploy controls and rearm behavior remain intact.
*/

params [
	["_aircraft", objNull, [objNull]]
];

if (!isServer) exitWith {};
if (isNull _aircraft) exitWith {};
if !(_aircraft isKindOf "Air") exitWith {};

if (_aircraft getVariable ["GOL_CM_CustomLaunchersInstalled", false]) exitWith {};
_aircraft setVariable ["GOL_CM_CustomLaunchersInstalled", true, true];

private _pilotTurret = [-1];
private _customWeapons = ["GOL_CMFlareLauncher_Visible", "GOL_CMFlareLauncher_IR"];
private _customMags = ["GOL_250Rnd_CMFlare_Visible_Mag", "GOL_250Rnd_CMFlare_IR_Mag"];

{
	if !(_x in (_aircraft weaponsTurret _pilotTurret)) then {
		_aircraft addWeaponTurret [_x, _pilotTurret];
	};
} forEach _customWeapons;

{
	if !(_x in (_aircraft magazinesTurret _pilotTurret)) then {
		_aircraft addMagazineTurret [_x, _pilotTurret];
	};
} forEach _customMags;
