/*
  OKS_fnc_Convoy_InitIntendedSlots
  Records each vehicle’s original intended slot index at convoy start.
  Params:
    0: OBJECT - lead vehicle (holds OKS_Convoy_VehicleArray)
*/
params ["_LeaderVehicle"];
if (isNull _LeaderVehicle) exitWith {};

private _ConvoyArray = _LeaderVehicle getVariable ["OKS_Convoy_VehicleArray", []];
{
  _x setVariable ["OKS_Convoy_IntendedSlot", _forEachIndex, true];
  _x setVariable ["OKS_Convoy_PrimarySlotCount", count _ConvoyArray, true]; // optional: baseline primary count
} forEach _ConvoyArray;


