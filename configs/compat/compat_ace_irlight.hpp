// GOL OX3000 IR-light copies.
// These preserve ACE originals and expose a renamed OX3000 family.
class InventoryFlashLightItem_Base_F;
class ACE_DBAL_A3_Red;

class GOL_OX3000: ACE_DBAL_A3_Red {
    scope = 2;
    scopeArsenal = 2;
    displayName = "OX3000 (GOL)";
    MRT_SwitchItemNextClass = "GOL_OX3000_FL";
    MRT_SwitchItemPrevClass = "GOL_OX3000_IP";
    MRT_SwitchItemHintText = "OX3000 IR Dual";
    baseWeapon = "GOL_OX3000";

    class ItemInfo: InventoryFlashLightItem_Base_F {
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
        class Pointer {
            irLaserPos = "laser pos";
            irLaserEnd = "laser dir";
            irDistance = 5;
        };
    };
};

class GOL_OX3000_IP: GOL_OX3000 {
    scope = 1;
    MRT_SwitchItemNextClass = "GOL_OX3000";
    MRT_SwitchItemPrevClass = "GOL_OX3000_II";
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
    scope = 1;
    MRT_SwitchItemNextClass = "GOL_OX3000_IP";
    MRT_SwitchItemPrevClass = "GOL_OX3000_FL";
    MRT_SwitchItemHintText = "OX3000 IR Illuminator";

    class ItemInfo: InventoryFlashLightItem_Base_F {
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
    };
};

class GOL_OX3000_FL: GOL_OX3000 {
    scope = 1;
    MRT_SwitchItemNextClass = "GOL_OX3000_II";
    MRT_SwitchItemPrevClass = "GOL_OX3000";
    MRT_SwitchItemHintText = "OX3000 Flashlight";

    class ItemInfo: InventoryFlashLightItem_Base_F {
        class Flashlight {
            color[] = {1, 1, 1};
            ambient[] = {0.1, 0.1, 0.1};
            size = 1;
            innerAngle = 10;
            outerAngle = 46;
            position = "laser pos";
            direction = "laser dir";
            useFlare = 0;
            flareSize = 1.4;
            flareMaxDistance = 120;
            coneFadeCoef = 8;
            intensity = 120;
            irLight = 0;
            volumeShape = "a3\data_f\VolumeLightFlashlight.p3d";
            scale[] = {0.25, 0.25, 1};
            class Attenuation {
                constant = 0.3;
                linear = 0.04;
                quadratic = 0.0025;
                start = 0.5;
                hardLimitStart = 42;
                hardLimitEnd = 50;
            };
        };
        class Pointer {};
    };
};

class GOL_OX3000_LR: GOL_OX3000 {
    scope = 2;
    scopeArsenal = 2;
    displayName = "OX3000 LR (GOL)";
    MRT_SwitchItemNextClass = "GOL_OX3000_LR_FL";
    MRT_SwitchItemPrevClass = "GOL_OX3000_LR_IP";
    MRT_SwitchItemHintText = "OX3000 LR IR Dual";
    baseWeapon = "GOL_OX3000_LR";

    class ItemInfo: InventoryFlashLightItem_Base_F {
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
            intensity = 140;
            irLight = 1;
            volumeShape = "a3\data_f\VolumeLightFlashlight.p3d";
            scale[] = {0.25, 0.25, 1};
            class Attenuation {
                constant = 1;
                linear = 0;
                quadratic = 0.001;
                start = 1;
                hardLimitStart = 570;
                hardLimitEnd = 600;
            };
        };
        class Pointer {
            irLaserPos = "laser pos";
            irLaserEnd = "laser dir";
            irDistance = 5;
        };
    };
};

class GOL_OX3000_LR_IP: GOL_OX3000_LR {
    scope = 1;
    MRT_SwitchItemNextClass = "GOL_OX3000_LR";
    MRT_SwitchItemPrevClass = "GOL_OX3000_LR_II";
    MRT_SwitchItemHintText = "OX3000 LR IR Pointer";

    class ItemInfo: InventoryFlashLightItem_Base_F {
        class Flashlight {};
        class Pointer {
            irLaserPos = "laser pos";
            irLaserEnd = "laser dir";
            irDistance = 5;
        };
    };
};

class GOL_OX3000_LR_II: GOL_OX3000_LR {
    scope = 1;
    MRT_SwitchItemNextClass = "GOL_OX3000_LR_IP";
    MRT_SwitchItemPrevClass = "GOL_OX3000_LR_FL";
    MRT_SwitchItemHintText = "OX3000 LR IR Illuminator";

    class ItemInfo: InventoryFlashLightItem_Base_F {
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
            intensity = 140;
            irLight = 1;
            volumeShape = "a3\data_f\VolumeLightFlashlight.p3d";
            scale[] = {0.25, 0.25, 1};
            class Attenuation {
                constant = 1;
                linear = 0;
                quadratic = 0.001;
                start = 1;
                hardLimitStart = 570;
                hardLimitEnd = 600;
            };
        };
    };
};

class GOL_OX3000_LR_FL: GOL_OX3000_LR {
    scope = 1;
    MRT_SwitchItemNextClass = "GOL_OX3000_LR_II";
    MRT_SwitchItemPrevClass = "GOL_OX3000_LR";
    MRT_SwitchItemHintText = "OX3000 LR Flashlight";

    class ItemInfo: InventoryFlashLightItem_Base_F {
        class Flashlight {
            color[] = {1, 1, 1};
            ambient[] = {0.1, 0.1, 0.1};
            size = 1;
            innerAngle = 10;
            outerAngle = 46;
            position = "laser pos";
            direction = "laser dir";
            useFlare = 0;
            flareSize = 1.4;
            flareMaxDistance = 120;
            coneFadeCoef = 8;
            intensity = 180;
            irLight = 0;
            volumeShape = "a3\data_f\VolumeLightFlashlight.p3d";
            scale[] = {0.25, 0.25, 1};
            class Attenuation {
                constant = 0.25;
                linear = 0.03;
                quadratic = 0.0018;
                start = 0.5;
                hardLimitStart = 55;
                hardLimitEnd = 65;
            };
        };
        class Pointer {};
    };
};
