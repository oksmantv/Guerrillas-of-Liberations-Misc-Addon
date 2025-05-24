diag_log "OKS_GOL_Misc: XEH_preInit.sqf executed";

[
    "GOL_MISC_ADDON_PackedDroneAPClass", // Unique setting variable name
    "EDITBOX",                           // Setting type (string input)
    ["Packed AP Drone Class", "Classname for the packed AP drone."], // Display name & tooltip
    "GOL Misc Addon",                    // Category in Addon Options
    "B_UAFPV_RKG_AP",                    // Default value
    true                                 // Is global (true for mission/server-wide, false for local)
] call cba_settings_fnc_init;

[
    "GOL_MISC_ADDON_PackedDroneATClass",
    "EDITBOX",
    ["Packed AT Drone Class", "Classname for the packed AT drone."],
    "GOL Misc Addon",
    "B_UAFPV_AT",
    true
] call cba_settings_fnc_init;

[
    "GOL_MISC_ADDON_PackedDroneReconClass",
    "EDITBOX",
    ["Packed Recon Drone Class", "Classname for the packed Recon drone."],
    "GOL Misc Addon",
    "B_UAV_01_F",
    true
] call cba_settings_fnc_init;

[
    "GOL_MISC_ADDON_PackedDroneSupplyClass",
    "EDITBOX",
    ["Packed Supply Drone Class", "Classname for the packed Supply drone."],
    "GOL Misc Addon",
    "B_UAV_06_F",
    true
] call cba_settings_fnc_init;

[
    "GOL_MISC_ADDON_PackedHMGClass", // Unique setting variable name
    "EDITBOX",                           // Setting type (string input)
    ["Packed Static HMG Class", "Classname for the Static HMG."], // Display name & tooltip
    "GOL Misc Addon",                    // Category in Addon Options
    "RHS_M2StaticMG_USMC_D",                    // Default value
    true                                 // Is global (true for mission/server-wide, false for local)
] call cba_settings_fnc_init;

[
    "GOL_MISC_ADDON_PackedGMGClass",
    "EDITBOX",
    ["Packed Static GMG Class", "Classname for the packed Static GMG."],
    "GOL Misc Addon",
    "RHS_MK19_TriPod_USMC_WD",
    true
] call cba_settings_fnc_init;

[
    "GOL_MISC_ADDON_PackedATClass",
    "EDITBOX",
    ["Packed Static AT Class", "Classname for the packed Static AT."],
    "GOL Misc Addon",
    "RHS_TOW_TriPod_USMC_D",
    true
] call cba_settings_fnc_init;

[
    "GOL_MISC_ADDON_PackedMortarClass",
    "EDITBOX",
    ["Packed Static Mortar Class", "Classname for the packed Static Mortar."],
    "GOL Misc Addon",
    "B_G_Mortar_01_F",
    true
] call cba_settings_fnc_init;