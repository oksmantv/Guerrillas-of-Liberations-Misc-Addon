/*
    This is called when the helicopter module is placed.
    _logic = module object
*/

params ["_logic"];

private _helicopter = nearestObject [_logic, "Air"];
[_helicopter] spawn OKS_fnc_Helicopter;

deleteVehicle _logic; // Clean up the module logic after setup