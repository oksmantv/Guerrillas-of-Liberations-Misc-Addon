# Convoy Framework — Complete Analysis

## Overview

The convoy framework is a **server-side** Arma 3 SQF system that spawns, moves, protects, and deploys convoys of AI vehicles along road networks. It consists of **2 entry points**, **19 helper functions**, and **9 air defence functions**, organized into three directories: root, `helper/`, and `airdefence/`.

---

## Entry Points

### 1. `OKS_fnc_Convoy_Spawn` — `fn_Convoy_Spawn.sqf`

The **primary** convoy spawner. This is the main function mission makers call.

**Parameters (11):**

| # | Type | Description |
|---|------|-------------|
| 1 | Object | Spawn position (Eden-placed helper object) |
| 2 | Object/Array/String | Intermediate waypoint(s) |
| 3 | Object | Final/end waypoint (herringbone destination) |
| 4 | Side | Faction side (east, west, independent) |
| 5 | Array | Vehicle params: `[count, classnames[], speedKph, dispersionMeters]` |
| 6 | Array | Cargo params: `[shouldHaveCargo, maxSoldiersPerVehicle]` |
| 7 | Array | Output array — filled with all created groups |
| 8 | Bool | Force careless (convoy ignores threats entirely) |
| 9 | Bool | Delete vehicles on reaching final waypoint |
| 10 | Array | Dismount behaviour types: `"rush"`, `"defend"`, `"patrol"`, `"assault"`, `"hunt"` |
| 11 | Bool | Fill both sides of road before advancing to next segment |

**Example:**
```sqf
[convoy_1,convoy_2,convoy_3,east,[4,["rhs_btr60_msv"], 6, 25],[true,6],[], false, false] spawn OKS_fnc_Convoy_Spawn;
[convoy_1,convoy_2,convoy_3,east,[4,["rhs_btr60_msv"], 6, 25],[true,6],[], false, false, ["rush"], true] spawn OKS_fnc_Convoy_Spawn; // Fill both sides
```

**Flow:**
1. Parses forced-AA classnames from `OKS_Convoy_AA_ForcedClassnames` / `OKS_Convoy_AA_ForcedMaxCount`
2. Spawns `_Count` vehicles sequentially, waiting for area clearance (`_DispersionInMeters` radius) before each spawn
3. Each vehicle gets crew via `OKS_fnc_AddVehicleCrew`, is locked, speed-limited, set to CARELESS/BLUE
4. Establishes a **linked list** of `OKS_Convoy_ImmediateLeader` references (vehicle N follows vehicle N-1)
5. Spawns `OKS_fnc_Convoy_CheckAndAdjustSpeeds` per vehicle for dynamic speed governance
6. Computes **herringbone positions** at the end waypoint via `OKS_fnc_Convoy_SetupHerringbone` — alternating left/right or dual-side fill
7. Creates **4 extra reserve positions** beyond the vehicle count
8. After the spawn loop, initializes slot tracking (`OKS_fnc_Convoy_InitIntendedSlots`), publishes reserve queues
9. If not forced-careless, starts three reactive systems:
   - `OKS_fnc_Convoy_WaitUntilCasualties` — damage/fire-near detection
   - `OKS_fnc_Convoy_WaitUntilTargets` — LOS/knowsAbout ground threat detection
   - `OKS_fnc_Convoy_WaitUntilAirTarget` — air defence engagement (only if dedicated AA vehicles exist)
10. Cleans up `Land_ClutterCutter_large_F` debug objects at end

### 2. `OKS_fnc_Convoy_Reinforce` — `fn_Convoy_Reinforce.sqf`

A **simpler, older** convoy variant designed for friendly resupply runs. Hardcodes unit classnames per side (vanilla Arma classes), creates debug markers, and optionally spawns a **resupply crate + task** at destination. Uses an inline `_WaitUntilCombat` code block rather than the modern helper functions. Does **not** include herringbone positioning, air defence, or the advanced speed governor.

**Parameters (12):**

| # | Type | Description |
|---|------|-------------|
| 1 | Object | Spawn position |
| 2 | Object | First waypoint |
| 3 | Object | Final waypoint |
| 4 | Side | Faction side |
| 5 | Array | Vehicle params: `[count, classnames[], speedMps, dispersion]` |
| 6 | Array | Cargo params: `[shouldHaveCargo, maxSoldiers]` |
| 7 | Bool | Force careless |
| 8 | String | Variable name set to true on completion |
| 9 | String | Resupply size |
| 10 | Bool | Should create resupply task |
| 11 | Bool | Should resupply |

**Example:**
```sqf
[reinforce_1,reinforce_2,reinforce_3,west,[4,["rhs_btr60_msv"], 6, 25],[true,6], false, "variable", "small", true, true] spawn OKS_fnc_Convoy_Reinforce;
```

---

## Helper Subsystem (`helper/`)

### Speed & Formation

#### `CheckAndAdjustSpeeds` — `fn_Convoy_CheckAndAdjustSpeeds.sqf` (370 lines)

The **core runtime loop** for each vehicle. Runs continuously while the vehicle crew is CARELESS. Responsibilities:

- **Distance-band speed control**: Measures distance to `OKS_Convoy_ImmediateLeader` and applies 4 speed tiers:
  - Very close (<50% dispersion): **25% base speed**
  - Close (<75%): **60% base speed**
  - Far (>150%): **125% base speed**
  - Very far (>200%): **150% base speed**
  - Normal band: base speed
- **Stuck detection**: If speed < 5 m/s for >2s near waypoint, issues `sendSimpleCommand "FORWARD"` nudge
- **Leader rebinding**: If the immediate leader is AA-engaging or disabled, searches backward through `OKS_Convoy_VehicleArray` for the next valid vehicle. Updates followers of the disabled vehicle too
- **Disabled vehicle exit**: Detects destroyed/immobile vehicles and switches them to COMBAT, removing convoy variables
- **Array cleanup**: Removes dead vehicles from `OKS_Convoy_VehicleArray` and `OKS_Convoy_AAArray` across all remaining vehicles
- **Front leader promotion**: If no valid vehicle exists ahead, promotes self to front leader
- **Dynamic dispersion**: Near waypoints (except `OKS_SUPPRESS_DISPERSION`-tagged ones), increases dispersion by 1.5×

### Herringbone Positioning

#### `SetupHerringbone` — `fn_Convoy_SetupHerringbone.sqf` (312 lines)

Computes angled parking positions along the road at the end waypoint using `roadsConnectedTo` / `getRoadInfo`. Two modes:

- **Alternating** (default): Each vehicle parks on the opposite side from the previous one
- **Dual-side filling** (`_FillBothSides`): Fills both sides of one road segment before moving to the next, tracking per-road side usage via variables like `OKS_Road_Side_<road>`

Places `Land_ClutterCutter_large_F` objects as occupancy markers (5m spacing check, 35m minimum hop spacing). Uses `OKS_fnc_Convoy_MakeSlot` for the actual 15m-offset, 45° angle slot positioning, and `OKS_fnc_Convoy_IsBlocked` for obstacle detection.

#### `MakeSlot` — `fn_Convoy_MakeSlot.sqf`

Builds a parking slot **15m perpendicular** to road center at **±45° angle**. If preferred side is blocked, flips to the other. Returns `[posATL, direction, usedLeft]`.

#### `NearestRoadTowardsOrigin` — `fn_Convoy_NearestRoadTowardsOrigin.sqf`

Walks the connected road graph toward the convoy's origin direction, selecting the best-matching connected road by direction difference.

### Combat Reaction

#### `WaitUntilCombat` — `fn_Convoy_WaitUntilCombat.sqf` (133 lines)

**Per-vehicle** combat handler. Waits for one of:
- AA engagement (exits without action)
- **Individual arrival** at herringbone position → deploys normally
- **Ambush** (`GOL_ConvoyAmbushed` flag) → pulls off road, then deploys

On trigger: stops vehicle, unlocks, dismounts cargo via `DismountAndTaskCode`. Armed vehicles get LAMBS tasks after a delay; artillery vehicles get mortar fire missions via `OKS_fnc_Mortars`; unarmed vehicles dismount crew to fight on foot.

#### `WaitUntilCasualties` — `fn_Convoy_WaitUntilCasualties.sqf` (107 lines)

Attaches **two event handlers** to every convoy vehicle:
- `FiredNear` — detects near-misses from hostile ground units within 1500m
- `HandleDamage` — detects direct hits from ground hostiles

Both trigger `OKS_fnc_Convoy_ProximityCombatFill` on the hit vehicle. After any casualty, increases base speed by 1.5× for all convoy groups (escape acceleration).

#### `WaitUntilTargets` — `fn_Convoy_WaitUntilTargets.sqf` (170 lines)

**Convoy-wide ground threat scanner**. Uses highly tunable parameters from `missionNamespace`:
- `OKS_Convoy_SpottingRange` (400m default)
- `OKS_Convoy_MinimumTargets` (1)
- `OKS_Convoy_LockingTime` (3s confirmation window)
- `OKS_Convoy_MinimumIdentification` (0.5 knowsAbout)
- Load-shedding controls: scan interval, jitter, vehicles per tick, stride, max candidates, max runtime (900s)

Uses LOS checks (`lineIntersectsSurfaces` + `checkVisibility`) and round-robin scanning across detector vehicles. When sustained threat is confirmed, triggers `ProximityCombatFill` on detecting vehicles.

#### `ProximityCombatFill` — `fn_Convoy_ProximityCombatFill.sqf`

**Flood-fill algorithm**: Starting from a detector vehicle, recursively finds all convoy vehicles within a radius (default 60m), marks them `GOL_ConvoyAmbushed = true` and switches to COMBAT. This creates a "ripple" effect — only nearby vehicles react, distant ones keep driving.

#### `DismountAndTaskCode` — `fn_Convoy_DismountAndTaskCode.sqf` (172 lines)

Universal dismount + task assignment. If ambushed, overrides defend/patrol to "attack". Supports 7 task types:

| Type | Behaviour |
|------|-----------|
| `rush` | `lambs_wp_fnc_taskRush` (1500m, 30s) |
| `attack` | SAD waypoint on nearest enemy |
| `hold` | HOLD waypoint at vehicle position |
| `hunt` | `lambs_wp_fnc_taskHunt` (1500m) |
| `defend` | Garrison nearest suitable building, or fallback to patrol |
| `patrol` | `lambs_wp_fnc_taskPatrol` (500m, 4 waypoints) |
| `assault` | `lambs_wp_fnc_taskAssault` on nearest enemy |

### Road / Terrain Helpers

#### `PullOffHelper` — `fn_Convoy_PullOffHelper.sqf` (191 lines)

Generic vehicle pull-off system used by both AA and ambush logic. Tries left, right, then ahead. Validates with `IsBlocked`, `IsFlatTerrain`, `IsOffRoad`, `EnsureMinRoadDistance`. Has a multi-stage fallback: short forward, then lateral stepping at 5m increments, then opposite side, then a full 360° spiral search up to 60m.

#### `IsBlocked` — `fn_Convoy_IsBlocked.sqf`

Checks for terrain objects (trees, rocks, walls) and game objects (buildings, vehicles) within radius (default 7m).

#### `DeleteAllWaypoints` — `fn_Convoy_DeleteAllWaypoints.sqf`

Deletes all waypoints from a group in reverse order.

### Parking / Reserve System

#### `InitIntendedSlots` — `fn_Convoy_InitIntendedSlots.sqf`

Tags each vehicle with its original convoy index (`OKS_Convoy_IntendedSlot`) and total primary slot count.

#### `AssignReserveWaypoint` — `fn_Convoy_AssignReserveWaypoint.sqf`

Finds the first unoccupied reserve position from `OKS_Convoy_ReserveQueue` and redirects a vehicle's last waypoint there. Used by AA vehicles that fall behind.

#### `EndParking_AssignIndices` — `fn_Convoy_EndParking_AssignIndices.sqf`

Two-pass algorithm: vehicles that kept up get their original primary slots; vehicles that fell behind get reserve tail slots. Stores `OKS_Convoy_EndParkIndex` on each vehicle.

#### `AssignParkingAtEnd`, `LeadArrivalMonitor`, `MonitorReserveActivation`

Currently **marked obsolete** or commented out in the spawn loop, but still present. They handle lead-arrival-triggered parking and automatic reserve activation for destroyed vehicles.

---

## Air Defence Subsystem (`airdefence/`)

### `CheckDedicatedAAAvailable` — `fn_Convoy_CheckDedicatedAAAvailable.sqf`

Scores each vehicle for AA dedication using: known AA classnames (ZSU, Tigris, etc.), radar, active radar components, AA missiles, autocannons, ammo availability. Threshold score ≥ 800 or explicit criteria. Excludes vehicles with cargo aboard or `OKS_Convoy_ExcludeFromAA`. Stores the AA array on all convoy vehicles.

### `SelectAAVehicle` — `fn_Convoy_SelectAAVehicle.sqf`

Picks the closest available (`OKS_AA_Available`) AA vehicle to the nearest air target. Skips vehicles with cargo, currently returning from engagement, or unavailable.

### `FindEnemyAirTargets` — `fn_Convoy_FindEnemyAirTargets.sqf`

Dual-pass detection: scans crew group known targets AND `nearEntities` for helicopters (1500m default) and planes (2500m default). Filters by `knowsAbout > 2.0`, aliveness, hostility, excludes parachutes and previously ignored targets.

### `WaitUntilAirTarget` — `fn_Convoy_WaitUntilAirTarget.sqf` (706 lines)

The **main air defence orchestrator**. Runs in a `while` loop until all convoy vehicles have stopped. On air threat detection:

1. Selects best AA vehicle, marks it unavailable
2. Stores all pending waypoints, deletes them
3. Reveals air targets to AA crew (knowsAbout 4)
4. Computes pull-off position (50m ahead, 22.75m lateral), disables targeting during transit
5. Moves to pull-off with timeout (10s skip-distance, 45s hard timeout)
6. Enables full combat (TARGET/AUTOTARGET/AUTOCOMBAT), stops vehicle, engages
7. Waits for: skies clear + all convoy vehicles behind have passed through checkpoint AND are >60m away (two-stage passing detection), OR 30s clear-sky timeout, OR 180s hard timeout, OR 500m hard fallback
8. 15s minimum post-clear wait
9. Restores stored waypoints, tries reserve waypoint assignment
10. Rejoins convoy at tail: removes from array, appends at end, re-establishes speed governor with new immediate leader
11. Re-enables `WaitUntilCombat` for the AA vehicle, re-marks as available

### `AAMergeGapHandler` — `fn_Convoy_AAMergeGapHandler.sqf`

Speed ramp helper for AA merge: waits until gap is ≥ `_gapMin` or timeout, then ramps speed from 10 to base in increments.

### Utility Functions

| Function | Purpose |
|----------|---------|
| `IsEnemySide` | `getFriend < 0.6` hostility check |
| `IsFlatTerrain` | `surfaceNormal` slope check against max degrees |
| `IsOffRoad` | `!isOnRoad` check |
| `EnsureMinRoadDistance` | Nudges position laterally until ≥ `_minRoadDistance` from nearest road |

---

## Key Variable Namespace

| Variable | Scope | Purpose |
|----------|-------|---------|
| `OKS_Convoy_ImmediateLeader` | Vehicle | Linked-list reference to vehicle ahead |
| `OKS_Convoy_FrontLeader` | Vehicle | Reference to the lead vehicle |
| `OKS_Convoy_VehicleArray` | Vehicle | Full convoy array (kept synced across all) |
| `OKS_Convoy_AAArray` | Vehicle | Array of dedicated AA vehicles |
| `OKS_Convoy_AAEngaging` | Vehicle | Currently performing AA intercept |
| `OKS_AA_Available` | Vehicle | Available for new AA tasks |
| `OKS_Convoy_Stopped` | Vehicle | Reached destination or halted |
| `OKS_Convoy_IndividualArrival` | Vehicle | Reached its herringbone position |
| `GOL_ConvoyAmbushed` | Vehicle | Flagged by ProximityCombatFill |
| `OKS_LimitSpeedBase` | Vehicle | Base speed in kph |
| `OKS_ForceSpeedActive` | Vehicle | Speed governor is active |
| `OKS_Convoy_ReserveQueue` | Vehicle | Array of `[pos, occupied]` reserve positions |
| `OKS_Convoy_IntendedSlot` | Vehicle | Original convoy index |
| `OKS_Convoy_ForceAA` | Vehicle | Explicitly forced as AA vehicle |
| `OKS_Convoy_ExcludeFromAA` | Vehicle | Excluded from AA selection |
| `OKS_Convoy_UnderAttack` | Vehicle | Flagged by casualty event handlers |
| `GOL_Convoy_Debug` | Mission | Master debug toggle |
| `GOL_Convoy_Speed_Debug` | Mission | Speed system debug |
| `GOL_Convoy_Dispersion_Debug` | Mission | Dispersion debug |
| `GOL_Convoy_Target_Debug` | Mission | Ground target debug |
| `GOL_Convoy_AA_Debug` | Mission | Air defence debug |
| `GOL_Convoy_Markers_Debug` | Mission | Visual debug markers |

---

## Architectural Summary

The framework uses a **decentralized, event-driven** architecture:

- Each vehicle has its own speed governor loop (`CheckAndAdjustSpeeds`) and combat monitor (`WaitUntilCombat`)
- Threat detection is split into **three independent monitors**: casualties (event handlers), ground targets (periodic LOS scan), and air targets (dedicated AA loop)
- Combat response uses **flood-fill proximity** rather than whole-convoy switching — only nearby vehicles react to threats
- AA vehicles operate with a full **detach → engage → rejoin** lifecycle, preserving and restoring waypoints
- The linked-list leader chain self-heals when vehicles are destroyed or AA-detached through the rebinding logic in `CheckAndAdjustSpeeds`
