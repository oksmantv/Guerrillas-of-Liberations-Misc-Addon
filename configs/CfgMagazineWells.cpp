// CfgMagazineWells — Register AP45 magazines into standard magazine wells.
//
// This is the CBA-standard way to make magazines available to all weapons
// that participate in a given well. One entry here replaces dozens of
// per-weapon magazines[] += patches.
//
// Wells covered:
//   CBA_556x45_STANAG  — UK3CB Factions M16/ACR/Khaybar + any CBA mod
//   CBA_556x45_G36     — UK3CB Factions G36 family
//   CBA_556x45_STEYR   — UK3CB Factions AUG family
//   STANAG_556x45       — JCA rifles (M4A1, M16A4, HK433, M4A4)

class CfgMagazineWells {

    // CBA standard STANAG well — used by UK3CB Factions (ACR, M16, Khaybar)
    // and any mod that registers its 5.56 weapons with CBA.
    class CBA_556x45_STANAG {
        GOL_AP45_mags[] = {
            "GOL_30Rnd_556x45_AP45",
            "GOL_30Rnd_556x45_AP45_Tracer_Red",
            "GOL_30Rnd_556x45_AP45_Tracer_Green",
            "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
            "GOL_30Rnd_556x45_AP45_Reload_Tracer_Red",
            "GOL_30Rnd_556x45_AP45_Reload_Tracer_Green",
            "GOL_30Rnd_556x45_AP45_Reload_Tracer_Yellow",
            "GOL_30Rnd_556x45_AP45_Mixed_Red",
            "GOL_30Rnd_556x45_AP45_Mixed_Green",
            "GOL_30Rnd_556x45_AP45_Mixed_Yellow"
        };
    };

    // CBA G36-type well — used by UK3CB Factions G36 family
    // Uses G36-specific AP45 mags (correct model, mass, initspeed for G36 magazines)
    class CBA_556x45_G36 {
        GOL_AP45_mags[] = {
            "GOL_G36_30Rnd_556x45_AP45",
            "GOL_G36_30Rnd_556x45_AP45_Tracer_Red",
            "GOL_G36_30Rnd_556x45_AP45_Tracer_Green",
            "GOL_G36_30Rnd_556x45_AP45_Tracer_Yellow"
        };
    };

    // CBA Steyr/AUG well — used by UK3CB Factions AUG family
    class CBA_556x45_STEYR {
        GOL_AP45_mags[] = {
            "GOL_30Rnd_556x45_AP45",
            "GOL_30Rnd_556x45_AP45_Tracer_Red",
            "GOL_30Rnd_556x45_AP45_Tracer_Green",
            "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
            "GOL_30Rnd_556x45_AP45_Reload_Tracer_Red",
            "GOL_30Rnd_556x45_AP45_Reload_Tracer_Green",
            "GOL_30Rnd_556x45_AP45_Reload_Tracer_Yellow",
            "GOL_30Rnd_556x45_AP45_Mixed_Red",
            "GOL_30Rnd_556x45_AP45_Mixed_Green",
            "GOL_30Rnd_556x45_AP45_Mixed_Yellow"
        };
    };

    // JCA custom STANAG well — used by JCA rifles (M4A1, M16A4, HK433, M4A4)
    // All JCA variants (black, sand, olive) inherit from bases that use this well,
    // so all color variants get our mags automatically — including sand!
    class STANAG_556x45 {
        GOL_AP45_mags[] = {
            "GOL_30Rnd_556x45_AP45",
            "GOL_30Rnd_556x45_AP45_Tracer_Red",
            "GOL_30Rnd_556x45_AP45_Tracer_Green",
            "GOL_30Rnd_556x45_AP45_Tracer_Yellow",
            "GOL_30Rnd_556x45_AP45_Reload_Tracer_Red",
            "GOL_30Rnd_556x45_AP45_Reload_Tracer_Green",
            "GOL_30Rnd_556x45_AP45_Reload_Tracer_Yellow",
            "GOL_30Rnd_556x45_AP45_Mixed_Red",
            "GOL_30Rnd_556x45_AP45_Mixed_Green",
            "GOL_30Rnd_556x45_AP45_Mixed_Yellow"
        };
    };

    // CBA 7.62x39 RPK-type well — registered by 3CB RPK variants.
    // GOL 75Rnd drum mags go here. RPD has empty well and uses magazines[] += directly.
    class CBA_762x39_RPK {
        GOL_762x39_mags[] = {
            "GOL_75Rnd_762x39",
            "GOL_75Rnd_762x39_Tracer_Red",
            "GOL_75Rnd_762x39_Tracer_Green",
            "GOL_75Rnd_762x39_Tracer_Yellow"
        };
    };

    // CBA 5.45x39 RPK-type well — registered by RHS rhs_weap_rpk_base (RPK-74M family).
    // All RHS RPK-74 variants automatically receive GOL 7N22 AP mags via this well.
    class CBA_545x39_RPK {
        GOL_545x39_mags[] = {
            "GOL_45Rnd_545x39_7N22",
            "GOL_45Rnd_545x39_7N22_Tracer_Red",
            "GOL_45Rnd_545x39_7N22_Tracer_Green",
            "GOL_45Rnd_545x39_7N22_Tracer_Yellow"
        };
    };

    // Vanilla A3 MX large-capacity well — used by arifle_MX_SW_F and all color variants.
    // GOL 100Rnd caseless belts become available to all MX SW weapons (vanilla + GOL).
    class MX_65x39_Large {
        GOL_65x39_caseless_mags[] = {
            "GOL_100Rnd_65x39_caseless",
            "GOL_100Rnd_65x39_caseless_Tracer_Red",
            "GOL_100Rnd_65x39_caseless_Tracer_Green",
            "GOL_100Rnd_65x39_caseless_Tracer_Yellow"
        };
    };
};
