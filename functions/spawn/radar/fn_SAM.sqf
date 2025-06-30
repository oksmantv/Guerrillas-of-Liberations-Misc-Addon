/*
	[SAMLAUNCHER;RADAR,RATEOFFIRE,AMMO,RELOADRATE] spawn OKS_fnc_SAM;
	[this,radar_1,20,4,30] spawn OKS_fnc_SAM;
	Put this in the the missions init.sqf after 10 second delay
*/
Params [
	"_SAM",
	"_Radar",
	["_RateOfFire",20,[0]],
	["_Ammo",4,[0]],
	["_ReloadRate",20,[0]],
	["_MinimumAltitude",100,[0]],
	["_MaxRange",3000,[0]]
];

// Setup GOL SAM Weapon.
{
	_SAM removeMagazine _x
} forEach (magazines _SAM);
_SAM removeWeapon (currentWeapon _SAM);
_SAM addMagazine "gol_magazine_Missile_s750_x4";
_SAM addWeapon "gol_weapon_s750Launcher";

sleep 2;

_SAM setVariable ["SAM_Name",_SAM];
_SAM setVariable ["SAM_ROF",_RateOfFire];
_SAM setVariable ["SAM_Ammo_Full",_Ammo];
_SAM setVariable ["SAM_Ammo",_Ammo];
_SAM setVariable ["SAM_RR",_ReloadRate];
_SAM addEventHandler ["Fired",{ [_this select 0] spawn OKS_fnc_SAM_FIRED; }];

while {alive _SAM} do {
	_NearbyTargets = (_Radar targets [true, _MaxRange]) select {_X isKindOf "AIR" && getPos _X select 2 >= _MinimumAltitude};
	if(count _NearbyTargets > 0) then {
		if(!(_SAM getVariable ["isReloading",false])) then {
			_SAM setVehicleReceiveRemoteTargets true;
		};
	} else {
		_SAM setVehicleReceiveRemoteTargets false;
	};

	sleep 5;
};