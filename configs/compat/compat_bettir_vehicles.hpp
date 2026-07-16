// BettIR vehicle patches - patches BettIR's light objects for stronger illumination.
// This file is included from CfgVehicles.cpp (inside the CfgVehicles class).
// Only loaded when BettIR is present (controlled by skipWhenMissingDependencies in CfgPatches).

class Lamps_base_F;

// NVG-mounted illuminator - PATCHED TO BE STRONGER
class BettIR_Illuminator_NVG: Lamps_base_F {
    class Reflectors {
        class Light_1 {
            // Increased from default: color {70,40,60}, intensity 0.9, range 22m
            color[] = {100, 60, 80};          // Brighter pink/purple IR color
            ambient[] = {0.8, 0.12, 0.08};   // Slightly more ambient
            intensity = 1.4;                  // +55% brightness (was 0.9)
            size = 1.2;                       // Slightly larger light
            innerAngle = 35;                  // Same tight beam
            outerAngle = 85;                  // Same wide spread
            coneFadeCoef = 4;                 // Same edge sharpness
            position = "Light_1_pos";
            direction = "Light_1_dir";
            hitpoint = "";
            selection = "";
            useFlare = 1;
            flareSize = 0.05;                 // Slightly more visible flare
            flareMaxDistance = 45;            // Flare visible further
            
            class Attenuation {
                start = 0;
                constant = 0;
                linear = 0;
                quadratic = 0.40;             // Slower falloff (was 1)
                hardLimitStart = 15;          // Starts fading further out (was 8)
                hardLimitEnd = 55;            // +59% range (was 22m)
            };
        };
    };
};

// Weapon-mounted illuminator - PATCHED FOR STRONGER FOCUSED BEAM
// This is what GOL_OX3000 will use via auto-activation
// Base class at 100% strength
class BettIR_Illuminator_Weapon: BettIR_Illuminator_NVG {
    class Reflectors: Reflectors {

        class Light_1: Light_1 {
            // Enhanced from BettIR defaults - wider solid beam, extended range
            // Original: color {160,120,80}, inner 3, outer 15, intensity 35, quadratic 1, hardLimit 350
            color[] = {180, 130, 90};         // Brighter than original
            innerAngle = 3.5;                   // Smaller solid center for more gradient zone
            outerAngle = 15;                  // Wider outer edge for smooth bleed
            coneFadeCoef = 1.5;                 // Very soft edge - smooth transition (was 5)
            ambient[] = {0.1, 0.14, 0.1};     // Subtle ambient
            intensity = 60;                   // Reduced by 15% from 70 (100% strength)
            useFlare = 1;
            size = 1.3;
            flareSize = 0.6;
            flareMaxDistance = 200;
            
            class Attenuation {
                start = 0.85;
                constant = 0;
                linear = 0;
                quadratic = 0.0015;             // Slower falloff for extended range
                hardLimitStart = 15;
                hardLimitEnd = 50;           // 75% increase from 95m
            };
        };
    };
};

// Adjustable strength variants (1%, 1.5%, 2%, 2.5%, 3%)
class BettIR_Illuminator_Weapon_1: BettIR_Illuminator_Weapon {
    class Reflectors: Reflectors {
        class Light_1: Light_1 {
            intensity = 0.6;    // 1% of 60 - Low mode
            size = 0.2;         // Minimal size for ultra-low bloom
            ambient[] = {0.003, 0.003, 0.003};  // Ultra-minimal ambient
            
            class Attenuation: Attenuation {
                quadratic = 0.006;          // Very high falloff - CQB range only
                hardLimitStart = 15;
                hardLimitEnd = 30;          // Short range for stealth
            };
        };
    };
};

class BettIR_Illuminator_Weapon_1_5: BettIR_Illuminator_Weapon {
    class Reflectors: Reflectors {
        class Light_1: Light_1 {
            intensity = 0.9;    // 1.5% of 60 - Medium mode
            size = 0.25;        // Very small for minimal bloom
            ambient[] = {0.005, 0.005, 0.005};  // Minimal ambient
            
            class Attenuation: Attenuation {
                quadratic = 0.004;          // High falloff - short-medium range
                hardLimitStart = 20;
                hardLimitEnd = 35;
            };
        };
    };
};

class BettIR_Illuminator_Weapon_2: BettIR_Illuminator_Weapon {
    class Reflectors: Reflectors {
        class Light_1: Light_1 {
            intensity = 1.2;    // 2% of 60 - High mode
            size = 0.3;         // Small size
            ambient[] = {0.007, 0.007, 0.007};  // Low ambient
            
            class Attenuation: Attenuation {
                quadratic = 0.003;          // Medium falloff - medium range
                hardLimitStart = 25;
                hardLimitEnd = 40;
            };
        };
    };
};

class BettIR_Illuminator_Weapon_2_5: BettIR_Illuminator_Weapon {
    class Reflectors: Reflectors {
        class Light_1: Light_1 {
            intensity = 1.5;    // 2.5% of 60 - Very High mode (extended)
            size = 0.35;        // Small-medium size
            ambient[] = {0.01, 0.01, 0.01};  // Low-medium ambient
            
            class Attenuation: Attenuation {
                quadratic = 0.002;          // Medium-low falloff - extended range
                hardLimitStart = 30;
                hardLimitEnd = 45;
            };
        };
    };
};

class BettIR_Illuminator_Weapon_3: BettIR_Illuminator_Weapon {
    class Reflectors: Reflectors {
        class Light_1: Light_1 {
            intensity = 1.5;    // 2.5% of 60 - reduced from 1.8 to reduce bloom
            size = 0.35;        // Reduced from 0.4 to reduce washout
            ambient[] = {0.01, 0.01, 0.01};  // Reduced from 0.012
            
            class Attenuation: Attenuation {
                quadratic = 0.0015;         // Low falloff - maximum range
                hardLimitStart = 35;
                hardLimitEnd = 50;
            };
        };
    };
};
