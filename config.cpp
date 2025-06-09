class CfgPatches
{
	class GOL_MISC_ADDON {
        requiredAddons[] = { 
            "A3_UI_F", 
            "ace_main",
            "cba_main",
            "cba_ui",
            "cba_xeh_a3",
            "UK3CB_BAF_Weapons_Static"
        };
        requiredVersion = 2.14;
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
	}
};

#include "BIS_AddonInfo.hpp"
#include "configs\CfgWeapons.cpp"
#include "configs\CfgVehicles.cpp"
#include "configs\CfgFunctions.cpp"
#include "configs\CfgSounds.cpp"
#include "configs\CfgUnitInsignia.cpp"
#include "configs\CfgOrbat.cfg"

class Extended_PreInit_EventHandlers {
    class OKS_PreInit {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH\XEH_preInit.sqf'";
    };
};

class Extended_PostInit_EventHandlers {
    class OKS_PostInit {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH\XEH_PostInit.sqf'";
    };
};

class CfgEditorCategories {
    class GOL_GuerrillasOfLiberation {
        displayName = "GOL Guerrillas of Liberation";
    };
};
class CfgEditorSubcategories {
    class GOL_Resupply {
        displayName = "Resupply";
    };
    // Add more subcategories as needed
};

class CfgSettings {
    class CBA {
        class Versioning {
            class GOL_MISC_ADDON {
                main_addon = "GOL_MISC_ADDON";
            };
        };
    };
};

#include "functions\logic\baseControls.hpp"

class RscStandardDisplay;
class OKS_MissionComplete_base: RscButtonMenu  {
    idc = 470215;
    text = "MISSION COMPLETE";
	tooltip="Sets up safety and scoreboards";    
	x = "1 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX)";
	y = "7 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + safezoneY";
	w = "15 * (((safezoneW / safezoneH) min 1.2) / 40)";
	h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
    action = "(findDisplay 49) closeDisplay 0; [] spawn OKS_fnc_SetMissionComplete;";
};

class RscDisplayInterrupt: RscStandardDisplay {
    class controls {
        class OKS_MissionComplete: OKS_MissionComplete_base {};
    };
};

class RscDisplayMPInterrupt: RscStandardDisplay {
	class controls {
		class OKS_MissionComplete: OKS_MissionComplete_base {};
	};
};


