# Stealth Subsystem Architecture And Function Guide

This document explains how stealth code flows at runtime, what each function does, what parameters matter, and what mission editors should watch out for.

## 1) Runtime Flow (High Level)

1. `XEH_PreInit/XEH_preInit_stealth.sqf` registers all CBA settings for stealth, visibility, language, and tracking.
2. `XEH_PostInit/XEH_postInit_Server.sqf` checks `GOL_Stealth_Enabled` and starts:
   - `[] call OKS_fnc_Stealth_Init`
   - `[] spawn OKS_fnc_Stealth_AutoEnable`
3. `XEH_PostInit/XEH_postInit_Global.sqf` starts player-local visibility logic on clients:
   - `[] spawn OKS_fnc_Stealth_PlayerVisibility`
4. Auto-enable tags existing and newly spawned groups as patrol-talk or sentry behavior, based on group state + CBA options.
5. Optional mission calls can add corpse radio chatter, hunted track generation, and tracker pursuit.

## 2) Shared State And Contracts

Global/runtime variables used by multiple functions:

- `OKS_HuntedGroups` (global array)
  - Populated by `OKS_fnc_Stealth_Hunted`
  - Consumed by `OKS_fnc_Stealth_Tracker`
- `OKS_Radios` (global array)
  - Corpses currently/previously used by corpse-radio loops
- `GOL_Stealth_RadioPatrolBySide` (missionNamespace hashmap)
- `GOL_Stealth_TalkCalmBySide` (missionNamespace hashmap)
- `GOL_Stealth_TalkReactionBySide` (missionNamespace hashmap)
- `GOL_Stealth_RadioHelpBySide` (missionNamespace hashmap)

Language profile values:

- `NONE`
- `ARAB`
- `RUSSIAN`
- `VIETNAMESE`

Important side behavior:

- If side language is `NONE`, auto-enable skips groups on that side.
- Russian currently reuses radio pool for talk/reaction.

## 3) Core Functions

### `OKS_fnc_Stealth_Init`

Purpose:
- One-time server bootstrap for stealth shared arrays and side->audio maps.

Key behavior:
- Creates `OKS_HuntedGroups` and `OKS_Radios` if missing.
- Builds curated audio path arrays.
- Resolves side language from new settings (`GOL_Stealth_Language_*`) with fallback to old profile vars.

Returns:
- `true` on server, `false` when not server.

### `OKS_fnc_Stealth_AutoEnable`

Purpose:
- Event-driven auto attachment of stealth behavior to AI groups.

Key behavior:
- Guarded by `OKS_Stealth_AutoEnable_Started` so it starts only once.
- Runs one full sweep over `allGroups`.
- Adds CBA class init handler for new `CAManBase` units and evaluates their group after delay.

What it attaches:
- Patrol groups (non-static, has waypoints): `OKS_fnc_Stealth_EnemyTalk`
- Static groups (`GOL_IsStatic`/`GOL_isStatic`/`OKS_Stealth_SentryPriority`): `OKS_fnc_Stealth_EnemySentry`

### `OKS_fnc_Stealth_PlayerVisibility`

Purpose:
- Client-local continuous update of player `camouflageCoef` and `audibleCoef`.

Key parameters/settings that drive result:
- `GOL_Stealth_PlayerVisibilityInterval`
- Darkness camo settings: `GOL_Stealth_PlayerCamoPitchBlack/VeryDark/Dark/Dim/Lit`
- Darkness audible settings: `GOL_Stealth_PlayerAudiblePitchBlack/VeryDark/Dark/Dim/Lit`
- Stance multipliers: `GOL_Stealth_PlayerCamoMulProne/Crouch/Stand`
- Vegetation concealment settings
- Weather audible settings
- `GOL_Stealth_PlayerAbsoluteMin`

Important details:
- Requests server lighting via `OKS_fnc_Stealth_GetLightingServer` to avoid NVG contamination on dedicated.
- Uses local fallback `getLightingAt player` when server value not yet cached.
- Visible flashlight multiplies camo strongly; IR-only illuminators are excluded from visible-light penalty logic.

### `OKS_fnc_Stealth_GetLightingServer` and `OKS_fnc_Stealth_ReceiveLighting`

Purpose:
- Remote lighting request/response pair for player visibility logic.

Flow:
- Client calls `GetLightingServer` on server with `[player, clientOwner]`.
- Server responds to that owner with lighting array via `ReceiveLighting`.

### `OKS_fnc_Stealth_EnemyRadio`

Purpose:
- Dead enemy radio chatter near players when enemy side has awareness.

Params:
1. Side (`east` default)
2. Trigger distance to players (default `15`)
3. Radio overlap suppression range (default `30`)
4. Cooldown between transmissions (default `60`)
5. Corpse cleanup distance from all players (default `300`)
6. Enemy knowledge threshold (default `2.5`)

Key behavior:
- Starts per-corpse loop when qualifying dead unit appears.
- Ensures only one transmitting corpse in local area.
- Deletes corpse if nobody is nearby for cleanup distance.

### `OKS_fnc_Stealth_EnemyTalk`

Purpose:
- Group chatter loop when players are close and group is not in combat.

Params:
1. Group
2. Player distance threshold (`125`)
3. Chance to play line (`1`)
4. Min/max delay array (`[9,14]`)
5. Loop poll delay (`5`)
6. Allow chatter for static groups (`true`)

Special behavior:
- On first combat transition, triggers `OKS_fnc_Stealth_SentryAlert` once (`OKS_Stealth_ReactionFired`).

### `OKS_fnc_Stealth_FindNearRadioMen`

Purpose:
- Find nearby friendly radio-capable units.

Input:
- Object or Group.

Return:
- `[hasRadioNearby, radioUnitsArray]`

Radio rule:
- Uses variable `GOL_HasRadio` and awake/alive checks.

### `OKS_fnc_Stealth_CallRadioHelp`

Purpose:
- Play side-profiled radio-help line from caller or nearest nearby radio man.

Params:
1. Caller object
2. Require radio presence (`true`)

Cooldown:
- `GOL_Stealth_RadioHelpCooldown`
- Stored per radio unit as `OKS_Stealth_RadioCalledAt`

### `OKS_fnc_Stealth_SentryAlert`

Purpose:
- Play reaction yell, optionally force combat mode, optionally radio help.

Params:
1. Unit
2. Call radio help (`true`)
3. Require radio to call (`true`)
4. Set combat behavior (`true`)

## 4) Sentry Functions

### `OKS_fnc_Stealth_EnemySentry`

Primary entry point for sentry behavior.

Params:
1. Unit/Object position/Group
2. Side
3. Chance to spawn with radio gear (`0.35`)
4. Require radio to trigger hunt (`true`)
5. Should nearby units be set to hunt (`true`)
6. Nearby hunter range (`500`)
7. Hunt range (`500`)
8. Variable name (currently unused by implementation)

Flow:
- Normalizes input through `EnemySentry_CreateUnit`
- Applies `EnemySentry_SetupUnit`
- Waits for player detection (`knowsAbout > 2`)
- Plays yell and optionally triggers radio->hunter escalation

### `OKS_fnc_Stealth_EnemySentry_CreateUnit`

Purpose:
- Accepts object/array/group input and returns actual sentry unit array.
- Can create a fresh sentry at position/object anchor and delete non-man anchor objects.

Key behavior:
- Marks leader classes with `GOL_HasRadio = true`.
- For group input also starts `EnemySentry_IgnoreAir`.

### `OKS_fnc_Stealth_EnemySentry_SetupUnit`

Purpose:
- Convert unit to static sentry profile.

Actions:
- Splits unit into single-unit group if needed.
- Marks group static/sentry vars.
- Starts chatter via `EnemyTalk`.
- Tweaks skills (`spotDistance`, `spotTime`, etc.) and disables parts of AI autonomy.
- Adds `Fired` and `Suppressed` handlers to force reaction/combat.

### `OKS_fnc_Stealth_EnemySentry_Yell`

Purpose:
- Plays one of `yell_1..yell_9` using `say3D`, then sets combat behavior.

### `OKS_fnc_Stealth_EnemySentry_IgnoreAir`

Purpose:
- Prevent static sentry groups from sticking to pilot/jet targets in air.

### `OKS_fnc_Stealth_EnemySentry_Call_Hunters`

Purpose:
- Non-LAMBS fallback hunt tasking.

Actions:
- Flags `LAMBS_HUNTING`, clears waypoints, sets detection flare.
- Sends group to detected player then starts local patrol around last detected area.

### `OKS_fnc_Stealth_EnemySentry_Call_Hunters_Lambs`

Purpose:
- LAMBS-based hunt tasking path.

Actions:
- Calls `lambs_wp_fnc_taskHunt` and switches group behavior after short delay.

## 5) Tracking Functions

### `OKS_fnc_Stealth_Hunted`

Purpose:
- Periodically drops temporary track objects behind a hunted group.

Params:
1. Hunted group
2. Optional trigger area object limiting track creation

Important dependencies:
- Requires marker `respawn_<side>` as origin safety check. If missing, function exits.

Track settings:
- `GOL_Stealth_TrackLifetime`
- `GOL_Stealth_TrackSpacing`
- `GOL_Stealth_TrackClass`
- `GOL_Stealth_TrackDebugClass`
- `GOL_Stealth_DebugTrackObject`

### `OKS_fnc_Stealth_Tracker`

Purpose:
- Makes tracker groups search and follow track chains created by hunted groups.

Params:
1. Tracker group
2. Activation range (`500`)
3. Detection radius to tracks (`10`)
4. Chance to identify nearby track (`0.25`)
5. Loop delay (`5`)

Behavior:
- Aggregates tracks from all `OKS_HuntedGroups`.
- On successful track find, rebuilds group waypoints along chosen track path.
- Signals contact with flare/sound.

### `OKS_fnc_Stealth_FindNearestRadioAndCallForHelp`

Purpose:
- Plays radio call from nearby radio-capable friend and triggers hunter response.

### `OKS_fnc_Stealth_InitiateHunterResponse`

Purpose:
- Chooses LAMBS or fallback hunt strategy based on function availability.

### `OKS_fnc_Stealth_SendDetectionFlare`

Purpose:
- Visual/audio cue when AI has started active response.

## 6) CBA Settings That Matter Most For Mission Feel

Global switches:

- `GOL_Stealth_Enabled`
- `GOL_Stealth_AutoEnablePatrols`
- `GOL_Stealth_AutoEnableStatics`

Language and voice identity:

- `GOL_Stealth_Language_BLUFOR`
- `GOL_Stealth_Language_OPFOR`
- `GOL_Stealth_Language_INDEPENDENT`
- `GOL_Stealth_RadioHelpCooldown`

Player stealth tuning:

- All `GOL_Stealth_PlayerCamo*` and `GOL_Stealth_PlayerAudible*`
- `GOL_Stealth_PlayerVisibilityInterval`
- `GOL_Stealth_Vegetation*`
- `GOL_Stealth_PlayerAbsoluteMin`

Tracker pressure:

- `GOL_Stealth_TrackLifetime`
- `GOL_Stealth_TrackSpacing`
- `GOL_Stealth_TrackClass`

## 7) AI Caveats And Editor Notes

1. Server/client split is strict.
   - Most stealth AI functions are server-side.
   - `PlayerVisibility` is client-only and should not be manually run on server.

2. Lighting accuracy caveat.
   - NVG/IR-safe lighting is accurate on dedicated server flow.
   - In SP or host-listen test, server and player share context, so IR edge cases can differ.

3. Static detection for auto-enable is variable-driven.
   - Use group vars `GOL_IsStatic` or `GOL_isStatic` (or set `OKS_Stealth_SentryPriority`).
   - Patrol auto-attach also requires group waypoints.

4. Legacy + new paths coexist.
   - New system uses side-profiled file-path playback (`playSound3D`).
   - Some sentry/hunter helpers still use legacy named sounds (`say3D` with `yell_*`, `radio_*`). Ensure sound classes exist.

5. Radio ownership requirement is explicit.
   - Help calls rely on `GOL_HasRadio` and awake/alive checks.
   - If nobody in chain has radio, escalation may stop.

6. `FindNearestRadioAndCallForHelp` name vs behavior.
   - Function sorts by nearest, but currently selects random from sorted list.
   - In practice, caller is not guaranteed to be the nearest radio unit.

7. `Hunted` requires side respawn marker.
   - Missing `respawn_west/east/independent` marker prevents track creation.

8. Optional dependency behavior.
   - If LAMBS hunt function exists, hunter response uses LAMBS path.
   - Otherwise fallback hunter routine is used.

## 8) Practical Setup Checklist For Editors

1. Enable `GOL_Stealth_Enabled`.
2. Choose side languages (not `NONE` for sides you want active).
3. Enable auto patrol/static if you want automatic attachment.
4. Mark static groups with `GOL_IsStatic = true` where needed.
5. For hunt gameplay:
   - Start `OKS_fnc_Stealth_Hunted` on hunted group(s)
   - Start `OKS_fnc_Stealth_Tracker` on tracker group(s)
6. Ensure respawn side markers exist for hunted logic.
7. Validate required sound definitions for legacy sentry yell/radio named sounds if those paths are used in mission.

## 9) Minimal Example Calls

```sqf
// Enemy corpse radio chatter (server)
[east] spawn OKS_fnc_Stealth_EnemyRadio;

// Manual patrol chatter for one group (server)
[group someEnemyLeader] spawn OKS_fnc_Stealth_EnemyTalk;

// Manual sentry setup for one static group (server)
private _g = group someSentryUnit;
_g setVariable ["GOL_IsStatic", true, true];
[_g, side _g, 0.35, true, true, 500, 500] spawn OKS_fnc_Stealth_EnemySentry;

// Hunted + tracker coupling (server)
[group huntedLead, triggerAreaObject] spawn OKS_fnc_Stealth_Hunted;
[group trackerLead, 500, 10, 0.25, 5] spawn OKS_fnc_Stealth_Tracker;
```
