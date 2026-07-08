/*
    Tracker AI that follows hunted tracks.

    Usage:
    [_trackerGroup] spawn OKS_fnc_Stealth_Tracker;
*/

params [
    ["_trackerGroup", grpNull, [grpNull]],
    ["_activationRange", 500, [0]],
    ["_trackDetectionRadius", 10, [0]],
    ["_detectionChance", 0.25, [0]],
    ["_checkDelay", 5, [0]]
];

if (!isServer) exitWith { false };
if (isNull _trackerGroup) exitWith { false };

[] call OKS_fnc_Stealth_Init;

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];
private _log = {
    params ["_message"];
    if (_debug) then {
        [format ["[Stealth.Tracker] %1", _message], false, false, true] spawn OKS_fnc_LogDebug;
    };
};

private _isAwake = {
    params ["_unit"];
    alive _unit || { !isNil "ace_common_fnc_isAwake" && { [_unit] call ace_common_fnc_isAwake } }
};

_trackerGroup setVariable ["acex_headless_blacklist", true, true];

while { { [_x] call _isAwake } count units _trackerGroup > 0 } do {
    private _leader = leader _trackerGroup;
    if (isNull _leader) then {
        sleep _checkDelay;
        continue;
    };

    if (
        ({ _leader distance _x < _activationRange } count allPlayers > 0)
        && { !(_trackerGroup getVariable ["OKS_isTracking", false]) }
    ) then {
        private _tracksArray = [];

        {
            private _groupTracks = (_x getVariable ["OKS_GroupTracks", []]) select { !isNull _x };
            { _tracksArray pushBackUnique _x; } forEach _groupTracks;
        } forEach OKS_HuntedGroups;

        if ({ _leader distance _x < _trackDetectionRadius } count _tracksArray > 0) then {
            if ((random 1) < _detectionChance) then {
                ["Trackers found a track"] call _log;

                private _selectedTrack = ([_tracksArray, [], { _leader distance _x }, "ASCEND"] call BIS_fnc_sortBy) select 0;
                private _selectedTracksArray = [];

                {
                    private _arr = (_x getVariable ["OKS_GroupTracks", []]) select { !isNull _x };
                    if (_selectedTrack in _arr) exitWith {
                        _selectedTracksArray = _arr;
                    };
                } forEach OKS_HuntedGroups;

                if (_selectedTracksArray isEqualTo []) then {
                    sleep _checkDelay;
                    continue;
                };

                private _startIdx = _selectedTracksArray find _selectedTrack;
                private _pathTracks = _selectedTracksArray select { (_selectedTracksArray find _x) >= _startIdx };

                {
                    deleteWaypoint [_trackerGroup, 0];
                } forEach waypoints _trackerGroup;

                {
                    private _wp = _trackerGroup addWaypoint [getPos _x, 0];
                    _wp setWaypointType "MOVE";
                    _wp setWaypointBehaviour "AWARE";
                    _wp setWaypointSpeed "NORMAL";
                    _wp setWaypointCompletionRadius 15;
                } forEach _pathTracks;

                _trackerGroup setVariable ["OKS_isTracking", true, true];

                [_trackerGroup, _pathTracks] spawn {
                    params ["_trackerGroup", "_pathTracks"];

                    waitUntil {
                        sleep 2;
                        (isNull leader _trackerGroup)
                        || { _pathTracks isEqualTo [] }
                        || { (leader _trackerGroup) distance (_pathTracks select ((count _pathTracks) - 1)) < 20 }
                    };

                    _trackerGroup setVariable ["OKS_isTracking", false, true];
                };

                [_trackerGroup] spawn {
                    params ["_trackerGroup"];
                    while { { alive _x } count units _trackerGroup > 0 } do {
                        {
                            if (!isNil "ace_common_fnc_isAwake" && { !([_x] call ace_common_fnc_isAwake) }) then {
                                _x setDamage 1;
                            };
                        } forEach units _trackerGroup;
                        sleep 30;
                    };
                };

                private _pos = getPosATL _leader;
                private _flare = createVehicle ["F_40mm_Red", [_pos select 0, _pos select 1, (_pos select 2) + 140], [], 20, "CAN_COLLIDE"];
                _flare setVelocity [0, 0, -10];
                sleep 3;
                playSound3D ["A3\Sounds_F\weapons\Flare_Gun\flaregun_2_shoot.wss", _leader, false, _pos, 8, 1, 300];
            } else {
                ["Trackers failed to identify track"] call _log;
                sleep 15;
            };
        };
    };

    sleep _checkDelay;
};

true
