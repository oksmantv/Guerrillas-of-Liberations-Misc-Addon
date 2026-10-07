// JCA (Jujubean's Community Arsenal) Compatibility
//
// AP45 magazine compatibility is handled via CfgMagazineWells (STANAG_556x45).
// All JCA 5.56mm weapons inherit that well and automatically accept AP45 mags.
// No per-class magazines[] patches are needed or safe here — patching JCA base
// classes without specifying their parent resets them to empty in binarized PBOs,
// breaking every subclass that inherits from them.

// ===== JCA HK437 — 5.56mm conversion =====
// Changes caliber from .300 BLK to 5.56x45mm NATO.
// initSpeed = 910 m/s, dispersion matches HK433 (0.0005), maxZeroing = 800.
// Fire modes are NOT overridden — all JCA Single/FullAuto properties (sounds, recoil,
// AI ranges, burst, autoFire, reloadTime) are fully inherited from the JCA parent.
// Forward declarations are required so the config parser can resolve the parent
// class name within this CfgWeapons scope. A bare declaration (no body, no parent
// override) does NOT reset the JCA class — it just tells the parser the name exists.
// This file should only be included when JCA is loaded.
class JCA_arifle_HK437_VFG_black_F;
class JCA_arifle_HK437_AFG_black_F;
class Rifle_Short_Base_F;
class JCA_muzzle_snds_9MM_enhanced_black;
class hgun_P07_F;
class hgun_Rook40_F;
class pdw2000_base_F;
class SMG_02_base_F;
class hgun_P18_F;
class hgun_MP453_F;

// Retains the JCA Enhanced 9 mm Suppressor's black model and attachment
// geometry while using significantly lower visual and AI-audible fire values.
class GOL_muzzle_snds_9MM_ghost_black: JCA_muzzle_snds_9MM_enhanced_black {
	scope = 2;
	scopeArsenal = 2;
	scopeCurator = 2;
	author = "Guerrillas of Liberation";
	type = 131072;
	weaponPoolAvailable = 1;
	displayName = "Ghost Sound Suppressor (9 mm, Black)";
	displayNameShort = "Ghost 9 mm";
	descriptionShort = "Extremely effective 9 mm suppressor. Optimized for subsonic ammunition.";
	model = "\weapons_f_JCA_IA\Acc\acca_snds_9mm_enhanced_black_F.p3d";
	picture = "\weapons_f_JCA_IA\Acc\data\UI\icon_muzzle_snds_9mm_enhanced_black_CA.paa";

	class ItemInfo: InventoryMuzzleItem_Base_F {
		mass = 5;
		type = 101;
		soundTypeIndex = 1;
		muzzleEnd = "zaslehPoint";
		alternativeFire = "Zasleh2";
		class MagazineCoef {
			initSpeed = 1.0;
		};
		class AmmoCoef {
			hit = 1.0;
			visibleFire = 0.05;
			audibleFire = 0.02;
			visibleFireTime = 0.1;
			audibleFireTime = 0.1;
			cost = 1.0;
			typicalSpeed = 1.0;
			airFriction = 1.0;
		};
		class MuzzleCoef {
			dispersionCoef = 0.8;
			artilleryDispersionCoef = 1.0;
			fireLightCoef = 0.05;
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

// Confirmed from the runtime config dump: these weapons use the listed
// magazine bases. Add the subsonic variants and Ghost Suppressor explicitly.
class JCA_hgun_G17_base_F: Pistol_Base_F {
	magazines[] += {"GOL_17Rnd_9x19_G17_Subsonic_Mag"};
	class WeaponSlotsInfo {
		class MuzzleSlot {
			compatibleItems[] += {"GOL_muzzle_snds_9MM_ghost_black"};
		};
	};
};

// The colour variants are pre-binarized JCA classes with their own effective
// magazines[] arrays, so each must receive the Ghost magazine explicitly.
class JCA_hgun_G17_black_F: JCA_hgun_G17_base_F {
	magazines[] += {"GOL_17Rnd_9x19_G17_Subsonic_Mag"};
};

class JCA_hgun_G17_sand_F: JCA_hgun_G17_base_F {
	magazines[] += {"GOL_17Rnd_9x19_G17_Subsonic_Mag"};
};

class JCA_hgun_G17_olive_F: JCA_hgun_G17_base_F {
	magazines[] += {"GOL_17Rnd_9x19_G17_Subsonic_Mag"};
};

class JCA_smg_MP5_base_F: Rifle_Short_Base_F {
	magazines[] += {"GOL_30Rnd_9x19_MP5_Subsonic_Mag"};
	class WeaponSlotsInfo {
		class MuzzleSlot {
			compatibleItems[] += {"GOL_muzzle_snds_9MM_ghost_black"};
		};
	};
};

class hgun_P07_F {
	magazines[] += {"GOL_30Rnd_9x21_Subsonic_Mag"};
	class WeaponSlotsInfo {
		class MuzzleSlot {
			compatibleItems[] += {"GOL_muzzle_snds_9MM_ghost_black"};
		};
	};
};

class hgun_Rook40_F {
	magazines[] += {"GOL_30Rnd_9x21_Subsonic_Mag"};
	class WeaponSlotsInfo {
		class MuzzleSlot {
			compatibleItems[] += {"GOL_muzzle_snds_9MM_ghost_black"};
		};
	};
};

class pdw2000_base_F {
	magazines[] += {"GOL_30Rnd_9x21_Subsonic_Mag"};
	class WeaponSlotsInfo {
		class MuzzleSlot {
			compatibleItems[] += {"GOL_muzzle_snds_9MM_ghost_black"};
		};
	};
};

class SMG_02_base_F {
	magazines[] += {"GOL_30Rnd_9x21_Subsonic_Mag"};
	class WeaponSlotsInfo {
		class MuzzleSlot {
			compatibleItems[] += {"GOL_muzzle_snds_9MM_ghost_black"};
		};
	};
};

class hgun_P18_F {
	magazines[] += {"GOL_30Rnd_9x21_Subsonic_Mag"};
	class WeaponSlotsInfo {
		class MuzzleSlot {
			compatibleItems[] += {"GOL_muzzle_snds_9MM_ghost_black"};
		};
	};
};

class hgun_MP453_F {
	magazines[] += {"GOL_30Rnd_9x21_Subsonic_Mag"};
	class WeaponSlotsInfo {
		class MuzzleSlot {
			compatibleItems[] += {"GOL_muzzle_snds_9MM_ghost_black"};
		};
	};
};

	class GOL_arifle_HK437_VFG_black_F: JCA_arifle_HK437_VFG_black_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "HK437 5.56 VFG Black (GOL)";
		descriptionShort = "HK437 converted to 5.56x45mm NATO. Ballistics match HK433.";
		baseWeapon = "GOL_arifle_HK437_VFG_black_F";
		initSpeed = 910;
		maxZeroing = 800;
		dispersion = 0.0005;
		magazineWell[] = {"STANAG_556x45"};
		magazines[] = {"30Rnd_556x45_Stanag"};
	};

	class GOL_arifle_HK437_AFG_black_F: JCA_arifle_HK437_AFG_black_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "HK437 5.56 AFG Black (GOL)";
		descriptionShort = "HK437 converted to 5.56x45mm NATO. Ballistics match HK433.";
		baseWeapon = "GOL_arifle_HK437_AFG_black_F";
		initSpeed = 910;
		maxZeroing = 800;
		dispersion = 0.0005;
		magazineWell[] = {"STANAG_556x45"};
		magazines[] = {"30Rnd_556x45_Stanag"};
	};