/*
    OKS_fnc_Convoy_DeleteAllWaypoints
    Deletes all waypoints for the given group.
    Usage: [group] call OKS_fnc_Convoy_DeleteAllWaypoints;
*/
params ["_Group"];
if (!isNull _Group) then {
    private _wpCount = count waypoints _Group;
    for [{_i = _wpCount - 1}, {_i >= 0}, {_i = _i - 1}] do {
        deleteWaypoint [_Group, _i];
    };
}