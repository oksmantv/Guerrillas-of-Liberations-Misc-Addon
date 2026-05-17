/*
    OKS_fnc_ClearWaypoints

    Signature:
    [group] call OKS_fnc_ClearWaypoints;

    Description:
    Removes all waypoints from the given group.

    Parameters:
    0: GROUP - The group to clear waypoints from.

    Return Value:
    None
*/

params [["_grp", grpNull, [grpNull]]];

if (isNull _grp) exitWith {};

while { (count waypoints _grp) > 0 } do {
    deleteWaypoint [_grp, 0];
};
