//	[Zone] Spawn OKS_fnc_ScanZone;
//
//	This scans the zone for players to stalk.
//
//	Returns: [Players]
//
//	Made by NeKo-ArroW

Private ["_Players"];
Params ["_Zone"];

_Players = [];
While {(Count _Players) == 0} do
{
	_Players = (List _Zone) select {(isPlayer (Vehicle _x)) && (Alive _x) && (((getPosATL _x) select 2) < 6)};
	if ((Count _Players) == 0) then {Sleep 10};
};
_Players;