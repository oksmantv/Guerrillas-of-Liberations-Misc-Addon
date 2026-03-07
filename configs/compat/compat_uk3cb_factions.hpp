// UK3CB Factions weapons compatibility for AP45 magazines
//
// PATTERN: Each patched class MUST specify its correct parent class
// to preserve Arma's inheritance chain. Forward-declare parent classes
// so the config parser knows they exist before we reference them.
//
// Parent classes extracted from UK3CB Factions config hierarchy
// (these weapons inherit from RHS base classes).

// Forward declarations for parent classes
class rhs_weap_hk416d145;
class rhs_weap_hk416d10_LMT;
class rhs_weap_hk416d145_m320;
class rhs_weap_m16a4_carryhandle_pmag;
class rhs_weap_m16a4_carryhandle_M203;
class rhs_weap_m4_carryhandle;
class rhs_weap_m4a1_m203s;
class rhs_weap_m4a1_d;
class rhs_weap_m4a1_m203s_d;
class rhs_weap_m4a1_wd;
class rhs_weap_m4a1_m203s_wd;
// rhs_weap_m249_pip_L — already defined in compat_rhs.hpp
class rhs_weap_m249_pip_L_vfg3;

// ============================================================
// HK416 variants (5.56mm)
// ============================================================
class UK3CB_HK416_eotech_552: rhs_weap_hk416d145 {
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

class UK3CB_HK416_eotech_552_sup: rhs_weap_hk416d145 {
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

class UK3CB_HK416_eotech_552_anpeq15_sup: rhs_weap_hk416d145 {
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

class UK3CB_HK416_LMT_eotech_552: rhs_weap_hk416d10_LMT {
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

class UK3CB_HK416_M320_eotech_552: rhs_weap_hk416d145_m320 {
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
// M16A4 variants (5.56mm)
// ============================================================
class uk3cb_weap_m16a4_eotech_552_anpeq15_bk: rhs_weap_m16a4_carryhandle_pmag {
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

class uk3cb_weap_m16a4_eotech_552_anpeq15_bk_sup: rhs_weap_m16a4_carryhandle_pmag {
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

class uk3cb_weap_m16a4_eotech_552_anpeq15_sup: rhs_weap_m16a4_carryhandle_pmag {
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

class uk3cb_weap_m16a4_m203s_eotech_552_anpeq15_sup: rhs_weap_m16a4_carryhandle_M203 {
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
// M4A1 variants — standard (5.56mm)
// ============================================================
class uk3cb_weap_m4a1_eot552: rhs_weap_m4_carryhandle {
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

class uk3cb_weap_m4a1_acog_anpeq15_sup: rhs_weap_m4_carryhandle {
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

class uk3cb_weap_m4a1_eot552_anpeq15_bk: rhs_weap_m4_carryhandle {
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

class uk3cb_weap_m4a1_eot552_anpeq15: rhs_weap_m4_carryhandle {
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

class uk3cb_weap_m4a1_eot552_anpeq15_sup: rhs_weap_m4_carryhandle {
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
// M4A1 M203 variants — standard (5.56mm)
// ============================================================
class uk3cb_weap_m4a1_m203s_eot552_anpeq15: rhs_weap_m4a1_m203s {
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

class uk3cb_weap_m4a1_m203s_eot552_anpeq15_sup: rhs_weap_m4a1_m203s {
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
// M4A1 variants — desert (5.56mm)
// ============================================================
class uk3cb_weap_m4a1_d_eotech_552_d_anpeq15: rhs_weap_m4a1_d {
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

class uk3cb_weap_m4a1_d_eotech_552_d_anpeq15_sup: rhs_weap_m4a1_d {
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

class uk3cb_weap_m4a1_m203s_d_eotech_552_d_anpeq15: rhs_weap_m4a1_m203s_d {
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

class uk3cb_weap_m4a1_m203s_d_eotech_552_d_anpeq15_sup: rhs_weap_m4a1_m203s_d {
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
// M4A1 variants — woodland (5.56mm)
// ============================================================
class uk3cb_weap_m4a1_w_eotech_552_wd_anpeq15_sup: rhs_weap_m4a1_wd {
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

class uk3cb_weap_m4a1_m203s_wd_eotech_552_wd_anpeq15_sup: rhs_weap_m4a1_m203s_wd {
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
// M249 variants (5.56mm belt-fed)
// NOTE: uk3cb_weap_m249_pip_L_sup and _eot552_anpeq15_sup inherit
//       from rhs_weap_m249_pip_L which is already patched in
//       compat_rhs.hpp — they get AP45 mags automatically.
//       Only vfg3 variant needs patching (different parent chain).
// ============================================================
class uk3cb_weap_m249_pip_L_vfg3_acog_bip_sup: rhs_weap_m249_pip_L_vfg3 {
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
