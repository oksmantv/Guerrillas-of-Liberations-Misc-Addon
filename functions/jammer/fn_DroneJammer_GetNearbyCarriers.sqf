/*
	OKS_fnc_DroneJammer_GetNearbyCarriers

	Finds all active jammer carriers near a position.
	Used by fn_DroneHuntZone to check if jammer is affecting drone guidance.

	Parameters:
		_position - Position to search from (ATL or ASL)
		_searchRange - Search radius in meters (default: 350)
		_jammerClassName - Classname of jammer item (default: "OKS_DroneJammer")

	Returns:
		Array of units carrying active jammers, or empty array

	Example:
		private _jammers = [getPosATL _drone, 350, "OKS_DroneJammer"] call OKS_fnc_DroneJammer_GetNearbyCarriers;
*/

params [
	["_position", [0,0,0], [[]]],
	["_searchRange", 350, [0]],
	["_jammerClassName", "OKS_DroneJammer", [""]]
];

private _nearbyUnits = _position nearEntities [["CAManBase"], _searchRange];

private _activeJammers = _nearbyUnits select {
	alive _x
	&& {_x getVariable ["OKS_JammerActive", false]}
	&& {_jammerClassName in (items _x + assignedItems _x)}
};

_activeJammers
