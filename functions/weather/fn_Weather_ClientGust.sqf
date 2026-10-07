if (!hasInterface) exitWith {};
params ["_velocity", "_duration"];

if ((missionNamespace getVariable ["GOL_Weather_SnowstormPositionState", "open"]) != "open") exitWith {};

private _position = [random 100 - 50, random 100 - 50, 0];
private _fog = "#particlesource" createVehicleLocal (getPosATL player);
_fog setParticleCircle [5, [0, 0, 0]];
_fog setParticleRandom [1, [1, 1, 0.1], [0, 0, 0], 0, 0.01, [0, 0, 0, 0.01], 1, 1];
_fog setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 5, _position, [_velocity # 0, _velocity # 1, 0], 15, 10, 8, 0.07, [1, 5, 10], [[1, 1, 1, 0.01], [1, 1, 1, 0.02], [1, 1, 1, 0]], [1], 1, 0, "", "", player];
_fog setDropInterval 0.01;

private _snow = "#particlesource" createVehicleLocal (getPosATL player);
_snow setParticleRandom [0, [10, 10, 5], [0, 0, 0], 0, 0.1, [0, 0, 0, 0.1], 0, 0];
_snow setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 8, 1], "", "Billboard", 1, 5, [0, 0, 7], [_velocity # 0, _velocity # 1, 0], 0, 1.7, 1, 0, [0.1], [[1, 1, 1, 1]], [1], 0, 0, "", "", player];
_snow setDropInterval 0.01;

playSound (selectRandom ["GOL_Weather_Gust_1", "GOL_Weather_Gust_2", "GOL_Weather_Gust_3", "GOL_Weather_Gust_5", "GOL_Weather_Gust_6"]);
if (missionNamespace getVariable ["GOL_Weather_SnowstormUnitColdEffects", true]) then {
    enableCamShake true;
    playSound (selectRandom ["GOL_Weather_Shiver_1", "GOL_Weather_Shiver_2", "GOL_Weather_Shiver_3", "GOL_Weather_Shiver_4"]);
    addCamShake [0.5, _duration * 2, 25];

    [] spawn {
        private _priority = 2000;
        private _effect = ppEffectCreate ["FilmGrain", _priority];
        while {_effect < 0} do {
            _priority = _priority + 1;
            _effect = ppEffectCreate ["FilmGrain", _priority];
        };
        _effect ppEffectEnable true;
        _effect ppEffectAdjust [0.1, 1, 5, 0.5, 0.3, 0];
        _effect ppEffectCommit 1;
        sleep 5;
        _effect ppEffectAdjust [0, 1, 5, 0.5, 0.3, 0];
        _effect ppEffectCommit 3;
        sleep 3;
        _effect ppEffectEnable false;
        ppEffectDestroy _effect;
    };
};

sleep (_duration / 2);
deleteVehicle _fog;
deleteVehicle _snow;