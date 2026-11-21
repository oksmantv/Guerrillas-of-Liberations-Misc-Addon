//	[[Players], Zone, Distance, NearestRef] Spawn OKS_fnc_SelectPlayer;
//
//	This selects a player and scans for a suitable AI spawn position.
//	NearestRef (optional position): when non-empty, the player nearest to it is selected instead of a random one.
//
//	Returns: [Number of Players too close, Position to spawn at, Selected player]
//
//	Made by NeKo-ArroW

Private ["_Count","_Pos"];
Params ["_Players","_Zone","_Distance",["_NearestRef",[],[[]]]];



_Player = if (_NearestRef isEqualTo []) then {
	selectRandom _Players
} else {
	private _Dists = _Players apply {_x distance2D _NearestRef};
	_Players select (_Dists find (selectMin _Dists))
};
For "_i" from 1 to 15 step 1 do
{
	_Pos = _Player getPos [_Distance,random 360];
	if (SurfaceIsWater _Pos) then
	{
		_Count = 1;
	} else {
		_Count = {_x distance _Pos < _Distance} count AllPlayers;
	};
	If (_Count == 0) exitWith {};
	Sleep 0.1;
};
[_Count, _Pos, _Player];