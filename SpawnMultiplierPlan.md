# Spawn Multiplier — Implementation Plan for OKS_GOL_Misc

## Context

`GOL_SpawnMultiplier` is a global numeric variable (0–100) that controls AI spawn density.
- Set to **100** by default → no reduction (all multiplier code is skipped entirely via `_oks_multiplier < 100` guard = zero performance cost).
- Set to e.g. **50** → spawn counts are halved across all covered functions.
- Set via a CBA settings SLIDER in this addon (for any mission) OR overridden by a mission parameter in GOL_FRAMEWORK_2021 missions (which sets `GOL_SpawnMultiplier` via `configProperties` + `paramsArray` in `Modules/Common/postInit.sqf`).

Per-function blacklists are **CBA CHECKBOX settings** (global variables, set via addon options in the lobby). Default = `false` (not blacklisted). When `true`, the specific function ignores the multiplier entirely.

---

## Files to Create

### 1. `XEH_PreInit/XEH_preInit_spawnMultiplier.sqf` _(new)_

Full file content — copy verbatim:

```sqf
diag_log "OKS_GOL_Misc: XEH_preInit_spawnMultiplier.sqf executed";

// --- Master multiplier value (server-wide default) ---
[
    "GOL_SpawnMultiplier",
    "SLIDER",
    ["Spawn Multiplier (%)", "Scales down AI spawn counts across all covered OKS spawn functions. 100 = full strength. Applied as: ceil(rawCount * value / 100)."],
    ["GOL Spawn Multiplier", "Settings"],
    [10, 100, 100, 0],  // [min, max, default, decimals]
    1
] call CBA_fnc_addSetting;

// --- Per-function blacklists (exemptions from the multiplier) ---

[
    "GOL_SpawnMultiplier_Blacklist_Patrol",
    "CHECKBOX",
    ["Blacklist: Patrol Spawns", "Exempt OKS_fnc_Patrol_Spawn from spawn multiplier reduction."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_Garrison",
    "CHECKBOX",
    ["Blacklist: Garrison (Buildings)", "Exempt OKS_fnc_Garrison from spawn multiplier. Also affects OKS_fnc_Populate_Strongpoints which delegates to Garrison."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_GarrisonCompound",
    "CHECKBOX",
    ["Blacklist: Garrison (Compounds)", "Exempt OKS_fnc_Garrison_Compound from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_PopulateBunkers",
    "CHECKBOX",
    ["Blacklist: Bunker Population", "Exempt OKS_fnc_Populate_Bunkers from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_StaticWeapons",
    "CHECKBOX",
    ["Blacklist: Static Weapon Crews", "Exempt OKS_fnc_Populate_StaticWeapons from spawn multiplier. When not blacklisted, excess uncrewed statics are deleted."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_SpawnStatic",
    "CHECKBOX",
    ["Blacklist: Static Spawn (Array)", "Exempt OKS_fnc_SpawnStatic from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_AmphibiousAssault",
    "CHECKBOX",
    ["Blacklist: Amphibious Assault", "Exempt OKS_fnc_AmphibiousAssault cargo infantry from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_BeachLanding",
    "CHECKBOX",
    ["Blacklist: Beach Landing", "Exempt OKS_fnc_BeachLanding cargo infantry from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_RailVehicle",
    "CHECKBOX",
    ["Blacklist: Rail Vehicle Cargo", "Exempt OKS_fnc_RailVehicle_Spawn cargo infantry from spawn multiplier. The vehicle itself always spawns."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_BuildingRestCamp",
    "CHECKBOX",
    ["Blacklist: Building Rest Camp", "Exempt OKS_fnc_BuildingRestCamp from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_AttackSpawnGroup",
    "CHECKBOX",
    ["Blacklist: Attack Spawn Group", "Exempt OKS_fnc_Attack_SpawnGroup infantry path from spawn multiplier. Vehicle path is unaffected regardless."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_HoldWaypoint",
    "CHECKBOX",
    ["Blacklist: Hold Waypoint", "Exempt OKS_fnc_Hold_Waypoint infantry path from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_VehiclePatrol",
    "CHECKBOX",
    ["Blacklist: Vehicle Patrol", "Exempt OKS_fnc_Vehicle_Patrol from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_Convoy",
    "CHECKBOX",
    ["Blacklist: Convoy Spawn", "Exempt OKS_fnc_Convoy_Spawn vehicle count and cargo from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_InfantryPincer",
    "CHECKBOX",
    ["Blacklist: Infantry Pincer", "Exempt OKS_fnc_SpawnInfantryPincer from spawn multiplier (all 4 fire teams)."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_MechanizedSpawn",
    "CHECKBOX",
    ["Blacklist: Mechanized Spawn Cargo", "Exempt OKS_fnc_Mechanized_Spawn cargo infantry from spawn multiplier. The vehicle itself always spawns."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_LambsSpawnGroup",
    "CHECKBOX",
    ["Blacklist: Lambs Spawn Group", "Exempt OKS_fnc_Lambs_SpawnGroup infantry path from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_LambsSpawner",
    "CHECKBOX",
    ["Blacklist: Lambs Spawner (Respawn)", "Exempt OKS_fnc_Lambs_Spawner from spawn multiplier."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_LambsWavespawn",
    "CHECKBOX",
    ["Blacklist: Lambs Wavespawn", "Exempt OKS_fnc_Lambs_Wavespawn from spawn multiplier (units per wave only, wave count unchanged)."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_LambsChargeSpawn",
    "CHECKBOX",
    ["Blacklist: Lambs Charge Spawn", "Exempt OKS_fnc_LambsChargeSpawn from spawn multiplier (units per wave only)."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;

[
    "GOL_SpawnMultiplier_Blacklist_HuntBase",
    "CHECKBOX",
    ["Blacklist: Hunt Base Waves", "Exempt OKS_fnc_HuntBase infantry wave size from spawn multiplier. Vehicle and convoy paths unaffected."],
    ["GOL Spawn Multiplier", "Blacklists"],
    false, 1
] call CBA_fnc_addSetting;
```

---

## Files to Modify

### 2. `config.cpp` — Register new preInit

Inside `class Extended_PreInit_EventHandlers { ... }`, add after the last existing entry:

```cpp
class OKS_PreInit_SpawnMultiplier {
    init = "call compile preprocessFileLineNumbers '\OKS_GOL_Misc\XEH_PreInit\XEH_preInit_spawnMultiplier.sqf'";
};
```

---

### Standard boilerplate for ALL 21 functions

Insert immediately **after the `params [...]` block** (or after `Params [...]` — preserve existing capitalisation). Replace `BLACKLIST_VAR_NAME` with the specific variable from the table below:

```sqf
private _oks_multiplier = missionNamespace getVariable ["GOL_SpawnMultiplier", 100];
private _oks_blacklisted = missionNamespace getVariable ["GOL_SpawnMultiplier_Blacklist_XXXX", false];
private _oks_applyMultiplier = (_oks_multiplier < 100) && {!_oks_blacklisted};
```

Then insert the group-specific scaling block described below.

#### Variable name table

| Function file | Blacklist variable |
|---|---|
| `fn_Patrol_Spawn.sqf` | `GOL_SpawnMultiplier_Blacklist_Patrol` |
| `fn_Garrison.sqf` | `GOL_SpawnMultiplier_Blacklist_Garrison` |
| `fn_Garrison_Compound.sqf` | `GOL_SpawnMultiplier_Blacklist_GarrisonCompound` |
| `fn_Populate_Bunkers.sqf` | `GOL_SpawnMultiplier_Blacklist_PopulateBunkers` |
| `fn_Populate_StaticWeapons.sqf` | `GOL_SpawnMultiplier_Blacklist_StaticWeapons` |
| `fn_SpawnStatic.sqf` | `GOL_SpawnMultiplier_Blacklist_SpawnStatic` |
| `fn_AmphibiousAssault.sqf` | `GOL_SpawnMultiplier_Blacklist_AmphibiousAssault` |
| `fn_BeachLanding.sqf` | `GOL_SpawnMultiplier_Blacklist_BeachLanding` |
| `fn_RailVehicle_Spawn.sqf` | `GOL_SpawnMultiplier_Blacklist_RailVehicle` |
| `fn_BuildingRestCamp.sqf` | `GOL_SpawnMultiplier_Blacklist_BuildingRestCamp` |
| `fn_Attack_SpawnGroup.sqf` | `GOL_SpawnMultiplier_Blacklist_AttackSpawnGroup` |
| `fn_Hold_Waypoint.sqf` | `GOL_SpawnMultiplier_Blacklist_HoldWaypoint` |
| `fn_Vehicle_Patrol.sqf` | `GOL_SpawnMultiplier_Blacklist_VehiclePatrol` |
| `fn_Convoy_SpawnBody.sqf` | `GOL_SpawnMultiplier_Blacklist_Convoy` |
| `fn_SpawnInfantryPincer.sqf` | `GOL_SpawnMultiplier_Blacklist_InfantryPincer` |
| `fn_Mechanized_Spawn.sqf` | `GOL_SpawnMultiplier_Blacklist_MechanizedSpawn` |
| `fn_Lambs_SpawnGroup.sqf` | `GOL_SpawnMultiplier_Blacklist_LambsSpawnGroup` |
| `fn_Lambs_Spawner.sqf` | `GOL_SpawnMultiplier_Blacklist_LambsSpawner` |
| `fn_Lambs_Wavespawn.sqf` | `GOL_SpawnMultiplier_Blacklist_LambsWavespawn` |
| `fn_LambsChargeSpawn.sqf` | `GOL_SpawnMultiplier_Blacklist_LambsChargeSpawn` |
| `fn_HuntBase.sqf` | `GOL_SpawnMultiplier_Blacklist_HuntBase` |

---

## Group-Specific Scaling Code

Apply after the boilerplate, before any unit-creation logic.

### Group 1 — Array-based: `fn_SpawnStatic.sqf`

Both `_InfantryArray` and `_VehicleArray` are shuffled then trimmed. Insert after params:

```sqf
if (_oks_applyMultiplier) then {
    if (count _InfantryArray > 0) then {
        _InfantryArray = _InfantryArray call BIS_fnc_arrayShuffle;
        _InfantryArray = _InfantryArray select [0, ceil (count _InfantryArray * _oks_multiplier / 100)];
    };
    if (count _VehicleArray > 0) then {
        _VehicleArray = _VehicleArray call BIS_fnc_arrayShuffle;
        _VehicleArray = _VehicleArray select [0, ceil (count _VehicleArray * _oks_multiplier / 100)];
    };
};
```

### Group 2 — Integer count, infantry (max 1)

Functions: `fn_Patrol_Spawn.sqf` (`_NumberInfantry`), `fn_Garrison.sqf` (`_NumberInfantry`), `fn_Garrison_Compound.sqf` (`_NumberInfantry`), `fn_Populate_Bunkers.sqf` (`_InfantryNumber`).

```sqf
// Replace PARAM_NAME with the actual param name in that file
if (_oks_applyMultiplier) then {
    PARAM_NAME = (ceil (PARAM_NAME * _oks_multiplier / 100)) max 1;
};
```

**Garrison-specific caveat**: `fn_Garrison.sqf` caps `_NumberInfantry` to the number of available building positions. The multiplier is applied BEFORE that cap, so the cap still functions correctly as a ceiling. Do not reorder.

**Populate_Bunkers caveat**: The loop is `for "_i" from 1 to (_InfantryNumber - 1)` (note the `-1`). Scaling the param is still correct — the `-1` in the loop is intentional existing code, do not remove it.

### Group 2 — Integer count, vehicle cargo (max 3)

Functions: `fn_AmphibiousAssault.sqf` (`_numUnits`), `fn_BeachLanding.sqf` (`_cargoUnitCount`), `fn_RailVehicle_Spawn.sqf` (`_cargoCount`).

```sqf
if (_oks_applyMultiplier) then {
    PARAM_NAME = (ceil (PARAM_NAME * _oks_multiplier / 100)) max 3;
};
```

Minimum 3 because fewer than 3 men in a vehicle looks and feels unnatural.

### Group 2 — Building rest camp (`fn_BuildingRestCamp.sqf`)

The param `_maxUnits` has a special value of `-1` meaning "fill all positions". Do not scale that value:

```sqf
if (_oks_applyMultiplier && { _maxUnits != -1 }) then {
    _maxUnits = (_maxUnits * _oks_multiplier / 100) max 1;
};
```

### Group 3 — Polymorphic count/vehicle

Functions: `fn_Attack_SpawnGroup.sqf`, `fn_Hold_Waypoint.sqf`. Both use `_ClassnameOrNumber` which is either a NUMBER (infantry for loop) or a STRING/ARRAY (single vehicle). Only scale the NUMBER path — a single vehicle is not a meaningful reduction target:

```sqf
if (_oks_applyMultiplier && { _ClassnameOrNumber isEqualType 0 }) then {
    _ClassnameOrNumber = (_ClassnameOrNumber * _oks_multiplier / 100) max 1;
};
```

### Group 4 — Vehicle count: `fn_Vehicle_Patrol.sqf`

```sqf
if (_oks_applyMultiplier) then {
    _NumberOfVehicles = (ceil (_NumberOfVehicles * _oks_multiplier / 100)) max 1;
};
```

### Group 5 — Convoy: `fn_Convoy_SpawnBody.sqf`

**IMPORTANT**: Edit `fn_Convoy_SpawnBody.sqf`, NOT `fn_Convoy_Spawn.sqf`. The body file contains the actual spawn loop.

Two reductions:
1. **Vehicle count** — natural loop truncation removes from the END (front vehicles spawn first, tail is cut). Just reduce the count.
2. **Cargo per vehicle** — minimum 3.

Identify the variables in `fn_Convoy_SpawnBody.sqf` that hold the vehicle count (from `_vehicleArray select 0`) and max soldiers per vehicle (from `_troopArray select 1`). Insert after params are extracted:

```sqf
if (_oks_applyMultiplier) then {
    _vehicleCount = (ceil (_vehicleCount * _oks_multiplier / 100)) max 1;
    _maxSoldiersPerVehicle = (ceil (_maxSoldiersPerVehicle * _oks_multiplier / 100)) max 3;
};
```

If these exact variable names differ, adapt to whatever local variables hold those values.

### Group 6a — Multi-count array: `fn_SpawnInfantryPincer.sqf`

`_NumbersArray` is an array of 4 integers (one per fire team). Scale each element:

```sqf
if (_oks_applyMultiplier) then {
    _NumbersArray = _NumbersArray apply { (ceil (_x * _oks_multiplier / 100)) max 1 };
};
```

### Group 6b — Mechanized cargo: `fn_Mechanized_Spawn.sqf`

`_InfantryNumber` is the cargo count passed to `OKS_fnc_AddVehicleCrew`. The vehicle always spawns. Minimum 3:

```sqf
if (_oks_applyMultiplier) then {
    _InfantryNumber = (ceil (_InfantryNumber * _oks_multiplier / 100)) max 3;
};
```

### Group 7 — Wave-based spawners

**Rule**: Scale **units per wave/cycle** only. Do NOT touch wave count or respawn delay — those control mission pacing, not density.

#### `fn_Lambs_SpawnGroup.sqf`
Only scale when `_InfantryCountOrVehicleArray` is SCALAR. When it is an ARRAY it is a vehicle definition, not a unit count:

```sqf
if (_oks_applyMultiplier && { _InfantryCountOrVehicleArray isEqualType 0 }) then {
    _InfantryCountOrVehicleArray = (ceil (_InfantryCountOrVehicleArray * _oks_multiplier / 100)) max 1;
};
```

#### `fn_Lambs_Spawner.sqf`
`_NumberInfantry` is multiplied internally by `GOL_ForceMultiplier`. Apply spawn multiplier to the raw param BEFORE the force multiplier loop. Locate the line `round(_NumberInfantry * _forceMultiplier)` and ensure the scaling block is before it:

```sqf
if (_oks_applyMultiplier) then {
    _NumberInfantry = (ceil (_NumberInfantry * _oks_multiplier / 100)) max 1;
};
// ... then later: round(_NumberInfantry * _forceMultiplier) as before
```

#### `fn_Lambs_Wavespawn.sqf`
Scale `_UnitsPerWave`. Leave `_AmountOfWaves` untouched:

```sqf
if (_oks_applyMultiplier) then {
    _UnitsPerWave = (ceil (_UnitsPerWave * _oks_multiplier / 100)) max 1;
};
```

#### `fn_LambsChargeSpawn.sqf`
Same pattern, `_unitsPerWave`:

```sqf
if (_oks_applyMultiplier) then {
    _unitsPerWave = (ceil (_unitsPerWave * _oks_multiplier / 100)) max 1;
};
```

#### `fn_HuntBase.sqf`
`_SpawnConfig` can be SCALAR (infantry count), STRING (vehicle classname), or ARRAY (convoy config). Only scale the SCALAR path. Leave `_Waves` count untouched:

```sqf
if (_oks_applyMultiplier && { _SpawnConfig isEqualType 0 }) then {
    _SpawnConfig = (ceil (_SpawnConfig * _oks_multiplier / 100)) max 1;
};
```

Note: `fn_HuntBase.sqf` also reads `GOL_ForceMultiplier` for wave count. That is a separate system — do not touch it.

### Group 9 — Static weapons: `fn_Populate_StaticWeapons.sqf`

After the function builds its list of eligible static weapons (the array collected via `vehicles select { isKindOf "StaticWeapon" && emptyPositions > 0 ... }`), insert:

```sqf
if (_oks_applyMultiplier && { count _staticWeapons > 0 }) then {
    _staticWeapons = _staticWeapons call BIS_fnc_arrayShuffle;
    private _keepCount = ceil (count _staticWeapons * _oks_multiplier / 100);
    { deleteVehicle _x } forEach (_staticWeapons select [_keepCount, (count _staticWeapons) - _keepCount]);
    _staticWeapons = _staticWeapons select [0, _keepCount];
};
```

**IMPORTANT**: The variable name `_staticWeapons` may differ in the actual file — read the file first and adapt to the real variable name used for the collected static weapon array. The delete step removes the weapon object from the map so empty emplacements don't remain.

---

## Files NOT Changed

| File | Reason |
|---|---|
| `fn_Populate_Strongpoints.sqf` | Delegates entirely to `fn_Garrison.sqf`. Garrison applies scaling. No change needed. |
| `fn_SpawnInfantrySquad.sqf` | Internal helper of `fn_SpawnInfantryPincer.sqf`. Scaling is applied upstream in Pincer. |
| `fn_Lambs_Wavespawn_Code.sqf` | Internal thread code called by Wavespawn. Scaling applied upstream. |
| `fn_ArtyFire.sqf` | Scripted single-vehicle behavior. Excluded by design. |
| `fn_Spawn_AntiAir_Soldier.sqf` | Single unit custom behavior. Excluded. |
| `fn_AirScout.sqf` | Single scripted aerial asset. Excluded. |
| `fn_AirSpawn.sqf` | Single scripted aircraft. Excluded. |
| `fn_AirStrike.sqf` | Scripted set-piece. Excluded. |
| `fn_AI_HelicopterFlyBy.sqf` | Scripted fly-by. Excluded. |
| `fn_AI_Battle.sqf` | Scripted AI vs AI event. Excluded. |
| `fn_AI_ArtilleryBattle.sqf` | Scripted AI vs AI event. Excluded. |
| `fn_Helicopter_Attack.sqf` | Single scripted helicopter. Excluded. |
| `fn_DroneHuntZone.sqf` | Single kamikaze drone. Excluded. |
| `fn_AirCargoDrop.sqf` | Scripted supply drop, no combat units. Excluded. |
| `fn_Civilian_Vehicle.sqf` | Civilian, not combat. Excluded. |
| `fn_Scout.sqf` | Wrapper only, no logic. Excluded. |
| `fn_SHORAD.sqf` | Utility modifier, no spawning. Excluded. |
| `fn_Follow_Squad.sqf` | Behaviour script, no spawning. Excluded. |

---

## Already Done — GOL_FRAMEWORK_2021

These changes are **complete** and must not be re-applied:

| File | Change |
|---|---|
| `GOL_Framework_2021.VR/Description.ext` | Added `class SpawnMultiplier` in `class Params` (no `function` field) |
| `GOL_Framework_2021.VR/Modules/Common/postInit.sqf` | Sets `GOL_SpawnMultiplier` from `paramsArray` via `configProperties` lookup |
| `GOL_Framework_2021.VR/Modules/Common/Functions/fnc_spawnHandler.sqf` | Reads `GOL_SpawnMultiplier`, shuffles+trims `_unitArray` and `_vehicleArray` |
| `GOL_Framework_2021.VR/Modules/Common/Functions/fnc_spawnGroup.sqf` | Added `_blacklistMultiplier` param (5th arg), passes to spawnHandler |

---

## Caveats

1. **CBA settings are addon-wide, not per-mission.** Blacklisting a function affects ALL missions loaded with OKS_GOL_Misc. This is intentional — it is a server configuration choice.

2. **`GOL_SpawnMultiplier` priority**: The CBA slider sets the value at addon init. In GOL_FRAMEWORK_2021 missions, `Modules/Common/postInit.sqf` overrides it with the lobby-selected mission param. Non-framework missions use only the CBA value.

3. **`Populate_Strongpoints` → `Garrison` path**: Blacklisting `Garrison` (CBA setting `GOL_SpawnMultiplier_Blacklist_Garrison`) also exempts all strongpoint spawns since Populate_Strongpoints delegates to Garrison. There is no separate blacklist for the two because no function parameter changes are used. Document this in-game tooltip (already reflected in the CBA setting description above).

4. **Wave count is never scaled.** Only units-per-wave/cycle is scaled in all Group 7 functions. This is intentional — wave count controls mission duration and narrative pacing.

5. **`fn_Lambs_Spawner.sqf` and `fn_HuntBase.sqf`** already apply `GOL_ForceMultiplier` internally. The spawn multiplier applies to the raw param BEFORE the force multiplier. Effective count = `ceil(raw × SpawnMultiplier/100) × ForceMultiplier`. This stacking is intentional.

6. **Convoy removes from the tail.** `fn_Convoy_SpawnBody.sqf` spawns vehicles in a sequential `for` loop. Reducing the vehicle count naturally removes the last N vehicles in the defined order, preserving the front of the column as designed.

7. **Cargo minimum is 3.** Any vehicle cargo function reduced below 3 men is clamped to 3 (`max 3`). This applies to: AmphibiousAssault, BeachLanding, RailVehicle, MechanizedSpawn, Convoy cargo-per-vehicle.

8. **Uncrewed static weapons are deleted.** `fn_Populate_StaticWeapons.sqf` uses `deleteVehicle` on any static weapon that was trimmed from the spawn list. The map is kept clean.

9. **Exact variable names in `fn_Convoy_SpawnBody.sqf`** must be verified by reading the file before editing. The plan uses `_vehicleCount` and `_maxSoldiersPerVehicle` as placeholders — confirm against actual local variable names.

10. **Exact variable name in `fn_Populate_StaticWeapons.sqf`** for the collected static list must be verified. The plan uses `_staticWeapons` as a placeholder.

11. **`isEqualType 0` vs `typeName == "SCALAR"`**: Use `isEqualType 0` in all SQF code (preferred Arma 3 idiom).

12. **`ceil` is used throughout.** Rounding is always upward so the last unit/vehicle is kept, not dropped. At 10% of 1 unit = `ceil(0.1)` = 1. The minimum clamp (`max 1` or `max 3`) acts as a secondary safety net.
