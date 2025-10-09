
params ["_unit","_adjustedChance"];
private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];

_value = missionNamespace getVariable ["GOL_Surrender_Adjust_Flashbang", 30];
_value = _value / 100;
_value = 1 + _value;
_adjustedChance = _adjustedChance * _value;
if(_surrenderDebug) then {
    format [
        "[SURRENDER] Surrender chance increased by %1%% (flashbang). New chance: %2%%",
        round((_value - 1) * 100),
        round(_adjustedChance * 100)
    ] spawn OKS_fnc_LogDebug;           
};

_adjustedChance