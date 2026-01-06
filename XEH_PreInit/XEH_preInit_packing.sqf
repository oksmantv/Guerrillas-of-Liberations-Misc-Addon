diag_log "OKS_GOL_Misc: XEH_preInit_packing.sqf executed";

// CBA Settings for OKS Packing

// Drone classnames are centralized in XEH_preInit_drones.sqf.

[
    "GOL_PackedHMGClass", // Unique setting variable name
    "EDITBOX",                           // Setting type (string input)
    ["Packed Static HMG Class", "Classname for the Static HMG."], // Display name & tooltip
    ["GOL Packing", "Static Weapons"],                    // Category in Addon Options
    "RHS_M2StaticMG_USMC_D",                    // Default value
    1                                 // Is global (true for mission/server-wide, false for local)
] call cba_settings_fnc_init;

[
    "GOL_PackedGMGClass",
    "EDITBOX",
    ["Packed Static GMG Class", "Classname for the packed Static GMG."],
    ["GOL Packing", "Static Weapons"],
    "RHS_MK19_TriPod_USMC_WD",
    1
] call cba_settings_fnc_init;

[
    "GOL_PackedATClass",
    "EDITBOX",
    ["Packed Static AT Class", "Classname for the packed Static AT."],
    ["GOL Packing", "Static Weapons"],
    "RHS_TOW_TriPod_USMC_D",
    1
] call cba_settings_fnc_init;

[
    "GOL_PackedMortarClass",
    "EDITBOX",
    ["Packed Static Mortar Class", "Classname for the packed Static Mortar."],
    ["GOL Packing", "Static Weapons"],
    "B_G_Mortar_01_F",
    1
] call cba_settings_fnc_init;
