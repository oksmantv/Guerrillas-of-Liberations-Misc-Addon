/*
    [vehicle, guardGroup, hvtUnit, originPos] call OKS_fnc_InterceptHvt_MountGroup;
    Returns: [overflowGuards, hvtInVehicle, driverMounted, overflowGroup]
*/
params [
    ["_vehicle", objNull, [objNull]],
    ["_guardGroup", grpNull, [grpNull]],
    ["_hvtUnit", objNull, [objNull]],
    ["_originPos", [0,0,0], [[]]]
];

if (isNull _vehicle || {isNull _guardGroup} || {isNull _hvtUnit}) exitWith {[[], false, false, grpNull]};

private _hvtDebug = missionNamespace getVariable ["GOL_HVT_Debug", false];

private _guards = (units _guardGroup) select {alive _x};
private _crewPool = +_guards;

private _driverSeats = _vehicle emptyPositions "driver";
private _commanderSeats = _vehicle emptyPositions "commander";
private _gunnerSeats = _vehicle emptyPositions "gunner";
private _cargoSeats = _vehicle emptyPositions "cargo";

_guardGroup addVehicle _vehicle;

if (_hvtDebug) then {
    format [
        "[INTERCEPT HVT][MOUNT_MAIN] Begin. veh=%1 guards=%2 origin=%3",
        typeOf _vehicle,
        count _guards,
        _originPos
    ] call OKS_fnc_LogDebug;
};

// Prevent HVT from opportunistically taking crew seats.
[_hvtUnit] allowGetIn false;

if (_driverSeats <= 0 || {_cargoSeats <= 0}) exitWith {
    if (_hvtDebug) then {
        format ["[INTERCEPT HVT] Mount skipped: vehicle %1 has invalid seat layout driver=%2 cargo=%3", typeOf _vehicle, _driverSeats, _cargoSeats] call OKS_fnc_LogDebug;
    };
    [_guards, false, false, grpNull]
};

private _takeCrewFn = {
    params ["_pool"];
    if (_pool isEqualTo []) exitWith {[objNull, _pool]};
    private _u = _pool deleteAt 0;
    [_u, _pool]
};

private _assignedDriver = objNull;
if (isNull driver _vehicle) then {
    private _pick = [_crewPool] call _takeCrewFn;
    _pick params ["_driver", "_remaining"];
    _crewPool = _remaining;
    if (!isNull _driver) then {
        _assignedDriver = _driver;
        _assignedDriver enableAI "PATH";
        _assignedDriver setBehaviour "AWARE";
        [_driver] allowGetIn true;
        _driver assignAsDriver _vehicle;
        [_driver] orderGetIn true;
        _driver doMove (getPosATL _vehicle);
        _driver setVariable ["OKS_InterceptHvt_DriverAssigned", true];

        if (_hvtDebug) then {
            format [
                "[INTERCEPT HVT][MOUNT_MAIN] Driver assigned=%1 distToVeh=%2",
                _assignedDriver,
                round (_assignedDriver distance2D _vehicle)
            ] call OKS_fnc_LogDebug;
        };
    };
};

if (_commanderSeats > 0 && {isNull commander _vehicle}) then {
    private _pick = [_crewPool] call _takeCrewFn;
    _pick params ["_commander", "_remaining"];
    _crewPool = _remaining;
    if (!isNull _commander) then {
        [_commander] allowGetIn true;
        _commander assignAsCommander _vehicle;
        [_commander] orderGetIn true;
    };
};

if (_gunnerSeats > 0 && {isNull gunner _vehicle}) then {
    private _pick = [_crewPool] call _takeCrewFn;
    _pick params ["_gunner", "_remaining"];
    _crewPool = _remaining;
    if (!isNull _gunner) then {
        [_gunner] allowGetIn true;
        _gunner assignAsGunner _vehicle;
        [_gunner] orderGetIn true;
    };
};

private _hvtInVehicle = false;
if (_cargoSeats > 0) then {
    [_hvtUnit] allowGetIn true;
    _hvtUnit assignAsCargo _vehicle;
    [_hvtUnit] orderGetIn true;
};

private _overflow = [];
private _guardCargoSlots = ((_cargoSeats - 1) max 0);
private _assignedGuardCargo = 0;
{
    if (_assignedGuardCargo < _guardCargoSlots) then {
        [_x] allowGetIn true;
        _x assignAsCargo _vehicle;
        [_x] orderGetIn true;
        _assignedGuardCargo = _assignedGuardCargo + 1;
    } else {
        _overflow pushBack _x;
    };
} forEach _crewPool;

// Overflow guards get one shared isolated group so they stay together
// and are not dragged along by the vehicle crew's group AI.
private _overflowGroup = grpNull;
if (_overflow isNotEqualTo []) then {
    _overflowGroup = createGroup [side _guardGroup, true];
    if (_hvtDebug) then {
        format ["[INTERCEPT HVT][MOUNT_MAIN] Overflow group created. units=%1", count _overflow] call OKS_fnc_LogDebug;
    };
};

{
    unassignVehicle _x;
    _x leaveVehicle _vehicle;
    [_x] join _overflowGroup;
    _x enableAI "PATH";
    _x setBehaviour "AWARE";
} forEach _overflow;

private _mountTimeout = time + 45;
private _lastMountLog = time;
waitUntil {
    sleep 0.5;

    private _driverMountedNow = !isNull driver _vehicle && {alive driver _vehicle} && {(driver _vehicle) in _guards};
    _hvtInVehicle = vehicle _hvtUnit == _vehicle;

    if (_hvtDebug && {time >= _lastMountLog}) then {
        _lastMountLog = time + 5;
        private _drv = driver _vehicle;
        format [
            "[INTERCEPT HVT][MOUNT_MAIN] WaitTick. assignedDriver=%1 mounted=%2 currentDriver=%3 hvtMounted=%4 tLeft=%5",
            _assignedDriver,
            _driverMountedNow,
            _drv,
            _hvtInVehicle,
            round (_mountTimeout - time)
        ] call OKS_fnc_LogDebug;
    };

    (time >= _mountTimeout) || (_driverMountedNow && _hvtInVehicle)
};

// Force-claim driver seat for the assigned guard if natural boarding failed (e.g. stuck in building).
if (!isNull _assignedDriver && {alive _assignedDriver} && {driver _vehicle != _assignedDriver}) then {
    if (_hvtDebug) then {
        format ["[INTERCEPT HVT] Force-claiming driver seat for %1 via moveInDriver.", _assignedDriver] call OKS_fnc_LogDebug;
    };

    private _currentDriver = driver _vehicle;
    if (!isNull _currentDriver && {_currentDriver != _assignedDriver}) then {
        [_currentDriver] allowGetIn false;
        _currentDriver leaveVehicle _vehicle;
        moveOut _currentDriver;
        unassignVehicle _currentDriver;
    };

    unassignVehicle _assignedDriver;
    _assignedDriver moveInDriver _vehicle;

    if (_hvtDebug) then {
        format ["[INTERCEPT HVT][MOUNT_MAIN] Post force-claim driver=%1 assigned=%2", driver _vehicle, _assignedDriver] call OKS_fnc_LogDebug;
    };
};

// If assigned driver still failed, claim any alive guard as driver to avoid full mission fallback.
if (isNull driver _vehicle || {!(driver _vehicle in _guards)} || {!alive driver _vehicle}) then {
    private _fallbackDriver = (units _guardGroup) findIf {
        alive _x &&
        {_x in _guards} &&
        {vehicle _x == _x}
    };

    if (_fallbackDriver >= 0) then {
        private _fbDriverUnit = (units _guardGroup) select _fallbackDriver;
        [_fbDriverUnit] allowGetIn true;
        _fbDriverUnit assignAsDriver _vehicle;
        [_fbDriverUnit] orderGetIn true;
        _fbDriverUnit moveInDriver _vehicle;

        if (_hvtDebug) then {
            format ["[INTERCEPT HVT][MOUNT_MAIN] Fallback driver claimed: %1", _fbDriverUnit] call OKS_fnc_LogDebug;
        };
    } else {
        if (_hvtDebug) then {
            "[INTERCEPT HVT][MOUNT_MAIN] No fallback driver candidate available." call OKS_fnc_LogDebug;
        };
    };
};

if (alive _hvtUnit && {vehicle _hvtUnit != _vehicle}) then {
    if (_hvtDebug) then {
        "[INTERCEPT HVT] Force-mounting HVT via moveInCargo." call OKS_fnc_LogDebug;
    };
    unassignVehicle _hvtUnit;
    _hvtUnit moveInCargo _vehicle;
};

private _driverMounted = !isNull driver _vehicle && {alive driver _vehicle} && {(driver _vehicle) in _guards};
_hvtInVehicle = vehicle _hvtUnit == _vehicle;

if (_hvtDebug && {!isNull _assignedDriver} && {_driverMounted} && {driver _vehicle != _assignedDriver}) then {
    format ["[INTERCEPT HVT][MOUNT_MAIN] Assigned driver failed; proceeding with alternate driver %1", driver _vehicle] call OKS_fnc_LogDebug;
};

private _hvtRole = assignedVehicleRole _hvtUnit;
private _hvtCargoMounted = _hvtInVehicle && {count _hvtRole > 0} && {(_hvtRole select 0) == "Cargo"};

if (_hvtInVehicle && {!_hvtCargoMounted}) then {
    if (_hvtDebug) then {
        format ["[INTERCEPT HVT] HVT mounted in invalid seat role=%1. Forcing dismount/fallback.", _hvtRole] call OKS_fnc_LogDebug;
    };
    [_hvtUnit] allowGetIn false;
    moveOut _hvtUnit;
    unassignVehicle _hvtUnit;
    _hvtCargoMounted = false;
};

if (_hvtDebug) then {
    format [
        "[INTERCEPT HVT][MOUNT_MAIN] Result: vehicle=%1 driverMounted=%2 hvtCargoMounted=%3 overflow=%4 cargoSeats=%5",
        typeOf _vehicle,
        _driverMounted,
        _hvtCargoMounted,
        count _overflow,
        _cargoSeats
    ] call OKS_fnc_LogDebug;
};

[_overflow, _hvtCargoMounted, _driverMounted, _overflowGroup];