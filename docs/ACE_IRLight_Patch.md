# ACE IR Light Patch — Lessons Learned

## Goal

Patch the ACE `ace_irlight` addon (DBAL-A3 items) from within OKS_GOL_Misc to:
- Remove the **visible red pointer mode** from all DBAL items
- Reduce **illuminator brightness by 30%**
- Preserve all ACE original classes untouched

---

## What the ACE irlight System Does

ACE defines several DBAL-A3 item classes in `CfgWeapons` inside its binarized PBO:

| Class | Mode |
|---|---|
| `ACE_DBAL_A3_Red` | IR Dual (laser + illuminator) |
| `ACE_DBAL_A3_Red_IP` | IR Pointer only |
| `ACE_DBAL_A3_Red_II` | IR Illuminator only |
| `ACE_DBAL_A3_Red_VP` | **Visible red pointer** ← removed in GOL |
| `ACE_DBAL_A3_Red_LR` | LR IR Dual |
| `ACE_DBAL_A3_Green_*` | Green variants of above |

The cycle order is controlled by three properties on each class:

```cpp
MRT_SwitchItemNextClass = "ACE_DBAL_A3_Red_IP";
MRT_SwitchItemPrevClass = "ACE_DBAL_A3_Red_VP";
```

The ACE function `ace_irlight_fnc_initItemContextMenu` registers a context menu for each mode variant using `CBA_fnc_addItemContextMenuOption`.

---

## Approach: GOL-Tagged Copies (Correct)

**Do not override ACE classes directly.** Instead, create GOL-prefixed child classes that inherit from the ACE bases, then override the function that builds the context menu.

### Why not direct overrides?

Attempting `class ACE_DBAL_A3_Red { class ItemInfo { class Flashlight { ... } } }` fails at runtime:

> `Undefined base class 'ItemInfo'`

**Root cause**: Arma 3 cannot resolve nested class inheritance cross-PBO from binarized files. When you re-open a class from another PBO and try to inherit a nested class by its short name, the engine has no reference for it.

### Correct pattern

```cpp
// Forward-declare both the ACE base AND any CfgWeapons base classes used in nested inheritance.
// The compat file is included inside class CfgWeapons {}, so forward declarations here
// tell the parser these classes exist elsewhere in that namespace.
class InventoryFlashLightItem_Base_F;
class ACE_DBAL_A3_Red;

// Create GOL child — inherits everything from ACE base
class GOL_DBAL_A3_Red: ACE_DBAL_A3_Red {
    // Redefine nested classes using GLOBAL base names, not relative names
    class ItemInfo: InventoryFlashLightItem_Base_F {
        class Flashlight { ... };
        class Pointer { ... };
    };
};
```

Key rules:
- `ItemInfo` must inherit from `InventoryFlashLightItem_Base_F` (global base), **not** `ItemInfo: ItemInfo`
- `Flashlight` and `Pointer` are defined fresh inside the new `ItemInfo` block
- All nested class parents must be globally resolvable names
- **Forward-declare every class used as a base** (even standard A3 classes like `InventoryFlashLightItem_Base_F`) — without this, the parser reports `Undefined base class` even for vanilla classes

---

## Removing Visible Pointer Mode

Simply **omit the `_VP` variant classes entirely**. The cycle is broken cleanly by making the last mode point back to the first:

```cpp
// 3-mode ring: Dual → Pointer → Illuminator → back to Dual
class GOL_DBAL_A3_Red {
    MRT_SwitchItemNextClass = "GOL_DBAL_A3_Red_IP";
    MRT_SwitchItemPrevClass = "GOL_DBAL_A3_Red_II";
};
class GOL_DBAL_A3_Red_IP {
    MRT_SwitchItemNextClass = "GOL_DBAL_A3_Red_II";
    MRT_SwitchItemPrevClass = "GOL_DBAL_A3_Red";
};
class GOL_DBAL_A3_Red_II {
    MRT_SwitchItemNextClass = "GOL_DBAL_A3_Red";
    MRT_SwitchItemPrevClass = "GOL_DBAL_A3_Red_IP";
};
// No GOL_DBAL_A3_Red_VP — visible pointer gone
```

---

## Reducing Illuminator Brightness (30%)

Original ACE values (defined via macros in ACE source):
- Normal DBAL: `intensity = 100`
- LR DBAL: `intensity = 200`

30% reduction applied in the `Flashlight` block of every illuminator-active mode (dual and illuminator-only):
- Normal: `intensity = 70`
- LR: `intensity = 140`

Pointer-only (`_IP`) classes have no `Flashlight` block, so no change needed there.

---

## Overriding the Context Menu Function

ACE builds the right-click menu via `ace_irlight_fnc_initItemContextMenu`. To override it, register a new function under the **same namespace** in `CfgFunctions`:

```cpp
// configs/CfgFunctions.cpp — inside class OKS {}
class ace_irlight {
    file = "\OKS_GOL_Misc\functions\compat\ace_irlight";
    class initItemContextMenu {};
};
```

This registers `ace_irlight_fnc_initItemContextMenu` from your path, overriding ACE's version.

The replacement function loops over GOL classnames with only 3 modes (no `_VP` entry):

```sqf
{
    _x params ["_variant", "_displayName"];
    // ... register menu option for each variant ...
} forEach [
    ["",    LSTRING(Mode_IRDual)],
    ["_IP", LSTRING(Mode_IRPointer)],
    ["_II", LSTRING(Mode_IRIlluminator)]
    // ["_VP", ...] intentionally absent
];
```

---

## File Structure

| File | Purpose |
|---|---|
| `config.cpp` | `GOL_MISC_COMPAT_ACE_IRLIGHT` CfgPatches block with `skipWhenMissingDependencies = 1` |
| `configs/CfgWeapons.cpp` | `#include "compat\compat_ace_irlight.hpp"` (inside `class CfgWeapons {}`) |
| `configs/CfgFunctions.cpp` | `class ace_irlight { class initItemContextMenu {}; }` registration |
| `configs/compat/compat_ace_irlight.hpp` | All GOL-tagged class definitions |
| `functions/compat/ace_irlight/fnc_initItemContextMenu.sqf` | Replacement context menu function |

---

## Common Mistakes

| Mistake | Result | Fix |
|---|---|---|
| `class ACE_DBAL_A3_Red { class ItemInfo { ... } }` | `Undefined base class 'ItemInfo'` | Create a GOL child class instead |
| `class ItemInfo: ItemInfo { class Flashlight: Flashlight {...} }` | Same error | Use `class ItemInfo: InventoryFlashLightItem_Base_F` |
| Include placed outside `class CfgWeapons {}` | Classes ignored or wrong context | Move `#include` inside the CfgWeapons block |
| Missing `class InventoryFlashLightItem_Base_F;` forward declaration | `Undefined base class 'InventoryFlashLightItem_Base_F'` even though it's a vanilla class | Add forward declaration at the top of the compat file (inside the CfgWeapons include) |
| Leaving a `_VP` class with no `MRT_SwitchItemNextClass` target | Dead end in cycle, item gets stuck | Ensure ring is closed; remove or reroute all references |

---

## Editor Warnings (False Positives)

The GOL-Intellisense VS Code extension reports warnings like:

> `'CBA_' is a reserved prefix` / `'ACE_' is a reserved prefix`

These are from the extension's namespace linter, not from Arma's config parser. They do not affect in-game behavior.
