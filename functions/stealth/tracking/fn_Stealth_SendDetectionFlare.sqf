/*
	[_Group] call OKS_fnc_Stealth_SendDetectionFlare;
*/

params [
	["_Group", grpNull, [grpNull]]
];

if (!isServer) exitWith { false };
if (isNull _Group) exitWith { false };
if ({ alive _X || [_X] call ace_common_fnc_isAwake } count (units _Group) == 0) exitWith {
	false
};

private _position = getPosATL (leader _Group);
private _temp = createVehicle ["F_20mm_Red", [(_position select 0), (_position select 1), ((_position select 2) + 140)], [], 20, "CAN_COLLIDE"];
_temp setVelocity [0, 0, -10];
sleep 3;
playSound3D ["A3\Sounds_F\weapons\Flare_Gun\flaregun_2_shoot.wss", (leader _Group), false, [(_position select 0), (_position select 1), (_position select 2)], 8, 1, 300];
true