/* PreInit for Jet suppression settings (CBA Settings) */
// This file sets up missionNamespace variables from CBA settings

diag_log "OKS_GOL_Misc: XEH_preInit_jets.sqf executed";

// Jet suppression CBA settings
[
    "GOL_JetSuppression_Radius",
    "SLIDER",
    ["Jet Suppression Radius", "Radius (meters) for jet flyby suppression."],
    ["GOL Jets", "Suppression"],
    [100, 500, 300, 1],
    1
] call CBA_fnc_addSetting;

[
    "GOL_JetSuppression_MinAGL",
    "SLIDER",
    ["Jet Suppression Min AGL", "Minimum altitude (meters) for jet suppression to trigger."],
    ["GOL Jets", "Suppression"],
    [100, 500, 250, 1],
    1
] call CBA_fnc_addSetting;

[
    "GOL_JetSuppression_MinSpeed",
    "SLIDER",
    ["Jet Suppression Min Speed", "Minimum speed (kph) for jet suppression to trigger."],
    ["GOL Jets", "Suppression"],
    [200, 1000, 600, 1],
    1
] call CBA_fnc_addSetting;

[
    "GOL_JetSuppression_Multiplier",
    "SLIDER",
    ["Jet Suppression Time Multiplier", "Multiplier for suppression time when jet is involved."],
    ["GOL Jets", "Suppression"],
    [1, 5, 3, 1],
    1
] call CBA_fnc_addSetting;

// AirStrike debug toggle (server-side RPT logging via OKS_fnc_LogDebug)
[
    "OKS_AirStrike_Debug",
    "CHECKBOX",
    ["AirStrike Debug", "Enable verbose server-side debug logging for OKS_fnc_AirStrike."],
    ["GOL Jets", "AirStrike"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "OKS_AirStrike_BombSpacing",
    "SLIDER",
    ["Bomb spacing (m)", "Spacing increment per bomb when using bomb carpet."],
    ["GOL Jets", "AirStrike"],
    [5, 150, 40, 0],
    1
] call CBA_fnc_addSetting;

[
    "OKS_AirStrike_BombCount",
    "SLIDER",
    ["Bomb count", "How many bombs to drop in bomb mode."],
    ["GOL Jets", "AirStrike"],
    [1, 4, 3, 0],
    1
] call CBA_fnc_addSetting;

[
    "OKS_AirStrike_BombAmmoClass",
    "EDITBOX",
    ["Bomb ammo classname", "Ammo classname for bomb strikes (CfgAmmo). Default: Bo_GBU12_LGB. Options: FIR_GBU39, FIR_GBU55, FIR_GBU24B"],
    ["GOL Jets", "AirStrike"],
    "Bo_GBU12_LGB",
    1
] call CBA_fnc_addSetting;