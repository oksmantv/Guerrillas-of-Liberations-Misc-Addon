/*
    OKS_fnc_LaserMarker_InitClient

    Maintains a map-only aircraft aim overlay for the local player and other
    crew in the same aircraft. It never draws any 3D line or icon on screen.
*/

if (!hasInterface) exitWith {};

[] spawn {
    waitUntil { !isNull player };
    diag_log "OKS_GOL_Misc: Aircraft aim marker client initialized";

    private _oldPfh = missionNamespace getVariable ["OKS_LaserMarker_PFH", -1];
    if (_oldPfh isNotEqualTo -1) then {
        [_oldPfh] call CBA_fnc_removePerFrameHandler;
    };

    private _previewMarker = "OKS_LaserMarker_SearchPreview";
    private _pfhId = [{
        params ["_args"];
        _args params ["_previewMarker"];

        // A crew recipient can dismount before the laser operator sends the
        // stop update. Remove any local drawings that no longer belong to the
        // vehicle the client occupies.
        {
            if (!isNull _x && {!(player in (crew _x))}) then {
                [_x, [], [], 0, 0, 0, 0, false] call OKS_fnc_LaserMarker_UpdateLive;
            };
        } forEach +(missionNamespace getVariable ["OKS_LaserMarker_VisibleVehicles", []]);
        missionNamespace setVariable [
            "OKS_LaserMarker_VisibleVehicles",
            (missionNamespace getVariable ["OKS_LaserMarker_VisibleVehicles", []]) select {!isNull _x}
        ];

        private _aimData = call OKS_fnc_LaserMarker_GetLaserAim;
        if (_aimData isEqualTo []) then {
            private _lastVehicle = missionNamespace getVariable ["OKS_LaserMarker_LiveVehicle", objNull];
            if (!isNull _lastVehicle) then {
                [_lastVehicle, [], [], 0, 0, 0, 0, false] call OKS_fnc_LaserMarker_UpdateLive;
                private _crewPlayers = (crew _lastVehicle) select {isPlayer _x && {!(_x isEqualTo player)}};
                if (_crewPlayers isNotEqualTo []) then {
                    [_lastVehicle, [], [], 0, 0, 0, 0, false] remoteExecCall ["OKS_fnc_LaserMarker_UpdateLive", _crewPlayers];
                };
                missionNamespace setVariable ["OKS_LaserMarker_LiveVehicle", objNull];
            };
        } else {
            _aimData params ["_originASL", "_impactASL", "_groundRange", "_vehicle", "_sourceATL", "_turretBearing", "_vehicleHeading"];

            private _lastVehicle = missionNamespace getVariable ["OKS_LaserMarker_LiveVehicle", objNull];
            if (!isNull _lastVehicle && {!(_lastVehicle isEqualTo _vehicle)}) then {
                [_lastVehicle, [], [], 0, 0, 0, 0, false] call OKS_fnc_LaserMarker_UpdateLive;
                private _crewPlayers = (crew _lastVehicle) select {isPlayer _x && {!(_x isEqualTo player)}};
                if (_crewPlayers isNotEqualTo []) then {
                    [_lastVehicle, [], [], 0, 0, 0, 0, false] remoteExecCall ["OKS_fnc_LaserMarker_UpdateLive", _crewPlayers];
                };
            };
            private _lastUpdate = missionNamespace getVariable ["OKS_LaserMarker_LastLiveUpdate", -1];
            private _updateRate = missionNamespace getVariable ["GOL_LaserMarker_UpdateRate", 30];
            private _updateInterval = if (_updateRate <= 0) then { 0 } else { 1 / _updateRate };
            if ((diag_tickTime - _lastUpdate) >= _updateInterval) then {
                private _updateArguments = [
                    _vehicle,
                    _impactASL,
                    _sourceATL,
                    _groundRange,
                    _turretBearing,
                    _vehicleHeading,
                    0,
                    true
                ];
                _updateArguments call OKS_fnc_LaserMarker_UpdateLive;

                private _crewPlayers = (crew _vehicle) select {isPlayer _x && {!(_x isEqualTo player)}};
                if (_crewPlayers isNotEqualTo []) then {
                    _updateArguments remoteExecCall ["OKS_fnc_LaserMarker_UpdateLive", _crewPlayers];
                };
                missionNamespace setVariable ["OKS_LaserMarker_LastLiveUpdate", diag_tickTime];
                missionNamespace setVariable ["OKS_LaserMarker_LiveVehicle", _vehicle];
            };
        };
    }, 0, [_previewMarker]] call CBA_fnc_addPerFrameHandler;

    missionNamespace setVariable ["OKS_LaserMarker_PFH", _pfhId];
};
