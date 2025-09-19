# Convoy AI – Working Notes and Engineering Log (transferable)

Date: 2025-09-15
Branch: features/main-convoy_improvement_update
Scope: Arma 3 SQF convoy system refactor, AA air-defense behavior, helpers, debug, and speed logic

## Overview
This document captures the architecture, key behaviors, decisions, refactors, debug conventions, and open issues addressed throughout the convoy AI improvement work. It’s intended to transfer context to future editors/Copilot sessions.

## High-level goals
- Fully automate convoy behavior post-spawn (no manual intervention)
- Modularize logic into helpers and register in CfgFunctions
- Improve clarity: descriptive names, consolidate helpers, remove local/private duplicates
- Robust AA vehicle engagement and rejoin behavior
- Standardized debug output with searchable tags
- Correct speed control using forceSpeed/limitSpeed across lifecycle

## Key files and responsibilities
- `functions/spawn/convoy/fn_Convoy_Spawn.sqf`
  - Spawns vehicles, crews, cargo; sets waypoint flow and end behavior
  - Initializes Convoy Vehicle Array and lead pointers
  - Starts monitors: casualties, targets (ground), air target handler, reserve activation, lead arrival
  - Applies per-vehicle limit/force speed and registers speed-control loop
  - Uses: `OKS_fnc_Convoy_CheckAndAdjustSpeeds`, `OKS_fnc_Convoy_CatchUpBooster` (helper), `OKS_fnc_Convoy_WaitUntilCombat`, `OKS_fnc_Convoy_WaitUntilTargets`, `OKS_fnc_Convoy_WaitUntilAirTarget`

- `functions/spawn/convoy/helper/fn_Convoy_CheckAndAdjustSpeeds.sqf`
  - Main convoy-follow speed governor. Each follower keeps spacing to leader vehicle (dispersion)
  - Uses vehicle vars: `OKS_ForceSpeedActive`, `OKS_LimitSpeedBase`, `OKS_Convoy_Dispersion`
  - Handles leader changes when vehicles disabled/removed

- `functions/spawn/convoy/helper/fn_Convoy_CatchUpBooster.sqf`
  - Temporary uncapping when a follower lags beyond threshold; toggles forceSpeed -1 during boost
  - NOTE: This helper is used in `fn_Convoy_Spawn.sqf`. Ensure file exists.

- `functions/spawn/convoy/helper/fn_Convoy_WaitUntilCombat.sqf`
  - Monitors for ground combat engagement; switches behavior when contact

- `functions/spawn/convoy/helper/fn_Convoy_WaitUntilTargets.sqf`
  - Monitors for nearby targets and reacts as needed (non-air layer)

- `functions/spawn/convoy/helper/fn_Convoy_InitIntendedSlots.sqf`, `fn_Convoy_MakeSlot.sqf`, `fn_Convoy_AssignParkingAtEnd.sqf`, `fn_Convoy_EndParking_AssignIndices.sqf`, `fn_Convoy_LeadArrivalMonitor.sqf`, `fn_Convoy_MonitorReserveActivation.sqf`
  - Slot tracking, herringbone end parking, reserve activation when losses happen, and lead arrival cleanup

- `functions/spawn/convoy/airdefence/fn_Convoy_WaitUntilAirTarget.sqf`
  - Core AA flow: detect air, select AA vehicle, pull-off to engage, hold/engage, restore and rejoin tail
  - Stores/restores waypoints; ensures AA follows last convoy vehicle post-engagement
  - Uses speed unlock during pull-off and catch-up; re-applies convoy speed logic after merge
  - Ensures AA is revealed targets during engagement

- `functions/spawn/convoy/airdefence/fn_Convoy_SelectAAVehicle.sqf`
  - Chooses best AA vehicle (alive, movable, in convoy). Variables clarified with descriptive names

- `functions/spawn/convoy/airdefence/fn_Convoy_FindEnemyAirTargets.sqf`
  - Returns array of airborne threats filtered by side/ignore list

- `functions/spawn/convoy/airdefence/fn_Convoy_IsOffRoad.sqf`, `fn_Convoy_IsFlatTerrain.sqf`, `fn_Convoy_EnsureMinRoadDistance.sqf`
  - Terrain validation and positioning helpers for safe pull-off

- Deprecated/removed
  - `fn_Convoy_IsClearOfObstacles.sqf` (deleted) – replaced by `fn_Convoy_IsBlocked.sqf`

## Behavior specs and contracts
- Spacing and follow
  - Each follower maintains dispersion to its immediate predecessor; speed is regulated via `limitSpeed` baseline and temporary `forceSpeed` as needed
  - Edge case: if convoy size <= 1, following logic gracefully no-ops

- AA engagement lifecycle
  1) Detect air targets via `OKS_fnc_Convoy_FindEnemyAirTargets`
  2) Select AA vehicle with `OKS_fnc_Convoy_SelectAAVehicle`
  3) Store current waypoints of AA group from current index onward; delete them from the group
  4) Compute pull-off point (ahead + lateral, off-road, slope-limited, road-distance-enforced)
  5) Set `OKS_Convoy_AAEngaging` true only at this point; add temporary MOVE waypoint to pull-off; travel conservatively (AWARE/YELLOW)
  6) Unlock speed for pull-off: `limitSpeed 999; forceSpeed -1` to release forced governor and allow AI speed control
  7) On arrival, if still on road, issue a small “nudge” off-road waypoint, then set group to COMBAT/RED and stop vehicle: `limitSpeed 0; forceSpeed 0`
  8) Before/at engagement, reveal all detected air targets to AA vehicle and each unit in the group with `reveal [target, 4]`
  9) Hold until skies clear and convoy is sufficiently spaced (>= 100m), or a timeout occurs
  10) Restore stored waypoints, set `OKS_Convoy_AAEngaging` false, set vehicle CARELESS; unlock with `limitSpeed 999; forceSpeed -1`
  11) Rejoin at tail and reapply convoy speed logic following the last vehicle; wait until within dispersion before re-locking as needed

- Leader reassignment and removals
  - Disabled/destroyed vehicles are removed from arrays; convoy leader pointer propagated; followers update leader references automatically

## Debug conventions
- Global enable flag: `missionNamespace getVariable ["GOL_Convoy_Debug", false]`
- Tags used (searchable):
  - `[CONVOY-SPAWN]`, `[CONVOY-GROUP]`, `[CONVOY-VEHICLE-CLASS]`, `[CONVOY-WAIT-CLEARANCE]`
  - `[CONVOY_AIR]` for all AA-related logs
  - `[CONVOY_DEBUG]` used in some helpers for generic events
- Avoid duplicate state text; keep messages short and tagged
- Added logs:
  - On every application of `forceSpeed -1` in AA and booster code
  - At AA pull-off waypoint assignment, movement start, arrival/engage, and after waypoints are restored
  - When setting/clearing `OKS_Convoy_AAEngaging`
  - When revealing targets to AA units

## Speed control notes (forceSpeed/limitSpeed)
- `forceSpeed -1` releases forced speed so AI can drive up to `limitSpeed` and terrain constraints
- `limitSpeed 999` is used to temporarily uncap for pull-off/catch-up; real speed is still bound by engine/terrain/AI
- Catch-up booster toggles `forceSpeed -1` when behind; otherwise resets to base limit
- AA post-engagement unlock occurs, followed by reapplication of convoy logic after the AA catches up within dispersion of the convoy tail

## Known issues addressed
- Undefined `_leader` variable in CheckAndAdjustSpeeds (resolved via variable rename completion)
- AA vehicle staying unlocked at `forceSpeed -1` indefinitely: ensured reapply of convoy speed logic after dispersion catch-up
- AA chosen as last-spawned vehicle remained unlocked: changed to always follow the convoy tail after rejoin
- AA leader rejoin: AA always follows last vehicle (excluding itself)
- AA should remain unlocked until within dispersion of convoy tail: delayed speed logic reapply until spacing satisfied
- AA stopped immediately and cleared waypoints: corrected placement of `OKS_Convoy_AAEngaging` set/unset to precise points
- Reveal targets: ensure AA group knows about all current air targets at engagement time

## Recent edits (high level)
- `fn_Convoy_WaitUntilAirTarget.sqf`
  - Added many debug points and tags
  - Corrected `OKS_Convoy_AAEngaging` timing
  - Added reveal of all current air targets to AA asset and crew
  - Added checks and waitUntil guards for pull-off movement, on-road nudge, and spacing
- `fn_Convoy_Spawn.sqf`
  - Maintains call to `OKS_fnc_Convoy_CatchUpBooster`
  - Initializes speed variables and behavior; sets up monitors
- `fn_Convoy_CatchUpBooster.sqf`
  - Ensure this file exists; earlier it was accidentally removed but must remain because Spawn calls it
  - Includes debug each time `forceSpeed -1` is applied (both booster ON/OFF transitions)
- Removed deprecated: `airdefence/fn_Convoy_IsClearOfObstacles.sqf`

## Variables and per-vehicle state
- `OKS_Convoy_VehicleArray`: array of vehicles; stored on lead vehicle and refreshed
- `OKS_Convoy_LeadVehicle`: pointer to the lead for each vehicle
- `OKS_Convoy_PrimarySlotCount`, `OKS_Convoy_ReserveQueue`: reserve logic
- `OKS_LimitSpeedBase`: base speed in KPH for limitSpeed
- `OKS_Convoy_Dispersion`: spacing in meters
- `OKS_Convoy_AAEngaging`: flag during AA pull-off/engage window
- `OKS_Convoy_Stopped`: set to true on HOLD waypoint at end if not deleting

## Edge cases and guardrails
- If only one vehicle in convoy, AA logic still stores/restores WPs but spacing checks shortcut
- Handle destroyed/immobile vehicles: ignored in air target scans; leaders updated
- On-road pull-off fallback: when lateral candidates are blocked or sloped, tries opposite side, then forward, then enforces road distance
- Ensure `currentWaypoint` indexing is used for WP capture to avoid [0,0,0] from some Arma functions

## How to grep for critical events
- `forceSpeed -1` occurrences (AA + booster)
- `[CONVOY_AIR]` tag for air defense lifecycle
- `OKS_Convoy_AAEngaging` set/unset
- `Restored %1 waypoints` indicates engagement completion

## Potential next improvements
- Add configurable distances: pull-off ahead distance, lateral offsets, and nudge values to missionNamespace
- Add failsafe if AA cannot reach pull-off within N seconds: re-evaluate position or try other side
- Optional: dynamic re-selection of AA if the chosen AA becomes disabled en route
- Better throttle of debug to avoid log spam under many convoys

## Quick checklist for regressions
- AA sets engaging true exactly after pull-off WP is created
- AA unlocks speed only for pull-off and post-engagement catch-up
- AA reveals air targets at engagement start
- AA restores WPs, sets engaging false, rejoins tail, and follows last vehicle
- Followers re-evaluate leader on removal; spacing maintained

---
This file is meant to travel with the project to seed context for future development and debugging sessions.
