if (!hasInterface) exitWith {};

private _nextAmbient = 120 + random (missionNamespace getVariable ["GOL_Weather_SnowstormAmbientInterval", 15]);
while {missionNamespace getVariable ["GOL_Weather_SnowstormActive", false]} do {
    if (_nextAmbient <= 0 && {(missionNamespace getVariable ["GOL_Weather_SnowstormPositionState", "open"]) in ["open", "vehicle", "inside"]}) then {
        private _sound = selectRandom ["lup_01.ogg", "lup_02.ogg", "lup_03.ogg"];
        private _position = player getRelPos [100 + random 200, random 360];
        playSound3D [format ["\OKS_GOL_Misc\sounds\weather\%1", _sound], objNull, false, [_position # 0, _position # 1, 50 + random 100], 0.2, 0.7, 2000];
        _nextAmbient = 120 + random (missionNamespace getVariable ["GOL_Weather_SnowstormAmbientInterval", 15]);
    };

    sleep 42;
    _nextAmbient = _nextAmbient - 42;
};