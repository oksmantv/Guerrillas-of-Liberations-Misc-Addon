/*
	Sets up an ACE Mobile Service Station.

	[_Crate] spawn OKS_fnc_SetupMobileServiceStation;
*/	

Params [
	"_Crate"
];

sleep 1;
if(!isServer) exitWith {
	"[SetupMSS] Not server exited." spawn OKS_fnc_LogDebug;
};

// Ensure Cargo is empty
ClearMagazineCargoGlobal _Crate;
ClearWeaponCargoGlobal _Crate;
ClearItemCargoGlobal _Crate;

// Set Repair
_Crate setVariable ["ace_repair_canRepair", 1, true];
_Crate setVariable ["ace_isRepairFacility", 1, true];

// Set Rearm
_Crate setVariable ["ace_rearm_isSupplyVehicle", true, true];
[_Crate, 9999] call ace_rearm_fnc_makeSource;
_Crate AddMagazineCargoGlobal ["UK3CB_BAF_127_100Rnd",20];
_Crate AddMagazineCargoGlobal ["UK3CB_BAF_32Rnd_40mm_G_Box",12];
_Crate AddMagazineCargoGlobal ["UK3CB_BAF_1Rnd_Milan",8];
_Crate AddMagazineCargoGlobal ["UK3CB_BAF_762_100Rnd_T",20];
_Crate AddMagazineCargoGlobal ["UK3CB_BAF_762_200Rnd_T",20];

// Set Fuel
_Debug = missionNamespace getVariable ["MHQ_Debug",false];
if((typeOf _Crate) isNotEqualTo "FlexibleTank_01_forest_F" &&
(typeOf _Crate) isNotEqualTo "GOL_MobileServiceStation" &&
(typeOf _Crate) isNotEqualTo "B_APC_Tracked_01_CRV_F") then {
	[_Crate, 9999] call ace_rearm_fnc_makeSource;
	if(_Debug) then {
		format["[SetupMSS] %1 made into source",_Crate] spawn OKS_fnc_LogDebug;
	};
} else {
	[_Crate, 9999] call ace_refuel_fnc_setFuel;
	if(_Debug) then {
		format["[SetupMSS] %1 already a fuel source.",_Crate] spawn OKS_fnc_LogDebug;
	};	
};
