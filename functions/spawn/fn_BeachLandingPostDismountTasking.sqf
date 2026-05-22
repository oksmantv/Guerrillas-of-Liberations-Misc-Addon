/*
    Function: OKS_fnc_BeachLandingPostDismountTasking

    Description:
        Assigns a LAMBS offensive task to a dismounted infantry group after a beach landing.
        Supports optional delay before tasking, combat suppression during the delay period,
        and a fan-out formation in front of the landing boat. Units are spread in an arc in
        front of the boat before receiving their LAMBS task, creating a realistic beachhead
        push. The function waits for LAMBS Danger to be available before proceeding.
        Used internally by OKS_fnc_BeachLanding but can be called independently.

    Parameters:
        0: _grp                   - GROUP   - Dismount group to task
        1: _taskType              - STRING  - LAMBS task type: "rush", "hunt", or "attack" (default: "rush")
        2: _range                 - NUMBER  - Range in meters for the LAMBS task (default: 1500)
        3: _targetPos             - ARRAY   - Target position [x,y,z] (default: [0,0,0])
        4: _delaySeconds          - NUMBER  - Delay in seconds before assigning task (default: 0)
        5: _suppressCombat        - BOOLEAN - Suppress combat behaviour during delay (default: false)
        6: _boatVehicle           - OBJECT  - Boat vehicle used to calculate fan-out direction (default: objNull)
        7: _coneRadiusMeters      - NUMBER  - Fan-out cone radius in meters (default: 10)
        8: _coneArcDegrees        - NUMBER  - Fan-out cone arc width in degrees (default: 140)
        9: _restoreStaggerSeconds - NUMBER  - Stagger delay in seconds per unit when restoring combat (default: 5)

    Returns:
        BOOLEAN - true on success, false if group is null or LAMBS is unavailable

    Example:
        [_dismountGroup, "rush", 1500, getPos beachTarget_1, 3, true, _boat, 15, 140, 5] spawn OKS_fnc_BeachLandingPostDismountTasking;
*/

params [
    ["_grp", grpNull, [grpNull]],
    ["_taskType", "rush", [""]],
    ["_range", 1500, [0]],
    ["_targetPos", [0,0,0], [[]]],
    ["_delaySeconds", 0, [0]],
    ["_suppressCombat", false, [true]],
    ["_boatVehicle", objNull, [objNull]],
    ["_coneRadiusMeters", 10, [0]],
    ["_coneArcDegrees", 140, [0]],
    ["_restoreStaggerSeconds", 5, [0]]
];

if (isNull _grp) exitWith { false };

private _debugEnabled = missionNamespace getVariable ["GOL_Amphibious_Debug", false];
private _debugLog = {
    params ["_stage", ["_details", "", [""]]];
    if (!_debugEnabled) exitWith {};
    private _msg = if (_details isEqualTo "") then {
        format ["[GOL Amphibious][BeachLandingPost] %1", _stage]
    } else {
        format ["[GOL Amphibious][BeachLandingPost] %1 | %2", _stage, _details]
    };
    diag_log _msg;
};

private _units = units _grp;
if (_units isEqualTo []) exitWith { false };

["START", format ["grp=%1 owner=%2 units=%3 delay=%4 suppress=%5", _grp, groupOwner _grp, count _units, _delaySeconds, _suppressCombat]] call _debugLog;

// Ensure basic movement is enabled.
{
    _x enableAI "MOVE";
    _x enableAI "PATH";
} forEach _units;

// If LAMBS isn't ready yet, wait now so we don't add extra delay *after* the movement window.
private _waitStart = diag_tickTime;
waitUntil {
    sleep 0.25;
    (!isNil "lambs_wp_fnc_taskRush") || {(diag_tickTime - _waitStart) > 10}
};

if (isNil "lambs_wp_fnc_taskRush") exitWith {
    ["LAMBS_MISSING", "lambs_wp_fnc_taskRush nil after 10s"] call _debugLog;
    false
};

private _applyLambsTask = {
    params ["_grp", "_taskType", "_range", "_targetPos"];

    // Clear any movement control so LAMBS takes over immediately.
    private _ldr = leader _grp;
    if (!isNull _ldr) then {
        { if (!isNull _x) then { _x doFollow _ldr; }; } forEach (units _grp);
    };

    for "_i" from ((count (waypoints _grp)) - 1) to 0 step -1 do {
        deleteWaypoint [_grp, _i];
    };

    switch (toLower _taskType) do {
        case "hunt": {
            [_grp, _range, 30, [], [], false, false, false] spawn lambs_wp_fnc_taskHunt;
        };
        case "attack": {
            {
                [_x, _targetPos, true] spawn lambs_wp_fnc_taskAssault;
            } forEach (units _grp);
        };
        default {
            [_grp, _range, 10, [], [], false] spawn lambs_wp_fnc_taskRush;
        };
    };
};

private _fanOutInFrontOfBoat = {
    params ["_units", "_boat", "_targetPos", "_radius", "_arcDeg"];
    if (_units isEqualTo []) exitWith {};
    if (isNull _boat) exitWith {};
    if (_radius <= 0) exitWith {};
    if (_arcDeg <= 0) exitWith {};

    private _boatPosASL = getPosASL _boat;
    _boatPosASL set [2, 0];

    private _baseDir = getDir _boat;

    private _n = count _units;
    private _halfArc = _arcDeg / 2;
    private _step = if (_n <= 1) then { 0 } else { _arcDeg / (_n - 1) };

    // Spread units along the arc in front of the boat.
    for "_i" from 0 to (_n - 1) do {
        private _u = _units select _i;
        if (isNull _u || {!alive _u}) then { continue; };

        private _offset = if (_n <= 1) then { 0 } else { (-_halfArc) + (_step * _i) };
        private _dir = _baseDir + _offset;
        private _xOff = (sin _dir) * _radius;
        private _yOff = (cos _dir) * _radius;
        private _posASL = [(_boatPosASL select 0) + _xOff, (_boatPosASL select 1) + _yOff, 0];
        private _posATL = ASLToATL _posASL;
        _posATL set [2, 0];

        _u doMove _posATL;
    };
};

if (_suppressCombat && {_delaySeconds > 0}) then {
    {
        _x disableAI "FSM";
        _x disableAI "COVER";
        _x enableAttack false;
    } forEach _units;

    // Fan out first (prevents the big "hiding blob"), then keep them moving generally inland.
    [_units, _boatVehicle, _targetPos, _coneRadiusMeters, _coneArcDegrees] call _fanOutInFrontOfBoat;

    ["SUPPRESS_ON", format ["units=%1", count _units]] call _debugLog;
};

// Apply the LAMBS task immediately (movement happens even while attack is suppressed).
[_grp, _taskType, _range, _targetPos] call _applyLambsTask;
["LAMBS_APPLIED", format ["type=%1", _taskType]] call _debugLog;

if (_suppressCombat && {_delaySeconds > 0}) then {
    sleep _delaySeconds;

    // Restore gradually so not everyone stops at the same time.
    private _restoreUnits = (units _grp) select { !isNull _x && {alive _x} };
    if (_restoreUnits isEqualTo []) exitWith { true };

    private _stagger = _restoreStaggerSeconds max 0;
    {
        _x enableAI "FSM";
        _x enableAI "COVER";
        _x enableAttack true;
        if (_stagger > 0) then { sleep _stagger; };
    } forEach _restoreUnits;

    ["SUPPRESS_OFF", format ["restored=%1 stagger=%2", count _restoreUnits, _stagger]] call _debugLog;
};

true;
