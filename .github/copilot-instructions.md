# Copilot Instructions — Commit Messages (OKS_GOL_Misc)

Follow these steps exactly when generating a commit message for this repository.

## Step 1 — Get the version from the diff
Look in the staged diff for `version.hpp`. Extract the new values of:
- `MISC_MAJOR`, `MISC_MINOR`, `MISC_PATCHLVL`, `MISC_BUILD`

If version.hpp is not in the diff, read the file directly to get these values.

## Step 2 — Write the commit message

Use this exact structure. Do not deviate.

```
Version MISC_MAJOR.MISC_MINOR.MISC_PATCHLVL Build MISC_BUILD
<Title>
+ [Subsystem] Description
~ [Subsystem] Description
- [Subsystem] Description
```

**Line 1 is always the version line.** It is never a change entry. It is never omitted.

## Rules

- Line 1: `Version X.X.X Build XXXXXXX` — values from version.hpp. Always present. Always first.
- Line 2: Short title summarising the functional intent. No trailing period.
- Lines 3+: One change per line using `+`, `~`, or `-` prefix.
- `+` = new functionality. `~` = modified existing. `-` = removed.
- Subsystem label in brackets: e.g. `[CfgWeapons]`, `[AI System]`, `[HMD]`, `[Medical]`, `[Core]`.
- **NEVER append a filename or path after an entry. No parentheses. No filenames. Ever.**
- Format is strictly: `~ [Subsystem] Description` — nothing after the description.
- Include all functional changes: scripts, configs, modules, AI behavior, loadouts, UI, networking.
- Omit a prefix type entirely if there are no changes of that type.

## Example

version.hpp contains: `MISC_MAJOR 3`, `MISC_MINOR 3`, `MISC_PATCHLVL 0`, `MISC_BUILD 270526`

Correct output:
```
Version 3.3.0 Build 270526
Updated Gear and Roles
+ [Medical] Added automatic medic loadout fallback
~ [CfgWeapons] Adjusted squad lead role radios and magazines
- [Core] Removed legacy ACE incompat workaround
```

Incorrect output (do NOT do this):
```
Updated Gear and Roles
~ Adjusted squad lead role radios and magazines (CfgWeapons.cpp)
+ Added medic fallback (fn_medic.sqf)
```