diag_log "OKS_GOL_Misc: XEH_preInit_convoy.sqf executed";

// XEH_preInit_convoy.sqf
// Initializes convoy-related variables and CBA settings (excluding debug)
[
    "OKS_Convoy_HelicopterDetectionRange",
    "SLIDER",
    ["Helicopter Detection Range", "Maximum range (meters) to detect enemy helicopters for convoy AA reaction."],
    "GOL Convoy",
    [500, 2500, 1500],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Convoy_PlaneDetectionRange",
    "SLIDER",
    ["Plane Detection Range", "Maximum range (meters) to detect enemy planes for convoy AA reaction."],
    "GOL Convoy",
    [500, 4000, 2500],
    1
] call CBA_fnc_addSetting;
