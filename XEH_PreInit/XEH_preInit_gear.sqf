diag_log "OKS_GOL_Misc: XEH_preInit_gear.sqf executed";

// CBA Settings for GOL Gear
[
    "MAGNIFIED_OPTICS_ALLOW",
    "CHECKBOX",
    ["Allow Magnified 2x Sights", "Allows magnified 2x sights to be selected from the Arsenal."],
    "GOL Gear",
    true, // default value (true/false)
    1    // isGlobal (1 = global, 0 = local)
] call CBA_fnc_addSetting;

[
    "OPTICS_ALLOW",
    "CHECKBOX",
    ["Allow Optics", "Allows sights to be selected from the Arsenal."],
    "GOL Gear",
    true,
    1
] call CBA_fnc_addSetting;

[
    "WEAPONS_ALLOW",
    "CHECKBOX",
    ["Allow Weapon Variations", "Allows weapon variations to be selected from Arsenal."],
    "GOL Gear",
    true,
    1
] call CBA_fnc_addSetting;

[
    "ARSENAL_ALLOW",
    "CHECKBOX",
    ["Allow Attachment Menu", "Allows Attachment Menu in Arsenal."],
    "GOL Gear",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GroundRoles_ALLOW",
    "CHECKBOX",
    ["Allow Specialist Ground Roles", "Allows specialist ground roles (Dragon, Light Rifleman, Ammo Bearer, Anti-Air, Heavy AT)"],
    "GOL Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "AirRoles_ALLOW",
    "CHECKBOX",
    ["Allow Specialist Air Roles", "Allows specialist air roles (Para-Rescueman, Jet Pilot, Marksman)."],
    "GOL Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "ENTRENCH_ALLOW",
    "CHECKBOX",
    ["Allow Entrenching Tools", "Adds Entrenching Tools to certain roles."],
    "GOL Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "WIRECUTTER_ALLOW",
    "CHECKBOX",
    ["Allow Wirecutters", "Adds Wirecutters to Riflemen."],
    "GOL Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "ForceNVG",
    "CHECKBOX",
    ["Force NVGs", "Forces addition of NVGs."],
    "GOL Gear",
    false,
    1
] call CBA_fnc_addSetting;

[
    "ForceNVGClassname",
    "EDITBOX",
    ["Force NVG Classname", "Forces change of NVGs."],
    "GOL Gear",
    "",
    1
] call CBA_fnc_addSetting;