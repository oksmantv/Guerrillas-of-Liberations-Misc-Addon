/*
    [_hvt, _veh, _hvtDebug, _aceSetSurrendered] spawn OKS_fnc_InterceptHvt_HandleMountedSurrender;
*/
params [
    ["_hvt", objNull, [objNull]],
    ["_veh", objNull, [objNull]],
    ["_hvtDebug", false, [false]],
    ["_aceSetSurrendered", {}, [{}]]
];

if (isNull _hvt || {isNull _veh} || {!alive _hvt}) exitWith {};

{
    if (alive _x && {vehicle _x == _veh}) then {
        doStop _x;
        _x forceSpeed 0;
    };
} forEach crew _veh;

private _stopDeadline = time + 15;
waitUntil {
    sleep 0.25;
    !alive _hvt ||
    isNull _veh ||
    !(alive _veh) ||
    (speed _veh <= 2) ||
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
        _x setBehaviour "COMBAT";
        _x setCombatMode "RED";
        _ejectedGuards pushBack _x;
        sleep 0.5;
    };
} forEach crew _veh;

if (_ejectedGuards isNotEqualTo []) then {
    private _guardGrp = group (_ejectedGuards select 0);
    [_guardGrp] call OKS_fnc_ClearWaypoints;
    private _guardWp = _guardGrp addWaypoint [getPosATL _veh, 0];
    _guardWp setWaypointType "SAD";
    _guardWp setWaypointBehaviour "COMBAT";
    _guardWp setWaypointCombatMode "RED";
    _guardWp setWaypointSpeed "FULL";
    _guardGrp setBehaviour "COMBAT";
    _guardGrp setCombatMode "RED";
    _guardGrp setSpeedMode "FULL";
    _guardGrp setCurrentWaypoint _guardWp;
};

if (_hvtDebug) then {
    "[INTERCEPT HVT] Mounted surrender waiting for nearby player (<=15m) before HVT exits." call OKS_fnc_LogDebug;
};

waitUntil {
    sleep 0.25;
    !alive _hvt ||
    isNull _veh ||
    !(alive _veh) ||
    (vehicle _hvt != _veh) ||
    ({alive _x && {_x distance _veh <= 15}} count allPlayers) > 0
};

if (alive _hvt && {!isNull _veh} && {alive _veh} && {vehicle _hvt == _veh}) then {
    _hvt setVariable ["OKS_InterceptHvt_AllowExit", true, true];
    _hvt setVariable ["OKS_InterceptHvt_ShouldExit", true];
    _hvt enableAI "PATH";
    [_hvt] allowGetIn false;
    _hvt leaveVehicle _veh;
    doGetOut _hvt;
    unassignVehicle _hvt;
    sleep 0.5;
    if (_hvtDebug) then {
        format ["[INTERCEPT HVT] HVT surprise exit triggered. Exit speed=%1", round (speed _veh)] call OKS_fnc_LogDebug;
    };
};

{
    if (alive _x) then {
        _x forceSpeed -1;
    };
} forEach crew _veh;

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
    _hvt setVariable ["OKS_InterceptHvt_SurrenderActionDone", true, true];
};