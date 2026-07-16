/*
    Initialize CBA settings for IR illuminator system.
    
    Called from XEH_preInit.
*/

[
    "GOL_IRIlluminator_Enabled",
    "CHECKBOX",
    ["Enable IR Illuminator System", "Use scripted lights for GOL OX3000 IR illuminator modes (prevents AI detection boost from isFlashlightOn)"],
    ["GOL Nightvision", "IR Illuminator"],
    true,
    0,
    {}
] call CBA_fnc_addSetting;

[
    "GOL_IRIlluminator_Intensity",
    "SLIDER",
    ["IR Illuminator Intensity", "Light intensity for GOL_OX3000_II. Higher = brighter and longer range through NVGs. BettIR default ~1000-2000, we use ~4000 for stronger effect."],
    ["GOL Nightvision", "IR Illuminator"],
    [1000, 10000, 4000, 0],
    0,
    {}
] call CBA_fnc_addSetting;

[
    "GOL_IRIlluminator_Brightness",
    "SLIDER",
    ["IR Illuminator Brightness", "Overall brightness multiplier. Affects how bright the light appears through NVGs."],
    ["GOL Nightvision", "IR Illuminator"],
    [1, 20, 8, 0],
    0,
    {}
] call CBA_fnc_addSetting;

[
    "GOL_IRIlluminator_MaxDistance",
    "SLIDER",
    ["Max Render Distance", "Maximum distance (meters) to render other players' IR illuminators. Higher = see more teammates, lower = better performance."],
    ["GOL Nightvision", "IR Illuminator"],
    [50, 150, 150, 0],
    0,
    {}
] call CBA_fnc_addSetting;

[
    "GOL_IRIlluminator_ShowHint",
    "CHECKBOX",
    ["Show Strength Hint", "Display visual hint when adjusting IR illuminator strength (sound and light change still occur)"],
    ["GOL Nightvision", "IR Illuminator"],
    true,
    0,
    {}
] call CBA_fnc_addSetting;

[
    "GOL_IRIlluminator_ExtendedStrength",
    "CHECKBOX",
    ["Enable Extended Strength Levels", "Add 2.5% and 3% strength levels for extremely dark/stealth missions. When disabled, only 1%, 1.5%, and 2% are available."],
    ["GOL Nightvision", "IR Illuminator"],
    false,
    1,
    {}
] call CBA_fnc_addSetting;

[
    "GOL_IRIlluminator_Debug",
    "CHECKBOX",
    ["Debug Mode", "Show debug messages for IR illuminator system"],
    ["GOL Nightvision", "IR Illuminator"],
    false,
    0,
    {}
] call CBA_fnc_addSetting;

// Keybinds for adjusting IR illuminator strength
// Default: Ctrl+Numpad Plus/Minus (can be rebound by user)
[
    "GOL Nightvision",
    "GOL_IRIlluminator_IncreaseStrength",
    ["Increase IR Illuminator Strength", "Increase IR illuminator strength by 10%. BIND TO: Ctrl+Mouse Wheel Up (click field, hold Ctrl, scroll up)."],
    { true call OKS_fnc_IRIlluminator_AdjustStrength; },
    {},
    [0, [false, false, false]],
    false
] call CBA_fnc_addKeybind;

[
    "GOL Nightvision",
    "GOL_IRIlluminator_DecreaseStrength",
    ["Decrease IR Illuminator Strength", "Decrease IR illuminator strength by 10%. BIND TO: Ctrl+Mouse Wheel Down (click field, hold Ctrl, scroll down)."],
    { false call OKS_fnc_IRIlluminator_AdjustStrength; },
    {},
    [0, [false, false, false]],
    false
] call CBA_fnc_addKeybind;
