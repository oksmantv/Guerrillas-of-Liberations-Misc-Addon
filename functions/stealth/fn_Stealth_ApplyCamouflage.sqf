/*
	Function: OKS_fnc_Stealth_ApplyCamouflage
	
	Description:
		Applies the camouflage coefficient trait to a player unit based on CBA settings.
		Lower values make the player harder to detect by AI.
	
	Parameter(s):
		0: OBJECT - Player unit to apply camouflage to
	
	Returns:
		Nothing
	
	Example:
		[player] call OKS_fnc_Stealth_ApplyCamouflage;
*/

params [
	["_unit", objNull, [objNull]]
];

if (isNull _unit) exitWith {};
if (!isPlayer _unit) exitWith {};

private _camouflageCoef = missionNamespace getVariable ["GOL_OKS_Player_Camouflage", 0.3];
private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];

_unit setUnitTrait ["camouflageCoef", _camouflageCoef];

// Add respawn event handler to reapply on respawn
if (!(_unit getVariable ["OKS_Stealth_Camouflage_EH_Added", false])) then {
	_unit addEventHandler ["Respawn", {
		params ["_unit", "_corpse"];
		private _camouflageCoef = missionNamespace getVariable ["GOL_OKS_Player_Camouflage", 0.3];
		_unit setUnitTrait ["camouflageCoef", _camouflageCoef];
		
		private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];
		if (_debug) then {
			format ["[STEALTH] Reapplied camouflage coefficient %1 to player %2 after respawn", _camouflageCoef, name _unit] spawn OKS_fnc_LogDebug;
		};
	}];
	_unit setVariable ["OKS_Stealth_Camouflage_EH_Added", true];
};

if (_debug) then {
	format ["[STEALTH] Applied camouflage coefficient %1 to player %2", _camouflageCoef, name _unit] spawn OKS_fnc_LogDebug;
};
