diag_log "OKS_GOL_Misc: XEH_preInit_amphibious.sqf executed";

// CBA Settings for GOL Amphibious
// These settings drive OKS_fnc_BeachLanding / amphibious-related tooling.

[
    "GOL_Amphibious_Debug",
    "CHECKBOX",
    ["Enable Amphibious Debug", "When enabled, Beach Landing will emit detailed staged logs to RPT."],
    ["GOL Amphibious", "Debug"],
    false,
    1
] call cba_settings_fnc_init;

[
    "GOL_Amphibious_DebugChat",
    "CHECKBOX",
    ["Echo Amphibious Debug To Chat", "If enabled, debug messages are also echoed to systemChat for all players (can be noisy)."],
    ["GOL Amphibious", "Debug"],
    false,
    1
] call cba_settings_fnc_init;

[
    "GOL_Amphibious_ApproachSpeedKph",
    "SLIDER",
    ["Approach Speed (km/h)", "Steering target speed while approaching the beach."],
    ["GOL Amphibious", "Beach Landing"],
    [0, 90, 55, 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_Amphibious_CutPropulsionDistanceMeters",
    "SLIDER",
    ["Cut Propulsion Distance (m)", "Stop steering once within this distance of the target position (fallback if land scan is disabled)."],
    ["GOL Amphibious", "Beach Landing"],
    [0, 150, 5, 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_Amphibious_MaxApproachTimeSeconds",
    "SLIDER",
    ["Max Approach Time (s)", "Failsafe timeout for the steering/approach loop."],
    ["GOL Amphibious", "Beach Landing"],
    [0, 600, 300, 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_Amphibious_BeachScanEnabled",
    "CHECKBOX",
    ["Enable Land-Ahead Scan", "If enabled, the steering loop stops as soon as a point ahead of the boat is detected as land (surfaceIsWater == false)."],
    ["GOL Amphibious", "Beach Landing"],
    true,
    1
] call cba_settings_fnc_init;

[
    "GOL_Amphibious_BeachScanAheadMeters",
    "SLIDER",
    ["Land-Ahead Scan Distance (m)", "Distance ahead of the boat to probe for land."],
    ["GOL Amphibious", "Beach Landing"],
    [0, 15, 5, 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_Amphibious_CrewDismountWhenNoTargets",
    "CHECKBOX",
    ["Crew Dismount When No Targets", "If enabled, the remaining boat crew (driver/commander/gunners) will dismount and join the assault group once no enemies are nearby for a short duration."],
    ["GOL Amphibious", "Boat Crew"],
    true,
    1
] call cba_settings_fnc_init;

[
    "GOL_Amphibious_TargetCheckRangeMeters",
    "SLIDER",
    ["Target Check Range (m)", "Search radius around the boat to decide if enemies exist (used to keep crew mounted to provide fire support)."],
    ["GOL Amphibious", "Boat Crew"],
    [0, 1500, 400, 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_Amphibious_TargetCheckIntervalSeconds",
    "SLIDER",
    ["Target Check Interval (s)", "How often to scan for nearby enemies."],
    ["GOL Amphibious", "Boat Crew"],
    [0.1, 10, 2, 1],
    1
] call cba_settings_fnc_init;

[
    "GOL_Amphibious_NoTargetTimeoutSeconds",
    "SLIDER",
    ["No Target Timeout (s)", "If no enemies are detected for this long, crew will dismount."],
    ["GOL Amphibious", "Boat Crew"],
    [0, 120, 15, 0],
    1
] call cba_settings_fnc_init;