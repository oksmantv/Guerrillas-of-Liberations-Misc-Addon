/*
    [_unit] call OKS_fnc_AddCivilianKilled;
*/

Params ["_unit"];
if(isNil "_unit") exitWith {};
if(isNull _unit) exitWith {};

Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
if(_Debug) then {
    format["%1 added killed eventHandler for non-combatant deaths.",name _unit] spawn OKS_fnc_LogDebug;
};

_unit addEventHandler ["Killed", {
    params ["_unit", "_killer"];
    private _civilianKilledCount = missionNamespace getVariable ["GOL_CiviliansKilled", 0];
    missionNamespace setVariable ["GOL_CiviliansKilled", _civilianKilledCount + 1, true];

    Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
    if(_Debug) then {
        format["%1 killed by %2 - Total Killed: %3",name _unit, name _killer, _civilianKilledCount] spawn OKS_fnc_LogDebug;
    };   
}];
