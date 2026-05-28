/*
    [spawnPos, designatedVehicle, guardGroup, hvtUnit, radius] call OKS_fnc_InterceptHvt_SelectVehicle;
*/
params [
    ["_spawnPos", [0,0,0], [[]]],
    ["_designatedVehicle", objNull, [objNull]],
    ["_guardGroup", grpNull, [grpNull]],
    ["_hvtUnit", objNull, [objNull]],
    ["_radius", 250, [0]]
];

private _hvtDebug = missionNamespace getVariable ["GOL_HVT_Debug", false];

private _guardSeatsNeeded = {alive _x} count (units _guardGroup);
private _groupUnits = if (isNull _guardGroup) then {[]} else {(units _guardGroup) select {alive _x}};

private _seatCountFn = {
    params ["_veh"];

    private _driverSeats = _veh emptyPositions "driver";
    private _commanderSeats = _veh emptyPositions "commander";
    private _gunnerSeats = _veh emptyPositions "gunner";
    private _cargoSeats = _veh emptyPositions "cargo";
    private _guardUsableSeats = _driverSeats + _commanderSeats + _gunnerSeats + ((_cargoSeats - 1) max 0);
    private _hasHvtCargoSeat = _cargoSeats > 0;

    [_guardUsableSeats, _hasHvtCargoSeat]
};

private _isValidVehicleFn = {
    params ["_veh"];
    !isNull _veh && {alive _veh} && {canMove _veh}
};

private _isCrewCompatibleFn = {
    params ["_veh", "_allowedCrew"];
    private _aliveCrew = (crew _veh) select {alive _x};
    (_aliveCrew select { !(_x in _allowedCrew) }) isEqualTo []
};

private _useDesignated = false;
if ([_designatedVehicle] call _isValidVehicleFn) then {
    private _designatedSeats = [_designatedVehicle] call _seatCountFn;
    _designatedSeats params ["_designatedGuardSeats", "_designatedHasHvtCargo"];
    if (
        _designatedHasHvtCargo &&
        {_designatedGuardSeats > 0} &&
        {[_designatedVehicle, _groupUnits] call _isCrewCompatibleFn}
    ) then {
        _useDesignated = true;
    };
};

if (_useDesignated) exitWith {
    if (_hvtDebug) then {
        format ["[INTERCEPT HVT][SELECT_VEH] Using designated vehicle %1", typeOf _designatedVehicle] call OKS_fnc_LogDebug;
    };
    _designatedVehicle setVariable ["OKS_InterceptHvt_Reserved", true, true];
    _designatedVehicle
};

private _candidates = nearestObjects [_spawnPos, ["LandVehicle"], _radius, true];
_candidates = _candidates select {
    ([_x] call _isValidVehicleFn) &&
    {(locked _x) != 2} &&
    {!(_x getVariable ["OKS_InterceptHvt_Reserved", false])} &&
    {[_x, _groupUnits] call _isCrewCompatibleFn}
};

if (_candidates isEqualTo []) exitWith {
    if (_hvtDebug) then {
        format ["[INTERCEPT HVT][SELECT_VEH] No candidate vehicles. radius=%1 guardSeatsNeeded=%2", _radius, _guardSeatsNeeded] call OKS_fnc_LogDebug;
    };
    objNull
};

if (_hvtDebug) then {
    format ["[INTERCEPT HVT][SELECT_VEH] Candidates=%1 guardSeatsNeeded=%2", count _candidates, _guardSeatsNeeded] call OKS_fnc_LogDebug;
};

private _bestVehicle = objNull;
private _bestSeats = -1;
private _bestVehicleEnough = objNull;
private _bestSeatsEnough = -1;

{
    private _seats = [_x] call _seatCountFn;
    _seats params ["_guardSeats", "_hasHvtCargo"];

    if (!_hasHvtCargo) then {
        continue;
    };

    if (_guardSeats > _bestSeats) then {
        _bestSeats = _guardSeats;
        _bestVehicle = _x;
    };

    if (_guardSeats >= _guardSeatsNeeded && {_guardSeats > _bestSeatsEnough}) then {
        _bestSeatsEnough = _guardSeats;
        _bestVehicleEnough = _x;
    };
} forEach _candidates;

if (!isNull _bestVehicleEnough) exitWith {
    _bestVehicleEnough setVariable ["OKS_InterceptHvt_Reserved", true, true];
    _bestVehicleEnough
};

if (_hvtDebug) then {
    format ["[INTERCEPT HVT][SELECT_VEH] Selected=%1 bestSeats=%2", typeOf _bestVehicle, _bestSeats] call OKS_fnc_LogDebug;
};
if (!isNull _bestVehicle) then {
    _bestVehicle setVariable ["OKS_InterceptHvt_Reserved", true, true];
};
_bestVehicle;