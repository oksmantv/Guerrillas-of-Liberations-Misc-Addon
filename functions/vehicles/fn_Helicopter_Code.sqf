	// [this,true,false] spawn OKS_Fnc_Helicopter_Code;
	
	Private _Debug_Variable = false;
	Params ["_Vehicle","_ShouldDisableThermal","_shouldDisableNVG"];
	_Vehicle RemoveAllEventHandlers "HandleDamage";
	_Vehicle setVariable ["NEKY_OldDamage",0];
	_Vehicle setVariable ["GW_Disable_autoRemoveCargo",true,true];

	clearItemCargoGlobal _Vehicle;
	clearWeaponCargoGlobal _Vehicle;
	clearMagazineCargoGlobal _Vehicle;
	clearBackpackCargoGlobal _Vehicle;

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
	[_Vehicle, 30] call ace_cargo_fnc_setSpace;

	_Vehicle setVariable ["ace_repair_canRepair", 1, true];
	_Vehicle setVariable ["ace_isRepairFacility", 1, true];

	_Vehicle addItemCargoGlobal ["Toolkit",2];
	_Vehicle addMagazineCargoGlobal ["SatchelCharge_Remote_Mag",5];
	_Vehicle addItemCargoGlobal ["ACE_rope36",4];

	// Add Extra Flares
	_CMWeapons = (_Vehicle weaponsTurret [-1]) select {["CM", _X,false] call BIS_fnc_inString};

	{
		_CMWeapon = _X;
		//systemchat str _CMWeapon;
		_FlareMag = (getArray (configFile >> "CfgWeapons" >> (_CMWeapon) >> "magazines")
			select 
				(count (getArray (configFile >> "CfgWeapons" >> (_CMWeapon) >> "magazines"))) - 1 );
		{_Vehicle removeMagazinesTurret [_X,[-1]]} forEach getArray (configFile >> "CfgWeapons" >> (_CMWeapon) >> "magazines");
		//systemchat str _FlareMag;
		_Vehicle addMagazineTurret [_FlareMag,[-1]];
		_Vehicle addMagazineTurret [_FlareMag,[-1]];
	} foreach _CMWeapons;

	_Vehicle setVehicleAmmo 1;
	_isWhiteList = {
		Params ["_Vehicle"];
		Private "_return";
		_WhiteListWords = ["mi24","mi8"];
		{
			if (((ToLower typeOf _Vehicle) find _X) == -1) then {
				_return = false;
			} else {
				_return = true;
				break;
			};
		} foreach _WhiteListWords;
		if(true) exitWith {_return}
	};	
	
	// Created by Neko-Arrow - Thanks very much
	if([_Vehicle] call _isWhiteList) then {
		_Vehicle addEventHandler ["HandleDamage",
		{
		    Params ["_Unit","_Selection","_NewDamage"];

		    //SystemChat str _Selection;

		    // Exits
		    if !(Alive _Unit) exitWith {};
		    if ( ((ToLower _Selection) find "rotor") == -1 ) exitWith {};

		    // Variables
		    _Multiplier = 0.05;

		    // Added Damage
		    _OldDamage = _Unit getVariable ["NEKY_OldDamage",0];
		    _AddedDamage = _NewDamage - _OldDamage;

		    //if !(_AddedDamage < 0) exitWith { 0 };
		    // New Damage
		    _Damage = _OldDamage + (_AddedDamage * _Multiplier);
		    _Damage = if (_Damage > 1) then { 1 } else { _Damage };

		    //SystemChat format ["Old: %3 Added: %1 Final: Damage %2",(_AddedDamage * _Multiplier),_Damage,_OldDamage];
		    _Unit setVariable ["NEKY_OldDamage",_Damage];

		    _Damage
		}];
	};