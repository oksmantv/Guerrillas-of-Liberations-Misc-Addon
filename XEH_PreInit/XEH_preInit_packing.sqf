diag_log "OKS_GOL_Misc: XEH_preInit_packing.sqf executed";

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
