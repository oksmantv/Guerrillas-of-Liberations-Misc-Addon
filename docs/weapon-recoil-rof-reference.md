# GOL Machinegun & AT Weapon Reference — Recoil & Rate of Fire

> **Purpose:** Rebalancing reference. All GOL machineguns currently share one recoil preset
> regardless of caliber. This document maps current values to support per-class tuning.

---

## Recoil Presets (CfgRecoils)

| Preset | kickBack | muzzleOuter | temporary | Used by |
|---|---|---|---|---|
| `GOL_recoil_machinegun` | {0.04, 0.07} | {0.2, 0.4, 0.1, 0.05} | 0.008 | All GOL MGs (standing) |
| `GOL_recoil_machinegun_prone` | {0.03, 0.0525} | {0.15, 0.3, 0.075, 0.0375} | 0.006 | All GOL MGs (prone) |

**Field meanings:**
- `kickBack` — rearward displacement per shot `[min, max]`
- `muzzleOuter` — angular dispersion `[inner_min, inner_max, outer_min, outer_max]`; higher = more muzzle climb
- `temporary` — duration of sway effect (seconds)

> **Current problem:** A .338 LWMMG and a 5.56 M249 both use identical recoil presets.

---

## Machineguns

### Summary Table

| Class | Display Name | Caliber | Recoil Preset | reloadTime (s) | ~RPM | Source |
|---|---|---|---|---|---|---|
| `GOL_MMG_01_tan_F` | HK121 9.3mm (Tan/GOL) | 9.3×64mm | `GOL_recoil_machinegun` | inherited | ~649 | parent `MMG_01_tan_F` |
| `GOL_MMG_01_hex_F` | HK121 9.3mm (Hex/GOL) | 9.3×64mm | `GOL_recoil_machinegun` | inherited | ~649 | parent `MMG_01_hex_F` |
| `GOL_MMG_02_black_F` | LWMMG .338 (Black/GOL) | .338 Norma Mag | `GOL_recoil_machinegun` | **0.0923** | **~649** | explicitly set |
| `GOL_MMG_02_camo_F` | LWMMG .338 (Camo/GOL) | .338 Norma Mag | `GOL_recoil_machinegun` | **0.0923** | **~649** | explicitly set |
| `GOL_MMG_02_sand_F` | LWMMG .338 (Sand/GOL) | .338 Norma Mag | `GOL_recoil_machinegun` | **0.0923** | **~649** | explicitly set |
| `GOL_weap_pkm` | PKM (GOL) | 7.62×54mmR | `GOL_recoil_machinegun` | inherited | ~700 | parent `rhs_weap_pkm` |
| `GOL_weap_pkp` | PKP (GOL) | 7.62×54mmR | `GOL_recoil_machinegun` | inherited | ~700 | parent `rhs_weap_pkp` |
| `GOL_LMG_Zafir_F` | Zafir 7.62mm (GOL) | 7.62×51mm NATO | `GOL_recoil_machinegun` | inherited | ~600 | parent `LMG_Zafir_F` |
| `GOL_weap_fnmag` | FN MAG (GOL) | 7.62×51mm NATO | `GOL_recoil_machinegun` | inherited | ~850 | parent `rhs_weap_fnmag` |
| `GOL_MG3_KWS_B` | MG3 KWS (GOL) | 7.62×51mm NATO | `GOL_recoil_machinegun` | inherited | ~1200 | parent `UK3CB_MG3_KWS_B` |
| `GOL_weap_m249_pip` | M249 PIP (GOL) | 5.56×45mm NATO | `GOL_recoil_machinegun` | inherited | ~850 | parent `rhs_weap_m249_pip` |

> `reloadTime` in Arma 3: seconds between shots. RPM = 60 / reloadTime.  
> "Inherited" values are estimates from parent mod (RHS/UK3CB/vanilla); no override exists in GOL config.

---

### Per-Weapon Detail

#### GOL_MMG_01 — HK121 9.3mm (Navid)
- **Classes:** `GOL_MMG_01_tan_F`, `GOL_MMG_01_hex_F`
- **Caliber:** 9.3×64mm — heaviest infantry MG in the set
- **Real-world ROF:** 600–700 RPM
- **GOL ROF:** ~649 RPM (inherited; parent Navid uses 0.0923s)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** none (ball + tracers only)
- **Notes:** Heaviest caliber among infantry MGs. Candidate for strongest recoil tier.

#### GOL_MMG_02 — LWMMG .338 Norma Magnum
- **Classes:** `GOL_MMG_02_black_F`, `GOL_MMG_02_camo_F`, `GOL_MMG_02_sand_F`
- **Caliber:** .338 Norma Magnum
- **Real-world ROF:** ~500 RPM
- **GOL ROF:** ~649 RPM (`reloadTime = 0.0923` — explicitly set, faster than real)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** `GOL_B_338_Ball_AP` — hit=21, caliber=1.65 (~70% .50 cal), 860 m/s
- **Notes:** High-caliber, overspeed in-game. Candidate for increased recoil + reduced ROF to real ~500 RPM (reloadTime ≈ 0.12).

#### GOL_weap_pkm / GOL_weap_pkp — PKM / PKP
- **Classes:** `GOL_weap_pkm`, `GOL_weap_pkp`
- **Caliber:** 7.62×54mmR
- **Real-world ROF:** PKM 650–800 RPM, PKP 650 RPM
- **GOL ROF:** ~700 RPM (inherited from RHS parent)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** none (ball + tracers only)
- **Notes:** Mid-tier. PKP is a bipod-equipped sustained-fire version — recoilProne could be reduced further.

#### GOL_LMG_Zafir_F — Zafir 7.62×51mm
- **Class:** `GOL_LMG_Zafir_F`
- **Caliber:** 7.62×51mm NATO
- **Real-world ROF:** 600–1000 RPM
- **GOL ROF:** ~600 RPM (inherited vanilla)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** `GOL_B_762x51_M993` (hit=16, caliber=2.6, 960 m/s), SLAP (hit=18, caliber=3.5, 1020 m/s)
- **Notes:** Relatively low ROF for 7.62 NATO. Middle of the recoil tier.

#### GOL_weap_fnmag — FN MAG
- **Class:** `GOL_weap_fnmag`
- **Caliber:** 7.62×51mm NATO
- **Real-world ROF:** 650–1000 RPM
- **GOL ROF:** ~850 RPM (inherited from RHS parent)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** `GOL_FNMAG_*` variants (M993 + SLAP), same ammo stats as above
- **Notes:** Higher ROF than Zafir on same caliber. Recoil should ideally be slightly higher or equal.

#### GOL_MG3_KWS_B — MG3 KWS
- **Class:** `GOL_MG3_KWS_B`
- **Caliber:** 7.62×51mm NATO
- **Real-world ROF:** 900–1200 RPM (fastest in the set)
- **GOL ROF:** ~1200 RPM (inherited from UK3CB parent)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** `GOL_MG3_*` variants (M993 + SLAP)
- **Notes:** Highest ROF in the set by a large margin. Shares the same recoil as the slow Zafir — strongest candidate for increased recoil to reflect sustained fire at 1200 RPM.

#### GOL_weap_m249_pip — M249 PIP
- **Class:** `GOL_weap_m249_pip`
- **Caliber:** 5.56×45mm NATO
- **Real-world ROF:** 750–1000 RPM
- **GOL ROF:** ~850 RPM (inherited from RHS parent)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** `GOL_B_556x45_Ball_AP45` (hit=12, caliber=2.0, 1162 m/s), tracer variants
- **Notes:** Lightest caliber in the set. Candidate for lowest recoil tier.

---

## AT / Launcher Weapons

| Class | Display Name | Type | Recoil | Dispersion | Notes |
|---|---|---|---|---|---|
| `GOL_weap_PSRL1` | PSRL-1 (GOL) | RPG-7 variant | `recoil_rpg` | **0** (none) | 4 round types; zero launch spread |
| `gol_weapon_igla` | 9K38 Igla (No ACE Guidance) | MANPADS | inherited | inherited | Single-shot; ACE guidance disabled |
| `gol_weapon_s750Launcher` | S-400 (No ACE Guidance) | SAM launcher | inherited | inherited | Single-shot; ACE guidance disabled |
| `gol_weapon_shorad_ir` | SHORAD IR Launcher (GOL) | Turret MANPADS | inherited | inherited | Turret use; 3 missile tiers |

### PSRL-1 Rounds

| Magazine Class | Warhead | hit | AP Caliber | Notes |
|---|---|---|---|---|
| `GOL_mag_rpg7_Modern` | HEAT+ (PG-7VM) | 275 | — | VM base +25%, penetrator hit=290 |
| `GOL_mag_rpg7_OG7V` | HE Frag (OG-7V) | 75 | — | indirectHit=20, range=15m; ACE frag |
| `GOL_mag_rpg7_TBG7V` | Thermobaric | 120 | — | indirectHit=60, range=12m; submunition wave |
| `GOL_mag_rpg7_VR` | Tandem HEAT (PG-7VR) | 310 | — | ERA-defeating; penetrator hit=420 |

### SHORAD IR Missile Tiers

| Magazine Class | Tier | maneuvrability | cmImmunity | Notes |
|---|---|---|---|---|
| `gol_magazine_shorad_light_x1` | Light | 18 | 0.35 | High agility, low CM resistance |
| `gol_magazine_shorad_medium_x1` | Medium | 15 | 0.55 | Balanced |
| `gol_magazine_shorad_heavy_x1` | Heavy | 12 | 0.75 | Low agility, high CM resistance |

---

## Rebalancing Notes

### Suggested Recoil Tier Structure

All GOL machineguns currently share one recoil preset. A tiered approach based on caliber and weapon class:

| Tier | Weapons | Suggested Preset Name | Rationale |
|---|---|---|---|
| **Light** | M249 PIP (5.56) | `GOL_recoil_mg_light` | Lightest caliber, high ROF but manageable |
| **Medium** | Zafir, FN MAG, PKM, PKP (7.62) | `GOL_recoil_mg_medium` (current) | Standard GPMG tier |
| **Heavy** | MG3 KWS (7.62 @ 1200 RPM), HK121 (9.3mm) | `GOL_recoil_mg_heavy` | High ROF or heavy caliber |
| **Extreme** | LWMMG .338 | `GOL_recoil_mg_338` | Heaviest round; ROF also needs reduction to ~500 RPM |

### Key Numbers to Tune

```cpp
// CURRENT — same for all
class GOL_recoil_machinegun: recoil_default {
    kickBack[]    = {0.04, 0.07};
    muzzleOuter[] = {0.2, 0.4, 0.1, 0.05};
    temporary     = 0.008;
};

// Suggested for .338 LWMMG
// kickBack up ~50–70%, muzzleOuter up ~40–60%
// Also: reloadTime = 0.12 → ~500 RPM (real LWMMG rate)
```

### LWMMG Rate of Fire Correction
The LWMMG is explicitly set to `reloadTime = 0.0923` (~649 RPM) in all three color variants.  
Real LWMMG fires at ~500 RPM. To correct: `reloadTime = 0.12`.
