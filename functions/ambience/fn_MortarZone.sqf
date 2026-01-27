/*
	Mortar harassment zone tied to a trigger.

	Usage (scheduled):
		[thisTrigger, 4] spawn OKS_fnc_MortarZone;
		[thisTrigger, 4, 30, 55, 65] spawn OKS_fnc_MortarZone;

	Params:
		0: Trigger <OBJECT>
		1: Delay per round (seconds) <NUMBER> (default: 4)
		2: Min player distance (meters) <NUMBER> (default: 30)
		3: Offset distance min (meters) <NUMBER> (default: 55)
		4: Offset distance max (meters) <NUMBER> (default: 65)

	Notes:
		- Server-only (prevents duplicate barrages in multiplayer)
		- Safe when trigger is empty (no targets)
		- Avoids landing within 30m of any player; capped rerolls
*/

params [
	"_trigger",
	["_delayPerRound", 4, [0]],
	["_minPlayerDistance", 30, [0]],
	["_offsetDistMin", 55, [0]],
	["_offsetDistMax", 65, [0]]
];

if (!isServer) exitWith {};
if (isNull _trigger) exitWith {};

if (_delayPerRound < 0.1) then { _delayPerRound = 0.1; };
if (_minPlayerDistance < 0) then { _minPlayerDistance = 0; };
if (_offsetDistMin < 0) then { _offsetDistMin = 0; };
if (_offsetDistMax < _offsetDistMin) then { _offsetDistMax = _offsetDistMin; };

private _maxRerolls = 30;
private _spawnHeightMin = 125;
private _spawnHeightRange = 25;

waitUntil { sleep 0.5; isNull _trigger || { triggerActivated _trigger } };
if (isNull _trigger) exitWith {};

while { triggerActivated _trigger } do {
	private _allVehicles = [];
	{
		private _veh = vehicle _x;
		if (!(_veh isKindOf "Air")) then {
			_allVehicles pushBackUnique _veh;
		};
	} forEach (list _trigger);

	if (_allVehicles isEqualTo []) then {
		sleep 1;
		continue;
	};

	private _target = selectRandom _allVehicles;
	if (isNull _target) then {
		sleep 1;
		continue;
	};

	private _strikePos = getPosATL _target;

	private _attempts = 0;
	while {
		({ _strikePos distance2D _x < _minPlayerDistance } count allPlayers) > 0
		&& { _attempts < _maxRerolls }
	} do {
		_attempts = _attempts + 1;

		private _randomDirectionRight = [30, 40] call BIS_fnc_randomInt;
		private _randomDirectionLeft = [320, 330] call BIS_fnc_randomInt;
		private _randomDirection = selectRandom [_randomDirectionRight, _randomDirectionLeft];
		private _randomDistance = [_offsetDistMin, _offsetDistMax] call BIS_fnc_randomInt;

		_strikePos = _target getPos [_randomDistance, _randomDirection];
	};

	if (({ _strikePos distance2D _x < _minPlayerDistance } count allPlayers) > 0) then {
		sleep _delayPerRound;
		continue;
	};

	private _spawnZ = _spawnHeightMin + (random _spawnHeightRange);
	private _round = "Sh_82mm_AMOS" createVehicle [_strikePos select 0, _strikePos select 1, _spawnZ];
	_round setVelocity [0, 0, -75];

	sleep _delayPerRound;
};
