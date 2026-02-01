/*
	File: ATGM.sqf
	Author: Phantom hawk

	Description:
	Adds 2 Titan AT missiles and 4 Titan AA missiles to any vehicle that uses this script.

	Parameter(s):
	None

	Returns:
	Nothing
*/

if (local _this) then
{
	_this removeMagazineTurret ["200Rnd_127x99_mag_Tracer_Yellow",[0]];
	_this removeMagazineTurret ["200Rnd_127x99_mag_Tracer_Yellow",[0]];
    _this addWeaponTurret ["missiles_titan",[0]]; 
	_this addMagazineTurret ["200Rnd_127x99_mag_Tracer_Red",[0]]; 
	_this addMagazineTurret ["200Rnd_127x99_mag_Tracer_Red",[0]];
	_this addMagazineTurret ["2Rnd_GAT_missiles",[0]]; 
    _this addWeaponTurret ["missiles_titan_static",[0]]; 
	_this addMagazineTurret ["1Rnd_GAA_missiles",[0]]; 
	_this addMagazineTurret ["1Rnd_GAA_missiles",[0]]; 
};