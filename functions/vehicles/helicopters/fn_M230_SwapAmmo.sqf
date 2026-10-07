// [_target, _caller, _id, _args] call OKS_fnc_M230_SwapAmmo;
// Called by addAction on the pilot's machine.
// _args: [targetType] — "HE" or "AP"
//
// Thin relay only. All tracking and pylon logic run in OKS_fnc_M230_SetPylon
// on the vehicle-local machine. Ammo counts come from the Fired EH counters
// set in fn_HeliActions.sqf — no ammo reading needed here.

params ["_target", "_caller", "_id", "_args"];
_args params ["_targetType"];

[_target, _targetType] remoteExec ["OKS_fnc_M230_SetPylon", _target];
