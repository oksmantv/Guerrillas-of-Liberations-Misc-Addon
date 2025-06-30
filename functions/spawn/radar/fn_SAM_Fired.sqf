params["_Object"];

_SAM = _Object getVariable "SAM_Name";
_RateOfFire = _Object getVariable "SAM_ROF";
_Ammo = _Object getVariable "SAM_Ammo";
_AmmoFull = _Object getVariable "SAM_Ammo_Full";
_ReloadRate = _Object getVariable "SAM_RR";

format["[SAM] FIRED - Prior Ammo: %1",_Ammo] spawn OKS_fnc_LogDebug;
_SAM setVariable ["isReloading",true,true];
_SAM setVehicleReceiveRemoteTargets false;
_Ammo = _Ammo - 1;

_SAM setVariable ["SAM_Ammo",_Ammo];
Format ["[SAM] Ammo after launch: %1",_Ammo] spawn OKS_fnc_LogDebug;

sleep (_RateOfFire + (Random _RateOfFire));

"[SAM] Reload Complete" spawn OKS_fnc_LogDebug;
_SAM setVariable ["isReloading",false,true];
_SAM setVehicleReceiveRemoteTargets true;

if (_Ammo < 1) then
{
	_SAM setVehicleReceiveRemoteTargets false;

	sleep _ReloadRate; _SAM setVehicleAmmo 0.25;
	sleep _ReloadRate; _SAM setVehicleAmmo 0.50;
	sleep _ReloadRate; _SAM setVehicleAmmo 0.75;
	sleep _ReloadRate; _SAM setVehicleAmmo 1;

	_SAM setVariable ["SAM_Ammo",_AmmoFull];
	_SAM setVehicleReceiveRemoteTargets true;
};