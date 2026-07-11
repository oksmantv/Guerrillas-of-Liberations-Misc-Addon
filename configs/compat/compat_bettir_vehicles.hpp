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
            ambient[] = {0.08, 0.12, 0.08};   // Slightly more ambient
            intensity = 1.4;                  // +55% brightness (was 0.9)
            size = 1.2;                       // Slightly larger light
            innerAngle = 25;                  // Same tight beam
            outerAngle = 85;                  // Same wide spread
            coneFadeCoef = 4;                 // Same edge sharpness
            position = "Light_1_pos";
            direction = "Light_1_dir";
            hitpoint = "";
            selection = "";
            useFlare = 1;
            flareSize = 0.15;                 // Slightly more visible flare
            flareMaxDistance = 45;            // Flare visible further
            
            class Attenuation {
                start = 0;
                constant = 0;
                linear = 0;
                quadratic = 0.55;             // Slower falloff (was 1)
                hardLimitStart = 20;          // Starts fading further out (was 8)
                hardLimitEnd = 45;            // +59% range (was 22m)
            };
        };
    };
};

// Weapon-mounted illuminator - PATCHED FOR STRONGER FOCUSED BEAM
// This is what GOL_OX3000 will use via auto-activation
class BettIR_Illuminator_Weapon: BettIR_Illuminator_NVG {
    class Reflectors: Reflectors {
		/*
			Original Light

			class Light_1: Light_1
			{
				color[] = {160,120,80};
				innerAngle = 3;
				outerAngle = 15;
				coneFadeCoef = 6;
				intensity = 35;
				useFlare = 1;
				flareSize = 0.6;
				flareMaxDistance = 350;
				class Attenuation: Attenuation
				{
					start = 0.85;
					constant = 0;
					linear = 0;
					quadratic = 1;
					hardLimitStart = 280;
					hardLimitEnd = 350;
				};
			};

		*/

        class Light_1: Light_1 {
            // Enhanced from BettIR defaults - wider solid beam, extended range
            // Original: color {160,120,80}, inner 3, outer 15, intensity 35, quadratic 1, hardLimit 350
            color[] = {180, 130, 90};         // Brighter than original
            innerAngle = 5;                   // Wider than original (3) - fills center
            outerAngle = 15;                  // Wider spread for larger circle
            coneFadeCoef = 5;                 // Softer edge - helps fill center
            ambient[] = {0.1, 0.14, 0.1};     // Subtle ambient
            intensity = 70;                  // 75% increase from 60
            useFlare = 1;
            size = 1.3;
            flareSize = 0.6;
            flareMaxDistance = 200;
            
            class Attenuation {
                start = 0.85;
                constant = 0;
                linear = 0;
                quadratic = 0.05;             // Slower falloff for extended range
                hardLimitStart = 150;
                hardLimitEnd = 200;           // 75% increase from 95m
            };
        };
    };
};
