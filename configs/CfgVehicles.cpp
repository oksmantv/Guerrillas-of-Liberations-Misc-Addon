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
