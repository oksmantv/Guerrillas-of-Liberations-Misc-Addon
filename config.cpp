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
        requiredVersion = 2.14;
        requiredAddons[] = { 
            "UK3CB_BAF_Weapons_Static", 
            "ace_main",
            "cba_main",
            "cba_ui",
            "cba_xeh_a3"
        };
	}
};

#include "BIS_AddonInfo.hpp"
#include "CfgWeapons.cpp"
#include "CfgVehicles.cpp"
#include "CfgFunctions.cpp"
#include "CfgSounds.cpp"
#include "CfgUnitInsignia.cpp"
#include "CfgOrbat.cfg"

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

class RscTitles {
    #include "functions\endMenu\endMenu_dialog.hpp"
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