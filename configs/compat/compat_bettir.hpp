// BettIR NVG compatibility extension.
//
// This file appends additional NVG classnames to BettIR's compatible list.
// It is loaded through GOL_MISC_COMPAT_BETTIR, which uses
// skipWhenMissingDependencies = 1 so the patch is ignored when BettIR is absent.

class BettIR_Config {
    class CompatibleNightvisionGoggles {
        // Common bino offset used by BettIR defaults.
        class ACE_NVG_Gen1 {
            offset[] = {0, 0.15, 0.14};
        };

        class ACE_NVG_Gen3 {
            offset[] = {0, 0.15, 0.14};
        };

        // ACE variants not present in BettIR defaults.
        class ACE_NVG_Wide_Green_WP {
            offset[] = {0, 0.15, 0.14};
        };

        class ACE_NVG_Wide_Green {
            offset[] = {0, 0.15, 0.14};
        };

        class ACE_NVG_Wide_WP {
            offset[] = {0, 0.15, 0.14};
        };

        class ACE_NVG_Wide_Black_WP {
            offset[] = {0, 0.15, 0.14};
        };

        class ACE_NVG_Wide_Black {
            offset[] = {0, 0.15, 0.14};
        };

        class ACE_NVG_Gen4_Green_WP {
            offset[] = {0, 0.15, 0.14};
        };

        class ACE_NVG_Gen4_Green {
            offset[] = {0, 0.15, 0.14};
        };

        class ACE_NVG_Gen4_WP {
            offset[] = {0, 0.15, 0.14};
        };

        class ACE_NVG_Gen4_Black_WP {
            offset[] = {0, 0.15, 0.14};
        };

        class ACE_NVG_Gen4_Black {
            offset[] = {0, 0.15, 0.14};
        };

        // Add more NVG classes below as needed.
        // Bino / dual-tube style example:
        // class MOD_NVG_DUAL {
        //     offset[] = {0, 0.15, 0.14};
        // };
        // Monocular style example:
        // class MOD_NVG_MONO {
        //     offset[] = {-0.04, 0.14, 0.1};
        // };
    };

    class CompatibleAttachments {
        class JCA_acc_LaserModule_black_Pointer {
            offset[] = {0.05, 0.28, 0.06};
        };

        class JCA_acc_LaserModule_olive_Pointer {
            offset[] = {0.05, 0.28, 0.06};
        };

        class JCA_acc_LaserModule_sand_Pointer {
            offset[] = {0.05, 0.28, 0.06};
        };

        class rhs_acc_perst1ik {
            offset[] = {0.032, 0.32, 0.105};
        };
    };
};
