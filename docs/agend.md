# Arma 3 Vehicle Customization — Complete Knowledge Base

## Overview

This document captures every lesson, caveat, debug technique, and workflow discovered during the full customization of the **GOL_BMP2D** (based on RHS `rhs_bmp2d_msv`). The goal was to replace the RHS-custom HUD/optics/FCS with vanilla Arma 3 equivalents while retaining RHS weapon systems, and to add quality-of-life features.

This guide is written so that the same process can be applied to **any modded vehicle** with reduced trial and error.

---

## Table of Contents

1. [The Cross-PBO Problem](#1-the-cross-pbo-problem)
2. [FCS / Ballistics Computer — The Split Single-Muzzle Solution](#2-fcs--ballistics-computer--the-split-single-muzzle-solution)
3. [Fire Modes — Controlling What the Player Sees](#3-fire-modes--controlling-what-the-player-sees)
4. [Optics System Architecture](#4-optics-system-architecture)
5. [Gunner Turret Configuration](#5-gunner-turret-configuration)
6. [Commander Turret Configuration](#6-commander-turret-configuration)
7. [Driver View Configuration](#7-driver-view-configuration)
8. [Memory Points — Finding the Right One](#8-memory-points--finding-the-right-one)
9. [Animation Sources — Stowing Weapons](#9-animation-sources--stowing-weapons)
10. [Magazine Management — Runtime Add/Remove](#10-magazine-management--runtime-addremove)
11. [ACE Interactions on Vehicles](#11-ace-interactions-on-vehicles)
12. [Debug Commands Reference](#12-debug-commands-reference)
13. [Config Property Reference](#13-config-property-reference)
14. [Common Pitfalls](#14-common-pitfalls)
15. [Vehicle Armor](#15-vehicle-armor--what-you-can-and-cannot-change)
16. [Complete ATGM Toggle System](#16-complete-atgm-toggle-system--putting-it-all-together)
17. [Final Working Configuration](#17-final-working-configuration)

---

## 1. The Cross-PBO Problem

### The Rule
**You CANNOT inherit from inner classes of a binarized (external) PBO in an unbinarized addon.**

This is the single most critical lesson. When you write:
```cpp
class MyVehicle: some_modded_vehicle {
    class AnimationSources: AnimationSources { // ← FAILS: "undefined base class"
        class myAnim { ... };
    };
};
```
The engine cannot resolve the parent `AnimationSources` because it lives inside a binarized PBO. This applies to **ALL inner classes**: `AnimationSources`, `Turrets`, `HitPoints`, `UserActions`, muzzle sub-classes inside weapons, etc.

### Consequences
- You **cannot** override `ballisticsComputer` inside an inherited muzzle class (e.g., inside `HE` or `AP` of `rhs_weap_2a42`) — the inner class reference is destroyed.
- You **cannot** inherit from `AnimationSources` to add/change a single animation — it wipes ALL parent animations (reload, recoil, hatches, etc.).
- You **can** override top-level properties (parent-level values like `ballisticsComputer`, `muzzles[]`, `modes[]`).

### Solutions
- **For weapons**: Create a NEW child class with `muzzles[] = {"this"}` to collapse the muzzle hierarchy (see Section 2).
- **For AnimationSources**: Don't override in config. Use `animate` command at runtime instead.
- **For Turrets**: Redefine the entire turret tree standalone (which is what GOL_BMP2D does).

---

## 2. FCS / Ballistics Computer — The Split Single-Muzzle Solution

### The Problem
RHS `rhs_weap_2a42` has:
- Parent level: `ballisticsComputer = 0` (RHS deliberately disabled vanilla FCS)
- Base class `rhs_weap_2a42_base`: `ballisticsComputer = "2 + 16"` (= 18)
- Inner HE muzzle: `ballisticsComputer = 0` (overrides parent)
- Inner AP muzzle: `ballisticsComputer = 0` (overrides parent)

Setting `ballisticsComputer = 18` on a child class doesn't work because the **inner muzzle classes** still have `bc = 0` and you can't override them (cross-PBO problem).

### The Solution — Split Single-Muzzle Weapons
Instead of fighting the multi-muzzle hierarchy, create **two separate single-muzzle weapons**:

```cpp
class GOL_weap_2a42_HE: rhs_weap_2a42 {
    ballisticsComputer = 18;           // Parent-level = effective muzzle-level
    muzzles[] = {"this"};              // Collapse to single muzzle — "this" IS the weapon
    magazineWell[] = {"RHS_AutoCannon_30mm_2A42_HE"};  // Only HE magazines
    modes[] = {"HighROFBMD2","closeBMD2","shortBMD2","mediumBMD2","farBMD2"};
    displayName = "2A42 HE";
};
class GOL_weap_2a42_AP: rhs_weap_2a42 {
    ballisticsComputer = 18;
    muzzles[] = {"this"};
    magazineWell[] = {"RHS_AutoCannon_30mm_2A42_AP"};
    modes[] = {"HighROFBMD2","closeBMD2","shortBMD2","mediumBMD2","farBMD2"};
    displayName = "2A42 AP";
};
```

### Why This Works
- `muzzles[] = {"this"}` means the weapon IS the muzzle — no inner classes exist.
- Parent-level `ballisticsComputer = 18` IS the effective muzzle-level value.
- Player switches between HE/AP via weapon switch (next weapon key) instead of muzzle toggle.
- `magazineWell[]` restricts each weapon to only its ammo type.
- Works with `Laserdesignator_mounted` for lasing / auto-range.

### ballisticsComputer Values
| Value | Meaning |
|-------|---------|
| 0 | Disabled |
| 2 | FCS auto-zeroing |
| 16 | Laser rangefinder integration |
| 18 | Both (2 + 16) — full auto-range with lasing |

### Laserdesignator_mounted — Required for Auto-Ranging
The `ballisticsComputer` value `16` means "laser rangefinder integration". But the laser must come from somewhere — you must include `Laserdesignator_mounted` in the turret's `weapons[]` array:
```cpp
weapons[] = {"GOL_weap_2a42_HE","GOL_weap_2a42_AP","GOL_weap_pkt",
             "rhs_weap_9m113","rhs_weap_902a","Laserdesignator_mounted"};
```
Without `Laserdesignator_mounted` in the turret, `bc = 18` falls back to manual zeroing only (the `16` component does nothing). The player lases a target with the laser designator, and the FCS reads the range and auto-adjusts zeroing for the cannons.

### ACE FCS Conflict — Disable ACE FCS When Using Vanilla
ACE3 has its own Fire Control System (`ace_fcs`) that **conflicts** with the vanilla `ballisticsComputer`. If both are active, you get double-zeroing or unpredictable behavior. Disable ACE FCS on the turret:
```cpp
ace_fcs_Enabled = 0;  // Disable ACE FCS — we use vanilla ballisticsComputer instead
```
This is set on the turret level (inside `MainTurret`), not on the weapon.

### Coaxial Weapons (PKT)
The PKT machine gun also needs FCS. Since it's single-muzzle already, a simple override works:
```cpp
class GOL_weap_pkt: rhs_weap_pkt {
    ballisticsComputer = 18;
};
```

### CfgPatches Registration
All custom weapons must be listed in `CfgPatches >> weapons[]`:
```cpp
weapons[] = {"GOL_weap_2a42_HE","GOL_weap_2a42_AP","GOL_weap_pkt"};
```

---

## 3. Fire Modes — Controlling What the Player Sees

### The Problem
Inheriting from `rhs_weap_2a42` brings ALL parent fire modes:
- `LowROFBMD2` (300 rpm, `showToPlayer = 1`)
- `HighROFBMD2` (600 rpm, `showToPlayer = 1`)
- `closeBMD2`, `shortBMD2`, `mediumBMD2`, `farBMD2` (AI-only modes)

Two player-visible modes × 2 weapons = **4 weapons** shown in the HUD.

### The Fix
Override `modes[]` to exclude unwanted modes:
```cpp
modes[] = {"HighROFBMD2","closeBMD2","shortBMD2","mediumBMD2","farBMD2"};
```
This removes `LowROFBMD2` — player sees only 2 weapons (HE + AP).

### Debug: Dump Fire Modes
```sqf
private _cfg = configFile >> "CfgWeapons" >> "rhs_weap_2a42";
{
    private _mode = _cfg >> _x;
    diag_log format["%1: showToPlayer=%2 reloadTime=%3",
        _x, getNumber(_mode >> "showToPlayer"), getNumber(_mode >> "reloadTime")];
} forEach getArray(_cfg >> "modes");
```

---

## 4. Optics System Architecture

### Three Layers of Optics Config

1. **`turretInfoType`** — The HUD overlay class (compass, turret direction indicator, weapon info)
2. **`gunnerOpticsModel`** — The reticle/frame 3D model (what you look "through")
3. **`visionMode[]`** — Available vision modes (Normal, NVG, Ti)

### Property Name Differences
| Context | Optics Model Property | Notes |
|---------|----------------------|-------|
| Turret level | `gunnerOpticsModel` | Fallback if not set in OpticsIn |
| Turret OpticsIn class | `gunnerOpticsModel` | Per-zoom-level model |
| Driver level | `driverOpticsModel` | Vehicle-level property |
| DriverOpticsIn class | `opticsModel` | **NOT** gunnerOpticsModel! |

> **CRITICAL**: Inside `DriverOpticsIn`, the property is `opticsModel`, not `gunnerOpticsModel`. Using the wrong name causes: `Warning Message: No entry 'config.bin/CfgVehicles/.../DriverOpticsIn/OpticView.opticsModel'`

### HUD Types (turretInfoType)
Discovered via config dumps:

| turretInfoType | Source Vehicle | Style |
|----------------|---------------|-------|
| `RscOptics_APC_Wheeled_01_gunner` | Badger (gunner) | Wide, clean APC gunner HUD |
| `RscOptics_MBT_02_gunner` | T-100 Varsuk (gunner) | OPFOR MBT gunner, more blacked-out |
| `RscOptics_MBT_01_commander` | Badger (commander) | NATO commander HUD, clean |
| `RscOptics_MBT_02_commander` | T-100 Varsuk (commander) | OPFOR commander, eye-shaped, heavy vignette |

### Optics Models (gunnerOpticsModel)
Per-zoom-level models from the Badger:

**Gunner:**
| Zoom | Model Path |
|------|-----------|
| Wide | `\A3\Weapons_F\Reticle\Optics_Gunner_APC_01_w_F.p3d` |
| Medium | `\A3\Weapons_F\Reticle\Optics_Gunner_APC_01_m_F.p3d` |
| Narrow+ | `\A3\Weapons_F\Reticle\Optics_Gunner_APC_01_n_F.p3d` |

**Commander:**
| Zoom | Model Path |
|------|-----------|
| Wide | `\A3\Weapons_F\Reticle\Optics_Commander_01_w_F.p3d` |
| Medium | `\A3\Weapons_F\Reticle\Optics_Commander_01_m_F.p3d` |
| Narrow+ | `\A3\Weapons_F\Reticle\Optics_Commander_01_n_F.p3d` |

**Other useful models:**
| Model | Purpose |
|-------|---------|
| `\A3\weapons_f\reticle\optics_empty` | No frame at all (raw view) |
| `\A3\weapons_f\reticle\Optics_Gunner_02_F` | Generic OPFOR gunner reticle |
| `\A3\weapons_f\reticle\Optics_Commander_02_F` | Generic commander reticle |
| `\A3\weapons_f\reticle\Optics_Commander_OPFOR_F` | OPFOR commander (heavy vignette) |
| `\A3\drones_f\Weapons_F_Gamma\Reticle\UGV_01_Optics_Driver_F.p3d` | UGV camera frame |

---

## 5. Gunner Turret Configuration

### Key Properties
```cpp
class MainTurret
{
    // Weapons
    weapons[] = {"GOL_weap_2a42_HE","GOL_weap_2a42_AP","GOL_weap_pkt",
                 "rhs_weap_9m113","rhs_weap_902a","Laserdesignator_mounted"};
    
    // Memory points
    memoryPointGun = "machinegun";          // Where bullets come from visually
    memoryPointGunnerOptics = "view_bpk42"; // Camera position in optics mode
    
    // Optics
    gunnerForceoptics = 1;
    LodOpticsIn = 0;          // MUST be 0 for optics to render
    LodOpticsOut = 0;
    
    // Vision modes — set in OpticsIn Wide class (children inherit)
    // visionMode[] = {"Normal","NVG","Ti"};
    
    // Zeroing
    discreteDistance[] = {100,200,...,3000};
    discreteDistanceInitIndex = 2;          // Default to 300m
    
    // FCS disabled (using vanilla ballisticsComputer instead)
    ace_fcs_Enabled = 0;
};
```

### Turret Nesting Structure
Understanding the class nesting is critical for turret paths and ACE conditions:
```
class GOL_BMP2D: rhs_bmp2d_msv {
    class Turrets {
        class MainTurret {              // ← turret path [0]  (gunner)
            class Turrets {
                class CommanderOptics { // ← turret path [0,0] (commander)
                };
            };
        };
    };
};
```
CommanderOptics is a **sub-turret** inside MainTurret. Its turret path is `[0,0]`. This matters for:
- `weaponsTurret [0,0]` — commander weapons
- `addMagazineTurret ["mag", [0]]` — adds to gunner (main turret)
- `turretUnit [0,0]` — the unit sitting in commander seat

### OpticsIn Inheritance Pattern
The zoom levels inside `OpticsIn` use **class inheritance** — the first class (`Wide`) is the base, and subsequent classes inherit from it:
```cpp
class OpticsIn {
    class Wide {                     // ← BASE zoom level
        visionMode[] = {"Normal","NVG","Ti"};  // Set here — children inherit
        thermalMode[] = {0,1};
        gunnerOpticsModel = "...w_F.p3d";
        initFov = 0.6;
    };
    class Medium: Wide {             // ← Inherits visionMode, thermalMode from Wide
        gunnerOpticsModel = "...m_F.p3d";
        initFov = 0.175;
    };
    class Narrow: Wide {
        gunnerOpticsModel = "...n_F.p3d";
        initFov = 0.0583;
    };
};
```
This means setting `visionMode` on `Wide` automatically gives NVG/thermals to all zoom levels.

### NVG Caveat
`visionMode[]` is set **per OpticsIn zoom class**, NOT at the turret level. The `Wide` class is the parent — children (Medium, Narrow, etc.) inherit from it. Set NVG on Wide and all zoom levels get it.

**Common mistake**: Setting `visionMode[] = {"Normal","Ti"}` — this omits NVG entirely! Always include all three: `{"Normal","NVG","Ti"}`.

### thermalMode Values
`thermalMode[]` controls which thermal imaging modes the player can cycle through:
| Value | Mode | Display |
|-------|------|--------|
| 0 | WHOT | White Hot — hot objects appear white |
| 1 | BHOT | Black Hot — hot objects appear black |

Set `thermalMode[] = {0,1}` to allow the player to toggle between both. Only relevant when `visionMode[]` includes `"Ti"`.

### stabilizedInAxes Values
| Value | Meaning |
|-------|---------|
| 0 | No stabilization — turret sways with vehicle movement |
| 1 | Vertical only — gun elevation is stabilized |
| 2 | Horizontal only — turret traverse is stabilized |
| 3 | Both axes — full stabilization (standard for modern IFVs) |

### gunnerOpticsEffect
Setting `gunnerOpticsEffect[] = {}` (empty array) removes all post-processing effects (chromatic aberration, blur, vignette) from the optics view. This is a deliberate choice for cleaner visuals. If you want effects, copy them from the reference vehicle dump.

### Magazines — Tripling Ammo
For fast-firing autocannons, multiply magazine entries:
```cpp
magazines[] = {
    "rhs_mag_3uof8_340","rhs_mag_3uof8_340","rhs_mag_3uof8_340",  // 3x HE = 1020 rounds
    "rhs_mag_3ubr8_160","rhs_mag_3ubr8_160","rhs_mag_3ubr8_160",  // 3x AP = 480 rounds
    ...
};
```

---

## 6. Commander Turret Configuration

### Key Properties
```cpp
class CommanderOptics
{
    primaryGunner = 0;
    primaryObserver = 1;    // ← REQUIRED for turret direction indicator
    commanding = 2;
    hasCommander = 1;
    
    // Animation — must match RHS bone names
    body = "RHS_BMP1_com_coppula_BMP2";
    gun = "RHS_BMP1_OU3_BMP2";
    animationSourceBody = "obsturret";
    animationSourceGun = "obsGun";
    
    // Memory point — critical for camera placement
    memoryPointGunnerOptics = "ou3_bmp2";   // See Section 8
    
    // HUD
    turretInfoType = "RscOptics_MBT_01_commander";
    showHMD = 0;            // Badger uses 0
};
```

### primaryObserver
`primaryObserver = 1` is what enables the **turret direction indicator** (the compass/turret bearing overlay) on the commander's HUD. Without this, the commander has no directional awareness. The Badger sets this to 1.

### Turret Direction Indicator
The turret direction indicator that shows gunner/commander turret bearings is tied to `primaryObserver`, NOT `showHMD`. Setting `showHMD = 1` was tested and is NOT the correct fix.

### commanding Values
| Value | Meaning |
|-------|---------|
| 0 | No command authority |
| 1 | Can issue waypoints |
| 2 | Full commander — shown as commander in group, controls formation |

Set `commanding = 2` for the commander turret to get full command authority.

### Animation Bone Names — Must Match Model
The `body` and `gun` properties reference **animation bones** in the 3D model (P3D file). These are NOT arbitrary — they must exactly match what the model defines:
```cpp
body = "RHS_BMP1_com_coppula_BMP2";    // Cupola rotation bone
gun = "RHS_BMP1_OU3_BMP2";             // Gun elevation bone
animationSourceBody = "obsturret";      // Config animation driving body rotation
animationSourceGun = "obsGun";          // Config animation driving gun elevation
```
RHS uses prefixed naming (`RHS_BMP1_...`). Vanilla Arma uses simpler names (`mainTurret`, `mainGun`). **Always dump the reference vehicle** (Section 12.2) to find the correct bone names — guessing will result in a non-rotating turret.

### LodOpticsIn Requirement
`LodOpticsIn = 0` (and `LodOpticsOut = 0`) **must be set to 0** for optics to render correctly. If these are set to other values (or not set at all), the engine may use the wrong LOD (Level of Detail) mesh when rendering the optics view, resulting in missing geometry or visual glitches.

---

## 7. Driver View Configuration

### Replacing RHS 2D Interior with Camera View
RHS uses a custom optics model (`rhs_tnpo170a`) that renders a 2D periscope texture. To replace with a camera-style view:

```cpp
class GOL_BMP2D: rhs_bmp2d_msv {
    driverForceOptics = 1;    // Force camera to driverview memory point
    driverOpticsModel = "\A3\drones_f\Weapons_F_Gamma\Reticle\UGV_01_Optics_Driver_F.p3d";
    driverOpticsColor[] = {1,1,1,1};
    driverOpticsEffect[] = {};
    
    class DriverOpticsIn {
        class OpticView {
            initAngleX = 0; minAngleX = -30; maxAngleX = 30;
            initAngleY = 0; minAngleY = -30; maxAngleY = 30;
            initFov = 0.7; minFov = 0.25; maxFov = 1.1;
            visionMode[] = {"Normal","NVG"};
            opticsModel = "\A3\drones_f\Weapons_F_Gamma\Reticle\UGV_01_Optics_Driver_F.p3d";
            gunnerOpticsEffect[] = {};
        };
    };
};
```

### Driver HUD Limitation
There is **no `driverInfoType` property** in Arma 3. The standard driver compass/speed HUD is engine-provided and only shows **outside** optics mode. With `driverForceOptics = 1`, no compass/speed is available via config. Options:
- Accept the limitation and use an external mod for compass
- Create a scripted RscTitles overlay
- Set `driverForceOptics = 0` (but then you see the 3D interior with no viewports)

### Available Optics Models for Driver
| Model | Effect |
|-------|--------|
| `\A3\weapons_f\reticle\optics_empty` | No frame — raw naked-eye view |
| `\A3\drones_f\...\UGV_01_Optics_Driver_F.p3d` | Camera-style frame overlay |
| RHS `\rhsafrf\...\rhs_tnpo170a` | 2D periscope texture (original) |

### Driver View — Trial Progression (How We Got Here)
This was discovered through iterative testing. Understanding the progression helps when adapting for other vehicles:

| Attempt | Config | Result | Why |
|---------|--------|--------|----- |
| 1. Original RHS | `driverForceOptics=1`, `driverOpticsModel="rhs_tnpo170a"` | 2D periscope texture overlay | RHS custom model renders a painted texture |
| 2. Disable optics | `driverForceOptics=0`, `driverOpticsModel="optics_empty"` | 3D interior visible, no viewports | Without forced optics the game shows the 3D interior, but BMP-2 model has no transparent windows |
| 3. Force + empty | `driverForceOptics=1`, `driverOpticsModel="optics_empty"` | Raw naked-eye camera, no frame | Works but looks too "bare" — no visual framing |
| 4. Force + UGV | `driverForceOptics=1`, `driverOpticsModel="UGV_01_Optics_Driver_F.p3d"` | **Camera-style frame** ✅ | Clean camera overlay, looks like a modern driver viewer |

**Lesson**: `driverForceOptics` controls whether the engine jumps to the driver's optics memory point:
- `= 0` → player sees the 3D interior model (first-person view inside hull). Only works if the model has transparent viewport geometry.
- `= 1` → player camera jumps to `memoryPointDriverOptics` and renders through the `driverOpticsModel`. This is the mode you want for camera-style views.

### PIP (Picture-in-Picture) Viewports
PIP viewports **require model support** — render target surfaces must be baked into the P3D model. Cannot be added via config alone.

---

## 8. Memory Points — Finding the Right One

### The Problem
Commander `memoryPointGunnerOptics` determines where the camera sits in optics mode. Choosing the wrong point results in:
- Camera inside geometry (can't see out)
- Camera at floor level (under the vehicle)
- Camera that doesn't follow turret rotation

### Debug: Dump All Memory Points
```sqf
private _veh = vehicle player;
private _cfg = configFile >> "CfgVehicles" >> typeOf _veh;
private _model = getText (_cfg >> "model");
systemChat format["Model: %1", _model];
{diag_log format["  %1", _x]} forEach (selectionNames _veh);
```

### BMP-2D Memory Points — Trial Results
| Memory Point | Result | Notes |
|-------------|--------|-------|
| `commanderview` | Camera at origin (0,0,0) | **Does not exist** in BMP2D model |
| `pos commander` | Floor/under vehicle | GetIn position — hull-mounted, not on turret bone |
| `comsight` | Inside turret geometry | TKN-3B eyepiece — inside the housing |
| `periscopecom1` | Inside turret geometry | Top of periscope but still clipped |
| `com_coppula_bmp2` | At cupola base, no elevation tracking | Pivot point of cupola bone — doesn't follow obsGun |
| **`ou3_bmp2`** | **WORKS** — above turret roof | OU-3 searchlight housing, mounted on top of cupola |

### Selection Criteria for Memory Points
1. Must **exist** in the model (dump and verify)
2. Must be **on the correct animation bone** (follows turret/gun rotation)
3. Must be **above/outside geometry** (not inside turret housing)
4. Points on accessory mounts (searchlights, antenna bases) often work well because they protrude

### Gunner Memory Points (usually stable)
RHS gunner optics typically use purpose-built points like `view_bpk42` which are correctly positioned.

---

## 9. Animation Sources — Stowing Weapons

### The Cross-PBO Trap
Defining `class AnimationSources { ... }` (without inheritance) on a child vehicle **WIPES ALL parent animations**. This breaks:
- Weapon reload animations
- Recoil animations
- Hatch animations
- All door animations

**Never define standalone `AnimationSources` on a child of a binarized vehicle.**

### The Correct Approach — Runtime Animation
Use `animate` command in script instead:
```sqf
_vehicle animate ["konkurs_hide_source", 1];  // Phase 1 = stowed
_vehicle animate ["konkurs_hide_source", 0];  // Phase 0 = deployed
```

### Debug: Dump Animation Sources
```sqf
private _cfg = configFile >> "CfgVehicles" >> "rhs_bmp2d_msv";
private _anims = _cfg >> "AnimationSources";
{
    diag_log format["%1: source=%2 initPhase=%3",
        configName _x, getText(_x >> "source"), getNumber(_x >> "initPhase")];
} forEach configProperties [_anims, "isClass _x"];
```

### Animation Source Types
| source | Meaning |
|--------|---------|
| `user` | Controlled via `animate` command — ideal for scripted toggle |
| `reload` | Driven by weapon reload state |
| `ammo` | Driven by ammo count |
| `door` | Driven by door open/close actions |
| `Hit` | Driven by damage state |
| `revolving` | Driven by weapon revolving mechanism |

### BMP-2D Key Animations
| Animation | Source | Purpose |
|-----------|--------|---------|
| `konkurs_hide_source` | user | Show/hide Konkurs/Metis launcher |
| `launcher_reload` | user | Launcher tube raise/lower (mechanical) |
| `maljutka_hide_source` | user | Show/hide Maljutka launcher |
| `caps_hide` | ammo | Hide smoke cap covers |
| `recoil_source_2a42` | reload | 2A42 recoil animation |

### Important: `launcher_reload` vs `konkurs_hide_source`
- `launcher_reload` controls the **mechanical animation** (smooth raise/lower) but is tied to the reload system — overriding it via `animate` fights with the engine's reload behavior.
- `konkurs_hide_source` is an **instant show/hide** (selection visibility) — predictable and doesn't interfere with reload.

**Use `konkurs_hide_source` for toggle functionality.**

---

## 10. Magazine Management — Runtime Add/Remove

### Adding Magazines to Turret
```sqf
_vehicle addMagazineTurret ["rhs_mag_9m113M", [0]];  // [0] = main turret path
```

### Removing Magazines from Turret
```sqf
_vehicle removeMagazineTurret ["rhs_mag_9m113M", [0]];
```

### Counting Magazines
```sqf
private _count = {_x == "rhs_mag_9m113M"} count (_vehicle magazinesTurret [0]);
```

### Force Weapon to Load After Adding Magazines
**Critical**: `addMagazineTurret` adds magazines but does NOT automatically chamber a round. The weapon shows red (unloaded) text. You must explicitly load:
```sqf
_vehicle loadMagazine [[0], "rhs_weap_9m113", "rhs_mag_9m113M"];
// Args: [turretPath, weaponClass, magazineClass]
```

### Turret Paths
| Path | Turret |
|------|--------|
| `[0]` | Main turret (gunner) |
| `[0,0]` | First sub-turret (commander) |
| `[0,1]` | Second sub-turret |

---

## 11. ACE Interactions on Vehicles

### ACE_SelfActions on Vehicle Class
```cpp
class GOL_BMP2D: rhs_bmp2d_msv {
    class ACE_SelfActions {
        class GOL_ATGM {
            displayName = "ATGM Launcher";
            condition = "_player == (vehicle _player) turretUnit [0,0]";  // Commander only
            statement = "";
            icon = "";
            
            class GOL_ATGM_Deploy {
                displayName = "Deploy ATGM";
                condition = "!((vehicle _player) getVariable ['GOL_ATGM_Deployed', true])";
                statement = "[vehicle _player, true] call OKS_fnc_ToggleATGM";
                icon = "";
            };
        };
    };
};
```

### Turret Unit References
| Expression | Meaning |
|-----------|---------|
| `(vehicle _player) turretUnit [0]` | Gunner |
| `(vehicle _player) turretUnit [0,0]` | Commander |
| `driver (vehicle _player)` | Driver |

### ACE_SelfActions vs ACE_MainActions vs ACE_Actions
| Class | When Visible | Typical Use |
|-------|-------------|-------------|
| `ACE_SelfActions` | Self-interact menu (Ctrl+Win) | Actions the current player performs |
| `ACE_MainActions` | Looking at vehicle | External interaction with the vehicle |
| `ACE_Actions` | Looking at vehicle | More external actions |

---

## 12. Debug Commands Reference

All commands below are run in the **Debug Console** (Esc → Debug Console in Eden, or via the `-debug` launch parameter). Output goes to the **RPT log file** (see Section 12.1).

### 12.1 Where Does `diag_log` Output Go?

All `diag_log` output is written to the **Arma 3 RPT file**:
```
C:\Users\<username>\AppData\Local\Arma 3\<profile_name>.rpt
```

**Workflow**:
1. Run the dump command in Debug Console
2. Open the RPT file in a text editor (VS Code / Notepad++)
3. Scroll to the bottom — your output is at the end
4. Search for your marker string (e.g., `===`) to find the start of the dump

**Tip**: Add a marker line at the start of your dump so you can find it:
```sqf
diag_log "========== MY DUMP START ==========";
// ... your dump code ...
diag_log "========== MY DUMP END ==========";
```

`systemChat` shows in-game chat — useful for quick single values. `diag_log` is for bulk output.

---

### 12.2 Comprehensive Reference Vehicle Extractor

This is the **most important script**. Run this against any vanilla or modded vehicle to extract ALL values you need to replicate its optics/HUD setup. Change the class name at the top.

```sqf
// === COMPREHENSIVE VEHICLE OPTICS/HUD EXTRACTOR ===
// Change this to any vehicle class you want to study:
private _class = "B_APC_Wheeled_01_cannon_F";  // Badger

private _cfg = configFile >> "CfgVehicles" >> _class;
diag_log format["========== FULL DUMP: %1 ==========", _class];

// --- DRIVER ---
diag_log "";
diag_log "=== DRIVER ===";
diag_log format["driverForceOptics: %1", getNumber(_cfg >> "driverForceOptics")];
diag_log format["driverOpticsModel: %1", getText(_cfg >> "driverOpticsModel")];
diag_log format["driverOpticsColor: %1", getArray(_cfg >> "driverOpticsColor")];
diag_log format["driverOpticsEffect: %1", getArray(_cfg >> "driverOpticsEffect")];
diag_log format["driverInfoType: %1", getText(_cfg >> "driverInfoType")];
diag_log format["memoryPointDriverOptics: %1", getText(_cfg >> "memoryPointDriverOptics")];
diag_log format["LODDriverTurnedIn: %1", getNumber(_cfg >> "LODDriverTurnedIn")];
diag_log format["LODDriverOpticsIn: %1", getNumber(_cfg >> "LODDriverOpticsIn")];
{
    private _c = _x;
    diag_log format["  DriverOpticsIn/%1:", configName _c];
    diag_log format["    opticsModel: %1", getText(_c >> "opticsModel")];
    diag_log format["    initFov: %1  minFov: %2  maxFov: %3",
        getNumber(_c >> "initFov"), getNumber(_c >> "minFov"), getNumber(_c >> "maxFov")];
    diag_log format["    visionMode: %1", getArray(_c >> "visionMode")];
    diag_log format["    thermalMode: %1", getArray(_c >> "thermalMode")];
} forEach configProperties [_cfg >> "DriverOpticsIn", "isClass _x"];

// --- GUNNER (MainTurret) ---
private _gt = _cfg >> "Turrets" >> "MainTurret";
diag_log "";
diag_log "=== GUNNER (MainTurret) ===";
diag_log format["turretInfoType: %1", getText(_gt >> "turretInfoType")];
diag_log format["gunnerOpticsModel: %1", getText(_gt >> "gunnerOpticsModel")];
diag_log format["gunnerOpticsEffect: %1", getArray(_gt >> "gunnerOpticsEffect")];
diag_log format["gunnerForceOptics: %1", getNumber(_gt >> "gunnerForceOptics")];
diag_log format["memoryPointGunnerOptics: %1", getText(_gt >> "memoryPointGunnerOptics")];
diag_log format["memoryPointGun: %1", getText(_gt >> "memoryPointGun")];
diag_log format["weapons: %1", getArray(_gt >> "weapons")];
diag_log format["magazines: %1", getArray(_gt >> "magazines")];
diag_log format["primaryGunner: %1", getNumber(_gt >> "primaryGunner")];
diag_log format["primaryObserver: %1", getNumber(_gt >> "primaryObserver")];
diag_log format["showHMD: %1", getNumber(_gt >> "showHMD")];
diag_log format["stabilizedInAxes: %1", getNumber(_gt >> "stabilizedInAxes")];
diag_log format["nightVision: %1", getNumber(_gt >> "nightVision")];
diag_log format["forceNVG: %1", getNumber(_gt >> "forceNVG")];
diag_log format["LODOpticsIn: %1", getNumber(_gt >> "LODOpticsIn")];
diag_log format["LODOpticsOut: %1", getNumber(_gt >> "LODOpticsOut")];
diag_log format["body: %1", getText(_gt >> "body")];
diag_log format["gun: %1", getText(_gt >> "gun")];
diag_log format["animationSourceBody: %1", getText(_gt >> "animationSourceBody")];
diag_log format["animationSourceGun: %1", getText(_gt >> "animationSourceGun")];
diag_log format["discreteDistance: %1", getArray(_gt >> "discreteDistance")];
diag_log format["discreteDistanceInitIndex: %1", getNumber(_gt >> "discreteDistanceInitIndex")];

diag_log "  --- Gunner OpticsIn ---";
{
    private _c = _x;
    diag_log format["  OpticsIn/%1:", configName _c];
    diag_log format["    opticsDisplayName: %1", getText(_c >> "opticsDisplayName")];
    diag_log format["    gunnerOpticsModel: %1", getText(_c >> "gunnerOpticsModel")];
    diag_log format["    gunnerOpticsEffect: %1", getArray(_c >> "gunnerOpticsEffect")];
    diag_log format["    initFov: %1  minFov: %2  maxFov: %3",
        getNumber(_c >> "initFov"), getNumber(_c >> "minFov"), getNumber(_c >> "maxFov")];
    diag_log format["    visionMode: %1", getArray(_c >> "visionMode")];
    diag_log format["    thermalMode: %1", getArray(_c >> "thermalMode")];
    diag_log format["    initAngleX: %1  initAngleY: %2",
        getNumber(_c >> "initAngleX"), getNumber(_c >> "initAngleY")];
} forEach configProperties [_gt >> "OpticsIn", "isClass _x"];

diag_log "  --- Gunner OpticsOut ---";
{
    private _c = _x;
    diag_log format["  OpticsOut/%1:", configName _c];
    diag_log format["    initFov: %1  minFov: %2  maxFov: %3",
        getNumber(_c >> "initFov"), getNumber(_c >> "minFov"), getNumber(_c >> "maxFov")];
    diag_log format["    visionMode: %1", getArray(_c >> "visionMode")];
} forEach configProperties [_gt >> "OpticsOut", "isClass _x"];

// --- COMMANDER (CommanderOptics sub-turret) ---
private _ct = _gt >> "Turrets" >> "CommanderOptics";
diag_log "";
diag_log "=== COMMANDER (CommanderOptics) ===";
diag_log format["turretInfoType: %1", getText(_ct >> "turretInfoType")];
diag_log format["gunnerOpticsModel: %1", getText(_ct >> "gunnerOpticsModel")];
diag_log format["gunnerOpticsEffect: %1", getArray(_ct >> "gunnerOpticsEffect")];
diag_log format["gunnerForceOptics: %1", getNumber(_ct >> "gunnerForceOptics")];
diag_log format["memoryPointGunnerOptics: %1", getText(_ct >> "memoryPointGunnerOptics")];
diag_log format["memoryPointGun: %1", getText(_ct >> "memoryPointGun")];
diag_log format["weapons: %1", getArray(_ct >> "weapons")];
diag_log format["primaryGunner: %1", getNumber(_ct >> "primaryGunner")];
diag_log format["primaryObserver: %1", getNumber(_ct >> "primaryObserver")];
diag_log format["showHMD: %1", getNumber(_ct >> "showHMD")];
diag_log format["commanding: %1", getNumber(_ct >> "commanding")];
diag_log format["hasCommander: %1", getNumber(_ct >> "hasCommander")];
diag_log format["stabilizedInAxes: %1", getNumber(_ct >> "stabilizedInAxes")];
diag_log format["nightVision: %1", getNumber(_ct >> "nightVision")];
diag_log format["LODOpticsIn: %1", getNumber(_ct >> "LODOpticsIn")];
diag_log format["body: %1", getText(_ct >> "body")];
diag_log format["gun: %1", getText(_ct >> "gun")];
diag_log format["animationSourceBody: %1", getText(_ct >> "animationSourceBody")];
diag_log format["animationSourceGun: %1", getText(_ct >> "animationSourceGun")];

diag_log "  --- Commander OpticsIn ---";
{
    private _c = _x;
    diag_log format["  OpticsIn/%1:", configName _c];
    diag_log format["    opticsDisplayName: %1", getText(_c >> "opticsDisplayName")];
    diag_log format["    gunnerOpticsModel: %1", getText(_c >> "gunnerOpticsModel")];
    diag_log format["    gunnerOpticsEffect: %1", getArray(_c >> "gunnerOpticsEffect")];
    diag_log format["    initFov: %1  minFov: %2  maxFov: %3",
        getNumber(_c >> "initFov"), getNumber(_c >> "minFov"), getNumber(_c >> "maxFov")];
    diag_log format["    visionMode: %1", getArray(_c >> "visionMode")];
    diag_log format["    thermalMode: %1", getArray(_c >> "thermalMode")];
} forEach configProperties [_ct >> "OpticsIn", "isClass _x"];

diag_log "========== DUMP COMPLETE ==========";
```

---

### 12.3 Full Weapon Config Tree Dump (Recursive)

Dumps the ENTIRE config tree of a weapon including all inner classes (muzzles, fire modes, etc.). Essential for understanding multi-muzzle weapons before deciding on the split approach.

```sqf
// === RECURSIVE WEAPON CONFIG DUMP ===
private _weaponClass = "rhs_weap_2a42";  // Change to target weapon

diag_log format["========== WEAPON DUMP: %1 ==========", _weaponClass];
private _cfg = configFile >> "CfgWeapons" >> _weaponClass;

// Show inheritance chain first
private _chain = [];
private _c = _cfg;
while {isClass _c} do {
    _chain pushBack configName _c;
    _c = inheritsFrom _c;
};
diag_log format["Inheritance chain: %1", _chain];
diag_log "";

// Key parent-level properties
diag_log format["muzzles: %1", getArray(_cfg >> "muzzles")];
diag_log format["modes: %1", getArray(_cfg >> "modes")];
diag_log format["ballisticsComputer: %1", getNumber(_cfg >> "ballisticsComputer")];
diag_log format["magazines: %1", getArray(_cfg >> "magazines")];
diag_log format["magazineWell: %1", getArray(_cfg >> "magazineWell")];
diag_log format["displayName: %1", getText(_cfg >> "displayName")];
diag_log "";

// Recursive dump of all sub-classes and properties
private _fnc_dump = {
    params ["_cfg","_indent"];
    {
        private _name = _x;
        private _c = _cfg >> _name;
        if (isClass _c) then {
            diag_log format["%1class %2 {", _indent, _name];
            [_c, _indent + "  "] call _fnc_dump;
            diag_log format["%1}", _indent];
        } else {
            if (isNumber _c) then { diag_log format["%1%2 = %3", _indent, _name, getNumber _c] };
            if (isText _c) then { diag_log format["%1%2 = ""%3""", _indent, _name, getText _c] };
            if (isArray _c) then { diag_log format["%1%2 = %3", _indent, _name, getArray _c] };
        };
    } forEach configProperties [_cfg];
};
[_cfg, ""] call _fnc_dump;

diag_log "========== WEAPON DUMP END ==========";
```

**Example output** (abbreviated) for `rhs_weap_2a42`:
```
Inheritance chain: [rhs_weap_2a42, rhs_weap_2a42_base, CannonCore, LauncherCore, Default]
muzzles: [HE,AP]
ballisticsComputer: 0

class HE {
  ballisticsComputer = 0
  magazineWell = [RHS_AutoCannon_30mm_2A42_HE]
  class LowROFBMD2 {
    showToPlayer = 1
    reloadTime = 0.2      // 300 rpm
  }
  class HighROFBMD2 {
    showToPlayer = 1
    reloadTime = 0.1      // 600 rpm
  }
  class closeBMD2 { showToPlayer = 0 }
  ...
}
class AP {
  ballisticsComputer = 0
  ...
}
```

This output is what tells you:
- Inner muzzles override `ballisticsComputer = 0` → you can't just set it on the parent
- Two `showToPlayer = 1` modes exist per muzzle → that's why you see 4 weapons
- `muzzles = [HE,AP]` → multi-muzzle, needs the split approach

---

### 12.4 Weapon Inheritance Chain Tracer

Traces the full inheritance chain of a weapon/vehicle class and shows where each key property is defined. Invaluable for finding which ancestor class sets a value you need to override.

```sqf
// === INHERITANCE CHAIN TRACER ===
private _className = "rhs_weap_2a42";  // Change to any CfgWeapons or CfgVehicles class
private _root = "CfgWeapons";          // or "CfgVehicles"

private _cfg = configFile >> _root >> _className;
private _properties = ["ballisticsComputer","muzzles","modes","magazineWell","displayName"];

diag_log format["========== INHERITANCE TRACE: %1 ==========", _className];

// Walk the chain
private _current = _cfg;
while {isClass _current} do {
    diag_log format["--- %1 ---", configName _current];
    {
        private _prop = _x;
        private _p = _current >> _prop;
        // Only show if this class DEFINES it (not inherited)
        if (isNumber _p) then { diag_log format["  %1 = %2", _prop, getNumber _p] };
        if (isText _p) then { diag_log format["  %1 = ""%2""", _prop, getText _p] };
        if (isArray _p) then { diag_log format["  %1 = %2", _prop, getArray _p] };
    } forEach _properties;
    _current = inheritsFrom _current;
};

diag_log "========== TRACE END ==========";
```

---

### 12.5 Dump Vehicle Memory Points

Extracts all named selections (memory points) from a vehicle model. These are the points you can use for `memoryPointGunnerOptics`, `memoryPointGun`, etc.

```sqf
// === MEMORY POINT DUMP ===
private _veh = vehicle player;
private _type = typeOf _veh;
private _cfg = configFile >> "CfgVehicles" >> _type;

diag_log format["========== MEMORY POINTS: %1 ==========", _type];
diag_log format["Model: %1", getText(_cfg >> "model")];
diag_log format["Current memoryPointGunnerOptics (gunner): %1",
    getText(_cfg >> "Turrets" >> "MainTurret" >> "memoryPointGunnerOptics")];
diag_log format["Current memoryPointGunnerOptics (commander): %1",
    getText(_cfg >> "Turrets" >> "MainTurret" >> "Turrets" >> "CommanderOptics" >> "memoryPointGunnerOptics")];
diag_log "";
diag_log "All selections:";
{
    diag_log format["  %1", _x];
} forEach (selectionNames _veh);
diag_log "========== MEMORY POINTS END ==========";
```

---

### 12.6 Test a Memory Point Position in Real-Time

After dumping all memory points, test individual ones to see where they are in 3D space. This creates a helper object at the memory point location so you can visually inspect it.

```sqf
// === TEST MEMORY POINT POSITION ===
private _veh = vehicle player;
private _pointName = "ou3_bmp2";  // Change to the memory point you want to test

private _pos = _veh selectionPosition _pointName;
systemChat format["%1 → local pos: %2", _pointName, _pos];

// Create a visible marker at the world position
private _worldPos = _veh modelToWorld _pos;
private _helper = "Sign_Sphere25cm_F" createVehicle _worldPos;
_helper setPos _worldPos;
systemChat format["Helper placed at %1 — look for the orange sphere", _worldPos];

// Clean up after 30 seconds
[_helper] spawn { sleep 30; deleteVehicle (_this select 0); };
```

**Workflow**: Run this for each candidate memory point. If the sphere appears:
- Inside the vehicle hull → point is inside geometry (unusable)
- On the ground/floor → point is hull-mounted (doesn't follow turret)
- On top of the turret → candidate for commander optics
- Moving with turret rotation → point is on the correct bone ✓

---

### 12.7 Dump Animation Sources

Extracts ALL animation sources defined on a vehicle. Essential before attempting any show/hide or stow/deploy features.

```sqf
// === ANIMATION SOURCES DUMP ===
private _type = typeOf (vehicle player);  // Or hardcode: "rhs_bmp2d_msv"
private _cfg = configFile >> "CfgVehicles" >> _type;
private _anims = _cfg >> "AnimationSources";

diag_log format["========== ANIMATION SOURCES: %1 ==========", _type];
diag_log format["Total sources: %1", count configProperties [_anims, "isClass _x"]];
diag_log "";
{
    private _name = configName _x;
    private _source = getText(_x >> "source");
    private _initPhase = getNumber(_x >> "initPhase");
    private _animPeriod = getNumber(_x >> "animPeriod");
    // Get current runtime phase
    private _currentPhase = (vehicle player) animationPhase _name;
    diag_log format["%1: source=%2  initPhase=%3  animPeriod=%4  CURRENT=%5",
        _name, _source, _initPhase, _animPeriod, _currentPhase];
} forEach configProperties [_anims, "isClass _x"];
diag_log "========== ANIMATION SOURCES END ==========";
```

Key things to look for in the output:
- `source = "user"` → can be controlled with `animate` command (ideal for toggles)
- `source = "reload"` → driven by engine reload system (don't try to override)
- `animPeriod = 0` → instant transition
- `animPeriod > 0` → smooth animated transition over N seconds

---

### 12.8 Test Animation Phases at Runtime

Use these one-liners in Debug Console to test animation toggling:

```sqf
// Set an animation to a specific phase
(vehicle player) animate ["konkurs_hide_source", 1];   // Phase 1 = stowed
(vehicle player) animate ["konkurs_hide_source", 0];   // Phase 0 = deployed

// Check current phase
systemChat format["Phase: %1", (vehicle player) animationPhase "konkurs_hide_source"];

// Animate with custom speed (second arg = speed multiplier)
// (vehicle player) animate ["launcher_reload", 1, true];  // Instant
```

---

### 12.9 Dump Fire Modes (detailed)

Shows all fire modes of a weapon with the properties that matter for player visibility and rate of fire.

```sqf
// === FIRE MODES DUMP ===
private _weaponClass = "rhs_weap_2a42";  // Change to target weapon
private _cfg = configFile >> "CfgWeapons" >> _weaponClass;
private _modes = getArray(_cfg >> "modes");

diag_log format["========== FIRE MODES: %1 ==========", _weaponClass];
diag_log format["modes[]: %1", _modes];
diag_log "";
{
    private _modeName = _x;
    private _m = _cfg >> _modeName;
    if (isClass _m) then {
        private _show = getNumber(_m >> "showToPlayer");
        private _reload = getNumber(_m >> "reloadTime");
        private _rpm = if (_reload > 0) then {round(60 / _reload)} else {0};
        private _burst = getNumber(_m >> "burst");
        private _textType = getText(_m >> "textureType");
        private _dispName = getText(_m >> "displayName");
        diag_log format["%1: showToPlayer=%2  reloadTime=%3  rpm=%4  burst=%5  textureType=%6  displayName=%7",
            _modeName, _show, _reload, _rpm, _burst, _textType, _dispName];
    } else {
        diag_log format["%1: (not a class — may be inherited)", _modeName];
    };
} forEach _modes;
diag_log "========== FIRE MODES END ==========";
```

---

### 12.10 Magazine / Ammo State Inspector

Inspects current magazine state on all turrets of the current vehicle.

```sqf
// === MAGAZINE STATE INSPECTOR ===
private _veh = vehicle player;
diag_log format["========== MAGAZINES: %1 ==========", typeOf _veh];

// Main turret [0]
diag_log "--- Turret [0] (Gunner) ---";
{
    diag_log format["  %1", _x];
} forEach (_veh magazinesTurret [0]);

// Commander turret [0,0]
diag_log "--- Turret [0,0] (Commander) ---";
{
    diag_log format["  %1", _x];
} forEach (_veh magazinesTurret [0,0]);

// Weapons on each turret
diag_log "";
diag_log "--- Weapons on [0] ---";
{
    diag_log format["  %1", _x];
} forEach (_veh weaponsTurret [0]);

diag_log "--- Weapons on [0,0] ---";
{
    diag_log format["  %1", _x];
} forEach (_veh weaponsTurret [0,0]);

diag_log "========== MAGAZINES END ==========";
```

---

### 12.11 Scan for All HUD/Optics Resource Classes

Finds all `RscOptics` and `RscUnit` classes in the entire config tree — these are the valid values for `turretInfoType`.

```sqf
// === HUD CLASS SCANNER ===
diag_log "========== HUD/OPTICS CLASSES ==========";
private _count = 0;
{
    private _name = configName _x;
    if (_name find "RscOptics" >= 0 || _name find "RscUnit" >= 0) then {
        diag_log format["  %1", _name];
        _count = _count + 1;
    };
} forEach ("true" configClasses (configFile));
diag_log format["Total found: %1", _count];
diag_log "========== HUD SCAN END ==========";
```

---

### 12.12 Scan Vehicles by Turret HUD Type

Find all vehicles that use a specific `turretInfoType` — useful for discovering reference vehicles with the HUD style you want.

```sqf
// === FIND VEHICLES BY HUD TYPE ===
private _targetHUD = "RscOptics_APC_Wheeled_01_gunner";  // Change to target HUD class

diag_log format["========== VEHICLES USING: %1 ==========", _targetHUD];
{
    private _vehCfg = _x;
    private _gt = _vehCfg >> "Turrets" >> "MainTurret";
    if (isClass _gt) then {
        private _hud = getText(_gt >> "turretInfoType");
        if (_hud == _targetHUD) then {
            diag_log format["  %1  (%2)", configName _vehCfg, getText(_vehCfg >> "displayName")];
        };
    };
} forEach ("isClass _x" configClasses (configFile >> "CfgVehicles"));
diag_log "========== SEARCH END ==========";
```

---

### 12.13 Dump magazineWell Contents

Shows what magazines are available in a specific magazineWell — essential when splitting multi-muzzle weapons to know which well to assign.

```sqf
// === MAGAZINE WELL DUMP ===
private _wellName = "RHS_AutoCannon_30mm_2A42_HE";  // Change to target well

diag_log format["========== MAGAZINE WELL: %1 ==========", _wellName];
private _well = configFile >> "CfgMagazineWells" >> _wellName;
{
    private _group = _x;
    diag_log format["  Group: %1", configName _group];
    {
        diag_log format["    %1", _x];
    } forEach getArray _group;
} forEach configProperties [_well, "isArray _x"];
diag_log "========== MAGAZINE WELL END ==========";
```

---

### 12.14 Quick One-Liners for Debug Console

These are fast checks you can run without opening the RPT:

```sqf
// What vehicle am I in?
systemChat typeOf (vehicle player);

// What's my turret path?
systemChat str ((vehicle player) unitTurret player);

// What weapons does my turret have?
systemChat str ((vehicle player) weaponsTurret ((vehicle player) unitTurret player));

// What's the current zeroing?
systemChat str (currentZeroing player);

// What optics model am I using?
private _t = (vehicle player) unitTurret player;
private _cfg = configFile >> "CfgVehicles" >> typeOf (vehicle player);
private _turretCfg = [_cfg, _t] call BIS_fnc_turretConfig;
systemChat format["turretInfoType: %1", getText(_turretCfg >> "turretInfoType")];

// Check ballisticsComputer on current weapon
systemChat format["bc: %1", getNumber(configFile >> "CfgWeapons" >> (currentWeapon player) >> "ballisticsComputer")];

// Is ACE FCS enabled on this turret?
systemChat format["ace_fcs: %1", getNumber(_turretCfg >> "ace_fcs_Enabled")];

// Check a specific config value on current vehicle
systemChat format["primaryObserver: %1", getNumber(_turretCfg >> "primaryObserver")];

// Spawn a vehicle next to player for testing
private _v = "GOL_BMP2D" createVehicle (player modelToWorld [0,10,0]);

// Delete vehicle I'm looking at
deleteVehicle cursorObject;
```

---

## 13. Config Property Reference

### Turret-Level Properties
| Property | Effect |
|----------|--------|
| `gunnerForceoptics = 1` | Force player into optics view |
| `LodOpticsIn = 0` | LOD level for optics-in (MUST be 0) |
| `LodOpticsOut = 0` | LOD level for optics-out |
| `turretInfoType` | HUD overlay class name |
| `gunnerOpticsModel` | Reticle/frame 3D model (turret-level fallback) |
| `gunnerOpticsEffect[]` | Post-processing effects (aberration, blur) |
| `showHMD = 0` | Helmet-mounted display toggle |
| `primaryObserver = 1` | Enables turret direction indicator (commander) |
| `commanding = 2` | Commander authority level |
| `nightVision = 1` | Allow NVG usage |
| `forceNVG = 0` | Force NVG always on |
| `stabilizedInAxes = 3` | Full stabilization (both axes) |

### OpticsIn Class Properties
| Property | Effect |
|----------|--------|
| `opticsDisplayName` | Label shown in zoom indicator ("W", "M", "N") |
| `initFov` / `minFov` / `maxFov` | Zoom level (lower = more zoom) |
| `visionMode[]` | Available modes: `"Normal"`, `"NVG"`, `"Ti"` |
| `thermalMode[]` | Thermal imaging modes: `{0,1}` = WHOT+BHOT |
| `gunnerOpticsModel` | Per-zoom reticle model |

### Common FOV Values
| Level | FOV | Approximate Magnification |
|-------|-----|--------------------------|
| Wide | 0.6 | ~1.2x |
| Medium | 0.175 | ~4x |
| Narrow | 0.0583 | ~12x |
| Very Narrow | 0.0292 | ~24x |
| Ultra Narrow | 0.0146 | ~48x |

---

## 14. Common Pitfalls

### 1. "Undefined base class" on inner classes
**Cause**: Trying to inherit from a binarized PBO's inner class.
**Fix**: Define standalone (no inheritance) or use scripting.

### 2. Standalone AnimationSources wipes all parent animations
**Cause**: Non-inherited `class AnimationSources` replaces parent completely.
**Fix**: Don't override AnimationSources in config. Use `animate` at runtime.

### 3. NVG doesn't work on gunner optics
**Cause**: `visionMode[]` in OpticsIn Wide class is `{"Normal","Ti"}` — missing `"NVG"`.
**Fix**: Add `"NVG"` → `{"Normal","NVG","Ti"}`. Children inherit from Wide.

### 4. `addMagazineTurret` doesn't auto-load weapon
**Cause**: Engine adds magazine to storage but doesn't chamber it.
**Fix**: Call `loadMagazine` after adding magazines.

### 5. Commander camera inside geometry
**Cause**: Wrong `memoryPointGunnerOptics` — point is inside turret housing.
**Fix**: Use memory point dump to find one above/outside geometry. Try accessory mounts.

### 6. 4 weapons shown instead of 2
**Cause**: Parent has multiple `showToPlayer = 1` fire modes.
**Fix**: Override `modes[]` to include only the desired player mode.

### 7. Commander has no turret direction indicator
**Cause**: `primaryObserver = 0`.
**Fix**: Set `primaryObserver = 1`.

### 8. `memoryPointGun = "usti hlavne"` causes dual fire
**Cause**: Multiple weapons share the same muzzle flash point.
**Fix**: Use separate memory points, e.g., `"machinegun"` for PKT.

### 9. Driver sees 2D texture overlay
**Cause**: RHS `driverOpticsModel` points to a 2D periscope texture model.
**Fix**: Override with `optics_empty` or UGV camera model.

### 10. `DriverOpticsIn` uses wrong property name
**Cause**: Using `gunnerOpticsModel` instead of `opticsModel`.
**Fix**: Use `opticsModel` in `DriverOpticsIn` classes.

### 11. Editing the wrong `visionMode[]` (gunner vs commander)
**Cause**: Both gunner and commander turrets have `class Wide` with `visionMode[]`. They look identical in config. When editing manually (or via an AI agent), it's easy to hit the wrong one — e.g., changing the commander's Wide instead of the gunner's Wide.
**Fix**: Always verify by counting indentation levels or by checking the parent class chain. Gunner Wide is inside `MainTurret >> OpticsIn >> Wide`. Commander Wide is inside `MainTurret >> Turrets >> CommanderOptics >> OpticsIn >> Wide`. When in doubt, search for a unique nearby property (like `memoryPointGunnerOptics`) to confirm which turret you're in.

### 12. `selectionNames` returns hundreds of entries
**Cause**: `selectionNames` returns ALL named selections from ALL LODs (resolution, geometry, fire geometry, memory, etc.), not just memory points.
**Fix**: This is normal. The memory points you need are mixed in with geometry selections. Look for names that suggest camera/optic positions (`view_`, `commander`, `optic`, `sight`, `ou3`, etc.). Use Section 12.6 to visually test candidates.

---

## 15. Vehicle Armor — What You Can and Cannot Change

### The Two Safe Properties
These are **top-level** vehicle properties — you CAN override them on a child class without inner class issues:

| Property | What It Does | Stock `rhs_bmp2d_msv` | GOL_BMP2D (75% increase) |
|----------|-------------|----------------------|-------------------------|
| `armor` | Total vehicle HP pool (higher = survives more hits) | 300 | **525** |
| `armorStructural` | Damage multiplier for hits outside named HitPoints | 500 | *unchanged* |

```cpp
class GOL_BMP2D: rhs_bmp2d_msv {
    armor = 525;  // 300 * 1.75 = 525 (75% increase)
};
```

### Why Only `armor` Was Changed
- **`armor`** is the total HP pool — increasing it directly increases how many hits the vehicle survives. Straightforward, predictable, no side effects.
- **`armorStructural`** is a damage multiplier. In vanilla Arma 3 mechanics, **lower = more survivable** (it multiplies damage for hits that don't land on a named HitPoint). However, RHS reports a value of 500 which is far outside the vanilla range (~3–6), suggesting RHS uses their own damage model that may interpret this differently. **Left unchanged** to avoid unintended interactions with the RHS damage system.

### What You CANNOT Safely Change (Cross-PBO Problem)
All per-component armor values live inside `class HitPoints` — an inner class of the vehicle. The cross-PBO rule (Section 1) applies:

```cpp
// ❌ THIS WIPES ALL PARENT HITPOINTS:
class GOL_BMP2D: rhs_bmp2d_msv {
    class HitPoints {                  // Standalone = replaces parent entirely
        class HitHull { armor = 150; };  // Only HitHull exists now
        // HitEngine, HitFuel, HitTurret, tracks, crew — ALL GONE
    };
};

// ❌ THIS FAILS:
class GOL_BMP2D: rhs_bmp2d_msv {
    class HitPoints: HitPoints {       // "Undefined base class" error
        class HitHull { armor = 150; };
    };
};
```

To change individual HitPoint values, you would need to either:
1. **Redefine the ENTIRE HitPoints tree** (every single hitpoint from the parent, plus your changes) — tedious, fragile, breaks when RHS updates
2. **Use scripted approach** — `addEventHandler ["HandleDamage", ...]` to intercept and reduce damage at runtime
3. **Just increase `armor`** — simplest, most maintainable approach ✅

### Per-Component Properties (for reference, not safely overridable)
| HitPoint | Property | Effect |
|----------|----------|--------|
| `HitHull` | `armor` | Hull toughness |
| `HitEngine` | `armor` | Engine durability |
| `HitFuel` | `armor` | Fuel tank resistance |
| `HitLTrack` / `HitRTrack` | `armor` | Track durability |
| `HitTurret` | `armor` | Turret toughness |
| Any HitPoint | `passThrough` | How much damage bleeds through to vehicle HP (0–1, lower = less) |
| Any HitPoint | `explosionShielding` | Explosive damage multiplier (lower = more resistant) |
| Any HitPoint | `minimalHit` | Minimum damage threshold to register |

### Debug: Dump Armor Values
```sqf
// === ARMOR VALUES DUMP ===
private _type = typeOf (vehicle player);
private _cfg = configFile >> "CfgVehicles" >> _type;

diag_log format["========== ARMOR: %1 ==========", _type];
diag_log format["armor: %1", getNumber(_cfg >> "armor")];
diag_log format["armorStructural: %1", getNumber(_cfg >> "armorStructural")];
diag_log format["explosionShielding: %1", getNumber(_cfg >> "explosionShielding")];
diag_log "";

// Dump all HitPoints
private _hp = _cfg >> "HitPoints";
if (isClass _hp) then {
    {
        private _name = configName _x;
        diag_log format["  %1: armor=%2  passThrough=%3  explosionShielding=%4  minimalHit=%5",
            _name,
            getNumber(_x >> "armor"),
            getNumber(_x >> "passThrough"),
            getNumber(_x >> "explosionShielding"),
            getNumber(_x >> "minimalHit")];
    } forEach configProperties [_hp, "isClass _x"];
};
diag_log "========== ARMOR END ==========";
```

### Scripted Alternative: Damage Reduction Handler
If you need per-component tuning without redefining HitPoints, use a HandleDamage event handler:
```sqf
// Reduce all damage by 40% (applied in init or spawn script)
_vehicle addEventHandler ["HandleDamage", {
    params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
    private _currentDamage = _unit getHitIndex _hitIndex;
    private _incomingDamage = _damage - _currentDamage;
    // Reduce incoming damage by 40%
    _currentDamage + (_incomingDamage * 0.6)
}];
```
This approach is flexible but requires careful testing — it applies to ALL damage sources (bullets, explosions, collisions).

---

## 16. Complete ATGM Toggle System — Putting It All Together

This section shows how Sections 9, 10, and 11 combine into a complete feature. This is the actual working implementation.

### Design Decisions
- **`konkurs_hide_source`** for instant show/hide (not `launcher_reload` — see Section 9)
- **Remove ammo when stowed** — prevents firing an invisible weapon
- **3-second deploy delay** — gives the animation time to "deploy" before ammo appears
- **Default state: deployed (`true`)** — matches the vehicle's spawn state (launcher visible)
- **Commander-only** — restricted via ACE condition to turret path `[0,0]`
- **`loadMagazine` after adding** — required or weapon shows unloaded (see Section 10)
- **Stored mag count** tracked via `setVariable` — preserves partial ammo state
- **`CBA_fnc_waitAndExecute`** — non-blocking delay (doesn't freeze the game)

### Complete ACE_SelfActions Config
Both Deploy AND Stow actions, with the parent menu:
```cpp
class GOL_BMP2D: rhs_bmp2d_msv {
    class ACE_SelfActions {
        class GOL_ATGM {
            displayName = "ATGM Launcher";
            condition = "_player == (vehicle _player) turretUnit [0,0]";  // Commander only
            statement = "";
            icon = "";
            
            class GOL_ATGM_Deploy {
                displayName = "Deploy ATGM";
                // Default var is true (deployed), so this shows when stowed (false)
                condition = "!((vehicle _player) getVariable ['GOL_ATGM_Deployed', true])";
                statement = "[vehicle _player, true] call OKS_fnc_ToggleATGM";
                icon = "";
            };
            class GOL_ATGM_Stow {
                displayName = "Stow ATGM";
                // Shows when deployed (true, which is the default)
                condition = "(vehicle _player) getVariable ['GOL_ATGM_Deployed', true]";
                statement = "[vehicle _player, false] call OKS_fnc_ToggleATGM";
                icon = "";
            };
        };
    };
};
```

**Key detail**: The default value for `GOL_ATGM_Deployed` is `true` in both conditions. This means on a freshly spawned vehicle (where the variable hasn't been set yet), the launcher is considered "deployed" — which matches the model's visual state (launcher visible at spawn).

### Complete fn_ToggleATGM.sqf Script
```sqf
/*
 * Toggle Konkurs/Metis ATGM launcher on GOL_BMP2D.
 * Uses konkurs_hide_source for instant show/hide.
 * Removes ATGM magazines when stowed, restores with 3s delay when deployed.
 *
 * Arguments:
 *   0: Vehicle <OBJECT>
 *   1: Deploy (true) or Stow (false) <BOOL>
 *
 * Called from ACE self-interaction on commander seat.
 */

params ["_vehicle", "_deploy"];

private _turretPath = [0];
private _atgmMag = "rhs_mag_9m113M";

if (_deploy) then {
    // --- Deploy: show launcher, wait 3s, then restore ammo ---
    _vehicle animate ["konkurs_hide_source", 0];   // Phase 0 = visible
    _vehicle setVariable ["GOL_ATGM_Deployed", true, true];  // 3rd true = broadcast to all clients
    systemChat "ATGM Deploying...";

    [{
        params ["_vehicle", "_turretPath", "_atgmMag"];
        // Safety check: if player stowed again during the 3s delay, abort
        if !(_vehicle getVariable ["GOL_ATGM_Deployed", false]) exitWith {};

        // Restore the saved number of magazines
        private _stored = _vehicle getVariable ["GOL_ATGM_StoredMags", 4];
        for "_i" from 1 to _stored do {
            _vehicle addMagazineTurret [_atgmMag, _turretPath];
        };
        _vehicle setVariable ["GOL_ATGM_StoredMags", nil, true];

        // Force weapon to load a magazine (otherwise shows red "unloaded")
        _vehicle loadMagazine [_turretPath, "rhs_weap_9m113", _atgmMag];

        systemChat "ATGM Ready";
    }, [_vehicle, _turretPath, _atgmMag], 3] call CBA_fnc_waitAndExecute;
    //  ↑ args     ↑ params passed to code    ↑ delay in seconds

} else {
    // --- Stow: remove ammo, hide launcher ---
    // Count current magazines before removing
    private _count = {_x == _atgmMag} count (_vehicle magazinesTurret _turretPath);
    _vehicle setVariable ["GOL_ATGM_StoredMags", _count, true];

    // Remove all ATGM magazines from the turret
    for "_i" from 1 to _count do {
        _vehicle removeMagazineTurret [_atgmMag, _turretPath];
    };

    _vehicle animate ["konkurs_hide_source", 1];   // Phase 1 = hidden
    _vehicle setVariable ["GOL_ATGM_Deployed", false, true];
    systemChat "ATGM Stowed";
};
```

### CfgFunctions Registration
```cpp
class OKS_Vehicles_GroundVehicles {
    file = "OKS_GOL_Misc\functions\vehicles\groundVehicles";
    class ToggleATGM {};
};
```
This makes the function callable as `OKS_fnc_ToggleATGM`.

### CBA_fnc_waitAndExecute Pattern
This is the CBA-standard way to do a non-blocking delay:
```sqf
[{
    // Code to run after delay
    params ["_arg1", "_arg2"];
    // ... do stuff ...
}, [_arg1, _arg2], DELAY_SECONDS] call CBA_fnc_waitAndExecute;
```
- Does NOT block the game (unlike `sleep` which requires `spawn`)
- Arguments are passed as an array in the second parameter
- The code block receives them via `params`
- Runs in the **scheduled** environment

---

## 17. Final Working Configuration

### Files Modified
| File | Changes |
|------|---------|
| `configs/CfgWeapons.cpp` | GOL_weap_2a42_HE, GOL_weap_2a42_AP, GOL_weap_pkt |
| `configs/CfgVehicles.cpp` | GOL_BMP2D class with full turret tree |
| `configs/CfgFunctions.cpp` | ToggleATGM function registration |
| `config.cpp` | CfgPatches weapons[] registration |
| `functions/vehicles/groundVehicles/fn_ToggleATGM.sqf` | ATGM deploy/stow script |

### Feature Summary
| Feature | Implementation |
|---------|---------------|
| FCS auto-range (lasing) | Split single-muzzle weapons with bc=18 + Laserdesignator_mounted |
| HE/AP toggle | Weapon switch (two separate weapons) |
| 5 zoom levels | W(0.6), M(0.175), N(0.0583), VN(0.0292), UN(0.0146) |
| Gunner NVG + Thermals | visionMode = {"Normal","NVG","Ti"} on Wide class |
| Commander independent optics | Standalone turret on obsturret bone, ou3_bmp2 memory point |
| Commander turret indicator | primaryObserver = 1 |
| Badger-style HUD | APC_Wheeled_01 gunner + MBT_01 commander HUD types |
| Per-zoom optics models | Badger gunner + commander reticle models |
| Driver camera view | UGV camera model, driverForceOptics = 1, NVG support |
| ATGM deploy/stow | ACE self-action + magazine management + konkurs_hide_source animation |
| Triple ammo | 3x HE (1020 rds) + 3x AP (480 rds) |
| Armor upgrade | armor = 525 (75% increase over RHS stock 300) |

---

## Workflow for New Vehicle

### Phase 1: Reconnaissance (all debug console)
1. **Spawn the target vehicle** and get in as gunner/commander
2. **Run Section 12.2** (Comprehensive Extractor) against the target vehicle — understand its current setup
3. **Run Section 12.3** (Weapon Config Dump) on its weapons — understand muzzle structure, bc values
4. **Run Section 12.9** (Fire Modes) — find unwanted `showToPlayer = 1` modes
5. **Run Section 12.5** (Memory Points) — dump all model selections for later
6. **Run Section 12.7** (Animation Sources) — find user-controllable animations
7. **Run Section 12.13** (Magazine Wells) — understand ammo groupings

### Phase 2: Find a Reference Vehicle
8. **Run Section 12.11** (HUD Scanner) — list all available HUD classes
9. **Run Section 12.2** against your chosen reference vehicle (Badger, Kamysh, etc.) — extract every value you need
10. **Compare** the two dumps side by side — identify what to copy

### Phase 3: Build
11. **Create weapon wrappers** if needed (Section 2) — split multi-muzzle weapons for FCS
12. **Override `modes[]`** to remove unwanted fire modes (Section 3)
13. **Build turret config** — standalone, NO inner class inheritance (Section 1)
14. **Copy HUD/optics values** from reference dump — `turretInfoType`, `gunnerOpticsModel` per zoom level
15. **Set `visionMode[]` on Wide class** — include all three: `{"Normal","NVG","Ti"}`

### Phase 4: Test Iteratively
16. **Test memory points** (Section 12.6) — place helper spheres, check bone attachment
17. **Test animation toggling** (Section 12.8) — verify stow/deploy phases
18. **Test magazine management** (Section 12.10) — verify ammo loads correctly
19. **Use one-liners** (Section 12.14) — quick sanity checks in-game

### Phase 5: Polish
20. **Add runtime features** — ATGM toggle, ammo management via scripted ACE actions
21. **Register in CfgPatches** — all custom weapons and vehicles
22. **Test all seats** — driver, gunner, commander, cargo

---

*Document created: February 2026*
*Vehicle: GOL_BMP2D (based on rhs_bmp2d_msv)*
*Addon: OKS_GOL_Misc*