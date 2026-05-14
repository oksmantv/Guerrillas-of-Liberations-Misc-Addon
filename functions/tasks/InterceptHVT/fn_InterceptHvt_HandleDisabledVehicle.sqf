/*
    [vehicle, guardGroup, hvtUnit] spawn OKS_fnc_InterceptHvt_HandleDisabledVehicle;
*/
params [
    ["_vehicle", objNull, [objNull]],
    ["_guardGroup", grpNull, [grpNull]],
    ["_hvtUnit", objNull, [objNull]]
];

if (isNull _vehicle || {isNull _guardGroup}) exitWith {};

_vehicle allowCrewInImmobile true;

private _isFrontWheelDisabledFn = {
    params ["_veh"];
    private _hitData = getAllHitPointsDamage _veh;
    if (_hitData isEqualTo [] || {count _hitData < 3}) exitWith {false};

    _hitData params ["_names", "_selections", "_damages"];

    private _frontWheelDamage = [];
    {
        private _name = toLower _x;
        if (
            (_name find "wheel_1_1") >= 0 ||
            (_name find "wheel_2_1") >= 0 ||
            (_name find "front") >= 0
        ) then {
            _frontWheelDamage pushBack (_damages select _forEachIndex);
        };
    } forEach _names;

    if (_frontWheelDamage isEqualTo []) exitWith {false};
    ({_x >= 0.95} count _frontWheelDamage) > 0
};

waitUntil {
    sleep 1;

    if (_hvtUnit getVariable ["OKS_InterceptHvt_InGarrison", false]) exitWith {true};

    if (isNull _vehicle || {!alive _vehicle}) exitWith {true};

    private _driverInvalid = isNull driver _vehicle || {!alive driver _vehicle};
    private _disabled = (!canMove _vehicle) || _driverInvalid || ([_vehicle] call _isFrontWheelDisabledFn);

    if (_disabled) then {
        {
            if (alive _x && {vehicle _x == _vehicle}) then {
                [_x] allowGetIn false;
                _x leaveVehicle _vehicle;
                moveOut _x;
                unassignVehicle _x;
                _x setBehaviour "AWARE";
                _x enableAI "PATH";
            };
        } forEach (units _guardGroup);

        if (alive _hvtUnit) then {
            private _allowExit = _hvtUnit getVariable ["OKS_InterceptHvt_AllowExit", false];
            private _criticalVehicle = (!alive _vehicle) || {damage _vehicle >= 0.85};

            if (vehicle _hvtUnit == _vehicle) then {
                if (_allowExit || _criticalVehicle) then {
                    [_hvtUnit] allowGetIn false;
                    _hvtUnit leaveVehicle _vehicle;
                    doGetOut _hvtUnit;
                    unassignVehicle _hvtUnit;
                } else {
                    [_hvtUnit] allowGetIn true;
                    _hvtUnit assignAsCargo _vehicle;
                    _hvtUnit setBehaviour "CARELESS";
                    _hvtUnit disableAI "PATH";
                };
            } else {
                if !(_allowExit || _criticalVehicle) then {
                    [_hvtUnit] allowGetIn true;
                    _hvtUnit assignAsCargo _vehicle;
                    [_hvtUnit] orderGetIn true;
                } else {
                    _hvtUnit disableAI "PATH";
                    _hvtUnit setUnitPos "MIDDLE";
                };
            };
        };
    };

    _disabled
};