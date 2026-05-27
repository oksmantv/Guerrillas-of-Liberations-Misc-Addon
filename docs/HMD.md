# GOL Ghost Hawk HMD / MFD / TGP System — Reference Document

This document covers the complete Helmet-Mounted Display (HMD), MFD layer system, and Targeting Pod (TGP / `pilotCamera`) implementation used across all GOL laser-equipped helicopter variants.  It consolidates everything learned during the multi-session development of this system so that future changes can be made with confidence.

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [MFD Class Hierarchy](#2-mfd-class-hierarchy)
3. [helmetMountedDisplay and the TGP Visibility Problem](#3-helmetmounteddisplay-and-the-tgp-visibility-problem)
4. [pilotCamera / TGP System](#4-pilotcamera--tgp-system)
5. [ballisticsComputer Bitmask](#5-ballisticscomputer-bitmask)
6. [MFD Bone Source Reference](#6-mfd-bone-source-reference)
7. [User Variables (user0–user6)](#7-user-variables-user0user6)
8. [CCIP System — Normal Flight View](#8-ccip-system--normal-flight-view)
9. [GOL_TGP_HMD — Camera Direction Reticle](#9-gol_tgp_hmd--camera-direction-reticle)
10. [Kimi HMD Layer Summary](#10-kimi-hmd-layer-summary)
11. [GOL Vehicle Reference](#11-gol-vehicle-reference)
12. [Known Limitations and Do-Not-Touch Items](#12-known-limitations-and-do-not-touch-items)
13. [Bug History and Fixes](#13-bug-history-and-fixes)

---

## 1. System Overview

GOL laser-equipped helicopters combine two separate display systems:

| System | Rendered by | Visible in TGP? |
|---|---|---|
| **Kimi HMD** — full attitude/flight symbology | `helmetMountedDisplay = 1` MFD layers | ❌ (engine limitation) |
| **GOL custom CCIP** — cannon/rocket cross | `helmetMountedDisplay = 1` MFD layers | ❌ (engine limitation) |
| **GOL_TGP_HMD** — TGP camera direction dot | `helmetMountedDisplay = 1` MFD layer | ❌ (engine limitation — intentional, see §9) |
| **Vanilla pilotOpticsShowCursor cursor** | Arma 3 engine (RSC optics overlay) | ✅ (only exists in TGP view) |

The Kimi HMD is a community-made high-quality helicopter HMD.  GOL extends it by:
- Overriding the Ghost Hawk's Kimi classes in `kimi_hmd_ghost_hawk.hpp`
- Adding weapons CCIP layers in `kimi_hmd_weapons_ccip.hpp`
- Adding a TGP-direction circle in `GOL_TGP_HMD` (defined in `gol_helicopters.hpp`)
- Adding a pilot cannon CCIP class `GOL_HMD_CCIP_Cannon_P` (defined in `gol_helicopters.hpp`)
- Configuring `pilotCamera` with `pilotOpticsShowCursor = 1` for vanilla TGP CCIP

All files are under `configs/compat/`:

| File | Role |
|---|---|
| `gol_helicopters.hpp` | GOL vehicle classes, `pilotCamera`, GOL custom MFD layers |
| `kimi_hmd_ghost_hawk.hpp` | Full Kimi HMD redefinition for the Ghost Hawk |
| `kimi_hmd_weapons_ccip.hpp` | Kimi HMD weapons CCIP (pilot rockets, copilot rockets + cannon boresight) |
| `kimi_hmd_had_common.hpp` | Kimi HAD common — range text (`R X.XX km`) for all seats |

---

## 2. MFD Class Hierarchy

### How MFD layers are structured

In `CfgVehicles`, each vehicle has a `class MFD`.  Every direct child class of `class MFD` is an **independent MFD layer**.  Layers do not inherit from each other by default.

```cpp
class MFD {
    class Layer_A { ... };  // drawn independently
    class Layer_B { ... };  // drawn independently
    #include "kimi_hmd_ghost_hawk.hpp"  // expands to multiple top-level classes
};
```

Each layer specifies:
- **Canvas corners** (`topLeft`, `topRight`, `bottomLeft`) — memory points on the vehicle model defining the screen rectangle.  For HMD layers these are set to the head-up-display memory points (`HUD_top_left`, etc.).
- **`helmetMountedDisplay`** — world-space projection mode (see §3).
- **`turret[]`** — which crew seat(s) see this layer (see below).
- **`class Bones`** — positional anchors computed per frame from data sources.
- **`class Draw`** — drawable elements (lines, text, circles) positioned relative to bones.
- **`condition`** — global per-layer visibility math expression.

### turret[] Seat Targeting

| Value | Meaning |
|---|---|
| `{-1}` | Pilot seat only |
| `{0}` | Copilot / gunner seat only |
| `{}` | All seats |
| `{-2}` | Nobody — effectively suppresses the layer |

The `AirplaneHUD` layer that Arma normally renders for armed helicopter variants is suppressed with `turret[] = {-2}` in the GOL Ghost Hawk to avoid it overlapping the Kimi HMD.

### Condition Expressions

Conditions are math expressions evaluated per frame to a float.  Non-zero = visible.

| Expression | Meaning |
|---|---|
| `"on"` or `"1"` | Always visible |
| `"off"` or `"0"` | Always hidden |
| `"mgun"` | 1 when pilot's currently selected weapon is type `MachineGun` (includes M230) |
| `"rockets"` | 1 when rockets selected |
| `"on*user0"` | 1 when HMD toggle (user0) is on |
| `"user0"` | Same as above |

Conditions can be nested: a `Draw` block has a condition, and individual elements inside can have their own `condition` that is AND-evaluated with the Draw block.

---

## 3. helmetMountedDisplay and the TGP Visibility Problem

### What it does

When `helmetMountedDisplay = 1`, the MFD layer is projected in **world space anchored to the pilot's head direction**.  The canvas (`HUD_top_left` etc.) is treated as a plane floating in front of the pilot's eyes.  As the pilot looks left/right, elements stay locked to their head orientation — this is what creates the realistic "HMD floating in view" effect.

Three parameters control the head offset for correct parallax calibration:

```cpp
helmetPosition[] = {-0.04, 0.04, 0.1};  // left, up, forward (metres, eye offset)
helmetRight[]    = {0.08, 0, 0};          // canvas right vector scale
helmetDown[]     = {0, -0.08, 0};         // canvas down vector scale
```

### Why HMD elements disappear in TGP camera

When the pilot enters `pilotCamera` mode:
1. The **rendering eye position** shifts from the pilot's head to the camera's physical location (the `memoryPointDriverOptics` model memory point — typically a stub wing or light fixture).
2. All `helmetMountedDisplay = 1` projections are still computed relative to the original head position but rendered from the new eye position.
3. The angle difference causes all helmet-mounted elements to project **off-screen**.

**This is an Arma 3 engine limitation.  There is no config workaround.**  Do not attempt to re-enable Kimi HMD elements inside the TGP view — they will always be off-screen when `pilotCamera` is active.

The vanilla CCIP cursor (`pilotOpticsShowCursor`) is part of the RSC optics overlay, not an MFD layer, so it is unaffected by this limitation.

---

## 4. pilotCamera / TGP System

### Key config properties (on the vehicle)

```cpp
// Location of the camera origin in 3D model space.
// Must point to a memory point on the model.
memoryPointDriverOptics = "light_l";

// Full-screen RSC optics resource rendered when the pilot enters pilotCamera.
// SIDE EFFECT: helmetMountedDisplay=1 MFD elements are NOT rendered in TGP view.
driverWeaponsInfoType = "RscOptics_CAS_01_TGP";
```

### pilotCamera class structure

```cpp
class pilotCamera {
    class OpticsIn {
        class Wide   { opticsZoomInit = 0.574; ... };  // FOV ≈30° (WFOV)
        class Medium { opticsZoomInit = 0.115; ... };  // FOV ≈6°  (MFOV)
        class Narrow { opticsZoomInit = 0.038; ... };  // FOV ≈2°  (NFOV)
    };
    // Renders vanilla CCIP cursor inside TGP view.
    // See §5 for conditions under which cursor appears by weapon type.
    pilotOpticsShowCursor = 1;
    controllable = 1;  // pilot can slew the camera with the mouse
};
```

Each `OpticsIn` subclass supports `Normal`, `NVG`, and `Ti` vision modes.

### How weapon selection interacts with TGP

When entering `pilotCamera`, Arma auto-selects the `Laserdesignator_pilotCamera` weapon.  The pilot's previously selected weapon (M230 cannon or rockets) is **not deselected** — it is only suppressed for the `mgun`/`rockets` condition in MFD layers.  The `pilotOpticsShowCursor` cursor is calculated against the weapon that was active before entering TGP, which is why the cannon cross appears in the optics when M230 was the last selected weapon.

### pilotOpticsShowCursor behavior by weapon type

| Weapon `cursorAim` type | Condition for cursor in optics |
|---|---|
| `"rocket"` (LauncherCore) | **Always shown** — engine-native, no config dependency |
| `"mg"` / `"cannon"` (MachineGun) | **Only shown when** the weapon's `ballisticsComputer` has bit 8 set |

This means rockets always produce a cursor in the TGP view.  For the M230 cannon, `ballisticsComputer = 26` (bits 1+3+4) is required — without bit 3 (value 8) the cannon cross is invisible in TGP even with `pilotOpticsShowCursor = 1`.

---

## 5. ballisticsComputer Bitmask

`ballisticsComputer` is a bitmask property set on **weapon classes** (`CfgWeapons`).  Each bit enables a different targeting computer feature.

| Bit | Value | Name | Effect |
|---|---|---|---|
| 0 | 1 | AAA lead indicator | Anti-aircraft lead targeting dot |
| 1 | 2 | CCIP | Continuously Computed Impact Point marker in normal HUD/MFD |
| 2 | 4 | CCRP | Continuously Computed Release Point (unguided bombs) |
| **3** | **8** | **FCS optics cursor** | **Enables cannon/mgun cursor in `pilotOpticsShowCursor` optics view** |
| 4 | 16 | FCS auto-zeroing | Auto-zeroes weapon to target range |

### GOL M230 value

```cpp
ballisticsComputer = 26;    // 2 (CCIP) + 8 (FCS optics cursor) + 16 (FCS zeroing)
```

### Reference: vanilla A-10 cannon

`Gatling_30mm_Plane_CAS_01_F` (A-10 CAS plane gun) has `ballisticsComputer = 8` — bit 3 only.  This is how it shows a cursor in the aircraft's camera view.

### BMP-2D weapons (no TGP)

`GOL_weap_2a42_HE`, `GOL_weap_2a42_AP`, `GOL_weap_pkt` all use `ballisticsComputer = 18` (bits 1+4 = CCIP + auto-zeroing).  These vehicles have no `pilotCamera`, so bit 3 is not needed.

---

## 6. MFD Bone Source Reference

Bones are positional/directional anchors defined in `class Bones`.  Each bone has a `source` that feeds it data.

| Source | Type | Description |
|---|---|---|
| `"forward"` | vector | Aircraft nose direction — used for artificial horizon and pitch lines |
| `"impactpoint"` | vector | **World-space** ballistic impact point.  Moves continuously with ballistics.  Falls back to canvas center (boresight) when no valid impact (aiming at sky). |
| `"impactpointtoview"` | vector | **View-space projection** of the ballistic impact point.  Places the marker exactly where the round will land on screen.  Falls back to canvas center when invalid. |
| `"pilotcameratoview"` | vector | Direction the `pilotCamera` is pointing, expressed in pilot's view space.  Used for `GOL_TGP_HMD` to show the pilot where the TGP is looking. |
| `"weapontoview"` | vector | Where the currently aimed weapon points in view space.  **Caution:** on stub-wing helicopters (Ghost Hawk with pylons) weapons are fixed forward — this bone always points at screen center regardless of the aircraft's attitude, making it useless for boresight indication. |
| `"weapon"` | vector | Weapon aim direction (world space, not view-projected). |
| `"velocity"` | vector | Aircraft velocity vector. |
| `"velocityToView"` | vector | Velocity vector projected to view space. |
| `"turret"` | vector | Copilot/gunner turret aim direction. |
| `"target"` | vector | Locked target world position. |
| `"targetToView"` | vector | Target position projected to view space. |
| `"wppoint"` | vector | Waypoint direction. |
| `"wppointtoview"` | vector | Waypoint projected to view space. |
| `"forward"` | vector | Aircraft forward vector. |
| `"horizonBank"` | rotational | Roll/bank angle — drives horizon line rotation. |
| `"vspeed"` | linear | Vertical speed (m/s). |
| `"speed"` | linear | Forward airspeed. |
| `"altitudeAGL"` | linear | Altitude above ground. |
| `"gmeterX"` | linear | Lateral G-force. |
| `"gmeterZ"` | linear | Longitudinal G-force. |

### Bone types

| Type | Meaning |
|---|---|
| `"fixed"` | Static anchor at a fixed canvas position |
| `"vector"` | Follows a directional source; `pos0` = origin, `pos10` = point at range 10 |
| `"linear"` | 1D linear interpolation from `minPos` to `maxPos` |
| `"rotational"` | Rotates around a center point |
| `"horizon"` | Pitch/bank line at a given angle |
| `"limit"` | Clamps child bone outputs to a rectangle |
| `"scale"` | Scales a range; `lineXleft`/`lineYright` control a bar element |

---

## 7. User Variables (user0–user6)

`defaultUserMFDvalues[]` on the vehicle sets the initial state of per-vehicle user variables.  These can be changed in-mission by scripts or the Kimi HMD interface.

### Ghost Hawk default values

```cpp
defaultUserMFDvalues[] = {0, 1, 0, 0, 1, 0, 0.2};
//                        ^  ^  ^  ^  ^  ^  ^
//                        |  |  |  |  |  |  user6 = alpha (0.2)
//                        |  |  |  |  |  user5 = B (0 = not blue)
//                        |  |  |  |  user4 = G (1 = green)
//                        |  |  |  user3 = R (0 = not red)
//                        |  |  user2 = (unused by Kimi HMD)
//                        |  user1 = (Kimi internal — leave 1)
//                        user0 = HMD on/off toggle (0 = OFF by default)
```

The result is: HMD **off by default**, color = **green** (R=0, G=1, B=0), alpha = **0.2**.

### Variable usage in MFD Draw blocks

```cpp
color[] = {"user3", "user4", "user5"};  // RGB from user variables
alpha = "user6";                         // alpha from user variable
condition = "on*user0";                  // only draw when user0=1 (HMD on)
```

The Kimi HMD interface (if present in the mission) lets the pilot cycle colors and toggle the HMD.  `user0` is the master switch.

---

## 8. CCIP System — Normal Flight View

### How CCIP works in MFD

The engine computes a ballistic trajectory for the currently selected weapon every frame and exposes its impact point via the `impactpointtoview` source.  An MFD element anchored to this bone tracks exactly where the round will land on the screen.

**Fallback behavior:** When there is no valid impact point (weapon aimed at the sky, level flight above effective range), both `impactpoint` and `impactpointtoview` fall back to canvas center (0.5, 0.5) = boresight.  The cross will drift to boresight; this is normal engine behavior.

### GOL_HMD_CCIP_Cannon_P (pilot cannon CCIP, `turret[] = {-1}`)

This custom MFD layer provides the pilot with a cannon CCIP cross in normal (non-TGP) flight.  It is **separate** from the vanilla `pilotOpticsShowCursor` cursor in TGP.

```
helmetMountedDisplay = 1
helmetPosition[] = {-0.04, 0.04, 0.1}
helmetRight[]    = {0.08, 0, 0}
helmetDown[]     = {0, -0.08, 0}
```

**Draw structure:**
- Global `condition = "on*user0"` — requires HMD to be on
- Inner `Cannon_Cross` group with `condition = "mgun"` — only when M230 (or other mgun type) is selected
- `GUN_X`: 4-arm hollow cross drawn at `CCIP_2_VIEW` bone
  - Line width: 3
  - Arm half-lengths: outer ±0.026, inner gap ±0.010 (adjusted -15% from original for less visual clutter)
- `Distance`: numeric text below the cross
  - Source: `ImpactDistance` (in metres)
  - Scale: 0.001
  - Positioned at `y + 0.035` below the CCIP cross

**Bone:**
```cpp
class CCIP_2_VIEW: CCIP {
    source = "impactpointtoview";
};
```

### Kimi_HMD_Weapons — Copilot cannon boresight distance (turret[] = {0})

The copilot sees the cannon CCIP through `Kimi_HMD_Weapons`.  Key points:
- `Gun_Cross` group with `condition = "mgun"` — only the **distance text** is drawn; the GUN_X cross shape was removed because stub-wing fixed weapons caused the cross to always appear at boresight.
- `Gunner_AIM` has `condition = "off"` — this was a boresight `+` symbol driven by `weapontoview`.  On stub-wing helicopters, fixed-forward weapons made `weapontoview` always point at screen center, drawing a constant `+` regardless of weapon selection.  Forced off.

### Pilot and Copilot Rocket CCIP (Kimi_HMD_RKT_P / Kimi_HMD_RKT_C)

Both rocket CCIP layers use `source = "impactpointtoview"` for the sight center and `source = "weapon"` for the weapon aim direction.  Both were sized **+15%** larger than the original Kimi default:
- `RocketSight` line width: 6.5 (was ~5.7)
- Point arm lengths: ±0.015 / ±0.021 / ±0.017

---

## 9. GOL_TGP_HMD — Camera Direction Reticle

This custom MFD layer shows the pilot **where the TGP camera is currently pointing** when flying normally (outside TGP view).

```cpp
// Shown to all crew (turret[] = {})
helmetMountedDisplay = 1;
```

**Bone:**
```cpp
class TargetingPodDir {
    type = "vector";
    source = "pilotcameratoview";
    pos0[]  = {0.5, 0.5};
    pos10[] = {"0.500 + 0.2165", "0.500 + 0.2165"};
};
```

`source = "pilotcameratoview"` gives the camera's world-space direction expressed in the pilot's current view space.  As the pilot turns their head the projected position of the reticle shifts, always landing where the camera is actually pointed.

**Draw:** 24-segment dashed circle at `TargetingPodDir` position.
- Color: `{user3, user4, user5}` — follows the Kimi HMD color setting
- Condition: `"on*user0"` — only shown when HMD is on

**Why it's invisible in TGP view:** `helmetMountedDisplay = 1` — the same engine limitation that hides Kimi HMD (§3).  This is intentional; the reticle's purpose is to help the pilot *find* where the camera is pointing *before* entering TGP view.  There is no equivalent needed inside the TGP view because you are already looking through the camera.

---

## 10. Kimi HMD Layer Summary

All classes defined in `kimi_hmd_ghost_hawk.hpp` and referenced HPPs.  All use `helmetMountedDisplay = 1`.

| Class | Source file | turret[] | Description |
|---|---|---|---|
| `Kimi_HMD_Common` | `kimi_hmd_ghost_hawk.hpp` | `{0}` (copilot) | Heading tape, altitude, airspeed, attitude, G-force, waypoint tape, turret tape, slip ball |
| `Kimi_HMD_Decluttered` | `kimi_hmd_ghost_hawk.hpp` | `{0}` (copilot) | Decluttered mode — minimal symbology |
| `Kimi_HMD_Transport` | `kimi_hmd_ghost_hawk.hpp` | `{0}` (copilot) | Transport mode HMD |
| `Kimi_HMD_Pilot` | `kimi_hmd_ghost_hawk.hpp` | `{-1}` (pilot) | Full pilot HMD — attitude, airspeed, altitude, speed boxes |
| `Kimi_HMD_Modes_Pilot` | `kimi_hmd_ghost_hawk.hpp` | `{-1}` (pilot) | Mode annunciators for pilot |
| `Kimi_HMD_Weapons` | `kimi_hmd_weapons_ccip.hpp` | `{0}` (copilot) | Copilot cannon boresight distance + gunner aim |
| `Kimi_HMD_RKT_P` | `kimi_hmd_weapons_ccip.hpp` | `{-1}` (pilot) | Pilot rocket CCIP cross |
| `Kimi_HMD_RKT_C` | `kimi_hmd_weapons_ccip.hpp` | `{0}` (copilot) | Copilot rocket CCIP cross |
| `Kimi_HMD_HAD_Common` | `kimi_hmd_had_common.hpp` | `{}` (all) | Range display `R X.XX km` for all seats |
| `GOL_HMD_CCIP_Cannon_P` | `gol_helicopters.hpp` (inline) | `{-1}` (pilot) | Pilot cannon CCIP cross + distance text |
| `GOL_TGP_HMD` | `gol_helicopters.hpp` (inline) | `{}` (all) | TGP camera direction circle reticle |

The `AirplaneHUD` layer inherited from vanilla armed Ghost Hawk is suppressed:
```cpp
class AirplaneHUD { turret[] = {-2}; };
```

---

## 11. GOL Vehicle Reference

All GOL TGP helicopters are defined in `configs/compat/gol_helicopters.hpp` and included inside `CfgVehicles {}` via `CfgVehicles.cpp`.

### memoryPointDriverOptics

This memory point is the **physical origin of the TGP camera** in the 3D model.  It must match where the laser designator visually appears on the model.  Getting this wrong causes the camera to appear from the wrong location or renders the optics from inside geometry.

| Class | Real vehicle | memoryPointDriverOptics | Notes |
|---|---|---|---|
| `GOL_Heli_Transport_01_pylons_laser_base` | UH-80 Ghost Hawk (stub wings) | `"light_l"` | Left stub wing light — where TGP pod sits |
| `GOL_Heli_Transport_01_laser` | UH-80 Ghost Hawk (plain) | `"light_l_end"` | End of left light fixture |
| `GOL_Heli_Light_01_dynamicLoadout_laser` | AH-6 Pawnee | `"light_pos"` | Light position memory point |
| `GOL_Heli_Light_02_dynamicLoadout_laser` | KA-60 Kasatska | `"light_r_pos"` | Right light position |
| `GOL_Heli_Light_03_dynamicLoadout_laser` | AW159 Wildcat | `"laserstart"` | Dedicated laser start memory point |

### MFD override: which vehicles have custom MFD

| Class | Has custom MFD override? | Includes GOL_TGP_HMD? | Includes GOL_HMD_CCIP_Cannon_P? |
|---|---|---|---|
| `GOL_Heli_Transport_01_pylons_laser_base` | ✅ Full override | ✅ | ✅ |
| `GOL_Heli_Transport_01_laser` | ❌ Inherits Kimi defaults | ❌ | ❌ |
| `GOL_Heli_Light_01_dynamicLoadout_laser` | ❌ Inherits Kimi defaults | ❌ | ❌ |
| `GOL_Heli_Light_02_dynamicLoadout_laser` | ✅ Own MFD with `GOL_TGP_HMD` | ✅ | ❌ |
| `GOL_Heli_Light_03_dynamicLoadout_laser` | ✅ Own MFD with Kimi + `GOL_TGP_HMD` | ✅ | ❌ |

### FOV levels (Ghost Hawk pilotCamera)

| Level | Class name | opticsZoomInit | Approx FOV |
|---|---|---|---|
| Wide | `Wide` | 0.574 | ~30° |
| Medium | `Medium` | 0.115 | ~6° |
| Narrow | `Narrow` | 0.038 | ~2° |

---

## 12. Known Limitations and Do-Not-Touch Items

### Heading tape — DO NOT MODIFY

The Kimi heading tape in `Kimi_HMD_Common` uses `type = "scale"` with a `lineXleft`/`lineYright` base expression.  **`pos[y]` only moves the number labels** — it does not move the tape bar itself.  The tape bar's Y position is controlled by the base value of `lineXleft`/`lineYright`.

Current values (fully reverted to original Kimi defaults):
```cpp
lineXleft = "0.03 + 0.085";
lineYright = "0.02 + 0.085";
pos y = "0.060";
```

The tape is already positioned at the HUD edge.  Any attempt to move it further will either detach the labels from the bar or clip it off-screen.  This work was investigated and abandoned.  **Do not attempt to move the heading tape.**

### HMD not visible in TGP view — ENGINE LIMITATION

`helmetMountedDisplay = 1` elements cannot be rendered inside `pilotCamera` view.  This applies to all Kimi HMD classes, `GOL_HMD_CCIP_Cannon_P`, and `GOL_TGP_HMD`.  There is no config workaround.  The vanilla `pilotOpticsShowCursor` cursor (RSC-level) is the correct mechanism for CCIP inside TGP.

### weapontoview on stub-wing helicopters

On the Ghost Hawk with stub wings, all pilot weapons are physically fixed in forward-looking mounts.  The `weapontoview` bone source always returns screen center regardless of flight attitude or weapon selection.  Any boresight element using `weapontoview` will draw a persistent marker at screen center — it cannot be used for meaningful weapon aiming indication on this aircraft.

### Laserdesignator_pilotCamera auto-select

When entering `pilotCamera`, Arma always auto-selects `Laserdesignator_pilotCamera`.  The `mgun`/`rockets` conditions in MFD layers evaluate to 0 in TGP view because those weapons are no longer selected.  This is correct behavior — the only CCIP visible in TGP is from `pilotOpticsShowCursor`.

---

## 13. Bug History and Fixes

### Bug 1 — Persistent boresight `+` on copilot screen (FIXED)

**Symptom:** A cross/`+` was permanently visible at screen center in the copilot's HMD, regardless of weapon selection.

**Root cause:** `Kimi_HMD_Weapons` (copilot) had a `Gunner_AIM` bone using `source = "weapontoview"`.  On the stub-wing Ghost Hawk, all weapons are forward-fixed, so `weapontoview` always points at screen center.  The boresight `+` was therefore always drawn.

**Fix:** `Gunner_AIM > condition = "off"` in `kimi_hmd_weapons_ccip.hpp`.

---

### Bug 2 — AirplaneHUD overlapping Kimi HMD (FIXED)

**Symptom:** Vanilla armed-helicopter `AirplaneHUD` layer was drawing its own primitive HUD on top of the Kimi HMD, producing double symbology.

**Root cause:** The GOL Ghost Hawk inherits from an armed base class that includes `AirplaneHUD`.  GOL's MFD override did not suppress it.

**Fix:** Added `class AirplaneHUD { turret[] = {-2}; };` inside the GOL Ghost Hawk's `class MFD`.

---

### Bug 3 — Cannon cursor not visible in TGP camera (FIXED, this session)

**Symptom:** In `pilotCamera` view with `pilotOpticsShowCursor = 1`, rocket CCIP cursor appeared correctly but the M230 cannon produced no cursor at all.

**Root cause:** `pilotOpticsShowCursor` shows cannon/mgun cursors **only when** `ballisticsComputer` on the weapon has bit 3 (value 8) set.  `GOL_weapon_M230_ChainGun` had `ballisticsComputer = 18` (bits 1+4 = CCIP + FCS-zeroing) — missing bit 3.  Rocket weapons use `cursorAim = "rocket"` which the engine treats unconditionally, bypassing the `ballisticsComputer` check.

**Evidence:** Vanilla `Gatling_30mm_Plane_CAS_01_F` (A-10 gun) has `ballisticsComputer = 8` (bit 3 only) and shows a cursor in the A-10's camera view.

**Fix:** `ballisticsComputer = 26` on `GOL_weapon_M230_ChainGun` (added bit 3, keeping bits 1 and 4):
```cpp
ballisticsComputer = 26;    // 2 (CCIP) + 8 (FCS optics cursor) + 16 (FCS zeroing)
```

---

*Document maintained alongside `gol_helicopters.hpp`, `kimi_hmd_ghost_hawk.hpp`, `kimi_hmd_weapons_ccip.hpp`, `kimi_hmd_had_common.hpp`.*
