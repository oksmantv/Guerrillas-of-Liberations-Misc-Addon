if (!hasInterface) exitWith {};

waitUntil {!isNull player};
while {missionNamespace getVariable ["GOL_Weather_SnowstormActive", false]} do {
    if (alive player && {(eyePos player # 2) > 0}) then {
        private _units = (player nearEntities ["Man", 20]) select {alive _x};
        if (_units isNotEqualTo []) then {
            private _unit = selectRandom _units;
            private _position = _unit modelToWorldVisual (_unit selectionPosition "head");
            private _velocity = [wind # 0, wind # 1, -0.2];
            drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 8, 1], "", "Billboard", 0.15, 0.3, _position, _velocity, 3, 1.2, 1, 0, [0.1, 0.2, 0.3], [[1, 1, 1, 0.05], [1, 1, 1, 0.2], [1, 1, 1, 0]], [0.1], 0, 0.04, "", "", _unit, 90];
        };
        sleep (5 + random 5);
    } else {
        sleep 10;
    };
};