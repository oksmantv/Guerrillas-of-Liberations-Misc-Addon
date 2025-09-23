/// [this] spawn OKS_fnc_Mechanized;
/// [vehicle,ShouldAddMortar,AddServiceStationInCargo,ShouldDisableThermals,ShouldDisableNVG]
/// Add MSS Box true/false

if(!isServer) exitWith {};

Params
[
	["_Vehicle", ObjNull, [ObjNull]],
	["_Flag",(missionNamespace getVariable ["GOL_Vehicle_Flag",""]),[""]],
	["_AddMortar", false, [true]],
	["_ServiceStation", true, [true]],
	["_ShouldDisableThermal", true, [true]],
	["_shouldDisableNVG", false, [true]],
	["_MortarType","heavy",[""]]
];

Private _Debug = missionNamespace getVariable ["GOL_GroundVehicles_Debug",false];

if(_Debug) then {
	format["[MECHANIZED] Starting setup for vehicle: %1 (%2)", [configFile >> "CfgVehicles" >> typeOf _Vehicle] call BIS_fnc_displayName, typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	format["[MECHANIZED] Parameters - Mortar: %1 | ServiceStation: %2 | Thermal: %3 | NVG: %4 | MortarType: %5", _AddMortar, _ServiceStation, _ShouldDisableThermal, _shouldDisableNVG, _MortarType] spawn OKS_fnc_LogDebug;
};

sleep 5;

if(_Flag != "" && flagTexture _Vehicle == "") then {
	_Vehicle forceFlagTexture _Flag;
	if(_Debug) then {
		format["[MECHANIZED] Applied flag texture: %1", _Flag] spawn OKS_fnc_LogDebug;
	};
};

Private _Debug_Variable = false;
_Vehicle setVariable ["GW_Disable_autoRemoveCargo",true,true];

if(_Debug) then {
	format["[MECHANIZED] Clearing vehicle cargo and setting base properties"] spawn OKS_fnc_LogDebug;
};

clearItemCargoGlobal _Vehicle;
clearWeaponCargoGlobal _Vehicle;
clearMagazineCargoGlobal _Vehicle;
clearBackpackCargoGlobal _Vehicle;
_Vehicle setFuelConsumptionCoef 3;
_Vehicle AddMagazineTurret ["rhs_mag_smokegen",[-1]];
_Vehicle setVariable ["gw_gear_blackList",true,true];
_Vehicle addWeaponTurret ["rhs_weap_smokegen",[-1]];

if(_ShouldDisableThermal) then {
	_Vehicle disableTIEquipment true;
	_Vehicle setVariable ["A3TI_Disable", true,true];
	if(_Debug) then {
		format["[MECHANIZED] Disabled thermal equipment for: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
};
if(_shouldDisableNVG) then {
	_Vehicle disableNVGEquipment true;
	if(_Debug) then {
		format["[MECHANIZED] Disabled NVG equipment for: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
};

if(_Debug) then {
	format["[MECHANIZED] Starting modular function calls for: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
};

[_Vehicle] call OKS_fnc_SetupMissileWarning;
[_Vehicle, 40] call OKS_fnc_SetupCargoSpace;
[_Vehicle, _ServiceStation] call OKS_fnc_SetupServiceStation;
[_Vehicle, _AddMortar, _MortarType] call OKS_fnc_SetupVehicleInventory;
[_Vehicle] call OKS_fnc_Setup3CBVehicleAmmo;
[_Vehicle] call OKS_fnc_SetupCargoItems;
[_Vehicle] call OKS_fnc_AdjustPlayerVehicleDamage;
[_Vehicle] spawn OKS_fnc_VehicleEmpty;
sleep 5;
if(_Debug_Variable) then {SystemChat "Remove dapsCanSmoke"};
_Vehicle setVariable["dapsCanSmoke",0,true];

if(_Debug) then {
	format["[MECHANIZED] Completed setup for vehicle: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
};