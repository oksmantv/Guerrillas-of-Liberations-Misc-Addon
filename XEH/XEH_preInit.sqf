diag_log "OKS_GOL_Misc: XEH_preInit.sqf executed";

/// CORE
[
    "GOL_CORE_Enabled",
    "CHECKBOX",
    ["Enables features from FW Version 2.7", "Enables all features added in the GOL Misc Addon."],
    "GOL_CORE",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Core_Debug",
    "CHECKBOX",
    ["Enable DEBUG", "Allows for any debug messages to be broadcast. If disabled, no messages will show regardless of specific debugs turned on."],
    "GOL_DEBUG",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Ambience_Debug",
    "CHECKBOX",
    ["Enable Ambience DEBUG", "Enables debugging for enemy scripts such as the PowerGenerator, Death Score, House Destruction scripts."],
    "GOL_DEBUG",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Enemy_Debug",
    "CHECKBOX",
    ["Enable Enemy DEBUG", "Enables debugging for enemy scripts such as AdjustDamage, ForceVehicleSpeed, EnablePath etc."],
    "GOL_DEBUG",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_RotorProtection_Debug",
    "CHECKBOX",
    ["Enable Rotor DEBUG", "Enables debugging for the handleDamage scripts for Mi-8/Mi-24 rotors."],
    "GOL_DEBUG",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Unconscious_CameraDebug",
    "CHECKBOX",
    ["Enable Camera DEBUG", "Enables Camera DEBUG for unconscious state."],
    "GOL_DEBUG",
    false,
    1
] call CBA_fnc_addSetting;

// CBA Settings for Supply
[
    "NEKY_SupplyHelicopter",
    "EDITBOX",
    ["Supply Helicopter Classname", "Classname for the AI helicopter that brings in supplies and vehicles."],
    "GOL_Supply",
    "",
    1
] call cba_settings_fnc_init;

[
    "NEKY_Supply_Enabled",
    "CHECKBOX",
    ["Enable AI Resupply", "Enables AI Resupply through landings or paradrops."],
    "GOL_Supply",
    true,
    1
] call cba_settings_fnc_init;

[
    "NEKY_SupplyVehicle_Enabled",
    "CHECKBOX",
    ["Enable AI Vehicle Drop", "Enables AI Vehicle drop through paradrop."],
    "GOL_Supply",
    true,
    1
] call cba_settings_fnc_init;

[
    "NEKY_SupplyMHQ_Enabled",
    "CHECKBOX",
    ["Enable AI MHQ Drop", "Enables AI MHQ Drop through paradrop."],
    "GOL_Supply",
    true,
    1
] call cba_settings_fnc_init;

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
    "MHQSAFEZONE",
    "SLIDER",
    ["MHQ Safe Zone Radius", "Radius (in meters) of the MHQ safe zone."],
    "GOL_MHQ",
    [25, 300, 100, 0], // [min, max, default, decimals]
    1
] call CBA_fnc_addSetting;

// CBA Settings for MHQ
[
    "MHQ_ShouldBe_ServiceStation",
    "CHECKBOX",
    ["MHQ Service Station", "If enabled the MHQ vehicle itself will be a service station, if disabled, it will be loaded with a mobile service station."],
    "GOL_MHQ",
    false,
    1
] call CBA_fnc_addSetting;

// CBA Settings for MHQ
[
    "MHQ_Debug",
    "CHECKBOX",
    ["Enable MHQ DEBUG", "Enable DEBUG messages for MHQ code."],
    "GOL_DEBUG",
    false,
    1
] call CBA_fnc_addSetting;

// CBA Settings for GOL Gear
[
    "MAGNIFIED_OPTICS_ALLOW",
    "CHECKBOX",
    ["Allow Magnified 2x Sights", "Allows magnified 2x sights to be selected from the Arsenal."],
    "GOL_Gear",
    true, // default value (true/false)
    1    // isGlobal (1 = global, 0 = local)
] call CBA_fnc_addSetting;

[
    "OPTICS_ALLOW",
    "CHECKBOX",
    ["Allow Optics", "Allows sights to be selected from the Arsenal."],
    "GOL_Gear",
    true,
    1
] call CBA_fnc_addSetting;

[
    "WEAPONS_ALLOW",
    "CHECKBOX",
    ["Allow Weapon Variations", "Allows weapon variations to be selected from Arsenal."],
    "GOL_Gear",
    true,
    1
] call CBA_fnc_addSetting;

[
    "ARSENAL_ALLOW",
    "CHECKBOX",
    ["Allow Attachment Menu", "Allows Attachment Menu in Arsenal."],
    "GOL_Gear",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GroundRoles_ALLOW",
    "CHECKBOX",
    ["Allow Specialist Ground Roles", "Allows specialist ground roles (Dragon, Light Rifleman, Ammo Bearer, Anti-Air, Heavy AT)"],
    "GOL_Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "AirRoles_ALLOW",
    "CHECKBOX",
    ["Allow Specialist Air Roles", "Allows specialist air roles (Para-Rescueman, Jet Pilot, Marksman)."],
    "GOL_Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "ENTRENCH_ALLOW",
    "CHECKBOX",
    ["Allow Entrenching Tools", "Adds Entrenching Tools to certain roles."],
    "GOL_Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "WIRECUTTER_ALLOW",
    "CHECKBOX",
    ["Allow Wirecutters", "Adds Wirecutters to Riflemen."],
    "GOL_Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "ForceNVG",
    "CHECKBOX",
    ["Force NVGs", "Forces addition of NVGs."],
    "GOL_Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "ForceNVGClassname",
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
    "AIForceNVG",
    "CHECKBOX",
    ["Force NVGs for AI", "Forces addition of NVGs for AI."],
    "GOL_Gear_AI",
    false,
    1
] call CBA_fnc_addSetting;

[
    "AIForceNVGClassname",
    "EDITBOX",
    ["AI NVG Classname", "Classname to be used as NVG for AI. Leave blank for none."],
    "GOL_Gear_AI",
    "", // Default is nil/empty
    1
] call CBA_fnc_addSetting;

[
    "GOL_SelectedComposition",
    "LIST",
    ["ORBAT Composition", "Set the ORBAT Composition."],
    "GOL_ORBAT",
    [
        [0, 1],
        ["Infantry", "Mechanized"], 
        0 // Default index for Infantry
    ],
    1
] call CBA_settings_fnc_init;

// Settings for NEKY Hunt
[
    "GOL_Hunt_MaxCount",
    "SLIDER",
    ["Max count of Hunters", "The maximum allowed enemy hunters at any given time."],
    "GOL_Hunt",
    [10, 100, 40, 0],
    1
] call CBA_fnc_addSetting;

// Settings for OKS Remove Vehicle HE
// CheckBox: Enable OKS Remove Vehicle HE.
[
    "GOL_RemoveVehicleHE_Enabled",
    "CHECKBOX",
    ["Remove HE Rounds from Vehicles", "When enabled, Russian/Soviet vehicles variants will have their HE rounds removed."],
    "GOL_Gear_AI",
    true,
    1
] call CBA_fnc_addSetting;

// CheckBox: Enable Custom Vehicle Appearance for AI Vehicles.
[
    "GOL_VehicleAppearanceAI",
    "CHECKBOX",
    ["Enable AI Vehicle Appearance", "When enabled, certain AI Vehicles will have randomized vehicle appearance."],
    "GOL_Gear_AI",
    true,
    1
] call CBA_fnc_addSetting;

// CheckBox: Enable OKS Remove ATGM.
[
    "GOL_RemoveVehicleATGM_Enabled",
    "CHECKBOX",
    ["Remove ATGM Rounds from Vehicles", "When enabled, Russian/Soviet vehicles variants will have their ATGM rounds removed."],
    "GOL_Gear_AI",
    true,
    1
] call CBA_fnc_addSetting;

// Settings for OKS Suppression
// CheckBox: Enable OKS Suppression.
[
    "GOL_Suppression_Enabled",
    "CHECKBOX",
    ["Enable Suppression", "When enabled, AI will be able to be suppressed."],
    "GOL_Suppression",
    true,
    1
] call CBA_fnc_addSetting;

// CheckBox: Enable OKS Suppression Debug.
[
    "GOL_Suppression_Debug",
    "CHECKBOX",
    ["Enable Suppression Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL_DEBUG",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Suppressed_Threshold",
    "SLIDER",
    ["Suppression Threshold", "For every friendly below 10 in the vicinity (this value) of the candidate, chance to surrender will increase."],
    "GOL_Suppression",
    [0, 1, 0.75, 1],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Suppressed_MinimumTime",
    "SLIDER",
    ["Minimum Suppressed Time", "Sets the minimum suppressed time for a unit to recover from suppression."],
    "GOL_Suppression",
    [1, 14, 6, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Suppressed_MaximumTime",
    "SLIDER",
    ["Maximum Suppressed Time", "Sets the maximum suppressed time for a unit to recover from suppression."],
    "GOL_Suppression",
    [2, 15, 10, 0],
    1
] call CBA_fnc_addSetting;

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

// Checkbox: Enable Surrender Debug
[
    "GOL_Surrender_Debug",
    "CHECKBOX",
    ["Enable Surrender Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL_DEBUG",
    false,
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

// Settings for OKS FaceSwap
// CheckBox: Enable OKS Face Swap.
[
    "GOL_FaceSwap_Enabled",
    "CHECKBOX",
    ["Allow FaceSwap", "When enabled, AI will change faces based on your choices on mission start and when spawned."],
    "GOL_FaceSwap",
    true,
    1
] call CBA_fnc_addSetting;

// Checkbox: Enable Surrender Debug
[
    "GOL_FaceSwap_Debug",
    "CHECKBOX",
    ["Enable FaceSwap Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL_DEBUG",
    false,
    1
] call CBA_fnc_addSetting;

// CBA Settings for OKS FaceSwap
[
    "GOL_FaceSwap_BLUFOR",
    "LIST",
    ["BLUFOR Ethnicity", "Set ethnic appearance for spawned BLUFOR units"],
    "GOL_FaceSwap",
    [
        ["african", "asian", "english", "american", "middleeast", "russian", "french", "greek", "polish"],
        ["African", "Asian", "English", "American", "Middle Eastern", "Russian", "French", "Greek", "Polish"], 
        3 // Default index for middleeast
    ],
    1
] call CBA_settings_fnc_init;

[
    "GOL_FaceSwap_OPFOR",
    "LIST",
    ["OPFOR Ethnicity", "Set ethnic appearance for spawned OPFOR units"],
    "GOL_FaceSwap",
    [
        ["african", "asian", "english", "american", "middleeast", "russian", "french", "greek", "polish"],
        ["African", "Asian", "English", "American", "Middle Eastern", "Russian", "French", "Greek", "Polish"], 
        4 // Default index for middleeast
    ],
    1
] call CBA_settings_fnc_init;

[
    "GOL_FaceSwap_INDEPENDENT",
    "LIST",
    ["INDEPENDENT Ethnicity", "Set ethnic appearance for spawned INDEPENDENT units"],
    "GOL_FaceSwap",
    [
        ["african", "asian", "english", "american", "middleeast", "russian", "french", "greek", "polish"],
        ["African", "Asian", "English", "American", "Middle Eastern", "Russian", "French", "Greek", "Polish"], 
        4 // Default index for middleeast
    ],
    1
] call CBA_settings_fnc_init;

[
    "GOL_FaceSwap_CIVILIAN",
    "LIST",
    ["CIVILIAN Ethnicity", "Set ethnic appearance for spawned CIVILIAN units"],
    "GOL_FaceSwap",
    [
        ["african", "asian", "english", "american", "middleeast", "russian", "french", "greek", "polish"],
        ["African", "Asian", "English", "American", "Middle Eastern", "Russian", "French", "Greek", "Polish"], 
        4 // Default index for middleeast
    ],
    1
] call CBA_settings_fnc_init;

// CBA Settings for OKS Packing
[
    "GOL_PackedDroneAPClass", // Unique setting variable name
    "EDITBOX",                           // Setting type (string input)
    ["Packed AP Drone Class", "Classname for the packed AP drone."], // Display name & tooltip
    "GOL_Packing",                    // Category in Addon Options
    "B_UAFPV_RKG_AP",                    // Default value
    1                                // Is global (true for mission/server-wide, false for local)
] call cba_settings_fnc_init;

[
    "GOL_PackedDroneATClass",
    "EDITBOX",
    ["Packed AT Drone Class", "Classname for the packed AT drone."],
    "GOL_Packing",
    "B_UAFPV_AT",
    1
] call cba_settings_fnc_init;

[
    "GOL_PackedDroneReconClass",
    "EDITBOX",
    ["Packed Recon Drone Class", "Classname for the packed Recon drone."],
    "GOL_Packing",
    "B_UAV_01_F",
    1
] call cba_settings_fnc_init;

[
    "GOL_PackedDroneSupplyClass",
    "EDITBOX",
    ["Packed Supply Drone Class", "Classname for the packed Supply drone."],
    "GOL_Packing",
    "B_UAV_06_F",
    1
] call cba_settings_fnc_init;

[
    "GOL_PackedHMGClass", // Unique setting variable name
    "EDITBOX",                           // Setting type (string input)
    ["Packed Static HMG Class", "Classname for the Static HMG."], // Display name & tooltip
    "GOL_Packing",                    // Category in Addon Options
    "RHS_M2StaticMG_USMC_D",                    // Default value
    1                                 // Is global (true for mission/server-wide, false for local)
] call cba_settings_fnc_init;

[
    "GOL_PackedGMGClass",
    "EDITBOX",
    ["Packed Static GMG Class", "Classname for the packed Static GMG."],
    "GOL_Packing",
    "RHS_MK19_TriPod_USMC_WD",
    1
] call cba_settings_fnc_init;

[
    "GOL_PackedATClass",
    "EDITBOX",
    ["Packed Static AT Class", "Classname for the packed Static AT."],
    "GOL_Packing",
    "RHS_TOW_TriPod_USMC_D",
    1
] call cba_settings_fnc_init;

[
    "GOL_PackedMortarClass",
    "EDITBOX",
    ["Packed Static Mortar Class", "Classname for the packed Static Mortar."],
    "GOL_Packing",
    "B_G_Mortar_01_F",
    1
] call cba_settings_fnc_init;
