	Params ["_Mortar","_Unit","_Position"];
	Private ["_Mag"];
	
	"[MORTAR] Firing.." spawn OKS_fnc_LogDebug;

	_Mortar = (_This select 0);
	_Unit = (_This select 1);
	_Position = (_This select 2);
	_Mag = currentMagazine _Mortar;
	
	_Unit doWatch [(_Position select 0),(_Position select 1),((_Position select 2) + 1000)];
	_Mortar addMagazine _Mag;

	// Use forceWeaponFire to bypass CARELESS behaviour blocking normal Fire command
	private _weapon = (_Mortar weaponsTurret [0]) select 0;
	private _fireMode = (getArray (configFile >> "CfgWeapons" >> _weapon >> "modes")) select 0;
	(gunner _Mortar) forceWeaponFire [_weapon, _fireMode];