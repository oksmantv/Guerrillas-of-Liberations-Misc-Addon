/*
    OKS_fnc_Insert_Task

    Creates an "Insertion" task that completes when players LAND inside a trigger zone.

    Behavior:
        - Trigger area: 200m radius (hardcoded)
        - Trigger condition: any player in area AND LANDED (vehicle touching ground)
            (also checks low speed + altitude (ATL) below 5m to avoid edge cases)
        - Trigger timeout: 5 seconds (hardcoded)
        - Task always shows position + pops notification (hardcoded)
        - Task type icon: "land" (hardcoded)

    Params:
        0: OBJECT|STRING (required)
            - Trigger reference (object or variable name). Must be named in Eden.

        1: STRING (optional) task title (defaults: "Insertion")
        2: STRING (optional) task display name (defaults: "Land in insertion zone")
        3: STRING (optional) task description (auto-generated if nil)
        4: STRING (optional) parent task id

    Example (using an Eden-placed trigger named InsertLZ_1):
            [InsertLZ_1] spawn OKS_fnc_Insert_Task;
*/

if (!isServer) exitWith {};

params [
    ["_triggerRef", objNull, [objNull, ""]],
    ["_customTitle", "", [""]],
    ["_customDisplayName", "", [""]],
    ["_customDescription", "", [""]],
    ["_taskParent", "", [""]]
];

private _shouldShowPosition = true;
private _shouldPopUpNotification = true;
private _taskIcon = "land";

private _radius = 200;
private _altitudeMax = 5;
private _timeoutSeconds = 5;

private _trg = objNull;

private _resolveTrigger = {
    params ["_ref"];
    if (_ref isEqualType objNull) exitWith {
        if (!isNull _ref) then {_ref} else {objNull};
    };
    if (_ref isEqualType "") exitWith {
        if (_ref isEqualTo "") then {objNull} else { missionNamespace getVariable [_ref, objNull] };
    };
    objNull
};

_trg = [_triggerRef] call _resolveTrigger;

if (isNull _trg) exitWith {
    private _msg = "OKS Insert Task: trigger reference is required (object or variable name)";
    if (is3DEN) then {
        [_msg, 0, 5, true] call BIS_fnc_3DENNotification;
    } else {
        diag_log _msg;
    };
};

private _pos = getPosATL _trg;
_pos set [2, 0];

// Ensure trigger has a usable name (variable) so it can be referenced/debugged.
private _trgName = vehicleVarName _trg;
if (_trgName isEqualTo "") then {
    for "_i" from 0 to 50 do {
        private _candidate = format ["OKS_InsertLZ_%1", floor (random 100000)];
        if (isNil { missionNamespace getVariable _candidate }) exitWith {
            _trgName = _candidate;
        };
    };
    if (_trgName isEqualTo "") then { _trgName = format ["OKS_InsertLZ_%1", diag_tickTime]; };
    _trg setVehicleVarName _trgName;
    missionNamespace setVariable [_trgName, _trg, true];
};

// Configure trigger behavior.
private _r = (_radius max 20) min 2000;
private _alt = (_altitudeMax max 0) min 200;
private _t = (_timeoutSeconds max 0) min 60;

_trg setTriggerArea [_r, _r, 0, false];
_trg setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_trg setTriggerTimeout [_t, _t, _t, true];

private _cond = format [
    "this && ({isPlayer _x && {isTouchingGround (vehicle _x)} && {(abs (speed (vehicle _x))) < 3} && {((getPosATL (vehicle _x)) select 2) < %1}} count thisList > 0)",
    _alt
];
_trg setTriggerStatements [_cond, "", ""]; 

// Task defaults.
private _taskPos = objNull;
if (_shouldShowPosition) then { _taskPos = _pos; };

private _nextDesignation = {
    params ["_index1Based"];
    private _choicesByLetter = [
        ["Alpha", "Able", "Apex"],
        ["Beta", "Bravo", "Baker"],
        ["Charlie", "Cobra", "Cyclone"],
        ["Delta", "Dagger", "Dragon"],
        ["Echo", "Eagle", "Ember"],
        ["Foxtrot", "Falcon", "Fury"],
        ["Golf", "Gamma", "Goliath"],
        ["Hotel", "Helios", "Hunter"],
        ["India", "Ion", "Ivory"],
        ["Juliet", "Javelin", "Juno"],
        ["Kilo", "Knight", "Kraken"],
        ["Lima", "Lancer", "Loki"],
        ["Mike", "Meteor", "Mantis"],
        ["November", "Nexus", "Nomad"],
        ["Oscar", "Omega", "Orion"],
        ["Papa", "Phoenix", "Pioneer"],
        ["Quebec", "Quartz", "Quasar"],
        ["Romeo", "Raptor", "Ragnar"],
        ["Sierra", "Spartan", "Sentinel"],
        ["Tango", "Titan", "Tempest"],
        ["Uniform", "Umbra", "Uplink"],
        ["Victor", "Vanguard", "Viper"],
        ["Whiskey", "Warden", "Wolf"],
        ["X-ray", "Xeno", "Xerxes"],
        ["Yankee", "Ymir", "Yellow"],
        ["Zulu", "Zenith", "Zephyr"]
    ];

    private _idx = (_index1Based - 1);
    if ((_idx >= 0) && (_idx < (count _choicesByLetter))) exitWith {
        selectRandom (_choicesByLetter select _idx)
    };

    // Fallback for > 26: Excel-style AA/AB/... (no randomization)
    private _n = _index1Based;
    private _letters = "";
    while {_n > 0} do {
        _n = _n - 1;
        _letters = ("ABCDEFGHIJKLMNOPQRSTUVWXYZ" select [_n mod 26, 1]) + _letters;
        _n = floor (_n / 26);
    };
    _letters
};

private _deploymentIndex = missionNamespace getVariable ["OKS_InsertTask_DeploymentIndex", 0];
_deploymentIndex = _deploymentIndex + 1;
missionNamespace setVariable ["OKS_InsertTask_DeploymentIndex", _deploymentIndex, true];

private _designation = [_deploymentIndex] call _nextDesignation;

private _title = if (_customTitle isEqualTo "") then {format ["Deployment %1", _designation]} else {_customTitle};
private _displayName = if (_customDisplayName isEqualTo "") then {format ["Deployment %1", _designation]} else {_customDisplayName};
private _desc = _customDescription;

if (_desc isEqualTo "") then {
    _desc = format [
        "You have been tasked with deploying our forces in this area.",
        round _r,
        _alt,
        _t
    ];
};

private _taskId = format ["OKS_InsertTask_%1", floor (random 1e6)];
private _taskData = _taskId;
if !(_taskParent isEqualTo "") then {
    _taskData = [_taskId, _taskParent];
};

[
    true,
    _taskData,
    [
        _desc,
        _displayName,
        ""
    ],
    _taskPos,
    "AUTOASSIGNED",
    -1,
    _shouldPopUpNotification,
    _taskIcon
] call BIS_fnc_taskCreate;

waitUntil {
    sleep 1;
    triggerActivated _trg
};

[_taskId, "SUCCEEDED", _shouldPopUpNotification] call BIS_fnc_taskSetState;
