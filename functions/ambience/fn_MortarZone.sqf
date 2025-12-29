/*
	Mortar harassment zone tied to a trigger.

	Usage (scheduled):
		[thisTrigger, 4] spawn OKS_fnc_MortarZone;

	Params:
		0: Trigger <OBJECT>
		1: Delay per round (seconds) <NUMBER>

	Notes:
		- Server-only (prevents duplicate barrages in multiplayer)
		- Safe when trigger is empty (no targets)
		- Avoids landing within 30m of any player; capped rerolls
*/

params ["_trigger", "_delayPerRound"];

if (!isServer) exitWith {};
if (isNull _trigger) exitWith {};

if (_delayPerRound < 0.1) then { _delayPerRound = 0.1; };

private _minPlayerDistance = 30;
private _maxRerolls = 30;
private _offsetDistMin = 55;
private _offsetDistMax = 65;
private _spawnHeightMin = 125;
private _spawnHeightRange = 25;

waitUntil { sleep 0.5; isNull _trigger || { triggerActivated _trigger } };
if (isNull _trigger) exitWith {};

while { triggerActivated _trigger } do {
	private _allVehicles = [];
	{ _allVehicles pushBackUnique (vehicle _x) } forEach (list _trigger);

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
