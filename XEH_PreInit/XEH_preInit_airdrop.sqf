diag_log "OKS_GOL_Misc: XEH_preInit_airdrop.sqf executed";

[
    "GOL_AirDrop_Debug",
    "CHECKBOX",
    ["Enable AirDrop Debug", "When enabled, DEBUG messages will play in the SystemChat."],
    ["GOL AirDrop", "Debug"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_Paradrop_Debug",
    "CHECKBOX",
    ["Enable Paradrop DEBUG", "Enables debugging for paradrop scripts such as Hook, Static Jump, Eject etc."],
    ["GOL AirDrop", "Debug"],
    true,
    1
] call CBA_fnc_addSetting;

// CBA Settings for AirDrop

[
    "GOL_Airdrop_Rendevouz",
    "CHECKBOX",
    ["AI Rendezvous After Paradrop", "Whether AI units will rendezvous after a paradrop."],
    ["GOL AirDrop", "General"],
    false,
    true
] call CBA_fnc_addSetting;

[
    "GOL_Airdrop_ChuteHeight",
    "SLIDER",
    ["Chute Open Height", "The height (in meters) where AI will start opening their parachute."],
    ["GOL AirDrop", "General"],
    [50, 1000, 100, 0], // [min, max, default, precision]
    true
] call CBA_fnc_addSetting;

[
    "GOL_Airdrop_WPDistance",
    "SLIDER",
    ["Waypoint Search Distance", "The size of the area to search around when reaching their final SAD waypoint."],
    ["GOL AirDrop", "General"],
    [50, 1000, 150, 0],
    true
] call CBA_fnc_addSetting;