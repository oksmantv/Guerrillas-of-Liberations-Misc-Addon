
params ["_unit","_adjustedChance"];

// Increase for suppression
private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];
private _suppression = getSuppression _unit;
_value = missionNamespace getVariable ["GOL_Surrender_Adjust_Suppressed", 5];
_value = _value / 100;
if (_suppression > 0.85) then {
    _adjustedChance = _adjustedChance + _value;
    if(_surrenderDebug) then {
        format [
            "[SURRENDER] Surrender chance increased by %1%% (Suppression: %2%%). New chance: %3%%",
            round(_value * 100), round(_suppression * 100), round(_adjustedChance * 100)
        ] spawn OKS_fnc_LogDebug;
    };
};

_adjustedChance