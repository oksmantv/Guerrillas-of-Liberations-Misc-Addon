if (!isServer) exitWith {};

while {missionNamespace getVariable ["GOL_Weather_SnowstormActive", false]} do {
    private _gustInterval = missionNamespace getVariable ["GOL_Weather_SnowstormGustInterval", 10];
    if (_gustInterval <= 0) then {
        sleep 10;
    } else {
        private _units = (if (isMultiplayer) then {playableUnits} else {switchableUnits}) select {alive _x};
        if (_units isNotEqualTo []) then {
            private _target = selectRandom _units;
            private _velocity = [(selectRandom [-1, 1]) * (2 + random 5), (selectRandom [-1, 1]) * (2 + random 5)];
            private _duration = selectRandom [8.5, 12, 13, 16, 17];
            [_velocity, _duration] remoteExec ["OKS_fnc_Weather_ClientGust", owner _target];

            if (missionNamespace getVariable ["GOL_Weather_SnowstormAffectObjects", false]) then {
                private _objects = (nearestObjects [_target, [], 50]) select {_x isKindOf "LandVehicle" || _x isKindOf "Man" || _x isKindOf "Air" || _x isKindOf "Wreck"};
                if (_objects isNotEqualTo []) then {
                    private _object = selectRandom _objects;
                    _object setVelocity [_velocity # 0, _velocity # 1, random 0.1];
                };
            };
        };
        sleep _gustInterval;
    };
};