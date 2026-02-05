Params["_Projectile","_Launcher"];
_Debug = 0;

_TargetPos = _Launcher getVariable ["OKS_Arty_Target",nil];
if(isNil "_TargetPos") exitWith {
	if(_Debug == 1) then {
		"[Arty] No Target Position found, deleting Projectile" spawn OKS_fnc_LogDebug;
	};
	deleteVehicle _Projectile;
};
WaitUntil {sleep 1; (_Projectile distance2D _Launcher > 1000 || _Projectile distance2D _TargetPos < 500)};
if(_Debug == 1) then {
	format["[Arty] Deleted Projectile - Away from Tube: %2 - Near Target: %3",_Projectile distance2D _Launcher,_Projectile distance2D _Launcher > 1000,_Projectile distance2D _TargetPos < 500] spawn OKS_fnc_LogDebug;
};
deleteVehicle _Projectile;