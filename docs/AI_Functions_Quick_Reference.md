# AI Functions Quick Reference

Quick reference for the AI system functions in OKS Guerrillas of Liberation Misc Addon.

## Artillery Battle System

**Function**: `OKS_fnc_AI_ArtilleryBattle`

### Quick Start
```sqf
// Basic artillery battle
_battle = [arty_spawn_1, arty_spawn_2, west, east] call OKS_fnc_AI_ArtilleryBattle;

// Stop battle
_battle setVariable ["OKS_ArtilleryBattle_On", false];
```

### Full Parameters
```sqf
[
    _Side1Spawn,           // Object - Side 1 artillery spawn
    _Side2Spawn,           // Object - Side 2 artillery spawn  
    _Side1,                // Side - Side 1 faction (default: west)
    _Side2,                // Side - Side 2 faction (default: east)
    _Side1Classes,         // Array - Side 1 artillery classes (default: ["B_MBT_01_arty_F"])
    _Side2Classes,         // Array - Side 2 artillery classes (default: ["O_MBT_02_arty_F"])
    _BaseFireMissionDelay, // Number - Base delay between missions (default: 45)
    _RoundsPerFireMission, // Number - Rounds per mission (default: 4)
    _ShouldLoop,           // Boolean - Enable looping (default: true)
    _MaxFireMissions,      // Number - Max missions, -1 = infinite (default: -1)
    _VictoryDelay          // Number - Victory delay before cleanup (default: 30)
] call OKS_fnc_AI_ArtilleryBattle;
```

---

## Helicopter Flyby System

**Function**: `OKS_fnc_AI_HelicopterFlyBy`

### Quick Start
```sqf
// Basic helicopter flyby
_flyby = [heli_spawn_1, heli_endpoint_1, west] call OKS_fnc_AI_HelicopterFlyBy;

// Stop flyby
_flyby setVariable ["OKS_HeliFlyBy_On", false];
```

### Full Parameters
```sqf
[
    _SpawnPoint,           // Object - Helicopter spawn (required)
    _EndPoint,             // Object - Flight endpoint (required)
    _Side,                 // Side - Helicopter faction (default: west)
    _HelicopterClasses,    // Array - Helicopter classes (default: ["B_Heli_Transport_01_F"])
    _EnableResupplyDrop,   // Boolean - Enable resupply drops (default: false)
    _FlyByDelay,           // Array - Delay range [min, max] (default: [90, 180])
    _FlightAltitude,       // Number - Flight altitude meters (default: 250)
    _FlightBehaviour,      // String - Flight behavior (default: "STEALTH")
    _ShouldLoop,           // Boolean - Enable looping (default: true)
    _MaxFlyByMissions,     // Number - Max missions, -1 = infinite (default: -1)
    _CleanupDelay          // Number - Cleanup delay (default: 30)
] call OKS_fnc_AI_HelicopterFlyBy;
```

---

## Convoy Spawn System

**Function**: `OKS_fnc_Convoy_Spawn`

### Quick Start
```sqf
// Basic convoy
[convoy_spawn_1, convoy_waypoint_1, convoy_end_1, east, [4, ["rhs_btr60_msv"], 15, 25]] call OKS_fnc_Convoy_Spawn;
```

### Full Parameters
```sqf
[
    _Spawn,              // Object - Spawn position (required)
    _Waypoint,           // Object/Array/String - First waypoint (required)
    _End,                // Object - Final waypoint (required)
    _Side,               // Side - Convoy faction (default: east)
    _VehicleParams,      // Array - [count, classes, speed, dispersion] (default: [])
    _CargoParams,        // Array - [spawn_troops, max_per_vehicle] (default: [])
    _ConvoyGroupArray,   // Array - Gets filled with convoy units (default: [])
    _ForcedCareless,     // Boolean - Force careless behavior (default: false)
    _DeleteAtFinalWP,    // Boolean - Delete at final waypoint (default: false)
    _DismountBehaviour,  // Array - Dismount behaviors (default: ["rush"])
    _FillBothSides       // Boolean - Fill both road sides (default: false)
] call OKS_fnc_Convoy_Spawn;
```

### Vehicle Parameters
```sqf
_VehicleParams = [
    4,                          // Number of vehicles
    ["rhs_btr60_msv"],         // Vehicle classes (array or string)
    15,                        // Speed in m/s
    25                         // Dispersion in meters
];
```

### Cargo Parameters
```sqf
_CargoParams = [
    true,                      // Spawn troops in cargo
    6                          // Max soldiers per vehicle
];
```

---

## Control Variables

### Artillery Battle Control
```sqf
_battle setVariable ["OKS_ArtilleryBattle_On", false];      // Stop battle
_battle setVariable ["OKS_ArtilleryBattle_Pause", true];    // Pause battle
_currentMission = _battle getVariable ["OKS_ArtilleryBattle_FireMission", 0];
```

### Helicopter Flyby Control
```sqf
_flyby setVariable ["OKS_HeliFlyBy_On", false];            // Stop flyby
_flyby setVariable ["OKS_HeliFlyBy_Pause", true];          // Pause flyby
_currentMission = _flyby getVariable ["OKS_HeliFlyBy_Mission", 0];
```

---

## Debug Mode

Enable debug logging for all systems:
```sqf
missionNamespace setVariable ["GOL_AI_ArtilleryBattle_Debug", true];
missionNamespace setVariable ["GOL_AI_HelicopterFlyBy_Debug", true];
missionNamespace setVariable ["GOL_Convoy_Debug", true];
```

---

## Common Examples

### Artillery Battle with Mixed Types
```sqf
[
    arty_west, arty_east, west, east,
    ["B_MBT_01_arty_F", "B_MBT_01_mlrs_F"],    // Mixed artillery
    ["O_MBT_02_arty_F", "O_T_MBT_02_arty_ghex_F"],
    60, 6, true, 20, 45
] call OKS_fnc_AI_ArtilleryBattle;
```

### Supply Helicopter with Drops
```sqf
[
    supply_spawn, supply_endpoint, west,
    ["B_Heli_Transport_01_F"],
    true,           // Enable resupply drops
    [180, 300],     // 3-5 minute delays
    150             // Lower altitude for drops
] call OKS_fnc_AI_HelicopterFlyBy;
```

### Reinforcement Convoy with Troops
```sqf
_units = [];
[
    spawn_pos, waypoint_1, destination, west,
    [6, ["rhsusf_stryker_m1126_m2_wd"], 12, 30],
    [true, 8],      // 8 troops per vehicle
    _units,         // Store spawned units
    false, false, ["defend", "assault"]
] call OKS_fnc_Convoy_Spawn;
```

---

## Dismount Behaviors (Convoy)

- `"rush"` - Quick movement to objectives
- `"defend"` - Defensive positioning  
- `"patrol"` - Area patrol patterns
- `"assault"` - Aggressive assault tactics
- `"hunt"` - Search and destroy missions

## Flight Behaviors (Helicopter)

- `"STEALTH"` - Silent, covert flight
- `"COMBAT"` - Alert, ready for engagement  
- `"SAFE"` - Relaxed, low threat awareness
- `"AWARE"` - Cautious, scanning for threats