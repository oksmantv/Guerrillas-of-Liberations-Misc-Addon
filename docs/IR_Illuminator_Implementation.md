# OX3000 IR Illuminator

The GOL OX3000 is a dual-purpose weapon light built on engine reflectors. It is **not** a
BettIR Attachments device. **BettIR Attachments** and **BettIR NVG** are hard dependencies
of GOL_MISC_ADDON because GOL patches them.

## Modes and strength

| Mode | Classes | Content |
|---|---|---|
| DP | `GOL_OX3000_DP_P1` - `_P5` | IR laser + IR illuminator (`irLight = 1`) |
| LS | `GOL_OX3000_LS_P1` - `_P5` | IR laser only (suffix only remembers strength) |
| FL | `GOL_OX3000_FL_P1` - `_P5` | Visible flashlight (`irLight = 0`) |

- `GOL_OX3000` is the arsenal item and equals `GOL_OX3000_DP_P1`.
- Each class stores `GOL_OX3000_Mode` and `GOL_OX3000_Power` in CfgWeapons.
- P1-P5 are shown as 20% - 100%.

## Controls

- **Power:** engine headlights key (L).
- **Mode:** CBA rail cycle key. MRT ring per strength: `DP -> LS -> FL -> DP`.
- **Strength:** BettIR Stepper #2 (default Ctrl + mouse wheel). Stepper #1 (Shift + wheel) works too.
  Only on foot, primary weapon selected, DP or FL mode. Clamped 20-100%.
- **NVG illuminator (BettIR NVG):** Alt + mouse wheel (`GOL Lights` in Controls).
  Only with NVGs down and the illuminator on. 20-100% (100% = 35% of BettIR stock), default 40%, saved in the profile.

## BettIR patches (`configs/compat/compat_bettir.hpp`, `configs/CfgFunctions.cpp`)

- The OX3000 is not in `BettIR_Config`, so BettIR never tracks it or adds ACE menus for it.
- `BettIR_Attachments_fnc_canUnitUseLaserDevice` -> GOL copy that returns false for the
  OX3000. BettIR's L-key hook and power buttons skip it.
- BettIR Stepper user actions (shipped as "not implemented") -> `OKS_fnc_BettIR_onStepper`.
  OX3000: `OKS_fnc_OX3000_AdjustStrength`. Other BettIR devices: their `onStepperUp/Down`.
- `BettIR_NVG_fnc_validateUnitLight` -> GOL copy. Intensity = `OKS_NVGIllum_Level` x 0.0525
  (100% = 0.2625, 35% of BettIR stock 0.75). The level is a public unit variable.
- Strength swaps the variant in place and re-enables the light after 0.1 s.

## Light values

- IR: soft spot, inner 4 / outer 32 deg, coneFadeCoef 8, no ambient.
  Intensity 10 / 15 / 22 / 32 / 45. Attenuation follows the BettIR DBAL preset.
- Visible: intensity 20 / 35 / 55 / 78 / 100, ambient 0.04-0.09, outer 40-48 deg, coneFadeCoef 8-5.
- Tune in `configs/compat/compat_ace_irlight.hpp`.

## Legacy classes

| Old class | Now behaves as |
|---|---|
| `GOL_OX3000_II`, `_LR`, `_LR_II` | DP P1 |
| `GOL_OX3000_IP`, `_LR_IP` | LS P1 |
| `GOL_OX3000_FL_Low`, `_LR_FL_Low` | FL P2 |
| `GOL_OX3000_FL`, `_LR_FL` | FL P4 |

## Stealth

`fn_Stealth_PlayerVisibility` treats any accessory with an `irLight = 1` flashlight as IR-only.
FL variants still apply the visible-light penalty.
