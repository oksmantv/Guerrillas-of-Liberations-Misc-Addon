diag_log "OKS_GOL_Misc: XEH_preInit_mhq.sqf executed";

// CBA Settings for MHQ
[
    "MHQSAFEZONE",
    "SLIDER",
    ["MHQ Safe Zone Radius", "Radius (in meters) of the MHQ safe zone."],
    "GOL MHQ",
    [25, 300, 100, 0], // [min, max, default, decimals]
    1
] call CBA_fnc_addSetting;

[
    "MHQ_ShouldBe_ServiceStation",
    "CHECKBOX",
    ["MHQ Service Station", "If enabled the MHQ vehicle itself will be a service station, if disabled, it will be loaded with a mobile service station."],
    "GOL MHQ",
    false,
    1
] call CBA_fnc_addSetting;