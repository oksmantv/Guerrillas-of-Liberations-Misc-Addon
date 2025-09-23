/// Sets up cargo items (spare parts) for a vehicle
/// [_Vehicle] call OKS_fnc_SetupCargoItems;

params ["_Vehicle"];

Private _GroundVehiclesDebug = missionNamespace getVariable ["GOL_GroundVehicles_Debug",false];

if(_GroundVehiclesDebug) then {
	format["[CARGO-ITEMS] Setting up cargo items for: %1 | Tank: %2 | MHQ: %3", typeOf _Vehicle, _Vehicle isKindOf "Tank", _Vehicle getVariable ["GOL_isMHQ",false]] spawn OKS_fnc_LogDebug;
};

waitUntil {sleep 1; !(isNil "ace_cargo_fnc_loadItem") && !(isNil "ace_cargo_fnc_removeCargoItem")};
if(!(_Vehicle getVariable ["GOL_isMHQ",false])) then {
	if(_GroundVehiclesDebug) then {
		format["[CARGO-ITEMS] Removing default ACE cargo items from non-MHQ vehicle: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
	
	["ACE_Wheel", _Vehicle, 4] call ace_cargo_fnc_removeCargoItem;
	["ACE_Track", _Vehicle, 4] call ace_cargo_fnc_removeCargoItem;
};

if(_Vehicle isKindOf "Tank" && !(_Vehicle getVariable ["GOL_isMHQ",false])) then {
	if(_GroundVehiclesDebug) then {
		format["[CARGO-ITEMS] Adding tank tracks to non-MHQ tank: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
	["ACE_Track", _Vehicle,true] call ace_cargo_fnc_loadItem;
	["ACE_Track", _Vehicle,true] call ace_cargo_fnc_loadItem;
	["ACE_Track", _Vehicle,true] call ace_cargo_fnc_loadItem;
};

if(_Vehicle isKindOf "Car" && !(_Vehicle getVariable ["GOL_isMHQ",false])) then {
	if(_GroundVehiclesDebug) then {
		format["[CARGO-ITEMS] Adding spare wheels to non-MHQ car: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
	
	["ACE_Wheel", _Vehicle,true] call ace_cargo_fnc_loadItem;
	["ACE_Wheel", _Vehicle,true] call ace_cargo_fnc_loadItem;
	["ACE_Wheel", _Vehicle,true] call ace_cargo_fnc_loadItem;
};