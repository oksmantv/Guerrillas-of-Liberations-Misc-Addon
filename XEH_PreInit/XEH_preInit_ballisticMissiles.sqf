diag_log "OKS_GOL_Misc: XEH_preInit_ballisticMissiles.sqf executed";

[ 
    "GOL_ScudIntercept_Debug",
    "CHECKBOX",
    ["Enable SCUD/Cruise Intercept DEBUG", "Enables debugging for SCUD (RHS) and Cruise Missile (VLS) launch/intercept scripts."],
    ["GOL Ballistic Missiles", "Debug"],
    true,
    1
] call cba_settings_fnc_init;

// Ballistic missile / SCUD / Cruise missile intercept settings
// These settings drive OKS_fnc_ScudIntercept_* scripts.

[
    "GOL_ScudIntercept_UseCMCIntercept",
    "CHECKBOX",
    ["Use CMC Intercept Proxy", "If enabled, calls cmc_intercept_fnc_onFired (when available) to create an interceptable proxy attached to the missile."],
    ["GOL Ballistic Missiles", "Intercept"],
    false,
    1
] call cba_settings_fnc_init;
 


[
    "GOL_ScudIntercept_ProxyClassname",
    "EDITBOX",
    ["Proxy Vehicle Classname", "Primary proxy vehicle classname to spawn/attach (default is CMC: cmc_intercept_cruiseMissile)."],
    ["GOL Ballistic Missiles", "Proxy"],
    "cmc_intercept_cruiseMissile",
    1
] call cba_settings_fnc_init;
 


[
    "GOL_ScudIntercept_NeutralizeExplosionClass",
    "EDITBOX",
    ["Neutralize Explosion Class", "Classname to trigger when neutralizing a projectile. Supports both CfgVehicles (instant effect, e.g. SmallSecondary) and CfgAmmo (ordnance, detonated via triggerAmmo). Examples: SmallSecondary (default), Bo_GBU12_LGB, BombCluster_01_Ammo_F. Browse more in Config Viewer under CfgVehicles/CfgAmmo."],
    ["GOL Ballistic Missiles", "Effects"],
    "SmallSecondary",
    1
] call cba_settings_fnc_init;

[
    "GOL_ScudIntercept_SuccessMinDistanceMeters",
    "SLIDER",
    ["Minimum Success Distance", "If the proxy is destroyed within this many meters (2D) of the target position, the intercept is considered TOO LATE and the task will FAIL."],
    ["GOL Ballistic Missiles", "Effects"],
    [0, 500, 50, 0],
    1
] call cba_settings_fnc_init;
 


[
    "GOL_ScudIntercept_DebugChat",
    "CHECKBOX",
    ["Echo SCUDINT Debug To Chat", "If enabled, SCUDINT debug is echoed to systemChat. If disabled, debug goes to RPT only (recommended)."],
    ["GOL Ballistic Missiles", "Debug"],
    false,
    1
] call cba_settings_fnc_init;
 


[
    "GOL_ScudIntercept_DebugZeus",
    "CHECKBOX",
    ["Expose Proxy In Zeus", "If enabled, projectile/proxy objects are added to curator editable objects (debugging aid)."],
    ["GOL Ballistic Missiles", "Debug"],
    true,
    1
] call cba_settings_fnc_init;
