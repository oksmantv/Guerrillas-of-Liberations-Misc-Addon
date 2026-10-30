// Enhanced diver equipment. Custom variants make the upgrades independently
// selectable and prevent later addon patches from replacing their values.

#ifdef GOL_GEAR_CFGWEAPONS
	class VestItem;
	class UniformItem;

	class V_RebreatherIA;
	class GOL_V_RebreatherIA: V_RebreatherIA {
		scope = 2;
		scopeArsenal = 2;
		displayName = "Rebreather [GOL]";
		descriptionShort = "Armor Level III";

		class ItemInfo: VestItem {
			uniformModel = "\A3\Characters_F\Common\equip_rebreather";
			vestType = "Rebreather";
			containerClass = "Supply180";
			mass = 80;
			hiddenSelections[] = {"camo"};

			class HitpointsProtectionInfo {
				class Chest {
					hitpointName = "HitChest";
					armor = 16;
					passThrough = 0.3;
				};
				class Diaphragm {
					hitpointName = "HitDiaphragm";
					armor = 16;
					passThrough = 0.3;
				};
				class Abdomen {
					hitpointName = "HitAbdomen";
					armor = 16;
					passThrough = 0.3;
				};
				class Pelvis {
					hitpointName = "HitPelvis";
					armor = 8;
					passThrough = 0.3;
				};
				class Body {
					hitpointName = "HitBody";
					passThrough = 0.3;
				};
			};
		};
	};

	class V_RebreatherIR;
	class GOL_V_RebreatherIR: V_RebreatherIR {
		scope = 2;
		scopeArsenal = 2;
		displayName = "Rebreather [GOL]";
		descriptionShort = "Armor Level III";

		class ItemInfo: VestItem {
			uniformModel = "\A3\Characters_F\Common\equip_rebreather";
			vestType = "Rebreather";
			containerClass = "Supply180";
			mass = 80;
			hiddenSelections[] = {"camo"};

			class HitpointsProtectionInfo {
				class Chest { hitpointName = "HitChest"; armor = 16; passThrough = 0.3; };
				class Diaphragm { hitpointName = "HitDiaphragm"; armor = 16; passThrough = 0.3; };
				class Abdomen { hitpointName = "HitAbdomen"; armor = 16; passThrough = 0.3; };
				class Pelvis { hitpointName = "HitPelvis"; armor = 8; passThrough = 0.3; };
				class Body { hitpointName = "HitBody"; passThrough = 0.3; };
			};
		};
	};

	class V_RebreatherB;
	class GOL_V_RebreatherB: V_RebreatherB {
		scope = 2;
		scopeArsenal = 2;
		displayName = "Rebreather [GOL]";
		descriptionShort = "Armor Level III";

		class ItemInfo: VestItem {
			uniformModel = "\A3\Characters_F\Common\equip_rebreather";
			vestType = "Rebreather";
			containerClass = "Supply180";
			mass = 80;
			hiddenSelections[] = {"camo"};

			class HitpointsProtectionInfo {
				class Chest { hitpointName = "HitChest"; armor = 16; passThrough = 0.3; };
				class Diaphragm { hitpointName = "HitDiaphragm"; armor = 16; passThrough = 0.3; };
				class Abdomen { hitpointName = "HitAbdomen"; armor = 16; passThrough = 0.3; };
				class Pelvis { hitpointName = "HitPelvis"; armor = 8; passThrough = 0.3; };
				class Body { hitpointName = "HitBody"; passThrough = 0.3; };
			};
		};
	};

	class U_I_Wetsuit;
	class GOL_U_I_Wetsuit: U_I_Wetsuit {
		scope = 2;
		scopeArsenal = 2;
		displayName = "Wetsuit [GOL]";
		descriptionShort = "Armor Level III";

		class ItemInfo: UniformItem {
			uniformModel = "-";
			uniformClass = "I_diver_F";
			containerClass = "Supply120";
			uniformType = "Neopren";
			mass = 60;
		};
	};

	class U_B_Wetsuit;
	class GOL_U_B_Wetsuit: U_B_Wetsuit {
		scope = 2;
		scopeArsenal = 2;
		displayName = "Wetsuit [GOL]";
		descriptionShort = "Armor Level III";

		class ItemInfo: UniformItem {
			uniformModel = "-";
			uniformClass = "B_diver_F";
			containerClass = "Supply120";
			uniformType = "Neopren";
			mass = 60;
		};
	};

	class U_O_Wetsuit;
	class GOL_U_O_Wetsuit: U_O_Wetsuit {
		scope = 2;
		scopeArsenal = 2;
		displayName = "Wetsuit [GOL]";
		descriptionShort = "Armor Level III";

		class ItemInfo: UniformItem {
			uniformModel = "-";
			uniformClass = "O_diver_F";
			containerClass = "Supply120";
			uniformType = "Neopren";
			mass = 60;
		};
	};
#endif

#ifdef GOL_GEAR_CFGGLASSES
class CfgGlasses {
	class G_B_Diving;
	class GOL_G_B_Diving: G_B_Diving {
		scope = 2;
		scopeArsenal = 2;
		displayName = "Diving Goggles [GOL]";
	};

	class G_O_Diving;
	class GOL_G_O_Diving: G_O_Diving {
		scope = 2;
		scopeArsenal = 2;
		displayName = "Diving Goggles [GOL]";
	};

	class G_I_Diving;
	class GOL_G_I_Diving: G_I_Diving {
		scope = 2;
		scopeArsenal = 2;
		displayName = "Diving Goggles [GOL]";
	};
};
#endif

