if (!isServer || !(missionNamespace getVariable ["GOL_Weather_SnowstormActive", false])) exitWith {};

missionNamespace setVariable ["GOL_Weather_SnowstormActive", false, true];
remoteExec ["", 0, "GOL_Weather_SnowstormClientStart"];

if (missionNamespace getVariable ["GOL_Weather_SnowstormVanillaFog", true]) then {
    60 setFog (missionNamespace getVariable ["GOL_Weather_SnowstormFogBefore", fog]);
};

if (missionNamespace getVariable ["GOL_Weather_SnowstormIntensifyWind", false]) then {
    private _wind = missionNamespace getVariable ["GOL_Weather_SnowstormWindBefore", wind];
    setWind [_wind # 0, _wind # 1, true];
};