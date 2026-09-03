// --- Forward declarations for VehicleSystemsDisplay panel templates ---
class DefaultVehicleSystemsDisplayManagerLeft
{
class components;
};
class DefaultVehicleSystemsDisplayManagerRight
{
class components;
};
class VehicleSystemsTemplateLeftDriver: DefaultVehicleSystemsDisplayManagerLeft
{
class components;
};
class VehicleSystemsTemplateRightDriver: DefaultVehicleSystemsDisplayManagerRight
{
class components;
};
class VehicleSystemsTemplateLeftGunner: DefaultVehicleSystemsDisplayManagerLeft
{
class components;
};
class VehicleSystemsTemplateRightGunner: DefaultVehicleSystemsDisplayManagerRight
{
class components;
};
class VehicleSystemsTemplateLeftCommander: DefaultVehicleSystemsDisplayManagerLeft
{
class components;
};
class VehicleSystemsTemplateRightCommander: DefaultVehicleSystemsDisplayManagerRight
{
class components;
};

// --- Forward declarations for Sensor templates ---
class SensorTemplatePassiveRadar;
class SensorTemplateActiveRadar;
class SensorTemplateIR;
class SensorTemplateVisual;
class SensorTemplateLaser;
class SensorTemplateNV;
class SensorTemplateDataLink;

class CfgVehicles {
    class Land;
    class LandVehicle: Land {
        class ACE_Actions {
            class ACE_MainActions {};
        };
    };

    // Custom air burst APERS charge — reduced power and no smoke cloud.
    // Used by OKS_fnc_ProxRound_TrackRound as the proximity fuse shrapnel source.
    // Half the indirectHit/indirectHitRange of vanilla APERSMine; explosionEffects
    // blanked so the heavy smoke cloud is suppressed (visual comes from OKS_ProxFuze_Airburst).
    class APERSMine;

    // Full-power air burst — range >= 100m, AGL <= 10m.
    class OKS_ProxMine_40mm_AP : APERSMine {
        ammo = "OKS_ProxMine_40mm_AP_Ammo";
        indirectHit = 7;
        indirectHitRange = 4;
        explosionEffects = "";
        CraterEffects = "";
        ace_frag_charge = 6;
        ace_frag_force = 1.5;
        ace_frag_gurney_c = 280;
        ace_frag_gurney_k = 0.166667;
        ace_frag_metal = 30;   // ~5-8 fragments
        ace_frag_classes[] = {"ace_frag_large", "ace_frag_large", "ace_frag_large"};
    };

    // Medium-altitude air burst — range >= 100m, AGL 10-15m. ~50% shrapnel.
    class OKS_ProxMine_40mm_AP_Med : APERSMine {
        ammo = "OKS_ProxMine_40mm_AP_Ammo";
        indirectHit = 5;
        indirectHitRange = 3;
        explosionEffects = "";
        CraterEffects = "";
        ace_frag_charge = 4;
        ace_frag_force = 1.2;
        ace_frag_gurney_c = 280;
        ace_frag_gurney_k = 0.166667;
        ace_frag_metal = 18;   // ~3-4 fragments
        ace_frag_classes[] = {"ace_frag_large", "ace_frag_large", "ace_frag_large"};
    };

    // High-altitude air burst — range >= 100m, AGL 15-25m. ~25% shrapnel.
    class OKS_ProxMine_40mm_AP_High : APERSMine {
        ammo = "OKS_ProxMine_40mm_AP_Ammo";
        indirectHit = 3;
        indirectHitRange = 2;
        explosionEffects = "";
        CraterEffects = "";
        ace_frag_charge = 2;
        ace_frag_force = 0.9;
        ace_frag_gurney_c = 280;
        ace_frag_gurney_k = 0.166667;
        ace_frag_metal = 8;    // ~1-2 fragments
        ace_frag_classes[] = {"ace_frag_large", "ace_frag_large", "ace_frag_large"};
    };

    // Short-range air burst — range < 100m, AGL <= 10m. Reduced to prevent ACE frag lag spike.
    class OKS_ProxMine_40mm_AP_Short : APERSMine {
        ammo = "OKS_ProxMine_40mm_AP_Ammo";
        indirectHit = 4;
        indirectHitRange = 3;
        explosionEffects = "";
        CraterEffects = "";
        ace_frag_charge = 4;
        ace_frag_force = 1.2;
        ace_frag_gurney_c = 280;
        ace_frag_gurney_k = 0.166667;
        ace_frag_metal = 15;   // ~2-4 fragments
        ace_frag_classes[] = {"ace_frag_large", "ace_frag_large", "ace_frag_large"};
    };

    // FX variants — used by the no-canister path (round deleted, no native HE explosion).
    // Inherit all frag/damage from the silent versions; re-enable explosion and crater effects.
    // ExploAmmoExplosion = cannon-round detonation effect; graphical mods enhance this class
    // the same way they enhance real HE rounds, giving mod-consistent visuals.
    class OKS_ProxMine_40mm_AP_FX : OKS_ProxMine_40mm_AP {
        ammo = "OKS_ProxMine_40mm_AP_Ammo_FX";
        explosionEffects = "ExploAmmoExplosion";
        CraterEffects = "";  // air burst — no ground crater
    };
    class OKS_ProxMine_40mm_AP_Med_FX : OKS_ProxMine_40mm_AP_Med {
        ammo = "OKS_ProxMine_40mm_AP_Ammo_FX";
        explosionEffects = "ExploAmmoExplosion";
        CraterEffects = "";  // air burst — no ground crater
    };
    class OKS_ProxMine_40mm_AP_High_FX : OKS_ProxMine_40mm_AP_High {
        ammo = "OKS_ProxMine_40mm_AP_Ammo_FX";
        explosionEffects = "ExploAmmoExplosion";
        CraterEffects = "";  // air burst — no ground crater
    };
    class OKS_ProxMine_40mm_AP_Short_FX : OKS_ProxMine_40mm_AP_Short {
        ammo = "OKS_ProxMine_40mm_AP_Ammo_FX";
        explosionEffects = "ExploAmmoExplosion";
        CraterEffects = "";  // air burst — no ground crater
    };

// Static weapons — ACE packing actions
#include "vehicles\static_weapons.hpp"

// Infantry — Man/CAManBase ACE actions
#include "vehicles\infantry.hpp"

// Logistics — resupply stations, helipad, flags, gear boxes
#include "vehicles\logistics.hpp"

// SAM system overrides
#include "vehicles\sam_systems.hpp"

// GOL Eden modules
#include "vehicles\modules.hpp"

// Light vehicles — FastRope, Plane actions, Fennek variants
#include "vehicles\light_vehicles.hpp"

// Tracked vehicles — BMP-2DM
#include "vehicles\bmp2dm.hpp"

// Fixed wing aircraft
#include "vehicles\fixed_wing.hpp"

// Helicopter Targeting Pod variants (UH-80, AH-9, PO-30, WY-55)
#include "compat\gol_helicopters.hpp"

// TFAR Intercom patch (enables intercom on MRAPs)
#include "compat\compat_tfar_intercom.hpp"

// BettIR light object patches (stronger NVG/weapon illuminators)
#include "compat\compat_bettir_vehicles.hpp"

};
