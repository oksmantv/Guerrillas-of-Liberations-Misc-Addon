/*
    Setup Paradrop Actions
*/

if (hasInterface) then {
    
    /* Add Paradrop Action to Gearboxes */
    _paraDropAction = ["ParadropActions", "Paradrop", "\A3\ui_f\data\Map\VehicleIcons\iconParachute_ca.paa", { }, {true}] call ace_interact_menu_fnc_createAction;
    _paraDropEquipmentAction = ["RequestEquipment", "Request Equipment", "\A3\ui_f\data\igui\cfg\actions\reammo_ca.paa", { [_player] call OKS_fnc_SetupParadrop; }, {true}] call ace_interact_menu_fnc_createAction;

    ["GOL_GearBox_WEST", 0, ["ACE_MainActions"], _paraDropAction, true] call ace_interact_menu_fnc_addActionToClass;
    ["GOL_GearBox_WEST", 0, ["ACE_MainActions","ParadropActions"], _paraDropEquipmentAction, true] call ace_interact_menu_fnc_addActionToClass;

    ["GOL_GearBox_EAST", 0, ["ACE_MainActions"], _paraDropAction, true] call ace_interact_menu_fnc_addActionToClass;
    ["GOL_GearBox_EAST", 0, ["ACE_MainActions","ParadropActions"], _paraDropEquipmentAction, true] call ace_interact_menu_fnc_addActionToClass;
};