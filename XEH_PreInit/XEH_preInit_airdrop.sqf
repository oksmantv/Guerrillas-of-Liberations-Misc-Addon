diag_log "OKS_GOL_Misc: XEH_preInit_airdrop.sqf executed";

// CBA Settings for AirDrop

[
    "GOL_Airdrop_Rendevouz",
    "CHECKBOX",
    ["AI Rendezvous After Paradrop", "Whether AI units will rendezvous after a paradrop."],
    "GOL AirDrop",
    false,
    true
] call CBA_fnc_addSetting;

[
    "GOL_Airdrop_ChuteHeight",
    "SLIDER",
    ["Chute Open Height", "The height (in meters) where AI will start opening their parachute."],
    "GOL AirDrop",
    [50, 1000, 100, 0], // [min, max, default, precision]
    true
] call CBA_fnc_addSetting;

[
    "GOL_Airdrop_WPDistance",
    "SLIDER",
    ["Waypoint Search Distance", "The size of the area to search around when reaching their final SAD waypoint."],
    "GOL AirDrop",
    [50, 1000, 150, 0],
    true
] call CBA_fnc_addSetting;