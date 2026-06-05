# HuntBase System — Full Technical Documentation

## Overview

The **HuntBase** system is a server-side AI reinforcement spawner for Arma 3. It simulates a "living" enemy base that detects nearby players, spawns waves of infantry or vehicles, and directs them to hunt players within a defined zone. The system persists across multiple waves and respects a wide set of mission-configurable global variables for tuning force sizes, response times, and AI skill.

The entry point is `OKS_fnc_HuntBase`. All logic runs on the server only.

---

## Script Entry Point

### `fn_HuntBase.sqf` — `OKS_fnc_HuntBase`

**Call signature:**
```sqf
[Base, SpawnPos, HuntZone, Waves, RespawnDelay, Side, Soldiers, RefreshRate, ShouldDeployFlare, WaypointBehaviour] spawn OKS_fnc_HuntBase;
```

**Execution context:** Server only (`if (!isServer) exitWith {false}`).

---

### Parameters

| Index | Name | Type | Default | Description |
|-------|------|------|---------|-------------|
| 0 | `_Base` | Object | `ObjNull` | The "base" object. When destroyed, no more waves will spawn. |
| 1 | `_SpawnPos` | Object | `ObjNull` | Editor object marking the spawn point and spawn direction. |
| 2 | `_HuntZone` | Object (Trigger) | `ObjNull` | Trigger defining the area where players are hunted. |
| 3 | `_Waves` | Number | `0` | Maximum number of waves to spawn (multiplied by `GOL_ForceMultiplier` at runtime). |
| 4 | `_RespawnDelay` | Number | `0` | Time in seconds between wave spawns. Scaled by `GOL_ResponseMultiplier`. |
| 5 | `_Side` | Side | `East` | Faction side of spawned AI. |
| 6 | `_Soldiers` | Number / String / Array | `0` | Infantry count (scalar), vehicle classname (string), or array of vehicle classnames (random pick). |
| 7 | `_RefreshRate` | Number | `0` | How often (seconds) the script checks for detected players. Scaled by `GOL_ResponseMultiplier`. |
| 8 | `_ShouldDeployFlare` | Boolean | `true` | Whether to fire an illumination flare at night when players are detected. |
| 9 | `_WaypointBehaviour` | String | `nil` | Waypoint behaviour string passed to `OKS_fnc_HuntRun`. Defaults to `"AWARE"` for infantry, `"SAFE"` for vehicles if not set. |

---

## Script Flow

```
START
│
├─ [Server check] — exit if not server
│
├─ sleep 5 (startup delay)
│
├─ [OKS_fnc_Hunt_Settings] — load faction-specific AI classes and settings
│
├─ Read global multipliers and config vars from missionNamespace
│
├─ Create internal trigger (300×300 m) around SpawnPos for supplemental player detection
│
├─ Create hidden eye-check object above SpawnPos (for line-of-sight check)
│
├─ Determine default _WaypointBehaviour if not provided
│
└─ MAIN LOOP: while { alive _Base AND remaining waves > 0 }
    │
    ├─ Refresh multipliers / config from missionNamespace each iteration
    │
    ├─ Determine _KnowsAboutValue threshold (day: 3.6 / night: 3.975)
    │
    ├─ [Player detection check]
    │   Count players in _HuntZone where side knowsAbout > threshold
    │   Also checks secondary side for INDEPENDENT faction
    │
    ├─ IF players detected:
    │   ├─ Wait _DetectDelay seconds (randomised refresh rate × response multiplier)
    │   │
    │   ├─ [Line-of-sight / proximity check]
    │   │   Uses checkVisibility from eye-check object vs all players
    │   │   Also checks internal trigger list
    │   │
    │   ├─ IF players confirmed:
    │   │   │
    │   │   ├─ Deploy flare if night and _ShouldDeployFlare == true
    │   │   │
    │   │   ├─ [INFANTRY PATH] (_Soldiers is SCALAR)
    │   │   │   ├─ Scale soldier count by GOL_ForceMultiplier
    │   │   │   ├─ Decrement _Waves
    │   │   │   ├─ Check GOL_Hunt_MaxCount against alive tracked units
    │   │   │   ├─ If under cap: createGroup, spawn soldiers at _SpawnPos
    │   │   │   │   ├─ First unit gets rank SERGEANT (becomes leader)
    │   │   │   │   ├─ Remaining units get rank PRIVATE
    │   │   │   │   ├─ [OKS_fnc_SetSkill] — apply skill profile to group
    │   │   │   │   ├─ AllowFleeing 0
    │   │   │   │   └─ [OKS_fnc_HuntRun] — start hunting behaviour
    │   │   │   └─ Track all spawned units in GOL_CurrentHuntCount
    │   │   │
    │   │   └─ [VEHICLE PATH] (_Soldiers is STRING or ARRAY)
    │   │       ├─ Check GOL_Hunt_MaxCount against alive tracked units
    │   │       ├─ Decrement _Waves
    │   │       ├─ Wait until spawn area is clear of vehicles (nearEntities, 15 m)
    │   │       ├─ createVehicle at _SpawnPos (random pick if ARRAY)
    │   │       ├─ Set vehicle direction to match _SpawnPos facing
    │   │       │
    │   │       ├─ IF vehicle has no gunner positions (transport):
    │   │       │   ├─ [OKS_fnc_AddVehicleCrew] — fill driver/crew
    │   │       │   ├─ Add cargo infantry (up to _MaxCargoSeats, capped by global)
    │   │       │   ├─ First cargo unit is SERGEANT and set as group leader
    │   │       │   └─ [OKS_fnc_SetSkill], AllowFleeing 0
    │   │       │
    │   │       └─ IF vehicle has gunner positions (combat vehicle):
    │   │           └─ [OKS_fnc_AddVehicleCrew] — fill driver/crew only
    │   │
    │   │       After vehicle spawn:
    │   │       ├─ sleep 5
    │   │       ├─ If group has > 1 unit: [OKS_fnc_HuntRun]
    │   │       └─ If only driver: delete vehicle (not a useful combat unit)
    │   │
    │   │   sleep 5, then sleep (_RespawnDelay × _ResponseMultiplier)
    │   │
    │   └─ IF players NOT confirmed (left area between detect delay):
    │       Exit inner check block silently
    │
    └─ IF no players detected:
        sleep (_RefreshRate × _ResponseMultiplier)

END CONDITIONS:
├─ _Base destroyed → delete _Base, exit (logs "[HUNT] Base Destroyed")
└─ _Waves == 0 → delete _Base, exit (logs "[HUNT] Waves Depleted")
```

---

## Global Variables

These variables are read from `missionNamespace` and can be set from anywhere in the mission to tune the system's behaviour at runtime.

| Variable | Default | Type | Description |
|----------|---------|------|-------------|
| `GOL_Hunt_Debug` | `false` | Boolean | Enables debug logging via `OKS_fnc_LogDebug`. |
| `GOL_ForceMultiplier` | `1` | Number | Multiplies the total wave count and infantry squad size. Values > 1 increase force size. |
| `GOL_ResponseMultiplier` | `1` | Number | Multiplies all timing delays (refresh rate, respawn delay, detect delay). Values < 1 make the enemy respond faster. |
| `GOL_Hunt_MaxCount` | `1` (effectively `40` in practice) | Number | Maximum number of simultaneously alive tracked hunt units. Spawn is blocked if this cap is reached. |
| `GOL_CurrentHuntCount` | `[]` | Array | Shared array tracking all AI units spawned by any active HuntBase. Used to enforce the MaxCount cap globally across all bases. |
| `GOL_Hunt_MinDistance` | `100` | Number | Minimum distance from a player that AI will spawn at (used inside `OKS_fnc_Hunt_Settings`). |
| `GOL_UpdateFreq` | `60` | Number | Default update frequency (seconds) for hunting AI waypoints (used in `OKS_fnc_Hunt_Settings`). |
| `GOL_MaxCargoSeats` | `6` | Number | Maximum cargo infantry per transport vehicle. |
| `GOL_Leaders_BLUFOR` | `"B_Soldier_TL_F,..."` | String | Comma-separated leader classnames for BLUFOR faction. |
| `GOL_Units_BLUFOR` | `"B_Soldier_LAT_F,..."` | String | Comma-separated unit classnames for BLUFOR faction. |
| `GOL_Leaders_OPFOR` | `"O_Soldier_TL_F,..."` | String | Comma-separated leader classnames for OPFOR faction. |
| `GOL_Units_OPFOR` | `"O_Soldier_LAT_F,..."` | String | Comma-separated unit classnames for OPFOR faction. |
| `GOL_Leaders_INDEPENDENT` | `"I_Soldier_TL_F,..."` | String | Comma-separated leader classnames for INDEPENDENT faction. |
| `GOL_Units_INDEPENDENT` | `"I_Soldier_LAT_F,..."` | String | Comma-separated unit classnames for INDEPENDENT faction. |
| `GOL_Core_Debug` | `false` | Boolean | Master debug flag used by `OKS_fnc_LogDebug` to gate all debug output. |
| `NEKY_Hunt_Disabled` | `false` | Boolean | Set on a trigger/zone object to disable spawning for that specific zone. |

---

## Detection Logic

### Day/Night Threshold

Detection sensitivity changes with time of day:

| Time | `_KnowsAboutValue` | Effect |
|------|--------------------|--------|
| 04:30–19:30 (day) | `3.6` | Players are detected at slightly lower awareness |
| Outside that range (night) | `3.975` | Players must be much more exposed to trigger a spawn |

### Primary Detection (`_HuntZone`)

Counts players inside `_HuntZone` where:
- The faction's `knowsAbout` value for the player (or their vehicle) exceeds the threshold.
- The player is touching the ground (not in a low-flying aircraft).
- For INDEPENDENT faction, also checks the secondary side (`_ThirdSide = east`) if they are enemies.

### Confirmation Check (after detect delay)

After waiting the randomised detect delay, the script performs a stricter double-confirmation:
1. **Line-of-sight check** — `checkVisibility` from `_EyeCheck` (a hidden object 3 m above the spawn) against each player's `eyePos`. A result ≥ 0.6 counts as visible.
2. **Proximity trigger** — Players inside the small internal `_Trigger` (300 × 300 m around the spawn).

If neither condition is met, the script re-checks `knowsAbout` and only proceeds if awareness is still above the threshold.

---

## Supporting Functions

### `OKS_fnc_Hunt_Settings`

**File:** `fn_Hunt_Settings.sqf`  
**Call:** `[_Side] call OKS_fnc_Hunt_Settings`  
**Returns:** Array — `[MinDistance, UpdateFreq, SkillVariables, Skill, Leaders, Units, MaxCargoSeats, HeliClass, PilotClasses, CrewClasses, ForceRespawnMultiplier]`

Reads mission namespace variables to build the full settings block for a given side. Provides side-specific unit/leader classname arrays (BLUFOR, OPFOR, INDEPENDENT), default helicopter classes, AI skill values, and cargo seat limits. The `ForceRespawnMultiplier` (hardcoded `150`) is used by `OKS_fnc_Hunting` to calculate the force-respawn distance for hunting groups.

---

### `OKS_fnc_HuntRun`

**File:** `fn_HuntRun.sqf`  
**Call:** `[Group, nil, HuntZone, 0, RefreshRate, 0, {}, WaypointBehaviour] spawn OKS_fnc_HuntRun`  
**Execution context:** Server or Headless Client.

The waypoint orchestrator for an already-spawned group. Performs:
1. Calls `OKS_fnc_ScanZone` to find players inside the zone.
2. Calls `OKS_fnc_SelectPlayer` to pick a target and find a safe spawn position at `_Distance` from that player.
3. Handles the case where no suitable position was found by re-running itself.
4. Calls `OKS_fnc_Hunting` to start the live pursuit loop.
5. Executes any `_Code` callback with `[Group, Player, Zone]`.

Respects the `NEKY_Hunt_Disabled` variable on the zone object to abort early.

---

### `OKS_fnc_Hunting`

**File:** `Functions/fn_Hunting.sqf`  
**Call:** `[Group, Player, Zone, UpdateFreq, Distance, Number, Code, ForceRespawnMultiplier, Repeat, WaypointBehaviour] spawn OKS_fnc_Hunting`

The live pursuit AI loop. Runs for the lifetime of a single hunting group. Behaviour:

- Sets a group-level flag `NEKY_Hunt_GroupEnabled` to prevent duplicate runs on the same group.
- Deletes existing waypoints and adds two new ones:
  - **WP1** — ~150 m short of the player's position in the direction of the group leader. Behaviour: `AWARE` (or `_WaypointBehaviour` if provided), `SAFE` if in a vehicle.
  - **WP2** — At the player's last known position (±75 m). Behaviour: `COMBAT`.
- **Update loop** — Runs every `_UpdateFreq` seconds:
  - Moves WP1 and WP2 if the prey has moved more than 100 m from WP2.
  - Reveals the player's group to the hunting AI (`_Grp Reveal`) at varying knowledge levels based on distance (< 300 m = knowledge 1.5; ≥ 300 m = 0.1 for infantry).
  - Sets group formation to `WEDGE`.
- **Loop exit conditions** (any one terminates hunting):
  - Player is dead.
  - All AI in the group are dead.
  - Player leaves the zone.
  - Zone is disabled (`NEKY_Hunt_Disabled`).
  - Player is airborne (altitude ≥ 6 m ATL).
  - No players are within `_ForceRespawnDistance` of the group leader (prevents indefinite pursuit of unreachable players).

Sets `NEKY_Hunt_GroupEnabled` back to `false` on exit.

---

### `OKS_fnc_ScanZone`

**File:** `Functions/fn_ScanZone.sqf`  
**Call:** `[Zone] call OKS_fnc_ScanZone`  
**Returns:** Array of players inside the zone.

Polls the zone's `list` every 10 seconds until at least one alive, grounded player is found. Filters for: `isPlayer`, `alive`, and ground altitude < 6 m ATL.

---

### `OKS_fnc_SelectPlayer`

**File:** `Functions/fn_SelectPlayer.sqf`  
**Call:** `[Players, Zone, Distance] call OKS_fnc_SelectPlayer`  
**Returns:** `[TooCloseCount, SpawnPosition, SelectedPlayer]`

Picks a random player from the supplied list and attempts to find a valid spawn position at `_Distance` metres from them (random bearing). Checks up to 15 candidate positions, skipping any that are on water or within `_Distance` of any player. Returns the last candidate tested regardless (caller handles retry logic).

---

### `OKS_fnc_HuntSpawn`

**File:** `Functions/fn_HuntSpawn.sqf`  
**Call:** `[Side, NumberOfUnits, Leaders, Units, Position] spawn OKS_fnc_Hunt_Spawn`  
**Returns:** AI Group.

Utility spawner used by `OKS_fnc_HuntRun` when creating a new group from scratch (when `_Side` is passed as a side rather than an existing group). Creates one leader (rank SERGEANT) and fills the rest of the group with private-rank soldiers. Applies FRAMEWORK gear if `FRAMEWORK_Gear_Run` is available. Sets `AllowFleeing 0`.

> **Note:** `fn_HuntBase.sqf` creates groups inline rather than calling this function directly. `OKS_fnc_HuntSpawn` is used by the standalone `OKS_fnc_HuntRun` flow when a fresh group is needed.

---

### `OKS_fnc_SetSkill`

**File:** `Functions/fn_SetSkill.sqf`  
**Call:** `[Group, SkillVariables, Skill] spawn OKS_fnc_SetSkill`

Iterates over every unit in the group and calls `GW_SetDifficulty_fnc_setSkill` on each via `remoteExec` (machine 0 = server/HC). Skill values are sourced from `OKS_fnc_Hunt_Settings`:

| Variable | Default Value |
|----------|--------------|
| `aimingspeed` | 0.4 |
| `aimingaccuracy` | 0.35 |
| `aimingshake` | 0.35 |
| `spotdistance` | 0.5 |
| `spottime` | 0.6 |
| `commanding` | 0.8 |
| `general` | 0.7 |

---

### `OKS_fnc_AddVehicleCrew`

**File:** `functions/enemy/fn_AddVehicleCrew.sqf`  
**Call:** `[Vehicle, Side] call OKS_fnc_AddVehicleCrew`  
**Returns:** AI Group.

Creates and fills the crew positions of a vehicle for a given faction side. Uses `OKS_fnc_Dynamic_Settings` to get unit arrays. For air vehicles it selects pilot/helicrew classnames automatically. Supports optional parameters for cargo slots, headless client blacklisting, and adding a cargo commander.

---

### `OKS_fnc_LogDebug`

**File:** `functions/logic/fn_LogDebug.sqf`  
**Call:** `"message" call OKS_fnc_LogDebug` or `["message", echoToChat, silent, force] call OKS_fnc_LogDebug`

Conditional debug logger. Only outputs if `GOL_Core_Debug` is `true` in `missionNamespace` (or `_force` is `true`). Writes to `diag_log` with a prefix identifying the machine/client. Can also broadcast to system chat (controlled by `_echoToChat`). Throughout `fn_HuntBase.sqf` the local `_Debug` variable (`GOL_Hunt_Debug`) gates whether these calls are made at all, providing a second, hunt-specific debug toggle.

---

## Conditions Summary

| Condition | Effect |
|-----------|--------|
| `!isServer` | Script exits immediately on any non-server machine. |
| `!alive _Base` | Main loop exits; base object is deleted. |
| `(_Waves * _ForceMultiplier) == 0` | Main loop exits; base object is deleted. |
| `_Side knowsAbout _Player > _KnowsAboutValue` | Triggers detection and starts the spawn sequence. |
| `checkVisibility >= 0.6` | Confirms player is visible from spawn before spawning. |
| `players in _Trigger` | Alternate confirmation — players are within 300 m of spawn. |
| `_AliveNumber >= _MaxCount` | Blocks spawning of new units until existing ones die. |
| `nearEntities ["LandVehicle", 15] isEqualTo []` | Blocks vehicle spawn until the pad is clear. |
| `_vehicle emptyPositions "gunner" == 0` | Routes vehicle to transport logic (adds cargo infantry). |
| `count units _Group > 1` | Only sends vehicle group hunting if more than just the driver is alive. |
| `NEKY_Hunt_Disabled == true` (on zone) | Prevents `OKS_fnc_HuntRun` / `OKS_fnc_Hunting` from running for that zone. |
| `(getPosATL _Player select 2) < 6` | Player must be on the ground to count as a valid target. |

---

## Known Issues / Notes

- `_ResponseMultiplier` is declared twice in the `Private` block at the top of the main loop body — the second declaration shadows the first (no functional impact, just redundant code).
- The transport cargo section uses `"CurrentHuntCount"` (missing `GOL_` prefix) as the variable name when pushing units to `missionNamespace`, while the rest of the script uses `"GOL_CurrentHuntCount"`. This is a bug that can cause tracked unit counts to drift.
- `fn_Repeat.sqf` exists in the hunt Functions folder but is empty — it appears to be a stub.
- The eye-check object (`_EyeCheck`) is created but never deleted when the script exits. It persists on the map for the duration of the mission.
- `BIS_fnc_crewCount` is called with `"TypeOf _Vehicle"` (a string literal) instead of `TypeOf _Vehicle` (expression) for the driver-only seat count — this is a latent bug that causes the cargo seat calculation to be inaccurate.
