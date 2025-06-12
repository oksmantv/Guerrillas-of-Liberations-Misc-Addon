diag_log "OKS_GOL_Misc: XEH_preInit_hunt.sqf executed";

// Settings for NEKY Hunt
[
    "GOL_Hunt_MaxCount",
    "SLIDER",
    ["Max count of Hunters", "The maximum allowed enemy hunters at any given time."],
    "GOL_Hunt",
    [10, 100, 40, 0],
    1
] call CBA_fnc_addSetting;