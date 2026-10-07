diag_log "OKS_GOL_Misc: XEH_preInit_player.sqf executed";

[
    "GOL_Player_IntelMessage_Setting",
    "LIST",
    ["Intel Message Style", "None = diary + optional notification only. Static = HQ sideChat. Animated = custom on-screen radio UI."],
    ["GOL Player Settings", "Radio Messages"],
    [[0,1,2], ["None","Static Message","Animated Message"], 2],
    1
] call cba_settings_fnc_init;

[
    "GOL_Player_ChatRadioRange",
    "SLIDER",
    ["Radio Message Range", "Maximum distance (in meters) for side-channel object talkers. Preset string callsigns are always global."],
    ["GOL Player Settings", "Radio Messages"],
    [100, 100000, 25000, 0],
    1
] call cba_settings_fnc_init;

[
    "GOL_Player_ChatLocalRange",
    "SLIDER",
    ["Local Message Range", "Maximum distance (in meters) for local-channel messages from object talkers."],
    ["GOL Player Settings", "Radio Messages"],
    [1, 250, 20, 0],
    1
] call cba_settings_fnc_init;