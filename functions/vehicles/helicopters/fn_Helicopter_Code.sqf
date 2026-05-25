// [this] spawn OKS_Fnc_Helicopter_Code;

Private _Debug_Variable = false;
Params [
	"_Helicopter",
	["_ShouldDisableThermal",false,[false]],
	["_shouldDisableNVG",false,[false]],
	["_ShouldAddExtraFlares",false,[true]]
];

_Helicopter setVariable ["GW_Disable_autoRemoveCargo",true,true];

clearItemCargoGlobal _Helicopter;
clearWeaponCargoGlobal _Helicopter;
clearMagazineCargoGlobal _Helicopter;
clearBackpackCargoGlobal _Helicopter;

if(_ShouldDisableThermal) then {
	_Helicopter disableTIEquipment true;
	_Helicopter setVariable ["A3TI_Disable", true,true];
};
if(_shouldDisableNVG) then {
	_Helicopter disableNVGEquipment true;
};

_Helicopter setVariable ["gw_gear_blackList",true,true];
if(_Debug_Variable) then { "Setting Cargo Space" spawn OKS_fnc_LogDebug; };
waitUntil {sleep 1; !(isNil "ace_cargo_fnc_setSpace")};
[_Helicopter, 40] call ace_cargo_fnc_setSpace;
if(getText (configFile >> "CfgVehicles" >> typeOf _Helicopter >> "ace_fastroping_friesType") isNotEqualTo "") then {
	[_Helicopter] call ace_fastroping_fnc_equipFRIES;
};

{
	_fuelCan = "FlexibleTank_01_forest_F" createVehicle [0,0,0];
	[_fuelCan,1000] call ace_refuel_fnc_setFuel;
	[_fuelCan,_Helicopter,true] call ace_cargo_fnc_loadItem;
} foreach [1,2];

_Helicopter setVariable ["ace_repair_canRepair", 1, true];
_Helicopter setVariable ["ace_isRepairFacility", 1, true];
_Helicopter setVariable ["ace_repair_canRefuel", 1, true];

_Helicopter addItemCargoGlobal ["Toolkit",2];
_Helicopter addMagazineCargoGlobal ["SatchelCharge_Remote_Mag",5];
_Helicopter addItemCargoGlobal ["ACE_rope36",4];

// M230 Chain Gun pod — add ammo swap actions unconditionally.
// Condition strings gate visibility: only shown to the pilot when a pod is loaded.
// Preserves round counts across swaps via GOL_M230_HE_Ammo / GOL_M230_AP_Ammo vehicle variables.
_Helicopter addAction [
	"M230: Switch to <t color='#FF6666'>AP</t>",
	{ _this call OKS_fnc_M230_SwapAmmo },
	["GOL_PylonWeapon_M230_AP", "GOL_PylonWeapon_M230_HE"],
	6, false, true, "",
	"driver _target == player && currentWeapon _target == 'GOL_weapon_M230_ChainGun' && 'GOL_PylonWeapon_M230_HE' in (getPylonMagazines _target) && (_target getVariable ['GOL_M230_AP_Ammo', 250]) > 0"
];
_Helicopter addAction [
	"M230: Switch to <t color='#66FF66'>HE</t>",
	{ _this call OKS_fnc_M230_SwapAmmo },
	["GOL_PylonWeapon_M230_HE", "GOL_PylonWeapon_M230_AP"],
	6, false, true, "",
	"driver _target == player && currentWeapon _target == 'GOL_weapon_M230_ChainGun' && 'GOL_PylonWeapon_M230_AP' in (getPylonMagazines _target) && (_target getVariable ['GOL_M230_HE_Ammo', 250]) > 0"
];

if(_ShouldAddExtraFlares) then {
	_CMWeapons = (_Helicopter weaponsTurret [-1]) select {["CM", _X,false] call BIS_fnc_inString};
	{
		_CMWeapon = _X;
		_FlareMag = (getArray (configFile >> "CfgWeapons" >> (_CMWeapon) >> "magazines")
			select 
				(count (getArray (configFile >> "CfgWeapons" >> (_CMWeapon) >> "magazines"))) - 1 );
		{_Helicopter removeMagazinesTurret [_X,[-1]]} forEach getArray (configFile >> "CfgWeapons" >> (_CMWeapon) >> "magazines");
		_Helicopter addMagazineTurret [_FlareMag,[-1]];
		_Helicopter addMagazineTurret [_FlareMag,[-1]];
	} foreach _CMWeapons;
};

_Helicopter setVehicleAmmo 1;