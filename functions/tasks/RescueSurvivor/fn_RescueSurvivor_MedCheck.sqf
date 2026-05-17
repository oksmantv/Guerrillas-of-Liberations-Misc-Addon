/*
    Function: OKS_fnc_RescueSurvivor_MedCheck

    Description:
    Monitors a casualty's ACE medical state and resolves the stabilize sub-task
    when the casualty is fully stabilized (cardiac output restored, blood loss
    stopped, no tourniquets remaining). If the casualty dies the task is failed.

    Spawned internally by OKS_fnc_RescueSurvivorTask.

    Parameters:
    0: _casualty (OBJECT)  — The unit being monitored.
    1: _taskId   (STRING)  — The stabilize sub-task ID to resolve.

    Returns: Nothing
*/

params [
    ["_casualty", objNull, [objNull]],
    ["_taskId",   "",      [""]]
];

if (isNull _casualty || _taskId isEqualTo "") exitWith {
    ["[RescueSurvivor_MedCheck] Called with null casualty or empty task ID."] call OKS_fnc_LogDebug;
};

// Wait for ACE stabilization or death.
// Stabilized = cardiac output restored + no active blood loss + no remaining tourniquets.
waitUntil {
    sleep 2;
    (
        [_casualty] call ace_medical_status_fnc_getCardiacOutput > 0.07
        && [_casualty] call ace_medical_status_fnc_getBloodLoss < 0.001
        && { [_casualty, _x] call ace_medical_treatment_fnc_hasTourniquetAppliedTo } count
           ["LeftLeg", "RightLeg", "LeftArm", "RightArm"] == 0
    )
    || !alive _casualty
};

if (
    alive _casualty
    && [_casualty] call ace_medical_status_fnc_getCardiacOutput > 0.07
    && [_casualty] call ace_medical_status_fnc_getBloodLoss < 0.001
) then {
    [_taskId, "SUCCEEDED"] call BIS_fnc_taskSetState;
} else {
    [_taskId, "FAILED"] call BIS_fnc_taskSetState;
};
