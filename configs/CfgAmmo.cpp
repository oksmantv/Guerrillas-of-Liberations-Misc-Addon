class CfgAmmo {
    class rhs_ammo_9k38;
    class gol_ammo_9k38: rhs_ammo_9k38
	{
		displayName = "9K38 (Disabled ACE Guidance)";
		maneuvrability = 15;
		cmImmunity = 0.8;
		class ace_missileguidance {
			enabled = 0;
			canVanillaLock = 1;
		};
    };	

    // Custom S750 ammo subclass — inherits everything, disables ACE guidance.
    class ammo_Missile_s750;
    class gol_ammo_s750_GOL: ammo_Missile_s750
	{
		displayName = "S750 - GOL";
		maneuvrability = 20;
		cmImmunity = 0.85;
		class ace_missileguidance {
			enabled = 0;
			canVanillaLock = 1;
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

	// Custom 7.62x51mm NATO M993 AP ammunition
	// Stats scaled from GOL_B_556x45_Ball_AP45 ×1.3 — tungsten AP core
	class B_762x51_Ball;

	class GOL_B_762x51_M993: B_762x51_Ball {
		hit = 16;               // AP45 hit (12) × 1.3
		indirectHit = 0;
		indirectHitRange = 0;
		caliber = 2.6;          // AP45 caliber (2.0) × 1.3 — tungsten AP core
		typicalSpeed = 960;     // M993 muzzle velocity (m/s)
		airFriction = -0.00086; // Better BC than 5.56 AP45

		// Suppress inherited white tracer from B_762x51_Ball — tracer variants handle this explicitly
		model = "\A3\Weapons_f\Data\bullettracer\tracer_white";
		tracerScale = 0;
		tracerStartTime = 100;
		tracerEndTime = 100;

		// ACE Advanced Ballistics
		ACE_caliber = 7.62;
		ACE_bulletLength = 29.0;  // M993 bullet length in mm
		ACE_bulletMass = 8.0;     // ~123gr tungsten AP core
		ACE_muzzleVelocityVariationSD = 0.4;
		ACE_ammoTempMuzzleVelocityShifts[] = {-24.0, -22.0, -20.0, -17.0, -14.0, -10.0, -5.0, 0.0, 6.0, 13.0, 22.0};
		ACE_ballisticCoefficients[] = {0.270}; // G7 BC
		ACE_velocityBoundaries[] = {};
		ACE_standardAtmosphere = "ICAO";
		ACE_dragModel = 7;
		ACE_muzzleVelocities[] = {780, 820, 860, 900, 935, 960};
		ACE_barrelLengths[] = {381, 457.2, 508, 558.8, 609.6, 660.4}; // 15" to 26" barrels in mm
	};

	class GOL_B_762x51_M993_Tracer_Red: GOL_B_762x51_M993 {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_red";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	class GOL_B_762x51_M993_Tracer_Green: GOL_B_762x51_M993 {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_green";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	// M993 SLAP — Saboted Light Armor Penetrator. Tungsten sub-caliber penetrator with sabot.
	// Extreme AP capability, trades raw hit for penetration.
	class GOL_B_762x51_M993_SLAP: GOL_B_762x51_M993 {
		hit = 18;               // Slightly lower raw damage — energy focused into penetrator
		caliber = 3.5;          // ~135% of .50 cal — defeats light APC armor
		typicalSpeed = 1020;    // Sabot increases muzzle velocity
		airFriction = -0.00080; // Sub-caliber penetrator has high BC

		// Suppress tracer — SLAP ball
		tracerScale = 0;
		tracerStartTime = 100;
		tracerEndTime = 100;

		// ACE Advanced Ballistics
		ACE_bulletMass = 5.2;   // ~80gr sub-caliber penetrator (lighter than M993)
		ACE_muzzleVelocities[] = {850, 890, 940, 980, 1000, 1020};
	};

	class GOL_B_762x51_M993_SLAP_Tracer_Red: GOL_B_762x51_M993_SLAP {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_red";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	class GOL_B_762x51_M993_SLAP_Tracer_Green: GOL_B_762x51_M993_SLAP {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_green";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	// Custom .338 Norma Magnum tracer ammunition (MMG_02 SPMG)
	class B_338_Ball;

	// .338 AP — 70% of .50 cal. Defeats BTR-60 class armor.
	class GOL_B_338_Ball_AP: B_338_Ball {
		hit = 21;               // damage kept at 70% of .50 cal (30)
		caliber = 1.65;         // ~63% of .50 cal (2.6) — penetrates light APC hulls
		typicalSpeed = 860;     // AP loadings typically slightly faster than ball
		airFriction = -0.00070; // Better BC than vanilla .338

		// Suppress inherited red tracer from B_338_Ball (it uses tracer_red by default)
		tracerScale = 0;
		tracerStartTime = 100;
		tracerEndTime = 100;

		// ACE Advanced Ballistics
		ACE_caliber = 8.6;
		ACE_bulletLength = 36.0;
		ACE_bulletMass = 16.8;  // ~260gr AP projectile
		ACE_muzzleVelocityVariationSD = 0.4;
		ACE_ballisticCoefficients[] = {0.310}; // G7 BC — AP bullet has high BC
		ACE_velocityBoundaries[] = {};
		ACE_standardAtmosphere = "ICAO";
		ACE_dragModel = 7;
		ACE_muzzleVelocities[] = {800, 830, 860};
		ACE_barrelLengths[] = {508, 558.8, 609.6};
	};

	class GOL_B_338_Ball_AP_Tracer_Red: GOL_B_338_Ball_AP {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_red";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};

	class GOL_B_338_Ball_AP_Tracer_Green: GOL_B_338_Ball_AP {
		model = "\A3\Weapons_f\Data\bullettracer\tracer_green";
		tracerScale = 1.2;
		tracerStartTime = 0.05;
		tracerEndTime = 2.5;
		nvgOnly = 0;
	};
	
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
		hit = 12;               // Superior stopping power (Mk262 is 10.3)
		indirectHit = 0;
		indirectHitRange = 0;
		caliber = 2.0;          // Superior armor penetration - AP45 armor-piercing core
		typicalSpeed = 1162.5;  // 930 m/s base + 25% = 1162.5 m/s
		airFriction = -0.00096; // Superior ballistic coefficient
		
		// ACE Advanced Ballistics
		ACE_caliber = 5.9;     // 5.56mm diameter
		ACE_bulletLength = 29.012; // AP45 bullet length in mm
		ACE_bulletMass = 6.2;   // 80gr - heavier than Mk262 (77gr) for more impact
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

	// ==================== SHORAD IR Missiles ====================
	// Parent: rhs_ammo_9k38 (RHS Igla MANPAD — proven base with correct
	// simulation, model, seeker and all engine-required properties)

	class gol_ammo_shorad_light: rhs_ammo_9k38 {
		displayName = "SHORAD IR Light (GOL)";
		maneuvrability = 18;
		cmImmunity = 0.35;
		class ace_missileguidance {
			enabled = 0;
			canVanillaLock = 1;
		};
	};

	class gol_ammo_shorad_medium: rhs_ammo_9k38 {
		displayName = "SHORAD IR Medium (GOL)";
		maneuvrability = 15;
		cmImmunity = 0.55;
		class ace_missileguidance {
			enabled = 0;
			canVanillaLock = 1;
		};
	};

	class gol_ammo_shorad_heavy: rhs_ammo_9k38 {
		displayName = "SHORAD IR Heavy (GOL)";
		maneuvrability = 12;
		cmImmunity = 0.75;
		class ace_missileguidance {
			enabled = 0;
			canVanillaLock = 1;
		};
	};

	// ==================== GOL Accurate RPG-7 Rounds ====================
	// LEFT reticle (VM markings): PG-7VM (HEAT+)
	// RIGHT reticle (VL markings): OG-7V, TBG-7V, PG-7VR
	class rhs_rpg7v2_pg7vm;
	class rhs_rpg7v2_pg7vl;

	// Improved HEAT (HEAT+) — VM base +25% main charge. Inherits VM submunition (penetrator hit=290).
	class GOL_ammo_Modern: rhs_rpg7v2_pg7vm {
		deflecting = 0;
		hit = 275;        // VM original (220) +25%
		explosive = 0.35;
	};

	// --- RIGHT reticle group (VL trajectory) ---

	// OG-7V — HE fragmentation
	class GOL_ammo_OG7V: rhs_rpg7v2_pg7vl {
		deflecting = 0;
		hit = 75;
		indirectHit = 20;
		indirectHitRange = 15;
		model = "\rhsafrf\addons\rhs_weapons\rpg7\projectiles\og7v";
		CraterEffects = "HEShellCrater";
		CraterWaterEffects = "ImpactEffectsWaterHE";
		warheadName = "HE";
		explosive = 1;
		ace_frag_charge = 210;
		ace_frag_classes[] = {"ACE_frag_medium_HD"};
		ace_frag_force = 1;
		ace_frag_gurney_c = 2800;
		ace_frag_gurney_k = 0.6;
		ace_frag_metal = 400;
		ace_frag_skip = 0;
		ace_vehicle_damage_incendiary = 0.1;
	};

	// TBG-7V — thermobaric
	class GOL_ammo_TBG7V: rhs_rpg7v2_pg7vl {
		deflecting = 0;
		hit = 120;
		indirectHit = 60;
		indirectHitRange = 12;
		model = "\rhsafrf\addons\rhs_weapons\rpg7\projectiles\tbg7v";
		explosionEffects = "RHS_FAE_Explosion";
		CraterEffects = "ArtyShellCrater";
		warheadName = "HE";
		explosive = 1;
		ACE_damageType = "explosive";
		ace_frag_enabled = 0;
		ace_frag_force = 0;
		ace_frag_skip = 1;
		ace_vehicle_damage_incendiary = 0.7;
		triggerOnImpact = 1;
		submunitionAmmo = "rhs_ammo_thermobaric_wave";
		submunitionAutoleveling = 1;
		submunitionConeAngle[] = {120, 220};
		submunitionConeAngleHorizontal = 720;
		submunitionConeType[] = {"randomupcone", 15};
		submunitionDirectionType = "SubmunitionModelDirection";
		submunitionInitialOffset[] = {0, 0, -0.4};
		submunitionInitSpeed = 200;
		submunitionParentSpeedCoef = 0;
	};

	// PG-7VR penetrator — custom subclass so we can tune damage independently of VM's penetrator
	class rhs_rpg7v2_pg7vr_penetrator;
	class GOL_ammo_PG7VR_penetrator: rhs_rpg7v2_pg7vr_penetrator {
		hit = 420;        // ~45% above VM penetrator (290) — meaningful advantage post-ERA
	};

	// PG-7VR — tandem HEAT (ERA-defeating)
	class GOL_ammo_PG7VR: rhs_rpg7v2_pg7vl {
		deflecting = 0;
		hit = 310;        // Higher than Improved HEAT (275) — VR is the harder hitter
		indirectHit = 20;
		indirectHitRange = 3.8;
		initTime = 0.15;
		warheadName = "TandemHEAT";
		triggerOnImpact = 1;
		model = "\rhsafrf\addons\rhs_weapons\rpg7\projectiles\pg7vr";
		explosionEffects = "ATRocketExplosion";
		CraterEffects = "ATRocketCrater";
		submunitionAmmo = "GOL_ammo_PG7VR_penetrator";
		submunitionDirectionType = "SubmunitionModelDirection";
		submunitionInitSpeed = 1053;
		submunitionInitialOffset[] = {0, 0, -0.1};
		submunitionParentSpeedCoef = 0;
	};
};
