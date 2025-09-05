Params ["_Helicopter"];
if(!isServer) exitWith {};

_Helicopter RemoveAllEventHandlers "HandleDamage";
_Helicopter setVariable ["NEKY_OldDamage",0];

private _isWhiteList = {
	Params ["_Helicopter"];
	Private "_return";
	_WhiteListWords = ["mi24","mi8","Mi_24","Mi_8"];
	{
		if (((ToLower typeOf _Helicopter) find _X) == -1) then {
			_return = false;
		} else {
			_return = true;
			break;
		};
	} foreach _WhiteListWords;
	_return;
};	
	
// Created by Neko-Arrow - Thanks very much
if([_Helicopter] call _isWhiteList) then {
	_Debug = missionNamespace getVariable ["GOL_RotorProtection_Debug",false];
	private _HelicopterClass = typeof _Helicopter;
	private _displayName = getText (configFile >> "CfgVehicles" >> _HelicopterClass >> "displayName");
	if(_Debug) then {
		format["Enabled Rotor protection on %1 - %2",_Helicopter,_displayName] spawn OKS_fnc_LogDebug;
	};
	_Helicopter addEventHandler ["HandleDamage",
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