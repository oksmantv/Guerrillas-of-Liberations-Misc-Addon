
params ["_unit","_adjustedChance"];
private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];

// Set to surrendered if unarmed.
_value = missionNamespace getVariable ["GOL_Surrender_Adjust_Unarmed", 15];
_value = _value / 100;
if(primaryWeapon _unit == "" && secondaryWeapon _unit == "" && handgunWeapon _unit == "") then {
    _adjustedChance = _value;
    if(_surrenderDebug) then {
        format ["[SURRENDER] Unarmed increased chance to %1%%", round(_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
    };
};

_adjustedChance