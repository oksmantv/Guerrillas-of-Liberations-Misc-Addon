Params ["_Unit"];
	_Ammo = secondaryWeaponMagazine _Unit;
	Sleep 5;
	_Unit addItem "NVGoggles_OPFOR";
	_Unit assignItem "NVGoggles_OPFOR";
	_Unit removeMagazines (_Ammo select 0);
	//_Unit addMagazine _Ammo;

	if(secondaryWeapon _Unit == "rhs_weap_igla") then {
		_Unit removeWeapon secondaryWeapon _Unit;
		_Unit addMagazines ["gol_mag_9k38_rocket",1];
		_Unit addWeapon "gol_weapon_igla";
	};