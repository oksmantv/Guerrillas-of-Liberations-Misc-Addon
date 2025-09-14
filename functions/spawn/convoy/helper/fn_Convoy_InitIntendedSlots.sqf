/*
  OKS_fnc_Convoy_InitIntendedSlots
  Records each vehicle’s original intended slot index at convoy start.
  Params:
    0: OBJECT - lead vehicle (holds OKS_Convoy_VehicleArray)
*/
params ["_leadVeh"];
if (isNull _leadVeh) exitWith {};

private _arr = _leadVeh getVariable ["OKS_Convoy_VehicleArray", []];
{
  _x setVariable ["OKS_Convoy_IntendedSlot", _forEachIndex, true];
} forEach _arr;

_leadVeh setVariable ["OKS_Convoy_PrimarySlotCount", count _arr, true]; // optional: baseline primary count
