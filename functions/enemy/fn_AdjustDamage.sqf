// [this] call OKS_fnc_AdjustDamage;
OKS_ReduceDamage_Data = "";

Params
[
	["_Vehicle", ObjNull, [ObjNull]]
];

if(hasInterface && !isServer) exitWith {};

Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
if(isNull _Vehicle) exitWith {
    if(_Debug) then {
        format ["AdjustDamage Script, Vehicle was null. Exiting.."] spawn OKS_fnc_LogDebug;
    };
};

if(_Debug) then {
	format["Adjust Damage enabled on %1", [configFile >> "CfgVehicles" >> typeOf _Vehicle] call BIS_fnc_displayName] spawn OKS_fnc_LogDebug;
};

_Vehicle addEventHandler ["HandleDamage",
	{
		params ["_unit", "_selection", "_newDamage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit"];
		private ["_selectedMultiplier","_hitpointName"];
		Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
		//SystemChat str [_Selection,_hitIndex,_hitPoint,_directHit];
		//copyToClipboard str [_Selection,_hitIndex,_hitPoint,_directHit];

		// Exits
		if !(Alive _Unit) exitWith {};
		if ( 
			!((ToLower _hitPoint) in ["hithull","hitturret","hitgun","hitengine","hitfuel","hitltrack","hitrtrack","hitcomgun","hitcomturret"])
		) exitWith {};

		// Variables
		private _Multiplier = 1;
		if(["T34", typeOf _unit] call BIS_fnc_inString && ["UK3CB", typeOf _unit] call BIS_fnc_inString) then {
			_Multiplier = 6;
			_unit setVehicleArmor 0.1;

			if(_Debug) then {
				format["Adjust Damage - %1 Identified - %2 - Changed Damage: %3 | Armor: %4.",[configFile >> "CfgVehicles" >> typeOf _Vehicle] call BIS_fnc_displayName,_Vehicle,_Multiplier,"10%"] spawn OKS_fnc_LogDebug;
			};
		};
		if(["T55", typeOf _unit] call BIS_fnc_inString && ["UK3CB", typeOf _unit] call BIS_fnc_inString) then {
			_Multiplier = 6;
			_unit setVehicleArmor 0.15;

			if(_Debug) then {
				format["Adjust Damage - %1 Identified - %2 - Changed Damage: %3 | Armor: %4.",[configFile >> "CfgVehicles" >> typeOf _Vehicle] call BIS_fnc_displayName,_Vehicle,_Multiplier,"15%"] spawn OKS_fnc_LogDebug;
			};				
		};
		if(["T72", typeOf _unit] call BIS_fnc_inString && ["UK3CB", typeOf _unit] call BIS_fnc_inString) then {
			_Multiplier = 3;
			_unit setVehicleArmor 0.25;

			if(_Debug) then {
				format["Adjust Damage - %1 Identified - %2 - Changed Damage: %3 | Armor: %4.",[configFile >> "CfgVehicles" >> typeOf _Vehicle] call BIS_fnc_displayName,_Vehicle,_Multiplier,"25%"] spawn OKS_fnc_LogDebug;
			};
		};
		if(["T80", typeOf _unit] call BIS_fnc_inString && ["UK3CB", typeOf _unit] call BIS_fnc_inString) then {
			_Multiplier = 3;
			_unit setVehicleArmor 0.3;

			if(_Debug) then {
				format["Adjust Damage - %1 Identified - %2 - Changed Damage: %3 | Armor: %4.",[configFile >> "CfgVehicles" >> typeOf _Vehicle] call BIS_fnc_displayName,_Vehicle,_Multiplier,"30%"] spawn OKS_fnc_LogDebug;
			};
		};		
			
		// Added Damage
		_newDamage = if (_newDamage > 1) then { 1 } else { _newDamage };
		_oldDamage = _Unit getVariable [format["NEKY_oldDamage_%1",_hitPoint],0];
		_AddedDamage = _newDamage - _oldDamage;

		//if !(_AddedDamage < 0) exitWith { 0 };
		// New Damage
		_Damage = _oldDamage + (_AddedDamage * _Multiplier);
		_Damage = if (_Damage > 1) then { 1 } else { _Damage };

		if(ToLower _hitpoint == "hithull") then {
			if(_Debug) then {
				format ["AdjustDamage - Old: %3 | Added: %1 | Final: Damage %2",(_AddedDamage * _Multiplier),_Damage,_oldDamage] spawn OKS_fnc_LogDebug;
			};
		};		
		_Unit setVariable [format["NEKY_oldDamage_%1",_hitPoint],_Damage];

		_Damage
	}
];