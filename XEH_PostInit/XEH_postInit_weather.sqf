diag_log "OKS_GOL_Misc: XEH_postInit_weather.sqf executed";

if (isServer && {missionNamespace getVariable ["GOL_Weather_SnowstormEnabled", false]}) then {
    [] call OKS_fnc_Weather_Start;
};