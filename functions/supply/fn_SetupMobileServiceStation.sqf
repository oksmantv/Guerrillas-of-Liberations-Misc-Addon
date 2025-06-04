/*
	Sets up an ACE Mobile Service Station.

	[_Crate] spawn OKS_fnc_SetupMobileServiceStation;
*/	

Params [
	"_Crate"
];

// Ensure Cargo is empty
ClearMagazineCargoGlobal _Crate;
ClearWeaponCargoGlobal _Crate;
ClearItemCargoGlobal _Crate;

_Crate setVariable ["ace_rearm_isSupplyVehicle", true];
_Crate setVariable ["ace_repair_canRepair", 1, true];
_Crate setVariable ["ace_isRepairFacility", 1, true];			

if(typeOf _Crate isNotEqualTo "FlexibleTank_01_forest_F") then {
	[_Crate, 9999] call ace_refuel_fnc_setFuel;
};
[_Crate, 9999] call ace_rearm_fnc_makeSource;