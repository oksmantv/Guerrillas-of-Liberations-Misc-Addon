diag_log "OKS_GOL_Misc: XEH_preInit_Tasks.sqf executed";

[
    "GOL_HVT_Debug",
    "CHECKBOX",
    ["Enable HVT Tasks DEBUG", "Enables debugging for HVT and Hostage task scripts."],
    ["GOL Tasks", "Debug"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_AI_Battle_Debug",
    "CHECKBOX",
    ["Enable AI Battle Debug", "Enables debug messages for AI Battle scripts including simulation monitoring and round management."],
    ["GOL Tasks", "Debug"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_AI_ArtilleryBattle_Debug",
    "CHECKBOX",
    ["Enable AI Artillery Battle Debug", "Enables debug messages for AI Artillery Battle scripts including fire missions, targeting, and accuracy progression."],
    ["GOL Tasks", "Debug"],
    true,
    1
] call CBA_fnc_addSetting;

// Settings for NEKY Tasks
[
    "GOL_Neky_Tasks_Enabled",
    "CHECKBOX",
    ["Enable NEKY Tasks", "Enables NEKY tasks for Civilian & Player deaths."],
    ["GOL Tasks", "General"],
    false,
    1
] call CBA_fnc_addSetting;