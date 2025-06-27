diag_log "OKS_GOL_Misc: XEH_preInit_gear_ai.sqf executed";

// CBA Settings for AI Gear
[
    "LAT_Chance",
    "SLIDER",
    ["Chance for Light AT (AI)", "Chance for Light AT to be given to AI (0 = never, 1 = always)."],
    "GOL Gear AI",
    [0, 1, 0.25, 2],
    1
] call CBA_fnc_addSetting;

[
    "MAT_Chance",
    "SLIDER",
    ["Chance for Medium AT (AI)", "Chance for Medium AT to be given to AI (0 = never, 1 = always)."],
    "GOL Gear AI",
    [0, 1, 0.15, 2],
    1
] call CBA_fnc_addSetting;

[
    "UGL_Chance",
    "SLIDER",
    ["Chance for UGL (AI)", "Chance for UGL to be given to AI (0 = never, 1 = always)."],
    "GOL Gear AI",
    [0, 1, 0.25, 2],
    1
] call CBA_fnc_addSetting;

[
    "Static_Enable_Chance",
    "SLIDER",
    ["Static AI Enable Chance", "Chance per loop to enable a Static AI to move (0 = never, 1 = always)."],
    "GOL Gear AI",
    [0, 1, 0.4, 2],
    1
] call CBA_fnc_addSetting;

[
    "Static_Enable_Refresh",
    "SLIDER",
    ["Static AI Enable Refresh (s)", "Delay per loop (in seconds) to enable movement."],
    "GOL Gear AI",
    [1, 120, 60, 0],
    1
] call CBA_fnc_addSetting;

[
    "AIForceNVG",
    "CHECKBOX",
    ["Force NVGs for AI", "Forces addition of NVGs for AI."],
    "GOL Gear AI",
    false,
    1
] call CBA_fnc_addSetting;

[
    "AIForceNVGClassname",
    "EDITBOX",
    ["AI NVG Classname", "Classname to be used as NVG for AI. Leave blank for none."],
    "GOL Gear AI",
    "", // Default is nil/empty
    1
] call CBA_fnc_addSetting;

// CheckBox: Enable OKS Remove Vehicle HE.
[
    "GOL_RemoveVehicleHE_Enabled",
    "CHECKBOX",
    ["Remove HE Rounds from Vehicles", "When enabled, Russian/Soviet vehicles variants will have their HE rounds removed."],
    "GOL Gear AI",
    true,
    1
] call CBA_fnc_addSetting;

// CheckBox: Enable Custom Vehicle Appearance for AI Vehicles.
[
    "GOL_VehicleAppearanceAI",
    "CHECKBOX",
    ["Enable AI Vehicle Appearance", "When enabled, certain AI Vehicles will have randomized vehicle appearance."],
    "GOL Gear AI",
    true,
    1
] call CBA_fnc_addSetting;

// CheckBox: Enable OKS Remove ATGM.
[
    "GOL_RemoveVehicleATGM_Enabled",
    "CHECKBOX",
    ["Remove ATGM Rounds from Vehicles", "When enabled, Russian/Soviet vehicles variants will have their ATGM rounds removed."],
    "GOL Gear AI",
    true,
    1
] call CBA_fnc_addSetting;