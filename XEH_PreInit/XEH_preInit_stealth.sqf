diag_log "OKS_GOL_Misc: XEH_preInit_stealth.sqf executed";

// Initialize IR illuminator settings (related to stealth/visibility system)
[] call OKS_fnc_IRIlluminator_InitSettings;

[
    "GOL_Stealth_Enabled",
    "CHECKBOX",
    ["Enable Stealth Subsystem", "Enables stealth helper functions (radio chatter, hunted tracks, tracker behavior)."],
    ["GOL Stealth", "General"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_Debug",
    "CHECKBOX",
    ["Enable Stealth Debug", "Enables stealth debug logging through OKS_fnc_LogDebug."],
    ["GOL Stealth", "Debug"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerVisibilityDebug",
    "CHECKBOX",
    ["Enable Player Visibility Debug", "Enables debug snapshots from player camouflage visibility logic."],
    ["GOL Stealth", "Debug"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerDetectThreshold",
    "SLIDER",
    ["Player Detect Debug Threshold", "knowsAbout threshold used for player detection debug alerts and snapshots. Lower values trigger earlier."],
    ["GOL Stealth", "Debug"],
    [0.1, 2.5, 0.8, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_AutoEnablePatrols",
    "CHECKBOX",
    ["Auto Enable on Patrols", "Automatically starts stealth patrol talk behavior on non-static AI groups with waypoints."],
    ["GOL Stealth", "General"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_AutoEnableStatics",
    "CHECKBOX",
    ["Auto Enable on Statics", "Automatically starts stealth sentry behavior on groups marked as static using GOL_IsStatic or GOL_isStatic."],
    ["GOL Stealth", "General"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerVisibilityEnabled",
    "CHECKBOX",
    ["Apply Player Camouflage Coef", "Applies player camouflage and audible coefficients locally based on precise lighting conditions."],
    ["GOL Stealth", "Player - General"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerCamoPitchBlack",
    "SLIDER",
    ["Player Camo (Pitch Black < 20)", "Camouflage coefficient in pitch black darkness. Light level < 20. Nearly invisible."],
    ["GOL Stealth", "Player - Camouflage"],
    [0.01, 0.5, 0.05, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerCamoVeryDark",
    "SLIDER",
    ["Player Camo (Very Dark 20-50)", "Camouflage coefficient in very dark conditions. Light level 20-50. Extremely hard to see."],
    ["GOL Stealth", "Player - Camouflage"],
    [0.01, 0.5, 0.12, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerCamoDark",
    "SLIDER",
    ["Player Camo (Dark 50-100)", "Camouflage coefficient in dark conditions. Light level 50-100. Hard to see."],
    ["GOL Stealth", "Player - Camouflage"],
    [0.01, 0.8, 0.25, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerCamoDim",
    "SLIDER",
    ["Player Camo (Dim 100-200)", "Camouflage coefficient in dim lighting. Light level 100-200. Reduced visibility."],
    ["GOL Stealth", "Player - Camouflage"],
    [0.1, 1.2, 0.6, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerCamoLit",
    "SLIDER",
    ["Player Camo (Lit 200+)", "Camouflage coefficient in bright conditions. Light level 200+. Normal visibility."],
    ["GOL Stealth", "Player - Camouflage"],
    [0.3, 2.0, 1.0, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerAbsoluteMin",
    "SLIDER",
    ["Absolute Minimum Camo Coef", "Safety minimum to prevent total invisibility. Only applies after all other calculations."],
    ["GOL Stealth", "Player - Camouflage"],
    [0.001, 0.1, 0.01, 3],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerCamoMulProne",
    "SLIDER",
    ["Camouflage Stance Multiplier (Prone)", "Multiplier applied to camouflage while prone. Lower means harder to detect."],
    ["GOL Stealth", "Player - Camouflage"],
    [0.5, 1.5, 0.8, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerCamoMulCrouch",
    "SLIDER",
    ["Camouflage Stance Multiplier (Crouch)", "Multiplier applied to camouflage while crouched."],
    ["GOL Stealth", "Player - Camouflage"],
    [0.5, 1.5, 0.9, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerCamoMulStand",
    "SLIDER",
    ["Camouflage Stance Multiplier (Stand)", "Multiplier applied to camouflage while standing. Higher means easier to detect."],
    ["GOL Stealth", "Player - Camouflage"],
    [0.5, 1.5, 1.05, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_VegetationConcealmentEnabled",
    "CHECKBOX",
    ["Enable Vegetation Concealment", "Applies concealment bonus when player is near bushes, trees, or other vegetation."],
    ["GOL Stealth", "Player - Camouflage"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_VegetationRadius",
    "SLIDER",
    ["Vegetation Detection Radius (m)", "How close vegetation must be to provide concealment bonus."],
    ["GOL Stealth", "Player - Camouflage"],
    [1, 5, 2.5, 1],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_VegetationThreshold",
    "SLIDER",
    ["Vegetation Count Threshold", "Minimum number of vegetation objects required for concealment bonus."],
    ["GOL Stealth", "Player - Camouflage"],
    [1, 5, 1, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_VegetationMultiplier",
    "SLIDER",
    ["Vegetation Concealment Multiplier", "Multiplier applied when in vegetation. Lower means harder to detect."],
    ["GOL Stealth", "Player - Camouflage"],
    [0.3, 1.0, 0.7, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerAudiblePitchBlack",
    "SLIDER",
    ["Player Audible (Pitch Black < 20)", "Audible coefficient in pitch black darkness. Light level < 20. Sounds harder to locate."],
    ["GOL Stealth", "Player - Audible"],
    [0.1, 1.0, 0.4, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerAudibleVeryDark",
    "SLIDER",
    ["Player Audible (Very Dark 20-50)", "Audible coefficient in very dark conditions. Light level 20-50."],
    ["GOL Stealth", "Player - Audible"],
    [0.1, 1.0, 0.55, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerAudibleDark",
    "SLIDER",
    ["Player Audible (Dark 50-100)", "Audible coefficient in dark conditions. Light level 50-100."],
    ["GOL Stealth", "Player - Audible"],
    [0.1, 1.5, 0.7, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerAudibleDim",
    "SLIDER",
    ["Player Audible (Dim 100-200)", "Audible coefficient in dim lighting. Light level 100-200."],
    ["GOL Stealth", "Player - Audible"],
    [0.3, 1.5, 0.85, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerAudibleLit",
    "SLIDER",
    ["Player Audible (Lit 200+)", "Audible coefficient in bright conditions. Light level 200+. Normal sound detection."],
    ["GOL Stealth", "Player - Audible"],
    [0.5, 2.0, 1.0, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerAudibleWeatherEnabled",
    "CHECKBOX",
    ["Apply Rain/Overcast To Audible Coef", "When enabled, player audible coefficient is reduced during heavier rain if overcast and rain thresholds are met."],
    ["GOL Stealth", "Player - Audible"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerAudibleWeatherOvercastMin",
    "SLIDER",
    ["Audible Weather Overcast Threshold", "Minimum overcast before weather begins reducing player audible coefficient."],
    ["GOL Stealth", "Player - Audible"],
    [0, 1, 0.5, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerAudibleWeatherRainMin",
    "SLIDER",
    ["Audible Weather Rain Threshold", "Minimum rain intensity before weather begins reducing player audible coefficient."],
    ["GOL Stealth", "Player - Audible"],
    [0, 1, 0.15, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerAudibleWeatherMinMultiplier",
    "SLIDER",
    ["Audible Weather Min Multiplier", "Lowest multiplier applied to player audible coefficient at very heavy rain/overcast. Lower means AI hears players less."],
    ["GOL Stealth", "Player - Audible"],
    [0.2, 1.0, 0.65, 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_PlayerVisibilityInterval",
    "SLIDER",
    ["Player Visibility Update Interval (s)", "How often player camouflage traits are reevaluated locally. Lower = more responsive to stance/lighting changes."],
    ["GOL Stealth", "Player - General"],
    [0.5, 10, 0.75, 2],
    1
] call CBA_fnc_addSetting;

// Side language selection (curated addon audio only)
[
    "GOL_Stealth_Language_BLUFOR",
    "LIST",
    ["Language (Blufor)", "Selects the language used for all Blufor stealth voice lines."],
    ["GOL Stealth", "Language"],
    [["NONE", "ARAB", "RUSSIAN", "VIETNAMESE"], ["None", "Arabic", "Russian", "Vietnamese"], 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_Language_OPFOR",
    "LIST",
    ["Language (Opfor)", "Selects the language used for all Opfor stealth voice lines."],
    ["GOL Stealth", "Language"],
    [["NONE", "ARAB", "RUSSIAN", "VIETNAMESE"], ["None", "Arabic", "Russian", "Vietnamese"], 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_Language_INDEPENDENT",
    "LIST",
    ["Language (Independent)", "Selects the language used for all Independent stealth voice lines."],
    ["GOL Stealth", "Language"],
    [["NONE", "ARAB", "RUSSIAN", "VIETNAMESE"], ["None", "Arabic", "Russian", "Vietnamese"], 1],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_RadioHelpCooldown",
    "SLIDER",
    ["Radio Help Cooldown (s)", "Minimum seconds before the same radio unit can make another help call."],
    ["GOL Stealth", "General"],
    [15, 300, 120, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_TrackLifetime",
    "SLIDER",
    ["Track Lifetime (s)", "How long generated hunted tracks remain before cleanup."],
    ["GOL Stealth", "Tracker"],
    [60, 1200, 300, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_TrackSpacing",
    "SLIDER",
    ["Track Spacing (m)", "Minimum distance required before placing the next track."],
    ["GOL Stealth", "Tracker"],
    [3, 50, 10, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_TrackClass",
    "EDITBOX",
    ["Track Object Class", "Classname used for non-debug tracks."],
    ["GOL Stealth", "Tracker"],
    "Land_ClutterCutter_small_F",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_TrackDebugClass",
    "EDITBOX",
    ["Track Debug Class", "Classname used when debug track objects are enabled."],
    ["GOL Stealth", "Tracker"],
    "Sign_Arrow_Green_F",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_DebugTrackObject",
    "CHECKBOX",
    ["Use Visible Debug Track Object", "If enabled, hunted tracks use the debug track classname."],
    ["GOL Stealth", "Debug"],
    false,
    1
] call CBA_fnc_addSetting;
