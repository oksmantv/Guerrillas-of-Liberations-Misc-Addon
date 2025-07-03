params ["_Generator", "_TurnOffNearbyLights", "_RangeOfPowerSupply"];

private _codeDisableGenerator = {
    params ["_target", "_player", "_actionParams"];
    _actionParams params ["_TurnOffNearbyLights", "_RangeOfPowerSupply"];

    private _actionName = "Disabling Generator..";	
    if (primaryWeapon player != "") then {
        player playMoveNow "AmovPknlMstpSlowWrflDnon";
    };
    [_actionName, 3, {true}, 
        // PROGRESS BAR COMPLETE CODE
        {
            params ["_args", "_pfhID"];
            _args params ["_target", "_TurnOffNearbyLights", "_RangeOfPowerSupply"];

            //systemChat str _args; // For debugging: will show [generator, true, 1000] etc.
            //copyToClipboard str _args;

            systemChat "Generator shutting down..";
            _target setVariable ["GeneratorActive", false, true];
            removeAllActions _target;  

            if (_TurnOffNearbyLights) then {
                private _lampTypes = [
                    "Lamps_Base_F", 
                    "PowerLines_base_F",
                    "Land_PowerPoleWooden_F", 
                    "Land_PowerPoleWooden_small_F", 
                    "Land_LampHarbour_F",
                    "Land_LampShabby_F",
                    "Land_LampStreet_small_F",
                    "Land_LampStreet_F",
                    "Land_PowerPoleWooden_L_F",
                    "Land_LampHalogen_F",
                    "Land_LampDecor_F",
                    "Land_LampSolar_F",
                    "Land_LampAirport_F"
                ];
                private _lamps = [];
                { { _lamps pushBackUnique _x } forEach (_target nearObjects [_x, _RangeOfPowerSupply]) } forEach _lampTypes;

                [_lamps] spawn {
                    params ["_lamps"];
                    { _x setDamage 0.92; sleep 0.1 } forEach _lamps;
                };
            };
        },
        // PROGRESS BAR CANCEL CODE
        {
            systemChat "Cancelled generator shutdown..";
        },
        // ARGUMENTS PASSED TO PROGRESS BAR CODE
        [_target, _TurnOffNearbyLights, _RangeOfPowerSupply]
    ] call CBA_fnc_progressBar;
};

private _condition = { _target getVariable ["GeneratorActive", false] };
private _actionDisableGenerator = [
    "Disable Generator",
    "Disable Generator",
    "\a3\ui_f\data\igui\cfg\simpletasks\types\Use_ca.paa",
    _codeDisableGenerator,
    _condition,
    {},
    [_TurnOffNearbyLights, _RangeOfPowerSupply] // custom params go here!
] call ace_interact_menu_fnc_createAction;

[_Generator, 0, ["ACE_MainActions"], _actionDisableGenerator] call ace_interact_menu_fnc_addActionToObject;

private _Debug = missionNamespace getVariable ["GOL_Ambience_Debug", false];
if(_Debug) then {
    format ["Power Generator Added Action to %1", _Generator] spawn OKS_fnc_LogDebug;
};
