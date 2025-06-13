/*
    [_value] call OKS_fnc_DecreaseMultiplier;
    _value is percent (default 10)
*/

params ["_value"];
if (isNil "_value") then { _value = 10; }; // Default to 10 if not provided

private _percent = _value / 100;

// Get current values from mission namespace
private _forceMultiplier = missionNamespace getVariable ["GOL_ForceMultiplier", 1];
private _responseMultiplier = missionNamespace getVariable ["GOL_ResponseMultiplier", 1];

// Decrease force, increase response
_forceMultiplier = _forceMultiplier * (1 - _percent);
_responseMultiplier = _responseMultiplier * (1 + _percent);

// Clamp values
_forceMultiplier = (_forceMultiplier max 1) min 3;
_responseMultiplier = (_responseMultiplier max 0.5) min 3;

// Update global variables
missionNamespace setVariable ["GOL_ForceMultiplier", _forceMultiplier, true];
missionNamespace setVariable ["GOL_ResponseMultiplier", _responseMultiplier, true];

private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug", false];
if(_Debug) then {
    format["Decreasing Multipliers by %1%% to %2%% (Force) & %3%% (Response)",_value, round (_forceMultiplier * 100), round (_responseMultiplier * 100)] spawn OKS_fnc_LogDebug;
};     