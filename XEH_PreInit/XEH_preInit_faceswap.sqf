diag_log "OKS_GOL_Misc: XEH_preInit_faceswap.sqf executed";

// Settings for OKS FaceSwap
// CheckBox: Enable OKS Face Swap.
[
    "GOL_FaceSwap_Enabled",
    "CHECKBOX",
    ["Allow FaceSwap", "When enabled, AI will change faces based on your choices on mission start and when spawned."],
    "GOL_FaceSwap",
    true,
    1
] call CBA_fnc_addSetting;

// CBA Settings for OKS FaceSwap
[
    "GOL_FaceSwap_BLUFOR",
    "LIST",
    ["BLUFOR Ethnicity", "Set ethnic appearance for spawned BLUFOR units"],
    "GOL_FaceSwap",
    [
        ["african", "asian", "english", "american", "middleeast", "russian", "french", "greek", "polish"],
        ["African", "Asian", "English", "American", "Middle Eastern", "Russian", "French", "Greek", "Polish"], 
        3 // Default index for middleeast
    ],
    1
] call CBA_settings_fnc_init;

[
    "GOL_FaceSwap_OPFOR",
    "LIST",
    ["OPFOR Ethnicity", "Set ethnic appearance for spawned OPFOR units"],
    "GOL_FaceSwap",
    [
        ["african", "asian", "english", "american", "middleeast", "russian", "french", "greek", "polish"],
        ["African", "Asian", "English", "American", "Middle Eastern", "Russian", "French", "Greek", "Polish"], 
        4 // Default index for middleeast
    ],
    1
] call CBA_settings_fnc_init;

[
    "GOL_FaceSwap_INDEPENDENT",
    "LIST",
    ["INDEPENDENT Ethnicity", "Set ethnic appearance for spawned INDEPENDENT units"],
    "GOL_FaceSwap",
    [
        ["african", "asian", "english", "american", "middleeast", "russian", "french", "greek", "polish"],
        ["African", "Asian", "English", "American", "Middle Eastern", "Russian", "French", "Greek", "Polish"], 
        4 // Default index for middleeast
    ],
    1
] call CBA_settings_fnc_init;

[
    "GOL_FaceSwap_CIVILIAN",
    "LIST",
    ["CIVILIAN Ethnicity", "Set ethnic appearance for spawned CIVILIAN units"],
    "GOL_FaceSwap",
    [
        ["african", "asian", "english", "american", "middleeast", "russian", "french", "greek", "polish"],
        ["African", "Asian", "English", "American", "Middle Eastern", "Russian", "French", "Greek", "Polish"], 
        4 // Default index for middleeast
    ],
    1
] call CBA_settings_fnc_init;