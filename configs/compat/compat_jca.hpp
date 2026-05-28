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