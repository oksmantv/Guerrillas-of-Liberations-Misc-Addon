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

    // 9.3x64mm SLAP belt magazines — 150-round
    class GOL_150Rnd_93x64_Mag_SLAP: GOL_150Rnd_93x64_Mag {
        scope = 2;
        displayName = "9.3 mm 150Rnd SLAP Belt";
        displayNameShort = "SLAP";
        descriptionShort = "9.3x64mm 150-round belt, SLAP armor-piercing";
        ammo = "GOL_B_93x64_Ball_SLAP";
        tracersEvery = 0;
    };

    class GOL_150Rnd_93x64_Mag_SLAP_Tracer_Red: GOL_150Rnd_93x64_Mag_SLAP {
        displayName = "9.3 mm 150Rnd SLAP Tracer (Red)";
        displayNameShort = "SLAP-T (Red)";
        descriptionShort = "9.3x64mm 150-round belt, SLAP with red tracers";
        ammo = "GOL_B_93x64_Ball_SLAP_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 150;
    };

    class GOL_150Rnd_93x64_Mag_SLAP_Tracer_Green: GOL_150Rnd_93x64_Mag_SLAP {
        displayName = "9.3 mm 150Rnd SLAP Tracer (Green)";
        displayNameShort = "SLAP-T (Green)";
        descriptionShort = "9.3x64mm 150-round belt, SLAP with green tracers";
        ammo = "GOL_B_93x64_Ball_SLAP_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 150;
    };

    class GOL_150Rnd_93x64_Mag_SLAP_Tracer_Yellow: GOL_150Rnd_93x64_Mag_SLAP {
        displayName = "9.3 mm 150Rnd SLAP Tracer (Yellow)";
        displayNameShort = "SLAP-T (Yellow)";
        descriptionShort = "9.3x64mm 150-round belt, SLAP with yellow tracers";
        ammo = "GOL_B_93x64_Ball_SLAP_Tracer_Yellow";
        tracersEvery = 1;
        lastRoundsTracer = 150;
    };

    // 9.3x64mm extended belt magazines — 200-round
    class GOL_200Rnd_93x64_Mag: GOL_150Rnd_93x64_Mag {
        scope = 2;
        displayName = "9.3 mm 200Rnd Belt";
        displayNameShort = "9.3mm";
        descriptionShort = "9.3x64mm 200-round belt, ball ammunition";
        count = 200;
        mass = 93;
    };

    class GOL_200Rnd_93x64_Mag_Tracer: GOL_200Rnd_93x64_Mag {
        displayName = "9.3 mm 200Rnd Tracer (Red)";
        displayNameShort = "Tracer";
        descriptionShort = "9.3x64mm 200-round belt, all red tracers";
        ammo = "GOL_B_93x64_Ball_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    class GOL_200Rnd_93x64_Mag_Tracer_Red: GOL_200Rnd_93x64_Mag_Tracer {
        displayName = "9.3 mm 200Rnd Tracer (Red)";
        ammo = "GOL_B_93x64_Ball_Tracer_Red";
    };

    class GOL_200Rnd_93x64_Mag_Tracer_Green: GOL_200Rnd_93x64_Mag_Tracer {
        displayName = "9.3 mm 200Rnd Tracer (Green)";
        displayNameShort = "Tracer (Green)";
        descriptionShort = "9.3x64mm 200-round belt, all green tracers";
        ammo = "GOL_B_93x64_Ball_Tracer_Green";
    };

    class GOL_200Rnd_93x64_Mag_Tracer_Yellow: GOL_200Rnd_93x64_Mag_Tracer {
        displayName = "9.3 mm 200Rnd Tracer (Yellow)";
        displayNameShort = "Tracer (Yellow)";
        descriptionShort = "9.3x64mm 200-round belt, all yellow tracers";
        ammo = "GOL_B_93x64_Ball_Tracer_Yellow";
    };

    // 9.3x64mm SLAP belt magazines — 200-round
    class GOL_200Rnd_93x64_Mag_SLAP: GOL_200Rnd_93x64_Mag {
        scope = 2;
        displayName = "9.3 mm 200Rnd SLAP Belt";
        displayNameShort = "SLAP";
        descriptionShort = "9.3x64mm 200-round belt, SLAP armor-piercing";
        ammo = "GOL_B_93x64_Ball_SLAP";
        tracersEvery = 0;
    };

    class GOL_200Rnd_93x64_Mag_SLAP_Tracer_Red: GOL_200Rnd_93x64_Mag_SLAP {
        displayName = "9.3 mm 200Rnd SLAP Tracer (Red)";
        displayNameShort = "SLAP-T (Red)";
        descriptionShort = "9.3x64mm 200-round belt, SLAP with red tracers";
        ammo = "GOL_B_93x64_Ball_SLAP_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    class GOL_200Rnd_93x64_Mag_SLAP_Tracer_Green: GOL_200Rnd_93x64_Mag_SLAP {
        displayName = "9.3 mm 200Rnd SLAP Tracer (Green)";
        displayNameShort = "SLAP-T (Green)";
        descriptionShort = "9.3x64mm 200-round belt, SLAP with green tracers";
        ammo = "GOL_B_93x64_Ball_SLAP_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    class GOL_200Rnd_93x64_Mag_SLAP_Tracer_Yellow: GOL_200Rnd_93x64_Mag_SLAP {
        displayName = "9.3 mm 200Rnd SLAP Tracer (Yellow)";
        displayNameShort = "SLAP-T (Yellow)";
        descriptionShort = "9.3x64mm 200-round belt, SLAP with yellow tracers";
        ammo = "GOL_B_93x64_Ball_SLAP_Tracer_Yellow";
        tracersEvery = 1;
        lastRoundsTracer = 200;
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
        displayNameShort = "M993";
        descriptionShort = "7.62x51mm NATO 150-round belt, M993 tungsten AP";
        ammo = "GOL_B_762x51_M993";
        count = 150;
        tracersEvery = 0;
        lastRoundsTracer = 0;
    };

    class GOL_150Rnd_762x51_M993_Tracer_Red: GOL_150Rnd_762x51_M993 {
        displayName = "7.62mm 150Rnd M993 AP Tracer (Red)";
        displayNameShort = "M993 (Red)";
        descriptionShort = "7.62x51mm NATO 150-round belt, M993 AP, all red tracers";
        ammo = "GOL_B_762x51_M993_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 150;
    };

    class GOL_150Rnd_762x51_M993_Tracer_Green: GOL_150Rnd_762x51_M993 {
        displayName = "7.62mm 150Rnd M993 AP Tracer (Green)";
        displayNameShort = "M993 (Green)";
        descriptionShort = "7.62x51mm NATO 150-round belt, M993 AP, all green tracers";
        ammo = "GOL_B_762x51_M993_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 150;
    };

    // 200-round belt — inherits BAF L110 762 200Rnd model/UI (belt box), overrides count
    class GOL_200Rnd_762x51_M993: UK3CB_BAF_762_200Rnd {
        scope = 2;
        displayName = "7.62mm 200Rnd M993 AP";
        displayNameShort = "M993";
        descriptionShort = "7.62x51mm NATO 200-round belt, M993 tungsten AP";
        ammo = "GOL_B_762x51_M993";
        count = 200;
        tracersEvery = 0;
        lastRoundsTracer = 0;
    };

    class GOL_200Rnd_762x51_M993_Tracer_Red: GOL_200Rnd_762x51_M993 {
        displayName = "7.62mm 200Rnd M993 AP Tracer (Red)";
        displayNameShort = "M993 (Red)";
        descriptionShort = "7.62x51mm NATO 200-round belt, M993 AP, all red tracers";
        ammo = "GOL_B_762x51_M993_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };

    class GOL_200Rnd_762x51_M993_Tracer_Green: GOL_200Rnd_762x51_M993 {
        displayName = "7.62mm 200Rnd M993 AP Tracer (Green)";
        displayNameShort = "M993 (Green)";
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
        displayNameShort = "M993 AP";
        descriptionShort = "7.62x51mm NATO 250-round drum belt, M993 tungsten AP";
        ammo = "GOL_B_762x51_M993";
        tracersEvery = 0;
    };

    class GOL_MG3_250Rnd_762x51_M993_Tracer_Red: GOL_MG3_250Rnd_762x51_M993 {
        displayName = "7.62mm 250Rnd M993 AP Tracer (Red) (MG3)";
        displayNameShort = "M993 AP (Red)";
        descriptionShort = "7.62x51mm NATO 250-round drum belt, M993 AP, all red tracers";
        ammo = "GOL_B_762x51_M993_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 250;
    };

    class GOL_MG3_250Rnd_762x51_M993_Tracer_Green: GOL_MG3_250Rnd_762x51_M993 {
        displayName = "7.62mm 250Rnd M993 AP Tracer (Green) (MG3)";
        displayNameShort = "M993 AP (Green)";
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
        displayNameShort = "M993";
        descriptionShort = "7.62x51mm NATO 150-round belt, M993 tungsten AP";
        ammo = "GOL_B_762x51_M993";
        tracersEvery = 0;
    };
    class GOL_FNMAG_150Rnd_762x51_M993_Tracer_Red: GOL_FNMAG_150Rnd_762x51_M993 {
        displayName = "7.62mm 150Rnd M993 AP Tracer (Red) (FN MAG)";
        displayNameShort = "M993 (Red)";
        ammo = "GOL_B_762x51_M993_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 150;
    };
    class GOL_FNMAG_150Rnd_762x51_M993_Tracer_Green: GOL_FNMAG_150Rnd_762x51_M993 {
        displayName = "7.62mm 150Rnd M993 AP Tracer (Green) (FN MAG)";
        displayNameShort = "M993 (Green)";
        ammo = "GOL_B_762x51_M993_Tracer_Green";
        tracersEvery = 1;
        lastRoundsTracer = 150;
    };
    class GOL_FNMAG_200Rnd_762x51_M993: rhsusf_100Rnd_762x51_m61_ap {
        scope = 2;
        count = 200;
        displayName = "7.62mm 200Rnd M993 AP (FN MAG)";
        displayNameShort = "M993";
        descriptionShort = "7.62x51mm NATO 200-round belt, M993 tungsten AP";
        ammo = "GOL_B_762x51_M993";
        tracersEvery = 0;
    };
    class GOL_FNMAG_200Rnd_762x51_M993_Tracer_Red: GOL_FNMAG_200Rnd_762x51_M993 {
        displayName = "7.62mm 200Rnd M993 AP Tracer (Red) (FN MAG)";
        displayNameShort = "M993 (Red)";
        ammo = "GOL_B_762x51_M993_Tracer_Red";
        tracersEvery = 1;
        lastRoundsTracer = 200;
    };
    class GOL_FNMAG_200Rnd_762x51_M993_Tracer_Green: GOL_FNMAG_200Rnd_762x51_M993 {
        displayName = "7.62mm 200Rnd M993 AP Tracer (Green) (FN MAG)";
        displayNameShort = "M993 (Green)";
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
        displayNameShort = "AP45 Reload Tracer (Red)";
        descriptionShort = "5.56x45mm NATO 30-round STANAG, Nammo AP45, last 5 red tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Red";
    };

    class GOL_30Rnd_556x45_AP45_Reload_Tracer_Green: GOL_30Rnd_556x45_AP45 {
        displayName = "5.56mm 30Rnd AP45 Reload Tracer (Green)";
        displayNameShort = "AP45 Reload Tracer (Green)";
        descriptionShort = "5.56x45mm NATO 30-round STANAG, Nammo AP45, last 5 green tracers";
        ammo = "GOL_B_556x45_Ball_AP45_Tracer_Green";
    };

    class GOL_30Rnd_556x45_AP45_Reload_Tracer_Yellow: GOL_30Rnd_556x45_AP45 {
        displayName = "5.56mm 30Rnd AP45 Reload Tracer (Yellow)";
        displayNameShort = "AP45 Reload Tracer (Yellow)";
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
	// LEFT   reticle (VM markings) : PG-7VM (HEAT+)
	// RIGHT  reticle (VL markings) : OG-7V
	// CENTER reticle (VR markings) : TBG-7V, PG-7VR
	class rhs_rpg7_PG7V_mag;
	class rhs_rpg7_PG7VM_mag;
	class rhs_rpg7_PG7VL_mag;
	class rhs_rpg7_PG7VR_mag;

	class GOL_mag_rpg7_Modern: rhs_rpg7_PG7VM_mag {
		scope = 2;
		scopeArsenal = 2;
		displayName = "PG-7VM+ (GOL)";
		displayNameShort = "PG-7VM+";
		descriptionShort = "HEAT+. Aim using LEFT reticle.";
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\magazines\rhs_rpg7_PG7VM_mag_ca.paa";
		mass = 22;
		ammo = "GOL_ammo_Modern";
	};

	class GOL_mag_rpg7_Type59: rhs_rpg7_PG7V_mag {
		scope = 2;
		scopeArsenal = 2;
		displayName = "Type-59 HEAT (GOL)";
		displayNameShort = "Type-59";
		descriptionShort = "Anti-personnel HEAT. Kills crew, damages components. Minimal structural blast. Aim using LEFT reticle.";
		mass = 18;
		ammo = "GOL_ammo_Type59HEAT";
	};

	class GOL_mag_rpg7_Type69: rhs_rpg7_PG7V_mag {
		scope = 2;
		scopeArsenal = 2;
		displayName = "Type-69 HEAT (GOL)";
		displayNameShort = "Type-69";
		descriptionShort = "Reduced-charge HEAT.";
		mass = 20;
		ammo = "GOL_ammo_Type69HEAT";
	};

	class GOL_mag_rpg7_Type69II: rhs_rpg7_PG7VL_mag {
		scope = 2;
		scopeArsenal = 2;
		displayName = "Type 69-II HEAT (GOL)";
		displayNameShort = "Type-69-II";
		descriptionShort = "Improved reduced-charge HEAT. Aim using RIGHT reticle.";
		mass = 22;
		ammo = "GOL_ammo_Type69II";
	};

	class GOL_mag_rpg7_OG7V: rhs_rpg7_PG7VL_mag {
		scope = 2;
		scopeArsenal = 2;
		displayName = "OG-7V (GOL)";
		displayNameShort = "OG-7V";
		descriptionShort = "HE fragmentation. Aim using RIGHT reticle.";
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\magazines\rhs_rpg7_OG7V_mag_ca.paa";
		model = "\rhsafrf\addons\rhs_weapons\rpg7\magazines\rhs_og7v_mag";
		modelSpecial = "\rhsafrf\addons\rhs_weapons\mag_proxies\rhs_mag_og7v";
		mass = 30;
		ammo = "GOL_ammo_OG7V";
	};

	class GOL_mag_rpg7_TBG7V: rhs_rpg7_PG7VR_mag {
		scope = 2;
		scopeArsenal = 2;
		displayName = "TBG-7V (GOL)";
		displayNameShort = "TBG-7V";
		descriptionShort = "Thermobaric. Aim using CENTER reticle.";
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\magazines\rhs_rpg7_TBG7V_mag_ca.paa";
		model = "\rhsafrf\addons\rhs_weapons\rpg7\magazines\rhs_tbg7v_mag";
		modelSpecial = "\rhsafrf\addons\rhs_weapons\mag_proxies\rhs_mag_tbg7v";
		mass = 52;
		ammo = "GOL_ammo_TBG7V";
	};

	class GOL_mag_rpg7_VR: rhs_rpg7_PG7VR_mag {
		scope = 2;
		scopeArsenal = 2;
		displayName = "PG-7VR (GOL)";
		displayNameShort = "PG-7VR";
		descriptionShort = "Tandem HEAT — defeats ERA. Aim using CENTER reticle.";
		picture = "\rhsafrf\addons\rhs_inventoryicons\data\magazines\rhs_rpg7_PG7VR_mag_ca.paa";
		model = "\rhsafrf\addons\rhs_weapons\rpg7\magazines\rhs_pg7vr_mag";
		modelSpecial = "\rhsafrf\addons\rhs_weapons\mag_proxies\rhs_mag_pg7vr";
		mass = 56;
		ammo = "GOL_ammo_PG7VR";
	};

	// ===== UK59N 7.62x51 NATO belts =====
	// Parent: UK3CB_UK59_100Rnd_762x51_Magazine_R (provides correct model, picture, mass).
	// count overridden to 100/200 as needed.
	class UK3CB_UK59_100Rnd_762x51_Magazine_R;

	class GOL_UK59_100Rnd_762x51_M993: UK3CB_UK59_100Rnd_762x51_Magazine_R {
		scope = 2;
		scopeArsenal = 2;
		count = 100;
		displayName = "7.62mm 100Rnd M993 AP (UK59)";
		displayNameShort = "M993 AP";
		descriptionShort = "7.62x51mm 100-round belt, M993 tungsten AP, no tracer";
		ammo = "GOL_B_762x51_M993";
		tracersEvery = 0;
		lastRoundsTracer = 0;
	};

	class GOL_UK59_100Rnd_762x51_M993_Tracer_Red: GOL_UK59_100Rnd_762x51_M993 {
		displayName = "7.62mm 100Rnd M993 AP Tracer Red (UK59)";
		displayNameShort = "M993 AP (Red)";
		descriptionShort = "7.62x51mm 100-round belt, M993 AP, all red tracers";
		ammo = "GOL_B_762x51_M993_Tracer_Red";
		tracersEvery = 1;
		lastRoundsTracer = 100;
	};

	class GOL_UK59_100Rnd_762x51_M993_Tracer_Green: GOL_UK59_100Rnd_762x51_M993 {
		displayName = "7.62mm 100Rnd M993 AP Tracer Green (UK59)";
		displayNameShort = "M993 AP (Green)";
		descriptionShort = "7.62x51mm 100-round belt, M993 AP, all green tracers";
		ammo = "GOL_B_762x51_M993_Tracer_Green";
		tracersEvery = 1;
		lastRoundsTracer = 100;
	};

	class GOL_UK59_100Rnd_762x51_M993_Tracer_Yellow: GOL_UK59_100Rnd_762x51_M993 {
		displayName = "7.62mm 100Rnd M993 AP Tracer Yellow (UK59)";
		displayNameShort = "M993 AP (Yellow)";
		descriptionShort = "7.62x51mm 100-round belt, M993 AP, all yellow tracers";
		ammo = "GOL_B_762x51_M993_Tracer_Yellow";
		tracersEvery = 1;
		lastRoundsTracer = 100;
	};

	class GOL_UK59_200Rnd_762x51_M993: UK3CB_UK59_100Rnd_762x51_Magazine_R {
		scope = 2;
		scopeArsenal = 2;
		count = 200;
		displayName = "7.62mm 200Rnd M993 AP (UK59)";
		displayNameShort = "M993 AP";
		descriptionShort = "7.62x51mm 200-round belt, M993 tungsten AP, no tracer";
		ammo = "GOL_B_762x51_M993";
		tracersEvery = 0;
		lastRoundsTracer = 0;
	};

	class GOL_UK59_200Rnd_762x51_M993_Tracer_Red: GOL_UK59_200Rnd_762x51_M993 {
		displayName = "7.62mm 200Rnd M993 AP Tracer Red (UK59)";
		displayNameShort = "M993 AP (Red)";
		descriptionShort = "7.62x51mm 200-round belt, M993 AP, all red tracers";
		ammo = "GOL_B_762x51_M993_Tracer_Red";
		tracersEvery = 1;
		lastRoundsTracer = 200;
	};

	class GOL_UK59_200Rnd_762x51_M993_Tracer_Green: GOL_UK59_200Rnd_762x51_M993 {
		displayName = "7.62mm 200Rnd M993 AP Tracer Green (UK59)";
		displayNameShort = "M993 AP (Green)";
		descriptionShort = "7.62x51mm 200-round belt, M993 AP, all green tracers";
		ammo = "GOL_B_762x51_M993_Tracer_Green";
		tracersEvery = 1;
		lastRoundsTracer = 200;
	};

	class GOL_UK59_200Rnd_762x51_M993_Tracer_Yellow: GOL_UK59_200Rnd_762x51_M993 {
		displayName = "7.62mm 200Rnd M993 AP Tracer Yellow (UK59)";
		displayNameShort = "M993 AP (Yellow)";
		descriptionShort = "7.62x51mm 200-round belt, M993 AP, all yellow tracers";
		ammo = "GOL_B_762x51_M993_Tracer_Yellow";
		tracersEvery = 1;
		lastRoundsTracer = 200;
	};

	// ===== RPD 7.62x39 100Rnd belts =====
	// Parent: UK3CB_RPD_100rnd_762x39 — provides RPD belt model, picture, mass 33.7.
	class UK3CB_RPD_100rnd_762x39;

	class GOL_RPD_100Rnd_762x39: UK3CB_RPD_100rnd_762x39 {
		scope = 2;
		scopeArsenal = 2;
		displayName = "7.62x39mm 100Rnd Belt (GOL)";
		displayNameShort = "7.62x39";
		descriptionShort = "7.62x39mm 100-round belt, ball, no tracer";
	};

	class GOL_RPD_100Rnd_762x39_Tracer_Red: GOL_RPD_100Rnd_762x39 {
		displayName = "7.62x39mm 100Rnd Belt Tracer Red (GOL)";
		displayNameShort = "7.62x39 (Red)";
		descriptionShort = "7.62x39mm 100-round belt, all red tracers";
		ammo = "GOL_B_762x39_Ball_Tracer_Red";
		tracersEvery = 1;
		lastRoundsTracer = 100;
	};

	class GOL_RPD_100Rnd_762x39_Tracer_Green: GOL_RPD_100Rnd_762x39 {
		displayName = "7.62x39mm 100Rnd Belt Tracer Green (GOL)";
		displayNameShort = "7.62x39 (Green)";
		descriptionShort = "7.62x39mm 100-round belt, all green tracers";
		ammo = "GOL_B_762x39_Ball_Tracer_Green";
		tracersEvery = 1;
		lastRoundsTracer = 100;
	};

	class GOL_RPD_100Rnd_762x39_Tracer_Yellow: GOL_RPD_100Rnd_762x39 {
		displayName = "7.62x39mm 100Rnd Belt Tracer Yellow (GOL)";
		displayNameShort = "7.62x39 (Yellow)";
		descriptionShort = "7.62x39mm 100-round belt, all yellow tracers";
		ammo = "GOL_B_762x39_Ball_Tracer_Yellow";
		tracersEvery = 1;
		lastRoundsTracer = 100;
	};

	// ===== 7.62x39 75Rnd drum (RPK-12, 3CB RPK via CBA_762x39_RPK well) =====
	class rhs_75Rnd_762x39mm;

	class GOL_75Rnd_762x39: rhs_75Rnd_762x39mm {
		scope = 2;
		scopeArsenal = 2;
		displayName = "7.62x39mm 75Rnd Drum (GOL)";
		displayNameShort = "7.62x39";
		descriptionShort = "7.62x39mm 75-round drum, ball, no tracer";
	};

	class GOL_75Rnd_762x39_Tracer_Red: GOL_75Rnd_762x39 {
		displayName = "7.62x39mm 75Rnd Drum Tracer Red (GOL)";
		displayNameShort = "7.62x39 (Red)";
		descriptionShort = "7.62x39mm 75-round drum, all red tracers";
		ammo = "GOL_B_762x39_Ball_Tracer_Red";
		tracersEvery = 1;
		lastRoundsTracer = 75;
	};

	class GOL_75Rnd_762x39_Tracer_Green: GOL_75Rnd_762x39 {
		displayName = "7.62x39mm 75Rnd Drum Tracer Green (GOL)";
		displayNameShort = "7.62x39 (Green)";
		descriptionShort = "7.62x39mm 75-round drum, all green tracers";
		ammo = "GOL_B_762x39_Ball_Tracer_Green";
		tracersEvery = 1;
		lastRoundsTracer = 75;
	};

	class GOL_75Rnd_762x39_Tracer_Yellow: GOL_75Rnd_762x39 {
		displayName = "7.62x39mm 75Rnd Drum Tracer Yellow (GOL)";
		displayNameShort = "7.62x39 (Yellow)";
		descriptionShort = "7.62x39mm 75-round drum, all yellow tracers";
		ammo = "GOL_B_762x39_Ball_Tracer_Yellow";
		tracersEvery = 1;
		lastRoundsTracer = 75;
	};

	// ===== 5.45x39mm 7N22 AP 45Rnd box (RHS RPK-74M via CBA_545x39_RPK well) =====
	class rhs_45Rnd_545X39_7N22_AK;

	class GOL_45Rnd_545x39_7N22: rhs_45Rnd_545X39_7N22_AK {
		scope = 2;
		scopeArsenal = 2;
		displayName = "5.45x39mm 45Rnd 7N22 AP (GOL)";
		displayNameShort = "7N22 AP";
		descriptionShort = "5.45x39mm 45-round box, 7N22 armor-piercing, no tracer";
	};

	class GOL_45Rnd_545x39_7N22_Tracer_Red: GOL_45Rnd_545x39_7N22 {
		displayName = "5.45x39mm 45Rnd 7N22 AP Tracer Red (GOL)";
		displayNameShort = "7N22 AP (Red)";
		descriptionShort = "5.45x39mm 45-round box, 7N22 AP, all red tracers";
		ammo = "GOL_B_545x39_7N22_Tracer_Red";
		tracersEvery = 1;
		lastRoundsTracer = 45;
	};

	class GOL_45Rnd_545x39_7N22_Tracer_Green: GOL_45Rnd_545x39_7N22 {
		displayName = "5.45x39mm 45Rnd 7N22 AP Tracer Green (GOL)";
		displayNameShort = "7N22 AP (Green)";
		descriptionShort = "5.45x39mm 45-round box, 7N22 AP, all green tracers";
		ammo = "GOL_B_545x39_7N22_Tracer_Green";
		tracersEvery = 1;
		lastRoundsTracer = 45;
	};

	class GOL_45Rnd_545x39_7N22_Tracer_Yellow: GOL_45Rnd_545x39_7N22 {
		displayName = "5.45x39mm 45Rnd 7N22 AP Tracer Yellow (GOL)";
		displayNameShort = "7N22 AP (Yellow)";
		descriptionShort = "5.45x39mm 45-round box, 7N22 AP, all yellow tracers";
		ammo = "GOL_B_545x39_7N22_Tracer_Yellow";
		tracersEvery = 1;
		lastRoundsTracer = 45;
	};

	// ===== 6.5x39mm caseless 100Rnd belt (MX SW via MX_65x39_Large well) =====
	class 100Rnd_65x39_caseless_mag;

	class GOL_100Rnd_65x39_caseless: 100Rnd_65x39_caseless_mag {
		scope = 2;
		scopeArsenal = 2;
		displayName = "6.5mm 100Rnd Caseless Belt (GOL)";
		displayNameShort = "6.5mm";
		descriptionShort = "6.5x39mm caseless 100-round belt, ball, no tracer";
		ammo = "B_65x39_caseless";
		tracersEvery = 0;
		lastRoundsTracer = 0;
	};

	class GOL_100Rnd_65x39_caseless_Tracer_Red: GOL_100Rnd_65x39_caseless {
		displayName = "6.5mm 100Rnd Caseless Belt Tracer Red (GOL)";
		displayNameShort = "6.5mm (Red)";
		descriptionShort = "6.5x39mm caseless 100-round belt, all red tracers";
		ammo = "GOL_B_65x39_caseless_Tracer_Red";
		tracersEvery = 1;
		lastRoundsTracer = 100;
	};

	class GOL_100Rnd_65x39_caseless_Tracer_Green: GOL_100Rnd_65x39_caseless {
		displayName = "6.5mm 100Rnd Caseless Belt Tracer Green (GOL)";
		displayNameShort = "6.5mm (Green)";
		descriptionShort = "6.5x39mm caseless 100-round belt, all green tracers";
		ammo = "GOL_B_65x39_caseless_Tracer_Green";
		tracersEvery = 1;
		lastRoundsTracer = 100;
	};

	class GOL_100Rnd_65x39_caseless_Tracer_Yellow: GOL_100Rnd_65x39_caseless {
		displayName = "6.5mm 100Rnd Caseless Belt Tracer Yellow (GOL)";
		displayNameShort = "6.5mm (Yellow)";
		descriptionShort = "6.5x39mm caseless 100-round belt, all yellow tracers";
		ammo = "GOL_B_65x39_caseless_Tracer_Yellow";
		tracersEvery = 1;
		lastRoundsTracer = 100;
	};

	// ===== 6.5x39mm cased 200Rnd belt (LMG Mk200) =====
	// Mk200 has no magazineWell[]; GOL mags are added via magazines[] += in the weapon class.
	class 200Rnd_65x39_cased_Box;

	class GOL_200Rnd_65x39_cased_Box: 200Rnd_65x39_cased_Box {
		scope = 2;
		scopeArsenal = 2;
		displayName = "6.5mm 200Rnd Cased Belt (GOL)";
		displayNameShort = "6.5mm Cased";
		descriptionShort = "6.5x39mm cased 200-round belt, ball, no tracer";
		ammo = "B_65x39_caseless";
		tracersEvery = 0;
		lastRoundsTracer = 0;
	};

	class GOL_200Rnd_65x39_cased_Box_Tracer_Red: GOL_200Rnd_65x39_cased_Box {
		displayName = "6.5mm 200Rnd Cased Belt Tracer Red (GOL)";
		displayNameShort = "6.5mm Cased (Red)";
		descriptionShort = "6.5x39mm cased 200-round belt, all red tracers";
		ammo = "GOL_B_65x39_cased_Tracer_Red";
		tracersEvery = 1;
		lastRoundsTracer = 200;
	};

	class GOL_200Rnd_65x39_cased_Box_Tracer_Green: GOL_200Rnd_65x39_cased_Box {
		displayName = "6.5mm 200Rnd Cased Belt Tracer Green (GOL)";
		displayNameShort = "6.5mm Cased (Green)";
		descriptionShort = "6.5x39mm cased 200-round belt, all green tracers";
		ammo = "GOL_B_65x39_cased_Tracer_Green";
		tracersEvery = 1;
		lastRoundsTracer = 200;
	};

	class GOL_200Rnd_65x39_cased_Box_Tracer_Yellow: GOL_200Rnd_65x39_cased_Box {
		displayName = "6.5mm 200Rnd Cased Belt Tracer Yellow (GOL)";
		displayNameShort = "6.5mm Cased (Yellow)";
		descriptionShort = "6.5x39mm cased 200-round belt, all yellow tracers";
		ammo = "GOL_B_65x39_cased_Tracer_Yellow";
		tracersEvery = 1;
		lastRoundsTracer = 200;
	};

	// ============================================================
	// GOL M230 30mm Chain Gun Pod — Pylon Magazines
	//
	// Both variants share the same pylon pod model and hardpoints.
	// They appear as separate loadout options on the pylon screen,
	// letting crews choose between HE (anti-infantry/soft) or AP
	// (anti-armour/vehicle) ammunition before flight.
	//
	// Hardpoints:
	//   "DAR"              — covers most vanilla armed helicopters
	//                        (Hellcat, Pawnee, UH-80 Stub Wings, etc.)
	//   "GOL_M230_CHAINGUN"— custom hardpoint; add to specific GOL
	//                        helicopter compat classes as needed
	// ============================================================

	class 250Rnd_30mm_HE_shells;
	class 250Rnd_30mm_APDS_shells;

	// HE pylon pod — fragmentation/blast, effective vs infantry and light vehicles
	class GOL_PylonWeapon_M230_HE: 250Rnd_30mm_HE_shells {
		scope = 2;
		author = "Guerrillas of Liberation";
		displayName = "M230 30mm Chain Gun Pod (HE)";
		displayNameShort = "M230 HE Belt";
		descriptionShort = "M230 30mm Chain Gun | HE 250 rounds";
		muzzleImpulseFactor[] = {0.2, 0.5};   // vanilla parent is {1,4} — reduced to limit nose kick at high ROF
		count = 300;
		model = "\A3\Weapons_F\DynamicLoadout\PylonPod_Twin_Cannon_20mm.p3d";
		muzzlePos = "muzzlePos";
		muzzleEnd = "muzzleEnd";
		hardpoints[] = {"DAR", "GOL_M230_CHAINGUN", "RHS_HP_FFAR_ARMY"};
		pylonWeapon = "GOL_weapon_M230_ChainGun";
		mass = 200;
	};

	// AP ammo belt — baked into all GOL pylon-capable helicopter classes.
	// Provides AP ammo for in-flight cycling (ammo-cycle key) once the
	// M230 HE pod is loaded. Not visible in the Eden pylon screen.
	class GOL_PylonWeapon_M230_AP: 250Rnd_30mm_APDS_shells {
		scope = 2;
		author = "Guerrillas of Liberation";
		displayName = "M230 30mm Chain Gun Pod (AP)";
		displayNameShort = "M230 AP Belt";
		descriptionShort = "M230 30mm Chain Gun | AP 250 rounds";
		ammo = "GOL_ammo_M230_AP"; // custom APFSDS-class round; see CfgAmmo
		muzzleImpulseFactor[] = {0.2, 0.5};   // vanilla parent is {0.5,2} — reduced to limit nose kick at high ROF
		count = 300;
		model = "\A3\Weapons_F\DynamicLoadout\PylonPod_Twin_Cannon_20mm.p3d";
		muzzlePos = "muzzlePos";
		muzzleEnd = "muzzleEnd";
		hardpoints[] = {"DAR", "GOL_M230_CHAINGUN", "RHS_HP_FFAR_ARMY"};
		pylonWeapon = "GOL_weapon_M230_ChainGun";
		mass = 200;
	};
};