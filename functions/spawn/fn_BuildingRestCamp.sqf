/*
    OKS_fnc_BuildingRestCamp

    Place a game logic near a building. This script finds the nearest building,
    fills every building position with a spawned AI unit, puts them all into
    rest/sleep state (OKS_fnc_RestCamp). When combat is detected the group
    wakes up, gears up, and executes one of four behaviours:

        "GARRISON" — ACE garrison scatter into nearby buildings (no teleport)
        "RUSH"    — LAMBS taskRush (aggressive push toward enemies)
        "HUNT"    — LAMBS taskHunt (sweep and search the area)
        "PATROL"  — LAMBS taskPatrol (patrol around the building)

    Parameters:
        _logic         - OBJECT : game logic placed near a building
        _side          - SIDE (optional): side for the spawned group.
                         Default: east
        _maxUnits      - NUMBER (optional): max number of units to spawn.
                         -1 = no limit (fill every building position).
                         Default: 8
        _garrisonRange - NUMBER (optional): radius (m) for ACE garrison
                         scatter or LAMBS task range. Default: 50
        _delayRange    - ARRAY (optional): [min, max] per-unit wake-up
                         delay passed to RestCamp. Default: [10, 30]
        _wakeMode      - STRING (optional): post-wake behaviour.
                         One of: "GARRISON", "RUSH", "HUNT", "PATROL".
                         Default: "GARRISON"

    Usage:
        [_logic] spawn OKS_fnc_BuildingRestCamp;
        [_logic, east] spawn OKS_fnc_BuildingRestCamp;
        [_logic, east, -1] spawn OKS_fnc_BuildingRestCamp;
        [_logic, east, 8, 75] spawn OKS_fnc_BuildingRestCamp;
        [_logic, east, 8, 50, [5, 20]] spawn OKS_fnc_BuildingRestCamp;
        [_logic, east, -1, 50, [10, 30], "RUSH"] spawn OKS_fnc_BuildingRestCamp;
        [_logic, east, 8, 50, [10, 30], "GARRISON"] spawn OKS_fnc_BuildingRestCamp;

    Notes:
        - Must be spawned (uses sleep / waitUntil).
        - Runs on server or HC only.
        - GARRISON mode requires ACE AI module (ace_ai_fnc_garrison).
        - RUSH / HUNT / PATROL require LAMBS Danger (lambs_wp_fnc_*).
        - Unit classnames are pulled from OKS_fnc_Dynamic_Settings
          (mission-configured faction).
        - Debug logging via GOL_Enemy_Debug variable.
*/

params [
    ["_logic", objNull, [objNull]],
    ["_side", east, [sideUnknown]],
    ["_maxUnits", 8, [0]],
    ["_garrisonRange", 50, [0]],
    ["_delayRange", [10, 30], [[]]],
    ["_wakeMode", "GARRISON", [""]]
];

_wakeMode = toUpper _wakeMode;

if (hasInterface && !isServer) exitWith {};

private _debug = missionNamespace getVariable ["GOL_Enemy_Debug", false];

if (isNull _logic) exitWith {
    if (_debug) then {
        "[BuildingRestCamp] Logic object is null — check that the named object exists in the mission." spawn OKS_fnc_LogDebug;
    };
};

// ── Find nearest building and its positions ────────────────────────────────
private _building = nearestBuilding (getPos _logic);

if (isNull _building) exitWith {
    if (_debug) then {
        "[BuildingRestCamp] No building found near logic." spawn OKS_fnc_LogDebug;
    };
};

private _positions = [_building] call BIS_fnc_buildingPositions;

if (count _positions == 0) exitWith {
    if (_debug) then {
        format [
            "[BuildingRestCamp] Building %1 has no enterable positions.",
            typeOf _building
        ] spawn OKS_fnc_LogDebug;
    };
};

// ── Cap positions to _maxUnits if set ──────────────────────────────────────
if (_maxUnits > 0 && {count _positions > _maxUnits}) then {
    _positions = _positions call BIS_fnc_arrayShuffle;
    _positions resize _maxUnits;
};

if (_debug) then {
    format [
        "[BuildingRestCamp] Building %1 — %2 positions found%3.",
        typeOf _building, count _positions,
        if (_maxUnits > 0) then { format [" (capped to %1)", _maxUnits] } else { "" }
    ] spawn OKS_fnc_LogDebug;
};

// ── Get unit classnames from mission faction ───────────────────────────────
waitUntil { sleep 1; !isNil "OKS_fnc_Dynamic_Settings" };

private _settings = [_side] call OKS_fnc_Dynamic_Settings;
_settings params ["_unitArray"];
_unitArray params ["_leaders", "_units", "_officer"];

// ── Create group and spawn one unit per building position ──────────────────
private _group = createGroup _side;
_group setVariable ["lambs_danger_disableGroupAI", true];

{
    private _unit = objNull;
    if (count units _group == 0) then {
        _unit = _group createUnit [selectRandom _leaders, _x, [], 0, "NONE"];
        _unit setRank "SERGEANT";
    } else {
        _unit = _group createUnit [selectRandom _units, _x, [], 0, "NONE"];
        _unit setRank "PRIVATE";
    };

    _unit setPos _x;
    _unit setDir (random 360);

    sleep 0.1;
} forEach _positions;

// Mark spawn as complete so RestCamp doesn't wait on GW_Performance_autoDelete
_group setVariable ["GW_Performance_autoDelete", true, true];

if (_debug) then {
    format [
        "[BuildingRestCamp] Spawned %1 units inside %2.",
        count units _group, typeOf _building
    ] spawn OKS_fnc_LogDebug;
};

// ── Set skill via GW system ────────────────────────────────────────────────
{[_x] remoteExec ["GW_SetDifficulty_fnc_setSkill", 0]} forEach units _group;

// ── Put the group into rest camp ───────────────────────────────────────────
[_group, _delayRange] spawn OKS_fnc_RestCamp;

// ── Wait for RestCamp to sleep units, then for all to finish waking ────────
//    Phase A: wait until RestCamp has set at least one unit to sleeping.
waitUntil {
    sleep 2;
    ({alive _x} count units _group == 0)
    || {({_x getVariable ["OKS_RestCamp_Sleeping", false]} count units _group) > 0}
};

if ({alive _x} count units _group == 0) exitWith {
    if (_debug) then {
        format ["[BuildingRestCamp] Group %1 wiped before waking.", _group]
            spawn OKS_fnc_LogDebug;
    };
};

if (_debug) then {
    format ["[BuildingRestCamp] Group %1 sleeping. Waiting for combat wake-up…", _group]
        spawn OKS_fnc_LogDebug;
};

//    Phase B: wait until no alive unit is still sleeping (all fully geared).
waitUntil {
    sleep 3;
    ({alive _x} count units _group == 0)
    || {
        ({_x getVariable ["OKS_RestCamp_Sleeping", false]}
            count (units _group select {alive _x})) == 0
    }
};

if ({alive _x} count units _group == 0) exitWith {
    if (_debug) then {
        format ["[BuildingRestCamp] Group %1 wiped during wake-up.", _group]
            spawn OKS_fnc_LogDebug;
    };
};

if (_debug) then {
    format [
        "[BuildingRestCamp] Group %1 fully awake. Executing post-wake mode: %2 (range %3m).",
        _group, _wakeMode, _garrisonRange
    ] spawn OKS_fnc_LogDebug;
};

// ── Post-wake behaviour ────────────────────────────────────────────────────
private _pos = getPos _logic;
private _aliveUnits = units _group select {alive _x};

if (count _aliveUnits == 0) exitWith {};

// Ensure pathfinding is enabled so units can move.
// GARRISON mode uses OKS_fnc_EnablePath (splits units into solo groups over
// time for static garrison behaviour).
// LAMBS modes (RUSH/HUNT/PATROL) need the group to stay intact, so we just
// enable PATH AI directly on every alive unit.
if (_wakeMode == "GARRISON") then {
    waitUntil { sleep 2; !(isNil "OKS_fnc_EnablePath") };
    [_group] spawn OKS_fnc_EnablePath;
} else {
    // Enable PATH AI on all alive units so they can move
    { _x enableAI "PATH" } forEach _aliveUnits;
    // Re-enable LAMBS group AI so danger.fsm can drive behaviour
    _group setVariable ["lambs_danger_disableGroupAI", false];
};

switch (toUpper _wakeMode) do {

    // ── GARRISON: ACE garrison scatter (no teleport) ───────────────────────
    case "GARRISON": {
        waitUntil { sleep 2; !(isNil "ace_ai_fnc_garrison") };

        // Random filling (mode 2), not top-to-bottom, NO teleport
        [_pos, nil, _aliveUnits, _garrisonRange, 2, false, false] remoteExec ["ace_ai_fnc_garrison", 0];

        if (_debug) then {
            format [
                "[BuildingRestCamp] ACE garrison — %1 units scattering to buildings within %2m.",
                count _aliveUnits, _garrisonRange
            ] spawn OKS_fnc_LogDebug;
        };

        // Wait for units to settle, then mark static
        sleep 10;
        private _settleTimeout = diag_tickTime + 120;

        waitUntil {
            sleep 5;
            if ({alive _x} count units _group == 0) exitWith { true };
            if (diag_tickTime > _settleTimeout) exitWith { true };

            private _alive = units _group select {alive _x};
            private _stationary = {speed _x < 0.5} count _alive;
            _stationary >= (count _alive * 0.8)
        };

        if ({alive _x} count units _group > 0) then {
            _group setVariable ["GOL_IsStatic", true, true];
            [_group] remoteExec ["OKS_fnc_SetStatic", 0];

            if (_debug) then {
                format ["[BuildingRestCamp] Group %1 settled — marked as static garrison.", _group]
                    spawn OKS_fnc_LogDebug;
            };
        };
    };

    // ── RUSH: LAMBS aggressive push ────────────────────────────────────────
    case "RUSH": {
        [
            _group,
            _garrisonRange,
            30,
            [],
            [],
            false
        ] spawn lambs_wp_fnc_taskRush;

        if (_debug) then {
            format ["[BuildingRestCamp] Group %1 — LAMBS RUSH (%2m).", _group, _garrisonRange]
                spawn OKS_fnc_LogDebug;
        };
    };

    // ── HUNT: LAMBS sweep and search ───────────────────────────────────────
    case "HUNT": {
        [
            _group,
            _garrisonRange,
            60,
            [],
            [],
            false,
            false,
            false
        ] spawn lambs_wp_fnc_taskHunt;
        sleep 5;
        _group setBehaviour "AWARE";

        if (_debug) then {
            format ["[BuildingRestCamp] Group %1 — LAMBS HUNT (%2m).", _group, _garrisonRange]
                spawn OKS_fnc_LogDebug;
        };
    };

    // ── PATROL: LAMBS patrol loop ──────────────────────────────────────────
    case "PATROL": {
        [
            _group,
            _pos,
            _garrisonRange,
            4,
            _pos,
            true,
            true
        ] spawn lambs_wp_fnc_taskPatrol;
        sleep 5;
        _group setBehaviour "AWARE";

        if (_debug) then {
            format ["[BuildingRestCamp] Group %1 — LAMBS PATROL (%2m, center: %3).", _group, _garrisonRange, _pos]
                spawn OKS_fnc_LogDebug;
        };
    };

    default {
        if (_debug) then {
            format ["[BuildingRestCamp] Unknown wakeMode '%1' — no post-wake action.", _wakeMode]
                spawn OKS_fnc_LogDebug;
        };
    };
};
