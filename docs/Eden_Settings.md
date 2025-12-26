# GOL Eden Settings

These settings are configured via **CBA Addon Options** and are initialized in `XEH_PreInit/XEH_preInit_eden.sqf`.

## Debug

### `OKS_3DEN_DEBUG`
- **Type:** Checkbox (boolean)
- **Purpose:** Enables extra 3DEN notifications and verbose logging for the Eden helpers under **GOL SCRIPTS**.
- **Default:** Enabled

## Tasks

### `OKS_3DEN_INTEL_CLASS`
- **Type:** Editbox (string)
- **Purpose:** Classname in `CfgVehicles` used by the 3DEN helper **GOL SCRIPTS → TASK → Setup Intel**.
- **Default:** `acex_intelitems_document`
- **Notes:** If the classname does not exist in `CfgVehicles`, the helper falls back to a set of known ACEX/ACE candidates and finally `Land_File1_F`.
