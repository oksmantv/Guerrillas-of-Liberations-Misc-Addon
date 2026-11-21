diag_log "OKS_GOL_Misc: XEH_preInit_dynamic.sqf executed";

[
    "GOL_Dynamic_Debug",
    "CHECKBOX",
    ["Enable Dynamic Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    ["GOL Dynamic", "Debug"],
    true,
    1
] call CBA_fnc_addSetting;

// CBA Settings for Dynamic
[
    "GOL_Dynamic_Faction",
    "LIST",
    [
        "Faction", 
        "Select the faction to use for dynamic operations."
    ],
    ["GOL Dynamic", "Faction"],
    [
        // Values
        [
            "CSAT",
            "CDF",
            "LDF",
            "TANOA",
            "ARDISTAN",
            "CHEDAKI",
            "COMMUNIST_REBELS",
            "DESERT_INSURGENTS",
            "DESERT_MILITIA",
            "RUSSIA_MODERN",
            "SOVIET",
            "TKA",
            "NAPA",
            "CUSTOM"          
        ],
        // Display names
        [
            "CSAT",
            "Chernarussian Defence Force",
            "Livonian Defence Force",
            "Tanoan Army",
            "Ardistan Army",
            "Chedaki Insurgents",
            "Communist Rebels",
            "Desert Insurgents",
            "Desert Militia",
            "Russia Armed Forces",
            "Soviet Army",
            "Takistani Army",
            "National Party (NAPA)",
            "Custom"
        ],
        0 // Default (CSAT)
    ],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_Wheeled",
    "EDITBOX",
    [
        "Override: Wheeled Vehicles",
        "Replaces the selected faction's wheeled vehicles (jeeps, technicals, light armed cars).<br/>Format: vehicle classnames separated by commas, no quotes, no spaces needed (spaces are also tolerated).<br/>Example: UK3CB_TKA_O_Hilux_M2,UK3CB_TKA_O_UAZ_MG<br/>Filled = replaces the faction list. Empty = faction default."
    ],
    ["GOL Dynamic", "Vehicle Overrides"],
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_APC",
    "EDITBOX",
    [
        "Override: APCs / IFVs",
        "Replaces the selected faction's APCs and IFVs.<br/>Format: vehicle classnames separated by commas, no quotes, no spaces needed (spaces are also tolerated).<br/>Example: UK3CB_TKA_O_BMP1,UK3CB_TKA_O_BTR70<br/>Filled = replaces the faction list. Empty = faction default."
    ],
    ["GOL Dynamic", "Vehicle Overrides"],
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_Tank",
    "EDITBOX",
    [
        "Override: Tanks",
        "Replaces the selected faction's tanks.<br/>Format: vehicle classnames separated by commas, no quotes, no spaces needed (spaces are also tolerated).<br/>Example: UK3CB_TKA_O_T55,UK3CB_TKA_O_T34<br/>Filled = replaces the faction list. Empty = faction default."
    ],
    ["GOL Dynamic", "Vehicle Overrides"],
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_Artillery",
    "EDITBOX",
    [
        "Override: Artillery",
        "Replaces the selected faction's artillery (howitzers, mortars, rocket launchers).<br/>Format: vehicle classnames separated by commas, no quotes, no spaces needed (spaces are also tolerated).<br/>Example: UK3CB_TKA_O_D30,UK3CB_TKA_O_BM21<br/>Filled = replaces the faction list. Empty = faction default."
    ],
    ["GOL Dynamic", "Vehicle Overrides"],
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_AntiAir",
    "EDITBOX",
    [
        "Override: Anti-Air",
        "Replaces the selected faction's anti-air vehicles and static AA.<br/>Format: vehicle classnames separated by commas, no quotes, no spaces needed (spaces are also tolerated).<br/>Example: UK3CB_TKA_O_ZsuTank,UK3CB_TKA_O_ZU23<br/>Filled = replaces the faction list. Empty = faction default."
    ],
    ["GOL Dynamic", "Vehicle Overrides"],
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_Helicopter",
    "EDITBOX",
    [
        "Override: Helicopters",
        "Replaces the selected faction's helicopters.<br/>Format: vehicle classnames separated by commas, no quotes, no spaces needed (spaces are also tolerated).<br/>Example: UK3CB_TKA_O_UH1H_M240,UK3CB_TKA_O_Bell412_Armed<br/>Filled = replaces the faction list. Empty = faction default."
    ],
    ["GOL Dynamic", "Vehicle Overrides"],
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_Transport",
    "EDITBOX",
    [
        "Override: Transport",
        "Replaces the selected faction's troop transport vehicles.<br/>Format: vehicle classnames separated by commas, no quotes, no spaces needed (spaces are also tolerated).<br/>Example: UK3CB_TKA_O_Ural,UK3CB_TKA_O_BTR40<br/>Filled = replaces the faction list. Empty = faction default."
    ],
    ["GOL Dynamic", "Vehicle Overrides"],
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_Supply",
    "EDITBOX",
    [
        "Override: Supply Vehicles",
        "Replaces the selected faction's supply vehicles (ammo, fuel, repair).<br/>Format: vehicle classnames separated by commas, no quotes, no spaces needed (spaces are also tolerated).<br/>Example: UK3CB_TKA_O_Ural_Ammo,UK3CB_TKA_O_Ural_Fuel<br/>Filled = replaces the faction list. Empty = faction default."
    ],
    ["GOL Dynamic", "Vehicle Overrides"],
    "",
    1
] call CBA_fnc_addSetting;


// CBA Settings for Dynamic Mission Parameters

[
    "GOL_Dynamic_ObjectiveTypes",
    "EDITBOX",
    [
        "Objective Types",
        "Comma-separated list of enabled objective types.<br/>Available: cache, artillery, hostage, hvttruck, ammotruck, radiotower, motorpool, antiair"
    ],
    ["GOL Dynamic", "Objectives"],
    "cache,artillery,hostage,hvttruck,ammotruck,radiotower,motorpool,antiair",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_TaskNotification",
    "CHECKBOX",
    [
        "Task Notification",
        "Show pop-ups when tasks are completed."
    ],
    ["GOL Dynamic", "Objectives"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_CompoundSize",
    "SLIDER",
    [
        "Compound Size (meters)",
        "Defines how large a compound is considered for garrisons."
    ],
    ["GOL Dynamic", "Patrols"],
    [10, 100, 25, 0], // min, default, max, decimals
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_PatrolSize",
    "SLIDER",
    [
        "Patrol Size",
        "Standard patrol group size."
    ],
    ["GOL Dynamic", "Patrols"],
    [1, 12, 4, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_EnableEnemyMarkers",
    "CHECKBOX",
    [
        "Enable Enemy Markers",
        "Place markers at enemy strongpoints and static targets."
    ],
    ["GOL Dynamic", "Markers"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_EnableZoneMarker",
    "CHECKBOX",
    [
        "Enable Zone Marker",
        "Mark trigger area with a zone marker."
    ],
    ["GOL Dynamic", "Markers"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_EnableZoneTypeMarker",
    "CHECKBOX",
    [
        "Enable Zone Type Marker",
        "Mark trigger area with a zone type marker."
    ],
    ["GOL Dynamic", "Markers"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_MarkerColor",
    "CHECKBOX",
    [
        "Enemy Marker Color",
        "Use default side color for enemy markers."
    ],
    ["GOL Dynamic", "Markers"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_EnableObjectiveTasks",
    "CHECKBOX",
    [
        "Enable Objective Tasks",
        "Attach tasks to objectives."
    ],
    ["GOL Dynamic", "Objectives"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_RoadblockVehicleType",
    "LIST",
    [
        "Roadblock Vehicle Type",
        "Vehicle type for roadblock vehicles."
    ],
    ["GOL Dynamic", "Patrols"],
    [
        ["Wheeled", "APC", "Tank", "AntiAir"],
        ["_Wheeled", "_APC", "_Tank", "_AntiAir"],
        1 // Default: APC
    ],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_CivilianUnits",
    "EDITBOX",
    [
        "Civilian Units",
        "Comma-separated list of civilian unit classnames."
    ],
    ["GOL Dynamic", "Civilians"],
    "C_man_polo_1_F,C_man_polo_2_F,C_man_polo_3_F,C_man_polo_4_F,C_man_polo_5_F,C_man_polo_6_F",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_CivilianTriggerSize",
    "SLIDER",
    [
        "Civilian Trigger Size",
        "Trigger size for dynamic civilian module."
    ],
    ["GOL Dynamic", "Civilians"],
    [50, 1000, 200, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_CivilianCount",
    "SLIDER",
    [
        "Civilian Count",
        "Number of dynamic civilians."
    ],
    ["GOL Dynamic", "Civilians"],
    [0, 25, 8, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_StaticCivilianCount",
    "SLIDER",
    [
        "Static Civilian Count",
        "Number of static civilians."
    ],
    ["GOL Dynamic", "Civilians"],
    [0, 25, 6, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_HouseWaypoints",
    "SLIDER",
    [
        "House Waypoints",
        "Number of waypoints per house for civilians."
    ],
    ["GOL Dynamic", "Civilians"],
    [0, 22, 10, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_RandomWaypoints",
    "SLIDER",
    [
        "Random Waypoints",
        "Number of random waypoints for civilians."
    ],
    ["GOL Dynamic", "Civilians"],
    [0, 25, 10, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_ShouldBeAgent",
    "CHECKBOX",
    [
        "Civilians as Agents",
        "Should civilians be spawned as agents?"
    ],
    ["GOL Dynamic", "Civilians"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_ShouldPanic",
    "CHECKBOX",
    [
        "Civilians Panic",
        "Should civilians panic?"
    ],
    ["GOL Dynamic", "Civilians"],
    false,
    1
] call CBA_fnc_addSetting;