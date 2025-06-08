	// [this] spawn OKS_Fnc_Helicopter_Code;
	
	Private _Debug_Variable = false;
	Params [
		"_Vehicle",
		["_ShouldDisableThermal",false,[false]],
		["_shouldDisableNVG",false,[false]]
	];
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
		_return;
	};	
	
	// Created by Neko-Arrow - Thanks very much
	if([_Vehicle] call _isWhiteList) then {
		_Debug = missionNamespace getVariable ["GOL_RotorProtection_Debug",false];
		private _vehicleClass = typeof _vehicle;
		private _displayName = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName");
		if(_Debug) then {
			format["Enabled Rotor protection on %1 - %2",_Vehicle,_displayName] spawn OKS_fnc_LogDebug;
		};
		_Vehicle addEventHandler ["HandleDamage",
		{
		    Params ["_Unit","_Selection","_NewDamage"];

		    //SystemChat str _Selection;
			if(isNil "_Selection" || _Selection == "") exitWith {
				//format["Rotor Protection: No Selection"] spawn OKS_fnc_LogDebug;
			};

		    // Exits
		    if !(Alive _Unit) exitWith {};
			//format["Rotor Protection: Hit on %1",_Selection] spawn OKS_fnc_LogDebug;
			if (!((toLower _selection) in ["main_rotor_hit","tail_rotor_hit"])) exitWith {
				//format["Rotor Protection: Not Rotor - Exited",_Selection] spawn OKS_fnc_LogDebug;
			};		

		    // Variables
		    _Multiplier = 0.05;

		    // Added Damage
		    _OldDamage = _Unit getVariable ["NEKY_OldDamage",0];
		    _AddedDamage = _NewDamage - _OldDamage;

		    //if !(_AddedDamage < 0) exitWith { 0 };
		    // New Damage
		    _Damage = _OldDamage + (_AddedDamage * _Multiplier);
		    _Damage = if (_Damage > 1) then { 1 } else { _Damage };
			_Debug = missionNamespace getVariable ["GOL_RotorProtection_Debug",false];
			if(_Debug) then {
				format[
					"Rotor Protection Damage: Old: %3%% | Added: %1%% | Final: Damage %2%%",
					((_AddedDamage * _Multiplier) * 100),
					(_Damage * 100),
					(_OldDamage * 100)
				] spawn OKS_fnc_LogDebug;
			};
		    _Unit setVariable ["NEKY_OldDamage",_Damage];

		    _Damage
		}];
	};