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
            "National Party (NAPA)"
        ],
        // Values (do not change, used in scripts)
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
            "NAPA"
        ],
        0 // Default (CSAT)
    ],
    1
] call CBA_fnc_addSetting;