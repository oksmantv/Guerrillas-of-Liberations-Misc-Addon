diag_log "OKS_GOL_Misc: XEH_preInit_ballisticMissiles.sqf executed";

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
    "GOL_ScudIntercept_NeutralizeProjectileOnSuccess",
    "CHECKBOX",
    ["Neutralize Missile On Intercept", "If enabled, when the proxy is destroyed the attached real projectile is deleted (if airborne) and a small explosion is triggered (CMC-like)."],
    ["GOL Ballistic Missiles", "Effects"],
    false,
    1
] call cba_settings_fnc_init;
 


[
    "GOL_ScudIntercept_NeutralizeMinAltitudeASL",
    "SLIDER",
    ["Neutralize Min Altitude (ASL)", "Only neutralize the real projectile if it is above this altitude (ASL meters)."],
    ["GOL Ballistic Missiles", "Effects"],
    [0, 2000, 5, 0],
    1
] call cba_settings_fnc_init;
 


[
    "GOL_ScudIntercept_NeutralizeExplosionClass",
    "EDITBOX",
    ["Neutralize Explosion Class", "Classname to trigger when neutralizing a projectile (default: SmallSecondary)."],
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
