// [this] spawn OKS_Fnc_Helicopter_Code;

Private _Debug_Variable = false;
Params [
	"_Helicopter",
	["_ShouldDisableThermal",false,[false]],
	["_shouldDisableNVG",false,[false]],
	["_ShouldAddExtraFlares",true,[true]]
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
[_Helicopter, 30] call ace_cargo_fnc_setSpace;
if(getText (configFile >> "CfgVehicles" >> typeOf _Helicopter >> "ace_fastroping_friesType") isNotEqualTo "") then {
	[_Helicopter] call ace_fastroping_fnc_equipFRIES;
};

_Helicopter setVariable ["ace_repair_canRepair", 1, true];
_Helicopter setVariable ["ace_isRepairFacility", 1, true];
_Helicopter setVariable ["ace_repair_canRefuel", 1, true];

_Helicopter addItemCargoGlobal ["Toolkit",2];
_Helicopter addMagazineCargoGlobal ["SatchelCharge_Remote_Mag",5];
_Helicopter addItemCargoGlobal ["ACE_rope36",4];

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