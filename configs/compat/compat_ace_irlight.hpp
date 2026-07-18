// GOL OX3000 IR-light copies.
// These preserve ACE originals and expose a renamed OX3000 family.
class InventoryFlashLightItem_Base_F;
class ACE_DBAL_A3_Red;

class GOL_OX3000: ACE_DBAL_A3_Red {
    scope = 2;
    scopeArsenal = 2;
    displayName = "OX3000 (GOL)";
    MRT_SwitchItemNextClass = "GOL_OX3000_FL_Low";
    MRT_SwitchItemPrevClass = "GOL_OX3000_IP";
    MRT_SwitchItemHintText = "OX3000 IR Dual";
    baseWeapon = "GOL_OX3000";

    class ItemInfo: InventoryFlashLightItem_Base_F {
        // SCRIPTED IR ILLUMINATOR: Empty Flashlight (AI CAN see irLight=1 despite it being "IR")
        // Light created by fn_IRIlluminator_Monitor.sqf when IR laser (pointer) is active
        // Only IR laser BEAMS are invisible to AI, not IR flashlights
        class Flashlight {};
        
        class Pointer {
            irLaserPos = "laser pos";
            irLaserEnd = "laser dir";
            irDistance = 5;
        };
    };
};

class GOL_OX3000_IP: GOL_OX3000 {
    scope = 1;
    baseWeapon = "GOL_OX3000";
    MRT_SwitchItemNextClass = "GOL_OX3000";
    MRT_SwitchItemPrevClass = "GOL_OX3000_FL_Low";
    MRT_SwitchItemHintText = "OX3000 IR Pointer";

    class ItemInfo: InventoryFlashLightItem_Base_F {
        class Flashlight {};
        class Pointer {
            irLaserPos = "laser pos";
            irLaserEnd = "laser dir";
            irDistance = 5;
        };
    };
};

class GOL_OX3000_II: GOL_OX3000 {
    scope = 1;  // Hidden but valid (not in cycle - prevents config errors)
    baseWeapon = "GOL_OX3000";
    MRT_SwitchItemNextClass = "GOL_OX3000";
    MRT_SwitchItemPrevClass = "GOL_OX3000";
    MRT_SwitchItemHintText = "OX3000 IR Illuminator";

    class ItemInfo: InventoryFlashLightItem_Base_F {
        // IR ILLUMINATOR ONLY: No laser pointer, no built-in flashlight.
        // BettIR weapon illuminator auto-activates with NVGs (see fn_BettIR_AutoWeaponIlluminator.sqf)
        class Flashlight {};
        class Pointer {};
        
        /* OLD CONFIG (built-in light triggers isFlashlightOn, alerts AI):
        class Flashlight {
            color[] = {1, 1, 1};
            ambient[] = {1, 1, 1};
            size = 1;
            innerAngle = 12;
            outerAngle = 16;
            position = "laser pos";
            direction = "laser dir";
            useFlare = 1;
            flareSize = 1.4;
            flareMaxDistance = 200;
            coneFadeCoef = 8;
            intensity = 70;
            irLight = 1;
            volumeShape = "a3\data_f\VolumeLightFlashlight.p3d";
            scale[] = {0.25, 0.25, 1};
            class Attenuation {
                constant = 1;
                linear = 0;
                quadratic = 0.008;
                start = 1;
                hardLimitStart = 220;
                hardLimitEnd = 250;
            };
        };
        */
    };
};

class GOL_OX3000_FL_Low: GOL_OX3000 {
    scope = 1;
    baseWeapon = "GOL_OX3000";
    MRT_SwitchItemNextClass = "GOL_OX3000_IP";
    MRT_SwitchItemPrevClass = "GOL_OX3000";
    MRT_SwitchItemHintText = "OX3000 Flashlight";

    class ItemInfo: InventoryFlashLightItem_Base_F {
        class Flashlight {
            color[] = {1, 1, 1};
            ambient[] = {0.1, 0.1, 0.1};
            size = 0.75;
            innerAngle = 8;
            outerAngle = 39;  // 30% narrower (was 55)
            position = "laser pos";
            direction = "laser dir";
            useFlare = 0;
            flareSize = 1.2;
            flareMaxDistance = 180;
            coneFadeCoef = 9;
            intensity = 190;  // 50% of original 380
            irLight = 0;
            volumeShape = "a3\data_f\VolumeLightFlashlight.p3d";
            scale[] = {0.3, 0.3, 0.85};  // 15% narrower width/length
            class Attenuation {
                constant = 0.05;
                linear = 0.008;
                quadratic = 0.0006;  // Increased for more natural falloff
                start = 0.5;
                hardLimitStart = 100;
                hardLimitEnd = 180;
            };
        };
        class Pointer {};
    };
};

class GOL_OX3000_FL: GOL_OX3000 {
    scope = 1;  // Hidden from arsenal but valid for compatibility (prevents config errors)
    baseWeapon = "GOL_OX3000";
    MRT_SwitchItemNextClass = "GOL_OX3000_FL_Low";
    MRT_SwitchItemPrevClass = "GOL_OX3000";
    MRT_SwitchItemHintText = "OX3000 Flashlight (High)";

    class ItemInfo: InventoryFlashLightItem_Base_F {
        class Flashlight {
            color[] = {1, 1, 1};
            ambient[] = {0.15, 0.15, 0.15};
            size = 0.75;
            innerAngle = 8;
            outerAngle = 42;  // 30% narrower (was 60)
            position = "laser pos";
            direction = "laser dir";
            useFlare = 0;
            flareSize = 1.4;
            flareMaxDistance = 250;
            coneFadeCoef = 7;
            intensity = 413;  // 50% of original 825
            irLight = 0;
            volumeShape = "a3\data_f\VolumeLightFlashlight.p3d";
            scale[] = {0.3, 0.3, 0.85};  // 15% narrower width/length
            class Attenuation {
                constant = 0.03;
                linear = 0.005;
                quadratic = 0.0005;  // Increased for more natural falloff
                start = 0.5;
                hardLimitStart = 135;
                hardLimitEnd = 225;
            };
        };
        class Pointer {};
    };
};

// Compatibility stubs for saved loadouts/missions that reference LR variants
// These redirect to standard versions to prevent config errors
class GOL_OX3000_LR: GOL_OX3000 {
    scope = 1;
    scopeArsenal = 0;
    baseWeapon = "GOL_OX3000";
    MRT_SwitchItemNextClass = "GOL_OX3000_LR_FL_Low";
    MRT_SwitchItemPrevClass = "GOL_OX3000_LR_IP";
};

class GOL_OX3000_LR_IP: GOL_OX3000_IP {
    scope = 1;
    scopeArsenal = 0;
    baseWeapon = "GOL_OX3000";
    MRT_SwitchItemNextClass = "GOL_OX3000_LR";
    MRT_SwitchItemPrevClass = "GOL_OX3000_LR_FL_Low";
};

class GOL_OX3000_LR_II: GOL_OX3000_II {
    scope = 1;  // Hidden but valid for compatibility (prevents config errors)
    scopeArsenal = 0;
    baseWeapon = "GOL_OX3000";
    MRT_SwitchItemNextClass = "GOL_OX3000_LR";
    MRT_SwitchItemPrevClass = "GOL_OX3000_LR";
};

class GOL_OX3000_LR_FL_Low: GOL_OX3000_FL_Low {
    scope = 1;
    scopeArsenal = 0;
    baseWeapon = "GOL_OX3000";
    MRT_SwitchItemNextClass = "GOL_OX3000_LR_IP";
    MRT_SwitchItemPrevClass = "GOL_OX3000_LR";
};

class GOL_OX3000_LR_FL: GOL_OX3000_FL {
    scope = 1;  // Hidden but valid for compatibility (prevents config errors)
    scopeArsenal = 0;
    baseWeapon = "GOL_OX3000";
    MRT_SwitchItemNextClass = "GOL_OX3000_LR_FL_Low";
    MRT_SwitchItemPrevClass = "GOL_OX3000_LR";
};
