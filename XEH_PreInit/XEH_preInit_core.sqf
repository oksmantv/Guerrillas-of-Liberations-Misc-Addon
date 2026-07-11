diag_log "OKS_GOL_Misc: XEH_preInit_core.sqf executed";

// Core and Debug Settings
/// CORE
[
    "GOL_CORE_Enabled",
    "CHECKBOX",
    ["Enables features from FW Version 2.7", "Enables all features added in the GOL Misc Addon."],
    ["GOL Core", "General"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Unconscious_CameraEnabled",
    "CHECKBOX",
    ["Enables Unconscious Camera", "Enables Unconscious Camera feature. This will allow players to see their surroundings while unconscious."],
    ["GOL Core", "General"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_DAPS_Enabled",
    "CHECKBOX",
    ["Enables APS Setup", "Enables default DAPS Options for the server. This will allow players to use APS features on vehicles."],
    ["GOL Core", "General"],
    false,
    1
] call CBA_fnc_addSetting;


[
    "GOL_Core_Debug",
    "CHECKBOX",
    ["Enable DEBUG", "Allows for any debug messages to be broadcast. If disabled, no messages will show regardless of specific debugs turned on."],
    ["GOL Debug", "General"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Global_Debug",
    "CHECKBOX",
    ["Enable Global DEBUG", "Allows for any debug messages to be broadcasted on all clients. If disabled, no messages will show for players but still logged on server."],
    ["GOL Debug", "General"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_VehicleCamera_Debug",
    "CHECKBOX",
    ["Vehicle Camera Debug", "Allows commander/gunner to see their own PiP camera feed for debugging positioning and FOV."],
    ["GOL Debug", "General"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Server_Debug",
    "CHECKBOX",
    ["Enable Server DEBUG", "Allows for any debug messages to be broadcasted on the server. If disabled, no messages will show for the server (Local Host if editing)."],
    ["GOL Debug", "General"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Ambience_Debug",
    "CHECKBOX",
    ["Enable Ambience DEBUG", "Enables debugging for enemy scripts such as the PowerGenerator, Death Score, House Destruction scripts."],
    ["GOL Core", "Ambience"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Kills_Debug",
    "CHECKBOX",
    ["Enable Kills DEBUG", "Enables debugging for kills-related scripts."],
    ["GOL Core", "Kills"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_HC_Debug",
    "CHECKBOX",
    ["Enable Headless Client DEBUG", "Enables debugging for headless client scripts."],
    ["GOL Core", "Headless Client"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Unconscious_CameraDebug",
    "CHECKBOX",
    ["Enable Camera DEBUG", "Enables Camera DEBUG for unconscious state."],
    ["GOL Core", "Unconscious Camera"],
    true,
    1
] call CBA_fnc_addSetting;

// Convoy Debug Settings
[
    "GOL_SignalFlare_Debug",
    "CHECKBOX",
    ["Enable Signal Flare Debug", "Enables debug messages for signal flare scripts."],
    ["GOL Core", "Ambience"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_FastropeDamage_Debug",
    "CHECKBOX",
    ["Enable Fastrope Damage Debug", "Enables debug messages for fastrope fall damage protection system."],
    ["GOL Player Protection", "Debug"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_FastropeDamage_Protection",
    "CHECKBOX",
    ["Enable Fastrope Damage Protection", "Enables the fastrope fall damage protection system."],
    ["GOL Player Protection", "General"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_FastropeDamage_ProtectionDuration",
    "SLIDER",
    ["Fastrope Protection Duration", "How long (in seconds) to maintain fall damage protection after fastrope animation ends."],
    ["GOL Player Protection", "General"],
    [0.5, 10.0, 4.0, 1]
] call CBA_fnc_addSetting;

