/*
	[this,false,false,true,["RHS_weap_gau19","rhsusf_mag_gau19_melb_right"],4] spawn OKS_Fnc_Helicopter;
*/

if(!isServer) exitWith {};

Params
[
	["_Vehicle", ObjNull, [ObjNull]],
	["_ShouldDisableThermal", true, [true]],
	["_shouldDisableNVG", false, [true]],
	["_ShouldReplaceDoorguns", true, [true]],
	["_DoorgunClasses",["RHS_weap_gau19","rhsusf_mag_gau19_melb_right"],[[]]],
	["_DoorgunAmmo",4,[0]]
];

_Vehicle enableSimulationGlobal false;
_Vehicle hideObjectGlobal true;
_Vehicle allowDamage false;
_Vehicle setFuelConsumptionCoef 1.5;
sleep 5;
[_Vehicle,_ShouldDisableThermal,_shouldDisableNVG] spawn OKS_fnc_Helicopter_Code;
[_Vehicle,_ShouldReplaceDoorguns,_DoorgunClasses,_DoorgunAmmo] spawn OKS_Fnc_DAP_Config;
[_Vehicle] remoteExec ["OKS_fnc_HeliActions",0];

_Vehicle enableSimulationGlobal true;
_Vehicle hideObjectGlobal false;
_Vehicle allowDamage true;