/*
	[this,true,["RHS_weap_gau19","rhsusf_mag_gau19_melb_right"],4] spawn OKS_fnc_DAP_Config;
*/

Params [
	["_Vehicle",objNull,[objNull]],
	["_ShouldChangeDoorGuns",true,[false]],
	["_WeaponMagazineTurret",["RHS_weap_gau19","rhsusf_mag_gau19_melb_right"],[[]]], // Example: ["RHS_weap_gau19","rhsusf_mag_gau19_melb_right"],
	["_MagazinesPerTurret",4,[0]]
];
_WeaponMagazineTurret params ["_Weapon","_Magazine"];

// How to use (in init of vehicle):
// _null = [this,false] spawn OKS_fnc_DAP_Config;

/*if (TypeOf _Vehicle  == "CUP_B_UH1Y_Gunship_Dynamic_USMC" || TypeOf _Vehicle == "CUP_O_UH1H_gunship_TKA" || TypeOf _Vehicle == "CUP_B_MH47E_USA" || TypeOf _Vehicle == "CUP_B_UH1D_armed_GER_KSK" || typeOf _Vehicle == "CUP_B_UH1D_slick_GER_KSK" ||
typeOf _Vehicle == "CUP_B_UH1D_slick_GER_KSK_Des" || typeOf _Vehicle == "CUP_B_UH1D_gunship_GER_KSK_Des" || typeOf _Vehicle == "CUP_B_UH1D_gunship_GER_KSK" || typeOf _Vehicle == "CUP_B_UH1D_GER_KSK_Des" || typeOf _Vehicle == "CUP_B_UH1D_armed_GER_KSK_Des" || typeOf _Vehicle == "CUP_B_UH1D_GER_KSK") then
*/

_AIR_MagazineForeach = {
	Params ["_Vehicle","_Magazine","_Index","_MagazinesPerTurret"];

	for "_i" from 1 to _MagazinesPerTurret do {
		_vehicle addMagazineTurret [_Magazine,[_Index]];
	};
};

if (_vehicle isKindOf "Helicopter") then {
	if(_ShouldChangeDoorGuns) then {		
		if (["UH1",TypeOf _Vehicle] call BIS_fnc_inString ||
			["MH47",TypeOf _Vehicle] call BIS_fnc_inString ||
			["CH47", TypeOf _Vehicle] call BIS_fnc_inString) then
		{
			_vehicle removeWeaponTurret ["LMG_Minigun_Transport",[1]];
			_vehicle removeWeaponTurret ["LMG_Minigun_Transport2",[2]];			
			_vehicle removeWeaponTurret ["rhs_weap_m134_minigun_1",[1]];
			_vehicle removeWeaponTurret ["rhs_weap_m134_minigun_2",[2]];				

			//// Add Weapon
			if (Count (_vehicle weaponsTurret [0]) < 1) then {
				_vehicle addWeaponTurret [_Weapon,[0]];
				[_Vehicle, _Magazine, 0, _MagazinesPerTurret] spawn _AIR_MagazineForeach;
			};

			if (Count (_vehicle weaponsTurret [1]) < 1) then {
				_vehicle addWeaponTurret [_Weapon,[1]];
				[_Vehicle, _Magazine, 1, _MagazinesPerTurret] spawn _AIR_MagazineForeach;
			};

			_Vehicle setVariable ["OKS_DoorGunMagazineClass",_Magazine,true];
			_Vehicle setVariable ["OKS_DoorGunIndexes",[1,2],true];
			_Vehicle setVariable ["OKS_DoorgunMagazineCount",_MagazinesPerTurret,true];
			_Vehicle setVariable ["ace_rearm_scriptedLoadout", true, true];
		};
		if (["UH60",TypeOf _Vehicle] call BIS_fnc_inString ||
			["MH60",TypeOf _Vehicle] call BIS_fnc_inString ||
			["RHS_UH1Y",TypeOf _Vehicle] call BIS_fnc_inString ||
			["RHS_CH_47",TypeOf _Vehicle] call BIS_fnc_inString ||
			["Bell412",TypeOf _Vehicle] call BIS_fnc_inString || 
			["Heli_Transport_01",TypeOf _Vehicle] call BIS_fnc_inString ||
			["B_Heli_Transport_03_F",TypeOf _Vehicle] call BIS_fnc_inString) then
		{
			_vehicle removeWeaponTurret ["LMG_Minigun_Transport",[1]];
			_vehicle removeWeaponTurret ["LMG_Minigun_Transport2",[2]];
			_vehicle removeWeaponTurret ["rhs_weap_m134_minigun_1",[1]];
			_vehicle removeWeaponTurret ["rhs_weap_m134_minigun_2",[2]];
			_vehicle removeWeaponTurret ["UK3CB_M134_LSV_L",[1]];
			_vehicle removeWeaponTurret ["UK3CB_M134_LSV_R",[2]];							

			//// Add Weapon
			if (Count (_vehicle weaponsTurret [1]) < 1) then {
				_vehicle addWeaponTurret [_Weapon,[1]];
				[_Vehicle, _Magazine, 1, _MagazinesPerTurret] spawn _AIR_MagazineForeach;
			};

			if (Count (_vehicle weaponsTurret [2]) < 1) then {
				_vehicle addWeaponTurret [_Weapon,[2]];
				[_Vehicle, _Magazine, 2, _MagazinesPerTurret] spawn _AIR_MagazineForeach;				
			};

			_Vehicle setVariable ["OKS_DoorGunMagazineClass",_Magazine,true];
			_Vehicle setVariable ["OKS_DoorGunIndexes",[1,2],true];
			_Vehicle setVariable ["OKS_DoorgunMagazineCount",_MagazinesPerTurret,true];
			_Vehicle setVariable ["ace_rearm_scriptedLoadout", true, true];
		};
	};
};	
