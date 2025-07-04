/*
    [_unit] call OKS_fnc_AddKilledScore;
*/

Params ["_unit"];
if(isNil "_unit") exitWith {};
if(isNull _unit) exitWith {};

_name = name _unit;
if(isNil "_name" || _name isEqualTo "") then {
    _name = typeof _unit;
};

if(!(_unit getVariable ["HasHandleScoreEvent",false])) then {
    _unit setVariable ["HasHandleScoreEvent", true, true];
    Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
    if(_Debug) then {
        format["%1 added killed eventHandler for scoring.",_name] spawn OKS_fnc_LogDebug;
    };

    _unit addEventHandler ["Killed", {
        params ["_unit", "_killer"];
        if(isPlayer _killer) then {
            private _enemyKilledCount = missionNamespace getVariable ["GOL_EnemiesKilled", 0];
            _enemyKilledCount = _enemyKilledCount + 1;
            missionNamespace setVariable ["GOL_EnemiesKilled", _enemyKilledCount + 1, true];

            _name = name _unit;
            if(isNil "_name" || _name isEqualTo "") then {
                _name = typeof _unit;
            };

            Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
            if(_Debug) then {
                format["%1 killed by %2 - Total Score: %3",_name, name _killer, _enemyKilledCount] spawn OKS_fnc_LogDebug;
            };   
        };
    }];

};