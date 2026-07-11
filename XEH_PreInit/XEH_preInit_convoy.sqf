diag_log "OKS_GOL_Misc: XEH_preInit_convoy.sqf executed";

[
    "GOL_Convoy_Debug",
    "CHECKBOX",
    ["Enable Convoy Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    ["GOL Convoy", "Debug"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Convoy_Target_Debug",
    "CHECKBOX",
    ["Enable Convoy Target Debug", "When enabled, DEBUG messages will show detailed convoy targeting and detection logic."],
    ["GOL Convoy", "Debug"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Convoy_Speed_Debug",
    "CHECKBOX",
    ["Enable Convoy Speed Debug", "When enabled, DEBUG messages will play in the SystemChat speed checks."],
    ["GOL Convoy", "Debug"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Convoy_Markers_Debug",
    "CHECKBOX",
    ["Enable Convoy Markers Debug", "When enabled, DEBUG Arrow markers will be spawned on the convoy end waypoints."],
    ["GOL Convoy", "Debug"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Convoy_Dispersion_Debug",
    "CHECKBOX",
    ["Enable Convoy Dispersion Debug", "When enabled, DEBUG messages will show dispersion changes near waypoints."],
    ["GOL Convoy", "Debug"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Convoy_AA_Debug",
    "CHECKBOX",
    ["Enable Convoy AA Debug", "When enabled, DEBUG messages will show detailed AA vehicle selection and engagement."],
    ["GOL Convoy", "Debug"],
    false,
    1
] call CBA_fnc_addSetting;

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

[
    "OKS_Convoy_TargetScanInterval",
    "SLIDER",
    ["Convoy Target Scan Interval", "Seconds between convoy ground-target scan ticks. Higher values reduce periodic stutter."],
    ["GOL Convoy", "Performance"],
    [0.1, 5, 1.5],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Convoy_TargetScanJitter",
    "SLIDER",
    ["Convoy Target Scan Jitter", "Random extra seconds added to each scan tick to de-sync multiple convoys and smooth frame-time spikes."],
    ["GOL Convoy", "Performance"],
    [0, 3, 0.8],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Convoy_TargetScanVehiclesPerTick",
    "SLIDER",
    ["Convoy Vehicles Scanned Per Tick", "How many convoy vehicles run target checks per scan tick. 1 = lead vehicle only (recommended for performance)."],
    ["GOL Convoy", "Performance"],
    [1, 10, 1],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Convoy_TargetScanStride",
    "SLIDER",
    ["Convoy Detector Stride", "Spacing between detector vehicles along the convoy. Example: 3 = every 3rd vehicle becomes a detector candidate (lead-only when convoy has 3 or fewer vehicles)."],
    ["GOL Convoy", "Performance"],
    [1, 10, 3],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Convoy_TargetScanMaxCandidatesPerVehicle",
    "SLIDER",
    ["Convoy Max Target Candidates", "Max candidate targets checked per scanned vehicle per tick (caps expensive LOS checks)."],
    ["GOL Convoy", "Performance"],
    [1, 50, 6],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Convoy_TargetScanMaxRuntime",
    "SLIDER",
    ["Convoy Scan Max Runtime", "Failsafe: stop the convoy ground-target scan after this many seconds (prevents endless background scanning)."],
    ["GOL Convoy", "Performance"],
    [30, 3600, 900],
    1
] call CBA_fnc_addSetting;
