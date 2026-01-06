diag_log "OKS_GOL_Misc: XEH_preInit_drones.sqf executed";

// Drone-related settings
// These are intended to provide safe defaults and a consistent place to configure drone classnames per side.

[
    "GOL_Drones_TerminalBallisticDistance",
    "SLIDER",
    ["Drone Terminal Ballistic Distance", "Distance (meters, 2D) where terminal guidance stops steering and only pushes forward to prevent close-range oscillation/spin."],
    ["GOL Drones", "Guidance"],
    [0, 100, 30, 0],
    1
] call cba_settings_fnc_init;

// We use LIST (instead of freeform EDITBOX) to reduce the chance of invalid classnames.

// BLUFOR
[
    "GOL_DroneAPClass_BLUFOR",
    "LIST",
    ["Drone AP Class", "Vehicle classname for AP drone (BLUFOR)."],
    ["GOL Drones", "Drones - BLUFOR"],
    [["B_UAFPV_RKG_AP","B_UAFPV_OG7V_AP","B_UAFPV_IED_AP"], ["RKG (AP)","OG7V (AP)","IED (AP)"], 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneATClass_BLUFOR",
    "LIST",
    ["Drone AT Class", "Vehicle classname for AT drone (BLUFOR). Used by OKS_fnc_DroneHuntZone when no classname override is provided."],
    ["GOL Drones", "Drones - BLUFOR"],
    [["B_UAFPV_PG7VL_AT"], ["PG7VL (AT)"], 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneReconClass_BLUFOR",
    "LIST",
    ["Drone Recon Class", "Vehicle classname for Recon drone (BLUFOR)."],
    ["GOL Drones", "Drones - BLUFOR"],
    [["B_UAV_01_F"], ["AR-2 Darter"], 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneSupplyClass_BLUFOR",
    "LIST",
    ["Drone Supply Class", "Vehicle classname for Supply drone (BLUFOR)."],
    ["GOL Drones", "Drones - BLUFOR"],
    [["B_UAV_06_F"], ["AL-6 Pelican"], 0],
    1
] call cba_settings_fnc_init;

// OPFOR
[
    "GOL_DroneAPClass_OPFOR",
    "LIST",
    ["Drone AP Class", "Vehicle classname for AP drone (OPFOR)."],
    ["GOL Drones", "Drones - OPFOR"],
    [["O_UAFPV_RKG_AP","O_UAFPV_OG7V_AP","O_UAFPV_IED_AP"], ["RKG (AP)","OG7V (AP)","IED (AP)"], 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneATClass_OPFOR",
    "LIST",
    ["Drone AT Class", "Vehicle classname for AT drone (OPFOR). Used by OKS_fnc_DroneHuntZone when no classname override is provided."],
    ["GOL Drones", "Drones - OPFOR"],
    [["O_UAFPV_PG7VL_AT"], ["PG7VL (AT)"], 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneReconClass_OPFOR",
    "LIST",
    ["Drone Recon Class", "Vehicle classname for Recon drone (OPFOR)."],
    ["GOL Drones", "Drones - OPFOR"],
    [["O_UAV_01_F"], ["AR-2 Darter"], 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneSupplyClass_OPFOR",
    "LIST",
    ["Drone Supply Class", "Vehicle classname for Supply drone (OPFOR)."],
    ["GOL Drones", "Drones - OPFOR"],
    [["O_UAV_06_F"], ["AL-6 Pelican"], 0],
    1
] call cba_settings_fnc_init;

// INDFOR
[
    "GOL_DroneAPClass_INDEPENDENT",
    "LIST",
    ["Drone AP Class", "Vehicle classname for AP drone (INDFOR)."],
    ["GOL Drones", "Drones - Independent"],
    [["I_UAFPV_RKG_AP","I_UAFPV_OG7V_AP","I_UAFPV_IED_AP"], ["RKG (AP)","OG7V (AP)","IED (AP)"], 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneATClass_INDEPENDENT",
    "LIST",
    ["Drone AT Class", "Vehicle classname for AT drone (INDFOR). Used by OKS_fnc_DroneHuntZone when no classname override is provided."],
    ["GOL Drones", "Drones - Independent"],
    [["I_UAFPV_PG7VL_AT"], ["PG7VL (AT)"], 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneReconClass_INDEPENDENT",
    "LIST",
    ["Drone Recon Class", "Vehicle classname for Recon drone (INDFOR)."],
    ["GOL Drones", "Drones - Independent"],
    [["I_UAV_01_F"], ["AR-2 Darter"], 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_DroneSupplyClass_INDEPENDENT",
    "LIST",
    ["Drone Supply Class", "Vehicle classname for Supply drone (INDFOR)."],
    ["GOL Drones", "Drones - Independent"],
    [["I_UAV_06_F"], ["AL-6 Pelican"], 0],
    1
] call cba_settings_fnc_init;
