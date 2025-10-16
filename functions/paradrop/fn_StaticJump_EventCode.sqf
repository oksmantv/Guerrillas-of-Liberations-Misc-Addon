/*
	[_aircraft,_player, _ejected] spawn OKS_fnc_StaticJump_Code;
*/

params ["_vehicle", "_role", "_unit", "_turret", "_isEject"];

_Debug = missionNamespace getVariable ["GOL_Paradrop_Debug",false];

if((_player getVariable ["GOL_StaticJump", false]) || !(_player getVariable ["GOL_Hooked", false])) exitWith {
	if(_Debug) then {
		"[StaticLine] GetOut Event Exited. Already Ejected or not hooked." spawn OKS_fnc_LogDebug;
	};
};

if(_Debug) then {
	"[StaticLine] GetOut Event Triggered." spawn OKS_fnc_LogDebug;
};
if(_isEject && _role == "cargo" && (getPosATL _vehicle) select 2 > 100 && _unit getVariable ["GOL_Hooked",false]) then {
	_Debug = missionNamespace getVariable ["GOL_Paradrop_Debug",false];
	if(_Debug) then {
		"[StaticLine] Eject Event Triggered." spawn OKS_fnc_LogDebug;
	};                
	[_vehicle, _unit, true] spawn OKS_fnc_StaticJump_Code; 
};

if(_isEject && _role == "cargo" && (getPosATL _vehicle) select 2 > 100 && !(_unit getVariable ["GOL_Hooked",false])) then {
	_Debug = missionNamespace getVariable ["GOL_Paradrop_Debug",false];
	if(_Debug) then {
		"[StaticLine] Eject Event Triggered without Static Line." spawn OKS_fnc_LogDebug;
	};
	[_vehicle, _unit, true] spawn OKS_fnc_StaticJump_Code;    
};