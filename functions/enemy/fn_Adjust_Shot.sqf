
params ["_unit","_adjustedChance"];
private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];

_adjustedChance = _adjustedChance + 0.05;
if(_surrenderDebug) then {
    format [
        "Surrender chance increased by 10%% (shot). New chance: %1%%",
        round(_adjustedChance * 100)
    ] spawn OKS_fnc_LogDebug;
};

_adjustedChance