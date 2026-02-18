diag_log "OKS_GOL_Misc: XEH_preInit_vehicles.sqf executed";

// Vehicle-related CBA settings.
// This file is intended for settings that affect vehicle systems (ground/air/sea).

// Vehicle Empty Monitoring
[
    "GOL_VehicleEmpty_Enabled",
    "CHECKBOX",
    ["Enable Vehicle Empty Monitoring", "When enabled, empty vehicles will receive invisible driver units so AI can target them. Disable this if you experience performance issues or stutters."],
    ["GOL Ground Vehicles", "Vehicle Empty"],
    false,
    1
] call CBA_fnc_addSetting;

// Ground Vehicles: Rail Move settings (OKS_fnc_RailMove / OKS_fnc_RailVehicle_Spawn)
[
    "GOL_RailMove_Debug",
    "CHECKBOX",
    ["Rail Move Debug", "Enables periodic [RAILMOVE]/[RAILSPAWN] logging to RPT (non-spam)."],
    ["GOL Ground Vehicles", "Rail Move"],
    true,
    1
] call CBA_fnc_addSetting;

// SatCam PiP profiles (vehicle-specific anchors)
missionNamespace setVariable [
    "OKS_SatCamPip_VehicleProfiles",
    call compile preprocessFileLineNumbers "\OKS_GOL_Misc\functions\helpers\camera\satCamProfiles.sqf"
];

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

// Amphibious IFVs: Water boost while holding Shift
[
    "GOL_AmphIFVBoost_Enabled",
    "CHECKBOX",
    ["Amphibious IFV Boost", "When enabled, amphibious IFVs get a small forward water-speed boost while the driver holds Shift (turbo) and is pressing forward. Applied locally to reduce MP jitter."],
    ["GOL Amphibious Vehicles", "IFV Boost"],
    true,
    1
] call CBA_fnc_addSetting;

[
	"GOL_AmphIFVBoost_Debug",
	"CHECKBOX",
	["Amphibious IFV Boost Debug", "Enables [AMPHIB_IFV_BOOST] logging via OKS_fnc_LogDebug (throttled)."],
	["GOL Amphibious Vehicles", "IFV Boost"],
	true,
	1
] call CBA_fnc_addSetting;

[
    "GOL_AmphIFVBoost_DebugVerbose",
    "CHECKBOX",
    ["Amphibious IFV Boost Verbose", "More frequent [AMPHIB_IFV_BOOST] state snapshots for troubleshooting. Can spam RPT."],
    ["GOL Amphibious Vehicles", "IFV Boost"],
    false,
    1
] call CBA_fnc_addSetting;

// PiP Camera settings
[
    "OKS_SatCamPip_ThermalEnabled",
    "CHECKBOX",
    ["PiP Camera Thermal", "When enabled, vision mode cycling includes Thermal in addition to Normal and Night Vision."],
    ["OKS Vehicles", "PiP Camera"],
    false,
    1
] call CBA_fnc_addSetting;

// Camera: keybinds
// Note: CBA keybinds are configured by users in Controls -> Addon Options -> CBA.
["GOL Custom Controls", "OKS_SatCam_CommanderView", ["Commander Camera", "Toggle PiP camera. Driver: rear camera. Cargo/other turrets: commander view. (ESC closes)."], {
    [] call OKS_fnc_SatCamPipToggleCommanderView;
}, {}, [0, [false, false, false]], false] call CBA_fnc_addKeybind;

["GOL Custom Controls", "OKS_SatCam_CommanderZoomIn", ["Commander Camera Zoom In", "Commander/gunner PiP: zoom in (cycles through 7 levels)."], {
    [] call OKS_fnc_SatCamPipCommanderZoomIn;
}, {}, [0, [false, false, false]], false] call CBA_fnc_addKeybind;

["GOL Custom Controls", "OKS_SatCam_CommanderZoomOut", ["Commander Camera Zoom Out", "Commander/gunner PiP: zoom out (cycles through 7 levels)."], {
    [] call OKS_fnc_SatCamPipCommanderZoomOut;
}, {}, [0, [false, false, false]], false] call CBA_fnc_addKeybind;

["GOL Custom Controls", "OKS_SatCam_VisionMode", ["Camera Vision Mode", "Cycle camera vision mode: Normal -> Night Vision -> Thermal."], {
    [] call OKS_fnc_SatCamPipCycleVisionMode;
}, {}, [0, [false, false, false]], false] call CBA_fnc_addKeybind;
