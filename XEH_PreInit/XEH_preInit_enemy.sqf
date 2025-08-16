diag_log "OKS_GOL_Misc: XEH_preInit_enemy.sqf executed";

// Settings for OKS Enemy
// SLIDER: Max Speed of AI Cars
[
    "GOL_Enemy_MaxSpeed_Cars",
    "SLIDER",
    ["AI Max Speed (Cars)", "The maximum speed allowed for enemy cars."],
    "GOL Enemy",
    [0, 150, 15, 0],
    1
] call CBA_fnc_addSetting;

// SLIDER: Max Speed of AI Wheeled APCs
[
    "GOL_Enemy_MaxSpeed_WheeledAPCs",
    "SLIDER",
    ["AI Max Speed (Wheeled APCs)", "The maximum speed allowed for enemy wheeled APCs."],
    "GOL Enemy",
    [0, 150, 12, 0],
    1
] call CBA_fnc_addSetting;

// SLIDER: Max Speed of AI Tracked APCs
[
    "GOL_Enemy_MaxSpeed_TrackedAPCs",
    "SLIDER",
    ["AI Max Speed (Tracked APCs)", "The maximum speed allowed for enemy tracked APCs."],
    "GOL Enemy",
    [0, 150, 8, 0],
    1
] call CBA_fnc_addSetting;

// SLIDER: Max Speed of AI Tanks
[
    "GOL_Enemy_MaxSpeed_Tanks",
    "SLIDER",
    ["AI Max Speed (Tanks)", "The maximum speed allowed for enemy tanks."],
    "GOL Enemy",
    [0, 150, 8, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_UndercoverAI_WeaponsArray",
    "EDITBOX",
    ["Undercover AI Weapons Array", "Array of weapons used by undercover AI."], 
    "GOL Enemy",
    str([["arifle_AKS_F", "30Rnd_545x39_Mag_Green_F"],["rhs_weap_M590_5RD","rhsusf_5Rnd_00Buck"],["uk3cb_port_said_m45","uk3cb_carlg_m45_36rnd_magazine_G"]]),
    1
] call CBA_fnc_addSetting;

[
    "GOL_UndercoverAI_ChanceForArms",
    "SLIDER",
    ["Undercover Chance for Arms", "The chance that the undercover AI gets their hands on weapons."],
    "GOL Enemy",
    [0, 1, 0.5, 2],
    1
] call CBA_fnc_addSetting;