# GOL Machinegun & AT Weapon Reference — Recoil & Rate of Fire

> **Purpose:** Reference for GOL MG recoil assignments and rate-of-fire values.
> The 3-tier recoil system (light / medium / heavy) is implemented.
> `CfgRecoils` currently lives at the top of `CfgWeapons.cpp` — consider moving to a dedicated `CfgRecoils.cpp` and `#include`ing it from `config.cpp`.

---

## Recoil Presets (CfgRecoils)

**Field meanings:**
- `kickBack` — rearward displacement per shot `[min, max]`
- `muzzleOuter` — `[horizontal_pos, vertical_pos, horizontal_magnitude, vertical_magnitude]`; `vertical_pos` drives muzzle climb
- `temporary` — duration of sway effect (seconds)
- Reference point: RHS PKM `muzzleOuter[] = {0.55, 1.0, 0.7, 0.35}`

### Light tier — 5.56mm / 5.45mm

| Preset | kickBack | muzzleOuter | temporary |
|---|---|---|---|
| `GOL_recoil_machinegun_light` | {0.015, 0.035} | {0.075, 0.5, 0.1, 0.15} | 0.0075 |
| `GOL_recoil_machinegun_light_prone` | {0.010, 0.025} | {0.05, 0.375, 0.075, 0.125} | 0.005 |

### Medium tier — 7.62mm class

| Preset | kickBack | muzzleOuter | temporary |
|---|---|---|---|
| `GOL_recoil_machinegun` | {0.02, 0.045} | {0.1, 0.6, 0.12, 0.175} | 0.010 |
| `GOL_recoil_machinegun_prone` | {0.015, 0.035} | {0.075, 0.45, 0.09, 0.14} | 0.0075 |

### Heavy tier — 9.3mm / .338 class

| Preset | kickBack | muzzleOuter | temporary |
|---|---|---|---|
| `GOL_recoil_machinegun_heavy` | {0.025, 0.055} | {0.1, 0.75, 0.12, 0.2} | 0.0125 |
| `GOL_recoil_machinegun_heavy_prone` | {0.02, 0.04} | {0.075, 0.55, 0.09, 0.15} | 0.009 |

---

## Machineguns

### Summary Table

| Class | Display Name | Caliber | Recoil Preset | reloadTime (s) | ~RPM | Source |
|---|---|---|---|---|---|---|
| `GOL_MMG_01_tan_F` | HK121 9.3mm (Tan/GOL) | 9.3×64mm | **heavy** | inherited | ~649 | parent `MMG_01_tan_F` |
| `GOL_MMG_01_hex_F` | HK121 9.3mm (Hex/GOL) | 9.3×64mm | **heavy** | inherited | ~649 | parent `MMG_01_hex_F` |
| `GOL_MMG_02_black_F` | LWMMG .338 (Black/GOL) | .338 Norma Mag | **heavy** | **0.0923** | **~649** ⚠️ | explicitly set |
| `GOL_MMG_02_camo_F` | LWMMG .338 (Camo/GOL) | .338 Norma Mag | **heavy** | **0.0923** | **~649** ⚠️ | explicitly set |
| `GOL_MMG_02_sand_F` | LWMMG .338 (Sand/GOL) | .338 Norma Mag | **heavy** | **0.0923** | **~649** ⚠️ | explicitly set |
| `GOL_weap_pkm` | PKM (GOL) | 7.62×54mmR | **medium** | inherited | ~700 | parent `rhs_weap_pkm` |
| `GOL_weap_pkp` | PKP (GOL) | 7.62×54mmR | **medium** | inherited | ~700 | parent `rhs_weap_pkp` |
| `GOL_LMG_Zafir_F` | Zafir 7.62mm (GOL) | 7.62×51mm NATO | **medium** | inherited | ~600 | parent `LMG_Zafir_F` |
| `GOL_weap_fnmag` | FN MAG (GOL) | 7.62×51mm NATO | **medium** | inherited | ~850 | parent `rhs_weap_fnmag` |
| `GOL_MG3_KWS_B` | MG3 KWS (GOL) | 7.62×51mm NATO | **medium** | inherited | ~1200 | parent `UK3CB_MG3_KWS_B` |
| `GOL_weap_UK59N` | UK59N (GOL) | 7.62×51mm NATO | **medium** | inherited | ~700 | parent `UK3CB_UK59N` |
| `GOL_weap_RPD` | RPD (GOL) | 7.62×39mm | **medium** | inherited | ~700 | parent `UK3CB_RPD` |
| `GOL_weap_RPK12` | RPK-12 (GOL) | 7.62×39mm | **medium** | inherited | ~600 | parent `arifle_RPK12_F` |
| `GOL_LMG_Mk200_F` | LMG Mk200 (GOL) | 6.5mm cased | **medium** | inherited | ~615 | parent `LMG_Mk200_F` |
| `GOL_arifle_MX_SW_F` | MX SW (GOL) | 6.5mm caseless | **medium** | inherited | ~625 | parent `arifle_MX_SW_F` |
| `GOL_arifle_MX_SW_Black_F` | MX SW Black (GOL) | 6.5mm caseless | **medium** | inherited | ~625 | parent `arifle_MX_SW_Black_F` |
| `GOL_arifle_MX_SW_khk_F` | MX SW Khaki (GOL) | 6.5mm caseless | **medium** | inherited | ~625 | parent `arifle_MX_SW_khk_F` |
| `GOL_weap_m249_pip` | M249 PIP (GOL) | 5.56×45mm NATO | **light** | inherited | ~850 | parent `rhs_weap_m249_pip` |
| `GOL_weap_m249` | M249 (GOL) | 5.56×45mm NATO | **light** | inherited | ~850 | parent `rhs_weap_m249` |
| `GOL_weap_rpk74m` | RPK-74M (GOL) | 5.45×39mm | **light** | inherited | ~600 | parent `rhs_weap_rpk74m` |
| `GOL_weap_rpk74m_npz` | RPK-74M (NPZ/GOL) | 5.45×39mm | **light** | inherited | ~600 | parent `rhs_weap_rpk74m_npz` |

> ⚠️ LWMMG `reloadTime = 0.0923` is explicitly set — ~649 RPM vs real ~500 RPM. See open items below.  
> `reloadTime` in Arma 3: seconds between shots. RPM = 60 / reloadTime.  
> "Inherited" RPM values are estimates from the parent mod; no GOL override exists.

---

### Per-Weapon Detail

#### GOL_MMG_01 — HK121 9.3mm (Navid)
- **Classes:** `GOL_MMG_01_tan_F`, `GOL_MMG_01_hex_F`
- **Caliber:** 9.3×64mm — heaviest infantry MG in the set
- **Real-world ROF:** 600–700 RPM
- **GOL ROF:** ~649 RPM (inherited; parent Navid uses 0.0923s)
- **Recoil:** `GOL_recoil_machinegun_heavy` / `GOL_recoil_machinegun_heavy_prone`
- **AP ammo:** none (ball + tracers only)

#### GOL_MMG_02 — LWMMG .338 Norma Magnum
- **Classes:** `GOL_MMG_02_black_F`, `GOL_MMG_02_camo_F`, `GOL_MMG_02_sand_F`
- **Caliber:** .338 Norma Magnum
- **Real-world ROF:** ~500 RPM
- **GOL ROF:** ~649 RPM (`reloadTime = 0.0923` — explicitly set, faster than real) ⚠️
- **Recoil:** `GOL_recoil_machinegun_heavy` / `GOL_recoil_machinegun_heavy_prone`
- **AP ammo:** `GOL_B_338_Ball_AP` — hit=21, caliber=1.65 (~70% .50 cal), 860 m/s

#### GOL_weap_pkm / GOL_weap_pkp — PKM / PKP
- **Classes:** `GOL_weap_pkm`, `GOL_weap_pkp`
- **Caliber:** 7.62×54mmR
- **Real-world ROF:** PKM 650–800 RPM, PKP 650 RPM
- **GOL ROF:** ~700 RPM (inherited from RHS parent)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** none (ball + tracers only)

#### GOL_LMG_Zafir_F — Zafir 7.62×51mm
- **Class:** `GOL_LMG_Zafir_F`
- **Caliber:** 7.62×51mm NATO
- **Real-world ROF:** 600–1000 RPM
- **GOL ROF:** ~600 RPM (inherited vanilla)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** `GOL_B_762x51_M993` (hit=16, caliber=2.6, 960 m/s), SLAP (hit=18, caliber=3.5, 1020 m/s)

#### GOL_weap_fnmag — FN MAG
- **Class:** `GOL_weap_fnmag`
- **Caliber:** 7.62×51mm NATO
- **Real-world ROF:** 650–1000 RPM
- **GOL ROF:** ~850 RPM (inherited from RHS parent)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** `GOL_FNMAG_*` variants (M993 + SLAP)
- **Notes:** `heatRadiation = 0` set to disable barrel shimmer/smoke effect.

#### GOL_MG3_KWS_B — MG3 KWS
- **Class:** `GOL_MG3_KWS_B`
- **Caliber:** 7.62×51mm NATO
- **Real-world ROF:** 900–1200 RPM (fastest in the set)
- **GOL ROF:** ~1200 RPM (inherited from UK3CB parent)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** `GOL_MG3_*` variants (M993 + SLAP)
- **Notes:** Highest ROF in the set. Medium tier recoil may be underselling the sustained fire intensity.

#### GOL_weap_UK59N — UK59N
- **Class:** `GOL_weap_UK59N`
- **Caliber:** 7.62×51mm NATO
- **Real-world ROF:** ~700–1000 RPM
- **GOL ROF:** ~700 RPM (inherited from UK3CB parent)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** `GOL_UK59_*` variants (M993 ball + tracers, up to 200Rnd belts)

#### GOL_weap_RPD — RPD
- **Class:** `GOL_weap_RPD`
- **Caliber:** 7.62×39mm
- **Real-world ROF:** 650–750 RPM
- **GOL ROF:** ~700 RPM (inherited from UK3CB parent)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** `GOL_RPD_100Rnd_762x39` variants (ball + tracers only, no AP)
- **Notes:** Magazine well empty on parent; GOL mags added via `magazines[] +=`.

#### GOL_weap_RPK12 — RPK-12
- **Class:** `GOL_weap_RPK12`
- **Caliber:** 7.62×39mm
- **Real-world ROF:** ~600 RPM
- **GOL ROF:** ~600 RPM (inherited vanilla)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** `GOL_75Rnd_762x39` drum variants (ball + tracers); GOL 75Rnd drums also injected into `CBA_762x39_RPK` magazine well for 3CB RPK variants.

#### GOL_LMG_Mk200_F — LMG Mk200
- **Class:** `GOL_LMG_Mk200_F`
- **Caliber:** 6.5mm cased
- **Real-world ROF:** ~615 RPM
- **GOL ROF:** ~615 RPM (inherited vanilla)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** `GOL_200Rnd_65x39_cased_Box` variants (ball + tracers only)
- **Notes:** No magazine well on parent; GOL mags added via `magazines[] +=`.

#### GOL_arifle_MX_SW variants — MX SW
- **Classes:** `GOL_arifle_MX_SW_F`, `GOL_arifle_MX_SW_Black_F`, `GOL_arifle_MX_SW_khk_F`
- **Caliber:** 6.5mm caseless
- **Real-world ROF:** ~625 RPM
- **GOL ROF:** ~625 RPM (inherited vanilla)
- **Recoil:** `GOL_recoil_machinegun` / `GOL_recoil_machinegun_prone`
- **AP ammo:** GOL 100Rnd caseless belt mags via `MX_65x39_Large` magazine well (`CfgMagazineWells`).

#### GOL_weap_m249_pip / GOL_weap_m249 — M249 PIP / M249
- **Classes:** `GOL_weap_m249_pip`, `GOL_weap_m249`
- **Caliber:** 5.56×45mm NATO
- **Real-world ROF:** 750–1000 RPM
- **GOL ROF:** ~850 RPM (inherited from RHS parent)
- **Recoil:** `GOL_recoil_machinegun_light` / `GOL_recoil_machinegun_light_prone`
- **AP ammo:** `GOL_B_556x45_Ball_AP45` (hit=12, caliber=2.0, 1162 m/s) + tracer variants; `GOL_rhsusf_200rnd_556x45_AP45` belt variants on M249.

#### GOL_weap_rpk74m / GOL_weap_rpk74m_npz — RPK-74M
- **Classes:** `GOL_weap_rpk74m`, `GOL_weap_rpk74m_npz`
- **Caliber:** 5.45×39mm
- **Real-world ROF:** ~600 RPM
- **GOL ROF:** ~600 RPM (inherited from RHS parent)
- **Recoil:** `GOL_recoil_machinegun_light` / `GOL_recoil_machinegun_light_prone`
- **AP ammo:** GOL 7N22 AP mags via `CBA_545x39_RPK` magazine well (`CfgMagazineWells`).

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

## Open Items

### LWMMG Rate of Fire
The LWMMG is explicitly set to `reloadTime = 0.0923` (~649 RPM) in all three color variants (`GOL_MMG_02_*`).  
Real LWMMG fires at ~500 RPM. To correct: `reloadTime = 0.12`.

### CfgRecoils file separation
`CfgRecoils` is currently declared at the top of `CfgWeapons.cpp`. Moving it to a dedicated `CfgRecoils.cpp` and `#include`-ing it from `config.cpp` would improve maintainability, especially as more recoil presets are added.
