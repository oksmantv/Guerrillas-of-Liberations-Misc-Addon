# OKS_fnc_AirSpawn

Spawns an aircraft and routes it to a target/waypoint. Supports selecting aircraft templates (including pylons) and optionally revealing hostile ground targets near the target so the aircraft starts with initial intel.

## Airframe Templates (with pylons)

`_Airframes` (3rd param) accepts:

- Classname string
- Array of classnames
- Array of templates: `[ [classname, pylons], ... ]`
  - `pylons` can be an array of magazine classnames (`getPylonMagazines` style)
  - or an array of tuples: `[ [pylonIndex, magazineClass, ammoCount], ... ]`

## Eden Helper

In Eden:

1. Select one or more airframes you want to use as templates.
2. Right-click terrain where you want the strike/waypoint to be.
3. Run: **GOL Spawns → Fire Support → Air Spawn → Copy (Selection → Templates + Target)**

This will:

- Create a logic named `AirSpawnTarget_X` at the clicked position
- Copy a ready-to-paste `OKS_fnc_AirSpawn` call to clipboard
- Delete the selected template airframes (so they don’t remain in the mission)

## Intel / Reveal

If `_RevealTargets` is `true`, the spawned crew will `reveal` hostile ground targets within `_RevealRadius` (default 1000m) around `_MoveToPos`.
A target is considered hostile when `(_Side getFriend side _target) == 0`.
