diag_log "OKS_GOL_Misc: XEH_preInit_dynamic.sqf executed";

// CBA Settings for Dynamic
[
    "GOL_Dynamic_Faction",
    "LIST",
    [
        "Faction", 
        "Select the faction to use for dynamic operations."
    ],
    "GOL Dynamic",
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
        "Custom Wheeled Vehicles",
        "Comma-separated classnames for custom faction wheeled vehicles."
    ],
    "GOL Dynamic",
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_APC",
    "EDITBOX",
    [
        "Custom APCs",
        "Comma-separated classnames for custom faction APCs."
    ],
    "GOL Dynamic",
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_Tank",
    "EDITBOX",
    [
        "Custom Tanks",
        "Comma-separated classnames for custom faction tanks."
    ],
    "GOL Dynamic",
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_Artillery",
    "EDITBOX",
    [
        "Custom Artillery",
        "Comma-separated classnames for custom faction artillery."
    ],
    "GOL Dynamic",
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_AntiAir",
    "EDITBOX",
    [
        "Custom Anti-Air",
        "Comma-separated classnames for custom faction anti-air."
    ],
    "GOL Dynamic",
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_Helicopter",
    "EDITBOX",
    [
        "Custom Helicopters",
        "Comma-separated classnames for custom faction helicopters."
    ],
    "GOL Dynamic",
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_Transport",
    "EDITBOX",
    [
        "Custom Transport",
        "Comma-separated classnames for custom faction transport vehicles."
    ],
    "GOL Dynamic",
    "",
    1
] call CBA_fnc_addSetting;

[
    "GOL_Dynamic_Custom_Supply",
    "EDITBOX",
    [
        "Custom Supply",
        "Comma-separated classnames for custom faction supply vehicles."
    ],
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
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
    "GOL Dynamic",
    false,
    1
] call CBA_fnc_addSetting;