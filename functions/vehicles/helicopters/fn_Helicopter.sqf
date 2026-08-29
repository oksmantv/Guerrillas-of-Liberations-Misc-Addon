/*
	[this,false,false,true,["RHS_weap_gau19","rhsusf_mag_gau19_melb_right"],4] spawn OKS_Fnc_Helicopter;
*/

if(!isServer) exitWith {};

Params
[
	["_Helicopter", ObjNull, [ObjNull]],
	["_ShouldDisableThermal", (missionNamespace getVariable ["GOL_Helicopter_TI",false]), [true]],
	["_shouldDisableNVG", (missionNamespace getVariable ["GOL_Helicopter_NVG",false]), [true]],
	["_ShouldReplaceDoorguns", (missionNamespace getVariable ["GOL_Helicopter_DoorgunReplace",true]), [true]],
	["_DoorgunClasses",["RHS_weap_gau19","rhsusf_mag_gau19_melb_right"],[[]]],
	["_DoorgunAmmo",4,[0]]
];

_Helicopter enableSimulationGlobal false;
_Helicopter allowDamage false;
_Helicopter setFuelConsumptionCoef 1.5;
sleep 1;
[_Helicopter,_ShouldDisableThermal,_shouldDisableNVG] spawn OKS_fnc_Helicopter_Code;
[_Helicopter,_ShouldReplaceDoorguns,_DoorgunClasses,_DoorgunAmmo] spawn OKS_fnc_DAP_Config;
[_Helicopter] remoteExec ["OKS_fnc_HeliActions",0];
[_Helicopter] remoteExec ["OKS_fnc_Interact_Apply",0];
[_Helicopter] spawn OKS_fnc_Helicopter_Protection;
[_Helicopter] call OKS_fnc_AircraftFlareSupportInit;

// Restore any pylon loadout saved from a previous life of this vehicle (same
// magazine class/position, always at full ammo). If nothing has been saved
// yet - this is the vehicle's first-ever spawn - capture its current
// (editor/config-default) pylon loadout as the baseline instead, so there is
// something to restore to on the next respawn.
private _varName = vehicleVarName _Helicopter;
private _SavedPylons = GOL_Heli_PylonLoadouts getOrDefault [_varName, []];
if (_SavedPylons isEqualTo []) then {
	GOL_Heli_PylonLoadouts set [_varName, getPylonMagazines _Helicopter];
} else {
	{
		if (_x != "") then {
			_Helicopter setPylonLoadout [_forEachIndex + 1, _x, true];
		};
	} forEach _SavedPylons;
};
[_Helicopter] remoteExec ["OKS_fnc_Helicopter_PylonEH",0];

_Helicopter enableSimulationGlobal true;
sleep 5;
_Helicopter allowDamage true;