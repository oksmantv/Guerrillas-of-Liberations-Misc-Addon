diag_log "OKS_GOL_Misc: XEH_preInit_spawnMultiplier.sqf executed";

// GOL_SpawnMultiplier itself is set by the mission parameter (GOL_FRAMEWORK_2021 Description.ext / Common/postInit.sqf).
// Non-framework missions fall back to 100 via the getVariable default in each covered function.

// --- Per-function blacklists (exemptions from the multiplier) ---

[
    "GOL_SpawnMultiplier_Blacklist_Patrol",
    "CHECKBOX",
    ["Blacklist: Patrol Spawns", "Exempt OKS_fnc_Patrol_Spawn from spawn multiplier reduction."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_Garrison",
    "CHECKBOX",
    ["Blacklist: Garrison (Buildings)", "Exempt OKS_fnc_Garrison from spawn multiplier. Also affects OKS_fnc_Populate_Strongpoints which delegates to Garrison."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_GarrisonCompound",
    "CHECKBOX",
    ["Blacklist: Garrison (Compounds)", "Exempt OKS_fnc_Garrison_Compound from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_PopulateBunkers",
    "CHECKBOX",
    ["Blacklist: Bunker Population", "Exempt OKS_fnc_Populate_Bunkers from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_StaticWeapons",
    "CHECKBOX",
    ["Blacklist: Static Weapon Crews", "Exempt OKS_fnc_Populate_StaticWeapons from spawn multiplier. When not blacklisted, excess uncrewed statics are deleted."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_SpawnStatic",
    "CHECKBOX",
    ["Blacklist: Static Spawn (Array)", "Exempt OKS_fnc_SpawnStatic from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_AmphibiousAssault",
    "CHECKBOX",
    ["Blacklist: Amphibious Assault", "Exempt OKS_fnc_AmphibiousAssault cargo infantry from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_BeachLanding",
    "CHECKBOX",
    ["Blacklist: Beach Landing", "Exempt OKS_fnc_BeachLanding cargo infantry from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_RailVehicle",
    "CHECKBOX",
    ["Blacklist: Rail Vehicle Cargo", "Exempt OKS_fnc_RailVehicle_Spawn cargo infantry from spawn multiplier. The vehicle itself always spawns."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_BuildingRestCamp",
    "CHECKBOX",
    ["Blacklist: Building Rest Camp", "Exempt OKS_fnc_BuildingRestCamp from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_AttackSpawnGroup",
    "CHECKBOX",
    ["Blacklist: Attack Spawn Group", "Exempt OKS_fnc_Attack_SpawnGroup infantry path from spawn multiplier. Vehicle path is unaffected regardless."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_HoldWaypoint",
    "CHECKBOX",
    ["Blacklist: Hold Waypoint", "Exempt OKS_fnc_Hold_Waypoint infantry path from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_VehiclePatrol",
    "CHECKBOX",
    ["Blacklist: Vehicle Patrol", "Exempt OKS_fnc_Vehicle_Patrol from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_Convoy",
    "CHECKBOX",
    ["Blacklist: Convoy Spawn", "Exempt OKS_fnc_Convoy_Spawn vehicle count and cargo from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_InfantryPincer",
    "CHECKBOX",
    ["Blacklist: Infantry Pincer", "Exempt OKS_fnc_SpawnInfantryPincer from spawn multiplier (all 4 fire teams)."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_MechanizedSpawn",
    "CHECKBOX",
    ["Blacklist: Mechanized Spawn Cargo", "Exempt OKS_fnc_Mechanized_Spawn cargo infantry from spawn multiplier. The vehicle itself always spawns."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_LambsSpawnGroup",
    "CHECKBOX",
    ["Blacklist: Lambs Spawn Group", "Exempt OKS_fnc_Lambs_SpawnGroup infantry path from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_LambsSpawner",
    "CHECKBOX",
    ["Blacklist: Lambs Spawner (Respawn)", "Exempt OKS_fnc_Lambs_Spawner from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_LambsWavespawn",
    "CHECKBOX",
    ["Blacklist: Lambs Wavespawn", "Exempt OKS_fnc_Lambs_Wavespawn from spawn multiplier (units per wave only, wave count unchanged)."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_LambsChargeSpawn",
    "CHECKBOX",
    ["Blacklist: Lambs Charge Spawn", "Exempt OKS_fnc_LambsChargeSpawn from spawn multiplier (units per wave only)."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_HuntBase",
    "CHECKBOX",
    ["Blacklist: Hunt Base Waves", "Exempt OKS_fnc_HuntBase infantry wave size from spawn multiplier. Vehicle and convoy paths unaffected."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;
