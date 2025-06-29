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

[
    "GOL_Vehicle_Flag",
    "EDITBOX",
    ["Vehicle Flag Texture", "If defined will put a flag texture on the vehicle. Use the full path to the texture, e.g. a3\ui_f\data\flag_usa_co.paa. (No quotation marks)"],
    "GOL Vehicle",
    "",
    1
] call CBA_fnc_addSetting;