/// [this, true,true] spawn OKS_fnc_Mechanized;
/// [vehicle,ShouldAddMortar,AddServiceStationInCargo,ShouldDisableThermals,ShouldDisableNVG]
/// Add MSS Box true/false

if(!isServer) exitWith {};

Params
[
	["_Vehicle", ObjNull, [ObjNull]],
	["_Flag",(missionNamespace getVariable ["GOL_Vehicle_Flag",nil]),[""]],
	["_AddMortar", false, [true]],
	["_ServiceStation", true, [true]],
	["_ShouldDisableThermal", true, [true]],
	["_shouldDisableNVG", false, [true]],
	["_MortarType","heavy",[""]]
];

sleep 5;

if(!isNil "_Flag") then {
	_Vehicle forceFlagTexture _Flag;
};

Private _Debug_Variable = false;
_Vehicle setVariable ["GW_Disable_autoRemoveCargo",true,true];

clearItemCargoGlobal _Vehicle;
clearWeaponCargoGlobal _Vehicle;
clearMagazineCargoGlobal _Vehicle;
clearBackpackCargoGlobal _Vehicle;
_Vehicle setFuelConsumptionCoef 3;

if(_ShouldDisableThermal) then {
	_Vehicle disableTIEquipment true;
	_Vehicle setVariable ["A3TI_Disable", true,true];
};
if(_shouldDisableNVG) then {
	_Vehicle disableNVGEquipment true;
};

_Vehicle setVariable ["gw_gear_blackList",true,true];
if(_Debug_Variable) then {SystemChat "Setting Cargo Space"};
waitUntil {sleep 1; !(isNil "ace_cargo_fnc_setSpace")};

_Vehicle spawn {
	Params ["_Vehicle"];
	while {alive _Vehicle} do {
		[_Vehicle, 40] call ace_cargo_fnc_setSpace;
		sleep 60;
	}
};

if(_ServiceStation) then {
	if(_Debug_Variable) then {SystemChat "Adding Service Station Box"};
	_ShouldGiveServiceStationToVehicle = ["ShouldGiveServiceStationToVehicle", 1] call BIS_fnc_getParamValue;
	if(!(_Vehicle getVariable ["GOL_isMHQ",false]) && _ShouldGiveServiceStationToVehicle isEqualTo 1) then {
		waitUntil {sleep 0.1; isNull (attachedTo _Vehicle)};		
		_Crate = "GOL_MobileServiceStation" createVehicle [0,0,0];
		[_Crate,_Vehicle,true] call ace_cargo_fnc_loadItem;				
		_Debug = missionNamespace getVariable ["MHQ_Debug",false];
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
		[_fuelCan,1000] call ace_refuel_fnc_makeJerryCan;
		[_fuelCan,_Vehicle,true] call ace_cargo_fnc_loadItem;
	} foreach [1,2,3];
};

if(_Vehicle getVariable ["GOL_isMHQ",false]) then {
	_Vehicle addItemCargoGlobal ["GOL_Packed_Drone_AP",5];
	_Vehicle addItemCargoGlobal ["GOL_Packed_Drone_AT",5];
};
_Vehicle addItemCargoGlobal ["Toolkit",1];
_Vehicle addMagazineCargoGlobal ["SatchelCharge_Remote_Mag",4];
_Vehicle addMagazineCargoGlobal ["DemoCharge_Remote_Mag",4];
_Vehicle addWeaponCargoGlobal ["rhs_weap_fim92",2];
_Vehicle addMagazineCargoGlobal ["rhs_fim92_mag",5];
_Vehicle addItemCargoGlobal ["ACE_rope6",1];
_Vehicle addItemCargoGlobal ["ACE_rope12",1];

if(_AddMortar) then {
	if(_Debug_Variable) then {SystemChat "Adding Mortar Equipment"};
	Switch (_MortarType) do {
		case "light": {
			_Vehicle addWeaponCargoGlobal ["UK3CB_BAF_M6",1];
			_Vehicle addItemCargoGlobal ["Packed_60mm_HE",6];
			_Vehicle addItemCargoGlobal ["Packed_60mm_HEAB",4];
			_Vehicle addItemCargoGlobal ["Packed_60mm_Smoke",4];
		};
		case "heavy":{
			_Vehicle addItemCargoGlobal ["GOL_Packed_Mortar",1];
		};
	};
};

if (["FV432_Mk3_GPMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["Panther_GPMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["WMIK_GPMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["Passenger_GPMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["Logistics_GPMG",(typeOf _Vehicle)] call BIS_fnc_inString) then 
{
	_Vehicle AddMagazineCargoGlobal ["UK3CB_BAF_762_200Rnd_T",10];
};

if (["Passenger_HMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["Logistics_HMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["L111A1",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["FV432_Mk3_RWS",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["LandRover_WMIK_HMG",(typeOf _Vehicle)] call BIS_fnc_inString) then 
{
	_Vehicle AddMagazineCargoGlobal ["UK3CB_BAF_127_100Rnd",10];
};

if(["L134A1",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["WMIK_GMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["Logistics_GMG",(typeOf _Vehicle)] call BIS_fnc_inString ||
	["Passenger_GMG",(typeOf _Vehicle)] call BIS_fnc_inString) then 
{
	_Vehicle AddMagazineCargoGlobal ["UK3CB_BAF_32Rnd_40mm_G_Box",10];
};

if(["WMIK_Milan",(typeOf _Vehicle)] call BIS_fnc_inString) then {
	_Vehicle AddMagazineCargoGlobal ["UK3CB_BAF_1Rnd_Milan",5];
};

if(["WMIK",(typeOf _Vehicle)] call BIS_fnc_inString || ["Coyote",(typeOf _Vehicle)] call BIS_fnc_inString || ["Jackal2",(typeOf _Vehicle)] call BIS_fnc_inString  ) then {
	_Vehicle AddMagazineCargoGlobal ["UK3CB_BAF_762_100Rnd_T",10];
};


if(_Debug_Variable) then {SystemChat "Add Smoke Generator and Smoke Ammo"};
// Add Smokegenerator and Smoke Screen Ammo
_Vehicle addweaponTurret ["rhs_weap_smokegen",[-1]];
_Vehicle AddMagazineTurret ["rhs_mag_smokegen",[-1]];

for [{private _i = 0}, {_i < 6}, {_i = _i + 1}] do {
	_Vehicle addMagazineTurret ["SmokeLauncherMag",[0,0]];
	_Vehicle addMagazineTurret ["rhsusf_mag_L8A3_8",[0,0]];
};

waitUntil {sleep 1; !(isNil "ace_cargo_fnc_loadItem") && !(isNil "ace_cargo_fnc_removeCargoItem")};
if(!(_Vehicle getVariable ["GOL_isMHQ",false])) then {
	["ACE_Wheel", _Vehicle, 4] call ace_cargo_fnc_removeCargoItem;
	["ACE_Track", _Vehicle, 4] call ace_cargo_fnc_removeCargoItem;
};

if(_Vehicle isKindOf "Tank" && !(_Vehicle getVariable ["GOL_isMHQ",false])) then {
	//systemChat "Is tank, giving tracks";
	if(_Debug_Variable) then {SystemChat "Is Tracked, giving Tracks"};
	["ACE_Track", _Vehicle,true] call ace_cargo_fnc_loadItem;
	["ACE_Track", _Vehicle,true] call ace_cargo_fnc_loadItem;
	["ACE_Track", _Vehicle,true] call ace_cargo_fnc_loadItem;
};

if(_Vehicle isKindOf "Car" && !(_Vehicle getVariable ["GOL_isMHQ",false])) then {
	if(_Debug_Variable) then {SystemChat "Is Wheeled, giving Wheels"};
	["ACE_Wheel", _Vehicle,true] call ace_cargo_fnc_loadItem;
	["ACE_Wheel", _Vehicle,true] call ace_cargo_fnc_loadItem;
	["ACE_Wheel", _Vehicle,true] call ace_cargo_fnc_loadItem;
};

sleep 5;

// Fix APS - Automatic Smoke
if(_Debug_Variable) then {SystemChat "Remove dapsCanSmoke"};
_Vehicle setVariable["dapsCanSmoke",0,true];