diag_log "OKS_GOL_Misc: XEH_preInit_eden.sqf executed";

// CBA Settings for Eden Editor Debug
[
    "OKS_3DEN_DEBUG",
    "CHECKBOX",
    ["3DEN Debug", "Enables extra [3DEN] notifications and verbose copy-to-clipboard logging for GOL SCRIPTS Eden helpers."],
    ["GOL Eden", "Debug"],
    true,
    1
] call cba_settings_fnc_init;

// CBA Settings for Eden Editor Task Tools
[
    "OKS_3DEN_INTEL_CLASS",
    "EDITBOX",
    ["Intel Object Class", "CfgVehicles classname used by the GOL SCRIPTS -> TASK -> Setup Intel helper. Default targets ACEX Intel Items document."],
    ["GOL Eden", "Tasks"],
    "acex_intelitems_document",
    1
] call cba_settings_fnc_init;

// Mirror the setting into uiNamespace so the Eden scripts can also be toggled per-editor-session.
// (Eden helpers check uiNamespace first, then fall back to missionNamespace.)
uiNamespace setVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", true]];

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
