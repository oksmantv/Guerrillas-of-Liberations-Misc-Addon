diag_log "OKS_GOL_Misc: XEH_preInit_mhq.sqf executed";

[
    "MHQ_Debug",
    "CHECKBOX",
    ["Enable MHQ DEBUG", "Enable DEBUG messages for MHQ code."],
    ["GOL MHQ", "Debug"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_RotorProtection_Debug",
    "CHECKBOX",
    ["Enable Rotor DEBUG", "Enables debugging for the handleDamage scripts for Mi-8/Mi-24 rotors."],
    ["GOL Helicopters", "Debug"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_AI_HelicopterFlyBy_Debug",
    "CHECKBOX",
    ["Enable AI Helicopter FlyBy Debug", "Enables debug messages for AI Helicopter FlyBy scripts including flight missions, waypoint tracking, and spawn management."],
    ["GOL Helicopters", "Debug"],
    true,
    1
] call CBA_fnc_addSetting;

// CBA Settings for MHQ
[
    "MHQSAFEZONE",
    "SLIDER",
    ["MHQ Safe Zone Radius", "Radius (in meters) of the MHQ safe zone."],
    ["GOL MHQ", "General"],
    [25, 300, 100, 0], // [min, max, default, decimals]
    1
] call CBA_fnc_addSetting;

[
    "MHQ_ShouldBe_ServiceStation",
    "CHECKBOX",
    ["MHQ Service Station", "If enabled the MHQ vehicle itself will be a service station, if disabled, it will be loaded with a mobile service station."],
    ["GOL MHQ", "General"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_MissileWarning_Enabled",
    "CHECKBOX",
    ["Enable Missile Warning", "If enabled vehicles will have a missile warning system that will alert the crew of incoming missiles."],
    ["GOL Vehicles", "General"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_MissileWarningSound_Enabled",
    "CHECKBOX",
    ["Enable Missile Warning Sound", "If enabled vehicles will have a missile warning sound effects that will alert the crew of incoming missiles."],
    ["GOL Vehicles", "General"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Vehicle_Flag",
    "EDITBOX",
    ["Vehicle Flag Texture", "If defined will put a flag texture on the vehicle. Use the full path to the texture, e.g. a3\ui_f\data\flag_usa_co.paa. (No quotation marks)"],
    ["GOL Vehicles", "General"],
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Helicopter_TI",
    "CHECKBOX",
    ["Disable Helicopter Thermals", "If disabled helicopters will no longer receive thermal vision in cameras."],
    ["GOL Helicopters", "General"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Helicopter_NVG",
    "CHECKBOX",
    ["Disable Helicopter NVGs", "If disabled helicopters will no longer receive night vision in cameras."],
    ["GOL Helicopters", "General"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Helicopter_DoorgunReplace",
    "CHECKBOX",
    ["Enable Doorgun Replacement", "If enabled helicopters will receive other door guns."],
    ["GOL Helicopters", "General"],
    true,
    1
] call CBA_fnc_addSetting;