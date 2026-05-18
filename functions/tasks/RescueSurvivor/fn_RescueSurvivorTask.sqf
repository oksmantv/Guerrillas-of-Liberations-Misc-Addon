/*
    Function: OKS_fnc_RescueSurvivorTask

    Description:
    Progressive single-casualty rescue task with three phases:
      Phase 1 — "Find [name]": task created with no position if showTaskPosition=false.
      Phase 2 — "Rescue [name]": created when any player is within 50m. Position is
        revealed at this point regardless of showTaskPosition. ACE medical damage applied.
      Phase 3 — "Extract [name]": created after rescue, only if _extractionSite is set.
        If no extraction site, the main task completes after rescue.

    Two variables are set globally on the casualty unit at resolution:
      OKS_IsRescued (BOOL true) — set when the full chain succeeds.
      OKS_IsDead    (BOOL true) — set when the task fails at any phase.
    Both are nil while in progress, making waitUntil hooks unambiguous.

    Parameters:
    0: _casualty (OBJECT|ARRAY)
        Pre-placed unit, OR [position, classname] to spawn automatically.
    1: _severity (STRING)
        Medical severity. One of: "lot" / "large" / "fatal".
        Passed directly to OKS_fnc_MedicalDamage.
    2: _taskData (ARRAY)
        [showTaskPosition (BOOL), taskParentId (STRING)]
        showTaskPosition=true:  casualty marker and map destination shown from the start.
        showTaskPosition=false: no position revealed until a player is within 50m.
        taskParentId: parent task ID string, or "" for standalone.
    3: _extractionSite (NIL|ARRAY|OBJECT)
        Optional. If defined, adds an Extract phase after rescue.
        Casualty must reach within 50m of this position to complete.
    4: _guardData (NIL|ARRAY)
        Optional. [guardCount (NUMBER), guardSide (SIDE)] — spawns an enemy guard
        group near the casualty using OKS_fnc_Task_Settings classnames.

    Returns: Nothing — hook outcomes via waitUntil on unit variables.

    Examples:
    // Pre-placed unit, fatal severity, position hidden, no extract, no guards
    [casualty_1, "fatal", [false, ""], nil, nil] spawn OKS_fnc_RescueSurvivorTask;

    // Hook: wait for resolution then branch
    waitUntil { sleep 1;
        casualty_1 getVariable ["OKS_IsRescued", false]
        || casualty_1 getVariable ["OKS_IsDead",    false]
    };
    if (casualty_1 getVariable ["OKS_IsRescued", false]) then {
        hint "Survivor rescued!";
    } else {
        hint "Survivor did not make it.";
    };

    // Spawned unit, large severity, extract to base, 4 independent guards, nested task
    [[getPos spawn_1, "B_Soldier_F"], "large", [false, "MainTask"], getPos extract_1, [4, independent]] spawn OKS_fnc_RescueSurvivorTask;
*/

if (!isServer) exitWith { objNull };

params [
    ["_casualty", objNull, [objNull, []]],
    ["_severity", "lot", [""]],
    ["_taskData", [true, ""], [[]]],
    ["_extractionSite", nil],
    ["_guardData", nil]
];

_taskData params [
    ["_showTaskPosition", true, [false]],
    ["_taskParent", "", [""]]
];

private _debug = missionNamespace getVariable ["OKS_RescueSurvivor_Debug", false];

// -------------------------------------------------------------------------
// 1. Resolve casualty unit
// -------------------------------------------------------------------------
private _casualtyUnit = objNull;

if (_casualty isEqualType objNull) then {
    if (isNull _casualty || !(_casualty isKindOf "Man")) exitWith {
        if (_debug) then { "[RescueSurvivor] Invalid pre-placed unit — must be a Man." call OKS_fnc_LogDebug };
        objNull
    };
    _casualtyUnit = _casualty;
} else {
    // ARRAY: [position, classname]
    if (count _casualty < 2) exitWith {
        if (_debug) then { "[RescueSurvivor] Spawn array must be [position, classname]." call OKS_fnc_LogDebug };
        objNull
    };

    private _spawnPos   = _casualty param [0, [0,0,0], [[]]];
    private _classname  = _casualty param [1, "", [""]];

    if (_classname isEqualTo "") exitWith {
        if (_debug) then { "[RescueSurvivor] Empty classname in spawn array." call OKS_fnc_LogDebug };
        objNull
    };

    private _spawnGroup = createGroup [west, true];
    _spawnGroup setVariable ["acex_headless_blacklist", true, true];
    _casualtyUnit = _spawnGroup createUnit [_classname, _spawnPos, [], 0, "NONE"];
    _casualtyUnit setPosATL (getPosATL _spawnPos);
    _casualtyUnit setDir (random 360);
    _casualtyUnit setRank "PRIVATE";
};

if (isNull _casualtyUnit) exitWith {
    if (_debug) then { "[RescueSurvivor] Casualty unit resolved to null — aborting." call OKS_fnc_LogDebug };
    objNull
};

// -------------------------------------------------------------------------
// 2. Disable AI / set prone
// -------------------------------------------------------------------------
_casualtyUnit disableAI "MOVE";
_casualtyUnit disableAI "AUTOTARGET";
_casualtyUnit disableAI "TARGET";
_casualtyUnit disableAI "FSM";
_casualtyUnit disableAI "RADIOPROTOCOL";
_casualtyUnit setCaptive true;
_casualtyUnit setUnitPos "DOWN";

if (_debug) then {
    format ["[RescueSurvivor] Casualty set up: %1 at %2", _casualtyUnit, getPosATL _casualtyUnit] call OKS_fnc_LogDebug;
};

// -------------------------------------------------------------------------
// 3. Casualty name
// -------------------------------------------------------------------------
private _casualtyName = name _casualtyUnit;

// -------------------------------------------------------------------------
// 4. Build task IDs
// -------------------------------------------------------------------------
private _uid = str round(random 99999);
private _mainTaskId    = format ["OKS_RESCUETASK_%1",         _uid];
private _rescueTaskId  = format ["OKS_RESCUETASK_%1_RESCUE",  _uid];
private _extractTaskId = format ["OKS_RESCUETASK_%1_EXTRACT", _uid];

// -------------------------------------------------------------------------
// 5. Severity tier label and stabilize description
// -------------------------------------------------------------------------
private _tierLabel = switch (toLower _severity) do {
    case "lot":   { "Tier 2" };
    case "large": { "Tier 2 (critical)" };
    case "fatal": { "Tier 1" };
    default       { "Unknown" };
};

private _severityText = switch (toLower _severity) do {
    case "lot": {
        "The casualty has lost a lot of blood and requires medical attention. If not treated soon he may go into cardiac arrest."
    };
    case "large": {
        "The casualty has lost a large amount of blood and requires medical attention. He will likely go into cardiac arrest if not stabilized soon."
    };
    case "fatal": {
        "The casualty has lost a fatal amount of blood and is in cardiac arrest. Immediate medical intervention is required — time is extremely short."
    };
    default {
        "The status of the casualty is unclear. Assess and treat accordingly."
    };
};

// -------------------------------------------------------------------------
// 6. Resolve extraction
// -------------------------------------------------------------------------
private _hasExtraction = false;
private _extractPos = [0, 0, 0];
if (!isNil "_extractionSite") then {
    if (_extractionSite isEqualType objNull) then {
        if (!isNull _extractionSite) then {
            _hasExtraction = true;
            _extractPos = getPosATL _extractionSite;
        };
    } else {
        if (_extractionSite isEqualType [] && { count _extractionSite >= 2 }) then {
            _hasExtraction = true;
            _extractPos = _extractionSite;
        };
    };
};

// -------------------------------------------------------------------------
// 7. Build main task description ("Find" phase — no position knowledge yet)
// -------------------------------------------------------------------------
private _mainDesc = format [
    "A survivor has been reported wounded in the area. Locate %1 and provide assistance.",
    _casualtyName
];

// -------------------------------------------------------------------------
// 8. Create main task — "Find [name]"
// -------------------------------------------------------------------------
private _mainTaskArray = if (_taskParent != "") then {
    [_mainTaskId, _taskParent]
} else {
    [_mainTaskId]
};

[true, _mainTaskArray,
    [_mainDesc, format ["Find %1", _casualtyName], _casualtyName],
    objNull, "CREATED", -1, false, "heal", false
] call BIS_fnc_taskCreate;

if (_debug) then {
    format ["[RescueSurvivor] Main task created (Find phase): %1", _mainTaskId] call OKS_fnc_LogDebug;
};

// -------------------------------------------------------------------------
// 9. Optional guard group
// -------------------------------------------------------------------------
if (!isNil "_guardData" && { _guardData isEqualType [] } && { count _guardData >= 2 }) then {
    _guardData params [
        ["_guardCount", 4, [0]],
        ["_guardSide",  east, [sideUnknown]]
    ];
    _guardCount = _guardCount max 1;

    private _settings = [_guardSide] call OKS_fnc_Task_Settings;
    _settings params [["_gLeaders", []], ["_gUnits", []]];

    private _guardGroup = createGroup [_guardSide, true];
    private _guardPos = getPosATL _casualtyUnit;

    // Leader
    private _leader = _guardGroup createUnit [
        (_gLeaders call BIS_fnc_selectRandom),
        _guardPos getPos [5 + random 5, random 360],
        [], 0, "NONE"
    ];
    _leader setRank "SERGEANT";

    // Remaining guards
    for "_i" from 2 to _guardCount do {
        private _guard = _guardGroup createUnit [
            (_gUnits call BIS_fnc_selectRandom),
            _guardPos getPos [5 + random 10, random 360],
            [], 0, "NONE"
        ];
        _guard setRank "PRIVATE";
    };

    // GUARD waypoint at casualty position — start stealthy, return fire only
    private _wp = _guardGroup addWaypoint [_guardPos, 15];
    _wp setWaypointType "GUARD";
    _wp setWaypointBehaviour "STEALTH";
    _wp setWaypointCombatMode "GREEN";

    _guardGroup setBehaviourStrong "STEALTH";
    _guardGroup setCombatMode "GREEN";

    // Switch to COMBAT when any player closes within 100m
    [_guardGroup, _casualtyUnit] spawn {
        params ["_grp", "_unit"];
        waitUntil {
            sleep 5;
            { _x distance _unit < 100 } count allPlayers >= 1 || !alive _unit
        };
        if (alive _unit) then {
            _grp setBehaviourStrong "COMBAT";
            _grp setCombatMode "RED";
        };
    };

    if (_debug) then {
        format ["[RescueSurvivor] Guard group spawned: %1 units, side %2", _guardCount, _guardSide] call OKS_fnc_LogDebug;
    };
};

// -------------------------------------------------------------------------
// 10. Wait for proximity trigger (50m)
// -------------------------------------------------------------------------
if (_debug) then { "[RescueSurvivor] Waiting for player proximity (50m)..." call OKS_fnc_LogDebug };

waitUntil {
    sleep 5;
    { _x distance _casualtyUnit < 50 } count allPlayers >= 1 || !alive _casualtyUnit
};

if (!alive _casualtyUnit) then {
    [_mainTaskId, "FAILED"] call BIS_fnc_taskSetState;
    _casualtyUnit setVariable ["OKS_IsDead", true, true];
    if (_debug) then { "[RescueSurvivor] Casualty died before proximity trigger — task FAILED." call OKS_fnc_LogDebug };
} else {

// -------------------------------------------------------------------------
// 11. Proximity triggered — reveal position, activate damage, create Rescue subtask
// -------------------------------------------------------------------------
if (_debug) then {
    format ["[RescueSurvivor] Proximity triggered. Applying medical damage: %1", _severity] call OKS_fnc_LogDebug;
};

[_casualtyUnit, _severity] spawn OKS_fnc_MedicalDamage;
_casualtyUnit setCaptive false;

// -------------------------------------------------------------------------
// 12. Create Rescue sub-task
// -------------------------------------------------------------------------
private _rescueDesc = format [
    "%1 has been located and requires immediate medical attention. He is a %2 casualty. %3",
    _casualtyName, _tierLabel, _severityText
];

[true, [_rescueTaskId, _mainTaskId],
    [_rescueDesc, format ["Rescue %1", _casualtyName], _casualtyName],
    _casualtyUnit, "ASSIGNED", -1, false, "heal", true
] call BIS_fnc_taskCreate;

[_rescueTaskId, getPosATL _casualtyUnit, true] call BIS_fnc_taskSetDestination;

[_casualtyUnit, _rescueTaskId] spawn OKS_fnc_RescueSurvivor_MedCheck;

if (_debug) then {
    format ["[RescueSurvivor] Rescue task created: %1", _rescueTaskId] call OKS_fnc_LogDebug;
};

// -------------------------------------------------------------------------
// 13. Wait for rescue result
// -------------------------------------------------------------------------
waitUntil {
    sleep 5;
    _rescueTaskId call BIS_fnc_taskState in ["SUCCEEDED", "FAILED"] || !alive _casualtyUnit
};

if (!alive _casualtyUnit || _rescueTaskId call BIS_fnc_taskState isEqualTo "FAILED") then {
    if (_rescueTaskId call BIS_fnc_taskState isNotEqualTo "FAILED") then {
        [_rescueTaskId, "FAILED"] call BIS_fnc_taskSetState;
    };
    [_mainTaskId, "FAILED"] call BIS_fnc_taskSetState;
    _casualtyUnit setVariable ["OKS_IsDead", true, true];
    if (_debug) then { "[RescueSurvivor] Casualty not rescued — task FAILED." call OKS_fnc_LogDebug };
} else {

// -------------------------------------------------------------------------
// 14. Extraction phase (optional) or complete main task
// -------------------------------------------------------------------------
if (_hasExtraction) then {
    [true, [_extractTaskId, _mainTaskId],
        [format ["Move %1 to the designated extraction point.", _casualtyName],
         format ["Extract %1", _casualtyName],
         _casualtyName],
        objNull, "ASSIGNED", -1, false, "heal", true
    ] call BIS_fnc_taskCreate;

    [_extractTaskId, _extractPos, true] call BIS_fnc_taskSetDestination;

    [_casualtyUnit, _extractPos, _extractTaskId] spawn OKS_fnc_RescueSurvivor_ExtractMonitor;

    if (_debug) then {
        format ["[RescueSurvivor] Extract task created: %1", _extractTaskId] call OKS_fnc_LogDebug;
    };

    waitUntil {
        sleep 5;
        _extractTaskId call BIS_fnc_taskState in ["SUCCEEDED", "FAILED"] || !alive _casualtyUnit
    };

    if (!alive _casualtyUnit || _extractTaskId call BIS_fnc_taskState isEqualTo "FAILED") then {
        if (_extractTaskId call BIS_fnc_taskState isNotEqualTo "FAILED") then {
            [_extractTaskId, "FAILED"] call BIS_fnc_taskSetState;
        };
        [_mainTaskId, "FAILED"] call BIS_fnc_taskSetState;
        _casualtyUnit setVariable ["OKS_IsDead", true, true];
        if (_debug) then { "[RescueSurvivor] Extraction failed — task FAILED." call OKS_fnc_LogDebug };
    } else {
        [_mainTaskId, "SUCCEEDED"] call BIS_fnc_taskSetState;
        _casualtyUnit setVariable ["OKS_IsRescued", true, true];
        if (alive _casualtyUnit) then { _casualtyUnit setUnitPos "UP" };
        if (_debug) then { "[RescueSurvivor] Extraction complete — task SUCCEEDED." call OKS_fnc_LogDebug };
    };

} else {
    // No extraction — stabilization is the final objective
    [_mainTaskId, "SUCCEEDED"] call BIS_fnc_taskSetState;
    _casualtyUnit setVariable ["OKS_IsRescued", true, true];
    if (alive _casualtyUnit) then { _casualtyUnit setUnitPos "UP" };
    if (_debug) then { "[RescueSurvivor] Stabilization complete — task SUCCEEDED." call OKS_fnc_LogDebug };
};

}; // end stabilize succeeded
}; // end proximity alive
