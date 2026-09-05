class Mode_FullAuto;
class Mode_SemiAuto;
class CfgWeapons {
	class CMFlareLauncher;
	class GOL_CMFlareLauncher_Visible: CMFlareLauncher {
		scope = 2;
		displayName = "Parachute Flare Launcher";
		descriptionShort = "Parachute Flare support. Single flare every 2 seconds.";
		muzzles[] = {"this"};
		magazines[] = {"GOL_250Rnd_CMFlare_Visible_Mag"};
		modes[] = {"Single"};

		class Single: Mode_SemiAuto {
			displayName = "Illumination (White)";
			burst = 1;
			reloadTime = 2.0;
			autoFire = 0;
			soundBurst = 0;
			sounds[] = {"StandardSound"};
			class StandardSound {
				soundSetShot[] = {"UGL_shot_SoundSet","UGL_Tail_SoundSet","UGL_InteriorTail_SoundSet"};
			};
			class SilencedSound {
				soundSetShot[] = {"UGL_shot_SoundSet","UGL_Tail_SoundSet","UGL_InteriorTail_SoundSet"};
			};
		};
	};

	class GOL_CMFlareLauncher_IR: CMFlareLauncher {
		scope = 2;
		displayName = "Parachute Flare Launcher (IR)";
		descriptionShort = "IR support flare dropper. Single flare every 2 seconds.";
		muzzles[] = {"this"};
		magazines[] = {"GOL_250Rnd_CMFlare_IR_Mag"};
		modes[] = {"Single"};

		class Single: Mode_SemiAuto {
			displayName = "Illumination (IR)";
			burst = 1;
			reloadTime = 2.0;
			autoFire = 0;
			soundBurst = 0;
			sounds[] = {"StandardSound"};
			class StandardSound {
				soundSetShot[] = {"UGL_shot_SoundSet","UGL_Tail_SoundSet","UGL_InteriorTail_SoundSet"};
			};
			class SilencedSound {
				soundSetShot[] = {"UGL_shot_SoundSet","UGL_Tail_SoundSet","UGL_InteriorTail_SoundSet"};
			};
		};
	};

	#include "CfgWeapons_AIStatics.hpp"
	#include "CfgWeapons_Items.hpp"
	#include "CfgWeapons_Launchers.hpp"
	#include "CfgWeapons_Armor3CB.hpp"
	#include "CfgWeapons_ArmorRHS.hpp"

	// Drone jammer pistol (inspired by Contact DLC ESD)
	// Drone Disruptor Pistol - Kills drone crew via cone detection
	class Pistol_Base_F;
	class OKS_DroneDisruptor_Pistol: Pistol_Base_F {
		scope = 2;
		scopeArsenal = 2;
		scopeCurator = 2;
		author = "OksmanTV from Guerrillas of Liberation";
		displayName = "Drone Disruptor Pistol";
		descriptionShort = "Electromagnetic pulse weapon. Fires directed energy to disable drones within 200m cone.";
		
		// Visual model from Contact DLC ESD
		model = "\A3\Weapons_F_Enoch\Pistols\ESD_01\ESD_01_F.p3d";
		picture = "\a3\weapons_f_enoch\pistols\esd_01\data\ui\gear_esd_01_ca.paa";
		
		// Base weapon reference for attachments
		baseWeapon = "OKS_DroneDisruptor_Pistol";
		
		magazines[] = {"OKS_Mag_DroneDisruptor"};
		
		// Force crosshair to show (weapon has no iron sights)
		showAimCursorInternal = 1;
		
		// Disable all attachment slots except muzzle
		class WeaponSlotsInfo {
			mass = 20;
			
			// Only allow custom antenna in muzzle slot
			class MuzzleSlot {
				linkProxy = "\A3\data_f\proxies\weapon_slots\MUZZLE";
				compatibleItems[] = {"OKS_Disruptor_Antenna"};
				iconPosition[] = {0, 0.4};
				iconScale = 0.2;
			};
			
			// Disable all other slots
			class CowsSlot {};
			class PointerSlot {};
			class UnderBarrelSlot {};
		};
		
		// Override inherited multi-muzzle system - this is a single muzzle weapon
		Muzzle_Base[] = {};
		muzzle_1[] = {};
		muzzle_2[] = {};
		muzzle_3[] = {};
		muzzle_4[] = {};
		muzzle_5[] = {};
		muzzle_6[] = {};
		muzzle_7[] = {};
		muzzle_8[] = {};
		muzzle_9[] = {};
		muzzle_10[] = {};
		muzzle_11[] = {};
		muzzle_12[] = {};
		bullet1[] = {};
		bullet2[] = {};
		bullet3[] = {};
		bullet4[] = {};
		bullet5[] = {};
		bullet6[] = {};
		bullet7[] = {};
		bullet8[] = {};
		bullet9[] = {};
		bullet10[] = {};
		bullet11[] = {};
		bullet12[] = {};		
		muzzles[] = {"this"};
		reloadAction = "GestureReloadPistolHeavy02";
		
		// Override muzzle effects - energy weapon has no visible muzzle flash or smoke
		class GunClouds {
			access = 0;
			cloudletDuration = 0;
			cloudletAnimPeriod = 0;
			cloudletSize = 0;
			cloudletAlpha = 0;
			cloudletGrowUp = 0;
			cloudletFadeIn = 0;
			cloudletFadeOut = 0;
			cloudletAccY = 0;
			cloudletMinYSpeed = 0;
			cloudletMaxYSpeed = 0;
			cloudletShape = "";
			cloudletColor[] = {0, 0, 0, 0};
			interval = 0;
			size = 0;
			sourceSize = 0;
			initT = 0;
			deltaT = 0;
			class Table {};
		};
		class GunFire {
			access = 0;
			cloudletDuration = 0;
			cloudletAnimPeriod = 0;
			cloudletSize = 0;
			cloudletAlpha = 0;
			cloudletGrowUp = 0;
			cloudletFadeIn = 0;
			cloudletFadeOut = 0;
			cloudletAccY = 0;
			cloudletMinYSpeed = 0;
			cloudletMaxYSpeed = 0;
			cloudletShape = "";
			cloudletColor[] = {0, 0, 0, 0};
			interval = 0;
			size = 0;
			sourceSize = 0;
			initT = 0;
			deltaT = 0;
			class Table {};
		};
		class GunParticles {};
		
		// Remove shell casing ejection - energy weapon has no physical casings
		magazineReloadSwitchPhase = 0;
		drySound[] = {"", 1, 1};
		reloadMagazineSound[] = {"", 1, 1};
		
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
		
		modes[] = {"Single"};
		class Single {
			displayName = "Single";
			textureType = "semi";
			burst = 1;
			reloadTime = 2.0;
			dispersion = 0.001;
			multiplier = 1;
			autoFire = 0;
			soundContinuous = 0;
			soundBurst = 0;
			useAction = 0;
			useActionTitle = "";
			showToPlayer = 1;
			artilleryDispersion = 0;
			artilleryCharge = 0;
			minRange = 2;
			minRangeProbab = 0.3;
			midRange = 100;
			midRangeProbab = 0.7;
			maxRange = 200;
			maxRangeProbab = 0.05;
			aiRateOfFire = 2;
			aiRateOfFireDistance = 100;
			recoil = "recoil_pistol_light";
			recoilProne = "recoil_prone_pistol_light";
			// Override inherited bullet impact sounds - energy weapon has no physical impact
			soundBullet[] = {};
			
			sounds[] = {"StandardSound"};
			class StandardSound {
				// Custom EMP weapon firing sound
				// Place your .ogg file at: OKS_GOL_Misc\Sounds\disruptor_fire.ogg
				begin1[] = {"\OKS_GOL_Misc\Sounds\disruptor_fire.ogg", 1.5, 1, 500};
				soundBegin[] = {"begin1", 1};
				weaponSoundEffect = "";
			};
		};
		
		class EventHandlers {
			fired = "_this call OKS_fnc_DroneDisruptor_Fired;";
		};
	};

	// Custom antenna attachment for disruptor (cosmetic only, no sound suppression)
	class InventoryMuzzleItem_Base_F;
	class muzzle_antenna_02_f;
	class OKS_Disruptor_Antenna: muzzle_antenna_02_f {
		scope = 2;
		scopeArsenal = 2;
		author = "OksmanTV from Guerrillas of Liberation";
		displayName = "Long-Range EMP Antenna (+250m)";
		descriptionShort = "Extends disruptor effective range by 250m. Total range: 750m.";
		
		// Override suppressor behavior - this is purely cosmetic
		class ItemInfo: InventoryMuzzleItem_Base_F {
			mass = 2;
			soundTypeIndex = 0;
			muzzleEnd = "zaslehPoint";
			alternativeFire = "Zasleh2";
			class MagazineCoef {
				initSpeed = 1.0;
			};
			class AmmoCoef {
				hit = 1.0;
				visibleFire = 1.0;
				audibleFire = 1.0;
				visibleFireTime = 1.0;
				audibleFireTime = 1.0;
				cost = 1.0;
				typicalSpeed = 1.0;
				airFriction = 1.0;
			};
			class MuzzleCoef {
				dispersionCoef = 1.0;
				artilleryDispersionCoef = 1.0;
				fireLightCoef = 1.0;
				recoilCoef = 1.0;
				recoilProneCoef = 1.0;
				minRangeCoef = 1.0;
				minRangeProbabCoef = 1.0;
				midRangeCoef = 1.0;
				midRangeProbabCoef = 1.0;
				maxRangeCoef = 1.0;
				maxRangeProbabCoef = 1.0;
			};
		};
	};

	// FPV throwables (soft dependency on BOT_FPV_Enhanced)
	class GrenadeLauncher;
	class Throw: GrenadeLauncher {
		Muzzles[] += {"GOL_MiniGrenadeMuzzle","GOL_Weapon_FPV_AT_Throw","GOL_Weapon_FPV_AP_Throw","GOL_Weapon_FPV_AP_OG7V_Throw","GOL_Weapon_FPV_AP_IED_Throw"};

		class ThrowMuzzle: GrenadeLauncher {};
		class GOL_MiniGrenadeMuzzle: ThrowMuzzle {
			magazines[] = {"GOL_HandGrenade_Mini"};
		};

		class GOL_Weapon_FPV_base: ThrowMuzzle {};
		class GOL_Weapon_FPV_AT_Throw: GOL_Weapon_FPV_base {
			magazines[] = {"GOL_Mag_FPV_AT_Throw"};
		};
		class GOL_Weapon_FPV_AP_Throw: GOL_Weapon_FPV_base {
			magazines[] = {"GOL_Mag_FPV_AP_Throw"};
		};
		class GOL_Weapon_FPV_AP_OG7V_Throw: GOL_Weapon_FPV_base {
			magazines[] = {"GOL_Mag_FPV_AP_OG7V_Throw"};
		};
		class GOL_Weapon_FPV_AP_IED_Throw: GOL_Weapon_FPV_base {
			magazines[] = {"GOL_Mag_FPV_AP_IED_Throw"};
		};
	};

	// --- GOL BMP-2D custom weapons (enable vanilla FCS auto-range) ---
	// Split into two single-muzzle weapons (muzzles={"this"}) so parent-level
	// bc=18 IS the effective muzzle-level value. This avoids the cross-PBO
	// inner-class corruption that occurs when overriding HE/AP inside a child.
	class rhs_weap_2a42;
	class GOL_weap_2a42_HE: rhs_weap_2a42 {
		ballisticsComputer = 18;
		muzzles[] = {"this"};
		magazineWell[] = {"RHS_AutoCannon_30mm_2A42_HE"};
		displayName = "2A42 HE";
		dispersion = 0.0004;
	};
	class GOL_weap_2a42_AP: rhs_weap_2a42 {
		ballisticsComputer = 18;
		muzzles[] = {"this"};
		magazineWell[] = {"RHS_AutoCannon_30mm_2A42_AP"};
		displayName = "2A42 AP";
		dispersion = 0.0004;
	};

	class rhs_weap_pkt;
	class GOL_weap_pkt: rhs_weap_pkt {
		ballisticsComputer = 18;
		dispersion = 0.0006;
	};

	// AP45 Compatibility patches
	// NOTE: UK3CB Factions (ACR/M16/G36/AUG) AP45 mags handled via CfgMagazineWells.
	// JCA HK437 5.56 conversion is in compat_jca.hpp (soft dependency via GOL_MISC_COMPAT_JCA).
	#include "compat\compat_vanilla.hpp"
	#include "compat\compat_rhs.hpp"
	#include "compat\compat_uk3cb.hpp"
	#include "compat\compat_uk3cb_factions.hpp"
	#include "compat\compat_jca.hpp"
	#include "compat\compat_ace_irlight.hpp"
	#include "CfgWeapons_MachineGuns.hpp"

        // ============================================================
        // GOL M230 30mm Chain Gun Pod
        //
        // A helicopter pylon-mounted single-barrel 30mm chain gun.
        // Two player-selectable fire modes:
        //   HighROF — 650 RPM (reloadTime ≈ 0.0923 s)
        //   LowROF  — 300 RPM (reloadTime = 0.2 s)
        //
        // Compatible with any pylon using the "DAR" or
        // "GOL_M230_CHAINGUN" hardpoint (see CfgMagazines).
        // ============================================================
        class rhs_weap_M230;

        class GOL_weapon_M230_ChainGun: rhs_weap_M230 {
                scope = 2;
                author = "Guerrillas of Liberation";
                displayName = "M230 30mm Chain Gun Pod";
                descriptionShort = "M230 30mm chain gun pod | 650 RPM full-auto / 300 RPM burst | load GOL_PylonWeapon_M230_AP for AP ammo";
                magazineReloadTime = 0.1;
                canLock = 0;
                ballisticsComputer = 26;    // 2 (CCIP) + 8 (FCS optics cursor) + 16 (FCS zeroing)
				showToPlayer = 1;
                aiDispersionCoefY = 0.5;
                aiDispersionCoefX = 0.5;
				cartridgePos = "nabojnicestart";
				cartridgeVel = "nabojniceend";
				muzzleEnd = "machinegun_end";
				muzzlePos = "machinegun_beg";
				selectionFireAnim = "zasleh";
                soundSetShot[] = {"RHSUSF_M230_Shot_SoundSet"};
                rhs_burstLimiter = 1200;
                magazines[] = {
					"GOL_PylonWeapon_M230_HE",
					"GOL_PylonWeapon_M230_AP",
					"GOL_PylonWeapon_M230_HE_L",
					"GOL_PylonWeapon_M230_AP_L"
                };
                modes[] = {"HighROF", "LowROF", "close", "short", "medium", "far"};

                class GunParticles {
					class Effect1 {
						directionName = "machinegun_eject_dir";
						effectName = "MachineGunCartridge";
						positionName = "machinegun_eject_pos";
					};
					class FirstEffect {
						directionName = "machinegun_beg";
						effectName = "MachineGun2";
						positionName = "machinegun_end";
					};
					class SecondEffect {
						directionName = "machinegun_beg";
						effectName = "MachineGun2";
						positionName = "machinegun_end";
					};										
                };

                // 650 RPM
                class HighROF: Mode_FullAuto {
                        displayName = "650 RPM";
                        autoFire = 1;
                        burst = 0;
                        soundSetShot[] = {"RHSUSF_M230_Shot_SoundSet"};
                        class StandardSound { soundSetShot[] = {"RHSUSF_M230_Shot_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {"RHSUSF_M230_Shot_SoundSet"}; };
                        flash = "gunfire";
                        flashSize = 0.1;
                        recoil = "Empty";
                        ffMagnitude = 0.25;
                        ffFrequency = 10;
                        ffCount = 6;
                        reloadTime = 0.0923;
                        dispersion = 0.0012;
                        showToPlayer = 1;
                        aiRateOfFire = 1;
                        aiRateOfFireDistance = 10;
                        minRange = 0;
                        minRangeProbab = 0.01;
                        midRange = 1;
                        midRangeProbab = 0.01;
                        maxRange = 2;
                        maxRangeProbab = 0.01;
						rhs_burstLimiter = 1200;
                };

                // 300 RPM
                class LowROF: Mode_SemiAuto {
                        displayName = "300 RPM";
                        autoFire = 1;
                        burst = 10;
                        soundSetShot[] = {"RHSUSF_M230_Shot_SoundSet"};
                        class StandardSound { soundSetShot[] = {"RHSUSF_M230_Shot_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {"RHSUSF_M230_Shot_SoundSet"}; };
                        flash = "gunfire";
                        flashSize = 0.1;
                        recoil = "Empty";
                        ffMagnitude = 0.25;
                        ffFrequency = 10;
                        ffCount = 6;
                        reloadTime = 0.2;
                        dispersion = 0.0012;
                        showToPlayer = 1;
                        aiRateOfFire = 1;
                        aiRateOfFireDistance = 10;
                        minRange = 0;
                        minRangeProbab = 0.01;
                        midRange = 1;
                        midRangeProbab = 0.01;
                        maxRange = 2;
                        maxRangeProbab = 0.01;
						rhs_burstLimiter = 1200;
                };
        };

        // ============================================================
        // GOL "Terror GMG" — same-model GMG/Mk19 weapons re-tuned for AI
        // gunners on enemy vehicles: 2-round bursts with a long pause
        // between them (aiRateOfFire = 6s), ~3x vanilla dispersion, and
        // reduced HE blast/damage (see GOL_ammo_* in CfgAmmo.cpp — rare
        // direct hits stay dangerous, splash is toned down).
        //
        // Swapped in at runtime by fn_RemoveVehicleHE.sqf. The vanilla
        // base classes (GMG_40MM, RHS_MK19, RHS_MK19_CROWS_M153,
        // UK3CB_Factions_MK19) are left untouched, so this only affects
        // vehicles the script has processed — AI-crewed enemy vehicles.
        // ============================================================

        // NOTE: internal same-name mode inheritance (class manual: manual {})
        // does NOT resolve in this addon's build pipeline — "manual" (etc.)
        // comes back as an undefined base class. Every fire mode below is
        // therefore a full standalone redefinition inheriting the global
        // Mode_FullAuto base, with every value that mattered (displayName,
        // reloadTime, aiRateOfFireDistance) copied from the real vanilla/RHS
        // class via the docs/gmg_terror_dump.sqf dump, plus our overrides
        // (dispersion ~3x, burst=2, aiRateOfFire=6 for the pause).
        //
        // autoFire=1 is REQUIRED here — autoFire=0 (true "stop after N
        // rounds, wait for a new fire decision") made AI vehicle gunners
        // refuse to ever select/fire these modes. autoFire=1 + burst=2 is
        // the only pattern confirmed to make AI actually use a burst on a
        // turret weapon in this codebase (see M230 LowROF in CfgWeapons.cpp
        // and /memories/repo/m230-chaingun.md). aiRateOfFire=6 still forces
        // the pause between burst groups.
        class GMG_40MM : MGun {
			class Manual;
			class close;
			class short;
			class medium;
			class far;
		};
        class GOL_weap_GMG40MM_Terror: GMG_40MM {
                scope = 2;
                displayName = "GMG 40mm (Suppressive)";
                dispersion = 0.03;
				aiBurstTerminable=1;
                magazines[] = {"GOL_mag_GMG40MM_200","GOL_mag_GMG40MM_96","GOL_mag_GMG40MM_64","GOL_mag_GMG40MM_32"};

                class manual: Mode_FullAuto {
                        displayName = "Mk 19"; 
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.171429; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 10;
                        class StandardSound { soundSetShot[] = {"GMG40mm_Shot_SoundSet","GMG40mm_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class close: Mode_FullAuto {
                        displayName = "Mk 19";
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.171429; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 50;
                        class StandardSound { soundSetShot[] = {"GMG40mm_Shot_SoundSet","GMG40mm_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class short: Mode_FullAuto {
                        displayName = "Mk 19"; 
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.171429; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 150;
                        class StandardSound { soundSetShot[] = {"GMG40mm_Shot_SoundSet","GMG40mm_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class medium: Mode_FullAuto {
                        displayName = "Mk 19"; 
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.171429; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 400;
                        class StandardSound { soundSetShot[] = {"GMG40mm_Shot_SoundSet","GMG40mm_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class far: Mode_FullAuto {
                        displayName = "Mk 19"; 
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.171429; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 1000;
                        class StandardSound { soundSetShot[] = {"GMG40mm_Shot_SoundSet","GMG40mm_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
        };
		class GMG_20mm;
        class RHS_MK19 : GMG_20mm {
			class manual;
			class close;
			class short;
			class medium;
			class far;
		};
        class GOL_weap_MK19_Terror: RHS_MK19 {
                scope = 2;
                displayName = "Mk19 (Suppressive)";
                dispersion = 0.03;
				aiBurstTerminable=1;
                magazines[] = {
                        "GOL_mag_MK19_48_M384","GOL_mag_MK19_48_M1001","GOL_mag_MK19_48_M430I","GOL_mag_MK19_48_M430A1",
                        "GOL_mag_MK19_96_M384","GOL_mag_MK19_96_M1001","GOL_mag_MK19_96_M430I","GOL_mag_MK19_96_M430A1"
                };

                class manual: manual {
                        displayName = "Mk. 19 Grenade Launcher";
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1;
						reloadTime = 0.15; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 500;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class close: close {
                        displayName = "Mk. 19 Grenade Launcher"; 
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1;
						reloadTime = 0.15;
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 50;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class short: short {
                        displayName = "Mk. 19 Grenade Launcher"; dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.15; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 300;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class medium: medium {
                        displayName = "Mk. 19 Grenade Launcher"; dispersion = 0.03;
						aiBurstTerminable=1;burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.15; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 600;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class far: far {
                        displayName = "Mk. 19 Grenade Launcher"; dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.15; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 1000;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
        };

        class RHS_MK19_CROWS_M153 : RHS_MK19 {};
        class GOL_weap_MK19_CROWS_Terror: RHS_MK19_CROWS_M153 {
                scope = 2;
                displayName = "Mk19 CROWS (Suppressive)";
                dispersion = 0.03;
				aiBurstTerminable=1;
                magazines[] = {
                        "GOL_mag_MK19_48_M384","GOL_mag_MK19_48_M1001","GOL_mag_MK19_48_M430I","GOL_mag_MK19_48_M430A1",
                        "GOL_mag_MK19_96_M384","GOL_mag_MK19_96_M1001","GOL_mag_MK19_96_M430I","GOL_mag_MK19_96_M430A1"
                };

                class manual: manual {
                        displayName = "Mk. 19 Grenade Launcher"; 
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.15; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 500;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class close: close {
                        displayName = "Mk. 19 Grenade Launcher"; 
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.15; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 50;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class short: short {
                        displayName = "Mk. 19 Grenade Launcher"; 
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.15; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 300;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class medium: medium {
                        displayName = "Mk. 19 Grenade Launcher"; 
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.15; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 600;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class far: far {
                        displayName = "Mk. 19 Grenade Launcher";
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.15; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 1000;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
        };

        class UK3CB_Factions_MK19 : RHS_MK19 {};
        class GOL_weap_MK19_UK3CB_Terror: UK3CB_Factions_MK19 {
                scope = 2;
                displayName = "Mk19 (Suppressive)";
                dispersion = 0.03;
				aiBurstTerminable=1;
                magazines[] = {
                        "GOL_mag_MK19_48_M384","GOL_mag_MK19_48_M1001","GOL_mag_MK19_48_M430I",
                        "GOL_mag_MK19_96_M384","GOL_mag_MK19_96_M1001","GOL_mag_MK19_96_M430I"
                };

                class manual: manual {
                        displayName = "Mk. 19 Grenade Launcher"; 
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.15; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 500;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class close: close {
                        displayName = "Mk. 19 Grenade Launcher"; 
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.15; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 50;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class short: short {
                        displayName = "Mk. 19 Grenade Launcher"; 
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.15; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 300;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class medium: medium {
                        displayName = "Mk. 19 Grenade Launcher"; 
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.15; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 600;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
                class far: far {
                        displayName = "Mk. 19 Grenade Launcher"; 
						dispersion = 0.03;
						aiBurstTerminable=1;
						burst = 1;
						burstRangeMax = 3;
						autoFire = 1; 
						reloadTime = 0.15; 
						aiRateOfFire = 6; 
						aiRateOfFireDistance = 1000;
                        class StandardSound { soundSetShot[] = {"RHSUSF_mk19_Shot_SoundSet","RHSUSF_lmg1_Tail_SoundSet"}; };
                        class SilencedSound { soundSetShot[] = {}; };
                };
        };

		class RHS_weap_Ags30;
		class RHS_weap_Ags30_tigr: RHS_weap_Ags30 {
			class manual;
			class close;
			class short;
			class medium;
			class far;
		};
		class RHS_weapon_Ags30_tigr_Terror : RHS_weap_Ags30_tigr {
			class manual : manual {
				displayName = "AGS30 Terror"; 
				dispersion = 0.03;
				aiBurstTerminable=1;
				burst = 1;
				burstRangeMax = 3;
				autoFire = 1; 
				reloadTime = 0.15; 
				aiRateOfFire = 6; 
				aiRateOfFireDistance = 500;
			};
			class close : close {
				displayName = "AGS30 Terror"; 
				dispersion = 0.03;
				aiBurstTerminable=1;
				burst = 1;
				burstRangeMax = 4;
				autoFire = 1; 
				reloadTime = 0.15; 
				aiRateOfFire = 6; 
				aiRateOfFireDistance = 50;
			};
			class short : short {
				displayName = "AGS30 Terror"; 
				dispersion = 0.03;
				aiBurstTerminable=1;
				burst = 1;
				burstRangeMax = 3;
				autoFire = 1; 
				reloadTime = 0.15; 
				aiRateOfFire = 6; 
				aiRateOfFireDistance = 300;
			};
			class medium : medium {
				displayName = "AGS30 Terror"; 
				dispersion = 0.03;
				aiBurstTerminable=1;
				burst = 1;
				burstRangeMax = 2;
				autoFire = 1; 
				reloadTime = 0.15; 
				aiRateOfFire = 6; 
				aiRateOfFireDistance = 500;
			};
			class far : far {
				displayName = "AGS30 Terror"; 
				dispersion = 0.03;
				aiBurstTerminable=1;
				burst = 1;
				burstRangeMax = 2;
				autoFire = 1; 
				reloadTime = 0.15; 
				aiRateOfFire = 6; 
				aiRateOfFireDistance = 1000;
			};
		};
};

