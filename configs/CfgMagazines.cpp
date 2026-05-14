class CfgMagazines {
    class rhs_mag_9k38_rocket; // Reference the base class (no body)
    class gol_mag_9k38_rocket: rhs_mag_9k38_rocket {
        displayName = "9K38 (Disabled ACE Guidance)";
        ammo = "gol_ammo_9k38";
    };

    class magazine_Missile_s750_x4;
    class gol_magazine_Missile_s750_x4: magazine_Missile_s750_x4 {
        displayName = "S750 (Disabled ACE Guidance)";
        ammo = "gol_ammo_s750_GOL";
    };


	// ==================== SHORAD IR Magazines (single-shot) ====================
	class gol_magazine_shorad_light_x1: rhs_mag_9k38_rocket {
		displayName = "SHORAD IR Light (GOL)";
		ammo = "gol_ammo_shorad_light";
		count = 1;
	};
	class gol_magazine_shorad_medium_x1: rhs_mag_9k38_rocket {
		displayName = "SHORAD IR Medium (GOL)";
		ammo = "gol_ammo_shorad_medium";
		count = 1;
	};
	class gol_magazine_shorad_heavy_x1: rhs_mag_9k38_rocket {
		displayName = "SHORAD IR Heavy (GOL)";
		ammo = "gol_ammo_shorad_heavy";
		count = 1;
	};

    // FPV throwables (soft dependency on BOT_FPV_Enhanced)
    class HandGrenade;
    class GOL_Mag_FPV_AT_Throw: HandGrenade {
        scope = 2;
        scopeArsenal = 2;
        scopeCurator = 2;
		displayName = "FPV Drone (AT) - Throwable";
		displayNameShort = "FPV AT";
		descriptionShort = "Throwable FPV drone. Throw to deploy and link.";
        mass = 33;
        ammo = "GOL_Ammo_FPV_AT_Throw";
        picture = "\ArmaFPV\data\drononmap.paa";
        icon = "\ArmaFPV\data\drononmap.paa";
        model = "\fpv_ua\drone_pg7vl.p3d";
    };

    class GOL_Mag_FPV_AP_Throw: HandGrenade {
        scope = 2;
        scopeArsenal = 2;
        scopeCurator = 2;
		displayName = "FPV Drone (AP) - Throwable";
		displayNameShort = "FPV AP";
		descriptionShort = "Throwable FPV drone. Throw to deploy and link.";
        mass = 33;
        ammo = "GOL_Ammo_FPV_AP_Throw";
        picture = "\ArmaFPV\data\drononmap.paa";
        icon = "\ArmaFPV\data\drononmap.paa";
		model = "\fpv_ua\drone_rkg.p3d";
    };

    class GOL_Mag_FPV_AP_OG7V_Throw: HandGrenade {
        scope = 2;
        scopeArsenal = 2;
        scopeCurator = 2;
		displayName = "FPV Drone (AP OG7V) - Throwable";
		displayNameShort = "FPV OG7V";
		descriptionShort = "Throwable FPV drone. Throw to deploy and link.";
        mass = 33;
        ammo = "GOL_Ammo_FPV_AP_OG7V_Throw";
        picture = "\ArmaFPV\data\drononmap.paa";
        icon = "\ArmaFPV\data\drononmap.paa";
        model = "\fpv_ua\drone_og7v.p3d";
    };

    class GOL_Mag_FPV_AP_IED_Throw: HandGrenade {
        scope = 2;
        scopeArsenal = 2;
        scopeCurator = 2;
		displayName = "FPV Drone (AP IED) - Throwable";
		displayNameShort = "FPV IED";
		descriptionShort = "Throwable FPV drone. Throw to deploy and link.";
        mass = 33;
        ammo = "GOL_Ammo_FPV_AP_IED_Throw";
        picture = "\ArmaFPV\data\drononmap.paa";
        icon = "\ArmaFPV\data\drononmap.paa";
        model = "\fpv_ua\drone_ied.p3d";
    };

    // Drone disruptor pistol magazine
    class 10Rnd_9x21_Mag;
    class OKS_Mag_DroneDisruptor: 10Rnd_9x21_Mag {
        scope = 2;
        scopeArsenal = 2;
        displayName = "EMP Capacitor Magazine";
        displayNameShort = "EMP";
        descriptionShort = "5-round electromagnetic pulse magazine for drone elimination";
        ammo = "OKS_Ammo_DisruptorPulse";
        count = 5;
        mass = 10;
        initSpeed = 0;
        picture = "\a3\ui_f\data\igui\cfg\simpleTasks\types\radio_ca.paa";
    };

    // Custom MMG magazines with tracer variants
    class 150Rnd_93x64_Mag;
    
    class GOL_150Rnd_93x64_Mag: 150Rnd_93x64_Mag {
        scope = 2;
        displayName = "9.3 mm 150Rnd Belt";
        displayNameShort = "9.3mm";
        descriptionShort = "9.3x64mm 150-round belt, ball ammunition";
        ammo = "B_93x64_Ball";
        tracersEvery = 0;
        mass = 70;
    };

    class GOL_150Rnd_93x64_Mag_Tracer: GOL_150Rnd_93x64_Mag {
        displayName = "9.3 mm 150Rnd Tracer (Red)";
        displayNameShort = "Tracer";
        descriptionShort = "9.3x64mm 150-round belt, all red tracers";
        ammo = "GOL_B_93x64_Ball_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 150;
    };

    class GOL_150Rnd_93x64_Mag_Tracer_Red: GOL_150Rnd_93x64_Mag_Tracer {
        displayName = "9.3 mm 150Rnd Tracer (Red)";
        ammo = "GOL_B_93x64_Ball_Tracer_Red";
    };

    class GOL_150Rnd_93x64_Mag_Tracer_Green: GOL_150Rnd_93x64_Mag_Tracer {
        displayName = "9.3 mm 150Rnd Tracer (Green)";
        displayNameShort = "Tracer (Green)";
        descriptionShort = "9.3x64mm 150-round belt, all green tracers";
        ammo = "GOL_B_93x64_Ball_Tracer_Green";
    };

    class GOL_150Rnd_93x64_Mag_Tracer_Yellow: GOL_150Rnd_93x64_Mag_Tracer {
        displayName = "9.3 mm 150Rnd Tracer (Yellow)";
        displayNameShort = "Tracer (Yellow)";
        descriptionShort = "9.3x64mm 150-round belt, all yellow tracers";
        ammo = "GOL_B_93x64_Ball_Tracer_Yellow";
    };

    // RHS PKM/PKP 7.62x54mmR magazines with red tracers
    class rhs_100Rnd_762x54mmR;
    
    class GOL_100Rnd_762x54mmR: rhs_100Rnd_762x54mmR {
        scope = 2;
        displayName = "7.62mm 100Rnd Box";
        displayNameShort = "7.62mm";
        descriptionShort = "7.62x54mmR 100-round box, ball ammunition";
        tracersEvery = 0;
    };

    class GOL_100Rnd_762x54mmR_red: GOL_100Rnd_762x54mmR {
        displayName = "7.62mm 100Rnd Tracer (Red)";
        displayNameShort = "Tracer (Red)";
        descriptionShort = "7.62x54mmR 100-round box, all red tracers";
        ammo = "GOL_B_762x54_Ball_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 100;
    };

    class GOL_100Rnd_762x54mmR_green: GOL_100Rnd_762x54mmR {
        displayName = "7.62mm 100Rnd Tracer (Green)";
        displayNameShort = "Tracer (Green)";
        descriptionShort = "7.62x54mmR 100-round box, all green tracers";
        ammo = "GOL_B_762x54_Ball_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 100;
    };

    // 7.62x51mm NATO M993 AP magazines
    class 150Rnd_762x51_Box;
    class UK3CB_BAF_762_200Rnd;
    class rhsusf_100Rnd_762x51_m61_ap;
    class UK3CB_MG3_250rnd_762x51;

    class GOL_100Rnd_762x51_M993: 150Rnd_762x51_Box {
        count = 100;
        scope = 2;
        displayName = "7.62mm 100Rnd M993 AP";
        displayNameShort = "M993";
        descriptionShort = "7.62x51mm NATO 100-round belt, M993 tungsten AP";
        ammo = "GOL_B_762x51_M993";
        tracersEvery = 0;
    };

    class GOL_100Rnd_762x51_M993_Tracer_Red: GOL_100Rnd_762x51_M993 {
        displayName = "7.62mm 100Rnd M993 AP Tracer (Red)";
        displayNameShort = "M993 (Red)";
        descriptionShort = "7.62x51mm NATO 100-round belt, M993 AP, all red tracers";
        ammo = "GOL_B_762x51_M993_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 100;
    };

    class GOL_100Rnd_762x51_M993_Tracer_Green: GOL_100Rnd_762x51_M993 {
        displayName = "7.62mm 100Rnd M993 AP Tracer (Green)";
        displayNameShort = "M993 (Green)";
        descriptionShort = "7.62x51mm NATO 100-round belt, M993 AP, all green tracers";
        ammo = "GOL_B_762x51_M993_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 100;
    };

    // 150-round belt — inherits BAF L110 762 200Rnd model/UI, overrides count
    class GOL_150Rnd_762x51_M993: UK3CB_BAF_762_200Rnd {
        scope = 2;
        displayName = "7.62mm 150Rnd M993 AP";
        displayNameShort = "M993 150";
        descriptionShort = "7.62x51mm NATO 150-round belt, M993 tungsten AP";
        ammo = "GOL_B_762x51_M993";
        count = 150;
        tracersEvery = 0;
        lastRoundsTracer = 0;
    };

    class GOL_150Rnd_762x51_M993_Tracer_Red: GOL_150Rnd_762x51_M993 {
        displayName = "7.62mm 150Rnd M993 AP Tracer (Red)";
        displayNameShort = "M993 150 (Red)";
        descriptionShort = "7.62x51mm NATO 150-round belt, M993 AP, all red tracers";
        ammo = "GOL_B_762x51_M993_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 150;
    };

    class GOL_150Rnd_762x51_M993_Tracer_Green: GOL_150Rnd_762x51_M993 {
        displayName = "7.62mm 150Rnd M993 AP Tracer (Green)";
        displayNameShort = "M993 150 (Green)";
        descriptionShort = "7.62x51mm NATO 150-round belt, M993 AP, all green tracers";
        ammo = "GOL_B_762x51_M993_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 150;
    };

    // 200-round belt — inherits BAF L110 762 200Rnd model/UI (belt box), overrides count
    class GOL_200Rnd_762x51_M993: UK3CB_BAF_762_200Rnd {
        scope = 2;
        displayName = "7.62mm 200Rnd M993 AP";
        displayNameShort = "M993 200";
        descriptionShort = "7.62x51mm NATO 200-round belt, M993 tungsten AP";
        ammo = "GOL_B_762x51_M993";
        count = 200;
        tracersEvery = 0;
        lastRoundsTracer = 0;
    };

    class GOL_200Rnd_762x51_M993_Tracer_Red: GOL_200Rnd_762x51_M993 {
        displayName = "7.62mm 200Rnd M993 AP Tracer (Red)";
        displayNameShort = "M993 200 (Red)";
        descriptionShort = "7.62x51mm NATO 200-round belt, M993 AP, all red tracers";
        ammo = "GOL_B_762x51_M993_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    class GOL_200Rnd_762x51_M993_Tracer_Green: GOL_200Rnd_762x51_M993 {
        displayName = "7.62mm 200Rnd M993 AP Tracer (Green)";
        displayNameShort = "M993 200 (Green)";
        descriptionShort = "7.62x51mm NATO 200-round belt, M993 AP, all green tracers";
        ammo = "GOL_B_762x51_M993_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    // MG3-specific M993 AP magazines (inherit UK3CB MG3 drum box model)
    class GOL_MG3_100Rnd_762x51_M993: UK3CB_MG3_250rnd_762x51 {
        scope = 2;
        count = 100;
        displayName = "7.62mm 100Rnd M993 AP (MG3)";
        displayNameShort = "M993";
        descriptionShort = "7.62x51mm NATO 100-round belt, M993 tungsten AP";
        ammo = "GOL_B_762x51_M993";
        tracersEvery = 0;
    };

    class GOL_MG3_100Rnd_762x51_M993_Tracer_Red: GOL_MG3_100Rnd_762x51_M993 {
        displayName = "7.62mm 100Rnd M993 AP Tracer (Red) (MG3)";
        displayNameShort = "M993 (Red)";
        descriptionShort = "7.62x51mm NATO 100-round belt, M993 AP, all red tracers";
        ammo = "GOL_B_762x51_M993_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 100;
    };

    class GOL_MG3_100Rnd_762x51_M993_Tracer_Green: GOL_MG3_100Rnd_762x51_M993 {
        displayName = "7.62mm 100Rnd M993 AP Tracer (Green) (MG3)";
        displayNameShort = "M993 (Green)";
        descriptionShort = "7.62x51mm NATO 100-round belt, M993 AP, all green tracers";
        ammo = "GOL_B_762x51_M993_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 100;
    };

    class GOL_MG3_250Rnd_762x51_M993: UK3CB_MG3_250rnd_762x51 {
        scope = 2;
        count = 250;
        displayName = "7.62mm 250Rnd M993 AP (MG3)";
        displayNameShort = "M993 250";
        descriptionShort = "7.62x51mm NATO 250-round drum belt, M993 tungsten AP";
        ammo = "GOL_B_762x51_M993";
        tracersEvery = 0;
    };

    class GOL_MG3_250Rnd_762x51_M993_Tracer_Red: GOL_MG3_250Rnd_762x51_M993 {
        displayName = "7.62mm 250Rnd M993 AP Tracer (Red) (MG3)";
        displayNameShort = "M993 250 (Red)";
        descriptionShort = "7.62x51mm NATO 250-round drum belt, M993 AP, all red tracers";
        ammo = "GOL_B_762x51_M993_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 250;
    };

    class GOL_MG3_250Rnd_762x51_M993_Tracer_Green: GOL_MG3_250Rnd_762x51_M993 {
        displayName = "7.62mm 250Rnd M993 AP Tracer (Green) (MG3)";
        displayNameShort = "M993 250 (Green)";
        descriptionShort = "7.62x51mm NATO 250-round drum belt, M993 AP, all green tracers";
        ammo = "GOL_B_762x51_M993_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 250;
    };

    // 7.62x51mm M993 SLAP magazines (infantry belts — Zafir/FN MAG)
    class GOL_100Rnd_762x51_M993_SLAP: GOL_100Rnd_762x51_M993 {
        displayName = "7.62mm 100Rnd M993 SLAP";
        displayNameShort = "M993 SLAP";
        descriptionShort = "7.62x51mm NATO 100-round belt, M993 SLAP saboted light armor penetrator";
        ammo = "GOL_B_762x51_M993_SLAP";
    };

    class GOL_100Rnd_762x51_M993_SLAP_Tracer_Red: GOL_100Rnd_762x51_M993_SLAP {
        displayName = "7.62mm 100Rnd M993 SLAP Tracer (Red)";
        displayNameShort = "M993 SLAP (Red)";
        descriptionShort = "7.62x51mm NATO 100-round belt, M993 SLAP, all red tracers";
        ammo = "GOL_B_762x51_M993_SLAP_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 100;
    };

    class GOL_100Rnd_762x51_M993_SLAP_Tracer_Green: GOL_100Rnd_762x51_M993_SLAP {
        displayName = "7.62mm 100Rnd M993 SLAP Tracer (Green)";
        displayNameShort = "M993 SLAP (Green)";
        descriptionShort = "7.62x51mm NATO 100-round belt, M993 SLAP, all green tracers";
        ammo = "GOL_B_762x51_M993_SLAP_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 100;
    };

    class GOL_200Rnd_762x51_M993_SLAP: GOL_200Rnd_762x51_M993 {
        displayName = "7.62mm 200Rnd M993 SLAP";
        displayNameShort = "M993 SLAP";
        descriptionShort = "7.62x51mm NATO 200-round belt, M993 SLAP saboted light armor penetrator";
        ammo = "GOL_B_762x51_M993_SLAP";
    };

    class GOL_200Rnd_762x51_M993_SLAP_Tracer_Red: GOL_200Rnd_762x51_M993_SLAP {
        displayName = "7.62mm 200Rnd M993 SLAP Tracer (Red)";
        displayNameShort = "M993 SLAP (Red)";
        descriptionShort = "7.62x51mm NATO 200-round belt, M993 SLAP, all red tracers";
        ammo = "GOL_B_762x51_M993_SLAP_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    class GOL_200Rnd_762x51_M993_SLAP_Tracer_Green: GOL_200Rnd_762x51_M993_SLAP {
        displayName = "7.62mm 200Rnd M993 SLAP Tracer (Green)";
        displayNameShort = "M993 SLAP (Green)";
        descriptionShort = "7.62x51mm NATO 200-round belt, M993 SLAP, all green tracers";
        ammo = "GOL_B_762x51_M993_SLAP_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    // 7.62x51mm M993 SLAP magazines (MG3-specific drum box model)
    class GOL_MG3_100Rnd_762x51_M993_SLAP: GOL_MG3_100Rnd_762x51_M993 {
        displayName = "7.62mm 100Rnd M993 SLAP (MG3)";
        displayNameShort = "M993 SLAP";
        descriptionShort = "7.62x51mm NATO 100-round belt, M993 SLAP saboted light armor penetrator";
        ammo = "GOL_B_762x51_M993_SLAP";
    };

    class GOL_MG3_100Rnd_762x51_M993_SLAP_Tracer_Red: GOL_MG3_100Rnd_762x51_M993_SLAP {
        displayName = "7.62mm 100Rnd M993 SLAP Tracer (Red) (MG3)";
        displayNameShort = "M993 SLAP (Red)";
        descriptionShort = "7.62x51mm NATO 100-round belt, M993 SLAP, all red tracers";
        ammo = "GOL_B_762x51_M993_SLAP_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 100;
    };

    class GOL_MG3_100Rnd_762x51_M993_SLAP_Tracer_Green: GOL_MG3_100Rnd_762x51_M993_SLAP {
        displayName = "7.62mm 100Rnd M993 SLAP Tracer (Green) (MG3)";
        displayNameShort = "M993 SLAP (Green)";
        descriptionShort = "7.62x51mm NATO 100-round belt, M993 SLAP, all green tracers";
        ammo = "GOL_B_762x51_M993_SLAP_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 100;
    };

    class GOL_MG3_250Rnd_762x51_M993_SLAP: GOL_MG3_250Rnd_762x51_M993 {
        displayName = "7.62mm 250Rnd M993 SLAP (MG3)";
        displayNameShort = "M993 SLAP";
        descriptionShort = "7.62x51mm NATO 250-round drum belt, M993 SLAP saboted light armor penetrator";
        ammo = "GOL_B_762x51_M993_SLAP";
    };

    class GOL_MG3_250Rnd_762x51_M993_SLAP_Tracer_Red: GOL_MG3_250Rnd_762x51_M993_SLAP {
        displayName = "7.62mm 250Rnd M993 SLAP Tracer (Red) (MG3)";
        displayNameShort = "M993 SLAP (Red)";
        descriptionShort = "7.62x51mm NATO 250-round drum belt, M993 SLAP, all red tracers";
        ammo = "GOL_B_762x51_M993_SLAP_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 250;
    };

    class GOL_MG3_250Rnd_762x51_M993_SLAP_Tracer_Green: GOL_MG3_250Rnd_762x51_M993_SLAP {
        displayName = "7.62mm 250Rnd M993 SLAP Tracer (Green) (MG3)";
        displayNameShort = "M993 SLAP (Green)";
        descriptionShort = "7.62x51mm NATO 250-round drum belt, M993 SLAP, all green tracers";
        ammo = "GOL_B_762x51_M993_SLAP_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 250;
    };

    // 7.62x51mm M993 / SLAP magazines — FN MAG-specific (RHS model parent)
    class GOL_FNMAG_100Rnd_762x51_M993: rhsusf_100Rnd_762x51_m61_ap {
        scope = 2;
        count = 100;
        displayName = "7.62mm 100Rnd M993 AP (FN MAG)";
        displayNameShort = "M993";
        descriptionShort = "7.62x51mm NATO 100-round belt, M993 tungsten AP";
        ammo = "GOL_B_762x51_M993";
        tracersEvery = 0;
    };
    class GOL_FNMAG_100Rnd_762x51_M993_Tracer_Red: GOL_FNMAG_100Rnd_762x51_M993 {
        displayName = "7.62mm 100Rnd M993 AP Tracer (Red) (FN MAG)";
        displayNameShort = "M993 (Red)";
        ammo = "GOL_B_762x51_M993_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 100;
    };
    class GOL_FNMAG_100Rnd_762x51_M993_Tracer_Green: GOL_FNMAG_100Rnd_762x51_M993 {
        displayName = "7.62mm 100Rnd M993 AP Tracer (Green) (FN MAG)";
        displayNameShort = "M993 (Green)";
        ammo = "GOL_B_762x51_M993_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 100;
    };
    class GOL_FNMAG_150Rnd_762x51_M993: rhsusf_100Rnd_762x51_m61_ap {
        scope = 2;
        count = 150;
        displayName = "7.62mm 150Rnd M993 AP (FN MAG)";
        displayNameShort = "M993 150";
        descriptionShort = "7.62x51mm NATO 150-round belt, M993 tungsten AP";
        ammo = "GOL_B_762x51_M993";
        tracersEvery = 0;
    };
    class GOL_FNMAG_150Rnd_762x51_M993_Tracer_Red: GOL_FNMAG_150Rnd_762x51_M993 {
        displayName = "7.62mm 150Rnd M993 AP Tracer (Red) (FN MAG)";
        displayNameShort = "M993 150 (Red)";
        ammo = "GOL_B_762x51_M993_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 150;
    };
    class GOL_FNMAG_150Rnd_762x51_M993_Tracer_Green: GOL_FNMAG_150Rnd_762x51_M993 {
        displayName = "7.62mm 150Rnd M993 AP Tracer (Green) (FN MAG)";
        displayNameShort = "M993 150 (Green)";
        ammo = "GOL_B_762x51_M993_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 150;
    };
    class GOL_FNMAG_200Rnd_762x51_M993: rhsusf_100Rnd_762x51_m61_ap {
        scope = 2;
        count = 200;
        displayName = "7.62mm 200Rnd M993 AP (FN MAG)";
        displayNameShort = "M993 200";
        descriptionShort = "7.62x51mm NATO 200-round belt, M993 tungsten AP";
        ammo = "GOL_B_762x51_M993";
        tracersEvery = 0;
    };
    class GOL_FNMAG_200Rnd_762x51_M993_Tracer_Red: GOL_FNMAG_200Rnd_762x51_M993 {
        displayName = "7.62mm 200Rnd M993 AP Tracer (Red) (FN MAG)";
        displayNameShort = "M993 200 (Red)";
        ammo = "GOL_B_762x51_M993_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };
    class GOL_FNMAG_200Rnd_762x51_M993_Tracer_Green: GOL_FNMAG_200Rnd_762x51_M993 {
        displayName = "7.62mm 200Rnd M993 AP Tracer (Green) (FN MAG)";
        displayNameShort = "M993 200 (Green)";
        ammo = "GOL_B_762x51_M993_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };
    class GOL_FNMAG_100Rnd_762x51_M993_SLAP: GOL_FNMAG_100Rnd_762x51_M993 {
        displayName = "7.62mm 100Rnd M993 SLAP (FN MAG)";
        displayNameShort = "M993 SLAP";
        descriptionShort = "7.62x51mm NATO 100-round belt, M993 SLAP saboted light armor penetrator";
        ammo = "GOL_B_762x51_M993_SLAP";
        tracersEvery = 0;
    };
    class GOL_FNMAG_100Rnd_762x51_M993_SLAP_Tracer_Red: GOL_FNMAG_100Rnd_762x51_M993_SLAP {
        displayName = "7.62mm 100Rnd M993 SLAP Tracer (Red) (FN MAG)";
        displayNameShort = "M993 SLAP (Red)";
        ammo = "GOL_B_762x51_M993_SLAP_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 100;
    };
    class GOL_FNMAG_100Rnd_762x51_M993_SLAP_Tracer_Green: GOL_FNMAG_100Rnd_762x51_M993_SLAP {
        displayName = "7.62mm 100Rnd M993 SLAP Tracer (Green) (FN MAG)";
        displayNameShort = "M993 SLAP (Green)";
        ammo = "GOL_B_762x51_M993_SLAP_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 100;
    };
    class GOL_FNMAG_200Rnd_762x51_M993_SLAP: GOL_FNMAG_200Rnd_762x51_M993 {
        displayName = "7.62mm 200Rnd M993 SLAP (FN MAG)";
        displayNameShort = "M993 SLAP";
        descriptionShort = "7.62x51mm NATO 200-round belt, M993 SLAP saboted light armor penetrator";
        ammo = "GOL_B_762x51_M993_SLAP";
        tracersEvery = 0;
    };
    class GOL_FNMAG_200Rnd_762x51_M993_SLAP_Tracer_Red: GOL_FNMAG_200Rnd_762x51_M993_SLAP {
        displayName = "7.62mm 200Rnd M993 SLAP Tracer (Red) (FN MAG)";
        displayNameShort = "M993 SLAP (Red)";
        ammo = "GOL_B_762x51_M993_SLAP_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };
    class GOL_FNMAG_200Rnd_762x51_M993_SLAP_Tracer_Green: GOL_FNMAG_200Rnd_762x51_M993_SLAP {
        displayName = "7.62mm 200Rnd M993 SLAP Tracer (Green) (FN MAG)";
        displayNameShort = "M993 SLAP (Green)";
        ammo = "GOL_B_762x51_M993_SLAP_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    // MMG_02 SPMG .338 magazines with red tracers
    class 130Rnd_338_Mag;
    
    class GOL_130Rnd_338_Mag: 130Rnd_338_Mag {
        scope = 2;
        displayName = ".338 130Rnd Belt";
        displayNameShort = ".338";
        descriptionShort = ".338 Norma Magnum 130-round belt, ball ammunition";
        tracersEvery = 0;
    };

    class GOL_130Rnd_338_Mag_red: GOL_130Rnd_338_Mag {
        displayName = ".338 130Rnd Tracer (Red)";
        displayNameShort = ".338 (Red)";
        descriptionShort = ".338 Norma Magnum 130-round belt, all red tracers";
        ammo = "GOL_B_338_Ball_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 130;
    };

    class GOL_130Rnd_338_Mag_green: GOL_130Rnd_338_Mag {
        displayName = ".338 130Rnd Tracer (Green)";
        displayNameShort = ".338 (Green)";
        descriptionShort = ".338 Norma Magnum 130-round belt, all green tracers";
        ammo = "GOL_B_338_Ball_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 130;
    };

    class GOL_200Rnd_338_Mag: GOL_130Rnd_338_Mag {
        displayName = ".338 200Rnd Belt";
        displayNameShort = ".338 200";
        descriptionShort = ".338 Norma Magnum 200-round belt, ball ammunition";
        count = 200;
        mass = 90;
    };

    class GOL_200Rnd_338_Mag_red: GOL_200Rnd_338_Mag {
        displayName = ".338 200Rnd Tracer (Red)";
        displayNameShort = ".338 (Red)";
        descriptionShort = ".338 Norma Magnum 200-round belt, all red tracers";
        ammo = "GOL_B_338_Ball_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    class GOL_200Rnd_338_Mag_green: GOL_200Rnd_338_Mag {
        displayName = ".338 200Rnd Tracer (Green)";
        displayNameShort = ".338 (Green)";
        descriptionShort = ".338 Norma Magnum 200-round belt, all green tracers";
        ammo = "GOL_B_338_Ball_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    // .338 AP magazines — 70% of .50 cal, penetrates BTR-60 class armor
    class GOL_130Rnd_338_AP: GOL_130Rnd_338_Mag {
        displayName = ".338 130Rnd AP";
        displayNameShort = ".338 AP";
        descriptionShort = ".338 Norma Magnum 130-round belt, AP armor-piercing";
        ammo = "GOL_B_338_Ball_AP";
    };

    class GOL_130Rnd_338_AP_Tracer_Red: GOL_130Rnd_338_AP {
        displayName = ".338 130Rnd AP Tracer (Red)";
        displayNameShort = ".338 AP (Red)";
        descriptionShort = ".338 Norma Magnum 130-round belt, AP, all red tracers";
        ammo = "GOL_B_338_Ball_AP_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 130;
    };

    class GOL_130Rnd_338_AP_Tracer_Green: GOL_130Rnd_338_AP {
        displayName = ".338 130Rnd AP Tracer (Green)";
        displayNameShort = ".338 AP (Green)";
        descriptionShort = ".338 Norma Magnum 130-round belt, AP, all green tracers";
        ammo = "GOL_B_338_Ball_AP_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 130;
    };

    class GOL_200Rnd_338_AP: GOL_200Rnd_338_Mag {
        displayName = ".338 200Rnd AP";
        displayNameShort = ".338 AP";
        descriptionShort = ".338 Norma Magnum 200-round belt, AP armor-piercing";
        ammo = "GOL_B_338_Ball_AP";
    };

    class GOL_200Rnd_338_AP_Tracer_Red: GOL_200Rnd_338_AP {
        displayName = ".338 200Rnd AP Tracer (Red)";
        displayNameShort = ".338 AP (Red)";
        descriptionShort = ".338 Norma Magnum 200-round belt, AP, all red tracers";
        ammo = "GOL_B_338_Ball_AP_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    class GOL_200Rnd_338_AP_Tracer_Green: GOL_200Rnd_338_AP {
        displayName = ".338 200Rnd AP Tracer (Green)";
        displayNameShort = ".338 AP (Green)";
        descriptionShort = ".338 Norma Magnum 200-round belt, AP, all green tracers";
        ammo = "GOL_B_338_Ball_AP_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    // 5.56mm AP45 magazines (vanilla STANAG base)
    class 30Rnd_556x45_Stanag;
    
    class GOL_30Rnd_556x45_AP45: 30Rnd_556x45_Stanag {
        scope = 2;
        displayName = "5.56mm 30Rnd AP45";
        displayNameShort = "AP45";
        descriptionShort = "5.56x45mm NATO 30-round STANAG, Nammo AP45 armor-piercing, last 5 red tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Red";
        tracersEvery = 0;
        lastRoundsTracer = 5;
    };

    class GOL_30Rnd_556x45_AP45_Tracer_Red: GOL_30Rnd_556x45_AP45 {
        displayName = "5.56mm 30Rnd AP45 Tracer (Red)";
        displayNameShort = "AP45 Tracer";
        descriptionShort = "5.56x45mm NATO 30-round STANAG, Nammo AP45, all red tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 30;
    };

    class GOL_30Rnd_556x45_AP45_Tracer_Green: GOL_30Rnd_556x45_AP45 {
        displayName = "5.56mm 30Rnd AP45 Tracer (Green)";
        displayNameShort = "AP45 Tracer (Green)";
        descriptionShort = "5.56x45mm NATO 30-round STANAG, Nammo AP45, all green tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 30;
    };

    class GOL_30Rnd_556x45_AP45_Tracer_Yellow: GOL_30Rnd_556x45_AP45 {
        displayName = "5.56mm 30Rnd AP45 Tracer (Yellow)";
        displayNameShort = "AP45 Tracer (Yellow)";
        descriptionShort = "5.56x45mm NATO 30-round STANAG, Nammo AP45, all yellow tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Yellow";
        tracersEvery = 1;
        lastRoundsTracer = 30;
    };

    // 5.56mm AP45 reload tracer variants (last 5 rounds are tracers)
    class GOL_30Rnd_556x45_AP45_Reload_Tracer_Red: GOL_30Rnd_556x45_AP45 {
        displayName = "5.56mm 30Rnd AP45 Reload Tracer (Red)";
        displayNameShort = "AP45 RT (Red)";
        descriptionShort = "5.56x45mm NATO 30-round STANAG, Nammo AP45, last 5 red tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Red";
    };

    class GOL_30Rnd_556x45_AP45_Reload_Tracer_Green: GOL_30Rnd_556x45_AP45 {
        displayName = "5.56mm 30Rnd AP45 Reload Tracer (Green)";
        displayNameShort = "AP45 RT (Green)";
        descriptionShort = "5.56x45mm NATO 30-round STANAG, Nammo AP45, last 5 green tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Green";
    };

    class GOL_30Rnd_556x45_AP45_Reload_Tracer_Yellow: GOL_30Rnd_556x45_AP45 {
        displayName = "5.56mm 30Rnd AP45 Reload Tracer (Yellow)";
        displayNameShort = "AP45 RT (Yellow)";
        descriptionShort = "5.56x45mm NATO 30-round STANAG, Nammo AP45, last 5 yellow tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Yellow";
    };

    // 5.56mm AP45 mixed tracer variants (every 4th round is a tracer)
    class GOL_30Rnd_556x45_AP45_Mixed_Red: GOL_30Rnd_556x45_AP45 {
        displayName = "5.56mm 30Rnd AP45 Mixed (Red)";
        displayNameShort = "AP45 Mixed (Red)";
        descriptionShort = "5.56x45mm NATO 30-round STANAG, Nammo AP45, every 4th round red tracer";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Red";
        tracersEvery = 4;
    };

    class GOL_30Rnd_556x45_AP45_Mixed_Green: GOL_30Rnd_556x45_AP45 {
        displayName = "5.56mm 30Rnd AP45 Mixed (Green)";
        displayNameShort = "AP45 Mixed (Green)";
        descriptionShort = "5.56x45mm NATO 30-round STANAG, Nammo AP45, every 4th round green tracer";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Green";
        tracersEvery = 4;
    };

    class GOL_30Rnd_556x45_AP45_Mixed_Yellow: GOL_30Rnd_556x45_AP45 {
        displayName = "5.56mm 30Rnd AP45 Mixed (Yellow)";
        displayNameShort = "AP45 Mixed (Yellow)";
        descriptionShort = "5.56x45mm NATO 30-round STANAG, Nammo AP45, every 4th round yellow tracer";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Yellow";
        tracersEvery = 4;
    };

    // 5.56mm AP45 magazines (G36-type, inherits G36 model/mass/initspeed)
    class UK3CB_G36_30rnd_556x45;

    class GOL_G36_30Rnd_556x45_AP45: UK3CB_G36_30rnd_556x45 {
        scope = 2;
        displayName = "30rnd HK G36 AP45";
        displayNameShort = "AP45";
        descriptionShort = "5.56x45mm 30-round G36 magazine, Nammo AP45 armor-piercing, last 5 red tracers";
        ammo = "GOL_B_556x45_Ball_AP45";
        tracersEvery = 0;
        lastRoundsTracer = 5;
    };

    class GOL_G36_30Rnd_556x45_AP45_Tracer_Red: GOL_G36_30Rnd_556x45_AP45 {
        displayName = "30rnd HK G36 AP45 Tracer (Red)";
        displayNameShort = "AP45 Tracer";
        descriptionShort = "5.56x45mm 30-round G36 magazine, Nammo AP45, all red tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 30;
    };

    class GOL_G36_30Rnd_556x45_AP45_Tracer_Green: GOL_G36_30Rnd_556x45_AP45 {
        displayName = "30rnd HK G36 AP45 Tracer (Green)";
        displayNameShort = "AP45 Tracer (Green)";
        descriptionShort = "5.56x45mm 30-round G36 magazine, Nammo AP45, all green tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 30;
    };

    class GOL_G36_30Rnd_556x45_AP45_Tracer_Yellow: GOL_G36_30Rnd_556x45_AP45 {
        displayName = "30rnd HK G36 AP45 Tracer (Yellow)";
        displayNameShort = "AP45 Tracer (Yellow)";
        descriptionShort = "5.56x45mm 30-round G36 magazine, Nammo AP45, all yellow tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Yellow";
        tracersEvery = 1;
        lastRoundsTracer = 30;
    };

    // 200-round belt variants (vanilla base)
    class 200Rnd_556x45_Box_Tracer_Red_F;
    
    class GOL_200Rnd_556x45_AP45_Box: 200Rnd_556x45_Box_Tracer_Red_F {
        scope = 2;
        displayName = "5.56mm 200Rnd AP45 Box";
        displayNameShort = "AP45";
        descriptionShort = "5.56x45mm NATO 200-round box, Nammo AP45 armor-piercing";
        ammo = "GOL_B_556x45_Ball_AP45";
        tracersEvery = 0;
        ACE_isBelt = 1;
    };

    class GOL_200Rnd_556x45_AP45_Box_Tracer_Red: GOL_200Rnd_556x45_AP45_Box {
        displayName = "5.56mm 200Rnd AP45 Tracer (Red)";
        displayNameShort = "AP45 Tracer";
        descriptionShort = "5.56x45mm NATO 200-round box, Nammo AP45, all red tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    class GOL_200Rnd_556x45_AP45_Box_Tracer_Green: GOL_200Rnd_556x45_AP45_Box {
        displayName = "5.56mm 200Rnd AP45 Tracer (Green)";
        displayNameShort = "AP45 Tracer (Green)";
        descriptionShort = "5.56x45mm NATO 200-round box, Nammo AP45, all green tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    class GOL_200Rnd_556x45_AP45_Box_Tracer_Yellow: GOL_200Rnd_556x45_AP45_Box {
        displayName = "5.56mm 200Rnd AP45 Tracer (Yellow)";
        displayNameShort = "AP45 Tracer (Yellow)";
        descriptionShort = "5.56x45mm NATO 200-round box, Nammo AP45, all yellow tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Yellow";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    // UK3CB 200-round belt variant
    class UK3CB_BAF_556_200Rnd_T;
    
    class GOL_UK3CB_BAF_556_200Rnd_AP45: UK3CB_BAF_556_200Rnd_T {
        scope = 2;
        displayName = "5.56mm 200Rnd AP45 Box (UK3CB)";
        displayNameShort = "AP45";
        descriptionShort = "5.56x45mm NATO 200-round box, Nammo AP45 armor-piercing";
        ammo = "GOL_B_556x45_Ball_AP45";
        tracersEvery = 0;
    };

    class GOL_UK3CB_BAF_556_200Rnd_AP45_T_Red: GOL_UK3CB_BAF_556_200Rnd_AP45 {
        displayName = "5.56mm 200Rnd AP45 Tracer (Red, UK3CB)";
        displayNameShort = "AP45 Tracer";
        descriptionShort = "5.56x45mm NATO 200-round box, Nammo AP45, all red tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    class GOL_UK3CB_BAF_556_200Rnd_AP45_T_Green: GOL_UK3CB_BAF_556_200Rnd_AP45 {
        displayName = "5.56mm 200Rnd AP45 Tracer (Green, UK3CB)";
        displayNameShort = "AP45 Tracer (Green)";
        descriptionShort = "5.56x45mm NATO 200-round box, Nammo AP45, all green tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    class GOL_UK3CB_BAF_556_200Rnd_AP45_T_Yellow: GOL_UK3CB_BAF_556_200Rnd_AP45 {
        displayName = "5.56mm 200Rnd AP45 Tracer (Yellow, UK3CB)";
        displayNameShort = "AP45 Tracer (Yellow)";
        descriptionShort = "5.56x45mm NATO 200-round box, Nammo AP45, all yellow tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Yellow";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    // RHS 200-round box variant
    class rhsusf_200rnd_556x45_mixed_box;
    
    class GOL_rhsusf_200rnd_556x45_AP45: rhsusf_200rnd_556x45_mixed_box {
        scope = 2;
        displayName = "5.56mm 200Rnd AP45 Box (RHS)";
        displayNameShort = "AP45";
        descriptionShort = "5.56x45mm NATO 200-round box, Nammo AP45 armor-piercing";
        ammo = "GOL_B_556x45_Ball_AP45";
        tracersEvery = 0;
    };

    class GOL_rhsusf_200rnd_556x45_AP45_tracer_red: GOL_rhsusf_200rnd_556x45_AP45 {
        displayName = "5.56mm 200Rnd AP45 Tracer (Red, RHS)";
        displayNameShort = "AP45 Tracer";
        descriptionShort = "5.56x45mm NATO 200-round box, Nammo AP45, all red tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    class GOL_rhsusf_200rnd_556x45_AP45_tracer_green: GOL_rhsusf_200rnd_556x45_AP45 {
        displayName = "5.56mm 200Rnd AP45 Tracer (Green, RHS)";
        displayNameShort = "AP45 Tracer (Green)";
        descriptionShort = "5.56x45mm NATO 200-round box, Nammo AP45, all green tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    class GOL_rhsusf_200rnd_556x45_AP45_tracer_yellow: GOL_rhsusf_200rnd_556x45_AP45 {
        displayName = "5.56mm 200Rnd AP45 Tracer (Yellow, RHS)";
        displayNameShort = "AP45 Tracer (Yellow)";
        descriptionShort = "5.56x45mm NATO 200-round box, Nammo AP45, all yellow tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Yellow";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

	// GOL Mini Hand Grenade magazine
	class GOL_HandGrenade_Mini: HandGrenade {
		scope = 2;
		scopeArsenal = 2;
		scopeCurator = 2;
		displayName = "M67 Fragmentation Grenade (AI)";
		displayNameShort = "M67 AI Grenade";
		descriptionShort = "Compact hand grenade with reduced blast radius.";
		ammo = "Mini_Grenade";
	};

	// ==================== GOL Accurate RPG-7 Magazines ====================
	// All use VS mag as base for consistent initSpeed/mass/maxLeadSpeed.
	class rhs_rpg7_PG7VS_mag;

	class GOL_mag_rpg7_PG7VL: rhs_rpg7_PG7VS_mag {
		scope = 2;
		scopeArsenal = 2;
		displayName = "RPG-7 PG-7VL (GOL)";
		displayNameShort = "PG-7VL";
		descriptionShort = "HEAT anti-armour round. Identical trajectory to all GOL RPG rounds.";
		model = "\rhsafrf\addons\rhs_weapons\rpg7\magazines\rhs_pg7vl_mag";
		modelSpecial = "\rhsafrf\addons\rhs_weapons\mag_proxies\rhs_mag_pg7vl";
		ammo = "GOL_ammo_PG7VL";
	};

	class GOL_mag_rpg7_OG7V: rhs_rpg7_PG7VS_mag {
		scope = 2;
		scopeArsenal = 2;
		displayName = "RPG-7 OG-7V (GOL)";
		displayNameShort = "OG-7V";
		descriptionShort = "HE fragmentation round. Identical trajectory to all GOL RPG rounds.";
		model = "\rhsafrf\addons\rhs_weapons\rpg7\magazines\rhs_og7v_mag";
		modelSpecial = "\rhsafrf\addons\rhs_weapons\mag_proxies\rhs_mag_og7v";
		ammo = "GOL_ammo_OG7V";
	};

	class GOL_mag_rpg7_TBG7V: rhs_rpg7_PG7VS_mag {
		scope = 2;
		scopeArsenal = 2;
		displayName = "RPG-7 TBG-7V (GOL)";
		displayNameShort = "TBG-7V";
		descriptionShort = "Thermobaric round. Identical trajectory to all GOL RPG rounds.";
		model = "\rhsafrf\addons\rhs_weapons\rpg7\magazines\rhs_tbg7v_mag";
		modelSpecial = "\rhsafrf\addons\rhs_weapons\mag_proxies\rhs_mag_tbg7v";
		ammo = "GOL_ammo_TBG7V";
	};

	class GOL_mag_rpg7_Modern: rhs_rpg7_PG7VS_mag {
		scope = 2;
		scopeArsenal = 2;
		displayName = "RPG-7 Modern HEAT (GOL)";
		displayNameShort = "Modern HEAT";
		descriptionShort = "Precision modern HEAT round. Sight-aligned flight path, boosted warhead.";
		ammo = "GOL_ammo_Modern";
	};
};