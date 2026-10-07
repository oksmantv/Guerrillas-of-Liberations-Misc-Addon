diag_log "OKS_GOL_Misc: XEH_preInit_weather.sqf executed";

private _category = ["GOL Weather", "Snowstorm"];

["GOL_Weather_SnowstormEnabled", "CHECKBOX", ["Enable Snowstorm", "Automatically starts the snowstorm on every mission when enabled."], _category, true, 1] call cba_settings_fnc_init;
["GOL_Weather_SnowstormSnowfall", "CHECKBOX", ["Snowfall", "Creates local, context-aware snow particle effects."], _category, true, 1] call cba_settings_fnc_init;
["GOL_Weather_SnowstormDuration", "SLIDER", ["Duration", "Storm duration in seconds. Set to -1 for an indefinite storm."], _category, [-1, 14400, -1, 0], 1] call cba_settings_fnc_init;
["GOL_Weather_SnowstormAmbientInterval", "SLIDER", ["Ambient Sound Variation", "Maximum additional seconds between distant ambient sounds. Set to 0 to disable them."], _category, [0, 1800, 15, 0], 1] call cba_settings_fnc_init;
["GOL_Weather_SnowstormBreathVapour", "CHECKBOX", ["Breath Vapour", "Creates breath vapour around nearby units. This has a performance cost."], _category, false, 1] call cba_settings_fnc_init;
["GOL_Weather_SnowstormGustInterval", "SLIDER", ["Gust Interval", "Seconds between snow gusts. Set to 0 to disable gusts."], _category, [0, 600, 10, 0], 1] call cba_settings_fnc_init;
["GOL_Weather_SnowstormAffectObjects", "CHECKBOX", ["Gust Object Force", "Allows gusts to push nearby eligible objects and units."], _category, false, 1] call cba_settings_fnc_init;
["GOL_Weather_SnowstormVanillaFog", "CHECKBOX", ["Vanilla Fog", "Applies and later restores the engine fog state."], _category, true, 1] call cba_settings_fnc_init;
["GOL_Weather_SnowstormLocalFog", "CHECKBOX", ["Local Fog", "Creates local particle fog waves around players."], _category, true, 1] call cba_settings_fnc_init;
["GOL_Weather_SnowstormIntensifyWind", "CHECKBOX", ["Intensify Wind", "Gradually amplifies the existing wind during the storm."], _category, false, 1] call cba_settings_fnc_init;
["GOL_Weather_SnowstormUnitColdEffects", "CHECKBOX", ["Unit Cold Effects", "Enables coughs, shivering, camera shake, and gust post-processing effects."], _category, true, 1] call cba_settings_fnc_init;