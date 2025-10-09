/*
    Create an explosive and detonate it immediately to create an explosion effect at the given position.

    Example:
    [getPos bomb_1,"SatchelCharge_Remote_Ammo"] spawn OKS_fnc_CreateExplosion;
*/

Params [
    "_Position",
    ["_Type","SatchelCharge_Remote_Ammo",[""]]
];

_explosive = "SatchelCharge_Remote_Ammo" createVehicle _Position;
_explosive setVelocity [0,0,-1];
_explosive setDamage 1;

