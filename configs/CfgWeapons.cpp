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
			mass = 50;
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
			mass = 50;
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
			mass = 50;
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
			mass = 50;
		};
	};

	class OKS_DroneJammer: ACE_ItemCore {
		scope = 2;
		author = "OksmanTV from Guerrillas of Liberation";
		displayName = "Drone Jammer";
		descriptionUse = "Portable drone jammer. Self-interact to activate.";
		descriptionShort = "Disrupts drone guidance systems within 350m when activated.";
		icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\radio_ca.paa";
		picture = "\a3\ui_f\data\igui\cfg\simpleTasks\types\radio_ca.paa";
		model = "\A3\Weapons_F\Items\GPS.p3d";
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 20;
		};
	};
	class OKS_DroneDetector: ACE_ItemCore {
		scope = 2;
		author = "OksmanTV from Guerrillas of Liberation";
		displayName = "Drone Detector";
		descriptionUse = "Portable drone detector. Self-interact to activate.";
		descriptionShort = "Detects nearby drones within 500m and displays alerts.";
		icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
		picture = "\a3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
		model = "\A3\Weapons_F\Items\GPS.p3d";
		class ItemInfo: CBA_MiscItem_ItemInfo {
			mass = 15;
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
			mass = 17;
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
			mass = 17;
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
			mass = 80;
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
			mass = 30;
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
			mass = 15;
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
			mass = 15;
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
			mass = 15;
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
			mass = 15;
		};
	};		

	class rhs_weap_igla;
	class gol_weapon_igla : rhs_weap_igla {
		displayName = "9K38 Igla (Disabled ACE Guidance)";
        magazines[] = { "gol_mag_9k38_rocket" };
		scope = 2;
    };

	class weapon_s750Launcher;
	class gol_weapon_s750Launcher : weapon_s750Launcher {
		displayName = "S-400 (Disabled ACE Guidance)";
        magazines[] = { "gol_magazine_Missile_s750_x4" };
		scope = 2;
    };	

	class UK3CB_V_Invisible_Plate;
	class UK3CB_V_Invisible_Plate_Low : UK3CB_V_Invisible_Plate {
		author = "3CB Factions edited by OksmanTV from Guerrillas of Liberation";
		displayName = "Invisible Chestrig + Plate (Low)";
		descriptionShort = "Armor Level I";
		class ItemInfo {
			_generalMacro = "VestItem";
			author = "Bohemia Interactive";
			containerClass = "Supply180";
			hiddenSelections[] = {};
			mass = 80;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			showHolsteredPistol = 0;
			type = 701;
			uniformModel = "\A3\weapons_f\empty";
			uniformType = "Default";

			class HitpointsProtectionInfo {
				class Abdomen {
					armor = 8;
					hitpointName = "HitAbdomen";
					passThrough = 0.3;
				};
				class Body {
					hitpointName = "HitBody";
					passThrough = 0.3;
				};
				class Chest {
					armor = 8;
					hitpointName = "HitChest";
					passThrough = 0.3;
				};		
				class Diaphragm {
					armor = 4;
					hitpointName = "HitDiaphragm";
					passThrough = 0.3;
				};	
			};
		};
	};

	class UK3CB_V_Invisible_Plate_Medium : UK3CB_V_Invisible_Plate {
		author = "3CB Factions edited by OksmanTV from Guerrillas of Liberation";
		displayName = "Invisible Chestrig + Plate (Medium)";
		descriptionShort = "Armor Level II";
		class ItemInfo {
			_generalMacro = "VestItem";
			author = "Bohemia Interactive";
			containerClass = "Supply180";
			hiddenSelections[] = {};
			mass = 80;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			showHolsteredPistol = 0;
			type = 701;
			uniformModel = "\A3\weapons_f\empty";
			uniformType = "Default";

			class HitpointsProtectionInfo {
				class Abdomen {
					armor = 10;
					hitpointName = "HitAbdomen";
					passThrough = 0.3;
				};
				class Body {
					hitpointName = "HitBody";
					passThrough = 0.3;
				};
				class Chest {
					armor = 10;
					hitpointName = "HitChest";
					passThrough = 0.3;
				};		
				class Diaphragm {
					armor = 5;
					hitpointName = "HitDiaphragm";
					passThrough = 0.3;
				};	
			};
		};
	};	
	
	class UK3CB_V_Invisible_Plate_High : UK3CB_V_Invisible_Plate {
		author = "3CB Factions edited by OksmanTV from Guerrillas of Liberation";
		displayName = "Invisible Chestrig + Plate (High)";
		descriptionShort = "Armor Level IV";
		class ItemInfo {
			_generalMacro = "VestItem";
			author = "Bohemia Interactive";
			containerClass = "Supply180";
			hiddenSelections[] = {};
			mass = 80;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			showHolsteredPistol = 0;
			type = 701;
			uniformModel = "\A3\weapons_f\empty";
			uniformType = "Default";

			class HitpointsProtectionInfo {
				class Abdomen {
					armor = 12;
					hitpointName = "HitAbdomen";
					passThrough = 0.3;
				};
				class Body {
					hitpointName = "HitBody";
					passThrough = 0.3;
				};
				class Chest {
					armor = 12;
					hitpointName = "HitChest";
					passThrough = 0.3;
				};		
				class Diaphragm {
					armor = 6;
					hitpointName = "HitDiaphragm";
					passThrough = 0.3;
				};	
			};
		};
	};

	class rhs_6b2_GOL : UK3CB_V_Invisible_Plate {
		author = "3CB Factions edited by OksmanTV from Guerrillas of Liberation";
		displayName = "62B (GOL)";
		descriptionShort = "Armor Level 4";
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\vests\rhs_6b2_ca.paa";
		model = "rhsafrf\addons\rhs_infantry3\gear\vests\rhs_6b2";
		class ItemInfo {
			_generalMacro = "VestItem";
			author = "Bohemia Interactive";
			containerClass = "Supply180";
			hiddenSelections[] = {};
			mass = 80;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			showHolsteredPistol = 0;
			type = 701;
			uniformModel = "rhsafrf\addons\rhs_infantry3\gear\vests\rhs_6b2";
			uniformType = "Default";
			class HitpointsProtectionInfo {
				class Abdomen { armor = 17; hitpointName = "HitAbdomen"; passThrough = 0.3; };
				class Body { hitpointName = "HitBody"; passThrough = 0.3; };
				class Chest { armor = 17; hitpointName = "HitChest"; passThrough = 0.3; };
				class Diaphragm { armor = 17; hitpointName = "HitDiaphragm"; passThrough = 0.3; };
			};
		};
	};

	class rhs_6b2_AK_GOL : UK3CB_V_Invisible_Plate {
		author = "3CB Factions edited by OksmanTV from Guerrillas of Liberation";
		displayName = "6B2 (6Sh46)";
		descriptionShort = "Armor Level 4";
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\vests\rhs_6b2_AK_ca.paa";
		model = "rhsafrf\addons\rhs_infantry3\gear\vests\rhs_6b2_AK";
		class ItemInfo {
			_generalMacro = "VestItem";
			author = "Bohemia Interactive";
			containerClass = "Supply180";
			hiddenSelections[] = {};
			mass = 80;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			showHolsteredPistol = 0;
			type = 701;
			uniformModel = "rhsafrf\addons\rhs_infantry3\gear\vests\rhs_6b2_AK";
			uniformType = "Default";
			class HitpointsProtectionInfo {
				class Abdomen { armor = 17; hitpointName = "HitAbdomen"; passThrough = 0.3; };
				class Body { hitpointName = "HitBody"; passThrough = 0.3; };
				class Chest { armor = 17; hitpointName = "HitChest"; passThrough = 0.3; };
				class Diaphragm { armor = 17; hitpointName = "HitDiaphragm"; passThrough = 0.3; };
			};
		};
	};

	class rhs_6b2_chicom_GOL : UK3CB_V_Invisible_Plate {
		author = "3CB Factions edited by OksmanTV from Guerrillas of Liberation";
		displayName = "6B2 (Chicom)";
		descriptionShort = "Armor Level 4";
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\vests\rhs_6b2_chicom_ca.paa";
		model = "rhsafrf\addons\rhs_infantry3\gear\vests\rhs_6b2_chicom";
		class ItemInfo {
			_generalMacro = "VestItem";
			author = "Bohemia Interactive";
			containerClass = "Supply180";
			hiddenSelections[] = {};
			mass = 80;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			showHolsteredPistol = 0;
			type = 701;
			uniformModel = "rhsafrf\addons\rhs_infantry3\gear\vests\rhs_6b2_chicom";
			uniformType = "Default";
			class HitpointsProtectionInfo {
				class Abdomen { armor = 17; hitpointName = "HitAbdomen"; passThrough = 0.3; };
				class Body { hitpointName = "HitBody"; passThrough = 0.3; };
				class Chest { armor = 17; hitpointName = "HitChest"; passThrough = 0.3; };
				class Diaphragm { armor = 17; hitpointName = "HitDiaphragm"; passThrough = 0.3; };
			};
		};
	};

	class rhs_6b2_holster_GOL : UK3CB_V_Invisible_Plate {
		author = "3CB Factions edited by OksmanTV from Guerrillas of Liberation";
		displayName = "6B2 (Holster)";
		descriptionShort = "Armor Level 4";
		dlc = "RHS_AFRF";
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\vests\rhs_6b2_holster_ca.paa";
		model = "rhsafrf\addons\rhs_infantry3\gear\vests\rhs_6b2_holster";
		class ItemInfo {
			_generalMacro = "VestItem";
			author = "Bohemia Interactive";
			containerClass = "Supply180";
			hiddenSelections[] = {};
			mass = 80;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			showHolsteredPistol = 0;
			type = 701;
			uniformModel = "rhsafrf\addons\rhs_infantry3\gear\vests\rhs_6b2_holster";
			uniformType = "Default";
			class HitpointsProtectionInfo {
				class Abdomen { armor = 17; hitpointName = "HitAbdomen"; passThrough = 0.3; };
				class Body { hitpointName = "HitBody"; passThrough = 0.3; };
				class Chest { armor = 17; hitpointName = "HitChest"; passThrough = 0.3; };
				class Diaphragm { armor = 17; hitpointName = "HitDiaphragm"; passThrough = 0.3; };
			};
		};
	};

	class rhs_6b2_lifchik_GOL : UK3CB_V_Invisible_Plate {
		author = "3CB Factions edited by OksmanTV from Guerrillas of Liberation";
		displayName = "6B2 (Lifchik)";
		descriptionShort = "Armor Level 4";
		dlc = "RHS_AFRF";
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\vests\rhs_6b2_lifchik_ca.paa";
		model = "rhsafrf\addons\rhs_infantry3\gear\vests\rhs_6b2_lichifka";
		class ItemInfo {
			_generalMacro = "VestItem";
			author = "Bohemia Interactive";
			containerClass = "Supply180";
			hiddenSelections[] = {};
			mass = 80;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			showHolsteredPistol = 0;
			type = 701;
			uniformModel = "rhsafrf\addons\rhs_infantry3\gear\vests\rhs_6b2_lichifka";
			uniformType = "Default";
			class HitpointsProtectionInfo {
				class Abdomen { armor = 17; hitpointName = "HitAbdomen"; passThrough = 0.3; };
				class Body { hitpointName = "HitBody"; passThrough = 0.3; };
				class Chest { armor = 17; hitpointName = "HitChest"; passThrough = 0.3; };
				class Diaphragm { armor = 17; hitpointName = "HitDiaphragm"; passThrough = 0.3; };
			};
		};
	};

	class rhs_6b2_RPK_GOL : UK3CB_V_Invisible_Plate {
		author = "3CB Factions edited by OksmanTV from Guerrillas of Liberation";
		displayName = "6B2 (RPK)";
		descriptionShort = "Armor Level 4";
		dlc = "RHS_AFRF";		
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\vests\rhs_6b2_RPK_ca.paa";
		model = "rhsafrf\addons\rhs_infantry3\gear\vests\rhs_6b2_RPK";
		class ItemInfo {
			_generalMacro = "VestItem";
			author = "Bohemia Interactive";
			containerClass = "Supply180";
			hiddenSelections[] = {};
			mass = 80;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			showHolsteredPistol = 0;
			type = 701;
			uniformModel = "rhsafrf\addons\rhs_infantry3\gear\vests\rhs_6b2_RPK";
			uniformType = "Default";
			class HitpointsProtectionInfo {
				class Abdomen { armor = 17; hitpointName = "HitAbdomen"; passThrough = 0.3; };
				class Body { hitpointName = "HitBody"; passThrough = 0.3; };
				class Chest { armor = 17; hitpointName = "HitChest"; passThrough = 0.3; };
				class Diaphragm { armor = 17; hitpointName = "HitDiaphragm"; passThrough = 0.3; };
			};
		};
	};

	class rhs_6b2_SVD_GOL : UK3CB_V_Invisible_Plate {
		author = "3CB Factions edited by OksmanTV from Guerrillas of Liberation";
		displayName = "6B2 (Sniper)";
		descriptionShort = "Armor Level 4";
		dlc = "RHS_AFRF";
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\vests\rhs_6b2_SVD_ca.paa";
		model = "rhsafrf\addons\rhs_infantry3\gear\vests\rhs_6b2_SVD";
		class ItemInfo {
			_generalMacro = "VestItem";
			author = "Bohemia Interactive";
			containerClass = "Supply180";
			hiddenSelections[] = {};
			mass = 80;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			showHolsteredPistol = 0;
			type = 701;
			uniformModel = "rhsafrf\addons\rhs_infantry3\gear\vests\rhs_6b2_SVD";
			uniformType = "Default";
			class HitpointsProtectionInfo {
				class Abdomen { armor = 17; hitpointName = "HitAbdomen"; passThrough = 0.3; };
				class Body { hitpointName = "HitBody"; passThrough = 0.3; };
				class Chest { armor = 17; hitpointName = "HitChest"; passThrough = 0.3; };
				class Diaphragm { armor = 17; hitpointName = "HitDiaphragm"; passThrough = 0.3; };
			};
		};
	};

	class rhs_beret_vdv1;
	class rhs_beret_vdv2;
	class rhs_beret_vdv3;
	class rhs_beret_vdv1_GOL : rhs_beret_vdv1 {
		author = "RHS edited by OksmanTV from Guerrillas of Liberation";
		displayName = "Beret VDV (GOL)";
		hiddenSelectionsTextures[] = {"\rhsafrf\addons\rhs_infantry2\gear\head\data\rhs_vdv_beret_co.paa"};
		descriptionShort = "Armored Beret";
		dlc = "RHS_AFRF";
		model = "\rhsafrf\addons\rhs_infantry2\gear\head\rhs_vdv_beret";
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\headgear\rhs_beret_vdv1_ca.paa";
		class ItemInfo {
			_generalMacro = "HeadgearItem";
			author = "Bohemia Interactive";
			allowedSlots[] = {801,901,701,605};
			hiddenSelections[] = {"Camo1"};
			mass = 5;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			modelSides[] = {6};
			type = 605;
			uniformModel = "\rhsafrf\addons\rhs_infantry2\gear\head\rhs_vdv_beret";
			class HitpointsProtectionInfo {
				class Head { armor = 6; hitpointName = "HitHead"; passThrough = 0.3; };
			};
		};		
	};
	class rhs_beret_vdv2_GOL : rhs_beret_vdv2 {
		author = "RHS edited by OksmanTV from Guerrillas of Liberation";
		displayName = "Beret VDV (GOL)";
		hiddenSelectionsTextures[] = {"\rhsafrf\addons\rhs_infantry2\gear\head\data\rhs_vdv_beret2_co.paa"};
		descriptionShort = "Armored Beret";
		dlc = "RHS_AFRF";
		model = "\rhsafrf\addons\rhs_infantry2\gear\head\rhs_vdv_beret2";
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\headgear\rhs_beret_vdv2_ca.paa";
		class ItemInfo {
			_generalMacro = "HeadgearItem";
			author = "Bohemia Interactive";
			allowedSlots[] = {801,901,701,605};
			hiddenSelections[] = {"Camo1"};
			mass = 5;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			modelSides[] = {6};
			type = 605;
			uniformModel = "\rhsafrf\addons\rhs_infantry2\gear\head\rhs_vdv_beret2";
			class HitpointsProtectionInfo {
				class Head { armor = 6; hitpointName = "HitHead"; passThrough = 0.3; };
			};
		};		
	};
	class rhs_beret_vdv3_GOL : rhs_beret_vdv3 {
		author = "RHS edited by OksmanTV from Guerrillas of Liberation";
		displayName = "Beret VDV (GOL)";
		hiddenSelectionsTextures[] = {"\rhsafrf\addons\rhs_infantry2\gear\head\data\rhs_vdv_beret3_co.paa"};
		descriptionShort = "Armored Beret";
		dlc = "RHS_AFRF";
		model = "\rhsafrf\addons\rhs_infantry2\gear\head\rhs_milp_beret";
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\headgear\rhs_beret_vdv3_ca.paa";
		class ItemInfo {
			_generalMacro = "HeadgearItem";
			author = "Bohemia Interactive";
			allowedSlots[] = {801,901,701,605};
			hiddenSelections[] = {"Camo1"};
			mass = 25;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			modelSides[] = {6};
			type = 605;
			uniformModel = "\rhsafrf\addons\rhs_infantry2\gear\head\rhs_milp_beret";
			class HitpointsProtectionInfo {
				class Head { armor = 6; hitpointName = "HitHead"; passThrough = 0.3; };
			};
		};		
	};

	class rhs_ssh60;
	class rhs_ssh6_GOL : rhs_ssh60 {
		author = "RHS edited by OksmanTV from Guerrillas of Liberation";
		displayName = "SSh-60 Helmet (GOL)";
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\headgear\rhs_ssh60_ca.paa";
		model = "\rhsafrf\addons\rhs_infantry3\gear\head\rhs_SSH_60.p3d";
		class ItemInfo {
			_generalMacro = "HeadgearItem";
			author = "Bohemia Interactive";
			allowedSlots[] = {801,901,701,605};
			hiddenSelections[] = {"Camo"};
			mass = 25;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			uniformModel = "\rhsafrf\addons\rhs_infantry3\gear\head\rhs_SSH_60";
			modelSides[] = {6};
			type = 605;
			class HitpointsProtectionInfo {
				class Head { armor = 6; hitpointName = "HitHead"; passThrough = 0.3; };
			};
		};		
	};	

	class UK3CB_H_SSH60_Helmet_Covered_TAN;
	class UK3CB_H_SSH60_Helmet_Covered_TAN_GOL : UK3CB_H_SSH60_Helmet_Covered_TAN {
		author = "RHS edited by OksmanTV from Guerrillas of Liberation";
		displayName = "SSh-60 Helmet Tan (GOL)";
		picture = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment_CW\data\ui\icon_ssh60_covered_tan_ca.paa";
		model = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment_CW\helmet_soviet\uk3cb_ssh60_cover.p3d";
		hiddenSelections[] = {"camo","camo1"};
		hiddenSelectionsTextures[] = {"uk3cb_factions\addons\uk3cb_factions_equipment_cw\data\ssh60_oli_co.paa","uk3cb_factions\addons\uk3cb_factions_equipment_cw\data\ssh60_cover_tan_co.paa"};
		class ItemInfo {
			_generalMacro = "HeadgearItem";
			author = "Bohemia Interactive";
			allowedSlots[] = {801,901,701,605};
			hiddenSelections[] = {"camo","camo1"};
			mass = 25;
			scope = 0;
			modelSides[] = {3,1};
			type = 605;
			uniformModel = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment_CW\helmet_soviet\uk3cb_ssh60_cover.p3d";
			class HitpointsProtectionInfo {
				class Head { armor = 6; hitpointName = "HitHead"; passThrough = 0.3; };
			};
		};		
	};		
	
	class UK3CB_CW_US_B_LATE_H_PASGT_01_WDL;
	class UK3CB_CW_US_B_LATE_V_PASGT_Crew_Vest;
	class UK3CB_CW_US_B_LATE_V_PASGT_Medic_Vest;
	class UK3CB_CW_US_B_LATE_V_PASGT_MG_Vest;
	class UK3CB_CW_US_B_LATE_V_PASGT_Rif_Vest;
	class UK3CB_CW_US_B_LATE_V_PASGT_Crew_Vest_GOL : UK3CB_CW_US_B_LATE_V_PASGT_Crew_Vest {
		author = "3CB Factions edited by OksmanTV from Guerrillas of Liberation";
		displayName = "PASGT Crew Vest (GOL)";
		descriptionShort = "Armor Level 4";
		model = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment\vest\UK3CB_Pasgt_Crew.p3d";
		picture = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment\vest\data\pasgt\ui\gear_pasgt_crew_wdl_ca.paa";
		hiddenSelections[] = {"camo","camo1","camo2"};
		hiddenSelectionsTextures[] = {"\UK3CB_Factions\addons\UK3CB_Factions_CW_US\Blufor\data\cw_us_b_pasgt_wdl_02_co.paa","\uk3cb_factions\addons\uk3cb_factions_equipment\vest\data\pasgt\sf_gear_khaky_co.paa","\uk3cb_factions\addons\uk3cb_factions_equipment\vest\data\pasgt\webbing_p58_full_co.paa"};
		class ItemInfo {
			_generalMacro = "VestItem";
			author = "Bohemia Interactive";
			containerClass = "Supply180";
			hiddenSelections[] = {"camo","camo1","camo2"};
			mass = 80;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			showHolsteredPistol = 0;
			type = 701;
			uniformModel = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment\vest\UK3CB_Pasgt_Crew";
			uniformType = "Default";
			class HitpointsProtectionInfo {
				class Abdomen { armor = 17; hitpointName = "HitAbdomen"; passThrough = 0.3; };
				class Body { hitpointName = "HitBody"; passThrough = 0.3; };
				class Chest { armor = 17; hitpointName = "HitChest"; passThrough = 0.3; };
				class Diaphragm { armor = 17; hitpointName = "HitDiaphragm"; passThrough = 0.3; };
			};
		};
	};

	class UK3CB_CW_US_B_LATE_V_PASGT_Medic_Vest_GOL : UK3CB_CW_US_B_LATE_V_PASGT_Medic_Vest {
		author = "3CB Factions edited by OksmanTV from Guerrillas of Liberation";
		displayName = "PASGT Medic Vest (GOL)";
		descriptionShort = "Armor Level 4";
		model = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment\vest\UK3CB_Pasgt_Medic.p3d";
		picture = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment\vest\data\pasgt\ui\gear_pasgt_medic_wdl_ca.paa";
		hiddenSelections[] = {"camo","camo1","camo2"};
		hiddenSelectionsTextures[] = {"\UK3CB_Factions\addons\UK3CB_Factions_CW_US\Blufor\data\cw_us_b_pasgt_wdl_02_co.paa","\uk3cb_factions\addons\uk3cb_factions_equipment\vest\data\pasgt\sf_gear_khaky_co.paa","\uk3cb_factions\addons\uk3cb_factions_equipment\vest\data\pasgt\webbing_p58_full_co.paa"};		
		class ItemInfo {
			_generalMacro = "VestItem";
			author = "Bohemia Interactive";
			containerClass = "Supply180";
			hiddenSelections[] = {"camo","camo1","camo2"};
			mass = 80;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			showHolsteredPistol = 0;
			type = 701;
			uniformmodel = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment\vest\UK3CB_Pasgt_Medic";
			uniformType = "Default";
			class HitpointsProtectionInfo {
				class Abdomen { armor = 17; hitpointName = "HitAbdomen"; passThrough = 0.3; };
				class Body { hitpointName = "HitBody"; passThrough = 0.3; };
				class Chest { armor = 17; hitpointName = "HitChest"; passThrough = 0.3; };
				class Diaphragm { armor = 17; hitpointName = "HitDiaphragm"; passThrough = 0.3; };
			};
		};
	};
	class UK3CB_CW_US_B_LATE_V_PASGT_MG_Vest_GOL : UK3CB_CW_US_B_LATE_V_PASGT_MG_Vest {
		author = "3CB Factions edited by OksmanTV from Guerrillas of Liberation";
		displayName = "PASGT Machinegun Vest (GOL)";
		descriptionShort = "Armor Level 4";
		model = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment\vest\UK3CB_Pasgt_MG.p3d";
		picture = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment\vest\data\pasgt\ui\gear_pasgt_mg_wdl_ca.paa";
		hiddenSelections[] = {"camo","camo1","camo2"};
		hiddenSelectionsTextures[] = {"\UK3CB_Factions\addons\UK3CB_Factions_CW_US\Blufor\data\cw_us_b_pasgt_wdl_02_co.paa","\uk3cb_factions\addons\uk3cb_factions_equipment\vest\data\pasgt\sf_gear_khaky_co.paa","\uk3cb_factions\addons\uk3cb_factions_equipment\vest\data\pasgt\webbing_p58_full_co.paa"};
		class ItemInfo {
			_generalMacro = "VestItem";
			author = "Bohemia Interactive";
			containerClass = "Supply180";
			hiddenSelections[] = {"camo","camo1","camo2"};
			mass = 80;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			showHolsteredPistol = 0;
			type = 701;
			uniformModel = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment\vest\UK3CB_Pasgt_MG";
			uniformType = "Default";
			class HitpointsProtectionInfo {
				class Abdomen { armor = 17; hitpointName = "HitAbdomen"; passThrough = 0.3; };
				class Body { hitpointName = "HitBody"; passThrough = 0.3; };
				class Chest { armor = 17; hitpointName = "HitChest"; passThrough = 0.3; };
				class Diaphragm { armor = 17; hitpointName = "HitDiaphragm"; passThrough = 0.3; };
			};
		};
	};
	class UK3CB_CW_US_B_LATE_V_PASGT_Rif_Vest_GOL : UK3CB_CW_US_B_LATE_V_PASGT_Rif_Vest {
		author = "3CB Factions edited by OksmanTV from Guerrillas of Liberation";
		displayName = "PASGT Rifleman Vest (GOL)";
		descriptionShort = "Armor Level 4";
		model = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment\vest\UK3CB_Pasgt_Rif.p3d";
		picture = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment\vest\data\pasgt\ui\gear_pasgt_rif_wdl_ca.paa";
		hiddenSelections[] = {"camo","camo1","camo2"};
		hiddenSelectionsTextures[] = {"\UK3CB_Factions\addons\UK3CB_Factions_CW_US\Blufor\data\cw_us_b_pasgt_wdl_02_co.paa","\uk3cb_factions\addons\uk3cb_factions_equipment\vest\data\pasgt\sf_gear_khaky_co.paa","\uk3cb_factions\addons\uk3cb_factions_equipment\vest\data\pasgt\webbing_p58_full_co.paa"};
		class ItemInfo {
			_generalMacro = "VestItem";
			author = "Bohemia Interactive";
			containerClass = "Supply180";
			hiddenSelections[] = {"camo","camo1","camo2"};
			mass = 80;
			overlaySelectionsInfo[] = {"Ghillie_hide"};
			scope = 0;
			showHolsteredPistol = 0;
			type = 701;
			uniformModel = "\UK3CB_Factions\addons\UK3CB_Factions_Equipment\vest\UK3CB_Pasgt_Rif";
			uniformType = "Default";
			class HitpointsProtectionInfo {
				class Abdomen { armor = 17; hitpointName = "HitAbdomen"; passThrough = 0.3; };
				class Body { hitpointName = "HitBody"; passThrough = 0.3; };
				class Chest { armor = 17; hitpointName = "HitChest"; passThrough = 0.3; };
				class Diaphragm { armor = 17; hitpointName = "HitDiaphragm"; passThrough = 0.3; };
			};
		};
	};		
	
	class UK3CB_CW_US_B_LATE_H_PASGT_01_WDL_GOL : UK3CB_CW_US_B_LATE_H_PASGT_01_WDL {
		author = "RHS edited by OksmanTV from Guerrillas of Liberation";
		displayName = "PASGT Woodland (GOL)";
		model = "rhsgref\addons\rhsgref_infantry\gear_tanoa\head\pasgt_helmet";
		picture = "\UK3CB_Factions\addons\UK3CB_Factions_CW_US\Blufor\data\ui\icon_cw_us_h_pasgt_wdl_01_ca.paa";
		hiddenSelectionsTextures[] = {"\UK3CB_Factions\addons\UK3CB_Factions_CW_US\Blufor\data\cw_us_b_h_pasgt_wdl_01_co.paa"};
		class ItemInfo {
			_generalMacro = "HeadgearItem";
			author = "Bohemia Interactive";
			allowedSlots[] = {801,901,701,605};
			hiddenSelections[] = {"camo"};
			mass = 25;
			scope = 0;
			modelSides[] = {6};
			type = 605;
			uniformModel = "rhsgref\addons\rhsgref_infantry\gear_tanoa\head\pasgt_helmet";
			class HitpointsProtectionInfo {
				class Head { armor = 6; hitpointName = "HitHead"; passThrough = 0.3; };
			};
		};		
	};		

	// Drone jammer pistol (inspired by Contact DLC ESD)
	// Drone Disruptor Pistol - Kills drone crew via cone detection
	class Pistol_Base_F;
	class OKS_DroneDisruptor_Pistol: Pistol_Base_F {
		scope = 2;
		scopeArsenal = 2;
		scopeCurator = 2;
		author = "OksmanTV from Guerrillas of Liberation";
		displayName = "Drone Disruptor Pistol";
		descriptionShort = "Electromagnetic pulse weapon. Fires directed energy to disable drones within 200m cone.";
		
		// Visual model from Contact DLC ESD
		model = "\A3\Weapons_F_Enoch\Pistols\ESD_01\ESD_01_F.p3d";
		picture = "\a3\weapons_f_enoch\pistols\esd_01\data\ui\gear_esd_01_ca.paa";
		
		// Base weapon reference for attachments
		baseWeapon = "OKS_DroneDisruptor_Pistol";
		
		magazines[] = {"OKS_Mag_DroneDisruptor"};
		
		// Force crosshair to show (weapon has no iron sights)
		showAimCursorInternal = 1;
		
		// Disable all attachment slots except muzzle
		class WeaponSlotsInfo {
			mass = 20;
			
			// Only allow custom antenna in muzzle slot
			class MuzzleSlot {
				linkProxy = "\A3\data_f\proxies\weapon_slots\MUZZLE";
				compatibleItems[] = {"OKS_Disruptor_Antenna"};
				iconPosition[] = {0, 0.4};
				iconScale = 0.2;
			};
			
			// Disable all other slots
			class CowsSlot {};
			class PointerSlot {};
			class UnderBarrelSlot {};
		};
		
		// Override inherited multi-muzzle system - this is a single muzzle weapon
		Muzzle_Base[] = {};
		muzzle_1[] = {};
		muzzle_2[] = {};
		muzzle_3[] = {};
		muzzle_4[] = {};
		muzzle_5[] = {};
		muzzle_6[] = {};
		muzzle_7[] = {};
		muzzle_8[] = {};
		muzzle_9[] = {};
		muzzle_10[] = {};
		muzzle_11[] = {};
		muzzle_12[] = {};
		bullet1[] = {};
		bullet2[] = {};
		bullet3[] = {};
		bullet4[] = {};
		bullet5[] = {};
		bullet6[] = {};
		bullet7[] = {};
		bullet8[] = {};
		bullet9[] = {};
		bullet10[] = {};
		bullet11[] = {};
		bullet12[] = {};		
		muzzles[] = {"this"};
		reloadAction = "GestureReloadPistolHeavy02";
		
		// Override muzzle effects - energy weapon has no visible muzzle flash or smoke
		class GunClouds {
			access = 0;
			cloudletDuration = 0;
			cloudletAnimPeriod = 0;
			cloudletSize = 0;
			cloudletAlpha = 0;
			cloudletGrowUp = 0;
			cloudletFadeIn = 0;
			cloudletFadeOut = 0;
			cloudletAccY = 0;
			cloudletMinYSpeed = 0;
			cloudletMaxYSpeed = 0;
			cloudletShape = "";
			cloudletColor[] = {0, 0, 0, 0};
			interval = 0;
			size = 0;
			sourceSize = 0;
			initT = 0;
			deltaT = 0;
			class Table {};
		};
		class GunFire {
			access = 0;
			cloudletDuration = 0;
			cloudletAnimPeriod = 0;
			cloudletSize = 0;
			cloudletAlpha = 0;
			cloudletGrowUp = 0;
			cloudletFadeIn = 0;
			cloudletFadeOut = 0;
			cloudletAccY = 0;
			cloudletMinYSpeed = 0;
			cloudletMaxYSpeed = 0;
			cloudletShape = "";
			cloudletColor[] = {0, 0, 0, 0};
			interval = 0;
			size = 0;
			sourceSize = 0;
			initT = 0;
			deltaT = 0;
			class Table {};
		};
		class GunParticles {};
		
		// Remove shell casing ejection - energy weapon has no physical casings
		magazineReloadSwitchPhase = 0;
		drySound[] = {"", 1, 1};
		reloadMagazineSound[] = {"", 1, 1};
		
		// Override inherited bullet impact sounds (bullet1-bullet12)
		soundHit1[] = {"", 1, 1};
		soundHit2[] = {"", 1, 1};
		soundHit3[] = {"", 1, 1};
		soundHit4[] = {"", 1, 1};
		soundHit5[] = {"", 1, 1};
		soundHit6[] = {"", 1, 1};
		soundHit7[] = {"", 1, 1};
		soundHit8[] = {"", 1, 1};
		soundHit9[] = {"", 1, 1};
		soundHit10[] = {"", 1, 1};
		soundHit11[] = {"", 1, 1};
		soundHit12[] = {"", 1, 1};		
		
		modes[] = {"Single"};
		class Single {
			displayName = "Single";
			textureType = "semi";
			burst = 1;
			reloadTime = 2.0;
			dispersion = 0.001;
			multiplier = 1;
			autoFire = 0;
			soundContinuous = 0;
			soundBurst = 0;
			useAction = 0;
			useActionTitle = "";
			showToPlayer = 1;
			artilleryDispersion = 0;
			artilleryCharge = 0;
			minRange = 2;
			minRangeProbab = 0.3;
			midRange = 100;
			midRangeProbab = 0.7;
			maxRange = 200;
			maxRangeProbab = 0.05;
			aiRateOfFire = 2;
			aiRateOfFireDistance = 100;
			recoil = "recoil_pistol_light";
			recoilProne = "recoil_prone_pistol_light";
			// Override inherited bullet impact sounds - energy weapon has no physical impact
			soundBullet[] = {};
			
			sounds[] = {"StandardSound"};
			class StandardSound {
				// Custom EMP weapon firing sound
				// Place your .ogg file at: OKS_GOL_Misc\Sounds\disruptor_fire.ogg
				begin1[] = {"\OKS_GOL_Misc\Sounds\disruptor_fire.ogg", 1.5, 1, 500};
				soundBegin[] = {"begin1", 1};
				weaponSoundEffect = "";
			};
		};
		
		class EventHandlers {
			fired = "_this call OKS_fnc_DroneDisruptor_Fired;";
		};
	};

	// Custom antenna attachment for disruptor (cosmetic only, no sound suppression)
	class InventoryMuzzleItem_Base_F;
	class muzzle_antenna_02_f;
	class OKS_Disruptor_Antenna: muzzle_antenna_02_f {
		scope = 2;
		scopeArsenal = 2;
		author = "OksmanTV from Guerrillas of Liberation";
		displayName = "Long-Range EMP Antenna (+250m)";
		descriptionShort = "Extends disruptor effective range by 250m. Total range: 750m.";
		
		// Override suppressor behavior - this is purely cosmetic
		class ItemInfo: InventoryMuzzleItem_Base_F {
			mass = 2;
			soundTypeIndex = 0;
			muzzleEnd = "zaslehPoint";
			alternativeFire = "Zasleh2";
			class MagazineCoef {
				initSpeed = 1.0;
			};
			class AmmoCoef {
				hit = 1.0;
				visibleFire = 1.0;
				audibleFire = 1.0;
				visibleFireTime = 1.0;
				audibleFireTime = 1.0;
				cost = 1.0;
				typicalSpeed = 1.0;
				airFriction = 1.0;
			};
			class MuzzleCoef {
				dispersionCoef = 1.0;
				artilleryDispersionCoef = 1.0;
				fireLightCoef = 1.0;
				recoilCoef = 1.0;
				recoilProneCoef = 1.0;
				minRangeCoef = 1.0;
				minRangeProbabCoef = 1.0;
				midRangeCoef = 1.0;
				midRangeProbabCoef = 1.0;
				maxRangeCoef = 1.0;
				maxRangeProbabCoef = 1.0;
			};
		};
	};

	// Custom MMG variants with reduced recoil and custom magazines
	class MMG_01_tan_F;
	class MMG_01_hex_F;

	class GOL_MMG_01_tan_F: MMG_01_tan_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "HK121 9.3 mm (Tan/GOL)";
		baseWeapon = "GOL_MMG_01_tan_F";
		
		// Custom recoil presets
		recoil = "UK3CB_BAF_recoil_saw_762";
		recoilProne = "assaultRifleBase";
		
		// Clear linkedItems to show in arsenal
		linkedItems[] = {};
		
		// Custom magazines with tracer variety
		magazines[] = {
			"GOL_150Rnd_93x64_Mag",
			"GOL_150Rnd_93x64_Mag_Tracer",
			"GOL_150Rnd_93x64_Mag_Tracer_Red",
			"GOL_150Rnd_93x64_Mag_Tracer_Green",
			"GOL_150Rnd_93x64_Mag_Tracer_Yellow",
			// Vanilla compatibility
			"150Rnd_93x64_Mag"
		};
	};

	class GOL_MMG_01_hex_F: MMG_01_hex_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "HK121 9.3 mm (Hex/GOL)";
		baseWeapon = "GOL_MMG_01_hex_F";
		
		// Custom recoil presets
		recoil = "UK3CB_BAF_recoil_saw_762";
		recoilProne = "assaultRifleBase";
		
		// Clear linkedItems to show in arsenal
		linkedItems[] = {};
		
		magazines[] = {
			"GOL_150Rnd_93x64_Mag",
			"GOL_150Rnd_93x64_Mag_Tracer",
			"GOL_150Rnd_93x64_Mag_Tracer_Red",
			"GOL_150Rnd_93x64_Mag_Tracer_Green",
			"GOL_150Rnd_93x64_Mag_Tracer_Yellow",
			"150Rnd_93x64_Mag"
		};
	};

	// RHS PKM/PKP variants with red tracers
	class rhs_weap_pkm;
	class rhs_weap_pkp;

	class GOL_weap_pkm: rhs_weap_pkm {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "PKM (GOL)";
		baseWeapon = "GOL_weap_pkm";
		
		recoil = "UK3CB_BAF_recoil_saw_762";
		recoilProne = "assaultRifleBase";
		
		magazines[] = {
			"GOL_100Rnd_762x54mmR",
			"GOL_100Rnd_762x54mmR_red",
			"GOL_100Rnd_762x54mmR_green",
			// Vanilla compatibility
			"rhs_100Rnd_762x54mmR",
			"rhs_100Rnd_762x54mmR_green"
		};
	};

	class GOL_weap_pkp: rhs_weap_pkp {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "PKP (GOL)";
		baseWeapon = "GOL_weap_pkp";
		
		recoil = "UK3CB_BAF_recoil_saw_762";
		recoilProne = "assaultRifleBase";
		
		magazines[] = {
			"GOL_100Rnd_762x54mmR",
			"GOL_100Rnd_762x54mmR_red",
			"GOL_100Rnd_762x54mmR_green",
			"rhs_100Rnd_762x54mmR",
			"rhs_100Rnd_762x54mmR_green"
		};
	};

	// MMG_02 SPMG variants (.338)
	class MMG_02_black_F;
	class MMG_02_camo_F;
	class MMG_02_sand_F;

	class GOL_MMG_02_black_F: MMG_02_black_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "LWMMG .338 (Black/GOL)";
		baseWeapon = "GOL_MMG_02_black_F";
		
		recoil = "UK3CB_BAF_recoil_saw_762";
		recoilProne = "assaultRifleBase";
		
		magazines[] = {
			"GOL_130Rnd_338_Mag",
			"GOL_130Rnd_338_Mag_red",
			"GOL_130Rnd_338_Mag_green",
			// Vanilla compatibility
			"130Rnd_338_Mag"
		};
	};

	class GOL_MMG_02_camo_F: MMG_02_camo_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "LWMMG .338 (Camo/GOL)";
		baseWeapon = "GOL_MMG_02_camo_F";
		
		recoil = "UK3CB_BAF_recoil_saw_762";
		recoilProne = "assaultRifleBase";
		
		magazines[] = {
			"GOL_130Rnd_338_Mag",
			"GOL_130Rnd_338_Mag_red",
			"GOL_130Rnd_338_Mag_green",
			"130Rnd_338_Mag"
		};
	};

	class GOL_MMG_02_sand_F: MMG_02_sand_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "LWMMG .338 (Sand/GOL)";
		baseWeapon = "GOL_MMG_02_sand_F";
		
		recoil = "UK3CB_BAF_recoil_saw_762";
		recoilProne = "assaultRifleBase";
		
		magazines[] = {
			"GOL_130Rnd_338_Mag",
			"GOL_130Rnd_338_Mag_red",
			"GOL_130Rnd_338_Mag_green",
			"130Rnd_338_Mag"
		};
	};

	// LMG_Zafir_F and other weapons that don't need new mags
	class LMG_Zafir_F;
	class rhs_weap_fnmag;
	class UK3CB_MG3_KWS_B;

	class GOL_LMG_Zafir_F: LMG_Zafir_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "Zafir 7.62mm (GOL)";
		baseWeapon = "GOL_LMG_Zafir_F";
		
		recoil = "UK3CB_BAF_recoil_saw_762";
		recoilProne = "assaultRifleBase";
	};

	class GOL_weap_fnmag: rhs_weap_fnmag {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "FN MAG (GOL)";
		baseWeapon = "GOL_weap_fnmag";
		
		recoil = "UK3CB_BAF_recoil_saw_762";
		recoilProne = "assaultRifleBase";
	};

	class GOL_MG3_KWS_B: UK3CB_MG3_KWS_B {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "MG3 KWS (GOL)";
		baseWeapon = "GOL_MG3_KWS_B";
		
		recoil = "UK3CB_BAF_recoil_saw_762";
		recoilProne = "assaultRifleBase";
	};

// FPV throwables (soft dependency on BOT_FPV_Enhanced)
class GrenadeLauncher;
class Throw: GrenadeLauncher {
		Muzzles[] += {"GOL_Weapon_FPV_AT_Throw","GOL_Weapon_FPV_AP_Throw","GOL_Weapon_FPV_AP_OG7V_Throw","GOL_Weapon_FPV_AP_IED_Throw"};
		class ThrowMuzzle: GrenadeLauncher {};

		class GOL_Weapon_FPV_base: ThrowMuzzle {};
		class GOL_Weapon_FPV_AT_Throw: GOL_Weapon_FPV_base {
			magazines[] = {"GOL_Mag_FPV_AT_Throw"};
		};
		class GOL_Weapon_FPV_AP_Throw: GOL_Weapon_FPV_base {
			magazines[] = {"GOL_Mag_FPV_AP_Throw"};
		};
		class GOL_Weapon_FPV_AP_OG7V_Throw: GOL_Weapon_FPV_base {
			magazines[] = {"GOL_Mag_FPV_AP_OG7V_Throw"};
		};
		class GOL_Weapon_FPV_AP_IED_Throw: GOL_Weapon_FPV_base {
			magazines[] = {"GOL_Mag_FPV_AP_IED_Throw"};
		};
	};

	// AP45 Compatibility patches
	// NOTE: UK3CB Factions (ACR/M16/G36/AUG) and JCA rifles are handled
	// via CfgMagazineWells — no per-weapon patching needed for those.
	#include "compat\compat_vanilla.hpp"
	#include "compat\compat_rhs.hpp"
	#include "compat\compat_uk3cb.hpp"
	#include "compat\compat_uk3cb_factions.hpp"
};