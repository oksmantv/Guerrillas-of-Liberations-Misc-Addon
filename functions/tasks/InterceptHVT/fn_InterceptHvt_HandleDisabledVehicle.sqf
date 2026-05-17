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
        _vehicle lock 0;
        {
            if (alive _x && {vehicle _x == _vehicle}) then {
                _x setVariable ["OKS_InterceptHvt_ShouldExit", true];
                [_x] allowGetIn false;
                _x leaveVehicle _vehicle;
                moveOut _x;
                unassignVehicle _x;
                _x setBehaviour "AWARE";
                _x enableAI "PATH";
                _x enableAI "FSM";
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

        // When the main convoy vehicle is first disabled, redirect each overflow team to a
        // unique spread position around the ambush site. Without this, all teams drive to the
        // same road waypoint and pile their vehicles at the garrison entrance.
        if (!(_vehicle getVariable ["OKS_InterceptHvt_OverflowRedirected", false])) then {
            _vehicle setVariable ["OKS_InterceptHvt_OverflowRedirected", true];
            private _overflowGroups = _hvtUnit getVariable ["OKS_InterceptHvt_OverflowGroups", []];
            if (_overflowGroups isNotEqualTo []) then {
                private _disabledPos = getPos _vehicle;
                private _groupCount = count _overflowGroups;
                {
                    private _og = _x;
                    if (!isNull _og && {(units _og) isNotEqualTo []}) then {
                        // Spread teams evenly around the compass, 80-120 m from the disabled vehicle.
                        private _spreadAngle = _forEachIndex * (360 / _groupCount);
                        private _offsetPos = [_disabledPos, 80 + random 40, _spreadAngle] call BIS_fnc_relPos;
                        private _roads = _offsetPos nearRoads 60;
                        if (_roads isNotEqualTo []) then { _offsetPos = getPos (_roads select 0); };
                        [_og] call OKS_fnc_ClearWaypoints;
                        private _wp = _og addWaypoint [_offsetPos, 0];
                        _wp setWaypointType "MOVE";
                        _wp setWaypointBehaviour "COMBAT";
                        _wp setWaypointCombatMode "RED";
                        _wp setWaypointSpeed "FULL";
                        _og setCurrentWaypoint _wp;
                    };
                } forEach _overflowGroups;
            };
        };
    };

    _disabled
};