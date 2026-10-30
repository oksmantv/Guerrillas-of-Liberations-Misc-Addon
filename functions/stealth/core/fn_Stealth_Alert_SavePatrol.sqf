/*
    Captures the simple waypoint data required to return an alert responder to
    its original patrol route.

    Usage:
    _patrolSnapshot = [_group] call OKS_fnc_Stealth_Alert_SavePatrol;
*/

params [
    ["_group", grpNull, [grpNull]]
];

if (isNull _group) exitWith { [] };

private _snapshot = [];
{
    _snapshot pushBack [
        waypointPosition _x,
        waypointType _x,
        waypointCompletionRadius _x,
        waypointFormation _x
    ];
} forEach waypoints _group;

_snapshot