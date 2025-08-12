/*
    This is called when the MHQ module is placed.
    _logic = module object
*/

params ["_logic"];

private _vehicle = nearestObject [_logic, "LandVehicle"];
[_Vehicle, "medium"] call GW_MHQ_Fnc_Handler;

deleteVehicle _logic; // Clean up the module logic after setup