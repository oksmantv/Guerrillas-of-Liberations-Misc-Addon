/*
	OKS_fnc_ScudIntercept_PickTargetPos

	Resolves a target position for missile launches.

	Usage:
	- [_trigger] call OKS_fnc_ScudIntercept_PickTargetPos;
	- [_trigger, 60, true] call OKS_fnc_ScudIntercept_PickTargetPos;

	If given an EmptyDetector trigger, it:
	- collects players inside the trigger area
	- filters to "ground" (not in Air)
	- finds the largest cluster (connected components) using _clusterRadius meters
	- returns the center (average) position of that cluster (ATL)

	If no eligible players are found inside a trigger, returns nil.
	(Non-trigger objects still return their position.)
*/

params [
	["_areaObject", objNull, [objNull]],
	["_clusterRadius", 60, [0]],
	["_requireGround", true, [true]]
];

if (isNull _areaObject) exitWith { [] };

private _fallbackPosATL = getPosATL _areaObject;

// If this isn't a trigger, just use its position.
if !((typeOf _areaObject) isEqualTo "EmptyDetector") exitWith {
	_fallbackPosATL
};

private _candidates = allPlayers select {
	alive _x &&
	{isPlayer _x} &&
	{_x inArea _areaObject}
};

if (_requireGround) then {
	_candidates = _candidates select {
		private _veh = vehicle _x;
		!(_veh isKindOf "Air")
	};
};

// Important: if a trigger was provided and no players match, return nil.
// The caller can then decide to abort or use an explicit fallback.
if (_candidates isEqualTo []) exitWith { nil };

// Build largest connected component where edges exist when distance <= _clusterRadius (2D)
private _unassigned = +_candidates;
private _bestCluster = [];

while { !(_unassigned isEqualTo []) } do {
	private _seed = _unassigned deleteAt 0;
	private _cluster = [_seed];
	private _queue = [_seed];

	while { !(_queue isEqualTo []) } do {
		private _current = _queue deleteAt 0;
		private _currentPos = getPosATL _current;

		// Find any remaining players close enough to join the cluster
		private _toAdd = [];
		{
			private _pos = getPosATL _x;
			if ((_currentPos distance2D _pos) <= _clusterRadius) then {
				_toAdd pushBack _x;
			};
		} forEach _unassigned;

		{
			_unassigned = _unassigned - [_x];
			_cluster pushBack _x;
			_queue pushBack _x;
		} forEach _toAdd;
	};

	if ((count _cluster) > (count _bestCluster)) then {
		_bestCluster = _cluster;
	} else {
		// Tie-breaker: randomly pick between same-size clusters
		if ((count _cluster) == (count _bestCluster) && {(count _cluster) > 0}) then {
			if (random 1 > 0.5) then {
				_bestCluster = _cluster;
			};
		};
	};
};

if (_bestCluster isEqualTo []) exitWith { nil };

private _sumX = 0;
private _sumY = 0;
private _count = count _bestCluster;

{
	private _p = getPosATL _x;
	_sumX = _sumX + (_p select 0);
	_sumY = _sumY + (_p select 1);
} forEach _bestCluster;

[
	_sumX / _count,
	_sumY / _count,
	0
]
