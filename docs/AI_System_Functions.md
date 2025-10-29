# AI System Functions Documentation

This document provides comprehensive documentation for the advanced AI systems in the OKS Guerrillas of Liberation Misc Addon.

## Table of Contents

1. [Artillery Battle System](#artillery-battle-system)
2. [Helicopter Flyby System](#helicopter-flyby-system)
3. [Convoy Spawn System](#convoy-spawn-system)

---

## Artillery Battle System

**Function:** `OKS_fnc_AI_ArtilleryBattle`  
**File:** `functions/spawn/fn_AI_ArtilleryBattle.sqf`

### Description

Creates persistent AI vs AI artillery battles with progressive accuracy improvement, burst fire missions, and intelligent target selection. Battles continue until manually stopped or one side is eliminated.

### Features

- **Persistent Combat**: Continuous artillery engagement between two sides
- **Progressive Accuracy**: Artillery accuracy improves over time (starts at 500m dispersion, reduces to 50m minimum)
- **Range Validation**: Uses proper `inRangeOfArtillery` command for realistic engagement ranges
- **Cross-Battle Targeting**: Artillery can engage enemy pieces from other battles
- **Automatic Replacement**: Replaces artillery pieces that cannot engage targets
- **Crew Monitoring**: Eliminates dismounted crew after 30 seconds
- **Unlimited Ammunition**: Automatic resupply system
- **Comprehensive Logging**: Detailed debug information for troubleshooting

### Syntax

```sqf
[
    _Side1Spawn,           // Side 1 artillery spawn object
    _Side2Spawn,           // Side 2 artillery spawn object  
    _Side1,                // Side 1 faction
    _Side2,                // Side 2 faction
    _Side1Classes,         // Side 1 artillery classes
    _Side2Classes,         // Side 2 artillery classes
    _BaseFireMissionDelay, // Base delay between fire missions (seconds)
    _RoundsPerFireMission, // Rounds per fire mission
    _ShouldLoop,           // Enable looping battles
    _MaxFireMissions,      // Max fire missions (-1 = infinite)
    _VictoryDelay          // Victory delay before cleanup
] call OKS_fnc_AI_ArtilleryBattle;
```

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `_Side1Spawn` | Object | objNull | Spawn position for Side 1 artillery |
| `_Side2Spawn` | Object | objNull | Spawn position for Side 2 artillery |
| `_Side1` | Side | west | Faction for Side 1 |
| `_Side2` | Side | east | Faction for Side 2 |
| `_Side1Classes` | Array | ["B_MBT_01_arty_F"] | Artillery vehicle classes for Side 1 |
| `_Side2Classes` | Array | ["O_MBT_02_arty_F"] | Artillery vehicle classes for Side 2 |
| `_BaseFireMissionDelay` | Number | 45 | Base delay between fire missions (seconds) |
| `_RoundsPerFireMission` | Number | 4 | Number of rounds per fire mission |
| `_ShouldLoop` | Boolean | true | Enable continuous battles |
| `_MaxFireMissions` | Number | -1 | Maximum fire missions (-1 = infinite) |
| `_VictoryDelay` | Number | 30 | Delay after victory before cleanup |

### Return Value

**Object** - Control object (Side1 spawn) for external battle management

### Control Variables

The returned control object has the following variables for external management:

- `OKS_ArtilleryBattle_On` - Boolean to stop/start the battle
- `OKS_ArtilleryBattle_FireMission` - Current fire mission number
- `OKS_ArtilleryBattle_Pause` - Boolean to pause/resume the battle
- `OKS_ArtilleryBattle_BattleId` - Unique battle identifier

### Examples

#### Basic Artillery Battle
```sqf
// Start a basic artillery battle between West and East
_battleControl = [
    arty_spawn_west,        // West artillery spawn
    arty_spawn_east,        // East artillery spawn
    west,                   // West side
    east,                   // East side
    ["B_MBT_01_arty_F"],    // West Scorcher
    ["O_MBT_02_arty_F"],    // East Sochor
    45,                     // 45 second delays
    4,                      // 4 rounds per mission
    true,                   // Loop enabled
    -1,                     // Infinite missions
    30                      // 30 second victory delay
] call OKS_fnc_AI_ArtilleryBattle;
```

#### Multiple Artillery Types
```sqf
// Artillery battle with multiple vehicle types
_battleControl = [
    arty_spawn_1,
    arty_spawn_2,
    west,
    east,
    ["B_MBT_01_arty_F", "B_MBT_01_mlrs_F"],     // Mix of tube and rocket artillery
    ["O_MBT_02_arty_F", "O_T_MBT_02_arty_ghex_F"],
    60,                                          // Longer delays for heavier combat
    6,                                           // More rounds per mission
    true,
    20,                                          // Limited to 20 missions
    45
] call OKS_fnc_AI_ArtilleryBattle;
```

#### Controlling the Battle
```sqf
// Stop the battle
_battleControl setVariable ["OKS_ArtilleryBattle_On", false];

// Pause the battle
_battleControl setVariable ["OKS_ArtilleryBattle_Pause", true];

// Resume the battle
_battleControl setVariable ["OKS_ArtilleryBattle_Pause", false];

// Get current mission number
_currentMission = _battleControl getVariable ["OKS_ArtilleryBattle_FireMission", 0];
```

### Debug Mode

Enable debug logging by setting:
```sqf
missionNamespace setVariable ["GOL_AI_ArtilleryBattle_Debug", true];
```

---

## Helicopter Flyby System

**Function:** `OKS_fnc_AI_HelicopterFlyBy`  
**File:** `functions/spawn/fn_AI_HelicopterFlyBy.sqf`

### Description

Creates persistent helicopter fly-by missions where helicopters spawn, fly to endpoint, return to spawn, and delete. Continues looping with configurable delays and helicopter types. Supports optional resupply drops during flight.

### Features

- **Looping Missions**: Continuous helicopter flights with configurable delays
- **Multiple Aircraft Types**: Random selection from provided helicopter classes
- **Resupply Drops**: Optional parachute supply drops near endpoint
- **Crew Monitoring**: Eliminates dismounted crew after 30 seconds
- **Stealth Operations**: Configurable flight behavior and combat modes
- **Player Interference Prevention**: AI ignores players during missions
- **Flight Validation**: Ensures helicopters complete full round-trip flights
- **Comprehensive Logging**: Detailed mission tracking and debug information

### Syntax

```sqf
[
    _SpawnPoint,           // Helicopter spawn object
    _EndPoint,             // Flight endpoint object
    _Side,                 // Side faction
    _HelicopterClasses,    // Helicopter classes
    _EnableResupplyDrop,   // Enable resupply drops
    _FlyByDelay,           // Delay between missions [min, max]
    _FlightAltitude,       // Flight altitude (meters)
    _FlightBehaviour,      // Flight behavior
    _ShouldLoop,           // Enable looping
    _MaxFlyByMissions,     // Max missions (-1 = infinite)
    _CleanupDelay          // Cleanup delay after completion
] call OKS_fnc_AI_HelicopterFlyBy;
```

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `_SpawnPoint` | Object | objNull | Helicopter spawn position |
| `_EndPoint` | Object | objNull | Flight endpoint position |
| `_Side` | Side | west | Helicopter faction |
| `_HelicopterClasses` | Array | ["B_Heli_Transport_01_F"] | Helicopter vehicle classes |
| `_EnableResupplyDrop` | Boolean | false | Enable parachute resupply drops |
| `_FlyByDelay` | Array | [90, 180] | Delay range between missions [min, max] seconds |
| `_FlightAltitude` | Number | 250 | Flight altitude in meters |
| `_FlightBehaviour` | String | "STEALTH" | Flight behavior mode |
| `_ShouldLoop` | Boolean | true | Enable continuous flyby missions |
| `_MaxFlyByMissions` | Number | -1 | Maximum missions (-1 = infinite) |
| `_CleanupDelay` | Number | 30 | Delay before cleanup |

### Flight Behaviors

- `"STEALTH"` - Silent, covert flight
- `"COMBAT"` - Alert, ready for engagement
- `"SAFE"` - Relaxed, low threat awareness
- `"AWARE"` - Cautious, scanning for threats

### Return Value

**Object** - Control object (spawn point) for external flyby management

### Control Variables

The returned control object has the following variables for external management:

- `OKS_HeliFlyBy_On` - Boolean to stop/start flyby system
- `OKS_HeliFlyBy_Mission` - Current mission number
- `OKS_HeliFlyBy_Pause` - Boolean to pause/resume missions
- `OKS_HeliFlyBy_FlybyId` - Unique flyby identifier

### Examples

#### Basic Transport Flyby
```sqf
// Simple helicopter flyby without resupply
_flybyControl = [
    heli_spawn_1,                    // Spawn position
    heli_endpoint_1,                 // Endpoint
    west,                            // Western forces
    ["B_Heli_Transport_01_F"],       // Ghosthawk
    false,                           // No resupply drops
    [120, 240],                      // 2-4 minute delays
    200,                             // 200m altitude
    "STEALTH",                       // Stealth flight
    true,                            // Loop enabled
    -1,                              // Infinite missions
    30                               // 30 second cleanup
] call OKS_fnc_AI_HelicopterFlyBy;
```

#### Supply Mission Flyby
```sqf
// Helicopter flyby with resupply drops
_supplyFlyby = [
    supply_spawn,
    supply_endpoint,
    west,
    ["B_Heli_Transport_01_F", "B_Heli_Transport_03_F"],  // Multiple helicopter types
    true,                                                 // Enable resupply drops
    [180, 300],                                          // 3-5 minute delays
    150,                                                 // Lower altitude for drops
    "SAFE",                                              // Safe flight behavior
    true,
    10,                                                  // Limited to 10 missions
    45
] call OKS_fnc_AI_HelicopterFlyBy;
```

#### High-Altitude Reconnaissance
```sqf
// High-altitude reconnaissance flights
_reconFlyby = [
    recon_spawn,
    recon_endpoint,
    west,
    ["B_Heli_Light_01_F"],           // Little Bird
    false,                           // No resupply
    [60, 120],                       // Frequent flights
    400,                             // High altitude
    "AWARE",                         // Alert behavior
    true,
    -1,
    20
] call OKS_fnc_AI_HelicopterFlyBy;
```

#### Controlling Flyby Operations
```sqf
// Stop flyby operations
_flybyControl setVariable ["OKS_HeliFlyBy_On", false];

// Pause operations
_flybyControl setVariable ["OKS_HeliFlyBy_Pause", true];

// Resume operations
_flybyControl setVariable ["OKS_HeliFlyBy_Pause", false];

// Get current mission number
_currentMission = _flybyControl getVariable ["OKS_HeliFlyBy_Mission", 0];
```

### Debug Mode

Enable debug logging by setting:
```sqf
missionNamespace setVariable ["GOL_AI_HelicopterFlyBy_Debug", true];
```

---

## Convoy Spawn System

**Function:** `OKS_fnc_Convoy_Spawn`  
**File:** `functions/spawn/convoy/fn_Convoy_Spawn.sqf`

### Description

Spawns and manages convoys of vehicles that move from a spawn position through waypoints, optionally carrying troops, and can perform various tactical behaviors upon reaching their destination.

### Features

- **Flexible Vehicle Composition**: Support for mixed vehicle types
- **Troop Transport**: Optional cargo troops with configurable dismount behaviors
- **Road Formation**: Intelligent vehicle positioning on roads
- **Speed Management**: Automatic convoy speed coordination
- **Tactical Behaviors**: Multiple dismount and positioning options
- **Herringbone Formation**: Professional military convoy deployment
- **Combat Monitoring**: Automatic response to enemy contact

### Syntax

```sqf
[
    _Spawn,              // Spawn Position
    _Waypoint,           // First Waypoint
    _End,                // Final Waypoint
    _Side,               // Side faction
    _VehicleParams,      // Vehicle configuration
    _CargoParams,        // Troop configuration
    _ConvoyGroupArray,   // Array to fill with convoy units
    _ForcedCareless,     // Force careless behavior
    _DeleteAtFinalWP,    // Delete convoy at final waypoint
    _DismountBehaviour,  // Dismount behavior types
    _FillBothSides       // Road filling pattern
] call OKS_fnc_Convoy_Spawn;
```

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `_Spawn` | Object | objNull | Spawn position for the convoy |
| `_Waypoint` | Object/Array/String | nil | First waypoint (object, position array, or marker) |
| `_End` | Object | objNull | Final waypoint where convoy spreads out |
| `_Side` | Side | east | Convoy faction |
| `_VehicleParams` | Array | [] | Vehicle configuration [count, classes, speed, dispersion] |
| `_CargoParams` | Array | [] | Troop configuration [spawn troops, max per vehicle] |
| `_ConvoyGroupArray` | Array | [] | Array that gets filled with convoy units |
| `_ForcedCareless` | Boolean | false | Force careless behavior (no reactions) |
| `_DeleteAtFinalWP` | Boolean | false | Delete convoy upon reaching final waypoint |
| `_DismountBehaviour` | Array | ["rush"] | Dismount behavior types |
| `_FillBothSides` | Boolean | false | Fill both road sides before moving to next segment |

### Vehicle Parameters Array

The `_VehicleParams` array contains:
1. **Count** (Number) - Number of vehicles to spawn
2. **Classes** (Array/String) - Vehicle class names or single class
3. **Speed** (Number) - Movement speed in meters per second
4. **Dispersion** (Number) - Vehicle spacing in meters

### Cargo Parameters Array

The `_CargoParams` array contains:
1. **Spawn Troops** (Boolean) - Whether to spawn cargo troops
2. **Max Per Vehicle** (Number) - Maximum soldiers per vehicle

### Dismount Behaviors

Available dismount behavior options:
- `"rush"` - Quick movement to objectives
- `"defend"` - Defensive positioning
- `"patrol"` - Area patrol patterns
- `"assault"` - Aggressive assault tactics
- `"hunt"` - Search and destroy missions

### Examples

#### Basic Military Convoy
```sqf
// Simple military convoy without troops
[
    convoy_spawn_1,                    // Spawn position
    convoy_waypoint_1,                 // First waypoint
    convoy_end_1,                      // Final position
    east,                              // Eastern forces
    [4, ["rhs_btr60_msv"], 15, 25],   // 4 BTR-60s, 15 m/s, 25m spacing
    [false, 0],                        // No cargo troops
    [],                                // Empty convoy array
    false,                             // Not forced careless
    false,                             // Don't delete at end
    ["rush"],                          // Rush behavior
    false                              // Traditional alternating pattern
] call OKS_fnc_Convoy_Spawn;
```

#### Reinforcement Convoy with Troops
```sqf
// Convoy carrying reinforcement troops
_convoyUnits = [];
[
    reinforce_spawn,
    reinforce_waypoint,
    reinforce_destination,
    west,
    [6, ["rhsusf_stryker_m1126_m2_wd", "rhsusf_M1230a1_usarmy_wd"], 12, 30],  // Mixed vehicles
    [true, 8],                         // Spawn 8 troops per vehicle
    _convoyUnits,                      // Store units in array
    false,
    false,
    ["defend", "assault"],             // Mixed behaviors
    true                               // Fill both road sides
] call OKS_fnc_Convoy_Spawn;

// Access spawned units
hint format ["Convoy spawned with %1 total units", count _convoyUnits];
```

#### Supply Convoy with Auto-Deletion
```sqf
// Supply convoy that deletes after delivery
[
    supply_depot,
    supply_route_1,
    supply_destination,
    west,
    [3, ["B_Truck_01_covered_F"], 8, 20],  // 3 covered trucks
    [false, 0],                            // No passengers
    [],
    true,                                  // Forced careless (no combat reactions)
    true,                                  // Delete at final waypoint
    ["rush"],
    false
] call OKS_fnc_Convoy_Spawn;
```

#### Heavy Armor Convoy
```sqf
// Tank convoy with mixed armor
[
    armor_spawn,
    armor_waypoint_1,
    armor_objective,
    west,
    [5, ["B_MBT_01_cannon_F", "B_APC_Wheeled_01_cannon_F"], 10, 40],  // Tanks and IFVs
    [true, 4],                           // Limited crew
    [],
    false,
    false,
    ["assault", "hunt"],                 // Aggressive behaviors
    false
] call OKS_fnc_Convoy_Spawn;
```

### Debug Mode

Enable debug logging by setting:
```sqf
missionNamespace setVariable ["GOL_Convoy_Debug", true];
```

---

## Common Debug Variables

All three systems support comprehensive debug logging. Enable debug modes by setting these variables:

```sqf
// Enable all AI system debugging
missionNamespace setVariable ["GOL_AI_ArtilleryBattle_Debug", true];
missionNamespace setVariable ["GOL_AI_HelicopterFlyBy_Debug", true];
missionNamespace setVariable ["GOL_Convoy_Debug", true];
```

## Performance Considerations

- **Artillery Battles**: Each battle spawns 2 artillery pieces and crews. Multiple battles can run simultaneously.
- **Helicopter Flybys**: Each flyby spawns 1 helicopter with crew. Cleanup is automatic after missions.
- **Convoy Spawns**: Vehicle count directly affects performance. Limit convoy size for better performance.

## Compatibility

- **Arma 3 Version**: 2.14 or higher
- **Required Addons**: CBA_A3, ACE3 (optional but recommended)
- **Mod Compatibility**: Works with RHS, CUP, and other major military mods

## Support

For issues, questions, or feature requests, please refer to the main README.md or contact the development team.