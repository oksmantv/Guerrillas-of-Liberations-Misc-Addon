#include "BIS_AddonInfo.hpp"
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

class CfgWeapons {
	class ACE_ItemCore;
	class CBA_MiscItem_ItemInfo;
	class GOL_Packed_HMG: ACE_ItemCore {
		scope = 2;
		author = "OksmanTV from Guerrillas of Liberation";
		displayName = "Static HMG (Packed)";
		descriptionUse = "Packed HMG. Self-interact to deploy.";
		descriptionShort = "Static HMG (Packed)";
		icon = "\OKS_GOL_Misc\Data\UI\GOL_HMG_Packed.paa";
		picture = "\OKS_GOL_Misc\Data\UI\GOL_HMG_Packed.paa";
		model = "\z\ace\addons\gunbag\data\ace_gunbag.p3d";
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 40;
		};
	};
	class GOL_Packed_GMG: ACE_ItemCore {
		scope = 2;
		author = "OksmanTV from Guerrillas of Liberation";		
		displayName = "Static GMG (Packed)";
		descriptionUse = "Packed GMG. Self-interact to deploy.";
		descriptionShort = "Static GMG (Packed)";
		icon = "\OKS_GOL_Misc\Data\UI\GOL_GMG_Packed.paa";
		picture = "\OKS_GOL_Misc\Data\UI\GOL_GMG_Packed.paa";
		model = "\z\ace\addons\gunbag\data\ace_gunbag.p3d";
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 40;
		};
	};
	class GOL_Packed_Mortar: ACE_ItemCore {
		scope = 2;
		author = "OksmanTV from Guerrillas of Liberation";		
		displayName = "Static Mortar (Packed)";
		descriptionUse = "Packed Mortar. Self-interact to deploy.";
		descriptionShort = "Static Mortar (Packed)";
		icon = "\OKS_GOL_Misc\Data\UI\GOL_Mortar_Packed.paa";
		picture = "\OKS_GOL_Misc\Data\UI\GOL_Mortar_Packed.paa";
		model = "\z\ace\addons\gunbag\data\ace_gunbag.p3d";
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 40;
		};
	};
	class GOL_Packed_AT: ACE_ItemCore {
		scope = 2;
		author = "OksmanTV from Guerrillas of Liberation";		
		displayName = "Static AT (Packed)";
		descriptionUse = "Packed AT. Self-interact to deploy.";
		descriptionShort = "Static AT (Packed)";
		icon = "\OKS_GOL_Misc\Data\UI\GOL_AT_Packed.paa";
		picture = "\OKS_GOL_Misc\Data\UI\GOL_AT_Packed.paa";
		model = "\z\ace\addons\gunbag\data\ace_gunbag.p3d";
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 40;
		};
	};
	class GOL_Packed_Drone_AT: ACE_ItemCore {
		scope = 2;
		author = "OksmanTV from Guerrillas of Liberation";		
		displayName = "Drone AT (Packed)";
		descriptionUse = "Packed AT Drone. Self-interact to deploy.";
		descriptionShort = "Drone AT (Packed)";
		icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
		picture = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
		model = "\fpv_ua\drone_pg7vl.p3d";
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 25;
		};
	};	
	class GOL_Packed_Drone_AP: ACE_ItemCore {
		scope = 2;
		author = "OksmanTV from Guerrillas of Liberation";		
		displayName = "Drone AP (Packed)";
		descriptionUse = "Packed AP Drone. Self-interact to deploy.";
		descriptionShort = "Drone AP (Packed)";
		icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
		picture = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
		model = "\fpv_ua\drone_ied.p3d";
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 25;
		};
	};
	class GOL_Packed_Drone_Supply: ACE_ItemCore {
		scope = 2;
		author = "OksmanTV from Guerrillas of Liberation";		
		displayName = "Drone Resupply (Packed)";
		descriptionUse = "Packed Resupply Drone. Self-interact to deploy.";
		descriptionShort = "Drone Resupply (Packed)";
		icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
		picture = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
		model = "\A3\Air_F_Orange\UAV_06\UAV_06_F.p3d";
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 60;
		};
	};
	
	class GOL_Packed_Drone_Recon: ACE_ItemCore {
		scope = 2;
		author = "OksmanTV from Guerrillas of Liberation";		
		displayName = "Drone Recon (Packed)";
		descriptionUse = "Packed Recon Drone. Self-interact to deploy.";
		descriptionShort = "Drone Recon (Packed)";
		icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
		picture = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
		model = "\A3\Drones_F\Air_F_Gamma\UAV_01\UAV_01_F.p3d";
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 15;
		};
	};		
	class GOL_Packed_60mm_HE: ACE_ItemCore {
		scope = 2;
		author = "OksmanTV from Guerrillas of Liberation";		
		displayName = "M6 60mm HE (Packed)";
		descriptionUse = "Packed M6 60mm HE rounds (4). Self-interact to deploy.";
		descriptionShort = "M6 60mm HE (Packed)";
		icon = "\OKS_GOL_Misc\Data\UI\60mm_HE.paa";
		picture = "\OKS_GOL_Misc\Data\UI\60mm_HE.paa";
		model =  "\rhsusf\addons\rhsusf_m252\rhs_81case_quad_small";
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 20;
		};
	};
	class GOL_Packed_60mm_HEAB: ACE_ItemCore {
		scope = 2;
		author = "OksmanTV from Guerrillas of Liberation";		
		displayName = "M6 60mm HE Airburst (Packed)";
		descriptionUse = "Packed M6 60mm HE Airbust rounds (4). Self-interact to deploy.";
		descriptionShort = "M6 60mm HE Airburst (Packed)";
		icon = "\OKS_GOL_Misc\Data\UI\60mm_HEAB.paa";
		picture = "\OKS_GOL_Misc\Data\UI\60mm_HEAB.paa";
		model =  "\rhsusf\addons\rhsusf_m252\rhs_81case_quad_small";
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 20;
		};
	};
	class GOL_Packed_60mm_FLARE: ACE_ItemCore {
		scope = 2;
		author = "OksmanTV from Guerrillas of Liberation";		
		displayName = "M6 60mm Flare (Packed)";
		descriptionUse = "Packed M6 60mm Flare rounds (4). Self-interact to deploy.";
		descriptionShort = "M6 60mm Flare (Packed)";
		icon = "\OKS_GOL_Misc\Data\UI\60mm_Flare.paa";
		picture = "\OKS_GOL_Misc\Data\UI\60mm_Flare.paa";
		model =  "\rhsusf\addons\rhsusf_m252\rhs_81case_quad_small";
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 20;
		};
	};
	class GOL_Packed_60mm_Smoke: ACE_ItemCore {
		scope = 2;
		author = "OksmanTV from Guerrillas of Liberation";		
		displayName = "M6 60mm Smoke (Packed)";
		descriptionUse = "Packed M6 60mm Smoke rounds (4). Self-interact to deploy.";
		descriptionShort = "M6 60mm Smoke (Packed)";
		icon = "\OKS_GOL_Misc\Data\UI\60mm_Smoke.paa";
		picture = "\OKS_GOL_Misc\Data\UI\60mm_Smoke.paa";
		model =  "\rhsusf\addons\rhsusf_m252\rhs_81case_quad_small";
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 20;
		};
	};					
};

class CfgFunctions // Defines a function
{
	class OKS {
		class Unpack_60mm {
			file = "\OKS_GOL_Misc\functions\staticWeapons";
			class Unpack_60mm_HE_Code {};
			class Unpack_60mm_HEAB_Code {};
			class Unpack_60mm_Smoke_Code {};
			class Unpack_60mm_Flare_Code {};
			class Deploy_AP_Drone_Code {};
			class Deploy_AT_Drone_Code {};
			class Deploy_Recon_Drone_Code {};
			class Deploy_Supply_Drone_Code {};			
			class Deploy_HMG_Code {};			
			class Deploy_GMG_Code {};			
			class Deploy_AT_Code {};			
			class Deploy_Mortar_Code {};			
			class Packing_code {};			
		};
	};
};

class Extended_PreInit_EventHandlers {
    class OKS_PreInit {
        init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_preInit.sqf'";
    };
};

class CfgVehicles {
    class Land;
    class LandVehicle: Land {
        class ACE_Actions {
            class ACE_MainActions {};
        };
    };
	class StaticWeapon : LandVehicle
	{
		class ACE_Actions {
			class ACE_MainActions {};
		};
	};
	class StaticMGWeapon : StaticWeapon
	{
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions : ACE_MainActions {		
				class Pack_Static {
					displayName = "Pack Static HMG";
					condition = "alive _target && vehicle _player != _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_Packed_HMG']), 1, true] && count crew _target == 0 && (typeOf _target) == (missionNamespace getVariable ['GOL_MISC_ADDON_PackedHMGClass', 'RHS_M2StaticMG_USMC_D'])";
					exceptions[] = {};
					statement = "[_player,_target] call OKS_fnc_Packing_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_HMG_Packed.paa";
				};	
			};
		};
	};
	class StaticGrenadeLauncher : StaticWeapon
	{
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions : ACE_MainActions {				
				class Pack_Static {
					displayName = "Pack Static GMG";
					condition = "alive _target && vehicle _player != _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_Packed_GMG']), 1, true] && count crew _target == 0 && (typeOf _target) == (missionNamespace getVariable ['GOL_MISC_ADDON_PackedGMGClass', 'RHS_MK19_TriPod_USMC_WD'])";
					exceptions[] = {};
					statement = "[_player,_target] call OKS_fnc_Packing_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_GMG_Packed.paa";
				};	
			};
		};
	};
	class StaticATWeapon : StaticWeapon
	{
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions : ACE_MainActions {			
				class Pack_Static_AT {
					displayName = "Pack Static AT";
					condition = "alive _target && vehicle _player != _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_Packed_AT']), 1, true] && count crew _target == 0 && (typeOf _target) == (missionNamespace getVariable ['GOL_MISC_ADDON_PackedATClass', 'RHS_TOW_TriPod_USMC_D'])";
					exceptions[] = {};
					statement = "[_player,_target] call OKS_fnc_Packing_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_AT_Packed.paa";
				};	
			};
		};
	};

	class StaticMortar : StaticWeapon
	{
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions : ACE_MainActions {			
				class Pack_Static_Mortar {
					displayName = "Pack Static Mortar";
					condition = "alive _target && vehicle _player != _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_Packed_Mortar']), 1, true] && count crew _target == 0 && (typeOf _target) == (missionNamespace getVariable ['GOL_MISC_ADDON_PackedMortarClass', 'B_G_Mortar_01_F'])";
					exceptions[] = {};
					statement = "[_player,_target] call OKS_fnc_Packing_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_Mortar_Packed.paa";
				};	
			};
		};
	};

    class Air;
    class Helicopter: Air {
        class ACE_Actions {
            class ACE_MainActions {};
        };
    };
    class Helicopter_Base_F: Helicopter {
        class ACE_Actions: ACE_Actions {
            class ACE_MainActions: ACE_MainActions {
				class Pack_Drone {
					displayName = "Pack Drone";
					condition = "alive _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_PACKED_DRONE_AP']), 1, true] && (typeOf _target) in [(missionNamespace getVariable ['GOL_MISC_ADDON_PackedDroneAPClass', 'B_UAFPV_RKG_AP']),(missionNamespace getVariable ['GOL_MISC_ADDON_PackedDroneATClass', 'B_UAFPV_AT']),(missionNamespace getVariable ['GOL_MISC_ADDON_PackedDroneReconClass', 'B_UAV_01_F']),(missionNamespace getVariable ['GOL_MISC_ADDON_PackedDroneSupplyClass', 'B_UAV_06_F'])]";
					exceptions[] = {};
					statement = "[_player,_target] call OKS_fnc_Packing_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";	
				}
			};
        };
    };		

	class Man;
	class CAManBase: Man {
		class ACE_SelfActions {
			class ACE_Equipment {
				class Unpack_60mm_HE {
					displayName = "Unpack 60mm HE";
					condition = "('GOL_Packed_60mm_HE' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Unpack_60mm_HE_Code";
					icon = "\OKS_GOL_Misc\Data\UI\60mm_HE.paa";
				};
				class Unpack_60mm_HEAB {
					displayName = "Unpack 60mm HEAB";
					condition = "('GOL_Packed_60mm_HEAB' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Unpack_60mm_HEAB_Code";
					icon = "\OKS_GOL_Misc\Data\UI\60mm_HEAB.paa";
				};
				class Unpack_60mm_Smoke {
					displayName = "Unpack 60mm Smoke";
					condition = "('GOL_Packed_60mm_Smoke' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Unpack_60mm_Smoke_Code";
					icon = "\OKS_GOL_Misc\Data\UI\60mm_Smoke.paa";
				};
				class Unpack_60mm_Flare {
					displayName = "Unpack 60mm Flare";
					condition = "('GOL_Packed_60mm_Flare' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Unpack_60mm_Flare_Code";
					icon = "\OKS_GOL_Misc\Data\UI\60mm_Flare.paa";
				};

					class Deploy_Drone_AP {
						displayName = "Deploy Drone (AP)";
						condition = "('GOL_Packed_Drone_AP' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_Deploy_AP_Drone_Code";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};
					class Deploy_Drone_AT {
						displayName = "Deploy Drone (AT)";
						condition = "('GOL_Packed_Drone_AT' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_Deploy_AT_Drone_Code";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};
					class Deploy_Drone_Recon {
						displayName = "Deploy Drone (Recon)";
						condition = "('GOL_Packed_Drone_Recon' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_Deploy_Recon_Drone_Code";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};
					class Deploy_Drone_Supply {
						displayName = "Deploy Drone (Supply)";
						condition = "('GOL_Packed_Drone_Supply' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_Deploy_Supply_Drone_Code";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};																
						class Deploy_Static_HMG {
							displayName = "Deploy Static HMG";
							condition = "('GOL_Packed_HMG' in (itemsWithMagazines _player)) && vehicle _player == _player";
							exceptions[] = {};
							statement = "[_player] call OKS_fnc_Deploy_HMG_Code";
							icon = "\OKS_GOL_Misc\Data\UI\GOL_HMG_Packed.paa";
						};
						class Deploy_Static_GMG {
							displayName = "Deploy Static GMG";
							condition = "('GOL_Packed_GMG' in (itemsWithMagazines _player)) && vehicle _player == _player";
							exceptions[] = {};
							statement = "[_player] call OKS_fnc_Deploy_GMG_Code";
							icon = "\OKS_GOL_Misc\Data\UI\GOL_GMG_Packed.paa";
						};
						class Deploy_Static_AT {
							displayName = "Deploy Static AT";
							condition = "('GOL_Packed_AT' in (itemsWithMagazines _player)) && vehicle _player == _player";
							exceptions[] = {};
							statement = "[_player] call OKS_fnc_Deploy_AT_Code";
							icon = "\OKS_GOL_Misc\Data\UI\GOL_AT_Packed.paa";
						};
						class Deploy_Static_Mortar {
							displayName = "Deploy Static Mortar";
							condition = "('GOL_Packed_Mortar' in (itemsWithMagazines _player)) && vehicle _player == _player";
							exceptions[] = {};
							statement = "[_player] call OKS_fnc_Deploy_Mortar_Code";
							icon = "\OKS_GOL_Misc\Data\UI\GOL_Mortar_Packed.paa";
						};					
			};
		};
	};
};