# IR Illuminator Implementation Notes

## Overview

GOL_OX3000_II and GOL_OX3000_LR_II now use **scripted light sources** instead of built-in `Flashlight` class configs. This prevents `isFlashlightOn` from returning `true`, eliminating the engine-level AI detection boost.

## Why Scripted Lights?

**The Problem:**
Arma 3's `irLight = 1` flashlight parameter is **broken** - AI CAN see these "IR" lights despite the flag.
Only IR laser **beams** (Pointer class) are truly invisible to AI.

**The Solution:**
Use empty Flashlight configs and create scripted `#lightpoint` objects triggered by IR laser activation.
- Empty `class Flashlight {};` → `isFlashlightOn = false` → no engine AI boost
- IR laser ON → create scripted light → visible through NVGs but AI can't see it
- IR laser OFF → delete scripted light

## How It Works

### Config Changes (ALL IR Modes)
- **ALL IR modes** (dual + _II): `class Flashlight {};` - Empty, no built-in light
- **_FL Modes**: Normal visible flashlights (`irLight = 0`)
- **Pointer class**: IR laser beam (trigger for scripted lights)

### Script System (Multiplayer-Aware)
1. **Monitor Loop** (`fn_IRIlluminator_Monitor.sqf`):
   - Runs client-side at 0.15s intervals
   - **Creates lights for BOTH dual and _II modes** when IR laser is ON
   - Monitors ALL nearby players (not just self) like BettIR
   - Checks `isIRLaserOn` (activation trigger)
   - Creates/destroys `#lightpoint` dynamically per player
   - Uses `createVehicleLocal` (no network traffic)
   - **Different intensities**:
     - Dual: 250/500 (moderate, simulating original configs)
     - _II: 4000/8000 (MUCH stronger, dedicated illuminators)
   - **BettIR Patching**: When _II modes active, overrides BettIR goggle light intensity
   - Result: Everyone sees everyone's IR illuminators ✓

2. **CBA Settings** (`fn_IRIlluminator_InitSettings.sqf`):
   - `GOL_IRIlluminator_Enabled` - Master switch (default: true)
   - `GOL_IRIlluminator_Intensity` - _II mode intensity (default: 4000)
   - `GOL_IRIlluminator_Intensity_LR` - _II long range intensity (default: 8000)
   - `GOL_IRIlluminator_Brightness` - _II mode brightness (default: 8)
   - `GOL_IRIlluminator_MaxDistance` - Render distance for teammates (default: 150m)
   - `GOL_IRIlluminator_Debug` - Debug mode (default: false)
   - Note: Dual mode intensities are hardcoded (250/500) to simulate original configs

### Result
- **ALL IR Modes**: isFlashlightOn = `false` (empty configs) ✓
- **AI Detection**: No engine boost, AI can't see scripted IR lights ✓
- **NVG Illumination**: Fully functional ✓
- **Multiplayer**: Teammates see each other's IR lights ✓
- **Dual Modes**: Moderate intensity (250/500) ✓
- **_II Modes**: MUCH stronger (4000/8000) + BettIR patch ✓
- **Performance**: No network traffic (local lights only) ✓
- **Configurable**: _II intensity adjustable via CBA ✓

## BettIR Integration

GOL automatically patches BettIR goggle lights when _II modes are active.

**How it works:**
- When any player activates _II mode (GOL_OX3000_II or GOL_OX3000_LR_II)
- GOL sets unit variables: `BETT_IR_light_intensity` and `BETT_IR_light_brightness`
- BettIR reads these variables and adjusts its goggle light accordingly
- Result: BettIR's goggle light matches GOL's stronger intensity (4000-8000 vs default ~2000)

**Behavior:**
- Base dual modes (GOL_OX3000, GOL_OX3000_LR): Use built-in configs, BettIR goggle uses defaults
- _II modes (GOL_OX3000_II, GOL_OX3000_LR_II): Empty configs + GOL scripted lights + boosted BettIR goggle
- Works automatically if BettIR is loaded, no manual patching needed
- Each client handles this independently (no network sync required)

**Code location:**
See `fn_IRIlluminator_Monitor.sqf` lines ~117-123 for the patching logic.

## Comparison

| Method | isFlashlightOn | AI Can See | Light Source | Intensity | BettIR Patch |
|--------|----------------|------------|--------------|-----------|------------|
| GOL Dual | FALSE ✓ | NO ✓ | Scripted (IR laser ON) | 250/500 | No |
| GOL _II | FALSE ✓ | NO ✓ | Scripted (IR laser ON) | 4000/8000 | Yes ✓ |
| GOL _FL | TRUE | YES ❌ | Built-in flashlight | Config | No |
| BettIR Default | FALSE ✓ | NO ✓ | Goggle light | ~2000 | N/A |
| Arma irLight=1 | TRUE | **YES ❌** | Built-in (broken) | Config | No |

**IMPORTANT:**
- Arma 3's `irLight = 1` is **BROKEN** - AI CAN see these lights
- Only IR laser **beams** (Pointer class) are invisible to AI
- Solution: Empty Flashlight configs + scripted lights triggered by IR laser

**Key Points:**
- **Dual** (GOL_OX3000, GOL_OX3000_LR): Moderate intensity (250/500), AI can't see
- **_II** (GOL_OX3000_II, GOL_OX3000_LR_II): MUCH stronger (4000/8000), patches BettIR, AI can't see
- **_FL**: Visible flashlight, AI CAN see it, triggers stealth penalty
- **Multiplayer**: All clients create local lights for all nearby players (BettIR approach)

## Testing Notes

1. **Verify isFlashlightOn**:
   ```sqf
   hint str (player isFlashlightOn (currentWeapon player));
   // Should show "false" when using _II mode
   ```

2. **Check Light Intensity**:
   ```sqf
   {
       systemChat format ["Light: %1, Intensity: %2", typeOf _x, lightIntensity _x];
   } forEach (attachedObjects player);
   ```

3. **AI Detection Test**:
   - Stand in pitch black with _II mode active
   - AI should NOT have improved detection
   - Compare with _FL mode (visible flashlight) - AI should react faster

## Rollback Procedure

If scripted lights cause issues, revert to built-in config:

1. Uncomment old `class Flashlight { ... }` in compat_ace_irlight.hpp
2. Remove/comment new empty `class Flashlight {};`
3. Disable monitor: `GOL_IRIlluminator_Enabled = false;`

## Performance

- Monitor loop: 0.15s interval (balanced for multiplayer)
- Light creation: Only when state changes
- Distance culling: Default 150m (configurable via `GOL_IRIlluminator_MaxDistance`)
- No network traffic (all lights created locally via `createVehicleLocal`)
- Memory: ~1-2 light objects per visible player with IR active
- CPU impact: Minimal (hashmap tracking + distance checks)

**Scaling:**
- 10 players with IR: ~10 lights per client
- 50 players with IR: Limited by 150m distance culling
- Large ops: Reduce `MaxDistance` to 50-75m for better performance
