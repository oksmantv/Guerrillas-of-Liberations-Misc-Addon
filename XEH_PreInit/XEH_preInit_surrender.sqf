diag_log "OKS_GOL_Misc: XEH_preInit_surrender.sqf executed";

// CBA Settings for GOL_Surrender
// Checkbox: Enable Surrender
[
    "GOL_Surrender_Enabled",
    "CHECKBOX",
    ["Enable Surrender", "When enabled, AI can surrender when threatened, suppressed, shot, flashbanged."],
    "GOL_Surrender",
    true,
    1
] call CBA_fnc_addSetting;

// Checkbox: Allow Surrender by Shot
[
    "GOL_Surrender_Shot",
    "CHECKBOX",
    ["Allow Surrender by Shot", "When enabled, AI can surrender when shot at."],
    "GOL_Surrender",
    true,
    1
] call CBA_fnc_addSetting;

// Checkbox: Allow Surrender by Flashbang
[
    "GOL_Surrender_Flashbang",
    "CHECKBOX",
    ["Allow Surrender by Flashbang", "When enabled, AI can surrender when flashbanged."],
    "GOL_Surrender",
    true,
    1
] call CBA_fnc_addSetting;

// Slider: Near Friendly Distance (20 to 300, default 200, 2 decimals)
[
    "GOL_Surrender_FriendlyDistance",
    "SLIDER",
    ["Check Friendly Distance", "For every friendly below 10 in the vicinity (this value) of the candidate, chance to surrender will increase."],
    "GOL_Surrender",
    [20, 300, 200, 0],
    1
] call CBA_fnc_addSetting;

// Slider: Surrender Chance (0.0 to 1.0, default 0.1, 2 decimals)
[
    "GOL_Surrender_Chance",
    "SLIDER",
    ["Surrender Chance", "Probability (0 = never, 0.3 = very likely) that AI will surrender."],
    "GOL_Surrender",
    [0, 0.3, 0.05, 2],
    1
] call CBA_fnc_addSetting;

// Slider: Surrender Chance Weapon Aim (0.0 to 1.0, default 0.1, 2 decimals)
[
    "GOL_Surrender_ChanceWeaponAim",
    "SLIDER",
    ["Surrender Chance Weapon Aim", "Probability (0 = never, 0.3 = very likely) that AI will surrender when aimed at."],
    "GOL_Surrender",
    [0, 0.3, 0.05, 2],
    1
] call CBA_fnc_addSetting;

// Slider: Surrender Distance (10 to 300 meters, default 30, 0 decimals)
[
    "GOL_Surrender_Distance",
    "SLIDER",
    ["Surrender Distance", "Maximum distance (in meters) for surrender checks."],
    "GOL_Surrender",
    [10, 300, 200, 0],
    1
] call CBA_fnc_addSetting;

// Slider: Surrender Distance for Aiming (10 to 100 meters, default 50, 0 decimals)
[
    "GOL_Surrender_DistanceWeaponAim",
    "SLIDER",
    ["Surrender Distance Weapon Aim", "Maximum distance (in meters) for surrender checks by player aiming at unit."],
    "GOL_Surrender",
    [10, 100, 50, 0],
    1
] call CBA_fnc_addSetting;