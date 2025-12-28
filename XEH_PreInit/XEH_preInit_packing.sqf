diag_log "OKS_GOL_Misc: XEH_preInit_packing.sqf executed";

// CBA Settings for OKS Packing
// Drone vehicle classnames (used for BOTH packed deploy and throwable FPV)
// Exactly 4 drone types (AP/AT/Recon/Supply) per side (BLUFOR/OPFOR/INDFOR).

// BLUFOR
[
    "GOL_DroneAPClass_BLUFOR",
    "EDITBOX",
    ["Drone AP Class", "Vehicle classname for AP drone (BLUFOR)."],
    ["GOL Packing", "Drones - BLUFOR"],
    "B_UAFPV_RKG_AP",
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneATClass_BLUFOR",
    "EDITBOX",
    ["Drone AT Class", "Vehicle classname for AT drone (BLUFOR)."],
    ["GOL Packing", "Drones - BLUFOR"],
    "B_UAFPV_PG7VL_AT",
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneReconClass_BLUFOR",
    "EDITBOX",
    ["Drone Recon Class", "Vehicle classname for Recon drone (BLUFOR)."],
    ["GOL Packing", "Drones - BLUFOR"],
    "B_UAV_01_F",
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneSupplyClass_BLUFOR",
    "EDITBOX",
    ["Drone Supply Class", "Vehicle classname for Supply drone (BLUFOR)."],
    ["GOL Packing", "Drones - BLUFOR"],
    "B_UAV_06_F",
    1
] call cba_settings_fnc_init;

// OPFOR
[
    "GOL_DroneAPClass_OPFOR",
    "EDITBOX",
    ["Drone AP Class", "Vehicle classname for AP drone (OPFOR)."],
    ["GOL Packing", "Drones - OPFOR"],
    "O_UAFPV_RKG_AP",
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneATClass_OPFOR",
    "EDITBOX",
    ["Drone AT Class", "Vehicle classname for AT drone (OPFOR)."],
    ["GOL Packing", "Drones - OPFOR"],
    "O_UAFPV_PG7VL_AT",
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneReconClass_OPFOR",
    "EDITBOX",
    ["Drone Recon Class", "Vehicle classname for Recon drone (OPFOR)."],
    ["GOL Packing", "Drones - OPFOR"],
    "O_UAV_01_F",
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneSupplyClass_OPFOR",
    "EDITBOX",
    ["Drone Supply Class", "Vehicle classname for Supply drone (OPFOR)."],
    ["GOL Packing", "Drones - OPFOR"],
    "O_UAV_06_F",
    1
] call cba_settings_fnc_init;

// INDFOR
[
    "GOL_DroneAPClass_INDEPENDENT",
    "EDITBOX",
    ["Drone AP Class", "Vehicle classname for AP drone (INDFOR)."],
    ["GOL Packing", "Drones - Independent"],
    "I_UAFPV_RKG_AP",
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneATClass_INDEPENDENT",
    "EDITBOX",
    ["Drone AT Class", "Vehicle classname for AT drone (INDFOR)."],
    ["GOL Packing", "Drones - Independent"],
    "I_UAFPV_PG7VL_AT",
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneReconClass_INDEPENDENT",
    "EDITBOX",
    ["Drone Recon Class", "Vehicle classname for Recon drone (INDFOR)."],
    ["GOL Packing", "Drones - Independent"],
    "I_UAV_01_F",
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneSupplyClass_INDEPENDENT",
    "EDITBOX",
    ["Drone Supply Class", "Vehicle classname for Supply drone (INDFOR)."],
    ["GOL Packing", "Drones - Independent"],
    "I_UAV_06_F",
    1
] call cba_settings_fnc_init;

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
