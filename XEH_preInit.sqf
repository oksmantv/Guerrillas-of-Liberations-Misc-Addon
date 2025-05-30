diag_log "OKS_GOL_Misc: XEH_preInit.sqf executed";

/// CORE
[
    "OKS_CORE_Enabled",
    "CHECKBOX",
    ["Enables features from FW Version 2.7", "Enables all features added in the GOL Misc Addon."],
    "GOL_CORE",
    false,
    1
] call CBA_fnc_addSetting;

// CBA Settings for Dynamic
[
    "GOL_Dynamic_Faction",
    "LIST",
    [
        "Faction", 
        "Select the faction to use for dynamic operations."
    ],
    "GOL_Dynamic",
    [
        // Display names
        [
            "CSAT",
            "Chernarussian Defence Force",
            "Livonian Defence Force",
            "Tanoan Army",
            "Ardistan Army",
            "Chedaki Insurgents",
            "Communist Rebels",
            "Desert Insurgents",
            "Desert Militia",
            "Russia Armed Forces",
            "Soviet Army",
            "Takistani Army",
            "National Party (NAPA)"
        ],
        // Values (do not change, used in scripts)
        [
            "CSAT",
            "CDF",
            "LDF",
            "TANOA",
            "ARDISTAN",
            "CHEDAKI",
            "COMMUNIST_REBELS",
            "DESERT_INSURGENTS",
            "DESERT_MILITIA",
            "RUSSIA_MODERN",
            "SOVIET",
            "TKA",
            "NAPA"
        ],
        0 // Default (CSAT)
    ],
    1
] call CBA_fnc_addSetting;


// CBA Settings for MHQ
[
    "GOL_MhqSafeZone",
    "SLIDER",
    ["MHQ Safe Zone Radius", "Radius (in meters) of the MHQ safe zone."],
    "GOL_MHQ",
    [25, 300, 100, 0], // [min, max, default, decimals]
    1
] call CBA_fnc_addSetting;

// CBA Settings for GOL Gear
[
    "GOL_MAGNIFIED_OPTICS",
    "CHECKBOX",
    ["Allow Magnified 2x Sights", "Allows magnified 2x sights to be selected from the Arsenal."],
    "GOL_Gear",
    true, // default value (true/false)
    1,    // isGlobal (1 = global, 0 = local)
    { },  // onChanged (optional)
    false // isLocalOnly (false = global)
] call CBA_fnc_addSetting;

[
    "GOL_OPTICS",
    "CHECKBOX",
    ["Allow Optics", "Allows sights to be selected from the Arsenal."],
    "GOL_Gear",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_WEAPONS",
    "CHECKBOX",
    ["Allow Weapon Variations", "Allows weapon variations to be selected from Arsenal."],
    "GOL_Gear",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_ARSENAL_ALLOWED",
    "CHECKBOX",
    ["Allow Attachment Menu", "Allows Attachment Menu in Arsenal."],
    "GOL_Gear",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_AllowSpecialistGroundRoles",
    "CHECKBOX",
    ["Allow Specialist Ground Roles", "Allows specialist ground roles (Dragon, Light Rifleman, Ammo Bearer, Anti-Air, Heavy AT)"],
    "GOL_Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_AllowSpecialistAirRoles",
    "CHECKBOX",
    ["Allow Specialist Air Roles", "Allows specialist air roles (Para-Rescueman, Jet Pilot, Marksman)."],
    "GOL_Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_ENTRENCH",
    "CHECKBOX",
    ["Allow Entrenching Tools", "Adds Entrenching Tools to certain roles."],
    "GOL_Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_WIRECUTTER",
    "CHECKBOX",
    ["Allow Wirecutters", "Adds Wirecutters to Riflemen."],
    "GOL_Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_ForceNVG",
    "CHECKBOX",
    ["Force NVGs", "Forces addition of NVGs."],
    "GOL_Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_ForceNVGClassname",
    "EDITBOX",
    ["Force NVG Classname", "Forces change of NVGs."],
    "GOL_Gear",
    "",
    1
] call CBA_fnc_addSetting;

// CBA Settings for AI Gear
[
    "LAT_Chance",
    "SLIDER",
    ["Chance for Light AT (AI)", "Chance for Light AT to be given to AI (0 = never, 1 = always)."],
    "GOL_Gear_AI",
    [0, 1, 0.25, 2],
    1
] call CBA_fnc_addSetting;

[
    "MAT_Chance",
    "SLIDER",
    ["Chance for Medium AT (AI)", "Chance for Medium AT to be given to AI (0 = never, 1 = always)."],
    "GOL_Gear_AI",
    [0, 1, 0.15, 2],
    1
] call CBA_fnc_addSetting;

[
    "UGL_Chance",
    "SLIDER",
    ["Chance for UGL (AI)", "Chance for UGL to be given to AI (0 = never, 1 = always)."],
    "GOL_Gear_AI",
    [0, 1, 0.25, 2],
    1
] call CBA_fnc_addSetting;

[
    "Static_Enable_Chance",
    "SLIDER",
    ["Static AI Enable Chance", "Chance per loop to enable a Static AI to move (0 = never, 1 = always)."],
    "GOL_Gear_AI",
    [0, 1, 0.4, 2],
    1
] call CBA_fnc_addSetting;

[
    "Static_Enable_Refresh",
    "SLIDER",
    ["Static AI Enable Refresh (s)", "Delay per loop (in seconds) to enable movement."],
    "GOL_Gear_AI",
    [1, 120, 60, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_AIForceNVG",
    "CHECKBOX",
    ["Force NVGs for AI", "Forces addition of NVGs for AI."],
    "GOL_Gear_AI",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_AIForceNVGClassname",
    "EDITBOX",
    ["AI NVG Classname", "Classname to be used as NVG for AI. Leave blank for none."],
    "GOL_Gear_AI",
    "", // Default is nil/empty
    1
] call CBA_fnc_addSetting;

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
    "GOL_Hunt",
    [10, 100, 40, 0]
] call CBA_fnc_addSetting;

// Settings for OKS Remove Vehicle HE
// CheckBox: Enable OKS Remove Vehicle HE.
[
    "OKS_RemoveVehicleHE_Enabled",
    "CHECKBOX",
    ["Remove HE Rounds from Vehicles", "When enabled, Russian/Soviet vehicles variants will have their HE rounds removed."],
    "GOL_RemoveVehicleHE",
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
    "GOL_RemoveVehicleHE",
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
    "GOL_Suppression",
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
    "GOL_Suppression",
    false,
    1,
    {},
    true
] call CBA_fnc_addSetting;

[
    "OKS_Suppressed_Threshold",
    "SLIDER",
    ["Suppression Threshold", "For every friendly below 10 in the vicinity (this value) of the candidate, chance to surrender will increase."],
    "GOL_Suppression",
    [0, 1, 0.75, 1]
] call CBA_fnc_addSetting;

[
    "OKS_Suppressed_MinimumTime",
    "SLIDER",
    ["Minimum Suppressed Time", "Sets the minimum suppressed time for a unit to recover from suppression."],
    "GOL_Suppression",
    [1, 14, 6, 0]
] call CBA_fnc_addSetting;

[
    "OKS_Suppressed_MaximumTime",
    "SLIDER",
    ["Maximum Suppressed Time", "Sets the maximum suppressed time for a unit to recover from suppression."],
    "GOL_Suppression",
    [2, 15, 10, 0]
] call CBA_fnc_addSetting;

// CBA Settings for OKS_Surrender
// Checkbox: Enable Surrender
[
    "OKS_Surrender_Enabled",
    "CHECKBOX",
    ["Enable Surrender", "When enabled, AI can surrender when threatened, suppressed, shot, flashbanged."],
    "GOL_Surrender",
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
    "GOL_Surrender",
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
    "GOL_Surrender",
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
    "GOL_Surrender",
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
    "GOL_Surrender",
    [20, 300, 200, 0]
] call CBA_fnc_addSetting;

// Slider: Surrender Chance (0.0 to 1.0, default 0.1, 2 decimals)
[
    "OKS_Surrender_Chance",
    "SLIDER",
    ["Surrender Chance", "Probability (0 = never, 0.3 = very likely) that AI will surrender."],
    "GOL_Surrender",
    [0, 0.3, 0.05, 2]
] call CBA_fnc_addSetting;

// Slider: Surrender Chance Weapon Aim (0.0 to 1.0, default 0.1, 2 decimals)
[
    "OKS_Surrender_ChanceWeaponAim",
    "SLIDER",
    ["Surrender Chance Weapon Aim", "Probability (0 = never, 0.3 = very likely) that AI will surrender when aimed at."],
    "GOL_Surrender",
    [0, 0.3, 0.05, 2]
] call CBA_fnc_addSetting;

// Slider: Surrender Distance (10 to 300 meters, default 30, 0 decimals)
[
    "OKS_Surrender_Distance",
    "SLIDER",
    ["Surrender Distance", "Maximum distance (in meters) for surrender checks."],
    "GOL_Surrender",
    [10, 300, 200, 0]
] call CBA_fnc_addSetting;

// Slider: Surrender Distance for Aiming (10 to 100 meters, default 50, 0 decimals)
[
    "OKS_Surrender_DistanceWeaponAim",
    "SLIDER",
    ["Surrender Distance Weapon Aim", "Maximum distance (in meters) for surrender checks by player aiming at unit."],
    "GOL_Surrender",
    [10, 100, 50, 0]
] call CBA_fnc_addSetting;

// Settings for OKS FaceSwap
// CheckBox: Enable OKS Face Swap.
[
    "OKS_FaceSwap_Enabled",
    "CHECKBOX",
    ["Allow FaceSwap", "When enabled, AI will change faces based on your choices on mission start and when spawned."],
    "GOL_FaceSwap",
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
    "GOL_FaceSwap",
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
    "GOL_FaceSwap",
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
    "GOL_FaceSwap",
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
    "GOL_FaceSwap",
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
    "GOL_FaceSwap",
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
    "GOL_Packing",                    // Category in Addon Options
    "B_UAFPV_RKG_AP",                    // Default value
    true                                 // Is global (true for mission/server-wide, false for local)
] call cba_settings_fnc_init;

[
    "OKS_PackedDroneATClass",
    "EDITBOX",
    ["Packed AT Drone Class", "Classname for the packed AT drone."],
    "GOL_Packing",
    "B_UAFPV_AT",
    true
] call cba_settings_fnc_init;

[
    "OKS_PackedDroneReconClass",
    "EDITBOX",
    ["Packed Recon Drone Class", "Classname for the packed Recon drone."],
    "GOL_Packing",
    "B_UAV_01_F",
    true
] call cba_settings_fnc_init;

[
    "OKS_PackedDroneSupplyClass",
    "EDITBOX",
    ["Packed Supply Drone Class", "Classname for the packed Supply drone."],
    "GOL_Packing",
    "B_UAV_06_F",
    true
] call cba_settings_fnc_init;

[
    "OKS_PackedHMGClass", // Unique setting variable name
    "EDITBOX",                           // Setting type (string input)
    ["Packed Static HMG Class", "Classname for the Static HMG."], // Display name & tooltip
    "GOL_Packing",                    // Category in Addon Options
    "RHS_M2StaticMG_USMC_D",                    // Default value
    true                                 // Is global (true for mission/server-wide, false for local)
] call cba_settings_fnc_init;

[
    "OKS_PackedGMGClass",
    "EDITBOX",
    ["Packed Static GMG Class", "Classname for the packed Static GMG."],
    "GOL_Packing",
    "RHS_MK19_TriPod_USMC_WD",
    true
] call cba_settings_fnc_init;

[
    "OKS_PackedATClass",
    "EDITBOX",
    ["Packed Static AT Class", "Classname for the packed Static AT."],
    "GOL_Packing",
    "RHS_TOW_TriPod_USMC_D",
    true
] call cba_settings_fnc_init;

[
    "OKS_PackedMortarClass",
    "EDITBOX",
    ["Packed Static Mortar Class", "Classname for the packed Static Mortar."],
    "GOL_Packing",
    "B_G_Mortar_01_F",
    true
] call cba_settings_fnc_init;