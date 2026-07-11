# Stealth Subsystem Architecture

This folder contains server-side stealth support behaviors that can be combined by mission logic.

## Goals

- Keep stealth gameplay logic reusable and mission-agnostic.
- Separate shared state initialization from behavior execution.
- Allow mission makers to opt-in per feature and per group.
- Use curated addon-managed audio profiles selected through CBA dropdowns (no custom user input required).

## Files

Core functions (functions/stealth/core):

- fn_Stealth_Init.sqf
  - Initializes shared state variables.
  - Builds side/profile audio maps from curated addon audio files.
- fn_Stealth_EnemyRadio.sqf
  - Emits radio chatter from enemy corpses near players.
  - Tracks active transmitting corpses and avoids overlap in a local area.
- fn_Stealth_EnemyTalk.sqf
  - Makes nearby enemy groups play calm patrol/sentry chatter sounds.
  - Triggers reaction yell + radio-help call once when group enters combat.
  - Supports chance-based trigger and min/max delay window.
- fn_Stealth_FindNearRadioMen.sqf
  - Finds nearby friendly units with radios for a unit/group.
- fn_Stealth_CallRadioHelp.sqf
  - Makes a radio-capable unit issue reinforcement call using side profile.
  - Uses cooldown to prevent radio spam.
- fn_Stealth_SentryAlert.sqf
  - Plays alert/yell reaction for sentry contact.
  - Optionally chains into radio-help call.

Sentry functions (functions/stealth/sentry):

- fn_Stealth_EnemySentry.sqf
  - Entry point for sentry behavior setup and alert loop.
- fn_Stealth_EnemySentry_CreateUnit.sqf
- fn_Stealth_EnemySentry_SetupUnit.sqf
- fn_Stealth_EnemySentry_Yell.sqf
- fn_Stealth_EnemySentry_IgnoreAir.sqf
- fn_Stealth_EnemySentry_Call_Hunters.sqf
- fn_Stealth_EnemySentry_Call_Hunters_Lambs.sqf

Tracking functions (functions/stealth/tracking):

- fn_Stealth_SendDetectionFlare.sqf
- fn_Stealth_InitiateHunterResponse.sqf
- fn_Stealth_FindNearestRadioAndCallForHelp.sqf
- fn_Stealth_Hunted.sqf
  - Drops temporary track markers behind a hunted group.
  - Stores tracks on group variable OKS_GroupTracks.
- fn_Stealth_Tracker.sqf
  - Makes tracker groups detect and follow generated tracks.
  - Rebuilds waypoints from selected track chain.

## Shared Data Contract

MissionNamespace / global values used by this subsystem:

- OKS_HuntedGroups (global array)
  - Group list registered by fn_Stealth_Hunted.
- OKS_Radios (global array)
  - Corpses that have participated in radio transmission.
- GOL_Stealth_RadioPatrolBySide (missionNamespace hashmap)
  - Used for patrol/dead-body radio ambience.
- GOL_Stealth_TalkCalmBySide (missionNamespace hashmap)
  - Used for calm chatter while patrolling/sentry idle.
- GOL_Stealth_TalkReactionBySide (missionNamespace hashmap)
  - Used for alerted reaction/yell calls.
- GOL_Stealth_RadioHelpBySide (missionNamespace hashmap)
  - Used when sentry/group issues reinforcement call.
Curated profile values:

- NONE
- ARAB
- RUSSIAN
- VIETNAMESE

Language behavior mapping:

- NONE
  - Excludes that side from auto-enabled stealth behavior.
  - No patrol/sentry auto-attach is performed for that faction.

- ARAB
  - Radio: Arab radio files
  - Talk: Arab talk files
  - Reaction: Arab yell files
- RUSSIAN
  - Radio: Russian radio files
  - Talk: Russian radio files (current asset limitation)
  - Reaction: Russian radio files (current asset limitation)
- VIETNAMESE
  - Radio: Vietnamese radio files
  - Talk: Vietnamese calm talk files
  - Reaction: Vietnamese reaction talk files

Per-side CBA settings:

- GOL_Stealth_Language_BLUFOR
- GOL_Stealth_Language_OPFOR
- GOL_Stealth_Language_INDEPENDENT
- GOL_Stealth_AutoEnablePatrols
- GOL_Stealth_AutoEnableStatics
- GOL_Stealth_RadioHelpCooldown

## Runtime Topology

1. PreInit registers CBA settings via XEH_preInit_stealth.sqf.
2. Server postInit calls fn_Stealth_Init when GOL_Stealth_Enabled is true.
3. Server postInit starts fn_Stealth_AutoEnable when GOL_Stealth_Enabled is true.
4. Auto-enable checks CBA settings and attaches behavior to patrol/static groups.
5. Hunted and tracker functions communicate through group track arrays and OKS_HuntedGroups.

## Suggested Mission Usage

```sqf
// Select side languages in Addon Options first.
// Then start corpse radio handling for enemy side.
[east] spawn OKS_fnc_Stealth_EnemyRadio;

// Start chatter for a specific enemy group.
[group someEnemyLeader] spawn OKS_fnc_Stealth_EnemyTalk;

// Mark a group as static and start sentry behavior (no hunter escalation).
private _g = group someSentryUnit;
_g setVariable ["GOL_IsStatic", true, true];
[_g, side _g, 0.35, true, false, 500, 500] spawn OKS_fnc_Stealth_EnemySentry;

// Manual sentry alert call (reaction yell + optional radio help).
[someSentryUnit, true, true, true] call OKS_fnc_Stealth_SentryAlert;

// Register hunted group and tracker group relationship.
[group huntedLead, triggerAreaObject] spawn OKS_fnc_Stealth_Hunted;
[group trackerLead] spawn OKS_fnc_Stealth_Tracker;
```

## Patrol and Sentry Test Quick Start

For addon-option driven testing:

- Enable GOL_Stealth_Enabled
- Enable GOL_Stealth_AutoEnablePatrols
- Enable GOL_Stealth_AutoEnableStatics

With these enabled, server postInit runs auto-detection:

- Patrol groups: non-static groups with waypoints -> fn_Stealth_EnemyTalk
- Static groups: groups with GOL_IsStatic or GOL_isStatic -> fn_Stealth_EnemySentry

## Extension Points

- Add per-faction sound pools:
  - Replace global sound arrays with map-like missionNamespace structures keyed by side/faction.
- Add scent/terrain modifiers:
  - Alter track lifetime and spacing based on surface type, weather, or time of day.
- Add detection skill modifiers:
  - Multiply tracker detection chance by AI skill and unit equipment.
- Add event hooks:
  - Broadcast custom mission events when tracks are created/detected.

## Audio Layout

- Curated audio packs are in functions/stealth/audio:
  - Arab
  - Russian
  - Vietnamese
- Profiles in fn_Stealth_Init.sqf are built so every current .ogg in the audio tree is included by at least one profile.

## Guardrails

- All functions are server-oriented and should be spawned/called server-side.
- Sound playback requires valid full paths available to all clients.
- Keep shared variable names stable to avoid cross-mission breakage.

## Duplicates And Archived Files

- Legacy archived and duplicate stealth files were removed.
- Active addon behavior uses the modular fn_Stealth_* functions under functions/stealth/core, functions/stealth/sentry, and functions/stealth/tracking.
