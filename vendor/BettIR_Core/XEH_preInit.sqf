[
    'GOL_IRLLM_ViewDistance',
    "SLIDER",
    'View distance',
    'GOL IR Illuminator',
    [150, 12000, 300, 0],
    nil
] call CBA_fnc_addSetting;

diag_log "[GOL_IRLLM] PreInit: registering CBA keybinds.";

// Register controls during pre-init so they are available in CBA Addon Options
// before a mission loads. The callbacks resolve `player` only when pressed.
["GOL IR Illuminator", "GOL_IRLLM_ToggleGogglesIlluminator", "Toggle Goggles Illuminator", {
    if !([] call GOL_IRLLM_fnc_initialize) exitWith { false };
    [player] call GOL_IRLLM_fnc_toggleNvgIlluminator;
    true;
}, { false }, [0x31, [true, false, true]], false] call CBA_fnc_addKeybind;

["GOL IR Illuminator", "GOL_IRLLM_ToggleWeaponIlluminator", "Toggle Weapon Illuminator", {
    if !([] call GOL_IRLLM_fnc_initialize) exitWith { false };
    [player] call GOL_IRLLM_fnc_toggleWeaponIlluminator;
    true;
}, { false }, [0x26, [true, false, true]], false] call CBA_fnc_addKeybind;

["GOL IR Illuminator", "GOL_IRLLM_HoldWeaponIlluminator", "Hold Weapon Illuminator", {
    if !([] call GOL_IRLLM_fnc_initialize) exitWith { false };
    [player] call GOL_IRLLM_fnc_weaponIlluminatorOn;
    true;
}, {
    if !([] call GOL_IRLLM_fnc_initialize) exitWith { false };
    [player] call GOL_IRLLM_fnc_weaponIlluminatorOff;
    true;
}, nil, false] call CBA_fnc_addKeybind;

["GOL IR Illuminator", "GOL_IRLLM_HoldWeaponLaser", "Hold Weapon IR Laser", {
    player action ["IRLaserOn", player];
    true;
}, {
    player action ["IRLaserOff", player];
    true;
}, nil, false] call CBA_fnc_addKeybind;

