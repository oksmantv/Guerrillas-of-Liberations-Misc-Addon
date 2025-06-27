diag_log "OKS_GOL_Misc: XEH_preInit_core.sqf executed";

// Core and Debug Settings
/// CORE
[
    "GOL_CORE_Enabled",
    "CHECKBOX",
    ["Enables features from FW Version 2.7", "Enables all features added in the GOL Misc Addon."],
    "GOL_CORE",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Unconscious_CameraEnabled",
    "CHECKBOX",
    ["Enables Unconscious Camera", "Enables Unconscious Camera feature. This will allow players to see their surroundings while unconscious."],
    "GOL_CORE",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_DAPS_Enabled",
    "CHECKBOX",
    ["Enables APS Setup", "Enables default DAPS Options for the server. This will allow players to use APS features on vehicles."],
    "GOL_CORE",
    false,
    1
] call CBA_fnc_addSetting;


[
    "GOL_Core_Debug",
    "CHECKBOX",
    ["Enable DEBUG", "Allows for any debug messages to be broadcast. If disabled, no messages will show regardless of specific debugs turned on."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Global_Debug",
    "CHECKBOX",
    ["Enable Global DEBUG", "Allows for any debug messages to be broadcasted on all clients. If disabled, no messages will show for players but still logged on server."],
    "GOL DEBUG",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Ambience_Debug",
    "CHECKBOX",
    ["Enable Ambience DEBUG", "Enables debugging for enemy scripts such as the PowerGenerator, Death Score, House Destruction scripts."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Enemy_Debug",
    "CHECKBOX",
    ["Enable Enemy DEBUG", "Enables debugging for enemy scripts such as AdjustDamage, ForceVehicleSpeed, EnablePath etc."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_RotorProtection_Debug",
    "CHECKBOX",
    ["Enable Rotor DEBUG", "Enables debugging for the handleDamage scripts for Mi-8/Mi-24 rotors."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Unconscious_CameraDebug",
    "CHECKBOX",
    ["Enable Camera DEBUG", "Enables Camera DEBUG for unconscious state."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "MHQ_Debug",
    "CHECKBOX",
    ["Enable MHQ DEBUG", "Enable DEBUG messages for MHQ code."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_FaceSwap_Debug",
    "CHECKBOX",
    ["Enable FaceSwap Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Surrender_Debug",
    "CHECKBOX",
    ["Enable Surrender Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Suppression_Debug",
    "CHECKBOX",
    ["Enable Suppression Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Debug",
    "CHECKBOX",
    ["Enable Dynamic Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Hunt_Debug",
    "CHECKBOX",
    ["Enable Hunt Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Convoy_Debug",
    "CHECKBOX",
    ["Enable Convoy Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_AirDrop_Debug",
    "CHECKBOX",
    ["Enable AirDrop Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_AA_Debug",
    "CHECKBOX",
    ["Enable AA Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;
