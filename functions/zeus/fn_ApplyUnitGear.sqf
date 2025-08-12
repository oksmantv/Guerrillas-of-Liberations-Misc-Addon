/*
    This is called when the gear module is placed.
    _logic = module object
*/

params ["_logic"];

private _unit = nearestObject [_logic, "Man"];
[_unit] call GW_Gear_Fnc_Init;

deleteVehicle _logic; // Clean up the module logic after setup