/*
    Initialize CBA settings for IR illuminator system.
    
    Called from XEH_preInit.
*/

[
    "GOL_IRIlluminator_Enabled",
    "CHECKBOX",
    ["Enable IR Illuminator System", "Use scripted lights for GOL OX3000 IR illuminator modes (prevents AI detection boost from isFlashlightOn)"],
    ["GOL Misc", "IR Illuminator"],
    true,
    0,
    {}
] call CBA_fnc_addSetting;

[
    "GOL_IRIlluminator_Intensity",
    "SLIDER",
    ["IR Illuminator Intensity (Standard)", "Light intensity for GOL_OX3000_II. Higher = brighter and longer range through NVGs. BettIR default ~1000-2000, we use ~4000 for stronger effect."],
    ["GOL Misc", "IR Illuminator"],
    [1000, 10000, 4000, 0],
    0,
    {}
] call CBA_fnc_addSetting;

[
    "GOL_IRIlluminator_Intensity_LR",
    "SLIDER",
    ["IR Illuminator Intensity (Long Range)", "Light intensity for GOL_OX3000_LR_II. Higher = brighter and longer range."],
    ["GOL Misc", "IR Illuminator"],
    [2000, 15000, 8000, 0],
    0,
    {}
] call CBA_fnc_addSetting;

[
    "GOL_IRIlluminator_Brightness",
    "SLIDER",
    ["IR Illuminator Brightness", "Overall brightness multiplier. Affects how bright the light appears through NVGs."],
    ["GOL Misc", "IR Illuminator"],
    [1, 20, 8, 0],
    0,
    {}
] call CBA_fnc_addSetting;

[
    "GOL_IRIlluminator_MaxDistance",
    "SLIDER",
    ["Max Render Distance", "Maximum distance (meters) to render other players' IR illuminators. Higher = see more teammates, lower = better performance."],
    ["GOL Misc", "IR Illuminator"],
    [50, 150, 150, 0],
    0,
    {}
] call CBA_fnc_addSetting;

[
    "GOL_IRIlluminator_Debug",
    "CHECKBOX",
    ["Debug Mode", "Show debug messages for IR illuminator system"],
    ["GOL Misc", "IR Illuminator"],
    false,
    0,
    {}
] call CBA_fnc_addSetting;
