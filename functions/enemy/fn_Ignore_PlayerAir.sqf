/*
	Enemy AI Ignore Player Air Targets

	Registers (or un-registers) a group with the shared manager loop
	(see OKS_fnc_Ignore_PlayerAir_Manager). No per-group loop is spawned.

	Param 1: Group - The group to apply the ignore air target behavior to
	Param 2: Value - true/false, whether to ignore player air targets or not (default true)

	Example Usage: [_this, true] call OKS_fnc_Ignore_PlayerAir;
*/

params [
	["_group", grpNull, [grpNull]],
	["_value", true, [false]]
];
if (isNull _group) exitWith { _value };

if (!_value) exitWith {
	_group setVariable ["GOL_IgnorePlayerAir_Active", false, true];
	isNil {
		missionNamespace setVariable [
			"GOL_IgnorePlayerAir_Registry",
			(missionNamespace getVariable ["GOL_IgnorePlayerAir_Registry", []]) - [_group]
		];
		nil
	};
	private _playerAircraft = (allPlayers - entities "HeadlessClient_F") select {
		alive _x && { vehicle _x isKindOf "Air" }
	};
	{
		_group ignoreTarget [vehicle _x, false];
	} forEach _playerAircraft;
	"[Ignore Player Air Targets] Value is false, un-ignoring all. Exiting script." spawn OKS_fnc_LogDebug;
	_value
};
if (_group getVariable ["GOL_IgnorePlayerAir_Active", false]) exitWith {
	"[Ignore Player Air Targets] Group is already registered, exiting script." spawn OKS_fnc_LogDebug;
	_value
};

private _ignoreValue = ["GOL_Enemy_IgnorePlayerAir"] call CBA_settings_fnc_get;
if (_ignoreValue isEqualType []) then { _ignoreValue = _ignoreValue param [0, "disabled"]; };
private _playerSide = missionNameSpace getVariable ["GOL_Friendly_Side", (side group player)];

if (_ignoreValue isEqualTo "disabled") exitWith {
	"[Ignore Player Air Targets] Disabled via CBA Settings, exiting script." spawn OKS_fnc_LogDebug;
	_value
};
if (side _group == _playerSide || { side _group getFriend _playerSide > 0.6 }) exitWith {
	"[Ignore Player Air Targets] Group is friendly, exiting script." spawn OKS_fnc_LogDebug;
	_value
};

_group setVariable ["GOL_IgnorePlayerAir_Active", true, true];

// Atomic so concurrent callers cannot double-start the manager.
isNil {
	private _registry = missionNamespace getVariable ["GOL_IgnorePlayerAir_Registry", []];
	_registry pushBackUnique _group;
	missionNamespace setVariable ["GOL_IgnorePlayerAir_Registry", _registry];

	private _handle = missionNamespace getVariable ["GOL_IgnorePlayerAir_ManagerHandle", scriptNull];
	if (isNull _handle || { scriptDone _handle }) then {
		missionNamespace setVariable ["GOL_IgnorePlayerAir_ManagerHandle", [] spawn OKS_fnc_Ignore_PlayerAir_Manager];
	};
	nil
};

format ["[Ignore Player Air Targets] Registered Group %1 (mode: %2)", _group, _ignoreValue] spawn OKS_fnc_LogDebug;

_value
