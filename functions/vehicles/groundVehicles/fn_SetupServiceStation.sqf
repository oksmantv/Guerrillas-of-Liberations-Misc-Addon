/// Sets up service station cargo for a vehicle
/// [_Vehicle, _ServiceStation] call OKS_fnc_SetupServiceStation;

params ["_Vehicle", "_ServiceStation"];

Private _GroundVehiclesDebug = missionNamespace getVariable ["GOL_GroundVehicles_Debug",false];

if(_GroundVehiclesDebug) then {
	format["[SERVICESTATION] Starting service station setup for: %1 | ServiceStation enabled: %2", typeOf _Vehicle, _ServiceStation] spawn OKS_fnc_LogDebug;
};

if(_ServiceStation) then {
	if(_GroundVehiclesDebug) then {
		format["[SERVICESTATION] Setting up service station for vehicle: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
	
	_Debug = missionNamespace getVariable ["MHQ_Debug",false];
	if(_Debug) then {SystemChat "Adding Service Station Box"};
	_ShouldGiveServiceStationToVehicle = ["ShouldGiveServiceStationToVehicle", 1] call BIS_fnc_getParamValue;
	if(!(_Vehicle getVariable ["GOL_isMHQ",false]) && _ShouldGiveServiceStationToVehicle isEqualTo 1) then {
		if(_GroundVehiclesDebug) then {
			format["[SERVICESTATION] Creating mobile service station for non-MHQ vehicle: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
		};
		
		waitUntil {sleep 0.1; isNull (attachedTo _Vehicle)};		
		_Crate = "GOL_MobileServiceStation" createVehicle [0,0,0];
		[_Crate,_Vehicle,true] call ace_cargo_fnc_loadItem;
		
		if(_GroundVehiclesDebug) then {
			format["[SERVICESTATION] Mobile service station %1 loaded into vehicle: %2", typeOf _Crate, typeOf _Vehicle] spawn OKS_fnc_LogDebug;
		};
		
		if(_Debug) then {
			format["%1 added to cargo of vehicle: %1",typeOf _Crate,_Vehicle] spawn OKS_fnc_LogDebug;
		};
	};

	_MHQShouldBeMobileServiceStation = missionNamespace getVariable ["MHQ_ShouldBe_ServiceStation",false];
	if(_Vehicle getVariable ["GOL_isMHQ",false] && !(_MHQShouldBeMobileServiceStation)) then {
		waitUntil {sleep 0.1; isNull (attachedTo _Vehicle)};
		_Crate = "GOL_MobileServiceStation" createVehicle [0,0,0];
		[_Crate,_Vehicle,true] call ace_cargo_fnc_loadItem;			
		_Debug = missionNamespace getVariable ["MHQ_Debug",false];
		if(_Debug) then {
			format["%1 added to cargo of mhq: %1",typeOf _Crate,_Vehicle] spawn OKS_fnc_LogDebug;
		};
	};
} else {
	{
		_fuelCan = "FlexibleTank_01_forest_F" createVehicle [0,0,0];
		[_fuelCan,1000] call ace_refuel_fnc_setFuel;
		[_fuelCan,_Vehicle,true] call ace_cargo_fnc_loadItem;
	} foreach [1,2];
};