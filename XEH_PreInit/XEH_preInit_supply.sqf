diag_log "OKS_GOL_Misc: XEH_preInit_supply.sqf executed";

// CBA Settings for Supply
[
    "NEKY_SupplyHelicopter",
    "EDITBOX",
    ["Supply Helicopter Classname", "Classname for the AI helicopter that brings in supplies and vehicles."],
    "GOL_Supply",
    "",
    1
] call cba_settings_fnc_init;

[
    "NEKY_Supply_Enabled",
    "CHECKBOX",
    ["Enable AI Resupply", "Enables AI Resupply through landings or paradrops."],
    "GOL_Supply",
    true,
    1
] call cba_settings_fnc_init;

[
    "NEKY_SupplyVehicle_Enabled",
    "CHECKBOX",
    ["Enable AI Vehicle Drop", "Enables AI Vehicle drop through paradrop."],
    "GOL_Supply",
    true,
    1
] call cba_settings_fnc_init;

[
    "NEKY_SupplyMHQ_Enabled",
    "CHECKBOX",
    ["Enable AI MHQ Drop", "Enables AI MHQ Drop through paradrop."],
    "GOL_Supply",
    true,
    1
] call cba_settings_fnc_init;
