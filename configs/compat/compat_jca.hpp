// JCA (Jujubean's Community Arsenal) Compatibility
// Adds AP45 magazines to JCA 5.56mm rifles

// M4A1 series - all standard, GL, and short variants (5.56x45mm)
class JCA_arifle_M4A1_base_F
{
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};

// M4A4 series - AFG, VFG, and GL variants (5.56x45mm)
class JCA_arifle_M4A4_base_F
{
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};

// M16A4 series - all standard, FG, and GL variants (5.56x45mm)
class JCA_arifle_M16A4_base_F
{
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};

// HK433 series - standard and short variants (5.56x45mm)
class JCA_arifle_HK433_base_F
{
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};

// ============================================================
// Sand variants — ALL JCA sand variants hard-override magazines[]
// with = (replacing default mag with sand-colored cosmetic mag).
// This wipes any inherited += from the base class above.
// Declare WITHOUT parent to avoid duplicates from chain stacking.
// ============================================================

// M4A1 sand (parent: JCA_arifle_M4A1_base_F — already patched above)
class JCA_arifle_M4A1_sand_F {
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};

// M4A1 GL has its own base class we haven't patched — patch sand directly
class JCA_arifle_M4A1_GL_sand_F {
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};

// M4A1 short has its own base class — patch sand directly
class JCA_arifle_M4A1_short_sand_F {
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};

// M4A4 sand variants (AFG, VFG, GL — all hard-override magazines[])
class JCA_arifle_M4A4_AFG_sand_F {
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};

class JCA_arifle_M4A4_VFG_sand_F {
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};

class JCA_arifle_M4A4_GL_sand_F {
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};

// M16A4 sand variants
class JCA_arifle_M16A4_sand_F {
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};

class JCA_arifle_M16A4_GL_sand_F {
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};

class JCA_arifle_M16A4_FG_sand_F {
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};

// HK433 sand variants
class JCA_arifle_HK433_sand_F {
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};

class JCA_arifle_HK433_short_sand_F {
	magazines[] += {
		"GOL_30Rnd_556x45_AP45",
		"GOL_30Rnd_556x45_AP45_Tracer_Red",
		"GOL_30Rnd_556x45_AP45_Tracer_Green",
		"GOL_30Rnd_556x45_AP45_Tracer_Yellow"
	};
};
// ===== JCA HK437 — 5.56mm conversion =====
// Changes caliber from .300 BLK to 5.56x45mm NATO.
// initSpeed = 910 m/s, dispersion matches HK433 (0.0005), maxZeroing = 800.
// Fire modes are NOT overridden — all JCA Single/FullAuto properties (sounds, recoil,
// AI ranges, burst, autoFire, reloadTime) are fully inherited from the JCA parent.
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