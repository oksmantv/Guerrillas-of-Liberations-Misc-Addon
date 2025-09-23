/// Sets up UK3CB vehicle-specific ammunition for a vehicle
/// [_Vehicle] call OKS_fnc_Setup3CBVehicleAmmo;

params ["_Vehicle"];

Private _GroundVehiclesDebug = missionNamespace getVariable ["GOL_GroundVehicles_Debug",false];

if(_GroundVehiclesDebug) then {
	format["[3CB-AMMO] Setting up UK3CB ammunition for vehicle: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
};

if (["FV432_Mk3_GPMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["Panther_GPMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["WMIK_GPMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["Passenger_GPMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["Logistics_GPMG",(typeOf _Vehicle)] call BIS_fnc_inString) then 
{
	if(_GroundVehiclesDebug) then {
		format["[3CB-AMMO] Adding GPMG ammunition for: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
	
	_Vehicle AddMagazineCargoGlobal ["UK3CB_BAF_762_200Rnd_T",10];
};

if (["Passenger_HMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["Logistics_HMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["L111A1",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["FV432_Mk3_RWS",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["LandRover_WMIK_HMG",(typeOf _Vehicle)] call BIS_fnc_inString) then 
{
	if(_GroundVehiclesDebug) then {
		format["[3CB-AMMO] Adding HMG ammunition for: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
	
	_Vehicle AddMagazineCargoGlobal ["UK3CB_BAF_127_100Rnd",10];
};

if(["L134A1",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["WMIK_GMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["Logistics_GMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["Passenger_GMG",(typeOf _Vehicle)] call BIS_fnc_inString) then 
{
	if(_GroundVehiclesDebug) then {
		format["[3CB-AMMO] Adding GMG ammunition for: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
	_Vehicle AddMagazineCargoGlobal ["UK3CB_BAF_32Rnd_40mm_G_Box",10];
};

if(["WMIK_Milan",(typeOf _Vehicle)] call BIS_fnc_inString) then {
	_Vehicle AddMagazineCargoGlobal ["UK3CB_BAF_1Rnd_Milan",5];
};

if(["WMIK",(typeOf _Vehicle)] call BIS_fnc_inString || ["Coyote",(typeOf _Vehicle)] call BIS_fnc_inString || ["Jackal2",(typeOf _Vehicle)] call BIS_fnc_inString  ) then {
	_Vehicle AddMagazineCargoGlobal ["UK3CB_BAF_762_100Rnd_T",10];
};