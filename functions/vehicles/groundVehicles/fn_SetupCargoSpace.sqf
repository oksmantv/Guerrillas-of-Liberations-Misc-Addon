/// Sets up ACE cargo space for a vehicle
/// [_Vehicle, _cargoSize] call OKS_fnc_SetupCargoSpace;

params ["_Vehicle", "_cargoSize"];

Private _Debug = missionNamespace getVariable ["GOL_GroundVehicles_Debug",false];

if(_Debug) then {
	format["[CARGOSPACE] Starting cargo space setup for: %1 with size: %2", typeOf _Vehicle, _cargoSize] spawn OKS_fnc_LogDebug;
};

waitUntil {sleep 1; !(isNil "ace_cargo_fnc_setSpace")};

if(_Debug) then {
	format["[CARGOSPACE] ACE cargo functions loaded, spawning continuous cargo space management"] spawn OKS_fnc_LogDebug;
};

[_Vehicle, _cargoSize] spawn {
	params ["_Vehicle", "_cargoSize"];
	Private _Debug = missionNamespace getVariable ["GOL_GroundVehicles_Debug",false];
	
	if(_Debug) then {
		format["[CARGOSPACE] Started background cargo space maintenance for: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
	
	while {alive _Vehicle} do {
		[_Vehicle, _cargoSize] call ace_cargo_fnc_setSpace;
		sleep 60;
	};
	
	if(_Debug) then {
		format["[CARGOSPACE] Vehicle destroyed, ending cargo space maintenance for: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
};