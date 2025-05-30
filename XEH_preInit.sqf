diag_log "OKS_GOL_Misc: XEH_preInit.sqf executed";

// CBA Settings for OKS ORBAT
[
    "GOL_Composition",
    "LIST",
    ["ORBAT Composition", "Set the ORBAT Composition."],
    "GOL_ORBAT",
    [
        [0, 1],
        ["Infantry", "Mechanized"], 
        0 // Default index for Infantry
    ],
    true // Global setting
] call CBA_settings_fnc_init;

// Settings for NEKY Hunt
[
    "OKS_Hunt_MaxCount",
    "SLIDER",
    ["Max count of Hunters", "The maximum allowed enemy hunters at any given time."],
    "GOL_OKS_Hunt",
    [10, 100, 40, 0]
] call CBA_fnc_addSetting;

// Settings for OKS Remove Vehicle HE
// CheckBox: Enable OKS Remove Vehicle HE.
[
    "OKS_RemoveVehicleHE_Enabled",
    "CHECKBOX",
    ["Remove HE Rounds from Vehicles", "When enabled, Russian/Soviet vehicles variants will have their HE rounds removed."],
    "GOL_OKS_RemoveVehicleHE",
    true,
    1,
    {},
    true
] call CBA_fnc_addSetting;
// CheckBox: Enable OKS Remove ATGM.
[
    "OKS_RemoveVehicleATGM_Enabled",
    "CHECKBOX",
    ["Remove ATGM Rounds from Vehicles", "When enabled, Russian/Soviet vehicles variants will have their ATGM rounds removed."],
    "GOL_OKS_RemoveVehicleHE",
    true,
    1,
    {},
    true
] call CBA_fnc_addSetting;

// Settings for OKS Suppression
// CheckBox: Enable OKS Suppression.
[
    "OKS_Suppression_Enabled",
    "CHECKBOX",
    ["Enable Suppression", "When enabled, AI will be able to be suppressed."],
    "GOL_OKS_Suppression",
    true,
    1,
    {},
    true
] call CBA_fnc_addSetting;

// CheckBox: Enable OKS Suppression Debug.
[
    "OKS_Suppression_Debug",
    "CHECKBOX",
    ["Enable Suppression Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL_OKS_Suppression",
    false,
    1,
    {},
    true
] call CBA_fnc_addSetting;

[
    "OKS_Suppressed_Threshold",
    "SLIDER",
    ["Suppression Threshold", "For every friendly below 10 in the vicinity (this value) of the candidate, chance to surrender will increase."],
    "GOL_OKS_Suppression",
    [0, 1, 0.75, 1]
] call CBA_fnc_addSetting;

[
    "OKS_Suppressed_MinimumTime",
    "SLIDER",
    ["Minimum Suppressed Time", "Sets the minimum suppressed time for a unit to recover from suppression."],
    "GOL_OKS_Suppression",
    [1, 14, 6, 0]
] call CBA_fnc_addSetting;

[
    "OKS_Suppressed_MaximumTime",
    "SLIDER",
    ["Maximum Suppressed Time", "Sets the maximum suppressed time for a unit to recover from suppression."],
    "GOL_OKS_Suppression",
    [2, 15, 10, 0]
] call CBA_fnc_addSetting;

// CBA Settings for OKS_Surrender
// Checkbox: Enable Surrender
[
    "OKS_Surrender_Enabled",
    "CHECKBOX",
    ["Enable Surrender", "When enabled, AI can surrender when threatened, suppressed, shot, flashbanged."],
    "GOL_OKS_Surrender",
    true,
    1,
    {},
    true
] call CBA_fnc_addSetting;

// Checkbox: Enable Surrender Debug
[
    "OKS_Surrender_Debug",
    "CHECKBOX",
    ["Enable Surrender Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL_OKS_Surrender",
    false,
    1,
    {},
    true
] call CBA_fnc_addSetting;

// Checkbox: Allow Surrender by Shot
[
    "OKS_Surrender_Shot",
    "CHECKBOX",
    ["Allow Surrender by Shot", "When enabled, AI can surrender when shot at."],
    "GOL_OKS_Surrender",
    true,
    1,
    {},
    true
] call CBA_fnc_addSetting;

// Checkbox: Allow Surrender by Flashbang
[
    "OKS_Surrender_Flashbang",
    "CHECKBOX",
    ["Allow Surrender by Flashbang", "When enabled, AI can surrender when flashbanged."],
    "GOL_OKS_Surrender",
    true,
    1,
    {},
    true
] call CBA_fnc_addSetting;

// Slider: Near Friendly Distance (20 to 300, default 200, 2 decimals)
[
    "OKS_Surrender_FriendlyDistance",
    "SLIDER",
    ["Check Friendly Distance", "For every friendly below 10 in the vicinity (this value) of the candidate, chance to surrender will increase."],
    "GOL_OKS_Surrender",
    [20, 300, 200, 0]
] call CBA_fnc_addSetting;

// Slider: Surrender Chance (0.0 to 1.0, default 0.1, 2 decimals)
[
    "OKS_Surrender_Chance",
    "SLIDER",
    ["Surrender Chance", "Probability (0 = never, 0.3 = very likely) that AI will surrender."],
    "GOL_OKS_Surrender",
    [0, 0.3, 0.05, 2]
] call CBA_fnc_addSetting;

// Slider: Surrender Chance Weapon Aim (0.0 to 1.0, default 0.1, 2 decimals)
[
    "OKS_Surrender_ChanceWeaponAim",
    "SLIDER",
    ["Surrender Chance Weapon Aim", "Probability (0 = never, 0.3 = very likely) that AI will surrender when aimed at."],
    "GOL_OKS_Surrender",
    [0, 0.3, 0.05, 2]
] call CBA_fnc_addSetting;

// Slider: Surrender Distance (10 to 300 meters, default 30, 0 decimals)
[
    "OKS_Surrender_Distance",
    "SLIDER",
    ["Surrender Distance", "Maximum distance (in meters) for surrender checks."],
    "GOL_OKS_Surrender",
    [10, 300, 200, 0]
] call CBA_fnc_addSetting;

// Slider: Surrender Distance for Aiming (10 to 100 meters, default 50, 0 decimals)
[
    "OKS_Surrender_DistanceWeaponAim",
    "SLIDER",
    ["Surrender Distance Weapon Aim", "Maximum distance (in meters) for surrender checks by player aiming at unit."],
    "GOL_OKS_Surrender",
    [10, 100, 50, 0]
] call CBA_fnc_addSetting;

// Settings for OKS FaceSwap
// CheckBox: Enable OKS Face Swap.
[
    "OKS_FaceSwap_Enabled",
    "CHECKBOX",
    ["Allow FaceSwap", "When enabled, AI will change faces based on your choices on mission start and when spawned."],
    "GOL_OKS_FaceSwap",
    true,
    1,
    {},
    true
] call CBA_fnc_addSetting;

// Checkbox: Enable Surrender Debug
[
    "OKS_FaceSwap_Debug",
    "CHECKBOX",
    ["Enable FaceSwap Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL_OKS_FaceSwap",
    false,
    1,
    {},
    true
] call CBA_fnc_addSetting;

// CBA Settings for OKS FaceSwap
[
    "OKS_FaceSwap_BLUFOR",
    "LIST",
    ["BLUFOR Ethnicity", "Set ethnic appearance for spawned BLUFOR units"],
    "GOL_OKS_FaceSwap",
    [
        ["african", "asian", "english", "american", "middleeast", "russian", "french", "greek", "polish"],
        ["African", "Asian", "English", "American", "Middle Eastern", "Russian", "French", "Greek", "Polish"], 
        3 // Default index for middleeast
    ],
    true // Global setting
] call CBA_settings_fnc_init;

[
    "OKS_FaceSwap_OPFOR",
    "LIST",
    ["OPFOR Ethnicity", "Set ethnic appearance for spawned OPFOR units"],
    "GOL_OKS_FaceSwap",
    [
        ["african", "asian", "english", "american", "middleeast", "russian", "french", "greek", "polish"],
        ["African", "Asian", "English", "American", "Middle Eastern", "Russian", "French", "Greek", "Polish"], 
        4 // Default index for middleeast
    ],
    true // Global setting
] call CBA_settings_fnc_init;

[
    "OKS_FaceSwap_INDEPENDENT",
    "LIST",
    ["INDEPENDENT Ethnicity", "Set ethnic appearance for spawned INDEPENDENT units"],
    "GOL_OKS_FaceSwap",
    [
        ["african", "asian", "english", "american", "middleeast", "russian", "french", "greek", "polish"],
        ["African", "Asian", "English", "American", "Middle Eastern", "Russian", "French", "Greek", "Polish"], 
        4 // Default index for middleeast
    ],
    true // Global setting
] call CBA_settings_fnc_init;

[
    "OKS_FaceSwap_CIVILIAN",
    "LIST",
    ["CIVILIAN Ethnicity", "Set ethnic appearance for spawned CIVILIAN units"],
    "GOL_OKS_FaceSwap",
    [
        ["african", "asian", "english", "american", "middleeast", "russian", "french", "greek", "polish"],
        ["African", "Asian", "English", "American", "Middle Eastern", "Russian", "French", "Greek", "Polish"], 
        4 // Default index for middleeast
    ],
    true // Global setting
] call CBA_settings_fnc_init;

// CBA Settings for OKS Packing
[
    "OKS_PackedDroneAPClass", // Unique setting variable name
    "EDITBOX",                           // Setting type (string input)
    ["Packed AP Drone Class", "Classname for the packed AP drone."], // Display name & tooltip
    "GOL_OKS_Packing",                    // Category in Addon Options
    "B_UAFPV_RKG_AP",                    // Default value
    true                                 // Is global (true for mission/server-wide, false for local)
] call cba_settings_fnc_init;

[
    "OKS_PackedDroneATClass",
    "EDITBOX",
    ["Packed AT Drone Class", "Classname for the packed AT drone."],
    "GOL_OKS_Packing",
    "B_UAFPV_AT",
    true
] call cba_settings_fnc_init;

[
    "OKS_PackedDroneReconClass",
    "EDITBOX",
    ["Packed Recon Drone Class", "Classname for the packed Recon drone."],
    "GOL_OKS_Packing",
    "B_UAV_01_F",
    true
] call cba_settings_fnc_init;

[
    "OKS_PackedDroneSupplyClass",
    "EDITBOX",
    ["Packed Supply Drone Class", "Classname for the packed Supply drone."],
    "GOL_OKS_Packing",
    "B_UAV_06_F",
    true
] call cba_settings_fnc_init;

[
    "OKS_PackedHMGClass", // Unique setting variable name
    "EDITBOX",                           // Setting type (string input)
    ["Packed Static HMG Class", "Classname for the Static HMG."], // Display name & tooltip
    "GOL_OKS_Packing",                    // Category in Addon Options
    "RHS_M2StaticMG_USMC_D",                    // Default value
    true                                 // Is global (true for mission/server-wide, false for local)
] call cba_settings_fnc_init;

[
    "OKS_PackedGMGClass",
    "EDITBOX",
    ["Packed Static GMG Class", "Classname for the packed Static GMG."],
    "GOL_OKS_Packing",
    "RHS_MK19_TriPod_USMC_WD",
    true
] call cba_settings_fnc_init;

[
    "OKS_PackedATClass",
    "EDITBOX",
    ["Packed Static AT Class", "Classname for the packed Static AT."],
    "GOL_OKS_Packing",
    "RHS_TOW_TriPod_USMC_D",
    true
] call cba_settings_fnc_init;

[
    "OKS_PackedMortarClass",
    "EDITBOX",
    ["Packed Static Mortar Class", "Classname for the packed Static Mortar."],
    "GOL_OKS_Packing",
    "B_G_Mortar_01_F",
    true
] call cba_settings_fnc_init;