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
};
