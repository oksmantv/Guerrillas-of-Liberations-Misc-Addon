diag_log "OKS_GOL_Misc: XEH_preInit_stealth.sqf executed";

// ============================================================================
// GENERAL SETTINGS
// ============================================================================

[
	"GOL_OKS_Enemy_Nationality",
	"LIST",
	["Enemy Nationality", "Determines which language/voice set to use for enemy radio and talk sounds"],
	["GOL Stealth", "General"],
	[
		["russian", "arabic", "vietnamese"],
		["Russian", "Arabic", "Vietnamese"],
		0
	],
	true
] call CBA_fnc_addSetting;

[
	"GOL_OKS_Enemy_Faction",
	"LIST",
	["Enemy Faction", "Which faction to monitor for stealth systems (radio chatter, tracking, etc.)"],
	["GOL Stealth", "General"],
	[
		[east, west, independent],
		["OPFOR (East)", "BLUFOR (West)", "Independent"],
		0
	],
	true
] call CBA_fnc_addSetting;

// ============================================================================
// PLAYER TRACKING
// ============================================================================

[
	"GOL_OKS_Tracker",
	"CHECKBOX",
	["Enable Player Tracking", "Enables the OKS tracking system where player groups leave footprints that AI trackers can follow"],
	["GOL Stealth", "Player Tracking"],
	false,
	true
] call CBA_fnc_addSetting;

[
	"GOL_OKS_Tracker_Range",
	"SLIDER",
	["Tracker Detection Range", "Range in meters that tracker groups search for player footprints"],
	["GOL Stealth", "Player Tracking"],
	[100, 1000, 500, 0],
	true
] call CBA_fnc_addSetting;

[
	"GOL_OKS_Player_Camouflage",
	"SLIDER",
	["Player Camouflage Coefficient", "Sets the camouflageCoef trait for all players. Lower values make players harder to detect by AI. Applied on spawn and respawn."],
	["GOL Stealth", "Player Tracking"],
	[0.2, 0.7, 0.3, 1],
	true
] call CBA_fnc_addSetting;

// ============================================================================
// ENEMY DIALOGUE
// ============================================================================

[
	"GOL_OKS_Enemy_Talk",
	"CHECKBOX",
	["Enable Enemy Talking", "Enables ambient enemy dialogue when players are nearby"],
	["GOL Stealth", "Enemy Dialogue"],
	false,
	true
] call CBA_fnc_addSetting;

[
	"GOL_OKS_Talk_Distance",
	"SLIDER",
	["Detection Range", "Distance in meters that enemies will talk when players are nearby"],
	["GOL Stealth", "Enemy Dialogue"],
	[50, 300, 125, 0],
	true
] call CBA_fnc_addSetting;

[
	"GOL_OKS_Talk_Chance",
	"SLIDER",
	["Talk Chance", "Probability that enemies will talk when conditions are met (0-1)"],
	["GOL Stealth", "Enemy Dialogue"],
	[0, 1, 1, 2],
	true
] call CBA_fnc_addSetting;

[
	"GOL_OKS_Talk_MinDelay",
	"SLIDER",
	["Minimum Delay", "Minimum seconds between enemy dialogue"],
	["GOL Stealth", "Enemy Dialogue"],
	[5, 30, 9, 0],
	true
] call CBA_fnc_addSetting;

[
	"GOL_OKS_Talk_MaxDelay",
	"SLIDER",
	["Maximum Delay", "Maximum seconds between enemy dialogue"],
	["GOL Stealth", "Enemy Dialogue"],
	[10, 60, 14, 0],
	true
] call CBA_fnc_addSetting;

[
	"GOL_OKS_Talk_LoopDelay",
	"SLIDER",
	["Check Interval", "How often (in seconds) to check if enemies should talk"],
	["GOL Stealth", "Enemy Dialogue"],
	[1, 30, 5, 0],
	true
] call CBA_fnc_addSetting;

[
	"GOL_OKS_Talk_AllowStatic",
	"CHECKBOX",
	["Static Units Can Talk", "Whether static/sentry units should engage in dialogue"],
	["GOL Stealth", "Enemy Dialogue"],
	false,
	true
] call CBA_fnc_addSetting;

// ============================================================================
// ENEMY RADIO
// ============================================================================

[
	"GOL_OKS_Enemy_Radio",
	"CHECKBOX",
	["Enable Radio Chatter", "Enables radio sounds from dead enemy corpses when players are nearby and enemies are alerted"],
	["GOL Stealth", "Enemy Radio"],
	false,
	true
] call CBA_fnc_addSetting;

// ============================================================================
// SENTRY SYSTEM
// ============================================================================

[
	"GOL_OKS_Sentry_ChanceForRadio",
	"SLIDER",
	["Radio Equipment Chance", "Chance that a sentry will have radio equipment to call reinforcements (0-1)"],
	["GOL Stealth", "Sentry System"],
	[0, 1, 0.25, 2],
	true
] call CBA_fnc_addSetting;

[
	"GOL_OKS_Sentry_RequiresRadio",
	"CHECKBOX",
	["Requires Radio", "Whether sentries need radio equipment (or nearby radio) to call reinforcements"],
	["GOL Stealth", "Sentry System"],
	true,
	true
] call CBA_fnc_addSetting;

[
	"GOL_OKS_Hunt_Range",
	"SLIDER",
	["Hunt Response Range", "Range in meters that enemy groups will respond to sentry alerts"],
	["GOL Stealth", "Sentry System"],
	[100, 2000, 500, 0],
	true
] call CBA_fnc_addSetting;
