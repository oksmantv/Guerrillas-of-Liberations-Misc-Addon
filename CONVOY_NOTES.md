# Convoy: implementation summary and quick reference

This document summarizes the convoy mechanics and all changes from this session so you (or Copilot) can quickly regain context if chat history is unavailable.

## Core features and changes

- Herringbone parking
  - Lead vehicle remains on-road, forward-facing (no alternating pull-off for the lead).
  - Following vehicles alternate left/right off-road with obstacle-aware side flipping and ATL placement.
  - Road-occupancy (clutter cutters) enforces minimum spacing along the road.
  - "Last road" memory keeps selection progressing along the same road segment so rear vehicles don’t jump to far-forward nodes.
  - Default minimum spacing set to 35 m (tweakable via CBA setting below).

- Air-defense (AA) interception handler
  - Detection: uses group leaders’ known targets + proximity fallback; excludes parachutes; ignores destroyed/immobile air (ignoreTarget/forgetTarget) to avoid re-triggering.
  - Selection: prefers dedicated AA (Tigris/Cheetah, radar/sensor components), is ammo-aware, and avoids tanks where possible.
  - Pull-off site: starts ahead + lateral; must be clear, off-road, reasonably flat (slope limited), and at least 20 m from the nearest road centerline.
  - Transit to pull-off: no firing while moving (TARGET/AUTOTARGET/AUTOCOMBAT disabled and ROE BLUE); AA speed is unlocked en route so it clears the lane quickly.
  - Engagement: on site, re-enable targeting and switch to COMBAT/RED; AA holds position while convoy continues.
  - Restore/rejoin:
    - Fixed waypoint restore (correct order and positions; avoids [0,0,0]).
    - Waits for clear sky and a minimum merge gap (or timeout), then ramps speed gradually before handing control back to the convoy speed controller.
    - Handler loops so it can respond to multiple air contacts over time.

- Convoy movement robustness
  - Catch-up booster: if any vehicle falls behind its leader by more than ~1.5 × dispersion, it temporarily runs uncapped until back within dispersion range, then resumes normal spacing control.

## CBA settings (Addon Options → "OKS Convoy")

The following settings are registered and mirrored into missionNamespace so scripts read the latest values at runtime:

- GOL_Convoy_HerringboneSpacingMin (m)
  - Default 35. Minimum spacing along road centerline between herringbone slots.
- GOL_Convoy_PullOffMaxSlopeDeg (deg)
  - Default 15. Max terrain slope for AA pull-off positions.
- GOL_Convoy_PullOffMinRoadDist (m)
  - Default 20. Minimum distance from nearest road centerline for AA pull-off positions.
- GOL_Convoy_MergeGapMin (m)
  - Default 80. Minimum distance to previous tail before AA accelerates to rejoin.
- GOL_Convoy_MergeGapTimeout (s)
  - Default 30. Grace timeout to merge even if the gap is smaller.
- GOL_Convoy_SpeedRampStepKph (kph)
  - Default 10. Speed increase per step during AA rejoin ramp.
- GOL_Convoy_SpeedRampInterval (s)
  - Default 1. Time between speed steps during AA rejoin ramp.

Note: These require CBA to be loaded. If CBA isn’t present, scripts use sensible defaults.

## Files updated (addon)

- functions/spawn/convoy/fn_Convoy_SetupHerringbone.sqf
  - Lead stays on-road; spacing reads from CBA; last-road memory via `_EndWP setVariable ["OKS_Convoy_LastRoad", road]` to prevent forward jumps.
- functions/spawn/convoy/fn_Convoy_WaitUntilAirTarget.sqf
  - En-route targeting disabled; ammo-aware AA selection; pull-off: flatness + min road distance; unlock AA speed while moving to site; waypoint restore fix; merge-gap wait + speed ramp for rejoin.
- functions/spawn/convoy/fn_Convoy_Spawn.sqf
  - Catch-up booster so stragglers sprint until within dispersion.
- XEH_preInit.sqf (addon root)
  - Registers CBA settings above and writes values to missionNamespace.

## Files updated (mission-local)

- Arma 3/Users/Oksman/missions/ConvoyDevelopment.takistan/fn_Convoy_SetupHerringbone.sqf
  - Lead on-road + cutter retained for local testing. (Optional: mirror the "last road" memory here if you keep using the mission-local script.)

## Integration notes

- Ensure the CBA settings preInit is executed via Extended_PreInit_EventHandlers in your addon config. If not yet added, include a preInit handler that runs `\\OKS_GOL_Misc\\XEH_preInit.sqf`.
- If both mission-local and addon herringbone scripts exist, whichever you call is the one that runs:
  - `[args] call OKS_fnc_Convoy_SetupHerringbone;` → addon version (reads CBA spacing)
  - `execVM "fn_Convoy_SetupHerringbone.sqf";` → mission-local version (hard-coded unless updated)

## Quick acceptance checklist

- AA won’t fire while moving; engages only when off-road.
- AA pull-off sites are clear, flat, and ≥ 20 m from roads (configurable).
- After engagement, AA rejoins smoothly: waypoints restored; waits for merge gap; ramps speed.
- Herringbone spacing defaults to 35 m and is tweakable; lead stays on-road; progression follows last road.
- Stragglers catch up quickly, then re-enter spacing control.

## Optional next tweaks

- Add a 1–2 s arming delay after AA arrival off-road to eliminate edge-case bursts during final nudge.
- Soft-cap AA speed while moving to pull-off (e.g., 70–90 kph) if desirable.
- Mirror last-road memory in the mission-local herringbone file, or drop the local copy to avoid divergence.
- Expose more tunables (lateral offset, pull-off forward distance) to CBA settings.
