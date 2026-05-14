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
removeAllWeapons _hvtUnit;

if (vehicle _hvtUnit != _hvtUnit) then {
    private _veh = vehicle _hvtUnit;

    if (_hvtDebug) then {
        format ["[INTERCEPT HVT] Surrender triggered while mounted. Waiting for safer dismount speed. Veh=%1 speed=%2", typeOf _veh, round (speed _veh)] call OKS_fnc_LogDebug;
    };

    [_hvtUnit, _veh, _hvtDebug] spawn {
        params ["_hvt", "_veh", "_hvtDebug"];

        if (isNull _veh || {!alive _hvt}) exitWith {};

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

        {
            if (alive _x && {_x != _hvt} && {vehicle _x == _veh}) then {
                [_x] allowGetIn false;
                _x leaveVehicle _veh;
                doGetOut _x;
                unassignVehicle _x;
                _x enableAI "PATH";
                _x setBehaviour "AWARE";
                _x setCombatMode "RED";
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
            [_hvt] allowGetIn false;
            _hvt leaveVehicle _veh;
            doGetOut _hvt;
            unassignVehicle _hvt;
            if (_hvtDebug) then {
                format ["[INTERCEPT HVT] HVT forced out on surrender. Exit speed=%1", round (speed _veh)] call OKS_fnc_LogDebug;
            };
        };

        {
            if (alive _x) then {
                _x forceSpeed -1;
            };
        } forEach crew _veh;
    };
};

_hvtUnit disableAI "PATH";
_hvtUnit setUnitPos "MIDDLE";

private _aceFnName = ["ACE", "captives", "fnc", "setSurrendered"] joinString "_";
private _aceSetSurrendered = missionNamespace getVariable [_aceFnName, {}];
if !(_aceSetSurrendered isEqualTo {}) then {
    [_hvtUnit, true] call _aceSetSurrendered;
};

_hvtUnit action ["Surrender", _hvtUnit];
true;