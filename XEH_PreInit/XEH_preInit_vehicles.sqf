diag_log "OKS_GOL_Misc: XEH_preInit_vehicles.sqf executed";

// Vehicle-related CBA settings.
// This file is intended for settings that affect vehicle systems (ground/air/sea).

// Ground Vehicles: Rail Move settings (OKS_fnc_RailMove / OKS_fnc_RailVehicle_Spawn)
[
    "GOL_RailMove_Debug",
    "CHECKBOX",
    ["Rail Move Debug", "Enables periodic [RAILMOVE]/[RAILSPAWN] logging to RPT (non-spam)."],
    ["GOL Ground Vehicles", "Rail Move"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "GOL_RailMove_ArrivalRadiusMeters",
    "SLIDER",
    ["Rail Move Arrival Radius (m)", "How close (2D) the vehicle must get to a waypoint before moving to the next."],
    ["GOL Ground Vehicles", "Rail Move"],
    [5, 150, 25, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_RailMove_StuckAfterSeconds",
    "SLIDER",
    ["Rail Move Stuck Timeout (s)", "If the vehicle makes no progress for this long (while far from the waypoint), it will stop and deploy/dismount."],
    ["GOL Ground Vehicles", "Rail Move"],
    [3, 120, 12, 0],
    1
] call CBA_fnc_addSetting;

[
    "GOL_RailMove_MinSpeedForNotStuck",
    "SLIDER",
    ["Rail Move Min Speed (km/h)", "If speed stays below this value and there is no progress, the vehicle is considered stuck."],
    ["GOL Ground Vehicles", "Rail Move"],
    [0, 25, 2.5, 1],
    1
] call CBA_fnc_addSetting;

[
    "GOL_RailMove_UseAgentDriver",
    "CHECKBOX",
    ["Rail Move Agent Driver (Experimental)", "If enabled, OKS_fnc_RailVehicle_Spawn will replace the driver with a createAgent unit. If the vehicle does not move, disable this."],
    ["GOL Ground Vehicles", "Rail Move"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "GOL_RailMove_UseForceSpeed",
    "CHECKBOX",
    ["Rail Move Force Speed", "If enabled, uses forceSpeed to hold the target speed. This can help keep vehicles moving fast under contact, but can also make driving look more 'on rails'."],
    ["GOL Ground Vehicles", "Rail Move"],
    true,
    1
] call CBA_fnc_addSetting;
