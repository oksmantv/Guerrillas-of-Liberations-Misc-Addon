/*
    [] spawn OKS_fnc_FlagTeleport;
*/

private _fnc_addTeleportAction = {
    params ["_flag", "_title", "_destination"];
    diag_log format ["[addTeleportAction] Params: %1",_this];

    [
        _flag, // Object the action is attached to
        _title, // Title of the action
        "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\move_ca.paa", // Idle icon shown on screen
        "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\move_ca.paa", // Progress icon shown on screen
        "true", // Condition for the action to be shown
        "true", // Condition for the action to progress
        {}, // Code executed when action starts
        {}, // Code executed on every progress tick
        { 
            params ["_target", "_caller", "_actionId", "_args"];
            _args params ["_destination"];
            _caller setPosATL (getPosATL _destination); // Code executed on completion
        },
        {}, // Code executed on interrupted
        [_destination], // Arguments passed to the scripts as _this select 3
        1, // Action duration in seconds
        3, // Priority
        false, // Remove on completion
        false // Show in unconscious state
    ] call BIS_fnc_holdActionAdd;
};

if(!isNil "flag_west_1" && !isNil "flag_west_2") then {
    [flag_west_1, "<t color='#eeb20e'>Teleport to FARP</t>", flag_west_2] call _fnc_addTeleportAction;
    flag_west_1 setFlagTexture "\OKS_GOL_Misc\data\images\hellfishflag.paa";

    [flag_west_2, "<t color='#eeb20e'>Teleport to Staging Area</t>", flag_west_1] call _fnc_addTeleportAction;
    flag_west_2 setFlagTexture "\OKS_GOL_Misc\data\images\aac.jpg";
};

if(!isNil "flag_east_1" && !isNil "flag_east_2") then {
    [flag_east_1, "<t color='#eeb20e'>Teleport to FARP</t>", flag_east_2] call _fnc_addTeleportAction;
    flag_east_1 setFlagTexture "\OKS_GOL_Misc\data\images\hellfishflag.paa";

    [flag_east_2, "<t color='#eeb20e'>Teleport to Staging Area</t>", flag_east_1] call _fnc_addTeleportAction;
    flag_east_2 setFlagTexture "\OKS_GOL_Misc\data\images\aac.jpg";
};

if(!isNil "flag_independent_1" && !isNil "flag_independent_2") then {
    [flag_independent_1, "<t color='#eeb20e'>Teleport to FARP</t>", flag_independent_2] call _fnc_addTeleportAction;
    flag_independent_1 setFlagTexture "\OKS_GOL_Misc\data\images\hellfishflag.paa";

    [flag_independent_2, "<t color='#eeb20e'>Teleport to Staging Area</t>", flag_independent_1] call _fnc_addTeleportAction;
    flag_independent_2 setFlagTexture "\OKS_GOL_Misc\data\images\aac.jpg";
};