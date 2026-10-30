if (!hasInterface || {missionNamespace getVariable ["GOL_Weather_SnowstormClientRunning", false]}) exitWith {};

missionNamespace setVariable ["GOL_Weather_SnowstormClientRunning", true];
[] spawn OKS_fnc_Weather_ClientPosition;

if (missionNamespace getVariable ["GOL_Weather_SnowstormSnowfall", true]) then { [] spawn OKS_fnc_Weather_ClientSnow; };
if (missionNamespace getVariable ["GOL_Weather_SnowstormLocalFog", true]) then { [] spawn OKS_fnc_Weather_ClientFog; };
if (missionNamespace getVariable ["GOL_Weather_SnowstormBreathVapour", false]) then { [] spawn OKS_fnc_Weather_ClientBreath; };
if ((missionNamespace getVariable ["GOL_Weather_SnowstormAmbientInterval", 15]) > 0) then { [] spawn OKS_fnc_Weather_ClientAmbient; };
if (missionNamespace getVariable ["GOL_Weather_SnowstormIntensifyWind", false]) then { [] spawn OKS_fnc_Weather_ClientWind; };
if (missionNamespace getVariable ["GOL_Weather_SnowstormUnitColdEffects", true]) then { [] spawn OKS_fnc_Weather_ClientCough; };

[] spawn {
    waitUntil {sleep 1; !(missionNamespace getVariable ["GOL_Weather_SnowstormActive", false])};
    missionNamespace setVariable ["GOL_Weather_SnowstormClientRunning", false];
};