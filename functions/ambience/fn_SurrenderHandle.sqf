

params ["_unit"];
private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];

if(_surrenderDebug) then {
    format["%1 Surrender triggered by shot!", name _unit] spawn OKS_fnc_LogDebug;
};

[_unit] spawn OKS_fnc_ThrowWeaponsOnGround;
sleep 1;
[_unit] call OKS_fnc_SetSurrendered;
sleep 1.5;
[_unit] spawn OKS_Fnc_KilledCaptiveEvent; 