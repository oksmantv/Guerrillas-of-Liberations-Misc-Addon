/*
	[_Helicopter] remoteExec ["OKS_fnc_Helicopter_PylonEH", 0];

	Adds a PylonChanged handler to a helicopter so its current pylon loadout
	(magazine classname per pylon index, via getPylonMagazines) gets pushed
	to the server for persistence across ModuleRespawnVehicle_F respawns.

	The handler is added on every machine (the vehicle can change locality),
	but it only reports from the machine the vehicle is currently local to,
	and only when the loadout differs from the last one sent. Without these
	guards every client forwarded every event to the server (observed: ~110k
	remoteExec calls in 3 hours).
*/

params ["_Helicopter"];

if (isNull _Helicopter) exitWith {};

// Never stack a second handler on the same object on this machine.
if (_Helicopter getVariable ["OKS_PylonEH_Added", false]) exitWith {};
_Helicopter setVariable ["OKS_PylonEH_Added", true];

_Helicopter addEventHandler ["PylonChanged", {
	params ["_vehicle"];

	if (!local _vehicle) exitWith {};

	private _varName = vehicleVarName _vehicle;
	if (_varName == "") exitWith {};

	private _pylons = getPylonMagazines _vehicle;
	if (_pylons isEqualTo (_vehicle getVariable ["OKS_PylonEH_LastSent", []])) exitWith {};
	_vehicle setVariable ["OKS_PylonEH_LastSent", _pylons];

	if (isServer) then {
		[_varName, _pylons] call OKS_fnc_Helicopter_SavePylonData;
	} else {
		[_varName, _pylons] remoteExec ["OKS_fnc_Helicopter_SavePylonData", 2];
	};
}];
