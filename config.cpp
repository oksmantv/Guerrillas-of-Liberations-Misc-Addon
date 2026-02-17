// Config file for GOL Misc Addon
class CfgPatches
{
	class GOL_MISC_ADDON {
        requiredAddons[] = { 
            "A3_3DEN",
            "A3_UI_F", 
            "A3_Soft_F",
            "A3_Soft_F_Beta",
            "A3_Modules_F",
            "A3_Structures_F",
            "A3_Weapons_F",
            "cba_main",
            "cba_ui",
            "cba_xeh_a3",
            "ace_main",
            "rhs_main",
            "rhs_weapons",
            "rhs_c_weapons",
            "rhsusf_main",
            "rhsusf_c_airweapons",
            "rhsusf_c_heavyweapons",
            "UK3CB_BAF_Weapons_Static",
            "UK3CB_BAF_Weapons_SmallArms",
            "UK3CB_BAF_Weapons_L85A3",
            "UK3CB_BAF_Weapons_L119",
            "UK3CB_BAF_Weapons_L110",
            "UK3CB_Factions_Weapons_G36",
            "FPV_UA"
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
			"GOL_Packed_60mm_Smoke",
            "GOL_ResupplyStation_WEST",
            "GOL_ResupplyStation_WEST_Small",
            "GOL_ResupplyStation_EAST",
            "GOL_ResupplyStation_EAST_Small",
			"GOL_ResupplyStation_GUER",
			"GOL_ResupplyStation_GUER_Small",
            "GOL_Helipad",
            "GOL_MobileServiceStation",
            "GOL_GearBox_WEST",
            "GOL_GearBox_EAST",
			"GOL_GearBox_GUER",
			"GOL_SupportBox_WEST",
			"GOL_SupportBox_EAST",
			"GOL_SupportBox_GUER",
            "GOL_MedicalResupply_WEST",
            "GOL_MedicalResupply_EAST",
            "GOL_TeamResupplybox_WEST",
            "GOL_TeamResupplybox_EAST",
            "GOL_SpecialistResupplybox_WEST",
            "GOL_SpecialistResupplybox_EAST",
            "GOL_SquadResupplybox_WEST",
            "GOL_SquadResupplybox_EAST",
            "GOL_O_SAM_System_04_F",
            "GOL_B_SAM_System_03_F",
            "GOL_I_E_SAM_System_03_F",
            "OKS_Module_MechanizedSetup",
            "OKS_Module_HelicopterSetup",
            "OKS_Module_MHQ",
            "OKS_Module_ApplyUnitGear",
			"GOL_FastRope_DZ",
			"GOL_Flag_Hellfish",
            "Fennek_wd","Fennek_d","Fennek_e","Fennek_hmg_wd","Fennek_hmg_d","Fennek_hmg_e","Fennek_gmg_wd","Fennek_gmg_d","Fennek_gmg_e"
		};
		weapons[] = {
            "UK3CB_V_Invisible_Plate_Low",
            "UK3CB_V_Invisible_Plate_Medium",
            "UK3CB_V_Invisible_Plate_High",
            "rhs_6b2_GOL",
            "rhs_6b2_AK_GOL",
            "rhs_6b2_chicom_GOL",
            "rhs_6b2_holster_GOL",
            "rhs_6b2_lifchik_GOL",
            "rhs_6b2_RPK_GOL",
            "rhs_6b2_SVD_GOL",
            "rhs_beret_vdv1_GOL",
            "rhs_beret_vdv2_GOL",
            "rhs_beret_vdv3_GOL",
            "OKS_DroneDisruptor_Pistol",
            "GOL_MMG_01_tan_F",
            "GOL_MMG_01_hex_F",
            "GOL_weap_pkm",
            "GOL_weap_pkp",
            "GOL_MMG_02_black_F",
            "GOL_MMG_02_camo_F",
            "GOL_MMG_02_sand_F",
            "GOL_LMG_Zafir_F",
            "GOL_weap_fnmag",
            "GOL_MG3_KWS_B"
        };
		magazines[] = {
			"GOL_150Rnd_93x64_Mag",
			"GOL_150Rnd_93x64_Mag_Tracer",
			"GOL_150Rnd_93x64_Mag_Tracer_Red",
			"GOL_150Rnd_93x64_Mag_Tracer_Green",
			"GOL_150Rnd_93x64_Mag_Tracer_Yellow",
			"GOL_100Rnd_762x54mmR",
			"GOL_100Rnd_762x54mmR_red",
			"GOL_100Rnd_762x54mmR_green",
			"GOL_130Rnd_338_Mag",
			"GOL_130Rnd_338_Mag_red",
			"GOL_130Rnd_338_Mag_green",
			"GOL_30Rnd_556x45_AP45",
			"GOL_30Rnd_556x45_AP45_Tracer_Red",
			"GOL_30Rnd_556x45_AP45_Tracer_Green",
			"GOL_30Rnd_556x45_AP45_Tracer_Yellow",
			"GOL_G36_30Rnd_556x45_AP45",
			"GOL_G36_30Rnd_556x45_AP45_Tracer_Red",
			"GOL_G36_30Rnd_556x45_AP45_Tracer_Green",
			"GOL_G36_30Rnd_556x45_AP45_Tracer_Yellow",
			"GOL_200Rnd_556x45_AP45_Box",
			"GOL_200Rnd_556x45_AP45_Box_Tracer_Red",
			"GOL_200Rnd_556x45_AP45_Box_Tracer_Green",
			"GOL_200Rnd_556x45_AP45_Box_Tracer_Yellow",
			"GOL_UK3CB_BAF_556_200Rnd_AP45",
			"GOL_UK3CB_BAF_556_200Rnd_AP45_T_Red",
			"GOL_UK3CB_BAF_556_200Rnd_AP45_T_Green",
			"GOL_UK3CB_BAF_556_200Rnd_AP45_T_Yellow",
			"GOL_rhsusf_200rnd_556x45_AP45",
			"GOL_rhsusf_200rnd_556x45_AP45_tracer_red",
			"GOL_rhsusf_200rnd_556x45_AP45_tracer_green",
			"GOL_rhsusf_200rnd_556x45_AP45_tracer_yellow"
		};
	};
};

#include "version.hpp"
#include "BIS_AddonInfo.hpp"
#include "configs\CfgAmmo.cpp"
#include "configs\CfgEden.cpp"
#include "configs\CfgMagazines.cpp"
#include "configs\CfgMagazineWells.cpp"
#include "configs\CfgWeapons.cpp"
#include "configs\CfgVehicles.cpp"
#include "configs\CfgFunctions.cpp"
#include "configs\CfgSounds.cpp"
#include "configs\CfgUnitInsignia.cpp"
#include "configs\CfgMarkers.cpp"
#include "functions\logic\baseControls.hpp"

class RscTitles {
    #include "configs\CfgJammerHUD.cpp"
    #include "configs\CfgSatCamHUD.cpp"
};

#include "configs\CfgJammerUILayout.cpp"
#include "configs\CfgOrbat.cfg"

class CfgMods {
    class GOL_MISC_ADDON {
        name = "Guerrillas of Liberation Misc";
        author = "Oksman";
        url = "https://gol-clan.com/home";
    };
};

class CBA_VERSIONING {
    class GOL_MISC_ADDON {
        version = MISC_VERSION_STR;
        server = 1; // Server must have matching version
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
    class GOL_Objects {
        displayName = "Objects";
    };      
};

class CfgFactionClasses {
    class GOL {
        displayName = "Guerrillas of Liberation";
        icon = "";
        priority = 0;
        side = 1;
    };
    class GOL_Modules {
        displayName = "GOL Modules";
        priority = 1;
        side = 7;
    };
    class BLU_F_WD
	{
		displayName = "NATO (Woodland)";
		side = 1;
		flag = "\a3\Data_f\Flags\flag_nato_co.paa";
		icon = "\a3\Data_f\cfgFactionClasses_BLU_ca.paa";
		priority = 0;
	};
	class BLU_F_D
	{
		displayName = "NATO (Desert)";
		side = 1;
		flag = "\a3\Data_f\Flags\flag_nato_co.paa";
		icon = "\a3\Data_f\cfgFactionClasses_BLU_ca.paa";
		priority = 0;
	};
	class BLU_F_A
	{
		displayName = "NATO (Arid)";
		side = 1;
		flag = "\a3\Data_f\Flags\flag_nato_co.paa";
		icon = "\a3\Data_f\cfgFactionClasses_BLU_ca.paa";
		priority = 0;
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
    class OKS_PreInit_Enemy {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_enemy.sqf'";
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
    class OKS_PreInit_Convoy {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_convoy.sqf'";
    };
    class OKS_PreInit_Jets {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_jets.sqf'";
    };
    class OKS_PreInit_Mortar {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_mortar.sqf'";
    };
    class OKS_PreInit_Eden {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_eden.sqf'";
    };
    class OKS_PreInit_BallisticMissiles {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_ballisticMissiles.sqf'";
    };
    class OKS_PreInit_Amphibious {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_amphibious.sqf'";
    };
    class OKS_PreInit_Vehicles {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_vehicles.sqf'";
    };
    class OKS_PreInit_Drones {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_drones.sqf'";
    };
};

class Extended_PostInit_EventHandlers {
    class OKS_PostInit_Global {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PostInit\XEH_PostInit_Global.sqf'";
    };
    class OKS_PostInit_Server {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PostInit\XEH_PostInit_Server.sqf'";
    };
    class OKS_PostInit_Intercom {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PostInit\XEH_postInit_Intercom.sqf'";
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

class RscStandardDisplay;
class OKS_MissionComplete_base: RscButtonMenu  {
    idc = 470215;
    text = "MISSION COMPLETE";
    tooltip="Sets up safety and scoreboards";    
    x = "1 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX)";
    y = "7 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + safezoneY";
    w = "15 * (((safezoneW / safezoneH) min 1.2) / 40)";
    h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
    action = "(findDisplay 49) closeDisplay 0; createDialog 'OKS_ConfirmationDialog'; missionNamespace setVariable ['OKS_MissionAction', true, true];";
};
class OKS_MissionFailed_base: RscButtonMenu  {
    idc = 470215;
    text = "MISSION FAILED";
    tooltip="Sets up safety and scoreboards";    
    x = "1 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX)";
    y = "8.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + safezoneY";
    w = "15 * (((safezoneW / safezoneH) min 1.2) / 40)";
    h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
    action = "(findDisplay 49) closeDisplay 0; createDialog 'OKS_ConfirmationDialog'; missionNamespace setVariable ['OKS_MissionAction', false, true];";
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

// Confirmation Dialog
class OKS_ConfirmationDialog {
    idd = -1;
    movingEnable = false;
    enableSimulation = true;
    class controlsBackground {
        class Background: RscText {
            idc = -1;
            x = 0.4; y = 0.4;
            w = 0.25; h = 0.15;
            colorBackground[] = {0, 0, 0, 0.7};
        };
    };
    class controls {
        class Text: RscText {
            idc = -1;
            text = "Confirm Mission End?";
            x = 0.42; y = 0.42;
            w = 0.24; h = 0.04;
        };
        class ButtonOK: RscButton {
            idc = -1;
            text = "YES";
            x = 0.43; y = 0.48;
            w = 0.08; h = 0.04;
            action = "closeDialog 0; missionNamespace getVariable ['OKS_MissionAction', false] spawn OKS_fnc_SetMissionComplete;";
        };
        class ButtonCancel: RscButton {
            idc = -1;
            text = "NO";
            x = 0.52; y = 0.48;
            w = 0.08; h = 0.04;
            action = "closeDialog 0;";
        };
    };
};



