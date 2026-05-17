# OKS_GOL_Misc — StaticJump / Paradrop System

## Files
All in `functions/paradrop/`:
- `fn_StaticJump_Code.sqf` — Core jump logic (eject, position, chute, cleanup). Params: `[_aircraft, _player, _ejected]`
- `fn_StaticJump_Hook.sqf` — Sets `GOL_Hooked` on player; spawns fn_StaticJump_Action when true
- `fn_StaticJump_Action.sqf` — Adds "Static Line Jump" action to aircraft object
- `fn_StaticJump_EventCode.sqf` — CBA GetOut EH; fires fn_StaticJump_Code when player exits at altitude >100m
- `fn_ParadropActions.sqf` — ACE menus on GOL_GearBox objects (steerable / static chute options)
- `fn_SetupParadrop.sqf` — Equips player: parachute backpack + altimeter, removes watch

## Initialization
- `XEH_PostInit/XEH_postInit_Global.sqf`: spawns ParadropActions; registers CBA GetOut EH for `RHS_C130J_BASE`, `Air`, `UK3CB_Antonov_An2_Base`, `UK3CB_DC3_Base`, `VTOL_01_base_F`
- `XEH_PreInit/XEH_preInit_core.sqf`: registers `GOL_Paradrop_Debug` CBA setting
- `configs/CfgFunctions.cpp`: class `OKS_Paradrop` registers all 6 functions
- `configs/CfgVehicles.cpp` (`Plane` class): ACE `GOL_StaticLine` submenu → Hook Up / Unhook

## Call Flow
```
Gearbox → SetupParadrop (equip chute)
Hook Up (ACE menu) → StaticJump_Hook → StaticJump_Action (adds button)
  Path A: player presses action → StaticJump_Code (_ejected=false)
  Path B: CBA GetOut fires → StaticJump_EventCode → StaticJump_Code (_ejected=true)
StaticJump_Code: guard → eject → snapshot velocity → boost damage threshold →
  alternate L/R offset → disableCollision + setPos + setVelocity →
  sleep 1 → OpenParachute + sound + 5.5m/s forward →
  cleanup: Hook(false), HasJumped=false, restore threshold on landing
```

## Key Variables
**Player (broadcast true):** `GOL_Hooked`, `GOL_StaticJump`, `GOL_HasJumped`, `GOL_StaticJumpAction`  
**Aircraft (broadcast true):** `GOL_Paradrop_SwitchSide` (alternates L/R per jumper)  
**Global (read):** `GOL_Paradrop_Debug` (CBA), `ace_medical_playerDamageThreshold` (ACE)

## Parachute Classes
- `rhsusf_eject_Parachute_backpack` — static line (auto-deploys)
- `B_Parachute` — steerable (manual)

## Notes
- `_ejected` flag prevents double-execution via `GOL_HasJumped` guard
- Damage threshold boosted ×1.25 during jump, restored after landing/death
- `GOL_Paradrop_SwitchSide` on aircraft alternates exit side to prevent collisions
- Sound: `"GOL_ParachuteDeploy"` on chute open
