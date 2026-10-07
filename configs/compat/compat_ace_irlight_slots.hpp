// Slot compatibility extension for GOL OX3000 variants.
// This file is loaded at top-level config scope (outside CfgWeapons).

class SlotInfo;
class PointerSlot: SlotInfo {
    compatibleItems[] += {
        "GOL_OX3000",
        "GOL_OX3000_IP",
        "GOL_OX3000_II",
        "GOL_OX3000_FL",
        "GOL_OX3000_FL_Low",
        "GOL_OX3000_LR",
        "GOL_OX3000_LR_IP",
        "GOL_OX3000_LR_II",
        "GOL_OX3000_LR_FL",
        "GOL_OX3000_LR_FL_Low"
    };
};

class PointerSlot_Rail: PointerSlot {
    class compatibleItems {
        ACE_DBAL_A3_Red = 1;
        ACE_DBAL_A3_Red_IP = 1;
        ACE_DBAL_A3_Red_II = 1;
        ACE_DBAL_A3_Red_VP = 1;
        ACE_DBAL_A3_Red_LR = 1;
        ACE_DBAL_A3_Red_LR_IP = 1;
        ACE_DBAL_A3_Red_LR_II = 1;
        ACE_DBAL_A3_Red_LR_VP = 1;
        ACE_DBAL_A3_Green = 1;
        ACE_DBAL_A3_Green_IP = 1;
        ACE_DBAL_A3_Green_II = 1;
        ACE_DBAL_A3_Green_VP = 1;
        ACE_DBAL_A3_Green_LR = 1;
        ACE_DBAL_A3_Green_LR_IP = 1;
        ACE_DBAL_A3_Green_LR_II = 1;
        ACE_DBAL_A3_Green_LR_VP = 1;
        ACE_SPIR = 1;
        ACE_SPIR_Medium = 1;
        ACE_SPIR_Narrow = 1;
        ACE_SPIR_LR = 1;
        ACE_SPIR_LR_Medium = 1;
        ACE_SPIR_LR_Narrow = 1;
        GOL_OX3000 = 1;
        GOL_OX3000_IP = 1;
        GOL_OX3000_II = 1;
        GOL_OX3000_FL = 1;
        GOL_OX3000_FL_Low = 1;
        GOL_OX3000_LR = 1;
        GOL_OX3000_LR_IP = 1;
        GOL_OX3000_LR_II = 1;
        GOL_OX3000_LR_FL = 1;
        GOL_OX3000_LR_FL_Low = 1;
    };
};

class asdg_SlotInfo;
class asdg_FrontSideRail: asdg_SlotInfo {
    class compatibleItems {
        ACE_DBAL_A3_Red = 1;
        ACE_DBAL_A3_Red_IP = 1;
        ACE_DBAL_A3_Red_II = 1;
        ACE_DBAL_A3_Red_VP = 1;
        ACE_DBAL_A3_Red_LR = 1;
        ACE_DBAL_A3_Red_LR_IP = 1;
        ACE_DBAL_A3_Red_LR_II = 1;
        ACE_DBAL_A3_Red_LR_VP = 1;
        ACE_DBAL_A3_Green = 1;
        ACE_DBAL_A3_Green_IP = 1;
        ACE_DBAL_A3_Green_II = 1;
        ACE_DBAL_A3_Green_VP = 1;
        ACE_DBAL_A3_Green_LR = 1;
        ACE_DBAL_A3_Green_LR_IP = 1;
        ACE_DBAL_A3_Green_LR_II = 1;
        ACE_DBAL_A3_Green_LR_VP = 1;
        ACE_SPIR = 1;
        ACE_SPIR_Medium = 1;
        ACE_SPIR_Narrow = 1;
        ACE_SPIR_LR = 1;
        ACE_SPIR_LR_Medium = 1;
        ACE_SPIR_LR_Narrow = 1;
        GOL_OX3000 = 1;
        GOL_OX3000_IP = 1;
        GOL_OX3000_II = 1;
        GOL_OX3000_FL = 1;
        GOL_OX3000_FL_Low = 1;
        GOL_OX3000_LR = 1;
        GOL_OX3000_LR_IP = 1;
        GOL_OX3000_LR_II = 1;
        GOL_OX3000_LR_FL = 1;
        GOL_OX3000_LR_FL_Low = 1;
    };
};
