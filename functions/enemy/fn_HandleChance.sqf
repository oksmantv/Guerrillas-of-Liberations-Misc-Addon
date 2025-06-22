
params ["_unit","_adjustedChance"];
private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];

_adjustedChance = _adjustedChance min 1;
private _dice = random 1;

if (_dice < _adjustedChance) then {
    if(_surrenderDebug) then {
        format ["Surrendered: Dice rolled: %1 << %2", round(_dice * 100), round(_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
    };   
    if(_unit getVariable ["GOL_Surrender",false]) then {
        [_unit] spawn OKS_fnc_SurrenderHandle;
    };
    _unit removeAllEventHandlers "Hit";
} else {
    if(_surrenderDebug) then { 
        format ["No Surrender: Dice rolled: %1 << %2", round(_dice * 100), round(_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
    };
};