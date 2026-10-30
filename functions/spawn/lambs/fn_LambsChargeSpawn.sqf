/*
	Lambs charge/rush wave spawner.

	Usage (scheduled):
		[spawnObjectOrPos, unitsPerWave, amountOfWaves, side, range, variableName] spawn OKS_fnc_LambsChargeSpawn;

	Params:
		0: Spawn origin <OBJECT|ARRAY>
		1: Units per wave <NUMBER>
		2: Amount of waves <NUMBER>
		3: Side <SIDE> (default: east)
		4: Range for LAMBS rush tracking <NUMBER> (default: 1500)
		5: MissionNamespace variable set TRUE when all spawned units are dead/unconscious <STRING>

	Notes:
		- Server-only (prevents duplicate spawning in MP)
		- References warcry sound from addon: \OKS_GOL_Misc\Sounds\ChargeWarcry.ogg
*/

if (!isServer) exitWith {};

params [
	"_spawnOrigin",
	"_unitsPerWave",
	"_amountOfWaves",
	["_side", east, [sideUnknown]],
	["_range", 1500, [0]],
	["_variableName", "Rush_WaveSpawn_Variable", [""]]
];

private _oks_multiplier = missionNamespace getVariable ["GOL_SpawnMultiplier", 100];
private _oks_blacklisted = missionNamespace getVariable ["GOL_SpawnMultiplier_Blacklist_LambsChargeSpawn", false];
private _oks_applyMultiplier = (_oks_multiplier < 100) && {!_oks_blacklisted};
if (_oks_applyMultiplier) then {
	_unitsPerWave = (ceil (_unitsPerWave * _oks_multiplier / 100)) max 2;
};

if (_unitsPerWave <= 0 || { _amountOfWaves <= 0 }) exitWith {};

private _allSpawnedUnits = [];

private _leaders = [];
private _units = [];

switch (_side) do {
	case BLUFOR: {
		_leaders = ["B_Soldier_SL_F", "B_Soldier_TL_F"];
		_units = [
			"B_Soldier_LAT_F",
			"B_Soldier_AR_F",
			"B_Soldier_AR_F",
			"B_medic_F",
			"B_medic_F",
			"B_Soldier_GL_F",
			"B_HeavyGunner_F"
		];
	};
	case OPFOR: {
		_leaders = ["O_Soldier_SL_F", "O_Soldier_TL_F"];
		_units = [
			"O_Soldier_LAT_F",
			"O_Soldier_AR_F",
			"O_Soldier_AR_F",
			"O_medic_F",
			"O_medic_F",
			"O_Soldier_GL_F",
			"O_HeavyGunner_F"
		];
	};
	case INDEPENDENT: {
		_leaders = ["I_Soldier_SL_F", "I_Soldier_TL_F"];
		_units = [
			"I_Soldier_LAT_F",
			"I_Soldier_AR_F",
			"I_Soldier_AR_F",
			"I_medic_F",
			"I_medic_F",
			"I_Soldier_GL_F"
		];
	};
	default {
		_leaders = ["O_Soldier_SL_F", "O_Soldier_TL_F"];
		_units = [
			"O_Soldier_LAT_F",
			"O_Soldier_AR_F",
			"O_Soldier_AR_F",
			"O_medic_F",
			"O_medic_F",
			"O_Soldier_GL_F",
			"O_HeavyGunner_F"
		];
	};
};

private _fnc_getBasePos = {
	params ["_origin"];
	if (_origin isEqualType objNull) exitWith { getPosATL _origin };
	if (_origin isEqualType []) exitWith { _origin };
	[0, 0, 0]
};

private _fnc_relPos = {
	params ["_origin", "_dist", "_dir"];
	if (_origin isEqualType objNull) exitWith { _origin getPos [_dist, _dir] };
	private _base = [_origin] call _fnc_getBasePos;
	[_base, _dist, _dir] call BIS_fnc_relPos
};

private _waveSpawnCode = {
	params ["_spawnOrigin", "_side", "_unitsPerWave", "_leaders", "_units", "_allSpawnedUnits", "_range", "_fnc_relPos"];

	private _group = createGroup _side;
	_group setVariable ["acex_headless_blacklist", true, true];

	for "_i" from 1 to _unitsPerWave do {
		private _spawnPos = [_spawnOrigin, 5 + (random 5), random 360] call _fnc_relPos;
		private _unitClass = "";

		if ((count (units _group)) == 0) then {
			_unitClass = selectRandom _leaders;
		} else {
			if ((count (units _group)) == 1 && { (count _units) > 0 }) then {
				_unitClass = _units select 0;
			} else {
				_unitClass = selectRandom _units;
			};
		};

		private _unit = _group createUnit [_unitClass, _spawnPos, [], 0, "NONE"];
		if ((count (units _group)) == 1) then {
			_unit setRank "SERGEANT";
		} else {
			_unit setRank "PRIVATE";
		};

		sleep 1;
	};

	{
		[_x] remoteExec ["GW_SetDifficulty_fnc_setSkill", 0];
		_x allowFleeing 0;
		_x disableAI "FSM";
		_x enableAttack false;
		_allSpawnedUnits pushBackUnique _x;
	} forEach (units _group);

	if (!isNil "OKS_Suppression" && { OKS_Suppression isEqualTo 1 }) then {
		{ [_x] remoteExec ["OKS_Suppressed", 0] } forEach (units _group);
	};

	sleep 5;
	waitUntil { sleep 1; !isNil "lambs_wp_fnc_taskRush" };
	[_group, _range, 5, [], [], true] remoteExec ["lambs_wp_fnc_taskRush", 0];
};

for "_i" from 1 to _amountOfWaves do {
	[_spawnOrigin, _side, _unitsPerWave, _leaders, _units, _allSpawnedUnits, _range, _fnc_relPos] spawn _waveSpawnCode;
	sleep 2;
};

// Warcry, roughly matching original behavior
sleep 15;
private _soundPath = "\OKS_GOL_Misc\Sounds\ChargeWarcry.ogg";
private _soundPos = [_spawnOrigin] call _fnc_getBasePos;
playSound3D [_soundPath, objNull, false, ASLToAGL _soundPos, 5, 1, _range];

// Mark variable false while active, then true when cleared
missionNamespace setVariable [_variableName, false, true];

waitUntil {
	sleep 1;
	({ alive _x || { [_x] call ace_common_fnc_isAwake } } count _allSpawnedUnits) < 1
};

missionNamespace setVariable [_variableName, true, true];
