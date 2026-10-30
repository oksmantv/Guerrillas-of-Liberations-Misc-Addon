/*
    Plays the alert siren locally at an ASL position.
    Called on every client by OKS_fnc_Stealth_Alert because playSound3D is local.
*/

params [
    ["_positionASL", [0, 0, 0], [[]], [2, 3]]
];

private _soundPosition = +_positionASL;
if (count _soundPosition == 2) then {
    _soundPosition pushBack 0;
};

playSound3D [
    "\OKS_GOL_Misc\Sounds\siren.ogg",
    objNull,
    false,
    _soundPosition,
    5,
    1,
    500
];

true