/*
    Setup Paradrop Actions
*/

if (hasInterface) then {
    
    /* Add Paradrop Action to Gearboxes */
    _paraDropAction = ["ParadropActions", "Paradrop", "\A3\ui_f\data\Map\VehicleIcons\iconParachute_ca.paa", { }, {true}] call ace_interact_menu_fnc_createAction;
    _paraDropSteerable = ["RequestEquipment", "Steerable Parachute", "\A3\ui_f\data\igui\cfg\actions\reammo_ca.paa", { [_player, false] call OKS_fnc_SetupParadrop; }, {true}] call ace_interact_menu_fnc_createAction;
    _paraDropStatic = ["RequestEquipment", "Static Parachute", "\A3\ui_f\data\igui\cfg\actions\reammo_ca.paa", { [_player, true] call OKS_fnc_SetupParadrop; }, {true}] call ace_interact_menu_fnc_createAction;

    ["GOL_GearBox_WEST", 0, ["ACE_MainActions"], _paraDropAction, true] call ace_interact_menu_fnc_addActionToClass;
    ["GOL_GearBox_WEST", 0, ["ACE_MainActions","ParadropActions"], _paraDropSteerable, true] call ace_interact_menu_fnc_addActionToClass;
    ["GOL_GearBox_WEST", 0, ["ACE_MainActions","ParadropActions"], _paraDropStatic, true] call ace_interact_menu_fnc_addActionToClass;

    ["GOL_GearBox_EAST", 0, ["ACE_MainActions"], _paraDropAction, true] call ace_interact_menu_fnc_addActionToClass;
    ["GOL_GearBox_EAST", 0, ["ACE_MainActions","ParadropActions"], _paraDropSteerable, true] call ace_interact_menu_fnc_addActionToClass;
    ["GOL_GearBox_EAST", 0, ["ACE_MainActions","ParadropActions"], _paraDropStatic, true] call ace_interact_menu_fnc_addActionToClass;
};