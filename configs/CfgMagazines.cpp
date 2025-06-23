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
};