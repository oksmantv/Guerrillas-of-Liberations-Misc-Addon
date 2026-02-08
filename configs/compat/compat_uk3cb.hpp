// UK3CB BAF weapons compatibility for AP45 magazines
//
// PATTERN: Each patched class MUST specify its correct parent class
// to preserve Arma's inheritance chain. Forward-declare parent classes
// so the config parser knows they exist before we reference them.
//
// CROSS-PBO INHERITANCE:
//   Binarized PBOs freeze inheritance at binarize time.
//   Changes to a parent class do NOT propagate to children in
//   OTHER pre-binarized PBOs.
//   We must patch the ROOT of each PBO's chain explicitly.
//   Children within the same PBO inherit from the patched root
//   automatically — do NOT patch both parent and child (stacking).
//
// REBUILD HAZARD:
//   Re-opening a class with `: Parent` when Parent is also FULLY
//   re-opened (with a body) in the same addon causes Arma to
//   REBUILD the child from our modified parent, losing the original
//   PBO's properties. Parents must be FORWARD-DECLARED ONLY.

// Forward declarations for parent classes
class arifle_Mk20_plain_F;
class UK3CB_BAF_L119_Base;
class UK3CB_BAF_L110_556_Base;

// ============================================================
// L85A2 (5.56mm) — root of SmallArms PBO chain
// Re-open with correct parent to append AP45 mags.
// arifle_Mk20_plain_F is ONLY forward-declared in our addon
// (intentionally NOT patched in compat_vanilla.hpp) so that
// this re-open merges with the existing L85A2 rather than
// rebuilding it from a modified parent.
// All L85A2 variants, L86, and L22 in the same PBO inherit.
// ============================================================
class UK3CB_BAF_L85A2: arifle_Mk20_plain_F {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

// ============================================================
// L85A3 (5.56mm) — in UK3CB_BAF_Weapons_L85A3 PBO
// L85A3 does NOT override magazines[] — it inherits from L85A2.
// Because L85A3's PBO does not bake a flat magazines[] = {...},
// it reads from L85A2 at load time. Our modification to L85A2
// above should flow through automatically.
// DO NOT re-open L85A3 here: specifying `: UK3CB_BAF_L85A2`
// would trigger a rebuild (since L85A2 has a body above),
// stripping L85A3's original properties from its binarized PBO.
// ============================================================

// ============================================================
// L119A1 (Colt Canada C8, 5.56mm)
// Source PBO: UK3CB_BAF_Weapons_L119
// ============================================================
class UK3CB_BAF_L119A1: UK3CB_BAF_L119_Base {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class UK3CB_BAF_L119A1_CQB: UK3CB_BAF_L119_Base {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class UK3CB_BAF_L119A1_RIS: UK3CB_BAF_L119_Base {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class UK3CB_BAF_L119A1_UKUGL: UK3CB_BAF_L119_Base {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

// ============================================================
// L110 Minimi (5.56mm belt-fed)
// Source PBO: UK3CB_BAF_Weapons_L110
// ============================================================
class UK3CB_BAF_L110A1: UK3CB_BAF_L110_556_Base {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
        "GOL_UK3CB_BAF_556_200Rnd_AP45",
        "GOL_UK3CB_BAF_556_200Rnd_AP45_T_Red",
        "GOL_UK3CB_BAF_556_200Rnd_AP45_T_Green",
        "GOL_UK3CB_BAF_556_200Rnd_AP45_T_Yellow"
    };
};

class UK3CB_BAF_L110A2: UK3CB_BAF_L110_556_Base {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
        "GOL_UK3CB_BAF_556_200Rnd_AP45",
        "GOL_UK3CB_BAF_556_200Rnd_AP45_T_Red",
        "GOL_UK3CB_BAF_556_200Rnd_AP45_T_Green",
        "GOL_UK3CB_BAF_556_200Rnd_AP45_T_Yellow"
    };
};

class UK3CB_BAF_L110A2RIS: UK3CB_BAF_L110_556_Base {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
        "GOL_UK3CB_BAF_556_200Rnd_AP45",
        "GOL_UK3CB_BAF_556_200Rnd_AP45_T_Red",
        "GOL_UK3CB_BAF_556_200Rnd_AP45_T_Green",
        "GOL_UK3CB_BAF_556_200Rnd_AP45_T_Yellow"
    };
};

class UK3CB_BAF_L110A3: UK3CB_BAF_L110_556_Base {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
        "GOL_UK3CB_BAF_556_200Rnd_AP45",
        "GOL_UK3CB_BAF_556_200Rnd_AP45_T_Red",
        "GOL_UK3CB_BAF_556_200Rnd_AP45_T_Green",
        "GOL_UK3CB_BAF_556_200Rnd_AP45_T_Yellow"
    };
};
