/*

	Clear Civilian Presence Script by Oksman

	Deletes the Civilian presence module from the trigger and deletes all non-HVT civilians in the trigger area.

	Parameters:
	1: Trigger (Object)

	Example: [CivTrigger_1] spawn OKS_fnc_ClearCivilians;
*/

if(HasInterface && !isServer) exitWith {};

Params ["_Trigger"];
if(isNil "_Trigger") exitWith {};

_Module = _Trigger getVariable ["GOL_Civilians_Module",objNull];
if(!isNil "_Module") then {
	deleteVehicle _Module;
	{
		if(side group _X == civilian && !(_x getVariable ["GOL_HVT",false])) then {
			deleteVehicle _X;
		};
		sleep 0.1;
	} foreach list _Trigger;
	sleep 1;
	deleteVehicle _Trigger;
};