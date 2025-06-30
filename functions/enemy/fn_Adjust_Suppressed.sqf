
params ["_unit","_adjustedChance"];

// Increase for suppression
private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];
private _suppression = getSuppression _unit;
if (_suppression > 0.85) then {
    _adjustedChance = _adjustedChance + 0.05;
    if(_surrenderDebug) then {
        format [
            "[SURRENDER] Surrender chance increased by 5%% (Suppression: %1%%). New chance: %2%%",
            round(_suppression * 100), round(_adjustedChance * 100)
        ] spawn OKS_fnc_LogDebug;
    };
};

_adjustedChance