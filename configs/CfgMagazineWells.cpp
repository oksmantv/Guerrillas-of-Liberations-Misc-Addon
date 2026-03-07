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
};
