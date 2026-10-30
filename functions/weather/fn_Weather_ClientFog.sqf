if (!hasInterface) exitWith {};

waitUntil {!isNull player};
while {missionNamespace getVariable ["GOL_Weather_SnowstormActive", false]} do {
    private _state = missionNamespace getVariable ["GOL_Weather_SnowstormPositionState", "open"];
    if (_state in ["open", "vehicle", "inside"]) then {
        private _radius = if (_state == "vehicle") then {30} else {10};
        private _source = "#particlesource" createVehicleLocal (getPosATL player);
        _source setParticleCircle [_radius, [3, 3, 0]];
        _source setParticleRandom [2, [0.25, 0.25, 0], [1, 1, 0], 1, 1, [0, 0, 0, 0.1], 0, 0];
        _source setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 8, [0, 0, 0], [-1, -1, 0], 3, 10.15, 7.9, 0.03, [5, 10, 10], [[0.5, 0.5, 0.5, 0], [0.5, 0.5, 0.5, 0.1], [1, 1, 1, 0]], [1], 1, 0, "", "", player];
        _source setDropInterval 0.1;
        waitUntil {sleep 0.5; !(missionNamespace getVariable ["GOL_Weather_SnowstormActive", false]) || {(missionNamespace getVariable ["GOL_Weather_SnowstormPositionState", "open"]) != _state}};
        deleteVehicle _source;
    } else {
        sleep 1;
    };
};