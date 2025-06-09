

params ["_unit"];

if(hasInterface && !isServer) exitWith {};

private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];

if(_surrenderDebug) then {
    format["%1 Surrender Handle triggered", name _unit] spawn OKS_fnc_LogDebug;
};

[_unit] spawn OKS_fnc_ThrowWeaponsOnGround;
sleep 0.5;
[_unit] call OKS_fnc_SetSurrendered;
sleep 2.5;
[_unit] spawn OKS_fnc_KilledCaptiveEvent;
[_unit] call OKS_fnc_AddCivilianKilled;