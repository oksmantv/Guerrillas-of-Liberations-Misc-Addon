diag_log "OKS_GOL_Misc: XEH_preInit_eden.sqf executed";

// CBA Settings for Eden Editor Marker Tools
[
    "OKS_Eden_FlagMarker_BLUFOR",
    "EDITBOX",
    ["BLUFOR Flag Marker Type", "Marker type to use for BLUFOR (b_) flag markers when using 'Mark Organisation Strength with Flag'."],
    ["GOL Eden", "Markers"],
    "flag_nato",
    1
] call cba_settings_fnc_init;

[
    "OKS_Eden_FlagMarker_OPFOR",
    "EDITBOX",
    ["OPFOR Flag Marker Type", "Marker type to use for OPFOR (o_) flag markers when using 'Mark Organisation Strength with Flag'."],
    ["GOL Eden", "Markers"],
    "flag_csat",
    1
] call cba_settings_fnc_init;

[
    "OKS_Eden_FlagMarker_INDEP",
    "EDITBOX",
    ["Independent Flag Marker Type", "Marker type to use for Independent (i_) flag markers when using 'Mark Organisation Strength with Flag'."],
    ["GOL Eden", "Markers"],
    "flag_aaf",
    1
] call cba_settings_fnc_init;
