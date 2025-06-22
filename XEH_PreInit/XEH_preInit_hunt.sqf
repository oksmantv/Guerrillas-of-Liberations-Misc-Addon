diag_log "OKS_GOL_Misc: XEH_preInit_hunt.sqf executed";

// Settings for NEKY Hunt
[
    "GOL_Hunt_MaxCount",
    "SLIDER",
    ["Max count of Hunters", "The maximum allowed enemy hunters at any given time."],
    "GOL Hunt",
    [10, 100, 40, 0],
    1
] call CBA_fnc_addSetting;

// Minimum spawn distance (Slider)
[
    "GOL_Hunt_MinDistance",
    "SLIDER",
    ["Minimum AI spawn distance from players", "Minimum distance in meters the AI spawn location has to be from all players."],
    "GOL Hunt",
    [50, 1000, 100, 0], // [min, max, default, precision]
    true
] call CBA_fnc_addSetting;

// Force respawn multiplier (Slider)
[
    "GOL_ForceRespawnMultiplier",
    "SLIDER",
    ["Force Respawn Multiplier", "_MinDistance * Multiplier = if distance to hunting target is greater than this, change target or respawn hunting group closer to players."],
    "GOL Hunt",
    [1, 1000, 100, 0],
    true
] call CBA_fnc_addSetting;

// Update frequency (Slider)
[
    "GOL_UpdateFreq",
    "SLIDER",
    ["Update Frequency", "Frequency in seconds that the hunting AI group will be updated with prey's position."],
    "GOL Hunt",
    [10, 600, 60, 0],
    true
] call CBA_fnc_addSetting;

// Max cargo seats (Slider)
[
    "GOL_MaxCargoSeats",
    "SLIDER",
    ["Max Cargo Seats", "Max amount of Cargo seats, will max out seats available in vehicle at most."],
    "GOL Hunt",
    [1, 20, 6, 0],
    true
] call CBA_fnc_addSetting;

// Leader classes (Edit box)
[
    "GOL_Leaders_BLUFOR",
    "EDITBOX",
    ["BLUFOR Leader Classes", "Comma-separated list of BLUFOR leader classnames."],
    "GOL Hunt",
    "B_Soldier_TL_F,B_Soldier_TL_F",
    true
] call CBA_fnc_addSetting;

[
    "GOL_Units_BLUFOR",
    "EDITBOX",
    ["BLUFOR Unit Classes", "Comma-separated list of BLUFOR unit classnames."],
    "GOL Hunt",
    "B_Soldier_LAT_F,B_Soldier_GL_F,B_medic_F,B_Soldier_AR_F,B_Soldier_A_F",
    true
] call CBA_fnc_addSetting;

// Leader classes (Edit box)
[
    "GOL_Leaders_INDEPENDENT",
    "EDITBOX",
    ["INDEPENDENT Leader Classes", "Comma-separated list of INDEPENDENT leader classnames."],
    "GOL Hunt",
    "I_Soldier_TL_F,I_Soldier_TL_F",
    true
] call CBA_fnc_addSetting;

[
    "GOL_Units_INDEPENDENT",
    "EDITBOX",
    ["INDEPENDENT Unit Classes", "Comma-separated list of INDEPENDENT unit classnames."],
    "GOL Hunt",
    "I_Soldier_LAT_F,I_Soldier_GL_F,I_medic_F,I_Soldier_AR_F,I_Soldier_A_F",
    true
] call CBA_fnc_addSetting;

// Leader classes (Edit box)
[
    "GOL_Leaders_OPFOR",
    "EDITBOX",
    ["OPFOR Leader Classes", "Comma-separated list of OPFOR leader classnames."],
    "GOL Hunt",
    "O_Soldier_TL_F,O_Soldier_TL_F",
    true
] call CBA_fnc_addSetting;

[
    "GOL_Units_OPFOR",
    "EDITBOX",
    ["OPFOR Unit Classes", "Comma-separated list of OPFOR unit classnames."],
    "GOL Hunt",
    "O_Soldier_LAT_F,O_Soldier_GL_F,O_medic_F,O_Soldier_AR_F,O_Soldier_A_F",
    true
] call CBA_fnc_addSetting;