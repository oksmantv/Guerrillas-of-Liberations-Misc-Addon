/*
	OKS_fnc_CycleVehicleWeapon

	NOT YET IMPLEMENTED

*/

params ["_Vehicle","_WeaponClass"];

while {alive gunner _Vehicle} do {

	if(count (gunner _Vehicle targets [true]) == 0 || currentWeapon gunner _Vehicle == _WeaponClass ) exitWith {
		format["[CycleVehicleWeapon] No targets or weapon already selected, exiting.."] spawn OKS_fnc_LogDebug;
	};

};
