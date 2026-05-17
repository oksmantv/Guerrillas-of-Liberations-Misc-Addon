

params ["_unit"];

if(hasInterface && !isServer) exitWith {};

if(isNil "_unit") exitWith {};

private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];

if(_surrenderDebug) then {
    format["[SURRENDER] %1 Surrender Handle triggered", name _unit] spawn OKS_fnc_LogDebug;
};
// HVT units are disarmed and surrendered by the intercept system; skip the general flow.
if (_unit getVariable ["OKS_InterceptHvt_Surrendered", false]) exitWith {};

_unit setVariable ["GOL_NonCombatant", true, true];
[_unit] spawn OKS_fnc_ThrowWeaponsOnGround;
sleep 0.5;
[_unit] call OKS_fnc_SetSurrendered;
sleep 2.5;
_unit removeAllEventHandlers "SUPPRESSED";
_unit removeAllEventHandlers "HIT";
[_unit] spawn OKS_fnc_WaitUntilCaptiveAtBase;