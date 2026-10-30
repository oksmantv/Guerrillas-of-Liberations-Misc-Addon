if (!hasInterface) exitWith {};

waitUntil {!isNull player};
while {missionNamespace getVariable ["GOL_Weather_SnowstormActive", false]} do {
    private _state = missionNamespace getVariable ["GOL_Weather_SnowstormPositionState", "open"];
    if (_state in ["open", "vehicle"]) then {
        private _source = "#particlesource" createVehicleLocal (getPosATL player);
        _source setParticleCircle [0, [0, 0, 0]];
        _source setParticleRandom [0, [20, 20, 9], [0, 0, 0], 0, 0.1, [0, 0, 0, 0.1], 0, 0];
        _source setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 8, 1], "", "Billboard", 1, 7, [0, 0, 10], [0, 0, 0], 3, 1.7, 1, 1, [0.1], [[1, 1, 1, 1]], [1], 0.3, 1, "", "", player];
        _source setDropInterval 0.005;
        waitUntil {sleep 0.5; !(missionNamespace getVariable ["GOL_Weather_SnowstormActive", false]) || {(missionNamespace getVariable ["GOL_Weather_SnowstormPositionState", "open"]) != _state}};
        deleteVehicle _source;
    } else {
        sleep 1;
    };
};