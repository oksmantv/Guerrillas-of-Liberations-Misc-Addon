/*
	Helper: Check if a position is blocked by terrain or objects within a given range
	
	Params:
	1. posATL (array)
	2. range (number)

	Returns: true if blocked, false otherwise
*/
params ["_posATL", ["_range", 7, [0]]];

private _terr = nearestTerrainObjects [_posATL, ["TREE","BUSH","ROCK","WALL","HOUSE","BUILDING"], _range, false, true];
private _objs = nearestObjects [_posATL, ["House","Wall","Building","Car","Tank","StaticWeapon","Thing"], _range];

(count _terr + count _objs) > 0