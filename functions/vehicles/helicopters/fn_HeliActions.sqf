/*
	[_helicopter] call OKS_fnc_HeliActions;
*/
params ["_Helicopter"];

_Helicopter = _this select 0;

_class = str(typeOf _Helicopter);

_Helicopter addAction [
	"M230: Switch to <t color='#FF6666'>AP</t>",
	{ _this call OKS_fnc_M230_SwapAmmo },
	["GOL_PylonWeapon_M230_AP", "GOL_PylonWeapon_M230_HE"],
	6, false, true, "",
	"driver _target == player && currentWeapon _target == 'GOL_weapon_M230_ChainGun' && 'GOL_PylonWeapon_M230_HE' in (getPylonMagazines _target) && (_target getVariable ['GOL_M230_AP_Ammo', 250]) > 0"
];
_Helicopter addAction [
	"M230: Switch to <t color='#66FF66'>HE</t>",
	{ _this call OKS_fnc_M230_SwapAmmo },
	["GOL_PylonWeapon_M230_HE", "GOL_PylonWeapon_M230_AP"],
	6, false, true, "",
	"driver _target == player && currentWeapon _target == 'GOL_weapon_M230_ChainGun' && 'GOL_PylonWeapon_M230_AP' in (getPylonMagazines _target) && (_target getVariable ['GOL_M230_HE_Ammo', 250]) > 0"
];

if (_class find "UH60" != -1) then {
	_Helicopter addAction ["Open Right Cargo Door",{_target = _this select 0; _target animateDoor ['doorRB',1]; _target animate ['doorHandler_R',1]},nil,1.5,true,true,"","(_target getRelDir _this > 35) && _target getRelDir _this < 120 && _target doorPhase 'DoorRB' == 0 && _target distance _this < 6 && !(_this in _target)"];
	_Helicopter addAction ["Close Right Cargo Door",{_target = _this select 0; _target animateDoor ['doorRB',0]; _target animate ['doorHandler_R',0]},nil,1.5,true,true,"","_target getRelDir _this > 35 && _target getRelDir _this < 120 && _target doorPhase 'DoorRB' == 1 && _target distance _this < 6 && !(_this in _target)"];
	_Helicopter addAction ["Open Left Cargo Door",{_target = _this select 0; _target animateDoor ['doorLB',1]; _target animate ['doorHandler_L',1]},nil,1.5,true,true,"","_target getRelDir _this < 320 && _target getRelDir _this > 240 && _target doorPhase 'DoorLB' == 0 && _target distance _this < 6 && !(_this in _target)"];
	_Helicopter addAction ["Close Left Cargo Door",{_target = _this select 0; _target animateDoor ['doorLB',0]; _target animate ['doorHandler_L',0]},nil,1.5,true,true,"","_target getRelDir _this < 320 && _target getRelDir _this > 240 && _target doorPhase 'DoorLB' == 1 && _target distance _this < 6 && !(_this in _target)"];
};

if (_class find "UH1" != -1) then {
	_Helicopter addAction ["Open Right Cargo Door",{_target = _this select 0; _target animateDoor ['doorRB',1]; _target animate ['doorHandler_R',1]},nil,1.5,true,true,"","(_target getRelDir _this > 25) && _target getRelDir _this < 150 && _target doorPhase 'DoorRB' == 0 && _target distance _this < 8 && !(_this in _target)"];
	_Helicopter addAction ["Close Right Cargo Door",{_target = _this select 0; _target animateDoor ['doorRB',0]; _target animate ['doorHandler_R',0]},nil,1.5,true,true,"","_target getRelDir _this > 25 && _target getRelDir _this < 150 && _target doorPhase 'DoorRB' == 1 && _target distance _this < 8 && !(_this in _target)"];
	_Helicopter addAction ["Open Left Cargo Door",{_target = _this select 0; _target animateDoor ['doorLB',1]; _target animate ['doorHandler_L',1]},nil,1.5,true,true,"","_target getRelDir _this < 340 && _target getRelDir _this > 240 && _target doorPhase 'DoorLB' == 0 && _target distance _this < 8 && !(_this in _target)"];
	_Helicopter addAction ["Close Left Cargo Door",{_target = _this select 0; _target animateDoor ['doorLB',0]; _target animate ['doorHandler_L',0]},nil,1.5,true,true,"","_target getRelDir _this < 340 && _target getRelDir _this > 240 && _target doorPhase 'DoorLB' == 1 && _target distance _this < 8 && !(_this in _target)"];
};

if (_class find "Mi24" != -1) then {
	_Helicopter addAction ["Open cargo doors",{_target = _this select 0; _target animateDoor ['Door_Cargo',1]},nil,1.5,true,true,"","!(_target getRelDir _this < 35 && _target getRelDir _this > 340) && !(_target getRelDir _this > 90 && _target getRelDir _this < 270) && _target doorPhase 'Door_Cargo' == 0 && _target distance _this < 7.8 && !(_this in _target)"];
	_Helicopter addAction ["Close cargo doors",{_target = _this select 0; _target animateDoor ['Door_Cargo',0]},nil,1.5,true,true,"","!(_target getRelDir _this < 35 && _target getRelDir _this > 340) && !(_target getRelDir _this > 90 && _target getRelDir _this < 270) && _target doorPhase 'Door_Cargo' == 1 && _target distance _this < 7.8 && !(_this in _target)"];
};

if (_class find "Mi8" != -1) then {
	_Helicopter addAction ["Open Left Cargo Door",{_target = _this select 0; _target animateDoor ['LeftDoor',1]; _target animate ['doorHandler_R',1]},nil,1.5,true,true,"","(_target getRelDir _this > 300) && _target getRelDir _this < 340 && _target doorPhase 'LeftDoor' == 0 && _target distance _this < 8 && _target distance _this > 4.5 && !(_this in _target)"];
	_Helicopter addAction ["Close Left Cargo Door",{_target = _this select 0; _target animateDoor ['LeftDoor',0]; _target animate ['doorHandler_R',0]},nil,1.5,true,true,"","_target getRelDir _this > 300 && _target getRelDir _this < 340 && _target doorPhase 'LeftDoor' == 1 && _target distance _this < 8 && _target distance _this > 4.5 && !(_this in _target)"];
	_Helicopter addAction ["Open Rear Cargo Doors",{_target = _this select 0; [_target,14,15] call rhs_fnc_mi8_checkDoor},nil,1.5,true,true,"","_target getRelDir _this < 200 && _target getRelDir _this > 160 && _target doorPhase 'RearDoors' == 0 && _target distance _this < 8 && !(_this in _target)"];
	_Helicopter addAction ["Close Rear Cargo Doors",{_target = _this select 0; [_target,14,15] call rhs_fnc_mi8_checkDoor},nil,1.5,true,true,"","_target getRelDir _this < 200 && _target getRelDir _this > 160 && _target doorPhase 'RearDoors' == 1 && _target distance _this < 8 && !(_this in _target)"];
};