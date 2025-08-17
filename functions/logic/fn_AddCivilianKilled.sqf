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

if(!(_unit getVariable ["HasHandleScoreEventCivilian",false])) then {

    _unit setVariable ["HasHandleScoreEventCivilian", true, true];
    Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
    if(_Debug) then {
        format["%1 added killed eventHandler for non-combatant deaths.",_name] spawn OKS_fnc_LogDebug;
    };

    _unit addEventHandler ["Killed", {
        params ["_unit", "_killer"];
        if(!(_unit getVariable ["GOL_NonCombatant", true])) exitWith {};
        if(isPlayer _killer) then {
            
            _name = name _unit;
            if(isNil "_name" || _name isEqualTo "") then {
                _name = typeof _unit;
            };

            private _civilianKilledCount = missionNamespace getVariable ["GOL_CiviliansKilled", 0];
            _civilianKilledCount = _civilianKilledCount + 1;
            missionNamespace setVariable ["GOL_CiviliansKilled", _civilianKilledCount, true];

            [10] call OKS_fnc_IncreaseMultiplier;        
        };
    }];
};