// RHS 5.56mm weapons compatibility for AP45 magazines
//
// PATTERN: Each patched class MUST specify its correct parent class
// to preserve Arma's inheritance chain. Forward-declare parent classes
// so the config parser knows they exist before we reference them.
//
// Parent classes extracted from RHS config hierarchy:
//   rhs_weap_m4, rhs_weap_m4a1, rhs_weap_m16a4 -> rhs_weap_m4_Base
//   rhs_weap_m249, m249_pip, m249_pip_S         -> rhs_weap_lmg_minimi_railed
//   rhs_weap_m249_pip_L                         -> rhs_weap_lmg_minimi_railed

// Forward declarations for parent classes
class rhs_weap_m4_Base;
class rhs_weap_lmg_minimi_railed;

// ============================================================
// RHS M4/M16 rifles (5.56mm, 30rnd only)
// ============================================================
class rhs_weap_m4: rhs_weap_m4_Base {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Yellow",
        "GOL_30Rnd_556x45_AP45_Mixed_Red",
        "GOL_30Rnd_556x45_AP45_Mixed_Green",
        "GOL_30Rnd_556x45_AP45_Mixed_Yellow"
    };
};

class rhs_weap_m4a1: rhs_weap_m4_Base {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Yellow",
        "GOL_30Rnd_556x45_AP45_Mixed_Red",
        "GOL_30Rnd_556x45_AP45_Mixed_Green",
        "GOL_30Rnd_556x45_AP45_Mixed_Yellow"
    };
};

class rhs_weap_m16a4: rhs_weap_m4_Base {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Yellow",
        "GOL_30Rnd_556x45_AP45_Mixed_Red",
        "GOL_30Rnd_556x45_AP45_Mixed_Green",
        "GOL_30Rnd_556x45_AP45_Mixed_Yellow"
    };
};

// ============================================================
// RHS M249 SAW variants (5.56mm, 30rnd + 200rnd belts)
// ============================================================
class rhs_weap_m249: rhs_weap_lmg_minimi_railed {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Yellow",
        "GOL_30Rnd_556x45_AP45_Mixed_Red",
        "GOL_30Rnd_556x45_AP45_Mixed_Green",
        "GOL_30Rnd_556x45_AP45_Mixed_Yellow",
        "GOL_rhsusf_200rnd_556x45_AP45",
        "GOL_rhsusf_200rnd_556x45_AP45_tracer_red",
        "GOL_rhsusf_200rnd_556x45_AP45_tracer_green",
        "GOL_rhsusf_200rnd_556x45_AP45_tracer_yellow"
    };
};

class rhs_weap_m249_pip_L: rhs_weap_lmg_minimi_railed {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Yellow",
        "GOL_30Rnd_556x45_AP45_Mixed_Red",
        "GOL_30Rnd_556x45_AP45_Mixed_Green",
        "GOL_30Rnd_556x45_AP45_Mixed_Yellow",
        "GOL_rhsusf_200rnd_556x45_AP45",
        "GOL_rhsusf_200rnd_556x45_AP45_tracer_red",
        "GOL_rhsusf_200rnd_556x45_AP45_tracer_green",
        "GOL_rhsusf_200rnd_556x45_AP45_tracer_yellow"
    };
};

class rhs_weap_m249_pip: rhs_weap_lmg_minimi_railed {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Yellow",
        "GOL_30Rnd_556x45_AP45_Mixed_Red",
        "GOL_30Rnd_556x45_AP45_Mixed_Green",
        "GOL_30Rnd_556x45_AP45_Mixed_Yellow",
        "GOL_rhsusf_200rnd_556x45_AP45",
        "GOL_rhsusf_200rnd_556x45_AP45_tracer_red",
        "GOL_rhsusf_200rnd_556x45_AP45_tracer_green",
        "GOL_rhsusf_200rnd_556x45_AP45_tracer_yellow"
    };
};

class rhs_weap_m249_pip_S: rhs_weap_lmg_minimi_railed {
    magazines[] += {
        "GOL_30Rnd_556x45_AP45",
        "GOL_30Rnd_556x45_AP45_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Red",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Green",
        "GOL_30Rnd_556x45_AP45_Reload_Tracer_Yellow",
        "GOL_30Rnd_556x45_AP45_Mixed_Red",
        "GOL_30Rnd_556x45_AP45_Mixed_Green",
        "GOL_30Rnd_556x45_AP45_Mixed_Yellow",
        "GOL_rhsusf_200rnd_556x45_AP45",
        "GOL_rhsusf_200rnd_556x45_AP45_tracer_red",
        "GOL_rhsusf_200rnd_556x45_AP45_tracer_green",
        "GOL_rhsusf_200rnd_556x45_AP45_tracer_yellow"
    };
};
