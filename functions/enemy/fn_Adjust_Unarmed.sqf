
params ["_unit","_adjustedChance"];
private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];

// Set to surrendered if unarmed.
if(primaryWeapon _unit == "" && secondaryWeapon _unit == "" && handgunWeapon _unit == "") then {
    _adjustedChance = 0.3;
    if(_surrenderDebug) then {
        format ["[SURRENDER] Unarmed increased chance to %1%%", round(_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
    };
};

_adjustedChance