// [_vehicle, _pylonIdx, _magazine, _ammo] call OKS_fnc_M230_SetPylon;
// Applies setPylonLoadOut with an explicit ammo count.
// Must execute where the vehicle is local — called via remoteExec from OKS_fnc_M230_SwapAmmo.

params ["_vehicle", "_pylonIdx", "_magazine", "_ammo"];
_vehicle setPylonLoadOut [_pylonIdx, _magazine, false];
_vehicle setAmmo ["GOL_weapon_M230_ChainGun", _ammo];
