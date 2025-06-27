class CfgPatches
{
	class GOL_MISC_ADDON {
        requiredAddons[] = { 
            "A3_UI_F", 
            "ace_main",
            "cba_main",
            "cba_ui",
            "cba_xeh_a3",
            "UK3CB_BAF_Weapons_Static",
            "rhs_main",
            "rhs_weapons",
            "rhs_c_weapons"
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
#include "configs\CfgAmmo.cpp"
#include "configs\CfgMagazines.cpp"
#include "configs\CfgWeapons.cpp"
#include "configs\CfgVehicles.cpp"
#include "configs\CfgFunctions.cpp"
#include "configs\CfgSounds.cpp"
#include "configs\CfgUnitInsignia.cpp"
#include "configs\CfgOrbat.cfg"

class CfgEditorCategories {
    class GOL_GuerrillasOfLiberation {
        displayName = "GOL Guerrillas of Liberation";
    }; 
};

class CfgEditorSubcategories {
    class GOL_Resupply {
        displayName = "Resupply";
    };  
};

class Extended_PreInit_EventHandlers {
    class OKS_PreInit_Core {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_core.sqf'";
    };
    class OKS_PreInit_Supply {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_supply.sqf'";
    };
    class OKS_PreInit_Gear {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_gear.sqf'";
    };
    class OKS_PreInit_Gear_AI {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_gear_ai.sqf'";
    };   
    class OKS_PreInit_Dynamic {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_dynamic.sqf'";
    };
    class OKS_PreInit_MHQ {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_mhq.sqf'";
    };
    class OKS_PreInit_ORBAT {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_orbat.sqf'";
    };
    class OKS_PreInit_Hunt {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_hunt.sqf'";
    };
    class OKS_PreInit_Suppression {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_suppression.sqf'";
    };
     class OKS_PreInit_Surrender {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_surrender.sqf'";
    };   
    class OKS_PreInit_FaceSwap {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_faceswap.sqf'";
    };
    class OKS_PreInit_Packing {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_PreInit_Packing.sqf'";
    };   
    class OKS_PreInit_Tasks {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_PreInit_Tasks.sqf'";
    };   
    class OKS_PreInit_AirDrop {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_PreInit_AirDrop.sqf'";
    };            
};

class Extended_PostInit_EventHandlers {
    class OKS_PostInit_Global {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PostInit\XEH_PostInit_Global.sqf'";
    };
    class OKS_PostInit_Server {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PostInit\XEH_PostInit_Server.sqf'";
    };    
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
    action = "(findDisplay 49) closeDisplay 0; [true] spawn OKS_fnc_SetMissionComplete;";
};
class OKS_MissionFailed_base: RscButtonMenu  {
    idc = 470215;
    text = "MISSION FAILED";
	tooltip="Sets up safety and scoreboards";    
	x = "1 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX)";
	y = "8.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + safezoneY";
	w = "15 * (((safezoneW / safezoneH) min 1.2) / 40)";
	h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
    action = "(findDisplay 49) closeDisplay 0; [false] spawn OKS_fnc_SetMissionComplete;";
};

class RscDisplayInterrupt: RscStandardDisplay {
    class controls {
        class OKS_MissionComplete: OKS_MissionComplete_base {};
        class OKS_MissionFailed: OKS_MissionFailed_base {};
    };
};

class RscDisplayMPInterrupt: RscStandardDisplay {
	class controls {
		class OKS_MissionComplete: OKS_MissionComplete_base {};
		class OKS_MissionFailed: OKS_MissionFailed_base {};
	};
};


