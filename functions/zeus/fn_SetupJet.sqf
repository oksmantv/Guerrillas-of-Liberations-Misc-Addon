/*
    This is called when the Jet Setup module is placed.
    _logic = module object
*/

params ["_logic"];

if (!isServer) exitWith {};

private _jet = nearestObject [_logic, "Plane"];

if (!isNull _jet) then {
    [_jet] spawn OKS_fnc_Jet;
};

deleteVehicle _logic; // Clean up the module logic after setup