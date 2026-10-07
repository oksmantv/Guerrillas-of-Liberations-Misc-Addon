# Stealth System Lighting Upgrade

## Changes Made

### 1. **Precise Lighting Detection** (replaces simple sun/moon check)
- Now uses `getLightingAt` command to measure **actual light levels** at player position
- Accounts for ambient light + dynamic lights (fires, flashlights, streetlights, vehicle lights)
- Works correctly indoors and in artificially lit areas

### 2. **Granular Darkness Levels** (5 distinct light brackets)

| Level | Light Value | Camo Default | Audible Default | Description |
|-------|-------------|--------------|-----------------|-------------|
| **Pitch Black** | 0-20 | 0.05 | 0.4 | Nearly invisible, sounds harder to locate |
| **Very Dark** | 20-50 | 0.12 | 0.55 | Extremely hard to see |
| **Dark** | 50-100 | 0.25 | 0.7 | Hard to see |
| **Dim** | 100-200 | 0.6 | 0.85 | Reduced visibility |
| **Lit** | 200+ | 1.0 | 1.0 | Normal visibility |

### 3. **Vegetation Concealment System**
- Uses `nearestTerrainObjects` to detect BUSH, TREE, SMALL TREE, HIDE within configurable radius
- Default: 2+ vegetation objects within 2.5m provides 0.7× camo multiplier (30% harder to spot)
- Stacks with darkness and stance bonuses
- **Example:** Pitch black (0.05) + prone (×0.8) + in bushes (×0.7) = **0.028 camo coefficient**

### 4. **Much Lower Minimum Values**
- Removed artificial floor of 0.35 - now allows values as low as 0.01
- **Safety minimum** set to 0.01 (configurable) to prevent complete invisibility exploits
- Extreme stealth possible with combined bonuses

### 5. **Flashlight Penalty**
- Using visible flashlight multiplies camo by **8x** (up to max 2.5)
- Makes you highly visible even in darkness when using lights
- IR lasers don't trigger this penalty (only visible lights)

### 6. **Enhanced Debug Info**
- Watch variables now track:
  - `lightLevel` - total light (ambient + dynamic)
  - `ambientLight` - environmental lighting
  - `dynamicLight` - artificial lights
  - `darknessLevel` - text label of current bracket
  - `vegetationMul` - concealment multiplier from vegetation
  - `vegetationCount` - number of nearby vegetation objects
- Detection logs show actual light levels when spotted

## CBA Settings Organization

Settings now organized into clear categories:

- **GOL Stealth / Player - General**: Enable/disable, update interval
- **GOL Stealth / Player - Camouflage**: 
  - All 5 darkness levels
  - Stance multipliers
  - Absolute minimum
  - **Vegetation concealment** (enable, radius, threshold, multiplier)
- **GOL Stealth / Player - Audible**: All 5 darkness levels, weather effects

## Default Values (Very Aggressive Stealth)

**Camouflage:**
- Pitch Black: 0.05 (20x harder to see than default)
- Very Dark: 0.12 (8x harder)
- Dark: 0.25 (4x harder)
- Dim: 0.6
- Lit: 1.0 (normal)

**Audible:**
- Pitch Black: 0.4 (sounds 60% harder to locate)
- Very Dark: 0.55
- Dark: 0.7
- Dim: 0.85
- Lit: 1.0 (normal)

**Stance Multipliers:**
- Prone: ×0.8
- Crouch: ×0.9
- Stand: ×1.05

**Vegetation:**
- Radius: 2.5m
- Threshold: 2 objects
- Multiplier: 0.7× (30% harder to spot)

## Calculation Formula

```
Final Camo = (Base Darkness Value × Stance Multiplier × Vegetation Multiplier)
Then: Apply Flashlight Penalty if active (×8)
Then: Clamp to [Absolute Min, 3.0]
```

**Example - Perfect Stealth:**
- Pitch black night: 0.05
- Prone in bushes: ×0.8 ×0.7
- **Result: 0.028** (36x harder to detect than normal!)

**Example - Compromised:**
- Pitch black: 0.05
- Standing with flashlight: ×1.05 ×8
- **Result: 0.42** (actually easier to spot than normal conditions)

## Key Philosophy

**No uniform consideration** - You're stealthy regardless of what you wear. It's about:
1. **Lighting** - Darkness is your friend
2. **Positioning** - Use vegetation and terrain
3. **Discipline** - Stay low, no lights

## Integration with GOL Framework

Your difficulty module's `playerCamoCoef` is **intentionally bypassed** when stealth system is active via the `GOL_OKS_Stealth_Mission` flag check in `fnc_setDetectionCoef.sqf`. This prevents conflicts and allows the stealth system to have full control.

## Testing Recommendations

1. Test at different times of day: noon, dusk, night
2. Test near fires and artificial lights
3. Test indoors vs outdoors
4. Test with NVGs on AI vs without
5. **Test in vegetation** - bushes, forests, tall grass
6. Test prone in bushes at night (should be nearly invisible)
7. Check debug watch: `missionNamespace getVariable "OKS_Stealth_PlayerVisibility_Watch"`

## Compared to Dynamic Camo System

| Feature | DYNCAS | OKS GOL Stealth |
|---------|--------|-----------------|
| **Lighting** | getLightingAt ✓ | getLightingAt ✓ |
| **Texture Matching** | ✓ RGB comparison | ✗ Uniform-agnostic |
| **Minimum Camo** | 0.6 hardcoded | 0.01 configurable |
| **Darkness Bonus** | ×0.8 | 5-level gradient |
| **Vegetation** | ✗ | ✓ nearestTerrainObjects |
| **Ghillie Bonus** | Config detection | Not implemented |
| **AI Behavior** | None | Radio, sentries, tracking |
| **Weather Audio** | None | Rain/overcast reduces sound |

We took DYNCAS's precise lighting measurement and extended it with vegetation detection and much more aggressive darkness bonuses. Perfect for tactical night ops.
