diag_log "OKS_GOL_Misc: XEH_preInit_suppression.sqf executed";

[
    "GOL_Suppression_Debug",
    "CHECKBOX",
    ["Enable Suppression Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    ["GOL Suppression", "Debug"],
    true,
    1
] call CBA_fnc_addSetting;

// Settings for OKS Suppression
[
    "GOL_Suppression_Enabled",
    "CHECKBOX",
    ["Enable Suppression", "When enabled, AI will be able to be suppressed."],
    ["GOL Suppression", "Behavior"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Suppressed_Threshold",
    "SLIDER",
    ["Suppression Threshold", "For every friendly below 10 in the vicinity (this value) of the candidate, chance to surrender will increase."],
    ["GOL Suppression", "Behavior"],
    [0, 1, 0.75, 1],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Suppressed_MinimumTime",
    "SLIDER",
    ["Minimum Suppressed Time", "Sets the minimum suppressed time for a unit to recover from suppression."],
    ["GOL Suppression", "Behavior"],
    [1, 14, 6, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Suppressed_MaximumTime",
    "SLIDER",
    ["Maximum Suppressed Time", "Sets the maximum suppressed time for a unit to recover from suppression."],
    ["GOL Suppression", "Behavior"],
    [2, 15, 10, 0],
    1
] call CBA_fnc_addSetting;