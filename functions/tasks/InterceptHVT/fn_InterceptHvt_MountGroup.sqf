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

// Prevent HVT from opportunistically entering a crew seat on its own.
[_hvtUnit] allowGetIn false;

if (_driverSeats <= 0 || {_cargoSeats <= 0}) exitWith {
    if (_hvtDebug) then {
        format ["[INTERCEPT HVT] Mount skipped: vehicle %1 has invalid seat layout driver=%2 cargo=%3", typeOf _vehicle, _driverSeats, _cargoSeats] call OKS_fnc_LogDebug;
    };
    [_guards, false, false, grpNull]
};

// Route guards out of buildings before issuing board commands.
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

// Seat the HVT in a cargo slot immediately, before any guard boards.
// This guarantees the HVT lands in cargo without an index assignment that
// could later cause the AI to reseat itself and vacate the vehicle.
[_hvtUnit] allowGetIn true;
_hvtUnit moveInCargo _vehicle;
[_hvtUnit] allowGetIn false;

if (_hvtDebug) then {
    format ["[INTERCEPT HVT][MOUNT_MAIN] HVT moved into cargo. inVehicle=%1", vehicle _hvtUnit == _vehicle] call OKS_fnc_LogDebug;
};

// Split guards into boarding (fit in vehicle) and overflow (excess).
// One cargo seat is reserved for the HVT; guard capacity = driver + commander + gunner + (cargo - 1).
private _guardCapacity = _driverSeats + _commanderSeats + _gunnerSeats + ((_cargoSeats - 1) max 0);
private _overflow = [];
private _overflowGroup = grpNull;
private _boardingGuards = [];

if (count _guards > _guardCapacity) then {
    _boardingGuards = _guards select [0, _guardCapacity];
    _overflow = _guards select [_guardCapacity, (count _guards) - _guardCapacity];
    _overflowGroup = createGroup [side _guardGroup, true];
    if (_hvtDebug) then {
        format ["[INTERCEPT HVT][MOUNT_MAIN] Overflow group created. units=%1", count _overflow] call OKS_fnc_LogDebug;
    };
    {
        unassignVehicle _x;
        [_x] join _overflowGroup;
        _x enableAI "PATH";
        _x setBehaviour "AWARE";
        doStop _x;
    } forEach _overflow;
} else {
    _boardingGuards = _guards;
};

// Allow all boarding guards to enter the vehicle.
{ [_x] allowGetIn true; } forEach _boardingGuards;

// GETIN NEAREST with no explicit seat assignments.
// assignAsX roles cause guards to leave when their assigned seat doesn't match
// their actual seat; letting GETIN NEAREST pick seats avoids that entirely.
_guardGroup setBehaviour "AWARE";
_guardGroup setSpeedMode "FULL";
private _getInWp = _guardGroup addWaypoint [getPosATL _vehicle, 0];
_getInWp setWaypointType "GETIN NEAREST";
_getInWp setWaypointBehaviour "AWARE";
_getInWp setWaypointSpeed "FULL";

// Hold the vehicle in place until the HVT is confirmed aboard.
_vehicle forceSpeed 0;

private _hvtInVehicle = false;
private _mountTimeout = time + 45;
private _lastMountLog = time;
waitUntil {
    sleep 0.5;
    _hvtInVehicle = vehicle _hvtUnit == _vehicle;
    private _allBoarded = (_boardingGuards select {alive _x && {vehicle _x != _vehicle}}) isEqualTo [];
    if (_hvtInVehicle) then { _vehicle forceSpeed _convoySpeedMS; };
    if (_hvtDebug && {time >= _lastMountLog}) then {
        _lastMountLog = time + 5;
        format [
            "[INTERCEPT HVT][MOUNT_MAIN] WaitTick. driver=%1 hvt=%2 notBoarded=%3 tLeft=%4",
            (!isNull (driver _vehicle) && {alive (driver _vehicle)} && {(driver _vehicle) in _guards}),
            _hvtInVehicle,
            {alive _x && {vehicle _x != _vehicle}} count _boardingGuards,
            round (_mountTimeout - time)
        ] call OKS_fnc_LogDebug;
    };
    (time >= _mountTimeout) || (_allBoarded && _hvtInVehicle)
};

// Always restore convoy speed — covers the timeout path.
_vehicle forceSpeed _convoySpeedMS;

// Force-mount any boarding guard still on foot after timeout.
{
    if (alive _x && {vehicle _x != _vehicle}) then {
        _x moveInCargo _vehicle;
        if (_hvtDebug) then {
            format ["[INTERCEPT HVT][MOUNT_MAIN] Force-mounted guard %1 into cargo.", _x] call OKS_fnc_LogDebug;
        };
    };
} forEach _boardingGuards;

// Force-mount HVT if it dismounted during the wait.
_hvtInVehicle = vehicle _hvtUnit == _vehicle;
if (alive _hvtUnit && {!_hvtInVehicle}) then {
    if (_hvtDebug) then {
        "[INTERCEPT HVT] Force-mounting HVT via moveInCargo." call OKS_fnc_LogDebug;
    };
    [_hvtUnit] allowGetIn true;
    _hvtUnit moveInCargo _vehicle;
    [_hvtUnit] allowGetIn false;
    _hvtInVehicle = true;
};

// Disable FSM on cargo guards only — not the driver (needs FSM to navigate)
// and not the HVT (needs FSM for surrender/exit logic).
{
    _x params ["_occupant", "_role", "_cargoIdx"];
    if (!isNull _occupant && {alive _occupant} && {toLowerANSI _role == "cargo"} && {_occupant != _hvtUnit}) then {
        _occupant disableAI "FSM";
    };
} forEach (fullCrew _vehicle);

// Lock the vehicle to prevent voluntary exit.
_vehicle lock 2;

private _driverMounted = !isNull (driver _vehicle) && {alive (driver _vehicle)} && {(driver _vehicle) in _guards};
private _hvtCargoMounted = _hvtInVehicle && {
    driver _vehicle != _hvtUnit &&
    {commander _vehicle != _hvtUnit} &&
    {gunner _vehicle != _hvtUnit}
};

// Safety net: any boarding guard still on foot gets a direct cargo seat.
{
    if (alive _x && {vehicle _x == _x}) then {
        _x moveInCargo _vehicle;
        _x disableAI "FSM";
        if (_hvtDebug) then {
            format ["[INTERCEPT HVT][MOUNT_MAIN] Guard %1 left on foot post-mount; force-seated in main vehicle cargo.", _x] call OKS_fnc_LogDebug;
        };
    };
} forEach _boardingGuards;

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
