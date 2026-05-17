/*
    [hvtUnit] call OKS_fnc_InterceptHvt_SetHvtSurrendered;
*/
params [["_hvtUnit", objNull, [objNull]]];
if (isNull _hvtUnit || {!alive _hvtUnit}) exitWith {false};
if (_hvtUnit getVariable ["OKS_InterceptHvt_Surrendered", false]) exitWith {true};

private _hvtDebug = missionNamespace getVariable ["GOL_HVT_Debug", false];

_hvtUnit setVariable ["OKS_InterceptHvt_Surrendered", true, true];
_hvtUnit setVariable ["OKS_InterceptHvt_AllowExit", true, true];
_hvtUnit setCaptive true;

// Immediately redirect all overflow groups to SAD at the HVT's current position.
// Runs unconditionally so it works whether the HVT is mounted or on foot.
private _sadRallyPos = getPosATL (if (vehicle _hvtUnit != _hvtUnit) then {vehicle _hvtUnit} else {_hvtUnit});
{
    private _grp = _x;
    if (!isNull _grp && {(units _grp) isNotEqualTo []}) then {
        [_grp] call OKS_fnc_ClearWaypoints;
        private _sadWp = _grp addWaypoint [_sadRallyPos, 0];
        _sadWp setWaypointType "SAD";
        _sadWp setWaypointBehaviour "COMBAT";
        _sadWp setWaypointCombatMode "RED";
        _grp setCurrentWaypoint _sadWp;
    };
} forEach (_hvtUnit getVariable ["OKS_InterceptHvt_OverflowGroups", []]);

private _aceFnName = ["ACE", "captives", "fnc", "setSurrendered"] joinString "_";
private _aceSetSurrendered = missionNamespace getVariable [_aceFnName, {}];

if (vehicle _hvtUnit != _hvtUnit) then {
    private _veh = vehicle _hvtUnit;

    if (_hvtDebug) then {
        format ["[INTERCEPT HVT] Surrender triggered while mounted. Waiting for safer dismount speed. Veh=%1 speed=%2", typeOf _veh, round (speed _veh)] call OKS_fnc_LogDebug;
    };

    [_hvtUnit, _veh, _hvtDebug, _aceSetSurrendered] spawn {
        params ["_hvt", "_veh", "_hvtDebug", "_aceSetSurrendered"];

        if (isNull _veh || {!alive _hvt}) exitWith {};

        // Disarm the HVT and transfer weapons into the vehicle cargo.
        _hvt setVariable ["GOL_ThrownWeaponOnGround", true, true];
        [_hvt, _veh, false] spawn OKS_fnc_ThrowWeaponsOnGround;

        // Ask current crew to stop, then dismount non-HVT first so they can engage.
        {
            if (alive _x && {vehicle _x == _veh}) then {
                doStop _x;
                _x forceSpeed 0;
            };
        } forEach crew _veh;

        private _stopDeadline = time + 12;
        waitUntil {
            sleep 0.25;
            !alive _hvt ||
            isNull _veh ||
            !(alive _veh) ||
            (speed _veh <= 3) ||
            (time >= _stopDeadline)
        };

        private _ejectedGuards = [];
        {
            if (alive _x && {_x != _hvt} && {vehicle _x == _veh}) then {
                _x setVariable ["OKS_InterceptHvt_ShouldExit", true];
                [_x] allowGetIn false;
                _x leaveVehicle _veh;
                doGetOut _x;
                unassignVehicle _x;
                _x enableAI "FSM";
                _x enableAI "PATH";
                _x setBehaviour "AWARE";
                _x setCombatMode "RED";
                _ejectedGuards pushBack _x;
            };
        } forEach crew _veh;

        private _safeExitDeadline = time + 8;
        waitUntil {
            sleep 0.25;
            !alive _hvt ||
            isNull _veh ||
            !(alive _veh) ||
            (vehicle _hvt != _veh) ||
            (speed _veh <= 1) ||
            (time >= _safeExitDeadline)
        };

        if (alive _hvt && {vehicle _hvt == _veh}) then {
            _hvt setVariable ["OKS_InterceptHvt_ShouldExit", true];
            [_hvt] allowGetIn false;
            _hvt leaveVehicle _veh;
            doGetOut _hvt;
            unassignVehicle _hvt;
            if (_hvtDebug) then {
                format ["[INTERCEPT HVT] HVT forced out on surrender. Exit speed=%1", round (speed _veh)] call OKS_fnc_LogDebug;
            };
        };

        // Clear stale waypoints and give a GUARD order at the HVT position so ejected guards
        // defend in place rather than scatter.
        if (_ejectedGuards isNotEqualTo []) then {
            private _guardGrp = group (_ejectedGuards select 0);
            [_guardGrp] call OKS_fnc_ClearWaypoints;
            private _guardWp = _guardGrp addWaypoint [getPosATL _hvt, 20];
            _guardWp setWaypointType "GUARD";
            _guardWp setWaypointBehaviour "AWARE";
            _guardWp setWaypointCombatMode "RED";
            _guardGrp setCurrentWaypoint _guardWp;
        };

        {
            if (alive _x) then {
                _x forceSpeed -1;
            };
        } forEach crew _veh;

        // Wait until the HVT has physically exited before triggering surrender animation.
        waitUntil {
            sleep 0.2;
            !alive _hvt || vehicle _hvt != _veh
        };

        if (alive _hvt) then {
            _hvt disableAI "PATH";
            _hvt setUnitPos "MIDDLE";
            if !(_aceSetSurrendered isEqualTo {}) then {
                [_hvt, true] call _aceSetSurrendered;
            };
            _hvt action ["Surrender", _hvt];
        };
    };
} else {
    // On foot — drop weapons to a ground holder.
    _hvtUnit setVariable ["GOL_ThrownWeaponOnGround", true, true];
    [_hvtUnit, objNull, false] spawn OKS_fnc_ThrowWeaponsOnGround;

    _hvtUnit disableAI "PATH";
    _hvtUnit setUnitPos "MIDDLE";
    if !(_aceSetSurrendered isEqualTo {}) then {
        [_hvtUnit, true] call _aceSetSurrendered;
    };
    _hvtUnit action ["Surrender", _hvtUnit];
};

true;