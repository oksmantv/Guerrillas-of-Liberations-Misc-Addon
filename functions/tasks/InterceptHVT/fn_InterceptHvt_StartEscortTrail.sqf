/*
    [_escortGrp, _escortVeh, _leadVeh, _fallbackTarget, _speedMS, _escortDelay, _hvtUnit, _debug] spawn OKS_fnc_InterceptHvt_StartEscortTrail;
*/
params [
    ["_escortGrp", grpNull, [grpNull]],
    ["_escortVeh", objNull, [objNull]],
    ["_leadVeh", objNull, [objNull]],
    ["_fallbackTarget", [0,0,0], [[]]],
    ["_speedMS", -1, [0]],
    ["_escortDelay", 0, [0]],
    ["_hvtUnit", objNull, [objNull]],
    ["_debug", false, [false]]
];

if (isNull _escortGrp || {isNull _escortVeh} || {isNull _leadVeh} || {isNull _hvtUnit}) exitWith {};

// Hard hold escort vehicle until the stagger delay expires.
_escortVeh forceSpeed 0;

if (_escortDelay > 0) then {
    if (_debug) then {
        format ["[INTERCEPT HVT][OVERFLOW] Delaying escort start by %1s for %2", round _escortDelay, typeOf _escortVeh] call OKS_fnc_LogDebug;
    };
    sleep _escortDelay;
};

if (!isNull _escortGrp && {!isNull _escortVeh} && {alive _escortVeh} && {alive _hvtUnit}) then {
    // Overflow groups get delayed start, then move directly toward the end waypoint.
    // No dynamic follow retargeting.
    if (!(_hvtUnit getVariable ["OKS_InterceptHvt_Surrendered", false])) then {
        // Re-enable lights now that vehicle is cleared to move.
        _escortVeh setPilotLight true;
        _escortVeh setCollisionLight true;
        { _x enableAI "LIGHTS"; } forEach (crew _escortVeh);

        [_escortGrp] call OKS_fnc_ClearWaypoints;
        private _moveWp = _escortGrp addWaypoint [_fallbackTarget, 0];
        _moveWp setWaypointType "MOVE";
        _moveWp setWaypointBehaviour "AWARE";
        _moveWp setWaypointSpeed "NORMAL";
        _escortGrp setCurrentWaypoint _moveWp;
        if (_debug) then {
            format ["[INTERCEPT HVT][OVERFLOW] Delayed group now moving to end waypoint %1", _fallbackTarget] call OKS_fnc_LogDebug;
        };
    };

    _escortVeh forceSpeed _speedMS;

    if (_speedMS > 0) then {
        _escortVeh limitSpeed (_speedMS * 3.6);
    } else {
        _escortVeh limitSpeed 5000;
    };
};