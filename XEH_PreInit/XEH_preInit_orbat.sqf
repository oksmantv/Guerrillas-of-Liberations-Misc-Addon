diag_log "OKS_GOL_Misc: XEH_preInit_orbat.sqf executed";

// ORBAT and Group Composition
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
