//	Settings for NEKY_Mortars
//
//	(https://community.bistudio.com/wiki/Arma_3_CfgMagazines#8Rnd_82mm_Mo_shells)   Mortar class names
//
//	Made by NeKo-ArroW
// General Settings
_TravelTime = missionNamespace getVariable ["OKS_Mortar_TravelTime", 20];
_SpawnAltitude = missionNamespace getVariable ["OKS_Mortar_SpawnAltitude", 150];
_Avoid = missionNamespace getVariable ["OKS_Mortar_Avoid", true];
_AvoidMultiplier = missionNamespace getVariable ["OKS_Mortar_AvoidMultiplier", 2];
_Danger = missionNamespace getVariable ["OKS_Mortar_Danger", true];
_DangerClose = missionNamespace getVariable ["OKS_Mortar_DangerClose", 50];
_Lock = missionNamespace getVariable ["OKS_Mortar_Lock", true];
_ScanVehicles = missionNamespace getVariable ["OKS_Mortar_ScanVehicles", false];
_Ammo = missionNamespace getVariable ["OKS_Mortar_Ammo", 30];

// Firing Mode settings
_PreciseSize = parseSimpleArray (missionNamespace getVariable ["OKS_Mortar_PreciseSize", "[1,2,3]"]);
_PreciseReloadTime = missionNamespace getVariable ["OKS_Mortar_PreciseReloadTime", 420];
_BarrageSize = parseSimpleArray (missionNamespace getVariable ["OKS_Mortar_BarrageSize", "[8,10,12]"]);
_BarrageReloadTime = missionNamespace getVariable ["OKS_Mortar_BarrageReloadTime", 480];
_BarrageInaccuracyMultiplier = missionNamespace getVariable ["OKS_Mortar_BarrageInaccuracyMultiplier", 1.75];
_SporadicSize = parseSimpleArray (missionNamespace getVariable ["OKS_Mortar_SporadicSize", "[10,12,14]"]);
_SporadicReloadTime = missionNamespace getVariable ["OKS_Mortar_SporadicReloadTime", 220];
_SporadicInaccuracyMultiplier = missionNamespace getVariable ["OKS_Mortar_SporadicInaccuracyMultiplier", 4];
_GuidedSize = parseSimpleArray (missionNamespace getVariable ["OKS_Mortar_GuidedSize", "[9,11,13]"]);
_GuidedReloadTime = missionNamespace getVariable ["OKS_Mortar_GuidedReloadTime", 360];
_GuidedInaccuracyMultiplier = missionNamespace getVariable ["OKS_Mortar_GuidedInaccuracyMultiplier", 3];
_ScreenSize = parseSimpleArray (missionNamespace getVariable ["OKS_Mortar_ScreenSize", "[6,8,10]"]);
_ScreenReloadTime = missionNamespace getVariable ["OKS_Mortar_ScreenReloadTime", 150];

// Class Names
_Light = missionNamespace getVariable ["OKS_Mortar_Light", "UK3CB_BAF_Sh_60mm_AMOS"];
_Medium = missionNamespace getVariable ["OKS_Mortar_Medium", "Sh_82mm_AMOS"];
_Heavy = missionNamespace getVariable ["OKS_Mortar_Heavy", "Sh_155mm_AMOS"];
_Smoke = missionNamespace getVariable ["OKS_Mortar_Smoke", "Smoke_120mm_AMOS_White"];
_Flare = missionNamespace getVariable ["OKS_Mortar_Flare", "F_40mm_White"];

// Day/Night time
_Sunrise = missionNamespace getVariable ["OKS_Mortar_Sunrise", 4.00];
_Sunset = missionNamespace getVariable ["OKS_Mortar_Sunset", 22.00];

// Crew
_BLUFORGunner = ["B_Soldier_F"];							// BLUFOR Gunner for the Mortar
_OPFORGunner = ["O_Soldier_F"];								// OPFOR Gunner for the Mortar
_INDEPGunner = ["I_Soldier_F"];								// INDEPENDENT Gunner for the Mortar

// Marking and Sound effects
_Marking = parseSimpleArray (missionNamespace getVariable ["OKS_Mortar_Marking", "[false,true,true,false,false]"]);
_SoundOn = parseSimpleArray (missionNamespace getVariable ["OKS_Mortar_SoundOn", "[true,true,false,false,true]"]);
_SoundTypes = ["mortar1","mortar1","",""];
_MarkSmoke = missionNamespace getVariable ["OKS_Mortar_MarkSmoke", "SmokeShellRed"];
_MarkFlare = missionNamespace getVariable ["OKS_Mortar_MarkFlare", "F_40mm_Red"];

//	Marking and Sound effects
// Random Parameter
_RandomFiringMode = parseSimpleArray (missionNamespace getVariable ["OKS_Mortar_RandomFiringMode", '["Sporadic", "Precise", "Barrage", "Guided"]']);
