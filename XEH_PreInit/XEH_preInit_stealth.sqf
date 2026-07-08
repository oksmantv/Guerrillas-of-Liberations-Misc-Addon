diag_log "OKS_GOL_Misc: XEH_preInit_stealth.sqf executed";

[
    "GOL_Stealth_Enabled",
    "CHECKBOX",
    ["Enable Stealth Subsystem", "Enables stealth helper functions (radio chatter, hunted tracks, tracker behavior)."],
    ["GOL STEALTH", "General"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_Debug",
    "CHECKBOX",
    ["Enable Stealth DEBUG", "Enables stealth debug logging through OKS_fnc_LogDebug."],
    ["GOL STEALTH", "Debug"],
    false,
    1
] call CBA_fnc_addSetting;

// Side profile selection (no custom user input; only curated addon profiles)
[
    "GOL_Stealth_ProfileRadio_BLUFOR",
    "LIST",
    ["Radio Profile (BLUFOR)", "Selects the radio chatter sound profile used for BLUFOR units."],
    ["GOL STEALTH", "Profiles"],
    [["NONE", "ARAB", "RUSSIAN", "VIETNAMESE"], ["None", "Arab", "Russian", "Vietnamese"], 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_ProfileRadio_OPFOR",
    "LIST",
    ["Radio Profile (OPFOR)", "Selects the radio chatter sound profile used for OPFOR units."],
    ["GOL STEALTH", "Profiles"],
    [["NONE", "ARAB", "RUSSIAN", "VIETNAMESE"], ["None", "Arab", "Russian", "Vietnamese"], 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_ProfileRadio_INDEPENDENT",
    "LIST",
    ["Radio Profile (INDEPENDENT)", "Selects the radio chatter sound profile used for Independent units."],
    ["GOL STEALTH", "Profiles"],
    [["NONE", "ARAB", "RUSSIAN", "VIETNAMESE"], ["None", "Arab", "Russian", "Vietnamese"], 1],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_ProfileTalk_BLUFOR",
    "LIST",
    ["Talk Profile (BLUFOR)", "Selects the proximity talk/chatter profile used for BLUFOR units."],
    ["GOL STEALTH", "Profiles"],
    [["NONE", "ARAB", "RUSSIAN", "VIETNAMESE"], ["None", "Arab", "Russian", "Vietnamese"], 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_ProfileTalk_OPFOR",
    "LIST",
    ["Talk Profile (OPFOR)", "Selects the proximity talk/chatter profile used for OPFOR units."],
    ["GOL STEALTH", "Profiles"],
    [["NONE", "ARAB", "RUSSIAN", "VIETNAMESE"], ["None", "Arab", "Russian", "Vietnamese"], 2],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_ProfileTalk_INDEPENDENT",
    "LIST",
    ["Talk Profile (INDEPENDENT)", "Selects the proximity talk/chatter profile used for Independent units."],
    ["GOL STEALTH", "Profiles"],
    [["NONE", "ARAB", "RUSSIAN", "VIETNAMESE"], ["None", "Arab", "Russian", "Vietnamese"], 3],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_ProfileReaction_BLUFOR",
    "LIST",
    ["Reaction Profile (BLUFOR)", "Selects the alert/yell profile used by BLUFOR sentry reaction."],
    ["GOL STEALTH", "Profiles"],
    [["NONE", "YELL_GENERIC", "ARAB", "RUSSIAN", "VIETNAMESE_Y"], ["None", "Yell (Generic)", "Arab", "Russian", "Vietnamese (Y)"], 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_ProfileReaction_OPFOR",
    "LIST",
    ["Reaction Profile (OPFOR)", "Selects the alert/yell profile used by OPFOR sentry reaction."],
    ["GOL STEALTH", "Profiles"],
    [["NONE", "YELL_GENERIC", "ARAB", "RUSSIAN", "VIETNAMESE_Y"], ["None", "Yell (Generic)", "Arab", "Russian", "Vietnamese (Y)"], 1],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_ProfileReaction_INDEPENDENT",
    "LIST",
    ["Reaction Profile (INDEPENDENT)", "Selects the alert/yell profile used by Independent sentry reaction."],
    ["GOL STEALTH", "Profiles"],
    [["NONE", "YELL_GENERIC", "ARAB", "RUSSIAN", "VIETNAMESE_Y"], ["None", "Yell (Generic)", "Arab", "Russian", "Vietnamese (Y)"], 4],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_ProfileRadioHelp_BLUFOR",
    "LIST",
    ["Radio Help Profile (BLUFOR)", "Selects the radio profile used when BLUFOR sentries call for reinforcement."],
    ["GOL STEALTH", "Profiles"],
    [["NONE", "LEGACY_HELP", "ARAB", "RUSSIAN", "VIETNAMESE"], ["None", "Legacy Help", "Arab", "Russian", "Vietnamese"], 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_ProfileRadioHelp_OPFOR",
    "LIST",
    ["Radio Help Profile (OPFOR)", "Selects the radio profile used when OPFOR sentries call for reinforcement."],
    ["GOL STEALTH", "Profiles"],
    [["NONE", "LEGACY_HELP", "ARAB", "RUSSIAN", "VIETNAMESE"], ["None", "Legacy Help", "Arab", "Russian", "Vietnamese"], 3],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_ProfileRadioHelp_INDEPENDENT",
    "LIST",
    ["Radio Help Profile (INDEPENDENT)", "Selects the radio profile used when Independent sentries call for reinforcement."],
    ["GOL STEALTH", "Profiles"],
    [["NONE", "LEGACY_HELP", "ARAB", "RUSSIAN", "VIETNAMESE"], ["None", "Legacy Help", "Arab", "Russian", "Vietnamese"], 4],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_RadioHelpCooldown",
    "SLIDER",
    ["Radio Help Cooldown (s)", "Minimum seconds before the same radio unit can make another help call."],
    ["GOL STEALTH", "General"],
    [15, 300, 120, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_TrackLifetime",
    "SLIDER",
    ["Track Lifetime (s)", "How long generated hunted tracks remain before cleanup."],
    ["GOL STEALTH", "Tracker"],
    [60, 1200, 300, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_TrackSpacing",
    "SLIDER",
    ["Track Spacing (m)", "Minimum distance required before placing the next track."],
    ["GOL STEALTH", "Tracker"],
    [3, 50, 10, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_TrackClass",
    "EDITBOX",
    ["Track Object Class", "Classname used for non-debug tracks."],
    ["GOL STEALTH", "Tracker"],
    "Land_ClutterCutter_small_F",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_TrackDebugClass",
    "EDITBOX",
    ["Track Debug Class", "Classname used when debug track objects are enabled."],
    ["GOL STEALTH", "Tracker"],
    "Sign_Arrow_Green_F",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Stealth_DebugTrackObject",
    "CHECKBOX",
    ["Use Visible Debug Track Object", "If enabled, hunted tracks use the debug track classname."],
    ["GOL STEALTH", "Debug"],
    false,
    1
] call CBA_fnc_addSetting;
