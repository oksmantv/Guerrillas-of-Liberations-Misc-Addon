// UK3CB BAF weapons compatibility for AP45 magazines
//
// PATTERN: Each patched class MUST specify its correct parent class
// to preserve Arma's inheritance chain. Forward-declare parent classes
// so the config parser knows they exist before we reference them.
//
// INHERITANCE NOTE:
//   The entire L85/L86/L22 family inherits from arifle_Mk20_plain_F,
//   which is already patched in compat_vanilla.hpp. All children
//   automatically inherit AP45 mags — no patches needed here.
//   Only L119 and L110 need explicit patches (different parent chains).

// Forward declarations for parent classes
class UK3CB_BAF_L119_Base;
class UK3CB_BAF_L110_556_Base;

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
