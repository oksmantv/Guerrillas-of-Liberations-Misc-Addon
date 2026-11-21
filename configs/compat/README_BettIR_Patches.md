# BettIR Patches - Compatible Equipment

Scope: only the IR strip patches (`BettIR_Patches` addon). Attachments and NVG are not covered here.

## How it is applied

`GW_Gear_Fnc_Handler` (`p:\x\GW\addons\gear\functions\fnc_Handler.sqf`) runs after the loadout is applied, for players only. For each category (uniform, vest, backpack, headgear) it:

1. Reads the worn gear class.
2. Asks BettIR_Patches for the slots that class defines (`BettIR_Patches_fnc_getSlotNames`).
3. Calls `BettIR_Patches_fnc_setPatch` with the insignia `BettIR` for each slot.

The whitelist is BettIR_Patches' own config (`configFile >> "BettIR_Patches" >> <section> >> <gearClass> >> "AttachedPatches"`). Gear not listed below gets no patch. Nothing happens if BettIR_Patches is not loaded.

## Compatible gear (total list)

| Category | Section | Class | Slot |
|---|---|---|---|
| vest | `compatibleVests` | `V_PlateCarrierL_CTRG` | `Chest` |
| headgear | `compatibleHelmets` | `H_HelmetB_light` | `Rear` |
| headgear | `compatibleHelmets` | `H_HelmetB_light_black` | `Rear` |
| headgear | `compatibleHelmets` | `H_HelmetB_light_desert` | `Rear` |
| headgear | `compatibleHelmets` | `H_HelmetB_light_grass` | `Rear` |
| headgear | `compatibleHelmets` | `H_HelmetB_light_sand` | `Rear` |
| headgear | `compatibleHelmets` | `H_HelmetB_light_snakeskin` | `Rear` |
| headgear | `compatibleHelmets` | `H_HelmetB_Light_tna_F` | `Rear` |
| headgear | `compatibleHelmets` | `H_HelmetB_light_wdl` | `Rear` |

Total: 9 items (1 vest, 8 helmets).

Not supported (empty in the addon): uniforms (`compatibleUniforms`) and backpacks (`compatibleBackpacks`). Uniform insignia is set through the normal arsenal insignia instead.

## Manual use

```sqf
[player, "headgear", "Rear", "BettIR"] call BettIR_Patches_fnc_setPatch;   // apply
[player, "headgear", "Rear", ""] call BettIR_Patches_fnc_setPatch;         // clear
```

Returns `false` when the worn gear has no such slot or the insignia is unknown.

## Source

List taken from the `BettIR_Patches` class in `BettIR_Patches\config.cpp` (Workshop `@BettIR NVG`). Re-check it after a BettIR update.
