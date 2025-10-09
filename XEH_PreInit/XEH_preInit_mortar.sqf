// XEH_preInit_mortar.sqf
// Initializes mortar-related variables and CBA settings for GOL Mortars

diag_log "OKS_GOL_Misc: XEH_preInit_mortar.sqf executed";

// General Settings
[
    "OKS_Mortar_TravelTime",
    "SLIDER",
    ["Travel Time", "Time it takes for round to travel to its position (seconds)."],
    "GOL Mortars",
    [2, 60, 20],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_SpawnAltitude",
    "SLIDER",
    ["Spawn Altitude", "Altitude at which the mortar rounds spawns (meters)."],
    "GOL Mortars",
    [200, 1000, 300],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_Avoid",
    "CHECKBOX",
    ["Avoid Friendlies", "Avoid firing near friendlies within inaccuracy area."],
    "GOL Mortars",
    true
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_AvoidMultiplier",
    "SLIDER",
    ["Avoid Multiplier", "Multiplier for inaccuracy zone to count as 'too close'."],
    "GOL Mortars",
    [1, 5, 2],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_Danger",
    "CHECKBOX",
    ["Danger Dismount", "Dismount static weapon if enemy is close."],
    "GOL Mortars",
    true
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_DangerClose",
    "SLIDER",
    ["Danger Close Range", "Range to react to enemy and dismount (meters)."],
    "GOL Mortars",
    [0, 500, 50],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_Lock",
    "CHECKBOX",
    ["Lock Mortar", "Lock the mortar if the gunner dies or leaves it."],
    "GOL Mortars",
    true
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_ScanVehicles",
    "CHECKBOX",
    ["Scan Vehicles", "Count manned vehicles as targets when scanning."],
    "GOL Mortars",
    false
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_Ammo",
    "SLIDER",
    ["Total Ammo", "Total ammo the mortar can spend before dismount (rounds)."],
    "GOL Mortars",
    [1, 100, 30],
    1
] call CBA_fnc_addSetting;

// Firing Mode Settings (Arrays as EDITBOX for now)
[
    "OKS_Mortar_PreciseSize",
    "EDITBOX",
    ["Precise Size", "Array: Number of mortars per 'Precise' rotation (e.g. [1,2,3])."],
    "GOL Mortars",
    '[1,2,3]'
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_PreciseReloadTime",
    "SLIDER",
    ["Precise Reload Time", "Cooldown after a Precise strike (seconds)."],
    "GOL Mortars",
    [0, 1200, 420],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_BarrageSize",
    "EDITBOX",
    ["Barrage Size", "Array: Number of mortars per Barrage (e.g. [8,10,12])."],
    "GOL Mortars",
    '[8,10,12]'
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_BarrageReloadTime",
    "SLIDER",
    ["Barrage Reload Time", "Cooldown after a Barrage (seconds)."],
    "GOL Mortars",
    [0, 1200, 480],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_BarrageInaccuracyMultiplier",
    "SLIDER",
    ["Barrage Inaccuracy Multiplier", "How much more inaccurate the barrage is compared to precise."],
    "GOL Mortars",
    [1, 10, 1.75],
    0.01
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_SporadicSize",
    "EDITBOX",
    ["Sporadic Size", "Array: Number of mortars per 'Sporadic' rotation (e.g. [10,12,14])."],
    "GOL Mortars",
    '[10,12,14]'
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_SporadicReloadTime",
    "SLIDER",
    ["Sporadic Reload Time", "Cooldown after a Sporadic strike (seconds)."],
    "GOL Mortars",
    [0, 1200, 220],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_SporadicInaccuracyMultiplier",
    "SLIDER",
    ["Sporadic Inaccuracy Multiplier", "How much more inaccurate the sporadic strike is compared to precise."],
    "GOL Mortars",
    [1, 10, 4],
    0.01
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_GuidedSize",
    "EDITBOX",
    ["Guided Size", "Array: Number of mortars per 'Guided' rotation (e.g. [9,11,13])."],
    "GOL Mortars",
    '[9,11,13]'
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_GuidedReloadTime",
    "SLIDER",
    ["Guided Reload Time", "Cooldown after a Guided strike (seconds)."],
    "GOL Mortars",
    [0, 1200, 360],
    1
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_GuidedInaccuracyMultiplier",
    "SLIDER",
    ["Guided Inaccuracy Multiplier", "How much more inaccurate the Guided strike is to begin with."],
    "GOL Mortars",
    [1, 10, 3],
    0.01
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_ScreenSize",
    "EDITBOX",
    ["Screen Size", "Array: Number of mortars per 'Screen' rotation (e.g. [6,8,10])."],
    "GOL Mortars",
    '[6,8,10]'
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_ScreenReloadTime",
    "SLIDER",
    ["Screen Reload Time", "Cooldown after a Screen strike (seconds)."],
    "GOL Mortars",
    [0, 1200, 150],
    1
] call CBA_fnc_addSetting;

// Class Names (Strings)
[
    "OKS_Mortar_Light",
    "EDITBOX",
    ["Light Round Class", "Class name of light mortar round."],
    "GOL Mortars",
    'UK3CB_BAF_Sh_60mm_AMOS'
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_Medium",
    "EDITBOX",
    ["Medium Round Class", "Class name of medium mortar round."],
    "GOL Mortars",
    'Sh_82mm_AMOS'
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_Heavy",
    "EDITBOX",
    ["Heavy Round Class", "Class name of heavy mortar round."],
    "GOL Mortars",
    'Sh_155mm_AMOS'
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_Smoke",
    "EDITBOX",
    ["Smoke Round Class", "Class name of smoke round."],
    "GOL Mortars",
    'Smoke_120mm_AMOS_White'
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_Flare",
    "EDITBOX",
    ["Flare Round Class", "Class name of flare round."],
    "GOL Mortars",
    'F_40mm_White'
] call CBA_fnc_addSetting;

// Day/Night time
[
    "OKS_Mortar_Sunrise",
    "SLIDER",
    ["Sunrise", "Time it gets bright enough for smokes (0.00 - 23.59)."],
    "GOL Mortars",
    [0, 23.99, 4.00],
    0.01
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_Sunset",
    "SLIDER",
    ["Sunset", "Time it gets dark enough to start using flares (0.00 - 23.59)."],
    "GOL Mortars",
    [0, 23.99, 22.00],
    0.01
] call CBA_fnc_addSetting;

// Marking and Sound effects
[
    "OKS_Mortar_Marking",
    "EDITBOX",
    ["Marking Modes", "Array: Marking on firing modes [Sporadic,Precise,Barrage,Guided,Screen] (e.g. [false,true,true,false,false])."],
    "GOL Mortars",
    '[false,true,true,false,false]'
] call CBA_fnc_addSetting;

[
    "OKS_Mortar_MarkSmoke",
    "EDITBOX",
    ["Mark Smoke Class", "Class name of smoke that marks target area."],
    "GOL Mortars",
    'SmokeShellRed'
] call CBA_fnc_addSetting;
[
    "OKS_Mortar_MarkFlare",
    "EDITBOX",
    ["Mark Flare Class", "Class name of flare that marks target area."],
    "GOL Mortars",
    'F_40mm_Red'
] call CBA_fnc_addSetting;

// Random Firing Mode
[
    "OKS_Mortar_RandomFiringMode",
    "EDITBOX",
    ["Random Firing Modes", "Array: Firing modes if set to 'Random' (e.g. ['Sporadic','Precise','Barrage','Guided'])."],
    "GOL Mortars",
    '["Sporadic", "Precise", "Barrage", "Guided"]'
] call CBA_fnc_addSetting;
