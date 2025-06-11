/*
    [_unit] call OKS_fnc_AddKilledScore;
*/

Params ["_unit"];
if(isNil "_unit") exitWith {};
if(isNull _unit) exitWith {};

Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
if(_Debug) then {
    format["%1 added killed eventHandler for scoring.",name _unit] spawn OKS_fnc_LogDebug;
};

_unit addEventHandler ["Killed", {
    params ["_unit", "_killer"];
    private _enemyKilledCount = missionNamespace getVariable ["GOL_EnemiesKilled", 0];
    missionNamespace setVariable ["GOL_EnemiesKilled", _enemyKilledCount + 1, true];

    Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
    if(_Debug) then {
        format["%1 killed by %2 - Total Score: %3",name _unit, name _killer, _enemyKilledCount] spawn OKS_fnc_LogDebug;
    };   
}];
