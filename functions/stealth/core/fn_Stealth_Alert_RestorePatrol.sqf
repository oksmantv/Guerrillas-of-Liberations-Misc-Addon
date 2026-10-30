/*
    Recreates a simple patrol route after an alert search has finished.
    Returning groups deliberately remain alert: AWARE, NORMAL speed, YELLOW.

    Usage:
    [_group, _patrolSnapshot] call OKS_fnc_Stealth_Alert_RestorePatrol;
*/

params [
    ["_group", grpNull, [grpNull]],
    ["_patrolSnapshot", [], [[]]]
];

if (isNull _group) exitWith { false };

while { count waypoints _group > 0 } do {
    deleteWaypoint [_group, 0];
};

{
    _x params ["_position", "_type", "_completionRadius", "_formation"];

    private _waypoint = _group addWaypoint [_position, _completionRadius];
    _waypoint setWaypointType _type;
    _waypoint setWaypointCompletionRadius _completionRadius;
    _waypoint setWaypointFormation _formation;
    _waypoint setWaypointBehaviour "AWARE";
    _waypoint setWaypointCombatMode "YELLOW";
    _waypoint setWaypointSpeed "NORMAL";
} forEach _patrolSnapshot;

_group setBehaviour "AWARE";
_group setCombatMode "YELLOW";
_group setSpeedMode "NORMAL";

true