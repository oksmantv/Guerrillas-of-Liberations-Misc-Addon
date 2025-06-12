<div align="center">
    <h1 align="center">GOL Miscellaneous Addon
    <br/>
    <br/>
    <a href="https://gol-clan.com/home">
        <img src="https://github.com/Bluwolf00/GOL_Framework_2021/blob/main/AnimatedGOLlogo.png?raw=true#gh-dark-mode-only" alt="GOL Logo" height="300">
		<!-- <img src="https://github.com/oksmantv/GOL_Addon/blob/master/img/GWLogo_DK.png?raw=true#gh-light-mode-only" alt="GOL Logo" height="300"> -->
    </a>
    </h1>
</div>

<div align="center">
<a><img src="https://img.shields.io/github/contributors/oksmantv/Guerrillas-of-Liberations-Misc-Addon?color=yellow"></img></a>
<a><img src="https://img.shields.io/github/commit-activity/t/oksmantv/Guerrillas-of-Liberations-Misc-Addon"></img></a>
<a href="https://github.com/oksmantv/Guerrillas-of-Liberations-Misc-Addon/issues"><img src="https://img.shields.io/github/issues-raw/oksmantv/Guerrillas-of-Liberations-Misc-Addon"></img></a>
<a href="https://gol-clan.com/home"><img src="https://img.shields.io/badge/Website-Click_Me-blue"></img></a>
<a href="https://discord.gg/k9BfvVjtYv"><img src="https://img.shields.io/discord/437979456196444161?label=Discord&color=%23BA55D3"></img></a>
</div>

## Introduction

This is the Guerrillas Of Liberation's custom addon that contains miscellaneous scripts for GOL gameplay. This includes a number of quality of life features for editing as well as general tweaks.
Edited by OksmanTV & Bluwolf.

## CBA Settings ⚙️
<details>
  <summary>⚙️ CBA Settings</summary>
<details>
  <summary>🔧 GOL_CORE_Enabled</summary>

  ### Description
  Enables all features added in the GOL Misc Addon (FW Version 2.7).

  ### Parameters
  | Name              | Type     | Default | Description                                        |
  |-------------------|----------|---------|----------------------------------------------------|
  | GOL_CORE_Enabled  | Checkbox | false   | Master switch for all GOL Misc Addon features.     |

  ### Example Usage
  Set in CBA Addon Options under "GOL_CORE".
</details>

<details>
  <summary>🔧 DEBUG Settings</summary>
<details>
  <summary>GOL_Core_Debug</summary>

  ### Description
  Allows for any debug messages to be broadcast. If disabled, no messages will show regardless of specific debugs turned on.

  ### Parameters
  | Name            | Type     | Default | Description                           |
  |-----------------|----------|---------|---------------------------------------|
  | GOL_Core_Debug  | Checkbox | false   | Master switch for all debug messages. |

  ### Example Usage
  Set in CBA Addon Options under "GOL_DEBUG".
</details>

<details>
  <summary>GOL_Ambience_Debug</summary>

  ### Description
  Enables debugging for enemy scripts such as the PowerGenerator, Death Score, House Destruction scripts.

  ### Parameters
  | Name                | Type     | Default | Description                                  |
  |---------------------|----------|---------|----------------------------------------------|
  | GOL_Ambience_Debug  | Checkbox | false   | Debug for ambience/enemy scripts.            |

  ### Example Usage
  Set in CBA Addon Options under "GOL_DEBUG".
</details>

<details>
  <summary>GOL_Enemy_Debug</summary>

  ### Description
  Enables debugging for enemy scripts such as AdjustDamage, ForceVehicleSpeed, EnablePath etc.

  ### Parameters
  | Name             | Type     | Default | Description                      |
  |------------------|----------|---------|----------------------------------|
  | GOL_Enemy_Debug  | Checkbox | false   | Debug for enemy scripts.         |

  ### Example Usage
  Set in CBA Addon Options under "GOL_DEBUG".
</details>

<details>
  <summary>GOL_RotorProtection_Debug</summary>

  ### Description
  Enables debugging for the handleDamage scripts for Mi-8/Mi-24 rotors.

  ### Parameters
  | Name                      | Type     | Default | Description                         |
  |---------------------------|----------|---------|-------------------------------------|
  | GOL_RotorProtection_Debug | Checkbox | false   | Debug for rotor damage scripts.     |

  ### Example Usage
  Set in CBA Addon Options under "GOL_DEBUG".
</details>

<details>
  <summary>GOL_Unconscious_CameraDebug</summary>

  ### Description
  Enables Camera DEBUG for unconscious state.

  ### Parameters
  | Name                        | Type     | Default | Description                        |
  |-----------------------------|----------|---------|------------------------------------|
  | GOL_Unconscious_CameraDebug | Checkbox | false   | Debug for unconscious camera.      |

  ### Example Usage
  Set in CBA Addon Options under "GOL_DEBUG".
</details>

<details>
  <summary>MHQ_Debug</summary>

  ### Description
  Enable DEBUG messages for MHQ code.

  ### Parameters
  | Name       | Type     | Default | Description                  |
  |------------|----------|---------|------------------------------|
  | MHQ_Debug  | Checkbox | false   | Debug for MHQ code.          |

  ### Example Usage
  Set in CBA Addon Options under "GOL_DEBUG".
</details>
</details>
<details>
  <summary>🔧 Supply Settings</summary>
<details>
  <summary>NEKY_SupplyHelicopter</summary>

  ### Description
  Classname for the AI helicopter that brings in supplies and vehicles.

  ### Parameters
  | Name                  | Type    | Default   | Description                                   |
  |-----------------------|---------|-----------|-----------------------------------------------|
  | NEKY_SupplyHelicopter | Editbox | *(empty)* | Aircraft classname for supply drops.           |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Supply".
</details>

<details>
  <summary>NEKY_Supply_Enabled</summary>

  ### Description
  Enables AI Resupply through landings or paradrops.

  ### Parameters
  | Name                | Type     | Default | Description                        |
  |---------------------|----------|---------|------------------------------------|
  | NEKY_Supply_Enabled | Checkbox | true    | Enable AI resupply (land/paradrop) |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Supply".
</details>

<details>
  <summary>NEKY_SupplyVehicle_Enabled</summary>

  ### Description
  Enables AI Vehicle drop through paradrop.

  ### Parameters
  | Name                      | Type     | Default | Description                |
  |---------------------------|----------|---------|----------------------------|
  | NEKY_SupplyVehicle_Enabled| Checkbox | true    | Enable AI vehicle paradrop |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Supply".
</details>

<details>
  <summary>NEKY_SupplyMHQ_Enabled</summary>

  ### Description
  Enables AI MHQ Drop through paradrop.

  ### Parameters
  | Name                 | Type     | Default | Description          |
  |----------------------|----------|---------|----------------------|
  | NEKY_SupplyMHQ_Enabled | Checkbox | true    | Enable AI MHQ paradrop |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Supply".
</details>
</details>
<details>
  <summary>🔧 Dynamic Settings</summary>
<details>
  <summary>GOL_Dynamic_Faction</summary>

  ### Description
  Select the faction to use for dynamic operations.

  ### Parameters
  | Name                | Type | Default | Description                                      |
  |---------------------|------|---------|--------------------------------------------------|
  | GOL_Dynamic_Faction | List | CSAT    | Faction for dynamic ops (CSAT, CDF, LDF, etc.).  |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Dynamic".
</details>
</details>
<details>
  <summary>🔧 MHQ Settings</summary>
<details>
  <summary>MHQSAFEZONE</summary>

  ### Description
  Radius (in meters) of the MHQ safe zone.

  ### Parameters
  | Name        | Type   | Default | Description                    |
  |-------------|--------|---------|--------------------------------|
  | MHQSAFEZONE | Slider | 100     | MHQ safe zone radius (meters). |

  ### Example Usage
  Set in CBA Addon Options under "GOL_MHQ".
</details>

<details>
  <summary>MHQ_ShouldBe_ServiceStation</summary>

  ### Description
  If enabled the MHQ vehicle itself will be a service station, if disabled, it will be loaded with a mobile service station.

  ### Parameters
  | Name                        | Type     | Default | Description                  |
  |-----------------------------|----------|---------|------------------------------|
  | MHQ_ShouldBe_ServiceStation | Checkbox | false   | MHQ is a service station     |

  ### Example Usage
  Set in CBA Addon Options under "GOL_MHQ".
</details>
</details>
<details>
  <summary>🔧 Gear Settings</summary>
<details>
  <summary>MAGNIFIED_OPTICS_ALLOW</summary>

  ### Description
  Allows magnified 2x sights to be selected from the Arsenal.

  ### Parameters
  | Name                   | Type     | Default | Description                        |
  |------------------------|----------|---------|------------------------------------|
  | MAGNIFIED_OPTICS_ALLOW | Checkbox | true    | Allow 2x sights in Arsenal         |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear".
</details>

<details>
  <summary>OPTICS_ALLOW</summary>

  ### Description
  Allows sights to be selected from the Arsenal.

  ### Parameters
  | Name          | Type     | Default | Description                |
  |---------------|----------|---------|----------------------------|
  | OPTICS_ALLOW  | Checkbox | true    | Allow optics in Arsenal    |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear".
</details>

<details>
  <summary>WEAPONS_ALLOW</summary>

  ### Description
  Allows weapon variations to be selected from Arsenal.

  ### Parameters
  | Name           | Type     | Default | Description                        |
  |----------------|----------|---------|------------------------------------|
  | WEAPONS_ALLOW  | Checkbox | true    | Allow weapon variants in Arsenal   |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear".
</details>

<details>
  <summary>ARSENAL_ALLOW</summary>

  ### Description
  Allows Attachment Menu in Arsenal.

  ### Parameters
  | Name           | Type     | Default | Description                        |
  |----------------|----------|---------|------------------------------------|
  | ARSENAL_ALLOW  | Checkbox | true    | Allow attachment menu in Arsenal   |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear".
</details>

<details>
  <summary>GroundRoles_ALLOW</summary>

  ### Description
  Allows specialist ground roles (Dragon, Light Rifleman, Ammo Bearer, Anti-Air, Heavy AT).

  ### Parameters
  | Name              | Type     | Default | Description                        |
  |-------------------|----------|---------|------------------------------------|
  | GroundRoles_ALLOW | Checkbox | false   | Allow specialist ground roles      |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear".
</details>

<details>
  <summary>AirRoles_ALLOW</summary>

  ### Description
  Allows specialist air roles (Para-Rescueman, Jet Pilot, Marksman).

  ### Parameters
  | Name           | Type     | Default | Description                        |
  |----------------|----------|---------|------------------------------------|
  | AirRoles_ALLOW | Checkbox | false   | Allow specialist air roles         |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear".
</details>

<details>
  <summary>ENTRENCH_ALLOW</summary>

  ### Description
  Adds Entrenching Tools to certain roles.

  ### Parameters
  | Name           | Type     | Default | Description                        |
  |----------------|----------|---------|------------------------------------|
  | ENTRENCH_ALLOW | Checkbox | false   | Add entrenching tools to roles     |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear".
</details>

<details>
  <summary>WIRECUTTER_ALLOW</summary>

  ### Description
  Adds Wirecutters to Riflemen.

  ### Parameters
  | Name             | Type     | Default | Description                        |
  |------------------|----------|---------|------------------------------------|
  | WIRECUTTER_ALLOW | Checkbox | false   | Add wirecutters to riflemen        |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear".
</details>

<details>
  <summary>ForceNVG</summary>

  ### Description
  Forces addition of NVGs.

  ### Parameters
  | Name      | Type     | Default | Description                        |
  |-----------|----------|---------|------------------------------------|
  | ForceNVG  | Checkbox | false   | Force NVGs for players             |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear".
</details>

<details>
  <summary>ForceNVGClassname</summary>

  ### Description
  Forces change of NVGs.

  ### Parameters
  | Name              | Type    | Default   | Description                        |
  |-------------------|---------|-----------|------------------------------------|
  | ForceNVGClassname | Editbox | *(empty)* | Override NVG classname             |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear".
</details>
</details>
<details>
  <summary>🔧 AI Gear Settings</summary>
<details>
  <summary>LAT_Chance</summary>

  ### Description
  Chance for Light AT to be given to AI (0 = never, 1 = always).

  ### Parameters
  | Name        | Type   | Default | Description                        |
  |-------------|--------|---------|------------------------------------|
  | LAT_Chance  | Slider | 0.25    | Chance AI get Light AT (0-1)       |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear_AI".
</details>

<details>
  <summary>MAT_Chance</summary>

  ### Description
  Chance for Medium AT to be given to AI (0 = never, 1 = always).

  ### Parameters
  | Name        | Type   | Default | Description                        |
  |-------------|--------|---------|------------------------------------|
  | MAT_Chance  | Slider | 0.15    | Chance AI get Medium AT (0-1)      |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear_AI".
</details>

<details>
  <summary>UGL_Chance</summary>

  ### Description
  Chance for UGL to be given to AI (0 = never, 1 = always).

  ### Parameters
  | Name        | Type   | Default | Description                        |
  |-------------|--------|---------|------------------------------------|
  | UGL_Chance  | Slider | 0.25    | Chance AI get UGL (0-1)            |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear_AI".
</details>

<details>
  <summary>Static_Enable_Chance</summary>

  ### Description
  Chance per loop to enable a Static AI to move (0 = never, 1 = always).

  ### Parameters
  | Name                 | Type   | Default | Description                        |
  |----------------------|--------|---------|------------------------------------|
  | Static_Enable_Chance | Slider | 0.4     | Chance static AI can move (0-1)    |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear_AI".
</details>

<details>
  <summary>Static_Enable_Refresh</summary>

  ### Description
  Delay per loop (in seconds) to enable movement.

  ### Parameters
  | Name                 | Type   | Default | Description                        |
  |----------------------|--------|---------|------------------------------------|
  | Static_Enable_Refresh| Slider | 60      | Static AI move refresh (seconds)   |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear_AI".
</details>

<details>
  <summary>AIForceNVG</summary>

  ### Description
  Forces addition of NVGs for AI.

  ### Parameters
  | Name        | Type     | Default | Description                        |
  |-------------|----------|---------|------------------------------------|
  | AIForceNVG  | Checkbox | false   | Force NVGs for AI                  |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear_AI".
</details>

<details>
  <summary>AIForceNVGClassname</summary>

  ### Description
  Classname to be used as NVG for AI. Leave blank for none.

  ### Parameters
  | Name                 | Type    | Default   | Description                        |
  |----------------------|---------|-----------|------------------------------------|
  | AIForceNVGClassname  | Editbox | *(empty)* | Override AI NVG classname          |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear_AI".
</details>

<details>
  <summary>GOL_RemoveVehicleHE_Enabled</summary>

  ### Description
  When enabled, Russian/Soviet vehicle variants will have their HE rounds removed.

  ### Parameters
  | Name                        | Type     | Default | Description                        |
  |-----------------------------|----------|---------|------------------------------------|
  | GOL_RemoveVehicleHE_Enabled | Checkbox | true    | Remove HE rounds from RU/SOV vehicles |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear_AI".
</details>

<details>
  <summary>GOL_VehicleAppearanceAI</summary>

  ### Description
  When enabled, certain AI Vehicles will have randomized vehicle appearance.

  ### Parameters
  | Name                  | Type     | Default | Description                        |
  |-----------------------|----------|---------|------------------------------------|
  | GOL_VehicleAppearanceAI| Checkbox| true    | Randomize AI vehicle appearance    |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear_AI".
</details>

<details>
  <summary>GOL_RemoveVehicleATGM_Enabled</summary>

  ### Description
  When enabled, Russian/Soviet vehicle variants will have their ATGM rounds removed.

  ### Parameters
  | Name                          | Type     | Default | Description                        |
  |-------------------------------|----------|---------|------------------------------------|
  | GOL_RemoveVehicleATGM_Enabled | Checkbox | true    | Remove ATGM rounds from RU/SOV vehicles |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Gear_AI".
</details>
</details>
<details>
  <summary>🔧 Player Composition Settings</summary>
<details>
  <summary>GOL_SelectedComposition</summary>

  ### Description
  Set the ORBAT Composition.

  ### Parameters
  | Name                   | Type | Default   | Description                     |
  |------------------------|------|-----------|---------------------------------|
  | GOL_SelectedComposition| List | Infantry  | ORBAT composition: Infantry/Mechanized |

  ### Example Usage
  Set in CBA Addon Options under "GOL_ORBAT".
</details>
</details>
<details>
  <summary>🔧 Hunt Settings</summary>
<details>
  <summary>GOL_Hunt_MaxCount</summary>

  ### Description
  The maximum allowed enemy hunters at any given time.

  ### Parameters
  | Name               | Type   | Default | Description                        |
  |--------------------|--------|---------|------------------------------------|
  | GOL_Hunt_MaxCount  | Slider | 40      | Max enemy hunters at once (10-100) |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Hunt".
</details>
</details>
<details>
  <summary>🔧 Suppression Settings</summary>
<details>
  <summary>GOL_Suppression_Enabled</summary>

  ### Description
  When enabled, AI will be able to be suppressed.

  ### Parameters
  | Name                   | Type     | Default | Description                        |
  |------------------------|----------|---------|------------------------------------|
  | GOL_Suppression_Enabled| Checkbox | true    | Enable AI suppression              |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Suppression".
</details>

<details>
  <summary>GOL_Suppression_Debug</summary>

  ### Description
  When enabled, DEBUG messages will play in the SystemChat.

  ### Parameters
  | Name                  | Type     | Default | Description                        |
  |-----------------------|----------|---------|------------------------------------|
  | GOL_Suppression_Debug | Checkbox | false   | Debug for suppression system       |

  ### Example Usage
  Set in CBA Addon Options under "GOL_DEBUG".
</details>

<details>
  <summary>GOL_Suppressed_Threshold</summary>

  ### Description
  For every friendly below 10 in the vicinity (this value) of the candidate, chance to surrender will increase.

  ### Parameters
  | Name                     | Type   | Default | Description                        |
  |--------------------------|--------|---------|------------------------------------|
  | GOL_Suppressed_Threshold | Slider | 0.75    | Surrender chance per friendly nearby (0-1) |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Suppression".
</details>

<details>
  <summary>GOL_Suppressed_MinimumTime</summary>

  ### Description
  Sets the minimum suppressed time for a unit to recover from suppression.

  ### Parameters
  | Name                        | Type   | Default | Description                        |
  |-----------------------------|--------|---------|------------------------------------|
  | GOL_Suppressed_MinimumTime  | Slider | 6       | Min suppressed time (seconds)      |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Suppression".
</details>

<details>
  <summary>GOL_Suppressed_MaximumTime</summary>

  ### Description
  Sets the maximum suppressed time for a unit to recover from suppression.

  ### Parameters
  | Name                        | Type   | Default | Description                        |
  |-----------------------------|--------|---------|------------------------------------|
  | GOL_Suppressed_MaximumTime  | Slider | 10      | Max suppressed time (seconds)      |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Suppression".
</details>
</details>
<details>
  <summary>🔧 Surrender Settings</summary>
<details>
  <summary>GOL_Surrender_Enabled</summary>

  ### Description
  When enabled, AI can surrender when threatened, suppressed, shot, flashbanged.

  ### Parameters
  | Name                  | Type     | Default | Description                        |
  |-----------------------|----------|---------|------------------------------------|
  | GOL_Surrender_Enabled | Checkbox | true    | Enable AI surrender                |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Surrender".
</details>

<details>
  <summary>GOL_Surrender_Debug</summary>

  ### Description
  When enabled, DEBUG messages will play in the SystemChat.

  ### Parameters
  | Name                | Type     | Default | Description                        |
  |---------------------|----------|---------|------------------------------------|
  | GOL_Surrender_Debug | Checkbox | false   | Debug for surrender system         |

  ### Example Usage
  Set in CBA Addon Options under "GOL_DEBUG".
</details>

<details>
  <summary>GOL_Surrender_Shot</summary>

  ### Description
  When enabled, AI can surrender when shot at.

  ### Parameters
  | Name               | Type     | Default | Description                        |
  |--------------------|----------|---------|------------------------------------|
  | GOL_Surrender_Shot | Checkbox | true    | Surrender if shot at               |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Surrender".
</details>

<details>
  <summary>GOL_Surrender_Flashbang</summary>

  ### Description
  When enabled, AI can surrender when flashbanged.

  ### Parameters
  | Name                    | Type     | Default | Description                        |
  |-------------------------|----------|---------|------------------------------------|
  | GOL_Surrender_Flashbang | Checkbox | true    | Surrender if flashbanged           |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Surrender".
</details>

<details>
  <summary>GOL_Surrender_FriendlyDistance</summary>

  ### Description
  For every friendly below 10 in the vicinity (this value) of the candidate, chance to surrender will increase.

  ### Parameters
  | Name                         | Type   | Default | Description                        |
  |------------------------------|--------|---------|------------------------------------|
  | GOL_Surrender_FriendlyDistance| Slider | 200     | Surrender: friendly check radius   |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Surrender".
</details>

<details>
  <summary>GOL_Surrender_Chance</summary>

  ### Description
  Probability (0 = never, 0.3 = very likely) that AI will surrender.

  ### Parameters
  | Name                | Type   | Default | Description                        |
  |---------------------|--------|---------|------------------------------------|
  | GOL_Surrender_Chance| Slider | 0.05    | Base surrender chance (0-0.3)      |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Surrender".
</details>

<details>
  <summary>GOL_Surrender_ChanceWeaponAim</summary>

  ### Description
  Probability (0 = never, 0.3 = very likely) that AI will surrender when aimed at.

  ### Parameters
  | Name                         | Type   | Default | Description                        |
  |------------------------------|--------|---------|------------------------------------|
  | GOL_Surrender_ChanceWeaponAim| Slider | 0.05    | Surrender chance if aimed at (0-0.3)|

  ### Example Usage
  Set in CBA Addon Options under "GOL_Surrender".
</details>

<details>
  <summary>GOL_Surrender_Distance</summary>

  ### Description
  Maximum distance (in meters) for surrender checks.

  ### Parameters
  | Name                 | Type   | Default | Description                        |
  |----------------------|--------|---------|------------------------------------|
  | GOL_Surrender_Distance| Slider| 200     | Surrender check max distance (m)   |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Surrender".
</details>

<details>
  <summary>GOL_Surrender_DistanceWeaponAim</summary>

  ### Description
  Maximum distance (in meters) for surrender checks by player aiming at unit.

  ### Parameters
  | Name                             | Type   | Default | Description                        |
  |----------------------------------|--------|---------|------------------------------------|
  | GOL_Surrender_DistanceWeaponAim  | Slider | 50      | Surrender check distance (aimed)   |

  ### Example Usage
  Set in CBA Addon Options under "GOL_Surrender".
</details>
</details>
<details>
  <summary>🔧 Faceswap Settings</summary>
 <details>
  <summary>GOL_FaceSwap_Enabled</summary>

  ### Description
  When enabled, AI will change faces based on your choices on mission start and when spawned.

  ### Parameters
  | Name                 | Type     | Default | Description                        |
  |----------------------|----------|---------|------------------------------------|
  | GOL_FaceSwap_Enabled | Checkbox | true    | Enable FaceSwap for AI             |

  ### Example Usage
  Set in CBA Addon Options under "GOL_FaceSwap".
</details> 
<details>
  <summary>GOL_FaceSwap_Debug</summary>

  ### Description
  When enabled, DEBUG messages will play in the SystemChat.

  ### Parameters
  | Name               | Type     | Default | Description                        |
  |--------------------|----------|---------|------------------------------------|
  | GOL_FaceSwap_Debug | Checkbox | false   | Debug for FaceSwap system          |

  ### Example Usage
  Set in CBA Addon Options under "GOL_DEBUG".
</details>

<details>
  <summary>GOL_FaceSwap_BLUFOR</summary>

  ### Description
  Set ethnic appearance for spawned BLUFOR units.

  ### Parameters
  | Name                  | Type | Default   | Description                        |
  |-----------------------|------|-----------|------------------------------------|
  | GOL_FaceSwap_BLUFOR   | List | American  | BLUFOR ethnicity                   |

  ### Example Usage
  Set in CBA Addon Options under "GOL_FaceSwap".
</details>

<details>
  <summary>GOL_FaceSwap_OPFOR</summary>

  ### Description
  Set ethnic appearance for spawned OPFOR units.

  ### Parameters
  | Name                  | Type | Default        | Description                        |
  |-----------------------|------|----------------|------------------------------------|
  | GOL_FaceSwap_OPFOR    | List | Middle Eastern | OPFOR ethnicity                    |

  ### Example Usage
  Set in CBA Addon Options under "GOL_FaceSwap".
</details>

<details>
  <summary>GOL_FaceSwap_INDEPENDENT</summary>

  ### Description
  Set ethnic appearance for spawned INDEPENDENT units.

  ### Parameters
  | Name                        | Type | Default        | Description                        |
  |-----------------------------|------|----------------|------------------------------------|
  | GOL_FaceSwap_INDEPENDENT    | List | Middle Eastern | INDEPENDENT ethnicity              |

  ### Example Usage
  Set in CBA Addon Options under "GOL_FaceSwap".
</details>

<details>
  <summary>GOL_FaceSwap_CIVILIAN</summary>

  ### Description
  Set ethnic appearance for spawned CIVILIAN units.

  ### Parameters
  | Name                     | Type | Default        | Description                        |
  |--------------------------|------|----------------|------------------------------------|
  | GOL_FaceSwap_CIVILIAN    | List | Middle Eastern | CIVILIAN ethnicity                 |

  ### Example Usage
  Set in CBA Addon Options under "GOL_FaceSwap".
</details>
</details>
</details> 

## Modules/Scripts
<details>
  <summary>🚩 Task Scripts</summary>
<details>
  <summary>OKS_fnc_FallbackArtillery</summary>

  ### Description
  Launches a fire mission with specified parameters.

  ### Parameters
  | Name              | Type            | Default             | Description                          |
  |-------------------|-----------------|---------------------|--------------------------------------|
  | `_Targets`        | Object/Array    | `objNull`           | Target object(s) or array of targets |
  | `_Munition`       | String          | `"rhs_ammo_3of56"`  | Type of munition to use              |
  | `_DelayBetweenRounds` | Number      | `5`                 | Delay between each round (seconds)   |
  | `_DelayUntilStrike`   | Number      | `180`               | Delay before strike starts (seconds) |
  | `_AmountOfRounds`     | Number      | `10`                | Number of rounds to fire             |
  | `_MunitionSpread`     | Number      | `100`               | Spread radius of munitions           |
  | `_ShouldBeRandom`     | Boolean     | `false`             | If true, targets are randomized      |
  | `_TaskParent`         | String/Nil  | `nil`               | Parent task identifier (optional)    |

  ### Example Usage
  [_Targets, _Munition, _DelayBetweenRounds, _DelayUntilStrike, _AmountOfRounds, _MunitionSpread, _ShouldBeRandom, _TaskParent] spawn OKS_fnc_FallbackArtillery;
</details>
<details>
  <summary>OKS_fnc_Defuse_Explosive</summary>

  ### Description
  Initiates a defusal sequence for an explosive device or position.  
  **Note:** Do not use too many at a time; can cause lag.  
  **Server-side only.** (If not run on the server, the function exits.)

  ### Parameters

  | Name                      | Type             | Default                | Description                                                         |
  |---------------------------|------------------|------------------------|---------------------------------------------------------------------|
  | `_ExplosiveOrPositionATL` | Object, Array    | `objNull`              | The explosive object or its ATL position as an array.               |
  | `_TimeInSeconds`          | Number           | `600`                  | Time (in seconds) for the defusal attempt.                          |
  | `_TargetObject`           | Object, Nil      | `nil`                  | Object to associate with the defusal (e.g., target or site).        |
  | `_Parent`                 | String, Nil      | `nil`                  | Parent task or identifier for tracking.                             |
  | `_PopUpNotification`      | Boolean          | `true`                 | Show a popup notification during defusal.                           |
  | `_ShouldShowPosition`     | Boolean          | `true`                 | If true, displays a position marker.                                |
  | `_VariableTrueOnFail`     | String           | `"ExplosiveDetonated"` | Variable set to true if defusal fails (detonation).                 |
  | `_VariableTrueOnSuccess`  | String           | `"ExplosiveDefused"`   | Variable set to true if defusal succeeds.                           |

  ### Example Usage
  [explosive_1, 60, targetObject, "Task_Main", true, false, "VariableOnSuccess", "VariableOnFail"] spawn OKS_fnc_Defuse_Explosive;
  [getPos explosiveSite_1, 60, targetObject, "Task_Main", true, true, "VariableOnSuccess", "VariableOnFail"] spawn OKS_fnc_Defuse_Explosive;
</details>
<details>
  <summary>OKS_fnc_ClearImmediateArea</summary>

  ### Description
  Creates a task for players to clear a specified area or building of enemy forces.  
  Dynamically generates a task and trigger zone based on the provided target and side.  
  **Note:** The task succeeds when all enemy units in the area are eliminated or incapacitated.

  ### Parameters

  | Name         | Type         | Default        | Description                                                                 |
  |--------------|--------------|----------------|-----------------------------------------------------------------------------|
  | `_Target`    | Object       | `objNull`      | The target object or building to clear (center of the area).                |
  | `_Side`      | String, Side | `"EAST"`       | Side to clear (as string: `"EAST"`, `"WEST"`, `"GUER"`, etc. or Side type). |
  | `_Parent`    | Any, Nil     | `nil`          | Optional parent task or identifier.                                         |
  | `_Range`     | Number       | `15`           | Radius (in meters) of the area to clear.                                    |
  | `_TaskTitle` | String       | `"Secure Area"`| Title for the task (displayed to players).                                  |
  | `_TaskIcon`  | String       | `"attack"`     | Icon for the task (e.g., `"attack"`, `"kill"`).                             |

  ### Example Usage
- Use `spawn OKS_fnc_ClearImmediateArea` for asynchronous execution.
- The function automatically converts Side types to their string equivalents.
- Task is marked as succeeded when the area is cleared of all enemy units.
</details>
<details>
  <summary>OKS_fnc_Destroy_Barricade</summary>

  ### Description
  Creates a task for players to destroy one or more barricades.  
  Generates a main task and subtasks for each barricade. Optionally adds an ACE action to plant explosives if only one barricade is present.

  ### Parameters

  | Name                        | Type     | Default | Description                                                               |
  |-----------------------------|----------|---------|---------------------------------------------------------------------------|
  | `_Barricades`               | Array    | —       | Array of barricade objects to be destroyed.                               |
  | `_TaskParent`               | Any, Nil | `nil`   | Optional parent task or identifier.                                       |
  | `_ShouldAddActionToDestroy` | Boolean  | `false` | If true and only one barricade, adds ACE action to plant explosives.      |

  ### Example Usage

      [[barricade_1, barricade_2]] spawn OKS_fnc_Destroy_Barricade;

      [[barricade_1, barricade_2], "TaskParent"] spawn OKS_fnc_Destroy_Barricade;
</details>
<details>
  <summary>OKS_fnc_Evacuate_HVT</summary>

  ### Description
  Creates a task to evacuate one or more high-value targets (HVTs) to an exfiltration site.  
  Handles captive and hostile HVTs, supports optional helicopter extraction, and manages task success or failure based on HVT status.

  ### Parameters

  | Name                | Type                | Default   | Description                                                         |
  |---------------------|---------------------|-----------|---------------------------------------------------------------------|
  | `_UnitsOrGroupOrArray` | Array, Group, Object | `[]`      | HVT units to evacuate (array, group, or single unit).               |
  | `_ExfilSite`        | Array, Object       | `[0,0,0]` | Exfiltration site position (array) or object.                       |
  | `_Side`             | Side                | `west`    | Side responsible for the task.                                      |
  | `_HelicopterEvac`   | Boolean             | `false`   | If true, requires helicopter extraction at exfil site.              |
  | `_ParentTask`       | String              | `""`      | Optional parent task or identifier.                                 |
  | `_IsCaptive`        | Boolean             | `true`    | If true, HVTs are set as captives; otherwise, they are hostile.     |

  ### Example Usage

      [Group HVT_1, getPos ExfilSite_1, west, false, nil] spawn OKS_fnc_Evacuate_HVT;

</details>
<details>
  <summary>OKS_fnc_Hostage</summary>

  ### Description
  Creates a task to manage and rescue one or more hostages.  
  Hostages are set to captive, handcuffed, and visually marked as restrained.

  ### Parameters

  | Name                   | Type              | Default | Description                                            |
  |------------------------|-------------------|---------|--------------------------------------------------------|
  | `_UnitsOrGroupOrArray` | Array, Group, Object | `[]`    | Hostage units (array, group, or single unit).          |
  | `_TaskParent`          | Any, Nil          | `nil`   | Optional parent task or identifier.                    |

  ### Example Usage

      [Group HVT_1] spawn OKS_fnc_Hostage;

      [Group HVT_1, getPos ExfilSite_1, west, false, nil] spawn OKS_fnc_Hostage;

</details>
<details>
  <summary>OKS_fnc_RandomArtillery</summary>

  ### Description
  Spawns a randomized artillery strike on a target, firing multiple rounds with configurable delay and spread.

  ### Parameters

  | Name                  | Type    | Default | Description                                                |
  |-----------------------|---------|---------|------------------------------------------------------------|
  | `_Target`             | Object  | —       | The target object or position for the artillery strike.     |
  | `_Munition`           | String  | —       | Classname of the munition to use (e.g., `"rhs_ammo_3of56"`).|
  | `_DelayBetweenRounds` | Number  | —       | Delay (in seconds) between each round.                     |
  | `_AmountOfRounds`     | Number  | —       | Total number of rounds to fire.                            |
  | `_MunitionSpread`     | Number  | —       | Maximum spread radius for impact points (in meters).        |

  ### Example Usage

      [targetObject, "rhs_ammo_3of56", 6, 10, 100] sleep OKS_fnc_RandomArtillery;

</details>
<details>
  <summary>OKS_fnc_Destroy_Task</summary>

  ### Description
  Creates a task to destroy or eliminate specified units or vehicles.  
  Supports custom titles, descriptions, icons, and task parent assignment. Handles both single targets and arrays of targets.

  ### Parameters

  | Name                      | Type           | Default     | Description                                                                                  |
  |---------------------------|----------------|-------------|----------------------------------------------------------------------------------------------|
  | `_Target`                 | Object, Array  | `objNull`   | The unit(s) or vehicle(s) to destroy or eliminate.                                           |
  | `_CustomTitle`            | String, Nil    | `nil`       | Custom task title. If not set, uses a default based on the target.                           |
  | `_CustomDisplayName`      | String, Nil    | `nil`       | Custom display name for the target.                                                          |
  | `_CustomDescription`      | String, Nil    | `nil`       | Custom description. Supports `%1` for name and `%2` for number of targets in arrays.         |
  | `_CustomIcon`             | String         | `"destroy"` | Task icon (e.g., `"kill"`, `"destroy"`).                                                     |
  | `_TaskParent`             | Any, Nil       | `nil`       | Optional parent task or identifier.                                                          |
  | `_ShouldShowPosition`     | Boolean        | `true`      | If true, task will display the target's position.                                            |
  | `_ShouldPopUpNotification`| Boolean        | `true`      | If true, shows a popup notification when the task is assigned or completed.                  |

  ### Example Usage

      [officer_1] spawn OKS_fnc_Destroy_Task;

      [[officer_1, officer_2, officer_3]] spawn OKS_fnc_Destroy_Task;

      [officer_1, "Kill the Officer", "Enemy Officer", "You need to kill this %1 because it needs to happen", "kill", nil, true, true] spawn OKS_fnc_Destroy_Task;

      [
          TargetOrTargets,
          TaskTitle,
          TargetName,
          TaskDescription, // "You need to kill this %1 because it needs to happen. There are %2 targets."
          TaskIcon,
          TaskParent,
          shouldShowPos,
          shouldPopUpNotify
      ] spawn OKS_fnc_Destroy_Task;

</details>
<details>
  <summary>OKS_fnc_Rescue_Friendly</summary>

  ### Description
  Spawns a friendly group with casualties at a building or position and creates a medical rescue task.  
  Garrisoned units are set as captives until players arrive. Subtasks are generated for stabilizing each casualty, with severity levels affecting medical requirements.

  ### Parameters

  | Name                | Type             | Default | Description                                                                 |
  |---------------------|------------------|---------|-----------------------------------------------------------------------------|
  | `_NumberInfantry`   | Number           | —       | Number of friendly units to spawn.                                          |
  | `_NumberOfCasualties` | Number         | —       | Number of casualties among the group.                                       |
  | `_Position`         | Array, Object    | —       | Position or building where the group is spawned/garrisoned.                 |
  | `_Side`             | Side             | —       | Side of the friendly group (e.g., `west`, `east`, `independent`).           |
  | `_ShouldCreateTasks`| Boolean          | —       | If true, creates tasks for the rescue operation.                            |
  | `_Severity`         | Array            | —       | Array of possible casualty severity levels (e.g., `["lot","large","fatal"]`).|
  | `_Parent`           | Any, Nil         | `nil`   | Optional parent task or identifier.                                         |
  | `_RushPositions`    | Array, Nil       | `nil`   | Optional array of positions for enemy rush/spawn triggers.                  |

  ### Example Usage

      [6, 3, getPos house1, east, true, ["lot", "large", "fatal"]] spawn OKS_fnc_Rescue_Friendly;

      [5, 1, getPos player, east, true, ["lot", "large", "fatal"]] spawn OKS_fnc_Rescue_Friendly;

</details>
</details>
<details>
  <summary>🚩 Spawn Scripts</summary>
<details>
  <summary>OKS_fnc_AI_Battle</summary>

  ### Description
  Spawns two opposing AI factions at designated spawn points and orchestrates a battle at a meeting position.  
  Supports custom vehicle types for each side and optional defending side logic.

  ### Parameters

  | Name                | Type     | Default                                         | Description                                                         |
  |---------------------|----------|-------------------------------------------------|---------------------------------------------------------------------|
  | `_Faction1Spawn`    | Object   | —                                               | Spawn position object for faction 1.                                |
  | `_Faction2Spawn`    | Object   | —                                               | Spawn position object for faction 2.                                |
  | `_MeetingPos`       | Object   | —                                               | Position object where the battle takes place.                       |
  | `_Side1`            | Side     | `west`                                          | Side for faction 1 (e.g., `west`).                                  |
  | `_Side2`            | Side     | `east`                                          | Side for faction 2 (e.g., `east`).                                  |
  | `_Faction1Classes`  | Array    | `["UK3CB_CW_US_B_EARLY_M1A1"]`                  | Array of vehicle classnames for faction 1.                          |
  | `_Faction2Classes`  | Array    | `["UK3CB_CHD_O_T72A"]`                          | Array of vehicle classnames for faction 2.                          |
  | `_DefendingSide`    | Side     | `sideUnknown`                                   | (Optional) Side that will defend and hold position.                 |

  ### Example Usage

      [
          west_1,
          east_1,
          meet_1,
          west,
          east,
          ["B_APC_Tracked_01_rcws_F", "B_APC_Tracked_01_rcws_F"],
          ["O_APC_Wheeled_02_rcws_v2_F", "O_APC_Wheeled_02_rcws_v2_F"]
      ] spawn OKS_fnc_AI_Battle;

</details>
<details>
  <summary>OKS_fnc_AirSpawn</summary>

  ### Description
  Spawns an aircraft at a specified position, assigns a waypoint, and sets crew behavior and altitude.  
  Supports customizable aircraft class, side, flight mode, and waypoint type.

  ### Parameters

  | Name                | Type          | Default | Description                                                                |
  |---------------------|---------------|---------|----------------------------------------------------------------------------|
  | `_SpawnPos`         | Array, Object | —       | Spawn position (array `[x,y,z]` or object).                                |
  | `_MoveToPos`        | Array, Object | —       | Destination position (array or object).                                    |
  | `_Classname`        | String        | —       | Classname of the aircraft to spawn.                                        |
  | `_Side`             | Side          | —       | Side to assign to the aircraft and crew.                                   |
  | `_ShouldBeCareless` | Boolean       | —       | If true, crew is set to "CARELESS"; otherwise, "STEALTH".                  |
  | `_WaypointType`     | String        | —       | Waypoint type (e.g., `"SAD"`, `"MOVE"`).                                   |
  | `_Height`           | Number        | —       | Altitude (in meters) for the aircraft to fly at spawn.                     |

  ### Example Usage

      [airspawn_1, [22278,19441.9,0], selectRandom ["UK3CB_CSAT_B_O_MIG21_AA", "UK3CB_CSAT_B_O_Su25SM", "UK3CB_CSAT_B_O_MIG21", "UK3CB_CSAT_B_O_MIG29SM"], east, false, "SAD", 1000] spawn OKS_fnc_AirSpawn;

      [Plane_1, PlaneExit_1, selectRandom ["UK3CB_AAF_B_L39_AA", "UK3CB_AAF_B_C130J_CARGO", "UK3CB_AAF_B_Gripen"], west, true, "MOVE"] spawn OKS_fnc_AirSpawn;

</details>
<details>
  <summary>OKS_fnc_Attack_SpawnGroup</summary>

  ### Description
  Spawns an AI group or vehicle at a specified position, assigns waypoints to attack a target or follow a path, and optionally adds a step waypoint before the attack. Supports dynamic group composition, side selection, and fallback hunt behavior.

  ### Parameters

  | Name                    | Type           | Default | Description                                                                 |
  |-------------------------|----------------|---------|-----------------------------------------------------------------------------|
  | `_Spawn`                | Object, Array  | —       | Spawn position (object or array).                                           |
  | `_TargetWaypoint`       | Object, Array, Nil | `nil` | Target waypoint (object, array of positions, or nil for fallback hunt).     |
  | `_ClassnameOrNumber`    | Number, String, Array | `5` | Number of infantry, classname, or array of vehicle classnames.              |
  | `_Side`                 | Side           | `east`  | Side for the spawned group or vehicle.                                      |
  | `_StepWaypoint`         | Boolean        | `false` | If true, adds a MOVE waypoint halfway before the attack waypoint.           |
  | `_RangeOfFallbackHunt`  | Number         | `1000`  | Range for fallback hunt script if no target waypoint is given.              |

  ### Example Usage

      [_this, player, 4, east, true, 500] spawn OKS_fnc_Attack_SpawnGroup;

      [SpawnPosOrObject, ArrayOrObject, UnitOrClassname, Side, ShouldAddStepWaypoint, RangeOfFallbackHuntScript] spawn OKS_fnc_Attack_SpawnGroup;

</details>
<details>
  <summary>OKS_fnc_Civilian_Vehicle</summary>

  ### Description
  Spawns a civilian vehicle with a driver at a start position, moves it to an end position, and optionally deletes the vehicle and driver upon arrival.

  ### Parameters

  | Name             | Type      | Default | Description                                                            |
  |------------------|-----------|---------|------------------------------------------------------------------------|
  | `_SpawnPosition` | Array     | —       | Position where the vehicle spawns.                                     |
  | `_EndPosition`   | Array     | —       | Destination position for the vehicle.                                  |
  | `_VehicleType`   | String    | —       | Classname of the civilian vehicle to spawn.                            |
  | `_Speed`         | Number    | `8`     | Speed at which the vehicle will travel.                                |
  | `_ShouldDelete`  | Boolean   | `true`  | If true, deletes the vehicle and driver after reaching the destination. |

  ### Example Usage

      [
          getPos civilianStart_1,
          getPos CivilianEnd_1,     
          selectRandom [
              "UK3CB_ADC_C_Datsun_Civ_Open",
              "UK3CB_ADC_C_Hatchback",
              "UK3CB_ADC_C_V3S_Repair",
              "UK3CB_ADC_C_Skoda",
              "UK3CB_ADC_C_Sedan",
              "UK3CB_ADC_C_UAZ_Open",
              "UK3CB_ADC_C_UAZ_Closed"
          ],
          10,
          true
      ] spawn OKS_fnc_Civilian_Vehicle;

</details>
<details>
  <summary>OKS_fnc_Mechanized_Spawn</summary>

  ### Description
  Spawns a mechanized group with a vehicle and accompanying infantry at a specified location, assigns hunting and attack behaviors, and manages group separation and coordination.

  ### Parameters

  | Name               | Type           | Default | Description                                                                 |
  |--------------------|----------------|---------|-----------------------------------------------------------------------------|
  | `_Spawn`           | Object, Array  | —       | Spawn position (object or array).                                           |
  | `_HuntTrigger`     | Object         | —       | Trigger or position for the group to hunt/attack towards.                   |
  | `_VehicleType`     | String, Array  | —       | Vehicle classname (string) or array of classnames for random selection.     |
  | `_InfantryNumber`  | Number         | `5`     | Number of accompanying infantry to spawn with the vehicle.                  |
  | `_Side`            | Side           | `east`  | Side for the spawned group and vehicle.                                     |
  | `_Range`           | Number         | `2000`  | Range for the infantry rush behavior after dismount.                        |

  ### Example Usage

      [this, Trigger_1, "O_APC_Wheeled_02_rcws_v2_F", 5, east, 500] spawn OKS_fnc_Mechanized_Spawn;

</details>
<details>
  <summary>OKS_fnc_Hold_Waypoint</summary>

  ### Description
  Spawns an AI infantry group or vehicle at a specified position and assigns them a HOLD waypoint at a target location.  
  Supports dynamic group or vehicle composition and sets defensive behavior at the waypoint.

  ### Parameters

  | Name                  | Type           | Default | Description                                                                |
  |-----------------------|----------------|---------|----------------------------------------------------------------------------|
  | `_Spawn`              | Object, Array  | —       | Spawn position (object or array).                                          |
  | `_TargetWaypoint`     | Object, Array  | —       | Target waypoint (object or array position).                                |
  | `_ClassnameOrNumber`  | Number, String, Array | `5` | Number of infantry, classname, or array of vehicle classnames.             |
  | `_Side`               | Side           | `east`  | Side for the spawned group or vehicle.                                     |

  ### Example Usage

      [SpawnPosOrObject, ArrayOrObject, UnitOrClassname, Side] spawn OKS_fnc_Hold_Waypoint;

</details>
<details>
  <summary>OKS_fnc_Scout</summary>

  ### Description
  Spawns a scout aircraft (UAV, helicopter, or plane) that patrols or loiters over a target area, spots players, and can call in mortar strikes when players are detected.  
  Supports custom flight behavior, spotting logic, and optional loadout configuration.

  ### Parameters

  | Name                  | Type      | Default                   | Description                                                                                   |
  |-----------------------|-----------|---------------------------|-----------------------------------------------------------------------------------------------|
  | `_SpawnPosition`      | Array     | —                         | Spawn position for the aircraft.                                                              |
  | `_TargetArea`         | Array     | —                         | Target position for the aircraft's waypoint.                                                  |
  | `_Side`               | Side      | `east`                    | Side of the aircraft and crew.                                                                |
  | `_Classname`          | String    | `"rhs_pchela1t_vvs"`      | Aircraft classname.                                                                           |
  | `_BehaviourArray`     | Array     | `["LOITER", true]`        | `[Waypoint Type, ShouldBeCareless]` (e.g., `["LOITER", false]`).                             |
  | `_SpottingArray`      | Array     | `[500, 4]`                | `[Spotting Distance, Spotting Value (0-1)]`.                                                  |
  | `_FlyingArray`        | Array     | `[250, 500]`              | `[Waypoint Altitude, Loiter Distance]`.                                                       |
  | `_Loadout`            | Array, Nil| `nil`                     | Optional array of pylon loadouts for the aircraft.                                            |
  | `_ShouldCallMortars`  | Boolean   | `true`                    | If true, calls in mortars when players are spotted.                                           |

  ### Example Usage

      [
          getPos drone_1,
          getPos droneTarget_1,
          east,
          "rhs_pchela1t_vvs",
          ["LOITER", false],
          [500, 4],
          [250, 500],
          ["", "", "", "", "", "", ""],
          true
      ] spawn OKS_fnc_Scout;
</details>
<details>
  <summary>OKS_fnc_Ambient_AAA</summary>

  ### Description
  Spawns and manages an ambient anti-air (AAA) gun or HMG, providing automatic engagement of air (and optionally ground) targets within a specified range.  
  Supports radar integration, AI crew spawning, and custom rate of fire settings.

  ### Parameters

  | Name               | Type           | Default           | Description                                                                                   |
  |--------------------|----------------|-------------------|-----------------------------------------------------------------------------------------------|
  | `_arty`            | Object         | `objNull`         | The anti-air object (vehicle or static weapon).                                               |
  | `_side`            | Side           | `east`            | The side that owns the AAA (e.g., `east`, `west`, `independent`).                             |
  | `_isHMG`           | Boolean        | `false`           | If true, treats the weapon as an HMG (improves accuracy for non-cannon weapons).              |
  | `_Range`           | Number         | `1500`            | Engagement range in meters.                                                                   |
  | `_Radar`           | Boolean        | `true`            | If true, AAA receives target info from nearby radar dishes.                                   |
  | `_Rof`             | Array          | `[10,15,20]`      | Possible rates of fire (number of shots per burst).                                           |
  | `_TimeBetweenShots`| Number         | `0`               | Time (in seconds) between shots in a burst.                                                   |

  ### Example Usage

      [this, east, false, 1500, true] spawn OKS_fnc_Ambient_AAA;

  - Place in any script context: unit init, triggers, or mission init.

</details>
<details>
  <summary>OKS_fnc_SAM</summary>

  ### Description
  Spawns and manages a surface-to-air missile (SAM) launcher, integrating with radar for automated target acquisition and engagement.  
  Supports custom rate of fire, ammo count, reload rate, altitude minimum, and maximum engagement range. Designed for use in mission init scripts or triggers.

  ### Parameters

  | Name                | Type    | Default | Description                                                                |
  |---------------------|---------|---------|----------------------------------------------------------------------------|
  | `_SAM`              | Object  | —       | The SAM launcher object.                                                   |
  | `_Radar`            | Object  | —       | Radar object for target detection and tracking.                            |
  | `_RateOfFire`       | Number  | `20`    | Time (in seconds) between missile launches.                                |
  | `_Ammo`             | Number  | `4`     | Number of missiles available before reload.                                |
  | `_ReloadRate`       | Number  | `20`    | Time (in seconds) to reload the launcher.                                  |
  | `_MinimumAltitude`  | Number  | `100`   | Minimum target altitude for engagement (in meters).                        |
  | `_MaxRange`         | Number  | `3000`  | Maximum engagement range (in meters).                                      |

  ### Example Usage

      [this, radar_1, 20, 4, 30] spawn OKS_fnc_SAM;

  - Place in the mission's `init.sqf` after a short delay for best results.

</details>
<details>
  <summary>OKS_fnc_Radar</summary>

  ### Description
  Links a radar object to nearby AAA vehicles, automatically sharing detected air targets within a specified range.  
  AAA vehicles will be given target information and will engage air targets that meet altitude and distance criteria.

  ### Parameters

  | Name                 | Type    | Default        | Description                                                                 |
  |----------------------|---------|----------------|-----------------------------------------------------------------------------|
  | `_Radar`             | Object  | —              | The radar object providing target detection.                                |
  | `_VehicleClassnames` | Array   | `[]`           | Array of AAA vehicle classnames to receive target data.                     |
  | `_ShareDistance`     | Number  | `2000`         | Maximum distance from radar to share targets with AAA vehicles (in meters). |
  | `_MaxRangeAAA`       | Number  | `2500`         | Maximum engagement range for AAA vehicles (in meters).                      |
  | `_MinimumAltitude`   | Number  | `100`          | Minimum altitude for targets to be shared (in meters).                      |

  ### Example Usage

      [this, ["rhsgref_ins_zsu234"], 200, 2500, 100] spawn OKS_fnc_Radar;

</details>
<details>
  <summary>OKS_fnc_Lambs_Spawner</summary>

  ### Description
  Continuously spawns groups of AI infantry at a given position using LAMBS AI behaviors, with support for dynamic disabling via trigger or variable.  
  Groups will hunt or rush players within a specified range and will respawn after being wiped out, unless disabled.

  ### Parameters

  | Name                        | Type           | Default   | Description                                                                 |
  |-----------------------------|----------------|-----------|-----------------------------------------------------------------------------|
  | `_SpawnPos`                 | Object, Array  | —         | Spawn position for the group (object or array).                             |
  | `_LambsType`                | String         | `"rush"`  | LAMBS AI behavior type (`"rush"`, `"hunt"`, etc.).                          |
  | `_NumberInfantry`           | Number         | `5`       | Number of infantry per group spawn.                                         |
  | `_Side`                     | Side           | `east`    | Side for the spawned group.                                                 |
  | `_Range`                    | Number         | `1500`    | Range for LAMBS AI tracking/hunting.                                        |
  | `_Array`                    | Array          | `[]`      | Array to store spawned units (for public variable use).                     |
  | `_ActivatedToDisableSpawner`| Object, String | `objNull` | Trigger object or variable name to disable the spawner.                     |
  | `_RespawnDelay`             | Number         | `180`     | Delay in seconds before respawning a new group after the previous is lost.  |

  ### Example Usage

      [SpawnPos, "hunt", UnitsPerBase, Side, Range, [], TriggerActivatedToDisableSpawner] spawn OKS_fnc_Lambs_Spawner;

  - Spawner will continue until the trigger is activated or variable is set true.
  - Groups use LAMBS AI for advanced hunting and combat behaviors.

</details>
<details>
  <summary>OKS_fnc_Lambs_SpawnGroup</summary>

  ### Description
  Spawns a group of AI infantry at a given position and assigns them a LAMBS AI behavior (hunt, rush, creep, ambush, etc.) based on the specified type.  
  Supports dynamic group composition, side selection, and advanced AI behaviors for mission scenarios.

  ### Parameters

  | Name             | Type           | Default | Description                                                        |
  |------------------|----------------|---------|--------------------------------------------------------------------|
  | `_SpawnPos`      | Object, Array  | —       | Spawn position for the group (object or array).                    |
  | `_LambsType`     | String         | —       | LAMBS AI behavior type (`"hunt"`, `"rush"`, `"creep"`, etc.).      |
  | `_NumberInfantry`| Number         | `5`     | Number of infantry to spawn in the group.                          |
  | `_Side`          | Side           | `east`  | Side for the spawned group.                                        |
  | `_Range`         | Number         | `1500`  | Range for LAMBS AI tracking/hunting.                               |
  | `_Array`         | Array          | `[]`    | Array to store spawned units (for public variable use).            |

  ### Example Usage

      [SpawnPos, "rush", UnitsPerBase, Side, Range, []] spawn OKS_fnc_Lambs_SpawnGroup;

  - Group will use the specified LAMBS AI behavior and engage players dynamically.
  - Supports advanced behaviors such as ambush, creep, hunt, and rush for flexible mission scripting[1][3].

</details>
<details>
  <summary>OKS_fnc_Lambs_Wavespawn</summary>

  ### Description
  Spawns multiple waves of AI infantry at one or more positions, using LAMBS AI behaviors for each wave.  
  Each wave is spawned after a configurable delay, and a variable is set to true when all spawned units are eliminated or unconscious.

  ### Parameters

  | Name           | Type           | Default                   | Description                                                               |
  |----------------|----------------|---------------------------|---------------------------------------------------------------------------|
  | `_SpawnPos`    | Object, Array  | —                         | Single position or array of positions for spawning each wave.              |
  | `_UnitsPerWave`| Number         | —                         | Number of infantry units to spawn per wave.                                |
  | `_AmountOfWaves`| Number        | —                         | Total number of waves to spawn.                                            |
  | `_DelayPerWave`| Number         | —                         | Delay (in seconds) between each wave.                                      |
  | `_LambsType`   | String         | `"rush"`                  | LAMBS AI behavior for each wave (`"hunt"`, `"rush"`, etc.).                |
  | `_Side`        | Side           | `east`                    | Side for the spawned groups.                                               |
  | `_Range`       | Number         | `1500`                    | Range for LAMBS AI tracking/hunting.                                       |
  | `_Variable`    | String         | `"Rush_WaveSpawn_Variable"`| Variable name to set true when all spawned units are eliminated.           |

  ### Example Usage

      [SpawnPosOrPositionsInArray, UnitsPerWave, AmountOfWaves, DelayPerWave, TypeOfWP, Side, Range, "VariableNameSetTrueUponAllClear"] spawn OKS_fnc_Lambs_Wavespawn;

      [[getPos spawn_1, getPos spawn_2], 5, 2, 120, "hunt", east, 1500, "WaveSpawn1Destroyed"] spawn OKS_fnc_Lambs_Wavespawn;

  - Supports spawning at multiple positions per wave.
  - Automatically sets the specified variable to true and public on all machines when all spawned units are dead or unconscious.
  - Integrates with LAMBS AI for advanced group behaviors[1][3].

</details>
<details>
  <summary>OKS_fnc_SpawnInfantryPincer</summary>

  ### Description
  Spawns a coordinated infantry pincer attack: two base-of-fire groups and two flanking groups, all targeting a player detected within a certain range and "knowsAbout" threshold.  
  Flankers and base-of-fire teams are positioned and tasked dynamically based on player location, with customizable angles, distances, and spawn spread.

  ### Parameters

  | Name                  | Type     | Default      | Description                                                                                                  |
  |-----------------------|----------|--------------|--------------------------------------------------------------------------------------------------------------|
  | `_SpawnPosition`      | Object   | —            | Position or object to spawn all groups from (should face suspected player positions).                        |
  | `_Side`               | Side     | `east`       | Side of the enemy units.                                                                                     |
  | `_NumbersArray`       | Array    | `[10,10,10]` | `[BaseOfFire 1, BaseOfFire 2, Left Flank, Right Flank]`—number of units in each respective group.            |
  | `_Range`              | Number   | `1500`       | Range to check for players. Script waits until at least one is detected within this range.                   |
  | `_KnowsAboutLimit`    | Number   | `-1`         | Minimum "knowsAbout" value the enemy must have on a player to activate (0–4 scale).                          |
  | `_FlankAngle`         | Number   | `45`         | Angle (in degrees) for left/right flanking movement relative to the target.                                  |
  | `_FlankingDistance`   | Number   | `-1`         | Distance (in meters) from target for flanking waypoints.                                                     |
  | `_BaseOfFireAngle`    | Number   | `15`         | Spread angle (in degrees) for base-of-fire teams to widen their attack formation.                            |
  | `_FlankingSpawnSpread`| Number   | `50`         | How far (in meters) to spread out the flankers' initial spawn from the center.                               |

  ### Example Usage

      [attack_1, east, [8,8,10,10], 1500, -1, 90, 250, 10, 100] spawn OKS_fnc_SpawnInfantryPincer;

  - Waits for a player to be detected within range and with sufficient "knowsAbout" before spawning and assigning groups.
  - Base-of-fire and flanking teams are spawned and tasked using supporting OKS functions for suppressive and flanking movement.
  - Ideal for creating dynamic, coordinated AI attacks in Arma 3 missions[1][4].

</details>
<details>
  <summary>OKS_fnc_Convoy_Reinforce</summary>

  ### Description
  Spawns and manages a reinforcement convoy that moves from a spawn position through waypoints, optionally carrying troops, and can perform resupply tasks.  
  Supports customizable vehicle types, troop loading, forced AI behavior, and completion triggers for dynamic Arma 3 missions.

  ### Parameters

  | Name                   | Type            | Default                     | Description                                                                                 |
  |------------------------|-----------------|-----------------------------|---------------------------------------------------------------------------------------------|
  | `_Spawn`               | Object          | —                           | Spawn position for the convoy.                                                              |
  | `_Waypoint`            | Object          | —                           | First waypoint object for the convoy.                                                       |
  | `_End`                 | Object          | —                           | Final waypoint object (where convoy disperses).                                             |
  | `_Side`                | Side            | `east`                      | Side of the convoy units.                                                                   |
  | `_VehicleArray`        | Array           | `[3,["UK3CB_ARD_O_BMP1"],6,25]` | `[Count, Classnames (array/string), Speed (m/s), Dispersion (m)]`.                          |
  | `_CargoArray`          | Array           | `[true,4]`                  | `[Should spawn troops in cargo (bool), Max soldiers per vehicle (int)]`.                    |
  | `_ForcedCareless`      | Boolean         | `false`                     | If true, forces convoy AI to behave "careless" (no reaction to threats).                    |
  | `_VariableSetToTrue`   | String          | `""`                        | Variable name to set true when the convoy completes its task.                               |
  | `_ResupplySize`        | String          | `"small"`                   | Size of the resupply task (e.g., `"small"`, `"medium"`, `"large"`).                         |
  | `_ShouldCreateTask`    | Boolean         | `true`                      | If true, creates a resupply task for the convoy.                                            |
  | `_ShouldResupply`      | Boolean         | `true`                      | If true, enables resupply functionality for the convoy.                                     |

  ### Example Usage

      [reinforce_1, reinforce_2, reinforce_3, west, [4, ["rhs_btr60_msv"], 6, 25], [true, 6], false, "variable", "small", true, true] spawn OKS_fnc_Convoy_Reinforce;

  - Vehicles and troops are spawned at the start, move through waypoints, and disperse at the end.
  - Supports dynamic troop loading, convoy dispersion, and mission task integration for advanced reinforcement scenarios.
  - Completion variable is set to true when the convoy finishes its task, enabling further mission scripting[1][2].

</details>
<details>
  <summary>OKS_fnc_Convoy_Spawn</summary>

  ### Description
  Spawns a convoy of vehicles (optionally with troops in cargo) at a specified position, moves them through waypoints, and can delete the convoy upon reaching the final waypoint.  
  Supports customizable vehicle types, troop loading, forced AI behavior, and dynamic convoy array management.

  ### Parameters

  | Name                | Type    | Default                           | Description                                                                 |
  |---------------------|---------|-----------------------------------|-----------------------------------------------------------------------------|
  | `_Spawn`            | Object  | —                                 | Spawn position for the convoy.                                              |
  | `_Waypoint`         | Object  | —                                 | First waypoint object for the convoy.                                       |
  | `_End`              | Object  | —                                 | Final waypoint object (where convoy disperses or is deleted).               |
  | `_Side`             | Side    | `east`                            | Side of the convoy units.                                                   |
  | `_VehicleArray`     | Array   | `[3,["UK3CB_ARD_O_BMP1"],6,25]`   | `[Count, Classnames (array/string), Speed (m/s), Dispersion (m)]`.          |
  | `_CargoArray`       | Array   | `[true,4]`                        | `[Should spawn troops in cargo (bool), Max soldiers per vehicle (int)]`.    |
  | `_ConvoyArray`      | Array   | `[]`                              | Array that gets filled with convoy units (for tracking or later use).       |
  | `_ForcedCareless`   | Boolean | `false`                           | If true, forces convoy AI to behave "careless" (no reaction to threats).    |
  | `_DeleteAtFinalWP`  | Boolean | `false`                           | If true, deletes convoy vehicles and units at the final waypoint.           |

  ### Example Usage

      [convoy_1, convoy_2, convoy_3, east, [4, ["rhs_btr60_msv"], 6, 25], [true, 6], [], false, false] spawn OKS_fnc_Convoy_Spawn;

  - Vehicles and (optionally) troops are spawned at the start, move through waypoints, and can be deleted on completion.
  - The convoy array is filled with all spawned vehicles and units for further scripting or tracking.
  - Designed for flexible convoy and reinforcement scenarios in Arma 3 missions[1][2].

</details>
<details>
  <summary>OKS_fnc_ArtyFire</summary>

  ### Description
  Spawns and manages an artillery fire mission: an artillery piece (with optional full crew) fires a specified number of rounds at a target position, with configurable rearm and reload times.  
  Includes projectile management to delete shells after impact or if they travel too far, optimizing performance for large-scale Arma 3 missions.

  ### Parameters

  | Name         | Type    | Default     | Description                                                               |
  |--------------|---------|-------------|---------------------------------------------------------------------------|
  | `_side`      | Side    | `east`      | Side of the artillery unit.                                               |
  | `_arty`      | Object  | —           | Artillery object (vehicle or static weapon).                              |
  | `_target`    | Array   | —           | Target position (array, e.g., `getMarkerPos "marker"`).                   |
  | `_rof`       | Number  | `5`         | Number of rounds to fire per fire mission.                                |
  | `_time`      | Number  | `60`        | Rearm time (seconds) between fire missions.                               |
  | `_reload`    | Number  | `300`       | Reload time (seconds) after expending all rounds.                         |
  | `_FullCrew`  | Boolean | `false`     | If true, spawns a full crew for the artillery piece.                      |

  ### Example Usage

      [east, this, getMarkerPos "respawn_west", 7, 300, 30] spawn OKS_fnc_ArtyFire;

      [east, ArtyName, TargetObjectPosition, RoundsFired, RearmTime, ReloadTime] spawn OKS_fnc_ArtyFire;

  - Artillery will fire at the specified target, then rearm/reload as configured.
  - Projectiles are deleted after impact or if they travel too far, improving performance.
  - Full crew option allows for realistic manning and operation of the artillery piece.

</details>
<details>
  <summary>OKS_fnc_ArtyFire</summary>

  ### Description
  Spawns and manages an artillery fire mission: an artillery piece (with optional full crew) fires a specified number of rounds at a target position, with configurable rearm and reload times.  
  Includes projectile management to delete shells after impact or if they travel too far, optimizing performance for large-scale Arma 3 missions.

  ### Parameters

  | Name         | Type    | Default     | Description                                                               |
  |--------------|---------|-------------|---------------------------------------------------------------------------|
  | `_side`      | Side    | `east`      | Side of the artillery unit.                                               |
  | `_arty`      | Object  | —           | Artillery object (vehicle or static weapon).                              |
  | `_target`    | Array   | —           | Target position (array, e.g., `getMarkerPos "marker"`).                   |
  | `_rof`       | Number  | `5`         | Number of rounds to fire per fire mission.                                |
  | `_time`      | Number  | `60`        | Rearm time (seconds) between fire missions.                               |
  | `_reload`    | Number  | `300`       | Reload time (seconds) after expending all rounds.                         |
  | `_FullCrew`  | Boolean | `false`     | If true, spawns a full crew for the artillery piece.                      |

  ### Example Usage

      [east, this, getMarkerPos "respawn_west", 7, 300, 30] spawn OKS_fnc_ArtyFire;

      [east, ArtyName, TargetObjectPosition, RoundsFired, RearmTime, ReloadTime] spawn OKS_fnc_ArtyFire;

  - Artillery will fire at the specified target, then rearm/reload as configured.
  - Projectiles are deleted after impact or if they travel too far, improving performance.
  - Full crew option allows for realistic manning and operation of the artillery piece.

</details>
<details>
  <summary>OKS_fnc_IR_AA</summary>

  ### Description
  Spawns and manages an infrared (IR) anti-air (AA) soldier or unit at a specified position or from an object, with configurable engagement parameters.  
  The AA unit will target and engage aircraft within altitude and range constraints, with a reload timer between engagements.

  ### Parameters

  | Name               | Type           | Default     | Description                                                                 |
  |--------------------|----------------|-------------|-----------------------------------------------------------------------------|
  | `_UnitOrPosition`  | Object, Array  | —           | Object to use as the AA unit, or position array to spawn one.               |
  | `_Side`            | Side           | `east`      | Side for the AA unit.                                                       |
  | `_MinimumAltitude` | Number         | `200`       | Minimum altitude (in meters) for target engagement.                         |
  | `_MinimumRange`    | Number         | `500`       | Minimum range (in meters) for target engagement.                            |
  | `_MaximumRange`    | Number         | `2500`      | Maximum range (in meters) for target engagement.                            |
  | `_ReloadTime`      | Number         | `20`        | Time (in seconds) between missile launches.                                 |
  | `_Array`           | Array, Nil     | `nil`       | Optional array to store or track spawned AA units.                          |

  ### Example Usage

      [this, east, 50, _MinimumRange, 2000, 30] spawn OKS_fnc_IR_AA;

      [UnitOrPosition, _Side, _MinimumAltitude, _MinimumRange, _MaximumRange, _ReloadTime] spawn OKS_fnc_IR_AA;

  - Automatically spawns an AA soldier if given a position, or uses the provided object.
  - Engages air targets within the specified altitude and range, with reload timing.
  - Optional array parameter allows tracking of spawned units for further scripting.
</details>



</details>  
<details>
  <summary>🚩 Mortars</summary>
  <details>
  <summary>OKS_fnc_Mortars</summary>

  ### Description
  Spawns and manages mortar or artillery fire missions, supporting both manned and off-map mortars with a variety of firing modes, round types, and targeting options.  
  Highly flexible for both continuous and single-shot strikes, with detailed control over accuracy, ammo, and firing behavior.

  ### Parameters

  | Name         | Type      | Description                                                                                       |
  |--------------|-----------|---------------------------------------------------------------------------------------------------|
  | 1. Mortar    | Object/String | The mortar object (e.g., `this` for static weapon) or `"OffMap"` for off-map strike.        |
  | 2. Side      | Side      | Side assigned to the mortar (e.g., `east`, `west`).                                               |
  | 3. Firing Mode | String  | `"Sporadic"`, `"Precise"`, `"Barrage"`, `"Guided"`, `"Screen"`, or `"Random"`.                   |
  | 4. Round Type | String   | `"Light"`, `"Medium"`, `"Heavy"`, `"Smoke"`, `"Flare"` (predefined in `NEKY_Settings.sqf`).      |
  | 5. Target Array | Array  | `[Position or Marker, Inaccuracy]` or `["Auto", Inaccuracy]` for automatic targeting.             |
  | 6. Min Range | Number    | Minimum range for auto-targeting (ignored if not using `"Auto"`).                                 |
  | 7. Max Range | Number    | Maximum range for auto-targeting (ignored if not using `"Auto"`).                                 |
  | 8. Ammo      | Number    | Total ammo for this mortar (overrides settings for this instance).                                |

  ### Example Usage

      [this, east, "precise", "light", ["auto", 50], 150, 400, 300] spawn OKS_fnc_Mortars;
      [Mortar1, west, "Barrage", "Medium", ["auto", 30], 100, 500, 20] spawn OKS_fnc_Mortars;
      ["OffMap", west, "Precise", "light", ["marker_position", 75]] spawn OKS_fnc_Mortars;

  ### Firing Modes

  - **Sporadic:** Random, inaccurate, medium refire rate.
  - **Precise:** Accurate, slow refire rate.
  - **Barrage:** Fairly accurate, rapid fire.
  - **Guided:** First shot inaccurate, subsequent shots increasingly accurate and rapid.
  - **Screen:** Fires in a line for smoke screens (best for off-map); overrides inaccuracy.
  - **Random:** Randomly selects a firing mode each cycle.

  ### Notes

  - `"Auto"` targeting makes the mortar select its own target within min/max range.
  - Off-map mortars only fire once per call.
  - Manned mortars with `"Auto"` repeat until destroyed or unmanned.
  - All parameters are designed for robust magazine and launcher management[1][2][6].

</details>
</details>  
<details>
  <summary>🚩 Hunt Bases</summary>
  <details>
  <summary>OKS_fnc_HuntBase</summary>

  ### Description
  Spawns waves of infantry or vehicles from a destructible "base" object, using a specified spawn point and trigger zone to define the hunting area.  
  Units or vehicles will only spawn and hunt when players are detected inside the trigger zone and the base object is alive.  
  Supports both infantry groups and vehicle crews, with customizable wave count, respawn delay, side, and refresh rate.

  ### Parameters

  | Name               | Type             | Default      | Description                                                                                       |
  |--------------------|------------------|--------------|---------------------------------------------------------------------------------------------------|
  | `_Base`            | Object           | —            | The destructible base object. If destroyed, no further waves will spawn.                          |
  | `_SpawnPos`        | Object           | —            | The object at which units/vehicles spawn (use a small object for best results).                   |
  | `_HuntZone`        | Object           | —            | Trigger area that defines the hunting zone for spawned units.                                     |
  | `_Waves`           | Number           | `0`          | Number of waves to spawn (0–999).                                                                |
  | `_RespawnDelay`    | Number           | `0`          | Delay (in seconds) between each wave spawn.                                                       |
  | `_Side`            | Side             | `east`       | Side of the spawned units or vehicles.                                                            |
  | `_Soldiers`        | Number/String/Array | `0`       | Number of infantry per group (scalar), vehicle classname (string), or array of classnames.        |
  | `_RefreshRate`     | Number           | `0`          | Time (in seconds) between checks for players in the hunt zone (lower = faster response).          |
  | `_ShouldDeployFlare`| Boolean         | `true`       | If true, units may deploy flares during CQB or at night (optional, default true).                 |

  ### Example Usage

      [Object_1, Spawn_1, HuntTrigger_1, 10, 300, east, 6, 60] spawn OKS_fnc_HuntBase;
      [Object_1, Spawn_1, HuntTrigger_1, 10, 450, east, "CUP_O_BTR40_MG_TKM", 30] spawn OKS_fnc_HuntBase;
      [Object_1, Spawn_1, HuntTrigger_1, 10, 450, east, ["CUP_O_MTLB_pk_TK_MILITIA", "CUP_O_BTR40_MG_TKM"], 30] spawn OKS_fnc_HuntBase;

  - Place destructible "base" and spawn objects in the editor, and set up a trigger for the hunt zone.
  - Units/vehicles spawn only if the base is alive and players are detected within the trigger.
  - Supports both infantry and vehicle waves, with random selection if an array of classnames is provided.
  - Refresh rate controls how quickly the script responds to player presence in the zone.
  - Designed for robust, dynamic reinforcement and hunting behaviors in Arma 3 missions.

</details>
<details>
  <summary>OKS_fnc_HuntRun</summary>

  ### Description
  Spawns or manages a hunting AI group that tracks and pursues players within a defined trigger zone.  
  Supports dynamic group creation, respawning, custom spawn distances, periodic updates, and optional custom code execution on each spawn.  
  Designed for flexible, performance-aware reinforcement and hunting behaviors in Arma 3 missions.

  ### Parameters

  | Name         | Type           | Description                                                                                 |
  |--------------|----------------|---------------------------------------------------------------------------------------------|
  | 1. Side/Group/Unit | Side/Group/Object | Side to spawn new AI, or an existing group/unit to manage.                        |
  | 2. Number    | Number/Nil     | Number of units to spawn (nil if using an existing group/unit).                            |
  | 3. Zone      | Object         | Trigger zone object that defines the hunting area.                                          |
  | 4. Distance  | Number         | (Optional) Spawn distance from player; also controls despawn/respawn logic.                |
  | 5. Update Freq | Number       | (Optional) How often (in seconds) the AI team updates its knowledge of player position.     |
  | 6. Repeat    | Number         | (Optional) How many times the hunting team will respawn (0 = no respawn).                  |
  | 7. {Code}    | Code           | (Optional) Code block executed when the AI group spawns and starts hunting.                |

  ### Example Usage

      [EAST, 4, Zone1, 600] spawn OKS_fnc_HuntRun;
      [MyUnit, 3, Trigger1] spawn OKS_fnc_HuntRun;
      [EnemyGroup, 0, Trigger1, nil, nil, {SystemChat "Enemy Group: We're on the trace!"}] spawn OKS_fnc_HuntRun;
      [Enemies, 0, Zone1, 0, 10] spawn OKS_fnc_HuntRun;

  ### Notes

  - The hunting group receives two waypoints: one ~300m before the player, and one randomly within 75m.
  - AI behavior transitions from "AWARE" to "COMBAT" as they close in.
  - Groups despawn if too far from all players, and can respawn closer if needed.
  - Trigger zones can be enabled/disabled dynamically using `SetVariable ["NEKY_Hunt_Disabled", true/false, true]`.
  - Custom code can be passed and will execute on each spawn, with `[AI Group, Player, Zone]` as arguments.
  - Designed for robust, dynamic AI hunting and reinforcement scenarios in Arma 3.

</details>

</details>  
<details>
  <summary>🚩 Dynamic Framework</summary>
<details>
  <summary>OKS_CreateZone</summary>

  ### Description
  Dynamically creates and manages a mission zone with AI garrisons, patrols, vehicles, roadblocks, mortars, objectives, hunt bases, and optional civilian presence.  
  Uses Eden-Editor locations and triggers to optimize strongpoint and objective placement, supporting both static and patrol AI, vehicles, and mission objectives.

  ### Parameters

  | Name                | Type      | Default                    | Description                                                                                       |
  |---------------------|-----------|----------------------------|---------------------------------------------------------------------------------------------------|
  | `_MainTrigger`      | Object    | —                          | Trigger object defining the spawn area for the zone.                                              |
  | `_SplitTrigger`     | Boolean   | `false`                    | (Unused/Reserved) Keep false.                                                                     |
  | `_InfantryNumber`   | Array     | `[0,0,false,false]`        | `[Static Infantry, Patrol Infantry, CreateSectorObjective?, LocalPatrols?]`                       |
  | `_Side`             | Side      | `sideUnknown`              | Side of the enemy forces (e.g., `east`).                                                          |
  | `_WheeledCount`     | Number    | `0`                        | Number of wheeled vehicles on patrol.                                                             |
  | `_apcCount`         | Number    | `0`                        | Number of APCs on patrol.                                                                         |
  | `_tankCount`        | Number    | `0`                        | Number of tanks on patrol.                                                                        |
  | `_RoadblockArray`   | Array     | `[0,false,false,0]`        | `[Count, OnlyOnTarmac, LocalPatrols?, ChanceForVehicle(0-1)]`                                     |
  | `_MortarArray`      | Array     | `[0,false]`                | `[Count, LocalPatrols?]`                                                                          |
  | `_ObjectiveArray`   | Array     | `[0,false]`                | `[Count, LocalPatrols?]`                                                                          |
  | `_HuntbaseArray`    | Array     | `[0,0,0,0,0]`              | `[Infantry, Wheeled, APC, Tank, Helicopter]` hunt bases (prefers 'Respawn Point' logics).         |
  | `_DynamicCivilians` | Boolean   | `false`                    | Enables dynamic civilian presence (requires 'Village' logic).                                     |

  ### Example Usage

      [ Trigger_1, false, [8,25,false,false], east, 0, 0, 0, [0,true,false,0], [0,false], [0,false], [0,0,0,0,0], false ] spawn OKS_CreateZone;

  - Infantry and vehicles are spawned as static garrisons or patrols, with optional sector objectives and local patrols.
  - Roadblocks, mortars, and objectives can have their own local patrols and are best placed using Eden-Editor locations for optimal results.
  - Hunt bases and dynamic civilians are supported for advanced mission dynamics.
  - The script leverages your expertise in unit spawning, control systems, and custom mission scripting for Arma 3[2][4].

</details>
<details>
  <summary>OKS_fnc_CreateObjectives</summary>

  ### Description
  Dynamically creates a variety of mission objectives at a specified position or object, supporting multiple objective types, patrols, placed objects, and custom task notifications.  
  Objective completion can be tracked via a variable set on the position/object, enabling follow-up scripting or triggers.

  ### Parameters

  | Name                    | Type        | Default    | Description                                                                                      |
  |-------------------------|-------------|------------|--------------------------------------------------------------------------------------------------|
  | `_Position`             | Object/Array| —          | Position array or object where the objective is created.                                         |
  | `_TypeOfObjective`      | String      | —          | Type of objective (`"sector"`, `"neutralize"`, `"cache"`, `"motorpool"`, etc.).                  |
  | `_Range`                | Number      | —          | Area radius or range for the objective.                                                          |
  | `_Side`                 | Side        | —          | Side that owns or defends the objective.                                                         |
  | `_ObjectivePatrols`     | Boolean     | —          | If true, spawns patrols around the objective.                                                    |
  | `_ShouldAddObjects`     | Boolean     | `true`     | If true, places objects relevant to the objective type (e.g., cache, truck, tower).              |
  | `_OverrideTaskNotification` | Boolean | `false`    | If true, disables or customizes the default task notification.                                   |
  | `_Parent`               | String/Nil  | `nil`      | Optional parent task or identifier for task hierarchy.                                           |

  ### Types Available

  - **sector:** Clear an area.
  - **neutralize:** Clear a building.
  - **cache:** Destroy weapons cache.
  - **motorpool:** Destroy supply vehicle.
  - **ammotruck:** Destroy a patrolling supply vehicle.
  - **radiotower:** Destroy a radio tower (affects hunt response/respawn delay).
  - **hvttruck:** Destroy a patrolling vehicle with an HVT.
  - **artillery:** Destroy an active artillery piece.
  - **antiair:** Destroy an active anti-air position.
  - **hostage:** Secure a building with hostiles and two hostages.

  ### Example Usage

      [Object_1, "sector", 300, EAST, false, false, false] spawn OKS_fnc_CreateObjectives;
      [Position, "cache", 100, EAST, true, true, false] spawn OKS_fnc_CreateObjectives;

  ### Objective Completion Tracking

  - If `_Position` is an object, it will receive the variable `OKS_ObjectiveComplete` set to `true` upon completion.
  - To trigger follow-up code:

        waitUntil {sleep 10; ObjectName getVariable ["OKS_ObjectiveComplete", false]};
        // YOUR FOLLOW-UP CODE HERE

  - Supports integration with custom UI elements or mission stat displays, as well as advanced unit spawning and control systems[1][2][4][5].

</details>
<details>
  <summary>OKS_fnc_Civilians</summary>

  ### Description
  Dynamically spawns and manages civilian presence within a trigger area, including both static and moving civilians, with customizable behavior, ethnicity, and panic response.  
  Civilians can use Arma 3 agents for performance, and all spawned civilians can be deleted when the main trigger is deactivated or destroyed.

  ### Parameters

  | Name              | Type      | Description                                                                 |
  |-------------------|-----------|-----------------------------------------------------------------------------|
  | 1. Trigger        | Object    | Trigger area for civilian spawning and behavior control.                     |
  | 2. Number         | Number    | Total number of civilians to spawn.                                          |
  | 3. Static Number  | Number    | Number of civilians assigned to static positions (e.g., sitting, idle).      |
  | 4. House WPs      | Number    | Number of waypoints assigned inside houses for civilian movement.            |
  | 5. Outside WPs    | Number    | Number of random outside waypoints for civilian movement.                    |
  | 6. Use Agents     | Boolean   | If true, uses Arma 3 agents for civilians (better performance, limited anims).|
  | 7. Panic Mode     | Boolean   | If true, civilians will enter panic mode (run, hide, react to combat).       |
  | 8. Ethnicity      | String    | (Optional) Ethnicity for faces/appearance (default: "Caucasian").            |
  | 9. MainTrigger    | Object    | (Optional) Main trigger to delete all civilians when deactivated.            |

  ### Example Usage

      [Trigger_1, 15, 5, 12, 15, true, true] spawn OKS_fnc_Civilians;

  - Civilians are distributed between static and moving roles, with randomized waypoints in buildings and outdoors.
  - Panic mode enables dynamic reactions to combat, gunfire, or threats.
  - Ethnicity parameter integrates with OKS_FACESWAP for custom civilian appearance.
  - All civilians in the area can be deleted by deactivating or destroying the main trigger.
  - Designed for dynamic, immersive civilian populations in Arma 3 missions, supporting advanced unit control and scripting[4][5].

</details>
<details>
  <summary>OKS_fnc_Garrison</summary>

  ### Description
  Spawns and positions a group of infantry to garrison a building, distributing units across available building positions.  
  Units are statically placed, have their pathfinding disabled, and are set to defensive postures for strongpoint defense.  
  Integrates with advanced AI skill and static management systems for enhanced mission control.

  ### Parameters

  | Name              | Type      | Description                                                                 |
  |-------------------|-----------|-----------------------------------------------------------------------------|
  | `_NumberInfantry` | Number    | Number of infantry to garrison the building (capped at available positions). |
  | `_House`          | Object    | Building object to be garrisoned.                                           |
  | `_Side`           | Side      | Side/faction for the garrisoned group.                                      |
  | `_UnitArray`      | Array     | Array with leader/unit classnames (e.g., `[Leaders, Units, Officer]`).      |

  ### Example Usage

      [5, nearestBuilding player, east, ["O_Soldier_F"]] spawn OKS_fnc_Garrison;

  ### Behavior

  - If the requested number exceeds available building positions, fills all positions with one unit each.
  - Units are assigned to random building positions, set to static posture, and have pathfinding disabled.
  - The building receives the variable `OKS_isGarrisoned = true` for tracking.
  - AI group is registered as static for performance and behavior control.
  - Integrates with skill setting (`GW_SetDifficulty_fnc_setSkill`), static management (`OKS_fnc_SetStatic`), and path enabling (`OKS_fnc_EnablePath`) systems.
  - Designed for robust, static defense scripting in Arma 3 missions[1][5].

</details>
<details>
  <summary>OKS_fnc_Garrison_Compound</summary>

  ### Description
  Spawns a group of infantry and distributes them throughout a compound or cluster of buildings within a specified range, using static defensive postures and disabling AI pathfinding for strongpoint defense.  
  Integrates with ACE AI garrisoning, advanced skill management, and static control systems for robust mission design.

  ### Parameters

  | Name              | Type      | Description                                                                 |
  |-------------------|-----------|-----------------------------------------------------------------------------|
  | `_NumberInfantry` | Number    | Number of infantry to garrison the compound.                                |
  | `_Position`       | Position  | Center position for the compound (array or object).                         |
  | `_Side`           | Side      | Faction/side for the garrisoned group.                                      |
  | `_UnitArray`      | Array     | Array with leader/unit classnames (e.g., `[Leaders, Units, Officer]`).      |
  | `_Range`          | Number    | Radius (in meters) to search for buildings to garrison.                     |

  ### Example Usage

      [5, getPos player, east, ["O_Soldier_F"], 30] spawn OKS_fnc_Garrison_Compound;

  ### Behavior

  - Creates a group and spawns units at the given position, dispersing them with slight randomization.
  - Disables AI pathfinding and sets defensive postures for non-civilian sides.
  - All buildings within the given range receive the variable `OKS_isGarrisoned = true` for tracking.
  - Waits for ACE AI and OKS path functions, then uses `ace_ai_fnc_garrison` to position units inside buildings.
  - Integrates with skill setting (`GW_SetDifficulty_fnc_setSkill`), static management (`OKS_fnc_SetStatic`), and path enabling (`OKS_fnc_EnablePath`) systems for advanced AI control[1][5].
  - Designed for efficient, static defense of compounds in Arma 3 missions.

</details>
<details>
  <summary>OKS_fnc_AddVehicleCrew</summary>

  ### Description
  Automatically creates and assigns a crew (and optionally cargo infantry) to a vehicle for a specified side.  
  Supports full or partial crew (driver, gunner, commander), as well as filling cargo seats with infantry from provided class arrays.  
  Integrates with advanced skill setting and group management systems for robust vehicle deployment in Arma 3 missions.

  ### Parameters

  | Name           | Type      | Description                                                                                   |
  |----------------|-----------|-----------------------------------------------------------------------------------------------|
  | `_Vehicle`     | Object    | The vehicle to be crewed.                                                                     |
  | `_Side`        | Side      | The faction/side for the crew (e.g., `west`, `east`).                                         |
  | `_CrewSlots`   | Number    | Which crew positions to fill: 0 = all, 1 = driver only, 2 = gunner only, 3 = commander only.  |
  | `_CargoSlots`  | Number    | Number of infantry to place in cargo seats (0 = none).                                        |

  ### Example Usage

      [_this, west, 0] call OKS_fnc_AddVehicleCrew;

  ### Behavior

  - Selects appropriate crew class based on side.
  - Fills specified crew slots if available in the vehicle.
  - If cargo slots are requested and available (minimum 4), fills them with a leader and additional infantry from the provided unit arrays.
  - All units are grouped together and skill is set via `GW_SetDifficulty_fnc_setSkill`.
  - Designed for flexible, automated vehicle crew and cargo assignment in dynamic Arma 3 scenarios[3][5].

</details>

</details>  
<details>
  <summary>🚩 Ambience Scripts</summary>
  <details>
  <summary>OKS_fnc_Chat</summary>

  ### Description
  Displays a custom chat/radio message from a specified entity or preset callsign, either over radio ("side" channel) or as a local message.  
  Supports both player entities and preset callsigns, with execution requirements based on channel type.

  ### Parameters

  | Name        | Type     | Default | Description                                                                                   |
  |-------------|----------|---------|-----------------------------------------------------------------------------------------------|
  | `_Talker`   | Object/String | —   | Entity (person) or preset callsign ("Base", "HQ", "PAPA_BEAR", etc.).                        |
  | `_Channel`  | String   | "side"  | "side" for radio (must match player side), "local" for proximity chat (20m range).           |
  | `_Message`  | String   | —       | The chat message to display.                                                                  |
  | `_Callsign` | String   | ""      | (Optional) Custom callsign override.                                                          |

  ### Example Usage

      ["HQ", "side", "Test"] spawn OKS_fnc_Chat;  
      [person1, "local", "Hello World!"] remoteExec ["OKS_fnc_Chat", 0];

  ### Behavior

  - **"side" channel:**  
    - Displays a radio message from the specified side/callsign.
    - Must be executed globally (e.g., via trigger or remoteExec), and is only visible to players of the same side (not captives).
    - Range: 1000m (radio).
    - Supports preset callsigns.

  - **"local" channel:**  
    - Displays a local message from any entity (not preset callsigns).
    - Must be executed on the client(s) that should see the message (e.g., via `remoteExec`).
    - Range: 20m (proximity).
    - Cannot use preset callsigns.

  - Designed for flexible mission communication and custom UI integration in Arma 3 mods.
</details>
<details>
  <summary>OKS_fnc_DeleteDeadAndObjects</summary>

  ### Description
  Deletes dead bodies (corpses), vehicles, and/or placed objects within a trigger area or around a specified position.  
  Supports customizable deletion delay, selective deletion of vehicles and objects, and adjustable range if using a position.

  ### Parameters

  | Name                     | Type         | Default   | Description                                                                 |
  |--------------------------|--------------|-----------|-----------------------------------------------------------------------------|
  | `_TriggerNameOrPosition` | Object/Array | —         | Trigger object (area) or position array to define the deletion zone.         |
  | `_DeleteDelayPerDelete`  | Number       | 0.01      | Time delay (in seconds) between each deletion for performance control.       |
  | `_ShouldDeleteVehicles`  | Boolean      | true      | If true, deletes vehicles in the area.                                      |
  | `_ShouldDeleteObjects`   | Boolean      | true      | If true, deletes placed objects (e.g., editor-placed items) in the area.    |
  | `_Range`                 | Number       | 250       | Range (meters) if using a position array instead of a trigger.              |

  ### Example Usage

      [DeleteTrigger_1] spawn OKS_fnc_DeleteDeadAndObjects;
      [[1000,2000,0], 0.05, true, false, 300] spawn OKS_fnc_DeleteDeadAndObjects;

  ### Behavior

  - If a trigger is provided, deletes all matching entities within the trigger area.
  - If a position array is provided, deletes entities within the specified range.
  - Deletion is staggered by the given delay to avoid performance spikes.
  - Useful for cleanup of corpses, wrecks, and clutter during or after missions, maintaining performance and immersion[5][1].
</details>
<details>
  <summary>OKS_fnc_Destroy_Houses</summary>

  ### Description
  Destroys or damages all houses within a trigger area or around a specified position, with optional randomization of damage level.  
  Supports blacklisting specific buildings to prevent their destruction, and can be used for immersive battlefield effects or mission scripting.

  ### Parameters

  | Name              | Type         | Default    | Description                                                                 |
  |-------------------|--------------|------------|-----------------------------------------------------------------------------|
  | `_TriggerOrPosition` | Object/Array | —        | Trigger object or position array defining the center of the destruction zone.|
  | `_RandomDamage`   | Boolean      | true       | If true, applies random damage; if false, sets all to 100% damage.           |
  | `_DamageVariation`| Array        | [8,10]     | Two numbers (0–10) for min/max damage (e.g., [8,10] = 80–100% damage).       |
  | `_Range`          | Number       | 250        | Range (meters) from position if using a position array.                      |

  ### Example Usage

      [thisTrigger, true, [8,10], 500] spawn OKS_fnc_Destroy_Houses;

  ### Blacklisting Buildings

  To prevent a building from being destroyed, place a logic object near it and add in its init:

      (nearestObject [getPos this,"HOUSE"]) setVariable ["OKS_Destroy_Blacklist",true,true];
      (nearestBuilding this) setVariable ["OKS_Destroy_Blacklist",true,true];

  ### Behavior

  - All houses within the specified area are damaged or destroyed, except those blacklisted.
  - If `_RandomDamage` is true and a variation is provided, each house receives a random damage within the specified range (as a percentage).
  - If `_RandomDamage` is false, all houses are set to full destruction (100% damage).
  - Useful for scripting post-battle effects, dynamic mission environments, or simulating artillery/airstrike aftermaths[1].

</details>
<details>
  <summary>OKS_fnc_PowerGenerator</summary>

  ### Description
  Activates a power generator object, optionally adds an interaction action, and manages nearby lights within a defined range.  
  Plays activation, idle, and shutdown sounds, and maintains generator state for immersive mission environments in Arma 3.

  ### Parameters

  | Name                  | Type    | Description                                                                 |
  |-----------------------|---------|-----------------------------------------------------------------------------|
  | `_Generator`          | Object  | The generator object to activate.                                           |
  | `_AddAction`          | Boolean | If true, adds an interaction action to the generator.                       |
  | `_TurnOffNearbyLights`| Boolean | If true, turns off nearby lights within the specified range.                |
  | `_RangeOfPowerSupply` | Number  | Range (meters) for power supply/light control.                              |

  ### Example Usage

      [Generator_1, true, true, 1000] spawn OKS_fnc_PowerGenerator;

  ### Behavior

  - If `_AddAction` is true, adds an interactive action to the generator via `OKS_fnc_addGeneratorAction`.
  - Plays a startup sound, then sets the generator as active (`GeneratorActive = true`).
  - Uses a per-frame handler to play idle sounds and monitor generator state.
  - If the generator is turned off or destroyed, plays a shutdown sound and stops the handler.
  - Optionally controls nearby lights within the specified range for immersive power management.
  - Debug messages and state changes are logged if debug mode is enabled.
  - Integrates with custom UI and scripting systems for enhanced mission control.

</details>
</details>