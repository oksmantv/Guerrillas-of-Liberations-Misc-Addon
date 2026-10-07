/*
	[_varName, _pylonMagazines] remoteExec ["OKS_fnc_Helicopter_SavePylonData", 2];

	Server-side store of a helicopter's current pylon loadout (array of
	magazine classnames indexed like getPylonMagazines), keyed by
	vehicleVarName so it survives ModuleRespawnVehicle_F recreating the
	vehicle object. Session-scoped only - GOL_Heli_PylonLoadouts is reset
	on server restart, not written to disk.
*/

if (!isServer) exitWith {};

params ["_varName", "_pylonMagazines"];

if (_varName == "") exitWith {};

GOL_Heli_PylonLoadouts set [_varName, _pylonMagazines];
