/*
    Author: OksmanTV from Guerrillas of Liberation
    Called via Extended_GetIn_EventHandlers for UK3CB_BAF_Static_M6.
    3CB sets UK3CB_ACE_Ballistics=true on gunner UI load, causing their
    built-in display to show inaccurate ACE-adjusted tables.
    Waits until 3CB sets the variable, then resets it to false.
    Arguments:
        _this: [vehicle, position, unit, turretPath] (XEH GetIn params)
    Return Value: none
*/
params ["_veh", "_position", "_unit"];
if (!hasInterface || _unit != player || _position != "Gunner") exitWith {};
diag_log "[OKS_M6_Fix] Extended_GetIn fired for M6 gunner — starting waitUntil";

[_unit] spawn {
    params ["_unit"];
    private _timeout = time + 0.5;
    waitUntil {
        sleep 0.05;
        diag_log format ["[OKS_M6_Fix] Polling UK3CB_ACE_Ballistics = %1", _unit getVariable ["UK3CB_ACE_Ballistics", false]];
        (_unit getVariable ["UK3CB_ACE_Ballistics", false]) || (time > _timeout)
    };
    diag_log format ["[OKS_M6_Fix] Resetting — was: %1", _unit getVariable ["UK3CB_ACE_Ballistics", false]];
    _unit setVariable ["UK3CB_ACE_Ballistics", false, true];
};
