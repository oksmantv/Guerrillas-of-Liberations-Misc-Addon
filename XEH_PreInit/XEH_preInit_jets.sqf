/* PreInit for Jet suppression settings (CBA Settings) */
// This file sets up missionNamespace variables from CBA settings

diag_log "OKS_GOL_Misc: XEH_preInit_jets.sqf executed";

// Jet suppression CBA settings
[
    "GOL_JetSuppression_Radius",
    "SLIDER",
    ["Jet Suppression Radius", "Radius (meters) for jet flyby suppression."],
    "GOL Jets",
    [100, 500, 300, 1],
    1
] call CBA_fnc_addSetting;

[
    "GOL_JetSuppression_MinAGL",
    "SLIDER",
    ["Jet Suppression Min AGL", "Minimum altitude (meters) for jet suppression to trigger."],
    "GOL Jets",
    [100, 500, 250, 1],
    1
] call CBA_fnc_addSetting;

[
    "GOL_JetSuppression_MinSpeed",
    "SLIDER",
    ["Jet Suppression Min Speed", "Minimum speed (kph) for jet suppression to trigger."],
    "GOL Jets",
    [200, 1000, 600, 1],
    1
] call CBA_fnc_addSetting;

[
    "GOL_JetSuppression_Multiplier",
    "SLIDER",
    ["Jet Suppression Time Multiplier", "Multiplier for suppression time when jet is involved."],
    "GOL Jets",
    [1, 5, 3, 1],
    1
] call CBA_fnc_addSetting;