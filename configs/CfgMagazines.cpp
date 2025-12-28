class CfgMagazines {
    class rhs_mag_9k38_rocket; // Reference the base class (no body)
    class gol_mag_9k38_rocket: rhs_mag_9k38_rocket {
        displayName = "9K38 (Disabled ACE Guidance)";
        ammo = "gol_ammo_9k38";
    };

    class magazine_Missile_s750_x4; // Reference the base class (no body)
    class gol_magazine_Missile_s750_x4: magazine_Missile_s750_x4 {
        displayName = "S750 (Disabled ACE Guidance)";
        ammo = "gol_ammo_s750_GOL";
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
        model = "\fpv_ua\drone_ied.p3d";
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
};