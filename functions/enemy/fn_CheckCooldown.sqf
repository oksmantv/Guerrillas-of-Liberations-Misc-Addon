
params ["_unit","_cooldown","_type"];

private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];
private _lastCheck = _unit getVariable [format["GOL_SurrenderCooldown_%1",_type], -_cooldown];
if ((CBA_missionTime - _lastCheck) < _cooldown) exitWith {
    false
};

_unit setVariable [format["GOL_SurrenderCooldown_%1", _type], CBA_missionTime];
true

