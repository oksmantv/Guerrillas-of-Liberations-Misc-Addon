/*
    [taskId, hvtUnit] spawn OKS_fnc_InterceptHvt_UpdateTrackedTaskPos;
*/
params [
    ["_taskId", "", [""]],
    ["_hvtUnit", objNull, [objNull]]
];

if (_taskId isEqualTo "" || {isNull _hvtUnit}) exitWith {};

while {
    alive _hvtUnit &&
    !(_hvtUnit getVariable ["OKS_InterceptHvt_StopTracking", false]) &&
    !(_hvtUnit getVariable ["OKS_InterceptHvt_TaskDone", false])
} do {
    [_taskId, getPosATL _hvtUnit, false] call BIS_fnc_taskSetDestination;
    sleep 2;
};