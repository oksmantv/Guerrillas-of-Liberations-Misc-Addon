/*
	[_Helicopter] remoteExec ["OKS_fnc_Helicopter_PylonEH", 0];

	Adds a PylonChanged handler to a helicopter so its current pylon loadout
	(magazine classname per pylon index, via getPylonMagazines) gets pushed
	to the server for persistence across ModuleRespawnVehicle_F respawns.

	PylonChanged only fires on the machine the vehicle is local to, so this
	must be (re)added on every machine each time the helicopter (re)spawns -
	hence remoteExec target 0 from fn_Helicopter.sqf.
*/

params ["_Helicopter"];

_Helicopter addEventHandler ["PylonChanged", {
	params ["_vehicle"];

	private _varName = vehicleVarName _vehicle;
	if (_varName == "") exitWith {};

	[_varName, getPylonMagazines _vehicle] remoteExec ["OKS_fnc_Helicopter_SavePylonData", 2];
}];
