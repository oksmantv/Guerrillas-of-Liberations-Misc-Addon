/*
    Function: OKS_fnc_RescueSurvivor_ExtractMonitor

    Description:
    Monitors a stabilized casualty's position relative to the extraction site.
    Resolves the extraction sub-task when the casualty is within range (default 50m),
    or fails it if the casualty dies before reaching the site.

    The casualty can be moved by any means — carried, driven, or on foot. Only
    position distance is checked.

    Spawned internally by OKS_fnc_RescueSurvivorTask.

    Parameters:
    0: _casualty    (OBJECT)  — The unit being monitored.
    1: _extractPos  (ARRAY)   — Destination position [x, y, z].
    2: _taskId      (STRING)  — The extraction sub-task ID to resolve.
    3: _range       (NUMBER)  — Acceptance radius in metres. Default: 50.

    Returns: Nothing
*/

params [
    ["_casualty",   objNull,   [objNull]],
    ["_extractPos", [0, 0, 0], [[]]],
    ["_taskId",     "",        [""]],
    ["_range",      50,        [0]]
];

if (isNull _casualty || _taskId isEqualTo "") exitWith {
    ["[RescueSurvivor_ExtractMonitor] Called with null casualty or empty task ID."] call OKS_fnc_LogDebug;
};

waitUntil {
    sleep 5;
    _casualty distance _extractPos < _range || !alive _casualty
};

if (alive _casualty && _casualty distance _extractPos < _range) then {
    [_taskId, "SUCCEEDED"] call BIS_fnc_taskSetState;
} else {
    [_taskId, "FAILED"] call BIS_fnc_taskSetState;
};
