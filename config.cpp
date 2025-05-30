#include "BIS_AddonInfo.hpp"
#include "CfgWeapons.cpp"
#include "CfgVehicles.cpp"
#include "CfgFunctions.cpp"
#include "CfgSounds.cpp"
#include "CfgOrbat.cfg"

class CfgPatches
{
	class GOL_MISC_ADDON {
		author = "OksmanTV";
		name = "GOL Misc Addon";
		url = "https://gol-clan.com/";
		units[] = {
			"GOL_Packed_HMG",
			"GOL_Packed_GMG",
			"GOL_Packed_Mortar",
			"GOL_Packed_AT",
			"GOL_Packed_Drone_AP",
			"GOL_Packed_Drone_AT",
			"GOL_Packed_Drone_Recon",
			"GOL_Packed_Drone_Supply",
			"GOL_Packed_60mm_HE",
			"GOL_Packed_60mm_HEAB",
			"GOL_Packed_60mm_FLARE",
			"GOL_Packed_60mm_Smoke"
		};
		weapons[] = {};
		requiredAddons[] = { "UK3CB_BAF_Weapons_Static" };
	}
};

class Extended_PreInit_EventHandlers {
    class OKS_PreInit {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_preInit.sqf'";
    };
};

class Extended_PostInit_EventHandlers {
    class OKS_PostInit {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PostInit.sqf'";
    };
};
