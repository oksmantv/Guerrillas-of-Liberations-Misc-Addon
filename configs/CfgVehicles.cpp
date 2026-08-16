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

    // Full-power air burst — used at >= 100m. ~60 large mixed fragments, full force.
    class OKS_ProxMine_AP : APERSMine {
        ammo = "OKS_ProxMine_AP_Ammo";
        indirectHit = 8;
        indirectHitRange = 6;
        explosionEffects = "";
        CraterEffects = "";
        ace_frag_charge = 40;
        ace_frag_force = 1;
        ace_frag_gurney_c = 1350;
        ace_frag_gurney_k = 0.166667;
        ace_frag_metal = 600;
        ace_frag_classes[] = {"ace_frag_large", "ace_frag_large_HD", "ace_frag_large"};
    };

    // Short-range air burst — used at < 100m to prevent ACE frag spike lag.
    // Fewer fragments, lower force, same no-smoke setup.
    class OKS_ProxMine_AP_Short : APERSMine {
        ammo = "OKS_ProxMine_AP_Ammo";
        indirectHit = 5;
        indirectHitRange = 4;
        explosionEffects = "";
        CraterEffects = "";
        ace_frag_charge = 15;
        ace_frag_force = 0.5;
        ace_frag_gurney_c = 1350;
        ace_frag_gurney_k = 0.166667;
        ace_frag_metal = 150;
        ace_frag_classes[] = {"ace_frag_large_HD", "ace_frag_large_HD", "ace_frag_large_HD"};
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
