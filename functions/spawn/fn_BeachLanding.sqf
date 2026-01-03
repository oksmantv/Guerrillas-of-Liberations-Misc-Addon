/*
    OKS_fnc_BeachLanding

    Server-only.

    [beachLandingSpawn, beachLandingTarget, boatClassname, cargoUnitCount, side, lambsType, lambsRange, publicVariableName] spawn OKS_fnc_BeachLanding;

    - Spawns a boat with full crew and cargo
    - Beaches in a straight line (physics steering)
    - Cuts propulsion shortly before shore so it glides
    - When speed < 2 km/h: dismounts quickly (driver + cargo; gunners stay)
    - Dismounts form a new group and get a reduced-set LAMBS offensive task (rush/hunt/attack)
*/

if (!isServer) exitWith {false};

params [
    ["_beachLandingSpawn", objNull, [objNull, []]],
    ["_beachLandingTarget", objNull, [objNull, []]],
    ["_boatClassname", "B_Boat_Transport_01_F", [""]],
    ["_cargoUnitCount", 5, [0]],
    ["_assaultSide", east, [sideUnknown]],
    ["_lambsTaskType", "rush", [""]],
    ["_lambsTaskRange", 1500, [0]],
    ["_publicVariableName", "", [""]]
];

private _spawnPositionASL = [0,0,0];
private _targetPositionASL = [0,0,0];

private _debugEnabled = missionNamespace getVariable ["GOL_Amphibious_Debug", false];
private _debugChat = missionNamespace getVariable ["GOL_Amphibious_DebugChat", false];

private _debugLog = {
    params ["_stage", ["_details", "", [""]]];
    if (!_debugEnabled) exitWith {};

    private _msg = if (_details isEqualTo "") then {
        format ["[GOL Amphibious][BeachLanding] %1", _stage]
    } else {
        format ["[GOL Amphibious][BeachLanding] %1 | %2", _stage, _details]
    };

    diag_log _msg;
    if (_debugChat) then {
        _msg remoteExec ["systemChat", 0];
    };
};

["START", format ["spawn: %1 target: %2 boat: %3 cargo: %4 side: %5 lambs: %6 range: %7 pv: %8", _beachLandingSpawn, _beachLandingTarget, _boatClassname, _cargoUnitCount, _assaultSide, _lambsTaskType, _lambsTaskRange, _publicVariableName]] call _debugLog;

if (_beachLandingSpawn isEqualType objNull) then {
    if (isNull _beachLandingSpawn) exitWith { false };
    _spawnPositionASL = getPosASL _beachLandingSpawn;
} else {
    if !(_beachLandingSpawn isEqualType []) exitWith { false };
    _spawnPositionASL = +_beachLandingSpawn;
};

if (_beachLandingTarget isEqualType objNull) then {
    if (isNull _beachLandingTarget) exitWith { false };
    _targetPositionASL = getPosASL _beachLandingTarget;
} else {
    if !(_beachLandingTarget isEqualType []) exitWith { false };
    _targetPositionASL = +_beachLandingTarget;
};

_spawnPositionASL set [2, 0];
_targetPositionASL set [2, 0];

if (_spawnPositionASL isEqualTo [0,0,0] || {_targetPositionASL isEqualTo [0,0,0]}) exitWith { false };

["POS", format ["spawnASL=%1 targetASL=%2", _spawnPositionASL, _targetPositionASL]] call _debugLog;

if (_beachLandingTarget isEqualType objNull) then {
    ["TARGET_OBJ", format ["targetObj=%1 rawASL=%2 flattenedASL=%3", _beachLandingTarget, getPosASL _beachLandingTarget, _targetPositionASL]] call _debugLog;
};

private _boatVehicle = createVehicle [_boatClassname, _spawnPositionASL, [], 0, "CAN_COLLIDE"];
if (isNull _boatVehicle) exitWith { false };
_boatVehicle setPosASL _spawnPositionASL;
private _approachDirectionDegrees = _spawnPositionASL getDir _targetPositionASL;
_boatVehicle setDir _approachDirectionDegrees;
_boatVehicle engineOn true;

["BOAT_SPAWNED", format ["boat=%1 dir=%2", _boatVehicle, _approachDirectionDegrees]] call _debugLog;

private _boatGroup = [_boatVehicle, _assaultSide, 0, _cargoUnitCount] call OKS_fnc_AddVehicleCrew;
if (isNull _boatGroup) exitWith { false };

["CREW", format ["group=%1 crewCount=%2", _boatGroup, count (crew _boatVehicle)]] call _debugLog;

// Beach in a straight line using physics steering.
// Cut propulsion before the final beach so it can glide.
private _approachSpeedKilometersPerHour = missionNamespace getVariable ["GOL_Amphibious_ApproachSpeedKph", 55];
private _cutPropulsionDistanceMeters = missionNamespace getVariable ["GOL_Amphibious_CutPropulsionDistanceMeters", 5];
private _maximumApproachTimeSeconds = missionNamespace getVariable ["GOL_Amphibious_MaxApproachTimeSeconds", 300];
private _beachScanEnabled = missionNamespace getVariable ["GOL_Amphibious_BeachScanEnabled", true];
private _beachScanAheadMeters = missionNamespace getVariable ["GOL_Amphibious_BeachScanAheadMeters", 5];
private _landScanParam = if (_beachScanEnabled) then { _beachScanAheadMeters } else { -1 };

["STEER_BEGIN", format ["speed=%1kph cutoff=%2m maxTime=%3s landScan=%4 (%5m)", _approachSpeedKilometersPerHour, _cutPropulsionDistanceMeters, _maximumApproachTimeSeconds, _beachScanEnabled, _beachScanAheadMeters]] call _debugLog;

// Always steer toward the flattened target position (ASL z=0). This avoids "target logic at seafloor" issues.
private _reachedCutoffDistance = [_boatVehicle, _targetPositionASL, _approachSpeedKilometersPerHour, _cutPropulsionDistanceMeters, 0.2, _maximumApproachTimeSeconds, [0,0,0], "ASL", true, false, _landScanParam] call OKS_fnc_SteerVehicleToTarget;

private _distanceToTargetNow = _boatVehicle distance _targetPositionASL;
["STEER_END", format ["ok=%1 distToTarget=%2m speedNow=%3", _reachedCutoffDistance, (round _distanceToTargetNow), speed _boatVehicle]] call _debugLog;

if (alive _boatVehicle && _reachedCutoffDistance) then {
    _boatVehicle engineOn false;
    private _driverUnit = driver _boatVehicle;
    if (!isNull _driverUnit) then {
     	doStop _driverUnit;
        _driverUnit disableAI "PATH";
    };

    // If we arrived too slowly, give a small push so it actually glides.
    if ((speed _boatVehicle) < 10) then {
        private _directionVector = vectorNormalized ((getPosASL _boatVehicle) vectorFromTo _targetPositionASL);
        _boatVehicle setVelocity (_directionVector vectorMultiply 6);
    };

    ["ENGINE_CUT", format ["speedNow=%1", speed _boatVehicle]] call _debugLog;
} else {
    ["ENGINE_NOT_CUT", format ["alive=%1 ok=%2", alive _boatVehicle, _reachedCutoffDistance]] call _debugLog;
};

private _dismountSpeedThresholdKph = 3;

["WAIT_DISMOUNT", format ["distToLanding=%1m speedNow=%2 threshold=%3", round (_boatVehicle distance _targetPositionASL), speed _boatVehicle, _dismountSpeedThresholdKph]] call _debugLog;

// Wait for a proper stop. If the boat is stuck (not moving), exit instead of forcing stop.
private _lastMoveTime = diag_tickTime;
private _lastPosASL = getPosASL _boatVehicle;
private _stuckDetected = false;

waitUntil {
    sleep 0.1;

    if (!alive _boatVehicle) exitWith { true };

    // If all crew died, nothing to do.
    if (({alive _x} count (crew _boatVehicle)) == 0) exitWith { true };

    if ((speed _boatVehicle) < _dismountSpeedThresholdKph) exitWith { true };

    private _posNowASL = getPosASL _boatVehicle;
    if ((_posNowASL distance2D _lastPosASL) > 0.75) then {
        _lastPosASL = _posNowASL;
        _lastMoveTime = diag_tickTime;
    };

    // If it's not making meaningful progress, consider it stuck and exit.
    if ((diag_tickTime - _lastMoveTime) > 20) exitWith {
        _stuckDetected = true;
        true
    };

    false
};

// If crew is dead (or was wiped during impact), exit entirely.
if (alive _boatVehicle && {({alive _x} count (crew _boatVehicle)) == 0}) exitWith {
    ["CREW_DEAD_EXIT", "All crew are dead"] call _debugLog;
    false
};

if (_stuckDetected) exitWith {
    ["STUCK_EXIT", format ["speedNow=%1 distToLanding=%2", speed _boatVehicle, round (_boatVehicle distance _targetPositionASL)]] call _debugLog;
    false
};

if (!alive _boatVehicle) exitWith { false };

// Dismount everyone except commander + gunner.
// This is intentionally strict to avoid odd fullCrew role/turret classification keeping drivers mounted.
private _unitsToDismountInitial = [];
private _unitsToKeepInBoat = [];

private _driverSeatUnit = driver _boatVehicle;

private _keeperCommander = commander _boatVehicle;
private _keeperGunner = gunner _boatVehicle;

// Some vehicles report the driver as "commander" (no dedicated commander seat).
// We never want the driver to be kept mounted.
if (!isNull _keeperCommander
    && {alive _keeperCommander}
    && {vehicle _keeperCommander == _boatVehicle}
    && {isNull _driverSeatUnit || {_keeperCommander != _driverSeatUnit}}) then {
    _unitsToKeepInBoat pushBackUnique _keeperCommander;
};
if (!isNull _keeperGunner && {alive _keeperGunner} && {vehicle _keeperGunner == _boatVehicle}) then {
    _unitsToKeepInBoat pushBackUnique _keeperGunner;
};

{
    _x params ["_crewUnit", "_vehicleRole", "_cargoIndex", "_turretPath", "_personTurretPath"];
    if (isNull _crewUnit) then { continue; };
    _unitsToDismountInitial pushBackUnique _crewUnit;
} forEach (fullCrew [_boatVehicle, "", true]);

_unitsToDismountInitial = _unitsToDismountInitial select { alive _x && {vehicle _x == _boatVehicle} };
_unitsToKeepInBoat = _unitsToKeepInBoat select { alive _x && {vehicle _x == _boatVehicle} };

if !(_unitsToKeepInBoat isEqualTo []) then {
    _unitsToDismountInitial = _unitsToDismountInitial - _unitsToKeepInBoat;
};

if (_unitsToDismountInitial isEqualTo []) exitWith {
    ["DISMOUNT_NONE", "No units to dismount"] call _debugLog;
    true
};

["DISMOUNT_KEEPERS", format ["driver=%1 commander=%2 gunner=%3 keep=%4", _driverSeatUnit, _keeperCommander, _keeperGunner, _unitsToKeepInBoat]] call _debugLog;

// Lock the boat before dismount so units can't immediately re-board.
if (alive _boatVehicle) then {
    _boatVehicle lock 2;
};

// Make sure the driver dismounts first (and doesn't get stuck if we disabled PATH earlier).
private _driverToDismount = driver _boatVehicle;
if (!isNull _driverToDismount && {_driverToDismount in _unitsToDismountInitial}) then {
    _unitsToDismountInitial = [_driverToDismount] + (_unitsToDismountInitial - [_driverToDismount]);
};

["DISMOUNT_BEGIN", format ["dismount=%1 keep=%2", count _unitsToDismountInitial, count _unitsToKeepInBoat]] call _debugLog;

private _dismountGroup = createGroup _assaultSide;
_dismountGroup setVariable ["acex_headless_blacklist", true, true];
_dismountGroup setVariable ["GW_HeadlessController_BlackList", true, true];

private _dismountStaggerSeconds = 1;
private _postDismountAttackDelaySeconds = 30;

// Helper: restore AI movement after we intentionally stopped/disabled PATH on the driver.
// (doStop + disableAI "PATH" will otherwise leave them frozen after dismount)
private _restoreUnitAI = {
    params ["_unit"];
    if (isNull _unit || {!alive _unit}) exitWith {};

    _unit enableAI "MOVE";
    _unit enableAI "PATH";
    _unit enableAI "FSM";
    _unit enableAI "AUTOTARGET";
    _unit enableAI "TARGET";
};

{
    unassignVehicle _x;
    // Prevent AI from immediately re-boarding the boat.
    [_x] orderGetIn false;

    // If this unit had PATH disabled (notably the driver during ENGINE_CUT), restore it before dismount.
    [_x] call _restoreUnitAI;

    doGetOut _x;
    _x action ["GetOut", _boatVehicle];
    sleep _dismountStaggerSeconds;
} forEach _unitsToDismountInitial;

private _forceDismountStartTimeSeconds = diag_tickTime;
waitUntil {
    sleep 0.05;
    ({vehicle _x == _x} count _unitsToDismountInitial) == (count _unitsToDismountInitial)
    || {diag_tickTime - _forceDismountStartTimeSeconds > 2}
};

{
    if (vehicle _x != _x) then { moveOut _x; };
} forEach _unitsToDismountInitial;

// Put all dismounts into one group (array join is more reliable than per-unit joins).
_unitsToDismountInitial joinSilent _dismountGroup;
if !(_unitsToDismountInitial isEqualTo []) then {
    _dismountGroup selectLeader (_unitsToDismountInitial select 0);
};

{
    [_x] call _restoreUnitAI;
    _x setBehaviour "AWARE";
    _x setCombatMode "YELLOW";
} forEach _unitsToDismountInitial;

["DISMOUNT_DONE", format ["group=%1 units=%2", _dismountGroup, count (units _dismountGroup)]] call _debugLog;

// Prevent dismounted units from trying to re-board the boat.
if (alive _boatVehicle) then {
    _boatVehicle lock 2;
};

// Hard-prevent re-boarding on the machine where these AI are local.
private _noRemountExecTarget = groupOwner _dismountGroup;
[(units _dismountGroup), _boatVehicle] remoteExecCall ["OKS_fnc_BeachLandingInstallNoRemount", _noRemountExecTarget];

if !(_publicVariableName isEqualTo "") then {
    missionNamespace setVariable [_publicVariableName, units _dismountGroup, true];
    ["PV_SET", format ["%1=%2 units", _publicVariableName, count (units _dismountGroup)]] call _debugLog;
};

// Reduced set of offensive LAMBS tasks: rush/hunt/attack.
private _taskTypeLower = toLower _lambsTaskType;
if (_taskTypeLower in ["creep","ambushattack","ambushrush","ambushhunt","ambushcqb"]) then {
    _taskTypeLower = "rush";
};

private _assaultTargetPosition = if (_beachLandingTarget isEqualType objNull) then { getPosASL _beachLandingTarget } else { _targetPositionASL };

["LAMBS_DELAYED", format ["type=%1 range=%2 delay=%3s target=%4", _taskTypeLower, _lambsTaskRange, _postDismountAttackDelaySeconds, _assaultTargetPosition]] call _debugLog;

// Run combat-delay + tasking on the group owner (server or HC) to avoid locality issues.
private _lambsExecTarget = groupOwner _dismountGroup;
[_dismountGroup, _taskTypeLower, _lambsTaskRange, _assaultTargetPosition, _postDismountAttackDelaySeconds, true, _boatVehicle, 10, 140, 5]
    remoteExec ["OKS_fnc_BeachLandingPostDismountTasking", _lambsExecTarget];

// Optional: keep boat crew mounted while enemies exist; when enemies disappear, dismount crew and merge into the assault group.
private _crewDismountWhenNoTargets = missionNamespace getVariable ["GOL_Amphibious_CrewDismountWhenNoTargets", true];
if (_crewDismountWhenNoTargets && {alive _boatVehicle}) then {
    private _targetCheckRangeMeters = missionNamespace getVariable ["GOL_Amphibious_TargetCheckRangeMeters", 400];
    private _targetCheckIntervalSeconds = missionNamespace getVariable ["GOL_Amphibious_TargetCheckIntervalSeconds", 2];
    private _noTargetTimeoutSeconds = missionNamespace getVariable ["GOL_Amphibious_NoTargetTimeoutSeconds", 15];

    private _hasNearbyEnemies = {
        params ["_boat", "_friendlySide", "_rangeMeters"];
        if (isNull _boat) exitWith { false };

        private _candidates = _boat nearEntities [["Man", "LandVehicle"], _rangeMeters];

        private _isEnemyMan = {
            params ["_unit", "_friendlySide"];
            if (isNull _unit || {!alive _unit}) exitWith { false };
            private _s = side (group _unit);
            (_s != civilian) && (_s != sideUnknown) && (_s != _friendlySide)
        };

        private _isEnemyCrewedVehicle = {
            params ["_veh", "_friendlySide"];
            if (isNull _veh || {!alive _veh}) exitWith { false };

            private _vehCrew = (crew _veh) select { alive _x };
            if (_vehCrew isEqualTo []) exitWith { false }; // ignore empty vehicles

            private _s = side (group (_vehCrew select 0));
            (_s != civilian) && (_s != sideUnknown) && (_s != _friendlySide)
        };

        private _enemies = _candidates select {
            if (_x isKindOf "Man") then {
                [_x, _friendlySide] call _isEnemyMan
            } else {
                [_x, _friendlySide] call _isEnemyCrewedVehicle
            }
        };

        (count _enemies) > 0
    };

    ["CREW_MONITOR", format ["keepMounted=%1 range=%2 interval=%3 timeout=%4", count _unitsToKeepInBoat, _targetCheckRangeMeters, _targetCheckIntervalSeconds, _noTargetTimeoutSeconds]] call _debugLog;

    private _noTargetStart = diag_tickTime;
    waitUntil {
        sleep _targetCheckIntervalSeconds;
        if (!alive _boatVehicle) exitWith { true };
        private _hasTargets = [_boatVehicle, _assaultSide, _targetCheckRangeMeters] call _hasNearbyEnemies;
        if (_hasTargets) then {
            _noTargetStart = diag_tickTime;
        };
        (diag_tickTime - _noTargetStart) > _noTargetTimeoutSeconds
    };

    if (alive _boatVehicle) then {
        private _crewToDismountLater = (crew _boatVehicle) select { alive _x && {vehicle _x == _boatVehicle} };
        if !(_crewToDismountLater isEqualTo []) then {
            ["CREW_DISMOUNT_BEGIN", format ["units=%1", count _crewToDismountLater]] call _debugLog;
            {
                unassignVehicle _x;
                [_x] orderGetIn false;
                doGetOut _x;
                _x action ["GetOut", _boatVehicle];
                sleep _dismountStaggerSeconds;
            } forEach _crewToDismountLater;

            private _crewForceStart = diag_tickTime;
            waitUntil {
                sleep 0.05;
                ({vehicle _x == _x} count _crewToDismountLater) == (count _crewToDismountLater)
                || {diag_tickTime - _crewForceStart > 2}
            };

            {
                if (vehicle _x != _x) then { moveOut _x; };
            } forEach _crewToDismountLater;

            {
                // no-op (join after forced moveOut)
            } forEach _crewToDismountLater;

            _crewToDismountLater joinSilent _dismountGroup;
            if !(_crewToDismountLater isEqualTo []) then {
                _dismountGroup selectLeader (leader _dismountGroup);
            };

            {
                [_x] call _restoreUnitAI;
            } forEach _crewToDismountLater;

            ["CREW_DISMOUNT_DONE", format ["groupUnits=%1", count (units _dismountGroup)]] call _debugLog;

            // Apply no-remount to newly merged crew as well.
            private _noRemountExecTarget2 = groupOwner _dismountGroup;
            [_crewToDismountLater, _boatVehicle] remoteExecCall ["OKS_fnc_BeachLandingInstallNoRemount", _noRemountExecTarget2];

            // Re-issue LAMBS task so newly merged units get it as well (no extra delay).
            private _retaskTarget = groupOwner _dismountGroup;
            [_dismountGroup, _taskTypeLower, _lambsTaskRange, _assaultTargetPosition, 0, false, objNull, 0, 0, 0]
                remoteExec ["OKS_fnc_BeachLandingPostDismountTasking", _retaskTarget];
        };
    };
};

true
