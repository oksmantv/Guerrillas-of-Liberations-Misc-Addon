	// Custom MMG variants with reduced recoil and custom magazines
	class MMG_01_tan_F;
	class MMG_01_hex_F;
	class GOL_MMG_01_tan_F: MMG_01_tan_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "HK121 9.3 mm (Tan/GOL)";
		baseWeapon = "GOL_MMG_01_tan_F";
		
		// Custom recoil presets — heavy tier (9.3mm)
		recoil = "GOL_recoil_machinegun_heavy";
		recoilProne = "GOL_recoil_machinegun_heavy_prone";

		// Tightened from vanilla (~0.00069) — still looser than FN MAG (RHS ~0.0003)
		dispersion = 0.0005;

		// Two full-auto modes — 800 RPM (standard) and 600 RPM (sustained)
		modes[] = {"GOL_HK121_FullAuto_800", "GOL_HK121_FullAuto_600"};
		class GOL_HK121_FullAuto_800: Mode_FullAuto {
			reloadTime = 0.075;
			autoFire = 1;
			burst = 1;
			textureType = "fullAuto";
			useActionTitle = "800 RPM";
			class StandardSound {
				soundSetShot[] = {"MMG01_Shot_SoundSet","MMG01_Tail_SoundSet","MMG01_InteriorTail_SoundSet"};
			};
			class SilencedSound {
				soundSetShot[] = {"MMG01_silencerShot_SoundSet","MMG01_silencerTail_SoundSet","MMG01_silencerInteriorTail_SoundSet"};
			};
		};
		class GOL_HK121_FullAuto_600: Mode_FullAuto {
			reloadTime = 0.1;
			autoFire = 1;
			burst = 0;
			textureType = "burst";
			useActionTitle = "600 RPM";
			class StandardSound {
				soundSetShot[] = {"MMG01_Shot_SoundSet","MMG01_Tail_SoundSet","MMG01_InteriorTail_SoundSet"};
			};
			class SilencedSound {
				soundSetShot[] = {"MMG01_silencerShot_SoundSet","MMG01_silencerTail_SoundSet","MMG01_silencerInteriorTail_SoundSet"};
			};
		};
		
		// Clear linkedItems to show in arsenal
		linkedItems[] = {};
		
		// Custom magazines with tracer variety
		magazines[] = {
			"GOL_150Rnd_93x64_Mag",
			"GOL_150Rnd_93x64_Mag_Tracer",
			"GOL_150Rnd_93x64_Mag_Tracer_Red",
			"GOL_150Rnd_93x64_Mag_Tracer_Green",
			"GOL_150Rnd_93x64_Mag_Tracer_Yellow",
			"GOL_150Rnd_93x64_Mag_SLAP",
			"GOL_150Rnd_93x64_Mag_SLAP_Tracer_Red",
			"GOL_150Rnd_93x64_Mag_SLAP_Tracer_Green",
			"GOL_150Rnd_93x64_Mag_SLAP_Tracer_Yellow",
			"GOL_200Rnd_93x64_Mag",
			"GOL_200Rnd_93x64_Mag_Tracer",
			"GOL_200Rnd_93x64_Mag_Tracer_Red",
			"GOL_200Rnd_93x64_Mag_Tracer_Green",
			"GOL_200Rnd_93x64_Mag_Tracer_Yellow",
			"GOL_200Rnd_93x64_Mag_SLAP",
			"GOL_200Rnd_93x64_Mag_SLAP_Tracer_Red",
			"GOL_200Rnd_93x64_Mag_SLAP_Tracer_Green",
			"GOL_200Rnd_93x64_Mag_SLAP_Tracer_Yellow",
			// Vanilla compatibility
			"150Rnd_93x64_Mag"
		};
	};

	class GOL_MMG_01_hex_F: MMG_01_hex_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "HK121 9.3 mm (Hex/GOL)";
		baseWeapon = "GOL_MMG_01_hex_F";
		
		// Custom recoil presets — heavy tier (9.3mm)
		recoil = "GOL_recoil_machinegun_heavy";
		recoilProne = "GOL_recoil_machinegun_heavy_prone";

		// Tightened from vanilla (~0.00069) — still looser than FN MAG (RHS ~0.0003)
		dispersion = 0.0005;

		// Two full-auto modes — 800 RPM (standard) and 600 RPM (sustained)
		modes[] = {"GOL_HK121_FullAuto_800", "GOL_HK121_FullAuto_600"};
		class GOL_HK121_FullAuto_800: Mode_FullAuto {
			reloadTime = 0.075;
			autoFire = 1;
			burst = 0;
			class StandardSound {
				soundSetShot[] = {"MMG01_Shot_SoundSet","MMG01_Tail_SoundSet","MMG01_InteriorTail_SoundSet"};
			};
			class SilencedSound {
				soundSetShot[] = {"MMG01_silencerShot_SoundSet","MMG01_silencerTail_SoundSet","MMG01_silencerInteriorTail_SoundSet"};
			};
		};
		class GOL_HK121_FullAuto_600: Mode_FullAuto {
			reloadTime = 0.1;
			autoFire = 1;
			burst = 1;
			textureType = "burst";
			class StandardSound {
				soundSetShot[] = {"MMG01_Shot_SoundSet","MMG01_Tail_SoundSet","MMG01_InteriorTail_SoundSet"};
			};
			class SilencedSound {
				soundSetShot[] = {"MMG01_silencerShot_SoundSet","MMG01_silencerTail_SoundSet","MMG01_silencerInteriorTail_SoundSet"};
			};
		};
		
		// Clear linkedItems to show in arsenal
		linkedItems[] = {};
		
		magazines[] = {
			"GOL_150Rnd_93x64_Mag",
			"GOL_150Rnd_93x64_Mag_Tracer",
			"GOL_150Rnd_93x64_Mag_Tracer_Red",
			"GOL_150Rnd_93x64_Mag_Tracer_Green",
			"GOL_150Rnd_93x64_Mag_Tracer_Yellow",
			"GOL_150Rnd_93x64_Mag_SLAP",
			"GOL_150Rnd_93x64_Mag_SLAP_Tracer_Red",
			"GOL_150Rnd_93x64_Mag_SLAP_Tracer_Green",
			"GOL_150Rnd_93x64_Mag_SLAP_Tracer_Yellow",
			"GOL_200Rnd_93x64_Mag",
			"GOL_200Rnd_93x64_Mag_Tracer",
			"GOL_200Rnd_93x64_Mag_Tracer_Red",
			"GOL_200Rnd_93x64_Mag_Tracer_Green",
			"GOL_200Rnd_93x64_Mag_Tracer_Yellow",
			"GOL_200Rnd_93x64_Mag_SLAP",
			"GOL_200Rnd_93x64_Mag_SLAP_Tracer_Red",
			"GOL_200Rnd_93x64_Mag_SLAP_Tracer_Green",
			"GOL_200Rnd_93x64_Mag_SLAP_Tracer_Yellow",
			"150Rnd_93x64_Mag"
		};
	};

	// RHS PKM/PKP variants with red tracers
	class rhs_weap_pkm;
	class rhs_weap_pkp;

	class GOL_weap_pkm: rhs_weap_pkm {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "PKM (GOL)";
		baseWeapon = "GOL_weap_pkm";
		
		recoil = "GOL_recoil_machinegun";
		recoilProne = "GOL_recoil_machinegun_prone";
		
		magazines[] = {
			"GOL_100Rnd_762x54mmR",
			"GOL_100Rnd_762x54mmR_red",
			"GOL_100Rnd_762x54mmR_green",
			// Vanilla compatibility
			"rhs_100Rnd_762x54mmR",
			"rhs_100Rnd_762x54mmR_green"
		};
	};

	class GOL_weap_pkp: rhs_weap_pkp {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "PKP (GOL)";
		baseWeapon = "GOL_weap_pkp";
		
		recoil = "GOL_recoil_machinegun";
		recoilProne = "GOL_recoil_machinegun_prone";
		
		magazines[] = {
			"GOL_100Rnd_762x54mmR",
			"GOL_100Rnd_762x54mmR_red",
			"GOL_100Rnd_762x54mmR_green",
			"rhs_100Rnd_762x54mmR",
			"rhs_100Rnd_762x54mmR_green"
		};
	};

	// MMG_02 SPMG variants (.338)
	class MMG_02_black_F;
	class MMG_02_camo_F;
	class MMG_02_sand_F;

	class GOL_MMG_02_black_F: MMG_02_black_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "LWMMG .338 (Black/GOL)";
		baseWeapon = "GOL_MMG_02_black_F";
		
		// Heavy tier recoil (.338 Norma Magnum)
		recoil = "GOL_recoil_machinegun_heavy";
		recoilProne = "GOL_recoil_machinegun_heavy_prone";
		
		class manual: Mode_FullAuto {
			sounds[] = {"StandardSound", "SilencedSound"};
			class BaseSoundModeType {};
			class StandardSound: BaseSoundModeType {
				soundSetShot[] = {"MMG02_Shot_SoundSet", "MMG02_Tail_SoundSet", "MMG02_InteriorTail_SoundSet"};
			};
			class SilencedSound: BaseSoundModeType {
				soundSetShot[] = {"MMG02_Shot_SoundSet", "MMG02_Tail_SoundSet", "MMG02_InteriorTail_SoundSet"};
			};
			reloadTime = 0.0923;
		};
		
		magazines[] = {
			"GOL_130Rnd_338_Mag",
			"GOL_130Rnd_338_Mag_red",
			"GOL_130Rnd_338_Mag_green",
			"GOL_130Rnd_338_AP",
			"GOL_130Rnd_338_AP_Tracer_Red",
			"GOL_130Rnd_338_AP_Tracer_Green",
			"GOL_200Rnd_338_Mag",
			"GOL_200Rnd_338_Mag_red",
			"GOL_200Rnd_338_Mag_green",
			"GOL_200Rnd_338_AP",
			"GOL_200Rnd_338_AP_Tracer_Red",
			"GOL_200Rnd_338_AP_Tracer_Green",
			// Vanilla compatibility
			"130Rnd_338_Mag"
		};
	};

	class GOL_MMG_02_camo_F: MMG_02_camo_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "LWMMG .338 (Camo/GOL)";
		baseWeapon = "GOL_MMG_02_camo_F";
		
		// Heavy tier recoil (.338 Norma Magnum)
		recoil = "GOL_recoil_machinegun_heavy";
		recoilProne = "GOL_recoil_machinegun_heavy_prone";
		
		class manual: Mode_FullAuto {
			sounds[] = {"StandardSound", "SilencedSound"};
			class BaseSoundModeType {};
			class StandardSound: BaseSoundModeType {
				soundSetShot[] = {"MMG02_Shot_SoundSet", "MMG02_Tail_SoundSet", "MMG02_InteriorTail_SoundSet"};
			};
			class SilencedSound: BaseSoundModeType {
				soundSetShot[] = {"MMG02_Shot_SoundSet", "MMG02_Tail_SoundSet", "MMG02_InteriorTail_SoundSet"};
			};
			reloadTime = 0.0923;
		};
		
		magazines[] = {
			"GOL_130Rnd_338_Mag",
			"GOL_130Rnd_338_Mag_red",
			"GOL_130Rnd_338_Mag_green",
			"GOL_130Rnd_338_AP",
			"GOL_130Rnd_338_AP_Tracer_Red",
			"GOL_130Rnd_338_AP_Tracer_Green",
			"GOL_200Rnd_338_Mag",
			"GOL_200Rnd_338_Mag_red",
			"GOL_200Rnd_338_Mag_green",
			"GOL_200Rnd_338_AP",
			"GOL_200Rnd_338_AP_Tracer_Red",
			"GOL_200Rnd_338_AP_Tracer_Green",
			"130Rnd_338_Mag"
		};
	};

	class GOL_MMG_02_sand_F: MMG_02_sand_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "LWMMG .338 (Sand/GOL)";
		baseWeapon = "GOL_MMG_02_sand_F";
		
		// Heavy tier recoil (.338 Norma Magnum)
		recoil = "GOL_recoil_machinegun_heavy";
		recoilProne = "GOL_recoil_machinegun_heavy_prone";
		
		class manual: Mode_FullAuto {
			sounds[] = {"StandardSound", "SilencedSound"};
			class BaseSoundModeType {};
			class StandardSound: BaseSoundModeType {
				soundSetShot[] = {"MMG02_Shot_SoundSet", "MMG02_Tail_SoundSet", "MMG02_InteriorTail_SoundSet"};
			};
			class SilencedSound: BaseSoundModeType {
				soundSetShot[] = {"MMG02_Shot_SoundSet", "MMG02_Tail_SoundSet", "MMG02_InteriorTail_SoundSet"};
			};
			reloadTime = 0.0923;
		};
		
		magazines[] = {
			"GOL_130Rnd_338_Mag",
			"GOL_130Rnd_338_Mag_red",
			"GOL_130Rnd_338_Mag_green",
			"GOL_130Rnd_338_AP",
			"GOL_130Rnd_338_AP_Tracer_Red",
			"GOL_130Rnd_338_AP_Tracer_Green",
			"GOL_200Rnd_338_Mag",
			"GOL_200Rnd_338_Mag_red",
			"GOL_200Rnd_338_Mag_green",
			"GOL_200Rnd_338_AP",
			"GOL_200Rnd_338_AP_Tracer_Red",
			"GOL_200Rnd_338_AP_Tracer_Green",
			"130Rnd_338_Mag"
		};
	};

	// LMG_Zafir_F and other weapons that don't need new mags
	class LMG_Zafir_F;
	class rhs_weap_fnmag;
	class UK3CB_MG3_KWS_B;

	class GOL_LMG_Zafir_F: LMG_Zafir_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "Zafir 7.62mm (GOL)";
		baseWeapon = "GOL_LMG_Zafir_F";

		recoil = "GOL_recoil_machinegun";
		recoilProne = "GOL_recoil_machinegun_prone";

		magazines[] += {
			"GOL_100Rnd_762x51_M993",
			"GOL_100Rnd_762x51_M993_Tracer_Red",
			"GOL_100Rnd_762x51_M993_Tracer_Green",
			"GOL_100Rnd_762x51_M993_SLAP",
			"GOL_100Rnd_762x51_M993_SLAP_Tracer_Red",
			"GOL_100Rnd_762x51_M993_SLAP_Tracer_Green",
			"GOL_150Rnd_762x51_M993",
			"GOL_150Rnd_762x51_M993_Tracer_Red",
			"GOL_150Rnd_762x51_M993_Tracer_Green",
			"GOL_200Rnd_762x51_M993",
			"GOL_200Rnd_762x51_M993_Tracer_Red",
			"GOL_200Rnd_762x51_M993_Tracer_Green",
			"GOL_200Rnd_762x51_M993_SLAP",
			"GOL_200Rnd_762x51_M993_SLAP_Tracer_Red",
			"GOL_200Rnd_762x51_M993_SLAP_Tracer_Green"
		};
	};

	class GOL_weap_fnmag: rhs_weap_fnmag {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "FN MAG (GOL)";
		baseWeapon = "GOL_weap_fnmag";

		recoil = "GOL_recoil_machinegun";
		recoilProne = "GOL_recoil_machinegun_prone";

		// Suppresses AI heat-signature detection.
		heatRadiation = 0;
		// FN MAG inherits RHSUSF_BarrelRefractHeavy — downgrade to standard refract.
		class GunParticles {
			class M240_AmmoBeltCaseEject {
				directionName = "shelleject_end";
				effectName    = "RHSUSF_762Cartridge";
				positionName  = "shelleject_start";
			};
			class M240_AmmoBeltLinkEject {
				directionName = "ammobeltlinks_end";
				effectName    = "MachineGunEject2";
				positionName  = "ammobeltlinks_start";
			};
			class M240_RHSUSF_BarrelRefract {
				directionName = "usti hlavne up";
				effectName    = "RHSUSF_BarrelRefract";
				positionName  = "usti hlavne";
			};
			class M240_WhiteGas {
				directionName = "konec hlavne";
				effectName    = "RifleAssaultCloud";
				positionName  = "usti hlavne";
			};
		};

		magazines[] += {
			"GOL_FNMAG_100Rnd_762x51_M993",
			"GOL_FNMAG_100Rnd_762x51_M993_Tracer_Red",
			"GOL_FNMAG_100Rnd_762x51_M993_Tracer_Green",
			"GOL_FNMAG_100Rnd_762x51_M993_SLAP",
			"GOL_FNMAG_100Rnd_762x51_M993_SLAP_Tracer_Red",
			"GOL_FNMAG_100Rnd_762x51_M993_SLAP_Tracer_Green",
			"GOL_FNMAG_150Rnd_762x51_M993",
			"GOL_FNMAG_150Rnd_762x51_M993_Tracer_Red",
			"GOL_FNMAG_150Rnd_762x51_M993_Tracer_Green",
			"GOL_FNMAG_200Rnd_762x51_M993",
			"GOL_FNMAG_200Rnd_762x51_M993_Tracer_Red",
			"GOL_FNMAG_200Rnd_762x51_M993_Tracer_Green",
			"GOL_FNMAG_200Rnd_762x51_M993_SLAP",
			"GOL_FNMAG_200Rnd_762x51_M993_SLAP_Tracer_Red",
			"GOL_FNMAG_200Rnd_762x51_M993_SLAP_Tracer_Green"
		};
	};

	class GOL_MG3_KWS_B: UK3CB_MG3_KWS_B {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "MG3 KWS (GOL)";
		baseWeapon = "GOL_MG3_KWS_B";

		recoil = "GOL_recoil_machinegun";
		recoilProne = "GOL_recoil_machinegun_prone";

		magazines[] += {
			"GOL_MG3_100Rnd_762x51_M993",
			"GOL_MG3_100Rnd_762x51_M993_Tracer_Red",
			"GOL_MG3_100Rnd_762x51_M993_Tracer_Green",
			"GOL_MG3_100Rnd_762x51_M993_SLAP",
			"GOL_MG3_100Rnd_762x51_M993_SLAP_Tracer_Red",
			"GOL_MG3_100Rnd_762x51_M993_SLAP_Tracer_Green",
			"GOL_MG3_250Rnd_762x51_M993",
			"GOL_MG3_250Rnd_762x51_M993_Tracer_Red",
			"GOL_MG3_250Rnd_762x51_M993_Tracer_Green",
			"GOL_MG3_250Rnd_762x51_M993_SLAP",
			"GOL_MG3_250Rnd_762x51_M993_SLAP_Tracer_Red",
			"GOL_MG3_250Rnd_762x51_M993_SLAP_Tracer_Green"
		};
	};

	class GOL_weap_m249_pip: rhs_weap_m249_pip {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "M249 PIP (GOL)";
		baseWeapon = "GOL_weap_m249_pip";
		
		// Light tier recoil (5.56mm)
		recoil = "GOL_recoil_machinegun_light";
		recoilProne = "GOL_recoil_machinegun_light_prone";
	};

	// ===== UK59N (7.62x51 NATO) — Medium MG tier =====
	class UK3CB_UK59N;

	class GOL_weap_UK59N: UK3CB_UK59N {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "UK59N (GOL)";
		baseWeapon = "GOL_weap_UK59N";

		recoil = "GOL_recoil_machinegun";
		recoilProne = "GOL_recoil_machinegun_prone";

		magazines[] += {
			"GOL_UK59_100Rnd_762x51_M993",
			"GOL_UK59_100Rnd_762x51_M993_Tracer_Red",
			"GOL_UK59_100Rnd_762x51_M993_Tracer_Green",
			"GOL_UK59_100Rnd_762x51_M993_Tracer_Yellow",
			"GOL_UK59_200Rnd_762x51_M993",
			"GOL_UK59_200Rnd_762x51_M993_Tracer_Red",
			"GOL_UK59_200Rnd_762x51_M993_Tracer_Green",
			"GOL_UK59_200Rnd_762x51_M993_Tracer_Yellow"
		};
	};

	// ===== UK3CB RPD (7.62x39) — Medium MG tier =====
	// RPD has empty magazineWell[]; GOL mags added directly via magazines[] +=.
	class UK3CB_RPD;

	class GOL_weap_RPD: UK3CB_RPD {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "RPD (GOL)";
		baseWeapon = "GOL_weap_RPD";

		recoil = "GOL_recoil_machinegun";
		recoilProne = "GOL_recoil_machinegun_prone";

		magazines[] += {
			"GOL_RPD_100Rnd_762x39",
			"GOL_RPD_100Rnd_762x39_Tracer_Red",
			"GOL_RPD_100Rnd_762x39_Tracer_Green",
			"GOL_RPD_100Rnd_762x39_Tracer_Yellow"
		};
	};

	// ===== RHS M249 (5.56mm) — Light MG tier =====
	// rhs_weap_m249 already fully defined in compat_rhs.hpp — no forward decl needed.
	class GOL_weap_m249: rhs_weap_m249 {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "M249 (GOL)";
		baseWeapon = "GOL_weap_m249";

		recoil = "GOL_recoil_machinegun_light";
		recoilProne = "GOL_recoil_machinegun_light_prone";
	};

	// ===== LMG Mk200 (6.5mm cased) — Medium MG tier =====
	// Vanilla Mk200 has no magazineWell[]; GOL mags added directly.
	class LMG_Mk200_F;

	class GOL_LMG_Mk200_F: LMG_Mk200_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "LMG Mk200 (GOL)";
		baseWeapon = "GOL_LMG_Mk200_F";

		recoil = "GOL_recoil_machinegun";
		recoilProne = "GOL_recoil_machinegun_prone";

		magazines[] += {
			"GOL_200Rnd_65x39_cased_Box",
			"GOL_200Rnd_65x39_cased_Box_Tracer_Red",
			"GOL_200Rnd_65x39_cased_Box_Tracer_Green",
			"GOL_200Rnd_65x39_cased_Box_Tracer_Yellow"
		};
	};

	// ===== Vanilla RPK-12 (7.62x39) — Medium MG tier =====
	// GOL 75Rnd drums also injected via CBA_762x39_RPK well for 3CB RPK variants.
	class arifle_RPK12_F;

	class GOL_weap_RPK12: arifle_RPK12_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "RPK-12 (GOL)";
		baseWeapon = "GOL_weap_RPK12";

		recoil = "GOL_recoil_machinegun";
		recoilProne = "GOL_recoil_machinegun_prone";

		magazines[] += {
			"GOL_75Rnd_762x39",
			"GOL_75Rnd_762x39_Tracer_Red",
			"GOL_75Rnd_762x39_Tracer_Green",
			"GOL_75Rnd_762x39_Tracer_Yellow"
		};
	};

	// ===== RHS RPK-74M (5.45x39) — Light MG tier =====
	// GOL 7N22 AP mags available via CBA_545x39_RPK well (CfgMagazineWells).
	class rhs_weap_rpk74m;
	class rhs_weap_rpk74m_npz;

	class GOL_weap_rpk74m: rhs_weap_rpk74m {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "RPK-74M (GOL)";
		baseWeapon = "GOL_weap_rpk74m";

		recoil = "GOL_recoil_machinegun_light";
		recoilProne = "GOL_recoil_machinegun_light_prone";
	};

	class GOL_weap_rpk74m_npz: rhs_weap_rpk74m_npz {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "RPK-74M (NPZ/GOL)";
		baseWeapon = "GOL_weap_rpk74m_npz";

		recoil = "GOL_recoil_machinegun_light";
		recoilProne = "GOL_recoil_machinegun_light_prone";
	};

	// ===== Vanilla MX SW variants (6.5mm caseless) — Medium MG tier =====
	// GOL 100Rnd caseless belt mags available via MX_65x39_Large well (CfgMagazineWells).
	class arifle_MX_SW_F;
	class arifle_MX_SW_Black_F;
	class arifle_MX_SW_khk_F;

	class GOL_arifle_MX_SW_F: arifle_MX_SW_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "MX SW (GOL)";
		baseWeapon = "GOL_arifle_MX_SW_F";

		recoil = "GOL_recoil_machinegun";
		recoilProne = "GOL_recoil_machinegun_prone";
	};

	class GOL_arifle_MX_SW_Black_F: arifle_MX_SW_Black_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "MX SW Black (GOL)";
		baseWeapon = "GOL_arifle_MX_SW_Black_F";

		recoil = "GOL_recoil_machinegun";
		recoilProne = "GOL_recoil_machinegun_prone";
	};

	class GOL_arifle_MX_SW_khk_F: arifle_MX_SW_khk_F {
		scope = 2;
		scopeArsenal = 2;
		author = "Guerrillas of Liberation";
		displayName = "MX SW Khaki (GOL)";
		baseWeapon = "GOL_arifle_MX_SW_khk_F";

		recoil = "GOL_recoil_machinegun";
		recoilProne = "GOL_recoil_machinegun_prone";
	};
