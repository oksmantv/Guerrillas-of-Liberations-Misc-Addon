/*
    [vehicle, guardGroup, hvtUnit, originPos] call OKS_fnc_InterceptHvt_MountGroup;
    Returns: [overflowGuards, hvtInVehicle, driverMounted, overflowGroup]
*/
params [
    ["_vehicle", objNull, [objNull]],
    ["_guardGroup", grpNull, [grpNull]],
    ["_hvtUnit", objNull, [objNull]],
    ["_originPos", [0,0,0], [[]]],
    ["_convoySpeedMS", -1, [0]]
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

// Route guards out of buildings before issuing board commands.
// Leader moves to building exit; non-leaders follow leader out.
{
    _x setUnitPos "AUTO";
    _x enableAI "PATH";
    _x enableAI "FSM";
    if (_x == leader _guardGroup) then {
        _x doMove ((nearestBuilding (getPos _x)) buildingExit 0);
    } else {
        doStop _x;
        _x doFollow (leader _guardGroup);
    };
} forEach _guards;

// HVT is in its own group and is not covered by the guard forEach above.
// Route it out of any building it may be standing in before we issue orderGetIn.
_hvtUnit setUnitPos "AUTO";
_hvtUnit enableAI "PATH";
_hvtUnit enableAI "FSM";
private _hvtBuilding = nearestBuilding (getPos _hvtUnit);
if (!isNull _hvtBuilding && {_hvtBuilding distance2D _hvtUnit < 30}) then {
    _hvtUnit doMove (_hvtBuilding buildingExit 0);
};

if (_hvtDebug) then {
    "[INTERCEPT HVT][MOUNT_MAIN] Building exit issued. Waiting for guards and HVT to clear." call OKS_fnc_LogDebug;
};
sleep 10;

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

private _assignedCommander = objNull;
if (_commanderSeats > 0 && {isNull commander _vehicle}) then {
    private _pick = [_crewPool] call _takeCrewFn;
    _pick params ["_commander", "_remaining"];
    _crewPool = _remaining;
    if (!isNull _commander) then {
        _assignedCommander = _commander;
        [_commander] allowGetIn true;
        _commander assignAsCommander _vehicle;
        [_commander] orderGetIn true;
    };
};

private _assignedGunner = objNull;
if (_gunnerSeats > 0 && {isNull gunner _vehicle}) then {
    private _pick = [_crewPool] call _takeCrewFn;
    _pick params ["_gunner", "_remaining"];
    _crewPool = _remaining;
    if (!isNull _gunner) then {
        _assignedGunner = _gunner;
        [_gunner] allowGetIn true;
        _gunner assignAsGunner _vehicle;
        [_gunner] orderGetIn true;
    };
};

// Pick a random cargo index for the HVT so it gets a stable specific seat.
// Guards do not get an explicit cargo assignment; GETIN NEAREST puts them wherever
// there is room and the specific slot is irrelevant as long as they are aboard.
private _hvtCargoIndex = floor (random (_cargoSeats max 1));
private _hvtInVehicle = false;
if (_cargoSeats > 0) then {
    [_hvtUnit] allowGetIn true;
    _hvtUnit assignAsCargoIndex [_vehicle, _hvtCargoIndex];
    [_hvtUnit] orderGetIn true;
};

private _overflow = [];
private _assignedCargo = [];
private _guardCargoSlots = ((_cargoSeats - 1) max 0);
private _assignedGuardCargo = 0;
{
    if (_assignedGuardCargo < _guardCargoSlots) then {
        [_x] allowGetIn true;
        [_x] orderGetIn true;
        _assignedGuardCargo = _assignedGuardCargo + 1;
        _assignedCargo pushBack _x;
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
    doStop _x; // Cancel doFollow toward main vehicle leader before overflow handling takes over.
} forEach _overflow;

// Give the guard group a GETIN waypoint so all assigned members actively move to board.
_guardGroup setBehaviour "AWARE";
_guardGroup setSpeedMode "FULL";
private _getInWp = _guardGroup addWaypoint [getPosATL _vehicle, 0];
_getInWp setWaypointType "GETIN NEAREST";
_getInWp setWaypointBehaviour "AWARE";
_getInWp setWaypointSpeed "FULL";

// Hold the vehicle in place until the HVT is confirmed aboard.
// forceSpeed -1 releases the cap once he boards (or on timeout fallback).
_vehicle forceSpeed 0;

private _mountTimeout = time + 90;
private _lastMountLog = time;
waitUntil {
    sleep 0.5;

    private _driverMountedNow = !isNull driver _vehicle && {alive driver _vehicle} && {(driver _vehicle) in _guards};
    _hvtInVehicle = vehicle _hvtUnit == _vehicle;
    private _commanderMountedNow = isNull _assignedCommander || {!alive _assignedCommander} || {vehicle _assignedCommander == _vehicle};
    private _gunnerMountedNow = isNull _assignedGunner || {!alive _assignedGunner} || {vehicle _assignedGunner == _vehicle};
    private _cargoMountedNow = (_assignedCargo select {alive _x && {vehicle _x != _vehicle}}) isEqualTo [];

    if (_hvtInVehicle) then { _vehicle forceSpeed _convoySpeedMS; };

    if (_hvtDebug && {time >= _lastMountLog}) then {
        _lastMountLog = time + 5;
        format [
            "[INTERCEPT HVT][MOUNT_MAIN] WaitTick. driver=%1 hvt=%2 commander=%3 gunner=%4 cargo=%5 tLeft=%6",
            _driverMountedNow,
            _hvtInVehicle,
            _commanderMountedNow,
            _gunnerMountedNow,
            _cargoMountedNow,
            round (_mountTimeout - time)
        ] call OKS_fnc_LogDebug;
    };

    (time >= _mountTimeout) || (_driverMountedNow && _hvtInVehicle && _commanderMountedNow && _gunnerMountedNow && _cargoMountedNow)
};

// Always restore convoy speed — covers the timeout path where HVT was force-mounted below.
_vehicle forceSpeed _convoySpeedMS;

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

// Force-mount any assigned crew who didn't board naturally before driver+HVT were seated.
if (!isNull _assignedCommander && {alive _assignedCommander} && {vehicle _assignedCommander != _vehicle}) then {
    if (_hvtDebug) then {
        format ["[INTERCEPT HVT][MOUNT_MAIN] Force-mounting commander %1 via moveInCommander.", _assignedCommander] call OKS_fnc_LogDebug;
    };
    unassignVehicle _assignedCommander;
    _assignedCommander moveInCommander _vehicle;
};

if (!isNull _assignedGunner && {alive _assignedGunner} && {vehicle _assignedGunner != _vehicle}) then {
    if (_hvtDebug) then {
        format ["[INTERCEPT HVT][MOUNT_MAIN] Force-mounting gunner %1 via moveInGunner.", _assignedGunner] call OKS_fnc_LogDebug;
    };
    unassignVehicle _assignedGunner;
    _assignedGunner moveInGunner _vehicle;
};

{
    if (alive _x && {vehicle _x != _vehicle}) then {
        if (_hvtDebug) then {
            format ["[INTERCEPT HVT][MOUNT_MAIN] Force-mounting cargo guard %1 via moveInCargo.", _x] call OKS_fnc_LogDebug;
        };
        unassignVehicle _x;
        _x moveInCargo _vehicle;
    };
} forEach _assignedCargo;

private _driverMounted = !isNull driver _vehicle && {alive driver _vehicle} && {(driver _vehicle) in _guards};
_hvtInVehicle = vehicle _hvtUnit == _vehicle;

if (_hvtDebug && {!isNull _assignedDriver} && {_driverMounted} && {driver _vehicle != _assignedDriver}) then {
    format ["[INTERCEPT HVT][MOUNT_MAIN] Assigned driver failed; proceeding with alternate driver %1", driver _vehicle] call OKS_fnc_LogDebug;
};

// Check actual seat rather than assigned role: assignedVehicleRole returns nothing
// after a moveInCargo force-mount (unassignVehicle clears it), which would cause a
// false dismount. We only care that the HVT is not sitting in a crew seat.
private _hvtCargoMounted = _hvtInVehicle && {
    driver _vehicle != _hvtUnit &&
    {commander _vehicle != _hvtUnit} &&
    {gunner _vehicle != _hvtUnit}
};

if (_hvtInVehicle && {!_hvtCargoMounted}) then {
    if (_hvtDebug) then {
        format ["[INTERCEPT HVT] HVT in crew seat. Forcing dismount/fallback. driver=%1 cmdr=%2 gunner=%3",
            driver _vehicle == _hvtUnit,
            commander _vehicle == _hvtUnit,
            gunner _vehicle == _hvtUnit
        ] call OKS_fnc_LogDebug;
    };
    [_hvtUnit] allowGetIn false;
    moveOut _hvtUnit;
    unassignVehicle _hvtUnit;
    _hvtCargoMounted = false;
};

// Re-assign every cargo occupant to their actual cargo slot. Without this, the AI
// compares its assigned role against its actual seat and voluntarily exits to reshuffle.
{
    _x params ["_occupant", "_role", "_cargoIdx"];
    if (!isNull _occupant && {alive _occupant} && {toLowerANSI _role == "cargo"}) then {
        _occupant assignAsCargoIndex [_vehicle, _cargoIdx];
        // Disable FSM on cargo guards so they cannot autonomously decide to exit the vehicle.
        // The HVT keeps FSM enabled so its surrender/exit logic still fires.
        if (_occupant != _hvtUnit) then {
            _occupant disableAI "FSM";
        };
    };
} forEach (fullCrew _vehicle);

// Lock the vehicle so AI cannot voluntarily exit to reshuffle seats en route.
// Unlocked by HandleDisabledVehicle on disable/ambush, or by the task before garrison.
_vehicle lock 2;

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