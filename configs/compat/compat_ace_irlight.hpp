// GOL OX3000 dual-purpose weapon light (included inside class CfgWeapons).
//
// Three modes, cycled with the CBA rail key (MRT rings per strength):
//   DP = IR laser + IR illuminator, LS = IR laser only, FL = visible flashlight.
// Five strengths (P1-P5), adjusted with Ctrl + mouse wheel (OKS_fnc_OX3000_AdjustStrength).
// Lights are engine reflectors; the IR illuminator uses irLight = 1.
// The OX3000 is not a BettIR device; see compat_bettir.hpp.
//
// IR illuminator: soft wide spot (no hard rim, no ambient spill), kept dim for NVG.
// Attenuation follows the BettIR DBAL preset. Visible flashlight is a softened FL.

class InventoryFlashLightItem_Base_F;
class ACE_DBAL_A3_Red;

#define GOL_OX3000_POINTER \
    class Pointer { \
        irLaserPos = "laser pos"; \
        irLaserEnd = "laser dir"; \
        irDistance = 5; \
    }

#define GOL_OX3000_IR_LIGHT(INT_VAL,HLSTART,HLEND,FLAREDIST) \
    class Flashlight { \
        color[] = {1, 1, 1}; \
        ambient[] = {0, 0, 0}; \
        intensity = INT_VAL; \
        size = 1; \
        innerAngle = 4; \
        outerAngle = 32; \
        coneFadeCoef = 8; \
        position = "laser pos"; \
        direction = "laser dir"; \
        useFlare = 1; \
        flareSize = 1; \
        flareMaxDistance = FLAREDIST; \
        dayLight = 0; \
        irLight = 1; \
        scale[] = {0}; \
        class Attenuation { \
            start = 10; \
            constant = 4; \
            linear = 0; \
            quadratic = 0.065; \
            hardLimitStart = HLSTART; \
            hardLimitEnd = HLEND; \
        }; \
    }

#define GOL_OX3000_VIS_LIGHT(INT_VAL,AMB,OUTER,FLARE_SZ,FLAREDIST,CONEFADE,ACONST,ALIN,AQUAD,HLSTART,HLEND) \
    class Flashlight { \
        color[] = {1, 1, 1}; \
        ambient[] = {AMB, AMB, AMB}; \
        size = 0.75; \
        innerAngle = 8; \
        outerAngle = OUTER; \
        position = "laser pos"; \
        direction = "laser dir"; \
        useFlare = 0; \
        flareSize = FLARE_SZ; \
        flareMaxDistance = FLAREDIST; \
        coneFadeCoef = CONEFADE; \
        intensity = INT_VAL; \
        irLight = 0; \
        volumeShape = "a3\data_f\VolumeLightFlashlight.p3d"; \
        scale[] = {0.3, 0.3, 0.85}; \
        class Attenuation { \
            constant = ACONST; \
            linear = ALIN; \
            quadratic = AQUAD; \
            start = 0.5; \
            hardLimitStart = HLSTART; \
            hardLimitEnd = HLEND; \
        }; \
    }

#define GOL_OX3000_VARIANT_HEADER(MODE,POWER,NEXT,PREV,HINT) \
    scope = 1; \
    scopeArsenal = 0; \
    baseWeapon = "GOL_OX3000"; \
    GOL_OX3000_Mode = MODE; \
    GOL_OX3000_Power = POWER; \
    MRT_SwitchItemNextClass = NEXT; \
    MRT_SwitchItemPrevClass = PREV; \
    MRT_SwitchItemHintText = HINT

#define GOL_OX3K_MAKE_DP(NAME,POWER,NEXT,PREV,HINT,INT_VAL,HLSTART,HLEND,FLAREDIST) \
    class NAME: GOL_OX3000 { \
        GOL_OX3000_VARIANT_HEADER("DP",POWER,NEXT,PREV,HINT); \
        class ItemInfo: InventoryFlashLightItem_Base_F { \
            GOL_OX3000_POINTER; \
            GOL_OX3000_IR_LIGHT(INT_VAL,HLSTART,HLEND,FLAREDIST); \
        }; \
    }

#define GOL_OX3K_MAKE_LS(NAME,POWER,NEXT,PREV,HINT) \
    class NAME: GOL_OX3000 { \
        GOL_OX3000_VARIANT_HEADER("LS",POWER,NEXT,PREV,HINT); \
        class ItemInfo: InventoryFlashLightItem_Base_F { \
            GOL_OX3000_POINTER; \
            class Flashlight { scale[] = {0}; }; \
        }; \
    }

#define GOL_OX3K_MAKE_FL(NAME,POWER,NEXT,PREV,HINT,INT_VAL,AMB,OUTER,FLARE_SZ,FLAREDIST,CONEFADE,ACONST,ALIN,AQUAD,HLSTART,HLEND) \
    class NAME: GOL_OX3000 { \
        GOL_OX3000_VARIANT_HEADER("FL",POWER,NEXT,PREV,HINT); \
        class ItemInfo: InventoryFlashLightItem_Base_F { \
            class Pointer {}; \
            GOL_OX3000_VIS_LIGHT(INT_VAL,AMB,OUTER,FLARE_SZ,FLAREDIST,CONEFADE,ACONST,ALIN,AQUAD,HLSTART,HLEND); \
        }; \
    }

// Arsenal item. Identical to GOL_OX3000_DP_P1.
class GOL_OX3000: ACE_DBAL_A3_Red {
    scope = 2;
    scopeArsenal = 2;
    displayName = "OX3000 (GOL)";
    baseWeapon = "GOL_OX3000";
    GOL_OX3000_Mode = "DP";
    GOL_OX3000_Power = "P1";
    MRT_SwitchItemNextClass = "GOL_OX3000_LS_P1";
    MRT_SwitchItemPrevClass = "GOL_OX3000_FL_P4";
    MRT_SwitchItemHintText = "OX3000 Dual";

    class ItemInfo: InventoryFlashLightItem_Base_F {
        GOL_OX3000_POINTER;
        GOL_OX3000_IR_LIGHT(13,140,210,300);
    };
};

// DP: IR laser + IR illuminator.
GOL_OX3K_MAKE_DP(GOL_OX3000_DP_P1,"P1","GOL_OX3000_LS_P1","GOL_OX3000_FL_P4","OX3000 Dual",13,140,210,300);
GOL_OX3K_MAKE_DP(GOL_OX3000_DP_P2,"P2","GOL_OX3000_LS_P2","GOL_OX3000_FL_P4","OX3000 Dual",19,160,240,400);
GOL_OX3K_MAKE_DP(GOL_OX3000_DP_P3,"P3","GOL_OX3000_LS_P3","GOL_OX3000_FL_P4","OX3000 Dual",29,180,270,700);
GOL_OX3K_MAKE_DP(GOL_OX3000_DP_P4,"P4","GOL_OX3000_LS_P4","GOL_OX3000_FL_P4","OX3000 Dual",42,200,300,1000);
GOL_OX3K_MAKE_DP(GOL_OX3000_DP_P5,"P5","GOL_OX3000_LS_P5","GOL_OX3000_FL_P4","OX3000 Dual",58,220,330,1200);

// LS: IR laser only. The strength suffix is kept so cycling back restores it.
// Entering the flashlight (from DP or LS) always starts at P4 (80%).
GOL_OX3K_MAKE_LS(GOL_OX3000_LS_P1,"P1","GOL_OX3000_FL_P4","GOL_OX3000_DP_P1","OX3000 IR");
GOL_OX3K_MAKE_LS(GOL_OX3000_LS_P2,"P2","GOL_OX3000_FL_P4","GOL_OX3000_DP_P2","OX3000 IR");
GOL_OX3K_MAKE_LS(GOL_OX3000_LS_P3,"P3","GOL_OX3000_FL_P4","GOL_OX3000_DP_P3","OX3000 IR");
GOL_OX3K_MAKE_LS(GOL_OX3000_LS_P4,"P4","GOL_OX3000_FL_P4","GOL_OX3000_DP_P4","OX3000 IR");
GOL_OX3K_MAKE_LS(GOL_OX3000_LS_P5,"P5","GOL_OX3000_FL_P4","GOL_OX3000_DP_P5","OX3000 IR");

// FL: visible flashlight.
GOL_OX3K_MAKE_FL(GOL_OX3000_FL_P1,"P1","GOL_OX3000_DP_P1","GOL_OX3000_LS_P1","OX3000 Flashlight",16,0.025,40,1.1,150,8,0.06,0.009,0.0007,80,150);
GOL_OX3K_MAKE_FL(GOL_OX3000_FL_P2,"P2","GOL_OX3000_DP_P2","GOL_OX3000_LS_P2","OX3000 Flashlight",22,0.028,42,1.2,180,7,0.05,0.008,0.0006,100,180);
GOL_OX3K_MAKE_FL(GOL_OX3000_FL_P3,"P3","GOL_OX3000_DP_P3","GOL_OX3000_LS_P3","OX3000 Flashlight",28,0.031,44,1.3,215,6,0.04,0.0065,0.00055,118,200);
GOL_OX3K_MAKE_FL(GOL_OX3000_FL_P4,"P4","GOL_OX3000_DP_P4","GOL_OX3000_LS_P4","OX3000 Flashlight",34,0.034,46,1.4,250,5,0.03,0.005,0.0005,135,225);
GOL_OX3K_MAKE_FL(GOL_OX3000_FL_P5,"P5","GOL_OX3000_DP_P5","GOL_OX3000_LS_P5","OX3000 Flashlight",40,0.037,48,1.5,300,5,0.025,0.004,0.00045,160,260);

// Legacy classes kept for saved loadouts and missions. They inherit the matching
// variant, so the next rail-key press moves them into the new rings.
class GOL_OX3000_II: GOL_OX3000_DP_P1 {};
class GOL_OX3000_IP: GOL_OX3000_LS_P1 {};
class GOL_OX3000_FL_Low: GOL_OX3000_FL_P2 {};
class GOL_OX3000_FL: GOL_OX3000_FL_P4 {};
class GOL_OX3000_LR: GOL_OX3000_DP_P1 {};
class GOL_OX3000_LR_II: GOL_OX3000_DP_P1 {};
class GOL_OX3000_LR_IP: GOL_OX3000_LS_P1 {};
class GOL_OX3000_LR_FL_Low: GOL_OX3000_FL_P2 {};
class GOL_OX3000_LR_FL: GOL_OX3000_FL_P4 {};

#undef GOL_OX3000_POINTER
#undef GOL_OX3000_IR_LIGHT
#undef GOL_OX3000_VIS_LIGHT
#undef GOL_OX3000_VARIANT_HEADER
#undef GOL_OX3K_MAKE_DP
#undef GOL_OX3K_MAKE_LS
#undef GOL_OX3K_MAKE_FL
