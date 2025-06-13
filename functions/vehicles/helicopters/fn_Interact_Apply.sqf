// [_this] call OKS_fnc_Interact_Apply;

params ["_Helicopter"];

// Parent menu with icon
private _menu = [
    "OKS_Menu",
    "Switch Seats Self",
    "\a3\ui_f\data\IGUI\Cfg\Cursors\getIn_ca.paa",
    { /* No statement for parent */ },
    { true }
] call ace_interact_menu_fnc_createAction;

[_Helicopter, 1, ["ACE_SelfActions"], _menu] call ace_interact_menu_fnc_addActionToObject;

// Move to Copilot
private _moveToCopilot = [
    "Move_To_Copilot",
    "Move to Co-Pilot",
    "\a3\ui_f\data\IGUI\Cfg\Actions\getincommander_ca.paa",
    { [_Player, _Target] spawn OKS_fnc_Interact_Copilot; },
    { true }
] call ace_interact_menu_fnc_createAction;

[_Helicopter, 1, ["ACE_SelfActions", "OKS_Menu"], _moveToCopilot] call ace_interact_menu_fnc_addActionToObject;

// Move to Pilot
private _moveToPilot = [
    "Move_To_Pilot",
    "Move to Pilot",
    "\a3\ui_f\data\IGUI\Cfg\Actions\getinpilot_ca.paa",
    { [_Player, _Target] spawn OKS_fnc_Interact_Pilot; },
    { true }
] call ace_interact_menu_fnc_createAction;

[_Helicopter, 1, ["ACE_SelfActions", "OKS_Menu"], _moveToPilot] call ace_interact_menu_fnc_addActionToObject;

// Move to Door Gunner
private _moveToDoorGunner = [
    "Move_To_DoorGunner",
    "Move to Door Gunner",
    "\a3\ui_f\data\IGUI\Cfg\Actions\getingunner_ca.paa",
    { [_Player, _Target] spawn OKS_fnc_Interact_DoorGunner; },
    { true }
] call ace_interact_menu_fnc_createAction;

[_Helicopter, 1, ["ACE_SelfActions", "OKS_Menu"], _moveToDoorGunner] call ace_interact_menu_fnc_addActionToObject;
