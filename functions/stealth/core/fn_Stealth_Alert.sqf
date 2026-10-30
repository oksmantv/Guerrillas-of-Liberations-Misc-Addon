/*
    Temporarily redirects friendly AI patrols to investigate an alert, search
    nearby dry terrain, then restores their original simple patrol waypoints.
    Returning patrols remain permanently alert: AWARE, NORMAL speed, YELLOW.

    Usage:
    [
        _source,
        _alertSide,
        _responseRange,
        _responsePercentage,
        _playAlarm,
        _investigateDuration,
        _searchRadius,
        _searchDuration
    ] spawn OKS_fnc_Stealth_Alert;

    Groups can opt out with:
    _group setVariable ["OKS_Stealth_AlertOptOut", true, true];

    Alarm speakers can be disabled with:
    _speaker setVariable ["OKS_Stealth_AlarmDisabled", true, true];
*/

params [
    ["_source", [0, 0, 0], [objNull, []], [2, 3]],
    ["_alertSide", east, [sideUnknown]],
    ["_responseRange", 750, [0]],
    ["_responsePercentage", 0.35, [0]],
    ["_playAlarm", false, [true]],
    ["_investigateDuration", 90, [0]],
    ["_searchRadius", 250, [0]],
    ["_searchDuration", 240, [0]]
];

if (!isServer) exitWith { [] };
if !(missionNamespace getVariable ["GOL_Stealth_Enabled", false]) exitWith { [] };
if (_alertSide in [civilian, sideLogic, sideUnknown]) exitWith { [] };

private _isAlarmObject = _source isEqualType objNull;
if (_playAlarm && _isAlarmObject && { isNull _source || { !alive _source } || { _source getVariable ["OKS_Stealth_AlarmDisabled", false] } }) exitWith { [] };

private _alertPositionASL = if (_isAlarmObject) then {
    getPosASL _source
} else {
    +_source
};
if (count _alertPositionASL == 2) then {
    _alertPositionASL pushBack 0;
};
private _alertPositionATL = ASLToATL _alertPositionASL;

_responseRange = _responseRange max 0;
_responsePercentage = (0 max _responsePercentage) min 1;
_investigateDuration = _investigateDuration max 0;
_searchRadius = _searchRadius max 0;
_searchDuration = _searchDuration max 0;

if (_playAlarm) then {
    playSound3D [
        "\OKS_GOL_Misc\Sounds\siren.ogg",
        objNull,
        false,
        _alertPositionASL,
        5,
        1,
        500
    ];
};

private _eligibleGroups = allGroups select {
    private _group = _x;
    !isNull _group &&
    { !(_group getVariable ["OKS_Stealth_AlertOptOut", false]) } &&
    { !(_group getVariable ["OKS_Stealth_AlertActive", false]) } &&
    { !(_group getVariable ["GOL_IsStatic", false]) } &&
    { !(_group getVariable ["GOL_isStatic", false]) } &&
    { !(_group getVariable ["OKS_Stealth_SentryPriority", false]) } &&
    { !(_group getVariable ["LAMBS_HUNTING", false]) } &&
    { count waypoints _group > 0 } &&
    { side _group != civilian } &&
    { (_alertSide getFriend (side _group)) >= 0.6 } &&
    { (leader _group) distance2D _alertPositionATL <= _responseRange } &&
    { { alive _x && !(isPlayer _x || { _x in playableUnits } || { _x in switchableUnits }) } count units _group > 0 }
};

private _responseCount = ceil ((count _eligibleGroups) * _responsePercentage);
private _responders = [];
for "_index" from 1 to _responseCount do {
    if (_eligibleGroups isEqualTo []) exitWith {};

    private _group = selectRandom _eligibleGroups;
    _responders pushBack _group;
    _eligibleGroups deleteAt (_eligibleGroups find _group);
};

if (_responders isEqualTo []) exitWith { [] };

{
    _x setVariable ["OKS_Stealth_AlertActive", true, true];
} forEach _responders;

private _gridCellSize = missionNamespace getVariable ["GOL_Stealth_AlertGridCellSize", 60];
private _searchPositions = [_alertPositionATL, _searchRadius, _gridCellSize] call OKS_fnc_Stealth_Alert_SearchGrid;

{
    private _group = _x;
    private _groupIndex = _forEachIndex;
    private _groupSearchPositions = [];

    {
        if ((_forEachIndex mod (count _responders)) == _groupIndex) then {
            _groupSearchPositions pushBack _x;
        };
    } forEach _searchPositions;

    [_group, _alertPositionATL, _investigateDuration, _groupSearchPositions, _searchDuration] spawn {
        params ["_group", "_alertPosition", "_investigateDuration", "_groupSearchPositions", "_searchDuration"];

        if (isNull _group) exitWith {};

        private _patrolSnapshot = [_group] call OKS_fnc_Stealth_Alert_SavePatrol;
        _group setBehaviour "AWARE";
        _group setCombatMode "YELLOW";
        _group setSpeedMode "NORMAL";

        while { count waypoints _group > 0 } do {
            deleteWaypoint [_group, 0];
        };

        private _investigateWaypoint = _group addWaypoint [_alertPosition, 30];
        _investigateWaypoint setWaypointType "MOVE";
        _investigateWaypoint setWaypointBehaviour "AWARE";
        _investigateWaypoint setWaypointCombatMode "YELLOW";
        _investigateWaypoint setWaypointSpeed "NORMAL";
        _investigateWaypoint setWaypointCompletionRadius 30;

        private _arrivalDeadline = diag_tickTime + 300;
        waitUntil {
            sleep 3;
            isNull _group ||
            { { alive _x } count units _group == 0 } ||
            { (leader _group) distance2D _alertPosition <= 35 } ||
            { diag_tickTime >= _arrivalDeadline }
        };

        if (!isNull _group && { { alive _x } count units _group > 0 }) then {
            private _investigationEnd = diag_tickTime + _investigateDuration;
            waitUntil {
                sleep 3;
                isNull _group ||
                { { alive _x } count units _group == 0 } ||
                { diag_tickTime >= _investigationEnd }
            };
        };

        if (!isNull _group && { { alive _x } count units _group > 0 }) then {
            while { count waypoints _group > 0 } do {
                deleteWaypoint [_group, 0];
            };

            {
                private _searchWaypoint = _group addWaypoint [_x, 25];
                _searchWaypoint setWaypointType "MOVE";
                _searchWaypoint setWaypointBehaviour "AWARE";
                _searchWaypoint setWaypointCombatMode "YELLOW";
                _searchWaypoint setWaypointSpeed "NORMAL";
                _searchWaypoint setWaypointCompletionRadius 25;
            } forEach _groupSearchPositions;

            private _searchEnd = diag_tickTime + _searchDuration;
            waitUntil {
                sleep 3;
                isNull _group ||
                { { alive _x } count units _group == 0 } ||
                { diag_tickTime >= _searchEnd } ||
                { count waypoints _group == 0 }
            };
        };

        if (!isNull _group) then {
            [_group, _patrolSnapshot] call OKS_fnc_Stealth_Alert_RestorePatrol;
            _group setVariable ["OKS_Stealth_AlertActive", false, true];
        };
    };
} forEach _responders;

_responders