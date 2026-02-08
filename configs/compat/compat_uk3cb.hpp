// UK3CB BAF weapons compatibility for AP45 magazines
//
// PATTERN: Each patched class MUST specify its correct parent class
// to preserve Arma's inheritance chain. Forward-declare parent classes
// so the config parser knows they exist before we reference them.
//
// CROSS-PBO INHERITANCE:
//   Binarized PBOs freeze inheritance at binarize time.
//   Our magazines[] += on arifle_Mk20_plain_F does NOT propagate
//   to children defined in OTHER pre-binarized PBOs.
//   We must patch the ROOT of each PBO's chain explicitly.
//   Children within the same PBO inherit from the patched root
//   automatically — do NOT patch both parent and child (stacking).

// Forward declarations for parent classes
// arifle_Mk20_plain_F — already defined in compat_vanilla.hpp
class UK3CB_BAF_L85A2;
class UK3CB_BAF_L119_Base;
class UK3CB_BAF_L110_556_Base;

// ============================================================
// L85A2 (5.56mm) — root of SmallArms PBO chain
// All L85A2 variants, L86, and L22 inherit from this within
// the same PBO and get AP45 mags automatically.
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
// L85A3 (5.56mm) — root of L85A3 PBO chain
// All AFG, Grippod, and UGL variants inherit from this within
// the same PBO and get AP45 mags automatically.
// Cross-PBO boundary: L85A3 inherits from L85A2 in SmallArms
// PBO, but binarized configs don't propagate += across PBOs.
// ============================================================
class UK3CB_BAF_L85A3: UK3CB_BAF_L85A2 {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

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
