diag_log "OKS_GOL_Misc: XEH_preInit_Tasks.sqf executed";

// Settings for NEKY Tasks
[
    "GOL_Neky_Tasks_Enabled",
    "CHECKBOX",
    ["Enable NEKY Tasks", "Enables NEKY tasks for Civilian & Player deaths."],
    "GOL_Tasks",
    false,
    1
] call CBA_fnc_addSetting;