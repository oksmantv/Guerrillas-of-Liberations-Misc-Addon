// UK3CB BAF weapons compatibility for AP45 magazines
//
// PATTERN: Each patched class MUST specify its correct parent class
// to preserve Arma's inheritance chain. Forward-declare parent classes
// so the config parser knows they exist before we reference them.
//
// Parent classes extracted from UK3CB BAF config hierarchy:
//   UK3CB_BAF_L85A2                -> arifle_Mk20_plain_F
//   UK3CB_BAF_L85A2_EMAG          -> UK3CB_BAF_L85A2
//   UK3CB_BAF_L85A2_RIS           -> UK3CB_BAF_L85A2
//   UK3CB_BAF_L85A2_RIS_D/G/W     -> UK3CB_BAF_L85A2_RIS
//   UK3CB_BAF_L85A2_UGL/UGL_HWS   -> UK3CB_BAF_L85A2
//   UK3CB_BAF_L85A3               -> UK3CB_BAF_L85A2
//   UK3CB_BAF_L85A3_UGL           -> UK3CB_BAF_L85A3
//   UK3CB_BAF_L86A2               -> UK3CB_BAF_L85A2
//   UK3CB_BAF_L86A3               -> UK3CB_BAF_L86A2
//   UK3CB_BAF_L22                 -> UK3CB_BAF_L85A2
//   UK3CB_BAF_L22A2               -> UK3CB_BAF_L22
//   UK3CB_BAF_L119A1/CQB/RIS/UKUGL -> UK3CB_BAF_L119_Base
//   UK3CB_BAF_L110A1/A2/A2RIS/A3  -> UK3CB_BAF_L110_556_Base

// Forward declarations for parent classes
// arifle_Mk20_plain_F — already defined in compat_vanilla.hpp
class UK3CB_BAF_L119_Base;
class UK3CB_BAF_L110_556_Base;

// ============================================================
// L85A2 family (5.56mm rifles)
// Source PBO: UK3CB_BAF_Weapons_SmallArms
// ============================================================
class UK3CB_BAF_L85A2: arifle_Mk20_plain_F {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class UK3CB_BAF_L85A2_EMAG: UK3CB_BAF_L85A2 {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class UK3CB_BAF_L85A2_RIS: UK3CB_BAF_L85A2 {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class UK3CB_BAF_L85A2_RIS_G: UK3CB_BAF_L85A2_RIS {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class UK3CB_BAF_L85A2_RIS_D: UK3CB_BAF_L85A2_RIS {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class UK3CB_BAF_L85A2_RIS_W: UK3CB_BAF_L85A2_RIS {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class UK3CB_BAF_L85A2_UGL: UK3CB_BAF_L85A2 {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class UK3CB_BAF_L85A2_UGL_HWS: UK3CB_BAF_L85A2 {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

// ============================================================
// L85A3 family (5.56mm rifles)
// Source PBO: UK3CB_BAF_Weapons_L85A3
// ============================================================
class UK3CB_BAF_L85A3: UK3CB_BAF_L85A2 {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class UK3CB_BAF_L85A3_UGL: UK3CB_BAF_L85A3 {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

// ============================================================
// L86 LSW (5.56mm light support weapon)
// Source PBO: UK3CB_BAF_Weapons_SmallArms
// ============================================================
class UK3CB_BAF_L86A2: UK3CB_BAF_L85A2 {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class UK3CB_BAF_L86A3: UK3CB_BAF_L86A2 {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

// ============================================================
// L22 Carbine (5.56mm)
// Source PBO: UK3CB_BAF_Weapons_SmallArms
// ============================================================
class UK3CB_BAF_L22: UK3CB_BAF_L85A2 {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow"
    };
};

class UK3CB_BAF_L22A2: UK3CB_BAF_L22 {
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
