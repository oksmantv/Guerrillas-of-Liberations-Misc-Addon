if (!isServer || {missionNamespace getVariable ["GOL_Weather_SnowstormActive", false]}) exitWith {};

missionNamespace setVariable ["GOL_Weather_SnowstormActive", true, true];
missionNamespace setVariable ["GOL_Weather_SnowstormFogBefore", fog];
missionNamespace setVariable ["GOL_Weather_SnowstormWindBefore", wind];

if (missionNamespace getVariable ["GOL_Weather_SnowstormVanillaFog", true]) then {
    60 setFog [1, 0.01, 0.5];
};

[] remoteExec ["OKS_fnc_Weather_ClientStart", 0, "GOL_Weather_SnowstormClientStart"];
[] spawn OKS_fnc_Weather_ServerLoop;

private _duration = missionNamespace getVariable ["GOL_Weather_SnowstormDuration", -1];
if (_duration >= 0) then {
    [_duration] spawn {
        params ["_duration"];
        sleep _duration;
        [] call OKS_fnc_Weather_Stop;
    };
};

if (missionNamespace getVariable ["GOL_Weather_SnowstormIntensifyWind", false]) then {
    [] spawn {
        private _wind = missionNamespace getVariable ["GOL_Weather_SnowstormWindBefore", [0, 0, true]];
        for "_multiplier" from 1 to 5 step 0.2 do {
            if !(missionNamespace getVariable ["GOL_Weather_SnowstormActive", false]) exitWith {};
            setWind [(_wind # 0) * _multiplier, (_wind # 1) * _multiplier, true];
            sleep 4;
        };
    };
};