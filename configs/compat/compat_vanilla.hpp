// Vanilla 5.56mm weapons compatibility for AP45 magazines
//
// PATTERN: Each patched class MUST specify its correct parent class
// to preserve Arma's inheritance chain. A bare class declaration
// (without parent) will strip the parent and corrupt the entire
// inheritance tree downstream.
//
// Forward-declare all parent classes so the config parser knows
// they exist before we reference them.

// Forward declarations for parent classes
class arifle_SPAR_01_base_F;
class arifle_SPAR_01_GL_base_F;
class arifle_Mk20_F;
class arifle_Mk20_GL_F;
class arifle_SPAR_02_base_F;
class LMG_03_base_F;

// ============================================================
// SPAR-01 rifles (5.56mm)
// ============================================================
class arifle_SPAR_01_blk_F: arifle_SPAR_01_base_F {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class arifle_SPAR_01_khk_F: arifle_SPAR_01_base_F {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class arifle_SPAR_01_snd_F: arifle_SPAR_01_base_F {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

// ============================================================
// SPAR-01 GL rifles (5.56mm + grenade launcher)
// ============================================================
class arifle_SPAR_01_GL_blk_F: arifle_SPAR_01_GL_base_F {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class arifle_SPAR_01_GL_khk_F: arifle_SPAR_01_GL_base_F {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class arifle_SPAR_01_GL_snd_F: arifle_SPAR_01_GL_base_F {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

// ============================================================
// Mk20 (FN F2000) rifles (5.56mm)
// NOTE: arifle_Mk20_plain_F intentionally NOT patched here.
// It is a vanilla leaf class whose only mod child is
// UK3CB_BAF_L85A2 (patched in compat_uk3cb.hpp).
// Fully re-opening it here would cause L85A2's re-open to
// rebuild from our modified parent, losing 3CB's magazines.
// ============================================================
class arifle_Mk20_GL_plain_F: arifle_Mk20_GL_F {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

// ============================================================
// SPAR-02 (5.56mm, 30rnd only — 200rnd box breaks animation)
// ============================================================
class arifle_SPAR_02_blk_F: arifle_SPAR_02_base_F {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class arifle_SPAR_02_khk_F: arifle_SPAR_02_base_F {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class arifle_SPAR_02_snd_F: arifle_SPAR_02_base_F {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

// ============================================================
// LMG_03 (LIM-85, 5.56mm belt-fed)
// ============================================================
class LMG_03_F: LMG_03_base_F {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
        "GOL_200Rnd_556x45_AP45_Box",
        "GOL_200Rnd_556x45_AP45_Box_Tracer_Red",
        "GOL_200Rnd_556x45_AP45_Box_Tracer_Green",
        "GOL_200Rnd_556x45_AP45_Box_Tracer_Yellow"
    };
};
