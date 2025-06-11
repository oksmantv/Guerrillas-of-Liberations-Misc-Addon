/*
    [_unit] call OKS_fnc_AddCivilianKilled;
*/

Params ["_unit"];
if(isNil "_unit") exitWith {};
if(isNull _unit) exitWith {};

_name = name _unit;
if(isNil "_name" || _name isEqualTo "") then {
    _name = typeof _unit;
};

Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
if(_Debug) then {
    format["%1 added killed eventHandler for non-combatant deaths.",_name] spawn OKS_fnc_LogDebug;
};

_unit addEventHandler ["Killed", {
    params ["_unit", "_killer"];
    _name = name _unit;
    if(isNil "_name" || _name isEqualTo "") then {
        _name = typeof _unit;
    };

    private _civilianKilledCount = missionNamespace getVariable ["GOL_CiviliansKilled", 0];
    missionNamespace setVariable ["GOL_CiviliansKilled", _civilianKilledCount + 1, true];

    Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
    if(_Debug) then {
        format["%1 killed by %2 - Total Killed: %3",_name, name _killer, _civilianKilledCount] spawn OKS_fnc_LogDebug;
    };   
}];
