/// Sets up basic vehicle inventory (tools, weapons, ropes, etc.)
/// [_Vehicle, _AddMortar, _MortarType] call OKS_fnc_SetupVehicleInventory;

params ["_Vehicle", "_AddMortar", "_MortarType"];

Private _GroundVehiclesDebug = missionNamespace getVariable ["GOL_GroundVehicles_Debug",false];

if(_GroundVehiclesDebug) then {
	format["[VEHICLE-INVENTORY] Setting up basic inventory for: %1 | MHQ: %2 | AddMortar: %3", typeOf _Vehicle, _Vehicle getVariable ["GOL_isMHQ",false], _AddMortar] spawn OKS_fnc_LogDebug;
};

if(_Vehicle getVariable ["GOL_isMHQ",false]) then {
	if(_GroundVehiclesDebug) then {
		format["[VEHICLE-INVENTORY] Adding MHQ-specific drones to: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
	
	_Vehicle addItemCargoGlobal ["GOL_Packed_Drone_AP",5];
	_Vehicle addItemCargoGlobal ["GOL_Packed_Drone_AT",5];
};
if(_GroundVehiclesDebug) then {
	format["[VEHICLE-INVENTORY] Adding standard equipment to: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
};

_Vehicle addItemCargoGlobal ["Toolkit",1];
_Vehicle addMagazineCargoGlobal ["SatchelCharge_Remote_Mag",4];
_Vehicle addMagazineCargoGlobal ["DemoCharge_Remote_Mag",4];
_Vehicle addWeaponCargoGlobal ["rhs_weap_fim92",2];
_Vehicle addMagazineCargoGlobal ["rhs_fim92_mag",5];
_Vehicle addItemCargoGlobal ["ACE_rope6",1];
_Vehicle addItemCargoGlobal ["ACE_rope12",1];

if(_AddMortar) then {
	if(_GroundVehiclesDebug) then {
		format["[VEHICLE-INVENTORY] Adding mortar setup - Type: %1 to vehicle: %2", _MortarType, typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
	
	Switch (_MortarType) do {
		case "light": {
			_Vehicle addWeaponCargoGlobal ["UK3CB_BAF_M6",2];
			_Vehicle addItemCargoGlobal ["Packed_60mm_HE",6];
			_Vehicle addItemCargoGlobal ["Packed_60mm_HEAB",4];
			_Vehicle addItemCargoGlobal ["Packed_60mm_Smoke",4];
		};
		case "heavy":{
			_Vehicle addItemCargoGlobal ["GOL_Packed_Mortar",2];
		};
	};
};