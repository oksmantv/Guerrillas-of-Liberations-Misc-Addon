
params ["_unit","_adjustedChance"];
private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];

_adjustedChance = _adjustedChance * 1.3;
if(_surrenderDebug) then {
    format [
        "[SURRENDER] Surrender chance increased by 150%% (flashbang). New chance: %1%%",
        round(_adjustedChance * 100)
    ] spawn OKS_fnc_LogDebug;           
};

_adjustedChance