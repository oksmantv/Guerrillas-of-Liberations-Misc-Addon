if (!hasInterface) exitWith {};

waitUntil {!isNull player};
while {missionNamespace getVariable ["GOL_Weather_SnowstormActive", false]} do {
    if ((missionNamespace getVariable ["GOL_Weather_SnowstormPositionState", "open"]) in ["open", "vehicle", "inside"] && {(eyePos player # 2) > 0}) then {
        private _sound = selectRandom ["GOL_Weather_Cough_1", "GOL_Weather_Cough_2", "GOL_Weather_Cough_3", "GOL_Weather_Cough_4", "GOL_Weather_Cough_5", "GOL_Weather_Cough_6"];
        player say3D [_sound, 100];
        addCamShake [5, 1, 7];
    };
    sleep (120 + random 900);
};