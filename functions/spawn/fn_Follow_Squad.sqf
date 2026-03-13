/*
    Function: OKS_fnc_Follow_Squad

    Description:
        Makes a vehicle crew group follow an infantry screen group by monitoring distance.
        When the infantry moves more than 50m away from the vehicle, a HOLD waypoint is
        placed at the infantry leader's position so the vehicle advances. Once the infantry
        moves away from that waypoint, it is deleted and a new one is placed. This creates
        a leapfrog pattern where the vehicle stays in formation with its dismounted screen.
        The loop continues while both groups have alive members and the vehicle can move.
        Typically called internally by OKS_fnc_Mechanized_Spawn after dismount.

    Parameters:
        0: _VehicleCrew    - GROUP  - Crew group of the vehicle
        1: _InfantryScreen - GROUP  - Infantry group screening ahead of the vehicle
        2: _Vehicle        - OBJECT - Vehicle that follows the infantry screen

    Returns:
        Nothing

    Example:
        [_crewGroup, _infantryGroup, _apc] spawn OKS_fnc_Follow_Squad;
*/

params ["_VehicleCrew","_InfantryScreen","_Vehicle"];
Private ["_WP"];
while { {Alive _X} count units _VehicleCrew > 0 && canMove _Vehicle && {Alive _X} count units _InfantryScreen > 0} do {
	
	if({_X distance _Vehicle < 50} count units _InfantryScreen == 0) then {
		_WP = _VehicleCrew addWaypoint [getPos (leader _InfantryScreen),10];
		_WP setWaypointType "HOLD";
	};
	
	if(!isNil "_WP") then {
		waitUntil { sleep 5; {_X distance (waypointPosition _WP) < 50} count units _InfantryScreen == 0};
		deleteWaypoint _WP;
	} else {
		sleep 5;
	};	
};