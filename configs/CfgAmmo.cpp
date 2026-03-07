class CfgAmmo {
    class rhs_ammo_9k38;
    class gol_ammo_9k38: rhs_ammo_9k38
	{
		displayName = "9K38 (Disabled ACE Guidance)";
		maneuvrability = 15;
		cmImmunity = 0.8;
		class ace_missileguidance {
			enabled = 0;                // Enable ACE guidance
			pitchRate = 15;             // Max pitch rate (deg/sec)
			yawRate = 15;               // Max yaw rate (deg/sec)
			canVanillaLock = 1;         // Disables vanilla lock
			defaultSeekerType = "IR";   // Set appropriate seeker type, e.g., "IR"
			seekerTypes[] = { "IR" };   // List allowed seeker types
			defaultSeekerLockMode = "LOBL"; // Lock-On After Launch (or "LOBL" for Before Launch)
			seekerAccuracy = 0.2;
			leadExponent = 1.5;
			leadMultiplier = 1.5;
			// You can add more ACE parameters as needed
		};
    };	

    class ammo_Missile_s750;
    class gol_ammo_s750_GOL: ammo_Missile_s750
	{
		displayName = "S750 - GOL";
		maneuvrability = 20;
		cmImmunity = 0.85;
		class ace_missileguidance {
			enabled = 0;                // Enable ACE guidance
			pitchRate = 15;             // Max pitch rate (deg/sec)
			yawRate = 15;               // Max yaw rate (deg/sec)
			canVanillaLock = 1;         // Disables vanilla lock
			defaultSeekerType = "IR";   // Set appropriate seeker type, e.g., "IR"
			seekerTypes[] = { "IR" };   // List allowed seeker types
			defaultSeekerLockMode = "LOBL"; // Lock-On After Launch (or "LOBL" for Before Launch)
			seekerAccuracy = 0.2;
			leadExponent = 1.5;
			leadMultiplier = 1.5;
			// You can add more ACE parameters as needed
		};
    };	

	// FPV throwables (soft dependency on BOT_FPV_Enhanced)
	class GrenadeHand;

	// Custom drone warhead classes (reduced lethality variants)
	class G_40mm_HE;
	class OKS_Drone_Warhead_Small: G_40mm_HE {
		hit = 80;
		indirectHit = 15;
		indirectHitRange = 6;
		// Ensure visible explosion effect
		explosionEffects = "GrenadeExplosion";
		CraterEffects = "GrenadeCrater";
		explosionSoundEffect = "DefaultExplosion";
		// Small warhead: effective against infantry, minimal vehicle damage
	};

	class R_PG7_F;
	class OKS_Drone_Warhead_Medium: R_PG7_F {
		hit = 180;
		indirectHit = 22;
		indirectHitRange = 8;
		// Medium warhead: can damage light vehicles, threatens infantry in ~8m radius
	};

	class OKS_Drone_Warhead_Large: R_PG7_F {
		hit = 400;
		indirectHit = 40;
		indirectHitRange = 12;
		// Large warhead: full lethality, equivalent to FPV_UA default
	};

	class GOL_Ammo_FPV_AT_Throw: GrenadeHand {
		model = "\fpv_ua\drone_pg7vl.p3d";
		// BOT_fnc_fpv_deploy selects by side index: [BLUFOR, OPFOR, INDEP, CIV].
		// UAFPV (PG7VL) variants
		BOT_vehicleSide[] = {"B_UAFPV_PG7VL_AT","O_UAFPV_PG7VL_AT","I_UAFPV_PG7VL_AT","B_UAFPV_PG7VL_AT"};
		GOL_spawnSetting = "GOL_DroneATClass";
		class EventHandlers {
			fired = "if !(isNil 'OKS_fnc_FPV_Deploy_Override') then { [_this#6] spawn OKS_fnc_FPV_Deploy_Override; } else { if !(isNil 'BOT_fnc_fpv_deploy') then { [_this#6] spawn BOT_fnc_fpv_deploy; }; };";
		};
	};

	class GOL_Ammo_FPV_AP_Throw: GrenadeHand {
		model = "\fpv_ua\drone_rkg.p3d";
		// UAFPV (RKG) variants
		BOT_vehicleSide[] = {"B_UAFPV_RKG_AP","O_UAFPV_RKG_AP","I_UAFPV_RKG_AP","B_UAFPV_RKG_AP"};
		GOL_spawnSetting = "GOL_DroneAPClass";
		class EventHandlers {
			fired = "if !(isNil 'OKS_fnc_FPV_Deploy_Override') then { [_this#6] spawn OKS_fnc_FPV_Deploy_Override; } else { if !(isNil 'BOT_fnc_fpv_deploy') then { [_this#6] spawn BOT_fnc_fpv_deploy; }; };";
		};
	};

	class GOL_Ammo_FPV_AP_OG7V_Throw: GrenadeHand {
		model = "\fpv_ua\drone_og7v.p3d";
		// UAFPV (OG7V) variants
		BOT_vehicleSide[] = {"B_UAFPV_OG7V_AP","O_UAFPV_OG7V_AP","I_UAFPV_OG7V_AP","B_UAFPV_OG7V_AP"};
		GOL_spawnSetting = "GOL_DroneAPClass";
		class EventHandlers {
			fired = "if !(isNil 'OKS_fnc_FPV_Deploy_Override') then { [_this#6] spawn OKS_fnc_FPV_Deploy_Override; } else { if !(isNil 'BOT_fnc_fpv_deploy') then { [_this#6] spawn BOT_fnc_fpv_deploy; }; };";
		};
	};

	class GOL_Ammo_FPV_AP_IED_Throw: GrenadeHand {
		model = "\fpv_ua\drone_ied.p3d";
		// UAFPV (IED) variants
		BOT_vehicleSide[] = {"B_UAFPV_IED_AP","O_UAFPV_IED_AP","I_UAFPV_IED_AP","B_UAFPV_IED_AP"};
		GOL_spawnSetting = "GOL_DroneAPClass";
		class EventHandlers {
			fired = "if !(isNil 'OKS_fnc_FPV_Deploy_Override') then { [_this#6] spawn OKS_fnc_FPV_Deploy_Override; } else { if !(isNil 'BOT_fnc_fpv_deploy') then { [_this#6] spawn BOT_fnc_fpv_deploy; }; };";
		};
	};

	// Drone disruptor pistol ammo - EMP pulses (no physical projectile)
	class B_9x21_Ball;
	class OKS_Ammo_DisruptorPulse: B_9x21_Ball {
		hit = 0;
		indirectHit = 0;
		indirectHitRange = 0;
		typicalSpeed = 1000;
		caliber = 0;
		airFriction = 0;
		
		// No visual tracer - completely invisible projectile
		model = "\A3\Weapons_f\empty";
		tracerScale = 0;
		tracerStartTime = 0;
		tracerEndTime = 0;
		nvgOnly = 0;
		
		// No shell casings ejected
		cartridge = "";
		
		// Silent impact - no physical projectile sounds
		soundHit[] = {"", 0, 1};
		soundFly[] = {"", 0, 1};
		supersonicCrackNear[] = {"", 0, 1};
		supersonicCrackFar[] = {"", 0, 1};
		
		// Override inherited bullet impact sounds (bullet1-bullet12)
		soundHit1[] = {"", 1, 1};
		soundHit2[] = {"", 1, 1};
		soundHit3[] = {"", 1, 1};
		soundHit4[] = {"", 1, 1};
		soundHit5[] = {"", 1, 1};
		soundHit6[] = {"", 1, 1};
		soundHit7[] = {"", 1, 1};
		soundHit8[] = {"", 1, 1};
		soundHit9[] = {"", 1, 1};
		soundHit10[] = {"", 1, 1};
		soundHit11[] = {"", 1, 1};
		soundHit12[] = {"", 1, 1};
	};

	// Custom 9.3mm tracer ammunition with different colors
	class B_93x64_Ball;
	
	class GOL_B_93x64_Ball_Tracer_Red: B_93x64_Ball {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_red";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	class GOL_B_93x64_Ball_Tracer_Green: B_93x64_Ball {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_green";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	class GOL_B_93x64_Ball_Tracer_Yellow: B_93x64_Ball {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_yellow";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	// Custom 7.62x54mmR tracer ammunition (RHS PKM/PKP)
	class rhs_B_762x54_Ball;
	
	class GOL_B_762x54_Ball_Tracer_Red: rhs_B_762x54_Ball {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_red";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	class GOL_B_762x54_Ball_Tracer_Green: rhs_B_762x54_Ball {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_green";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	// Custom .338 Norma Magnum tracer ammunition (MMG_02 SPMG)
	class B_338_Ball;
	
	class GOL_B_338_Ball_Tracer_Red: B_338_Ball {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_red";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	class GOL_B_338_Ball_Tracer_Green: B_338_Ball {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_green";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	// Custom 5.56mm AP45 ammunition (Nammo AP45 +25% ballistics)
	class B_556x45_Ball;
	
	class GOL_B_556x45_Ball_AP45: B_556x45_Ball {
		hit = 11;               // Superior stopping power (Mk262 is 10.3)
		indirectHit = 0;
		indirectHitRange = 0;
		caliber = 2.0;          // Superior armor penetration - AP45 armor-piercing core
		typicalSpeed = 1162.5;  // 930 m/s base + 25% = 1162.5 m/s
		airFriction = -0.00096; // Superior ballistic coefficient
		
		// ACE Advanced Ballistics
		ACE_caliber = 5.69;     // 5.56mm diameter
		ACE_bulletLength = 23.012; // AP45 bullet length in mm
		ACE_bulletMass = 5.2;   // 80gr - heavier than Mk262 (77gr) for more impact
		ACE_muzzleVelocityVariationSD = 0.4;
		ACE_ammoTempMuzzleVelocityShifts[] = {-26.55, -25.47, -22.85, -20.12, -16.98, -12.80, -7.64, -1.53, 5.96, 15.17, 26.19};
		ACE_ballisticCoefficients[] = {0.151}; // G7 BC from real AP45 data
		ACE_velocityBoundaries[] = {};
		ACE_standardAtmosphere = "ICAO";
		ACE_dragModel = 7;      // G7 drag model
		ACE_muzzleVelocities[] = {880, 915, 950, 1000, 1050, 1100, 1162.5};
		ACE_barrelLengths[] = {254, 292.1, 355.6, 406.4, 457.2, 508, 558.8}; // 10" to 22" barrels in mm
	};

	class GOL_B_556x45_Ball_AP45_Tracer_Red: GOL_B_556x45_Ball_AP45 {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_red";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	class GOL_B_556x45_Ball_AP45_Tracer_Green: GOL_B_556x45_Ball_AP45 {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_green";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	class GOL_B_556x45_Ball_AP45_Tracer_Yellow: GOL_B_556x45_Ball_AP45 {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_yellow";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	class GOL_Ammo_HandGrenade_Mini: GrenadeHand {
		hit = 8;
		indirectHit = 8;
		indirectHitRange = 4;
		explosionEffects = "MiniGrenadeExplosion";
		CraterEffects = "MiniGrenadeCrater";
	};
};
