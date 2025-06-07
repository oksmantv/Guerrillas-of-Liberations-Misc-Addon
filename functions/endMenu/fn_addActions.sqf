["GOL Misc Addon", "OpenScoreMenu", "Open Score Menu", {
    [] call OKS_fnc_openDialog;
}, "", [DIK_HOME, [false, false, false]]] call CBA_fnc_addKeybind;

["My Score Menu", "Open Score Display", {
    [] call OKS_fnc_openDialog;
}] call CBA_fnc_addPauseMenuOption;