diag_log "OKS_GOL_Misc: XEH_preInit_sam.sqf executed";

[
    "GOL_AA_Debug",
    "CHECKBOX",
    ["Enable AA Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    ["GOL SAM", "Debug"],
    true,
    1
] call CBA_fnc_addSetting;

// GOL SAM Network — shared CBA settings for SAM + SHORAD systems

[
    "OKS_SAM_MaxMissilesPerTarget",
    "SLIDER",
    ["Max Missiles Per Target", "Network-wide limit of in-flight missiles allowed per single air target. Shared across all SAM and SHORAD launchers."],
    ["GOL SAM", "Network"],
    [1, 10, 3, 0],
    1
] call CBA_fnc_addSetting;
