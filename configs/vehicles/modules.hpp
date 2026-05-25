	class Module_F;
    class OKS_Module_MechanizedSetup : Module_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "Mechanized Setup";
        category = "GOL_Modules";
        function = "OKS_fnc_SetupMechanized"; // Your function
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 1;
    };
    class OKS_Module_HelicopterSetup : Module_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "Helicopter Setup";
        category = "GOL_Modules";
        function = "OKS_fnc_SetupHelicopter"; // Your function
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 1;
    };
    class OKS_Module_MHQ : Module_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "MHQ Setup";
        category = "GOL_Modules";
        function = "OKS_fnc_SetupMHQ"; // Your function
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 1;
    };	
    class OKS_Module_ApplyUnitGear : Module_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "OKS Apply Unit Gear";
        category = "GOL_Modules";
        function = "OKS_fnc_ApplyUnitGear"; // Your function
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 1;
    };

    class OKS_Module_Mortars : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Mortar Fire Support";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleMortars";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Mortar fire support module. Sync to a trigger to delay activation. Sync to an OKS_Module_MortarTarget for designated target position. Sync a placed mortar/artillery vehicle to use it directly at runtime — its position is used as the firing position. If no vehicle is synced, one is spawned from the 'Vehicle Class' classname at the module position. NOTE: There is a ~10 second warmup after activation for manned mortars (AI gunner mounting).";
        };
        class Arguments {
            class Platform {
                displayName = "Platform";
                description = "Manned: uses a synced vehicle or spawns from 'Vehicle Class' with an AI gunner. OffMap: virtual strike, no physical mortar.";
                typeName = "STRING";
                defaultValue = "manned";
                class values {
                    class Manned  { name = "Manned";  value = "manned"; };
                    class OffMap   { name = "Off-Map"; value = "offmap"; };
                };
            };
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "Fallback classname used when no vehicle is synced (Manned only). If a vehicle is synced to this module, it is used directly and this field is ignored. Examples: O_Mortar_01_F, B_Mortar_01_F, rhs_2b14_82mm_msv, RHS_M252_USMC_WD";
                typeName = "STRING";
                defaultValue = "O_Mortar_01_F";
            };
            class Side {
                displayName = "Side";
                description = "Side the mortar crew belongs to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class FiringMode {
                displayName = "Firing Mode";
                description = "Sporadic: random inaccurate. Precise: slow accurate. Barrage: fast salvo. Guided: walks onto target. Screen: line pattern. Random: picks one each cycle.";
                typeName = "STRING";
                defaultValue = "precise";
                class values {
                    class Precise  { name = "Precise";  value = "precise"; };
                    class Barrage  { name = "Barrage";  value = "barrage"; };
                    class Sporadic { name = "Sporadic"; value = "sporadic"; };
                    class Guided   { name = "Guided";   value = "guided"; };
                    class Screen   { name = "Screen";   value = "screen"; };
                    class Random   { name = "Random";   value = "random"; };
                };
            };
            class RoundType {
                displayName = "Round Type";
                description = "Ammunition type defined in Mortar_Settings.";
                typeName = "STRING";
                defaultValue = "light";
                class values {
                    class Light  { name = "Light";  value = "light"; };
                    class Medium { name = "Medium"; value = "medium"; };
                    class Heavy  { name = "Heavy";  value = "heavy"; };
                    class Smoke  { name = "Smoke";  value = "smoke"; };
                    class Flare  { name = "Flare";  value = "flare"; };
                };
            };
            class Targeting {
                displayName = "Targeting";
                description = "Auto: mortar picks its own targets. Designated: sync an OKS_Module_MortarTarget to set the target position. Falls back to module position if no target synced.";
                typeName = "STRING";
                defaultValue = "designated";
                class values {
                    class Designated { name = "Designated"; value = "designated"; };
                    class Auto       { name = "Auto";       value = "auto"; };
                };
            };
            class Inaccuracy {
                displayName = "Inaccuracy";
                description = "Round scatter in meters.";
                typeName = "NUMBER";
                defaultValue = 50;
            };
            class MinRange {
                displayName = "Min Range";
                description = "Minimum engagement range (Auto targeting only).";
                typeName = "NUMBER";
                defaultValue = 150;
            };
            class MaxRange {
                displayName = "Max Range";
                description = "Maximum engagement range (Auto targeting only).";
                typeName = "NUMBER";
                defaultValue = 400;
            };
            class Ammo {
                displayName = "Ammo";
                description = "Total rounds available.";
                typeName = "NUMBER";
                defaultValue = 20;
            };
            class RoundInterval {
                displayName = "Round Interval";
                description = "Seconds between rounds. -1 uses mode default.";
                typeName = "NUMBER";
                defaultValue = -1;
            };
            class RoundCount {
                displayName = "Round Count";
                description = "Forced rounds per burst. -1 uses mode default.";
                typeName = "NUMBER";
                defaultValue = -1;
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before firing. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    class OKS_Module_MortarTarget : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Mortar Target";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "";
        functionPriority = 0;
        isGlobal = 0;
        isTriggerActivated = 0;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Designates a target position for Mortar Fire Support. Synchronize this module to an OKS_Module_Mortars to set where rounds land. Drag to move the impact point.";
        };
    };

    // ==================== Radar ====================
    class OKS_Module_Radar : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Radar Share";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleRadar";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Radar share module. Sync a crewed radar vehicle to use it — the vehicle MUST have crew (the script does not create crew). If no vehicle is synced, one is spawned from 'Vehicle Class' at the module position (unmanned — add crew in Eden or it will not function). Nearby AAA vehicles matching the classnames list will receive target data from the radar.";
        };
        class Arguments {
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "Radar classname used when no vehicle is synced. Synced vehicles take priority. The radar MUST have crew to function. Examples: O_Radar_System_02_F, B_Radar_System_01_F";
                typeName = "STRING";
                defaultValue = "O_Radar_System_02_F";
            };
            class AAAClassnames {
                displayName = "AAA Classnames";
                description = "Comma-separated vehicle classnames of AAA assets the radar will assist. The radar shares target data with nearby vehicles of these types.";
                typeName = "STRING";
                defaultValue = "rhsgref_ins_zsu234";
            };
            class ShareDistance {
                displayName = "Share Distance";
                description = "Range in meters within which AAA assets receive radar data.";
                typeName = "NUMBER";
                defaultValue = 2000;
            };
            class MaxRangeAAA {
                displayName = "Max Range AAA";
                description = "Maximum engagement range for AAA assets.";
                typeName = "NUMBER";
                defaultValue = 2500;
            };
            class MinimumAltitude {
                displayName = "Minimum Altitude";
                description = "Minimum altitude (meters) a target must be at to be considered.";
                typeName = "NUMBER";
                defaultValue = 100;
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before starting. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    // ==================== ArtyFire ====================
    class OKS_Module_ArtyFire : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Artillery Fire (Ambience)";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleArtyFire";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Ambient artillery fire module. Sync an artillery vehicle to use it directly, or one is spawned from 'Vehicle Class'. Sync an OKS_Module_ArtyTarget to set the impact position. The artillery will fire cyclically: 'Rounds' per salvo, 'Reload Time' between rounds, 'Rearm Time' between salvos.";
        };
        class Arguments {
            class Side {
                displayName = "Side";
                description = "Side the artillery crew belongs to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "Artillery classname used when no vehicle is synced. Synced vehicles take priority. Examples: rhs_2s1_tv, RHS_M119_WD";
                typeName = "STRING";
                defaultValue = "rhs_2s1_tv";
            };
            class Rounds {
                displayName = "Rounds";
                description = "Number of rounds fired per salvo.";
                typeName = "NUMBER";
                defaultValue = 7;
            };
            class RearmTime {
                displayName = "Rearm Time";
                description = "Seconds between salvos (cooldown).";
                typeName = "NUMBER";
                defaultValue = 300;
            };
            class ReloadTime {
                displayName = "Reload Time";
                description = "Seconds between individual rounds within a salvo.";
                typeName = "NUMBER";
                defaultValue = 30;
            };
            class FullCrew {
                displayName = "Full Crew";
                description = "Spawn commander crew in addition to gunner (if artillery has commander seat with weapon).";
                typeName = "STRING";
                defaultValue = "no";
                class values {
                    class No  { name = "No";  value = "no"; };
                    class Yes { name = "Yes"; value = "yes"; };
                };
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before firing. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    class OKS_Module_ArtyTarget : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Artillery Target";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "";
        functionPriority = 0;
        isGlobal = 0;
        isTriggerActivated = 0;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Designates a target position. Sync to an OKS_Module_ArtyFire or OKS_Module_ArtySuppression. For Suppression, sync multiple of these to define the firing sequence. Drag to move the impact point.";
        };
    };

    // ==================== Artillery Suppression ====================
    class OKS_Module_ArtySuppression : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Artillery Suppression";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleArtySuppression";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Artillery suppression module. Sync an artillery vehicle to use it directly, or one is spawned from 'Vehicle Class'. Sync multiple OKS_Module_ArtyTarget modules to define target positions — the artillery fires at each in sequence. Crew is auto-created if the vehicle has none.";
        };
        class Arguments {
            class Side {
                displayName = "Side";
                description = "Side the artillery crew belongs to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "Artillery classname used when no vehicle is synced. Synced vehicles take priority. Examples: rhs_2s1_tv, RHS_M119_WD";
                typeName = "STRING";
                defaultValue = "rhs_2s1_tv";
            };
            class RoundsPerTarget {
                displayName = "Rounds Per Target";
                description = "Number of rounds fired at each target position.";
                typeName = "NUMBER";
                defaultValue = 3;
            };
            class TimeBetweenRounds {
                displayName = "Time Between Rounds";
                description = "Seconds between individual rounds.";
                typeName = "NUMBER";
                defaultValue = 5;
            };
            class UnlimitedAmmo {
                displayName = "Unlimited Ammo";
                description = "Refill ammo after each salvo.";
                typeName = "STRING";
                defaultValue = "yes";
                class values {
                    class Yes { name = "Yes"; value = "yes"; };
                    class No  { name = "No";  value = "no"; };
                };
            };
            class ShouldLoop {
                displayName = "Loop";
                description = "Continuously loop through all targets until the artillery is destroyed.";
                typeName = "STRING";
                defaultValue = "yes";
                class values {
                    class Yes { name = "Yes"; value = "yes"; };
                    class No  { name = "No";  value = "no"; };
                };
            };
            class LoopDelay {
                displayName = "Loop Delay";
                description = "Seconds to wait between loops (only when Loop is enabled).";
                typeName = "NUMBER";
                defaultValue = 120;
            };
            class ShouldMark {
                displayName = "Mark Targets";
                description = "Drop red smoke (day) or flare (night) on target before firing.";
                typeName = "STRING";
                defaultValue = "yes";
                class values {
                    class Yes { name = "Yes"; value = "yes"; };
                    class No  { name = "No";  value = "no"; };
                };
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before firing. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    // ==================== LAMBS SpawnGroup ====================
    class OKS_Module_LambsSpawnGroup : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "LAMBS Spawn Group";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleLambsSpawnGroup";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Spawns a LAMBS AI group at the module position. Infantry mode: spawns a foot patrol. Vehicle mode: sync pre-placed vehicles to use their classnames (vehicles are deleted at runtime, fresh ones spawned by the script). If no vehicles are synced, uses the 'Vehicle Class' fallback.";
        };
        class Arguments {
            class Mode {
                displayName = "Mode";
                description = "Infantry: spawns foot soldiers. Vehicle: spawns a vehicle with cargo (sync vehicles for classnames or use fallback).";
                typeName = "STRING";
                defaultValue = "infantry";
                class values {
                    class Infantry { name = "Infantry"; value = "infantry"; };
                    class Vehicle  { name = "Vehicle";  value = "vehicle"; };
                };
            };
            class LambsType {
                displayName = "LAMBS Type";
                description = "AI behaviour type from LAMBS danger.";
                typeName = "STRING";
                defaultValue = "rush";
                class values {
                    class Rush        { name = "Rush";         value = "rush"; };
                    class Hunt        { name = "Hunt";         value = "hunt"; };
                    class Creep       { name = "Creep";        value = "creep"; };
                    class Attack      { name = "Attack";       value = "attack"; };
                    class AmbushAttack { name = "Ambush Attack"; value = "ambushattack"; };
                    class AmbushRush  { name = "Ambush Rush";  value = "ambushrush"; };
                    class AmbushHunt  { name = "Ambush Hunt";  value = "ambushhunt"; };
                    class AmbushCQB   { name = "Ambush CQB";   value = "ambushcqb"; };
                };
            };
            class Side {
                displayName = "Side";
                description = "Side the spawned units belong to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class UnitCount {
                displayName = "Unit Count";
                description = "Number of infantry to spawn (Infantry mode only).";
                typeName = "NUMBER";
                defaultValue = 6;
            };
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "Vehicle classname used when no vehicle is synced (Vehicle mode only). Sync placed vehicles for their classnames instead. Examples: O_MRAP_02_hmg_F, O_APC_Wheeled_02_rcws_v2_F";
                typeName = "STRING";
                defaultValue = "O_MRAP_02_hmg_F";
            };
            class CargoCount {
                displayName = "Cargo Count";
                description = "Number of infantry in vehicle cargo (Vehicle mode only).";
                typeName = "NUMBER";
                defaultValue = 2;
            };
            class Range {
                displayName = "Range";
                description = "Tracking range for LAMBS AI and ambush trigger radius.";
                typeName = "NUMBER";
                defaultValue = 1500;
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before spawning. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    // ==================== Convoy ====================
    class OKS_Module_Convoy : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Convoy Spawn";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleConvoy";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Spawns a convoy at the module position. Sync to OKS_Module_ConvoyWaypoint modules to define the route: Main → WP1 → WP2 → ... → End. Each waypoint syncs to the next. The last waypoint must have Type=End. Sync pre-placed vehicles to use their classnames (vehicles are deleted at runtime). If no vehicles are synced, uses the 'Vehicle Classnames' field.";
        };
        class Arguments {
            class Side {
                displayName = "Side";
                description = "Side the convoy units belong to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class VehicleCount {
                displayName = "Vehicle Count";
                description = "Number of vehicles in the convoy (when using classnames field, not synced vehicles).";
                typeName = "NUMBER";
                defaultValue = 4;
            };
            class VehicleClassnames {
                displayName = "Vehicle Classnames";
                description = "Comma-separated vehicle classnames. Synced vehicles override this field. Examples: O_MRAP_02_F, O_Truck_03_covered_F";
                typeName = "STRING";
                defaultValue = "O_MRAP_02_F";
            };
            class SpeedKph {
                displayName = "Speed (km/h)";
                description = "Convoy travel speed in km/h.";
                typeName = "NUMBER";
                defaultValue = 35;
            };
            class Dispersion {
                displayName = "Dispersion";
                description = "Spacing in meters between convoy vehicles while driving.";
                typeName = "NUMBER";
                defaultValue = 50;
            };
            class ParkingDispersion {
                displayName = "Parking Dispersion";
                description = "Spacing in meters between parked vehicles at the end waypoint.";
                typeName = "NUMBER";
                defaultValue = 30;
            };
            class SpawnCargo {
                displayName = "Spawn Cargo";
                description = "Spawn infantry in vehicle cargo.";
                typeName = "STRING";
                defaultValue = "yes";
                class values {
                    class Yes { name = "Yes"; value = "yes"; };
                    class No  { name = "No";  value = "no"; };
                };
            };
            class CargoCount {
                displayName = "Cargo Count";
                description = "Maximum infantry per vehicle cargo.";
                typeName = "NUMBER";
                defaultValue = 6;
            };
            class ForcedCareless {
                displayName = "Forced Careless";
                description = "Force the convoy to careless behaviour (no reaction to threats).";
                typeName = "STRING";
                defaultValue = "no";
                class values {
                    class No  { name = "No";  value = "no"; };
                    class Yes { name = "Yes"; value = "yes"; };
                };
            };
            class DeleteAtFinalWP {
                displayName = "Delete at Final WP";
                description = "Delete convoy vehicles and crew when they reach the end waypoint.";
                typeName = "STRING";
                defaultValue = "no";
                class values {
                    class No  { name = "No";  value = "no"; };
                    class Yes { name = "Yes"; value = "yes"; };
                };
            };
            class DismountBehaviour {
                displayName = "Dismount Behaviour";
                description = "AI behaviour after dismounting at the end waypoint.";
                typeName = "STRING";
                defaultValue = "rush";
                class values {
                    class Rush    { name = "Rush";    value = "rush"; };
                    class Defend  { name = "Defend";  value = "defend"; };
                    class Patrol  { name = "Patrol";  value = "patrol"; };
                    class Assault { name = "Assault"; value = "assault"; };
                    class Hunt    { name = "Hunt";    value = "hunt"; };
                };
            };
            class ParkingMode {
                displayName = "Parking Mode";
                description = "How vehicles park at the end waypoint. Alternate: herringbone left/right. Successive: fill both sides. ConvoyStop: stop in-line on road. Offroad: single-file off-road.";
                typeName = "STRING";
                defaultValue = "alternate";
                class values {
                    class Alternate  { name = "Alternate (Herringbone)"; value = "alternate"; };
                    class Successive { name = "Successive";             value = "successive"; };
                    class ConvoyStop { name = "Convoy Stop";            value = "convoystop"; };
                    class Offroad    { name = "Offroad";                value = "offroad"; };
                };
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before spawning. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    class OKS_Module_ConvoyWaypoint : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Convoy Waypoint";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "";
        functionPriority = 0;
        isGlobal = 0;
        isTriggerActivated = 0;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Defines a waypoint or end position for a Convoy. Sync from the main OKS_Module_Convoy (or previous waypoint) to this module, then from this module to the next. The last module in the chain must have Type set to End.";
        };
        class Arguments {
            class WaypointType {
                displayName = "Type";
                description = "Waypoint: intermediate travel point (can have multiple). End: final destination where vehicles park and troops dismount (exactly one).";
                typeName = "STRING";
                defaultValue = "waypoint";
                class values {
                    class Waypoint { name = "Waypoint"; value = "waypoint"; };
                    class End      { name = "End";      value = "end"; };
                };
            };
        };
    };

    // ==================== Ambient AAA ====================
    class OKS_Module_AmbientAAA : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Ambient AAA";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleAmbientAAA";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Ambient anti-aircraft fire. Sync a static weapon or vehicle to use as the AAA platform. If no vehicle is synced, one is spawned from 'Vehicle Class'. Crew is auto-created if the vehicle has no gunner.";
        };
        class Arguments {
            class Side {
                displayName = "Side";
                description = "Side the AAA crew belongs to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "AAA vehicle classname used when no vehicle is synced. Synced vehicles take priority. Examples: RHS_Ural_Zu23_MSV_01, rhsgref_ins_zsu234";
                typeName = "STRING";
                defaultValue = "RHS_Ural_Zu23_MSV_01";
            };
            class IsHMG {
                displayName = "Is HMG";
                description = "Set to Yes if the AAA platform is an HMG (heavy machine gun). Affects lead calculation for moving targets — HMG rounds are slower and need more lead.";
                typeName = "STRING";
                defaultValue = "no";
                class values {
                    class No  { name = "No";  value = "no"; };
                    class Yes { name = "Yes"; value = "yes"; };
                };
            };
            class Range {
                displayName = "Range";
                description = "Maximum engagement range in meters. Targets beyond this distance are ignored.";
                typeName = "NUMBER";
                defaultValue = 1500;
            };
            class Radar {
                displayName = "Radar";
                description = "Enable radar-assisted targeting. When on, nearby radar vehicles share target information with this AAA platform, improving detection.";
                typeName = "STRING";
                defaultValue = "yes";
                class values {
                    class Yes { name = "Yes"; value = "yes"; };
                    class No  { name = "No";  value = "no"; };
                };
            };
            class RateOfFire {
                displayName = "Rate of Fire (burst sizes)";
                description = "Comma-separated list of burst sizes. Each burst randomly picks one value from this list. Example: '3,4,5,6' means each burst fires 3 to 6 rounds at random.";
                typeName = "STRING";
                defaultValue = "3,4,5,6";
            };
            class TimeBetweenShots {
                displayName = "Time Between Shots";
                description = "Override seconds between individual shots in a burst. Set to 0 to use the weapon's natural reload time.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before the AAA starts operating.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    // ==================== Hunt Base ====================
    class OKS_Module_HuntBase : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Hunt Base";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleHuntBase";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 1;
        canSetAreaShape = 1;
        class AttributeValues {
            size3[] = {3000, 3000, -1};
            isRectangle = 0;
        };
        class ModuleDescription {
            description = "Reactive hunt base. When enemy players are detected in the module's zone, the base spawns infantry or vehicles to hunt them. Requires two synced objects: a destructible base object (building/vehicle — destroying it stops spawns) and an OKS_Module_SpawnPoint (defines where units spawn and which direction they face). The module's adjustable area defines the trigger zone. If 'Vehicle Classnames' is set, vehicles are spawned instead of infantry.";
        };
        class Arguments {
            class Side {
                displayName = "Side";
                description = "Side the spawned units belong to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class Soldiers {
                displayName = "Infantry Count";
                description = "Number of infantry per wave (used when Vehicle Classnames is empty).";
                typeName = "NUMBER";
                defaultValue = 6;
            };
            class VehicleClassnames {
                displayName = "Vehicle Classnames";
                description = "Comma-separated vehicle classnames. If set, vehicles are spawned instead of infantry. One is randomly selected per wave. Leave blank for infantry. Examples: CUP_O_BTR40_MG_TKM, CUP_O_Ural_ZU23_TKM";
                typeName = "STRING";
                defaultValue = "";
            };
            class Waves {
                displayName = "Waves";
                description = "Total number of spawn waves before the base runs out.";
                typeName = "NUMBER";
                defaultValue = 5;
            };
            class RespawnDelay {
                displayName = "Respawn Delay";
                description = "Seconds between waves.";
                typeName = "NUMBER";
                defaultValue = 900;
            };
            class RefreshRate {
                displayName = "Refresh Rate";
                description = "Seconds between player-detection checks in the hunt zone. Lower = faster response but slightly higher performance cost.";
                typeName = "NUMBER";
                defaultValue = 120;
            };
            class DeployFlare {
                displayName = "Deploy Flare (Night)";
                description = "Launch a red flare above the base when spawning at night.";
                typeName = "STRING";
                defaultValue = "yes";
                class values {
                    class Yes { name = "Yes"; value = "yes"; };
                    class No  { name = "No";  value = "no"; };
                };
            };
            class WaypointBehaviour {
                displayName = "Waypoint Behaviour";
                description = "AI behaviour for spawned groups. Auto = AWARE for infantry, SAFE for vehicles.";
                typeName = "STRING";
                defaultValue = "";
                class values {
                    class Auto    { name = "Auto";    value = ""; };
                    class Safe    { name = "SAFE";    value = "SAFE"; };
                    class Aware   { name = "AWARE";   value = "AWARE"; };
                    class Combat  { name = "COMBAT";  value = "COMBAT"; };
                    class Stealth { name = "STEALTH"; value = "STEALTH"; };
                };
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before the base starts listening for players.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    // ==================== Air Base ====================
    class OKS_Module_AirBase : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Air Base";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleAirBase";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 1;
        canSetAreaShape = 1;
        class AttributeValues {
            size3[] = {5000, 5000, -1};
            isRectangle = 0;
        };
        class ModuleDescription {
            description = "Helicopter reinforcement base. When enemy players are detected in the module's zone, a helicopter is dispatched to insert troops near the players. Requires two synced objects: a destructible base object (destroying it stops spawns) and an OKS_Module_SpawnPoint (helicopter spawn position). The module's adjustable area defines the reinforcement zone. Supports multiple comma-separated helicopter classnames for random selection.";
        };
        class Arguments {
            class Side {
                displayName = "Side";
                description = "Side the helicopter and inserted troops belong to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class HelicopterClass {
                displayName = "Helicopter Class";
                description = "Helicopter classname(s). Comma-separated for random selection per wave. Examples: O_Heli_Light_02_unarmed_F, RHS_Mi8mt_vvsc";
                typeName = "STRING";
                defaultValue = "O_Heli_Light_02_unarmed_F";
            };
            class InsertType {
                displayName = "Insert Type";
                description = "How troops are delivered. Unload: helicopter lands. Fastrope: troops fast-rope down. Paradrop: troops parachute. UnloadThenPatrol / ParadropThenPatrol: same but helicopter stays to patrol. Random: picks randomly per wave.";
                typeName = "STRING";
                defaultValue = "unload";
                class values {
                    class Unload            { name = "Unload";              value = "unload"; };
                    class Fastrope          { name = "Fastrope";            value = "fastrope"; };
                    class Paradrop          { name = "Paradrop";            value = "paradrop"; };
                    class UnloadThenPatrol  { name = "Unload then Patrol";  value = "unloadthenpatrol"; };
                    class ParadropThenPatrol { name = "Paradrop then Patrol"; value = "paradropthenpatrol"; };
                    class Random            { name = "Random";              value = "random"; };
                };
            };
            class NumGroups {
                displayName = "Number of Groups";
                description = "Split inserted troops into this many groups/teams.";
                typeName = "NUMBER";
                defaultValue = 2;
            };
            class CargoPercent {
                displayName = "Cargo Fill (%)";
                description = "Percentage of the helicopter's cargo seats to fill with troops (0-100). 100 = all seats, 50 = half.";
                typeName = "NUMBER";
                defaultValue = 100;
            };
            class RespawnTimer {
                displayName = "Respawn Timer";
                description = "Cooldown in seconds between helicopter waves.";
                typeName = "NUMBER";
                defaultValue = 900;
            };
            class RandomDistanceLZ {
                displayName = "LZ Distance";
                description = "How far (in meters) from the target player the landing zone / drop zone is placed.";
                typeName = "NUMBER";
                defaultValue = 200;
            };
            class RefreshRate {
                displayName = "Refresh Rate";
                description = "Seconds between player-detection checks in the reinforcement zone.";
                typeName = "NUMBER";
                defaultValue = 90;
            };
            class RespawnCount {
                displayName = "Wave Count";
                description = "Total number of helicopter waves before the base runs out.";
                typeName = "NUMBER";
                defaultValue = 5;
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before the air base starts listening for players.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    // ==================== SpawnPoint (companion) ====================
    class OKS_Module_SpawnPoint : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Spawn Point";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "";
        functionPriority = 0;
        isGlobal = 0;
        isTriggerActivated = 0;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Defines a spawn position and direction for a parent module. Sync to an OKS_Module_HuntBase or OKS_Module_AirBase. Units/vehicles spawn at this module's position facing its direction. Rotate the module in Eden to set the spawn facing.";
        };
        class Arguments {};
    };

    // ==================== SAM (Networked) ====================
    class OKS_Module_SAM : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "SAM Launcher (Networked)";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleSAM";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Networked SAM launcher. Sync a SAM vehicle and a radar to use them directly. If no SAM is synced, one is spawned from 'Vehicle Class'. A radar must be synced or placed within 200m. The global network limits in-flight missiles per target across all SAM launchers.";
        };
        class Arguments {
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "SAM launcher classname used when no vehicle is synced. Synced vehicles take priority. Examples: GOL_O_SAM_System_04_F, GOL_B_SAM_System_03_F";
                typeName = "STRING";
                defaultValue = "GOL_O_SAM_System_04_F";
            };
            class RateOfFire {
                displayName = "Rate of Fire";
                description = "Base delay (seconds) between shots. Actual delay is randomised up to 2x this value.";
                typeName = "NUMBER";
                defaultValue = 20;
            };
            class Ammo {
                displayName = "Ammo (Magazine Size)";
                description = "Number of missiles per magazine before a full reload cycle.";
                typeName = "NUMBER";
                defaultValue = 4;
            };
            class ReloadRate {
                displayName = "Reload Rate";
                description = "Seconds per reload step (4 steps total) when the magazine is empty.";
                typeName = "NUMBER";
                defaultValue = 20;
            };
            class MinimumAltitude {
                displayName = "Minimum Altitude";
                description = "Minimum altitude (meters) a target must be at to be engaged.";
                typeName = "NUMBER";
                defaultValue = 100;
            };
            class MaxRange {
                displayName = "Max Range";
                description = "Maximum engagement range in meters.";
                typeName = "NUMBER";
                defaultValue = 3000;
            };
            class MaxMissilesPerTarget {
                displayName = "Max Missiles Per Target";
                description = "Network-wide limit of in-flight missiles allowed per single air target. Prevents all launchers from dumping on one aircraft.";
                typeName = "NUMBER";
                defaultValue = 2;
                class values {
                    class V1 { name = "1"; value = 1; };
                    class V2 { name = "2"; value = 2; default = 1; };
                    class V3 { name = "3"; value = 3; };
                    class V4 { name = "4"; value = 4; };
                };
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before starting. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    // ==================== SHORAD (Networked) ====================
    class OKS_Module_SHORAD : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "SHORAD (Networked)";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleSHORAD";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Networked SHORAD. Sync a vehicle (Tigris, Cheetah, etc.) to rate-limit its missile fire. Native missile weapons are replaced with the unified GOL SHORAD IR launcher. Cannons are unaffected. The global network limits in-flight missiles per target across all SAM and SHORAD launchers.";
        };
        class Arguments {
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "SHORAD vehicle classname used when no vehicle is synced. Examples: O_APC_Tracked_02_AA_F (Tigris), B_APC_Tracked_01_AA_F (Cheetah), I_APC_tracked_03_AA_F (Cheetah IND)";
                typeName = "STRING";
                defaultValue = "O_APC_Tracked_02_AA_F";
            };
            class MissileType {
                displayName = "Missile Type";
                description = "IR missile variant. Light = high flare susceptibility, Medium = balanced, Heavy = low flare susceptibility.";
                typeName = "STRING";
                defaultValue = "medium";
                class values {
                    class Light { name = "Light (High Flare Susceptibility)"; value = "light"; };
                    class Medium { name = "Medium (Balanced)"; value = "medium"; default = 1; };
                    class Heavy { name = "Heavy (Low Flare Susceptibility)"; value = "heavy"; };
                };
            };
            class Ammo {
                displayName = "Missiles Per Turret";
                description = "Number of missiles each turret gets before a full reload cycle. Each turret tracks ammo independently.";
                typeName = "NUMBER";
                defaultValue = 4;
            };
            class ReloadTime {
                displayName = "Reload Time";
                description = "Base delay (seconds) between missile shots. Actual delay is randomised up to 1.5x this value. Full reload after all missiles spent = 4x this value.";
                typeName = "NUMBER";
                defaultValue = 10;
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before starting. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

