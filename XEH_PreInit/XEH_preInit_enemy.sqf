diag_log "OKS_GOL_Misc: XEH_preInit_enemy.sqf executed";

[
    "GOL_Enemy_Debug",
    "CHECKBOX",
    ["Enable Enemy DEBUG", "Enables debugging for enemy scripts such as AdjustDamage, ForceVehicleSpeed, EnablePath etc."],
    ["GOL Enemy", "Debug"],
    true,
    1
] call CBA_fnc_addSetting;

// CBA Settings for OKS FaceSwap
[
    "GOL_Enemy_IgnorePlayerAir",
    "LIST",
    ["Ignore Player Air Targets", "If enabled, enemy AI groups will by default, ignore player air targets. (Dynamic Targeting uses MaxRange value)"],
    ["GOL Enemy", "AI Behaviour"],
    [
        ["disabled", "enabled", "dynamic"],
        ["Disabled", "Enabled", "Dynamic Targeting"], 
        0 // Default index for disabled
    ],
    1
] call CBA_settings_fnc_init;

[
    "GOL_Enemy_IgnorePlayerAir_MaxRange",
    "SLIDER",
    ["Ignore Player Air Targets Max Range", "The maximum range at which enemy AI groups will ignore player air targets."],
    ["GOL Enemy", "AI Behaviour"],
    [0, 1000, 400, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_EnemyVehicle_IgnorePlayerAir_MaxRange",
    "SLIDER",
    ["Ignore Player Air Targets Max Range", "The maximum range at which enemy AI Vehicle groups will ignore player air targets."],
    ["GOL Enemy", "AI Behaviour"],
    [0, 2000, 800, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_EnemyVehicle_IgnorePlayerAir_MaxRange_AAA",
    "SLIDER",
    ["Ignore Player Air Targets Max Range (AAA)", "Dynamic Targeting only. The maximum range at which enemy AAA-equipped groups (vehicles or infantry carrying AA-tagged ammo) will ignore player air targets."],
    ["GOL Enemy", "AI Behaviour"],
    [0, 6000, 2500, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Enemy_IgnorePlayerAir_PollTime",
    "SLIDER",
    ["Ignore Player Air Targets Poll Time", "How often to check for new player air targets (in seconds)."],
    ["GOL Enemy", "AI Behaviour"],
    [0, 30, 2, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Enemy_IgnorePlayerAir_IgnoreDelay",
    "SLIDER",
    ["Ignore Player Air Targets Grace Delay", "Dynamic Targeting only. After a player aircraft leaves max range, keep it engageable for this many extra seconds before re-ignoring it. Compensates for fast/low flybys being missed by the poll rate."],
    ["GOL Enemy", "AI Behaviour"],
    [0, 30, 10, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Enemy_IgnorePlayerAir_DetailedDebug",
    "CHECKBOX",
    ["Detailed Debug for Ignore Player Air Targets", "Enables detailed debugging for ignore player air targets."],
    ["GOL Enemy", "AI Behaviour"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_UndercoverAI_Debug",
    "CHECKBOX",
    ["Enable UndercoverAI DEBUG", "Enables debugging for undercover AI scripts."],
    ["GOL Enemy", "Undercover AI"],
    true,
    1
] call CBA_fnc_addSetting;

// Settings for OKS Enemy
// SLIDER: Max Speed of AI Cars
[
    "GOL_Enemy_MaxSpeed_Cars",
    "SLIDER",
    ["AI Max Speed (Cars)", "The maximum speed allowed for enemy cars."],
    ["GOL Enemy", "Vehicle Speed"],
    [0, 150, 15, 0],
    1
] call CBA_fnc_addSetting;

// SLIDER: Max Speed of AI Wheeled APCs
[
    "GOL_Enemy_MaxSpeed_WheeledAPCs",
    "SLIDER",
    ["AI Max Speed (Wheeled APCs)", "The maximum speed allowed for enemy wheeled APCs."],
    ["GOL Enemy", "Vehicle Speed"],
    [0, 150, 12, 0],
    1
] call CBA_fnc_addSetting;

// SLIDER: Max Speed of AI Tracked APCs
[
    "GOL_Enemy_MaxSpeed_TrackedAPCs",
    "SLIDER",
    ["AI Max Speed (Tracked APCs)", "The maximum speed allowed for enemy tracked APCs."],
    ["GOL Enemy", "Vehicle Speed"],
    [0, 150, 8, 0],
    1
] call CBA_fnc_addSetting;

// SLIDER: Max Speed of AI Tanks
[
    "GOL_Enemy_MaxSpeed_Tanks",
    "SLIDER",
    ["AI Max Speed (Tanks)", "The maximum speed allowed for enemy tanks."],
    ["GOL Enemy", "Vehicle Speed"],
    [0, 150, 8, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_UndercoverAI_WeaponsArray",
    "EDITBOX",
    ["Undercover AI Weapons Array", "Array of weapons used by undercover AI."], 
    ["GOL Enemy", "Undercover AI"],
    str([["arifle_AKS_F", "30Rnd_545x39_Mag_Green_F"],["rhs_weap_M590_5RD","rhsusf_5Rnd_00Buck"],["uk3cb_port_said_m45","uk3cb_carlg_m45_36rnd_magazine_G"]]),
    1
] call CBA_fnc_addSetting;

[
    "GOL_UndercoverAI_ChanceForArms",
    "SLIDER",
    ["Undercover Chance for Arms", "The chance that the undercover AI gets their hands on weapons."],
    ["GOL Enemy", "Undercover AI"],
    [0, 1, 0.5, 2],
    1
] call CBA_fnc_addSetting;