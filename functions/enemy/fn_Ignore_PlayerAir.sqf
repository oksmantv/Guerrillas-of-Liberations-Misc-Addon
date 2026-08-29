/*
	Enemy AI Ignore Player Air Targets

	Param 1: Group - The group to apply the ignore air target behavior to
	Param 2: Value - true/false, whether to ignore player air targets or not (default true)
	Param 3: PollingTime - How often to check for new player air targets (default 10 seconds)

*/

params [
	["_group", grpNull, [grpNull]],
	["_value", true, [false]]
];

private _disabled = "disabled";
private _enabled = "enabled";
private _dynamic = "dynamic";
private _ignoreAirSetup = ["GOL_Enemy_IgnorePlayerAir"] call CBA_settings_fnc_get;
		_ignoreAirSetup params ["_ignoreValue", "_ignoreDisplayName"];
private _ignoreAirMaxRange = ["GOL_Enemy_IgnorePlayerAir_MaxRange"] call CBA_settings_fnc_get;
private _pollingTime = ["GOL_Enemy_IgnorePlayerAir_PollTime"] call CBA_settings_fnc_get;
private _playerSide = missionNameSpace getVariable ["GOL_Friendly_Side", (side group player)];


if (_ignoreValue isEqualTo _disabled) exitWith {
	"[Ignore Player Air Targets] Disabled via CBA Settings, exiting script." spawn OKS_fnc_LogDebug;
};

if (side _group == _playerSide) exitWith {
	"[Ignore Player Air Targets] Group is friendly, exiting script." spawn OKS_fnc_LogDebug;
};

if (side _group getFriend _playerSide > 0.6) exitWith {
	"[Ignore Player Air Targets] Group is friendly, exiting script." spawn OKS_fnc_LogDebug;
};

while {
		{ alive _x } count units _group > 0
		&& { _ignoreValue isEqualTo _enabled || _ignoreValue isEqualTo _dynamic }
	} do {
		private _playerAircraft = (allPlayers - entities "HeadlessClient_F") select {
		alive _x && { vehicle _x isKindOf "Air" }
	};

	diag_log format ["[Ignore Player Air Targets] Group %1 checking for player air targets. Found %2 player aircraft. Polling Time: %3", name _group, count _playerAircraft, _pollingTime];
	if (_ignoreValue == _enabled) then {
		// Dynamic Air Targeting Disabled
		{
			if (_value) then {
				_group ignoreTarget [_x, true];
				diag_log format ["[Ignore Player Air Targets] Group %1 ignoring player air target %2", name _group, name _x];
			} else {
				_group ignoreTarget [_x, false];
				diag_log format ["[Ignore Player Air Targets] Group %1 no longer ignoring player air target %2", name _group, name _x];
			};
		} forEach _playerAircraft;
	};

	if (_ignoreValue == _dynamic) then {
		// Dynamic Air Targeting Enabled - Max Range in effect.
		private _playerAircraftInRange = _playerAircraft select { (leader _group distance2d _x) < _ignoreAirMaxRange };
		{
			if (_value) then {
				_group ignoreTarget [_x, true];
				diag_log format ["[Ignore Player Air Targets] Group %1 ignoring player air target %2", name _group, name _x];
			} else {
				_group ignoreTarget [_x, false];
				diag_log format ["[Ignore Player Air Targets] Group %1 no longer ignoring player air target %2", name _group, name _x];
			};
		} forEach _playerAircraftInRange;
	};

	sleep _pollingTime;
};





