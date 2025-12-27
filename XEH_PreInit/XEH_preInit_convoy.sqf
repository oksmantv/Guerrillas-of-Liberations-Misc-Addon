diag_log "OKS_GOL_Misc: XEH_preInit_convoy.sqf executed";

// XEH_preInit_convoy.sqf
// Initializes convoy-related variables and CBA settings (excluding debug)

[
    "OKS_Convoy_SpottingRange",
    "SLIDER",
    ["Convoy Spotting Range", "Radius (meters) in which convoy units can spot enemy ground targets."],
    ["GOL Convoy", "Detection"],
    [100, 2000, 400],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Convoy_MinimumTargets",
    "SLIDER",
    ["Convoy Minimum Targets", "Minimum number of enemy ground targets required to trigger convoy combat reaction."],
    ["GOL Convoy", "Combat Reaction"],
    [1, 10, 3],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Convoy_LockingTime",
    "SLIDER",
    ["Convoy Locking Time", "Seconds required to sustain detection before triggering convoy combat reaction."],
    ["GOL Convoy", "Combat Reaction"],
    [1, 10, 3],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Convoy_MinimumIdentification",
    "SLIDER",
    ["Convoy Minimum Identification", "Minimum identification threshold (0-4) for a target to be considered valid."],
    ["GOL Convoy", "Combat Reaction"],
    [0, 4, 0.5],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Convoy_HelicopterDetectionRange",
    "SLIDER",
    ["Helicopter Detection Range", "Maximum range (meters) to detect enemy helicopters for convoy AA reaction."],
    ["GOL Convoy", "Air Detection"],
    [500, 2500, 1500],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Convoy_PlaneDetectionRange",
    "SLIDER",
    ["Plane Detection Range", "Maximum range (meters) to detect enemy planes for convoy AA reaction."],
    ["GOL Convoy", "Air Detection"],
    [500, 4000, 2500],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Convoy_AA_ForcedClassnames",
    "EDITBOX",
    [
        "Forced AA Vehicle Classnames",
        "Comma-separated vehicle classnames that should be treated as dedicated convoy AA vehicles. Matching vehicles will not spawn cargo units, preventing dismount/eject issues during AA engagement. Example: O_APC_Tracked_02_AA_F"
    ],
    ["GOL Convoy", "Air Defense"],
    "",
    1
] call CBA_fnc_addSetting;

[
    "OKS_Convoy_AA_ForcedMaxCount",
    "SLIDER",
    [
        "Forced AA Max Count",
        "Maximum number of vehicles per convoy (in spawn order) that may be treated as forced AA from the Forced AA Vehicle Classnames list. Extra matching vehicles spawn normally and will be excluded from AA selection."
    ],
    ["GOL Convoy", "Air Defense"],
    [0, 10, 1],
    1
] call CBA_fnc_addSetting;
