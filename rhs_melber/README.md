# GOL MELB (RHS Little Bird Variant)

This folder contains a **GOL**-namespaced variant of the RHS MELB Little Bird config.

## In‑game class

- Vehicle classname: `GOL_MELB_AH6M`
- Display name: `AH-6M Little Bird (GOL)`

Inheritance and behavior are intentionally kept the same as the source config; the goal of this first pass is simply: **it loads and appears in Eden without config name conflicts**.

## Kimi HMDs

- `OKS_GOL_Misc` requires `Kimi_UI`.
- `OKS_GOL_Misc` does **not** require `Kimi_HMDs_RHS`.
- HMD support is implemented for `GOL_MELB_AH6M` inside the main addon config (GOL-only patching; no RHS classnames are modified).

## What changed (namespacing)

The following addon-defined classes were renamed to avoid clashing with RHS’ own `RHS_*` / `rhs_*` classnames:

- `CfgPatches`: `GOL_melber`
- `CfgVehicles`: `GOL_MELB_base`, `GOL_MELB_AH6M`
- `EventHandlers` helper: `GOL_MELB_EH`
- Eden attributes (vehicle customization): `GOL_MELB_TailNumber`, `GOL_MELB_NoFear`, `GOL_MELB_SGDM`, `GOL_MELB_SN_Nose`, `GOL_MELB_clan`, `GOL_MELB_ToggleBoy`
- Eden attributes (pylon extension toggles): `GOL_ExtLongL`, `GOL_ExtLongR`
- Support classes: `GOL_FakeMagazine_MELB`, `GOL_Laserdesignator_MELB`, `GOL_ammo_127x99_SLAP`

## Good values to tweak later (from this config)

This is a curated list of config values already present in this file that are commonly adjusted to create a “different” variant.

### Identity / editor presence

- `scope` / `scopeCurator`: Controls whether the class is visible in Eden and Zeus. (`scope = 2` is editor-visible.)
- `displayName`: The name shown in Eden/Zeus.
- `editorPreview`, `picture`, `icon`: The preview image and UI icons used in editor and UI lists.
- `faction`, `side`, `crew`: Determines what faction list it appears under, which side it belongs to, and what unit spawns in the pilot seat.

### Seating / transport

- `transportSoldier`: How many passengers the vehicle can carry.
- `cargoAction[]`, `cargoGetInAction[]`, `cargoGetOutAction[]`: Passenger animations and entry/exit actions.
- `memoryPointsGetInDriver*`, `memoryPointsGetInCargo*`: Which model memory points are used for get-in and their directions.
- `getInProxyOrder[]`, `cargoProxyIndexes[]`: Which proxies are used and in what order the game fills them.

### Sensors / targeting / awareness

- `LockDetectionSystem`, `incomingMissileDetectionSystem`: What warning/lock systems the vehicle has.
- `irTarget`, `irTargetSize`, `visualTarget`, `visualTargetSize`, `radarTarget`, `radarTargetSize`: How “detectable” the helicopter is to different sensor types.
- `receiveRemoteTargets`, `reportRemoteTargets`, `reportOwnPosition`: Datalink behavior.
- `class Components > class SensorsManagerComponent`: Per-sensor tuning.
  - `IRSensorComponent`, `VisualSensorComponent`, `ActiveRadarSensorComponent`: Detection arcs and ranges.
  - `minRange` / `maxRange` (AirTarget/GroundTarget): Core detection distances.
  - `angleRangeHorizontal`, `angleRangeVertical`, `aimDown`: Sensor field of view.

### Weapons / pylons / loadouts

- `weapons[]`, `magazines[]`: What the vehicle spawns with by default.
- `class Components > class TransportPylonsComponent`:
  - `UIPicture`: Pylon layout image shown in Eden.
  - `class pylons > pylonX`:
    - `hardpoints[]`: Which weapon types can mount on that pylon.
    - `attachment`: Default store on that pylon.
    - `maxweight`: Weight limit.
    - `UIposition[]`: Where it appears on the Eden pylon UI.
  - `class Presets`: Named preconfigured loadouts.

### Flight model / handling

- `maxSpeed`: The max forward speed cap.
- `fuelCapacity`, `fuelConsumptionRate`: Range/endurance.
- `slingLoadMaxCargoMass`: Slingloading capacity.
- `liftForceCoef`, `cyclicAsideForceCoef`, `cyclicForwardForceCoef`, `backrotorforcecoef`: Control authority / helicopter handling feel.
- `sensitivity`, `bodyFrictionCoef`: General responsiveness and damping.

If RTD is enabled:

- `class RotorLibHelicopterProperties`:
  - `RTDconfig`: The RotorLib XML used for advanced flight.
  - `maxTorque`, `defaultCollective`, throttle timing fields: Engine/rotor response characteristics.
  - Stress limits (`maxMainRotorStress`, etc.) and stall warning speed: RTD damage and warnings.

### Survivability / damage behavior

- `destrType`: How it behaves on destruction (wreck type).
- `class EventHandlers`:
  - `handleDamage`: Hooks for custom damage handling (here used for fall damage).
  - `postInit`: Used here to reapply textures.

### Visual customization (Eden Attributes)

These attributes are wired to model animations and scripts:

- `GOL_MELB_TailNumber`: Runs `RHS_MELB_fnc_tailNumber` to swap the tail-number texture selection.
- `GOL_MELB_NoFear`, `GOL_MELB_SGDM`, `GOL_MELB_SN_Nose`, `GOL_MELB_clan`: Toggles specific decals/overlays.
- `GOL_MELB_ToggleBoy`: Toggles the bobblehead.
- Pylon extension: forced ON by default via `AnimationSources` (`ExtLongL` / `ExtLongR`), and no Eden attribute is exposed to toggle it.

### Sound set

- `soundEngineOnInt/Ext`, `soundEngineOffInt/Ext`, `class Sounds`: Defines which samples play and how volume/frequency scale with rotor speed/thrust.

---

## Notes / next steps

- You mentioned the pilot camera overlay not supporting ultrawide. Once this variant is confirmed loading cleanly, we can look at the MFD/PiP/UI resources involved (typically `RscUnitInfo*`, MFD config, render targets, and UI safezone usage) and find what is hard-coded.
