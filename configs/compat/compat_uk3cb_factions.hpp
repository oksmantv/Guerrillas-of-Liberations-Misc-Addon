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
class SMG_02_F;
class uk3cb_muzzle_snds_mp5;
class InventoryMuzzleItem_Base_F;
// rhs_weap_m249_pip_L — already defined in compat_rhs.hpp
class rhs_weap_m249_pip_L_vfg3;

// 3CB-model Ghost suppressor for 3CB MP5 weapons.
class GOL_muzzle_snds_mp5_ghost: uk3cb_muzzle_snds_mp5 {
    scope = 2;
    scopeArsenal = 2;
    scopeCurator = 2;
    author = "Guerrillas of Liberation";
    type = 131072;
    weaponPoolAvailable = 1;
    displayName = "Ghost MP5 Sound Suppressor (9 mm)";
	displayNameShort = "Ghost MP5";
    descriptionShort = "Extremely effective 9 mm suppressor. Optimized for subsonic ammunition.";
	model = "\UK3CB_Factions\addons\UK3CB_Factions_Weapons\Accessories\Agenda6\uk3cb_agenda6_sup.p3d";
	picture = "\UK3CB_Factions\addons\UK3CB_Factions_Weapons\Accessories\Agenda6\data\ui\gear_acc_agenda6_silencer_ca.paa";

    class ItemInfo: InventoryMuzzleItem_Base_F {
        mass = 11;
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
            dispersionCoef = 0.95;
            artilleryDispersionCoef = 1.0;
            fireLightCoef = 0.05;
            recoilCoef = 0.95;
            recoilProneCoef = 0.95;
            minRangeCoef = 1.0;
            minRangeProbabCoef = 1.0;
            midRangeCoef = 1.0;
            midRangeProbabCoef = 1.0;
            maxRangeCoef = 1.0;
            maxRangeProbabCoef = 1.0;
        };
    };
};

// 3CB MP5 family — verified root class and parent from the runtime config.
// Its child variants inherit the custom magazine and muzzle-slot entry.
class UK3CB_MP5_Base: SMG_02_F {
    magazines[] += {"GOL_UK3CB_MP5_30Rnd_9x19_Subsonic_Mag"};
    class WeaponSlotsInfo: WeaponSlotsInfo {
        class MuzzleSlot: MuzzleSlot {
            compatibleItems[] += {
                "GOL_muzzle_snds_9MM_ghost_black",
                "GOL_muzzle_snds_mp5_ghost"
            };
        };
    };
};

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
