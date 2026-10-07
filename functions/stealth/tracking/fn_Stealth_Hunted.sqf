/*
    Creates temporary track objects for a hunted group.

    Usage:
    [_huntedGroup] spawn OKS_fnc_Stealth_Hunted;
    [_huntedGroup, _triggerArea] spawn OKS_fnc_Stealth_Hunted;
*/

params [
    ["_huntedGroup", grpNull, [grpNull]],
    ["_huntedTriggerArea", objNull, [objNull]]
];

if (!isServer) exitWith { false };
if (isNull _huntedGroup) exitWith { false };

[] call OKS_fnc_Stealth_Init;

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];
private _log = {
    params ["_message"];
    if (_debug) then {
        [format ["[Stealth.Hunted] %1", _message], false, false, true] spawn OKS_fnc_LogDebug;
    };
};

private _trackLifetime = missionNamespace getVariable ["GOL_Stealth_TrackLifetime", 300];
private _trackSpacing = missionNamespace getVariable ["GOL_Stealth_TrackSpacing", 10];
private _trackClass = missionNamespace getVariable ["GOL_Stealth_TrackClass", "Land_ClutterCutter_small_F"];
private _debugTrackClass = missionNamespace getVariable ["GOL_Stealth_TrackDebugClass", "Sign_Arrow_Green_F"];
private _debugTrackObject = missionNamespace getVariable ["GOL_Stealth_DebugTrackObject", false];

private _selectedTrackClass = if (_debugTrackObject) then { _debugTrackClass } else { _trackClass };

if ((OKS_HuntedGroups find _huntedGroup) == -1) then {
    OKS_HuntedGroups pushBack _huntedGroup;
};

private _respawnMarker = format ["respawn_%1", side _huntedGroup];
private _originBasePosition = getMarkerPos _respawnMarker;
if (_originBasePosition isEqualTo [0, 0, 0]) exitWith {
    [format ["Missing marker %1, cannot place tracks", _respawnMarker]] call _log;
    false
};

private _isAwake = {
    params ["_unit"];
    alive _unit || { !isNil "ace_common_fnc_isAwake" && { [_unit] call ace_common_fnc_isAwake } }
};

while {
    ({ [_x] call _isAwake } count units _huntedGroup > 0)
    && {
        isNull _huntedTriggerArea
        || { ({ ([_x] call _isAwake) && { _x inArea _huntedTriggerArea } } count units _huntedGroup) > 0 }
    }
} do {
    private _tracksArray = (_huntedGroup getVariable ["OKS_GroupTracks", []]) select { !isNull _x };

    private _candidates = [
        units _huntedGroup,
        [],
        {
            count ((_x nearEntities ["Man", 20]) select { isPlayer _x && { alive _x } })
        },
        "DESCEND"
    ] call BIS_fnc_sortBy;

    _candidates = _candidates select {
        private _candidate = _x;
        (_candidate distance _originBasePosition > 10)
        && { _tracksArray findIf { _candidate distance _x < _trackSpacing } == -1 }
    };

    if (_candidates isEqualTo []) then {
        sleep 5;
        continue;
    };

    private _selectedUnit = _candidates select 0;
    private _track = createVehicle [_selectedTrackClass, getPosATL _selectedUnit, [], 0, "CAN_COLLIDE"];
    _track setVariable ["OKS_isTrack", true, true];

    _tracksArray pushBackUnique _track;
    _huntedGroup setVariable ["OKS_GroupTracks", _tracksArray];

    [format ["Track created at %1", getPosATL _selectedUnit]] call _log;

    [_huntedGroup, _track, _trackLifetime] spawn {
        params ["_huntedGroup", "_track", "_trackLifetime"];

        sleep _trackLifetime;

        private _tracks = (_huntedGroup getVariable ["OKS_GroupTracks", []]) select { !isNull _x };
        _tracks deleteAt (_tracks find _track);
        _huntedGroup setVariable ["OKS_GroupTracks", _tracks];

        if (!isNull _track) then {
            deleteVehicle _track;
        };
    };

    waitUntil {
        sleep 2;
        private _updatedTracks = (_huntedGroup getVariable ["OKS_GroupTracks", []]) select { !isNull _x };
        _updatedTracks findIf { _selectedUnit distance _x < _trackSpacing } == -1
    };
};

true
