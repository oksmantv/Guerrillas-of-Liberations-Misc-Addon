diag_log "OKS_GOL_Misc: XEH_preInit_core.sqf executed";

// Core and Debug Settings
/// CORE
[
    "GOL_CORE_Enabled",
    "CHECKBOX",
    ["Enables features from FW Version 2.7", "Enables all features added in the GOL Misc Addon."],
    "GOL CORE",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Unconscious_CameraEnabled",
    "CHECKBOX",
    ["Enables Unconscious Camera", "Enables Unconscious Camera feature. This will allow players to see their surroundings while unconscious."],
    "GOL CORE",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_DAPS_Enabled",
    "CHECKBOX",
    ["Enables APS Setup", "Enables default DAPS Options for the server. This will allow players to use APS features on vehicles."],
    "GOL CORE",
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
    "GOL_Server_Debug",
    "CHECKBOX",
    ["Enable Server DEBUG", "Allows for any debug messages to be broadcasted on the server. If disabled, no messages will show for the server (Local Host if editing)."],
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
    "GOL_Kills_Debug",
    "CHECKBOX",
    ["Enable Kills DEBUG", "Enables debugging for kills-related scripts."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_HC_Debug",
    "CHECKBOX",
    ["Enable Headless Client DEBUG", "Enables debugging for headless client scripts."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_UndercoverAI_Debug",
    "CHECKBOX",
    ["Enable UndercoverAI DEBUG", "Enables debugging for undercover AI scripts."],
    "GOL DEBUG",
    true,
    1    
] call CBA_fnc_addSetting;

[
    "GOL_MissileWarning_Debug",
    "CHECKBOX",
    ["Enable Missile Warning DEBUG", "Enables debugging for missile warnings."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_MissileDeflect_Debug",
    "CHECKBOX",
    ["Enable Missile Deflect DEBUG", "Enables debugging for missile deflection."],
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

// Convoy Debug Settings
[
    "GOL_Convoy_Debug",
    "CHECKBOX",
    ["Enable Convoy Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[ 
    "GOL_Convoy_Target_Debug",
    "CHECKBOX",
    ["Enable Convoy Target Debug", "When enabled, DEBUG messages will show detailed convoy targeting and detection logic."],
    "GOL DEBUG",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Convoy_Speed_Debug",
    "CHECKBOX",
    ["Enable Convoy Speed Debug", "When enabled, DEBUG messages will play in the SystemChat speed checks."],
    "GOL DEBUG",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Convoy_Markers_Debug",
    "CHECKBOX",
    ["Enable Convoy Markers Debug", "When enabled, DEBUG Arrow markers will be spawned on the convoy end waypoints."],
    "GOL DEBUG",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Convoy_Dispersion_Debug",
    "CHECKBOX",
    ["Enable Convoy Dispersion Debug", "When enabled, DEBUG messages will show dispersion changes near waypoints."],
    "GOL DEBUG",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Convoy_AA_Debug",
    "CHECKBOX",
    ["Enable Convoy AA Debug", "When enabled, DEBUG messages will show detailed AA vehicle selection and engagement."],
    "GOL DEBUG",
    false,
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

[
    "GOL_Paradrop_Debug",
    "CHECKBOX",
    ["Enable Paradrop DEBUG", "Enables debugging for paradrop scripts such as Hook, Static Jump, Eject etc."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_HVT_Debug",
    "CHECKBOX",
    ["Enable HVT Tasks DEBUG", "Enables debugging for HVT and Hostage task scripts."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_GroundVehicles_Debug",
    "CHECKBOX",
    ["Enable Ground Vehicles DEBUG", "Enables debugging for ground vehicle setup scripts such as Mechanized, SetupCargoSpace, etc. (excludes damage system)"],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_PlayerVehicleDamage_Debug",
    "CHECKBOX",
    ["Enable Player Vehicle Damage DEBUG", "Enables debugging specifically for the player vehicle damage reduction system for targeted damage testing."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_SignalFlare_Debug",
    "CHECKBOX",
    ["Enable Signal Flare Debug", "Enables debug messages for signal flare scripts."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_AI_Battle_Debug",
    "CHECKBOX",
    ["Enable AI Battle Debug", "Enables debug messages for AI Battle scripts including simulation monitoring and round management."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_AI_ArtilleryBattle_Debug",
    "CHECKBOX",
    ["Enable AI Artillery Battle Debug", "Enables debug messages for AI Artillery Battle scripts including fire missions, targeting, and accuracy progression."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_FastropeDamage_Debug",
    "CHECKBOX",
    ["Enable Fastrope Damage Debug", "Enables debug messages for fastrope fall damage protection system."],
    "GOL DEBUG",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_FastropeDamage_Protection",
    "CHECKBOX",
    ["Enable Fastrope Damage Protection", "Enables the fastrope fall damage protection system."],
    "GOL Player Protection",
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_FastropeDamage_ProtectionDuration",
    "SLIDER",
    ["Fastrope Protection Duration", "How long (in seconds) to maintain fall damage protection after fastrope animation ends."],
    "GOL Player Protection",
    [0.5, 10.0, 4.0, 1]
] call CBA_fnc_addSetting;

[
    "GOL_AI_HelicopterFlyBy_Debug",
    "CHECKBOX",
    ["Enable AI Helicopter FlyBy Debug", "Enables debug messages for AI Helicopter FlyBy scripts including flight missions, waypoint tracking, and spawn management."],
    "GOL DEBUG",
    true,
    1
] call CBA_fnc_addSetting;
