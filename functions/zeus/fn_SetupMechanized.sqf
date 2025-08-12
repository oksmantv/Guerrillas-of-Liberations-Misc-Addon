/*
    This is called when the mechanized module is placed.
    _logic = module object
*/

params ["_logic"];

private _vehicle = nearestObject [_logic, "LandVehicle"];
[_vehicle] spawn OKS_fnc_Mechanized;

deleteVehicle _logic; // Clean up the module logic after setup