/*
	[_Group] call OKS_fnc_Stealth_EnemySentry_IgnoreAir;
*/

params ["_Group"];

waitUntil { sleep 1; { alive _X || [_X] call ace_common_fnc_isAwake } count units _Group > 0 };

_Group setVariable ["lambs_danger_disableGroupAI", true, true];
while {{ alive _X || [_X] call ace_common_fnc_isAwake } count units _Group > 0} do {
	private _PlayersInAir = allPlayers select {
		(vehicle _X) isKindOf "AIR" &&
		((_X getVariable ["GOL_SelectedRole", [""]] select 0) in ["p", "jetp"])
	};

	{
		private _Player = _X;
		{
			(_X targetKnowledge _Player) params [
				"_knownByGroup",
				"_knownByUnit",
				"_lastSeen",
				"_lastThreat",
				"_side",
				"_errorMargin",
				"_position",
				"_Ignored"
			];
			if (_Ignored && ({ behaviour _X == "COMBAT" } count units _Group > 0 || (vehicle _Player) distance _X < 300)) then {
				_X ignoreTarget [(vehicle _X), false];
			} else {
				_X ignoreTarget (vehicle _X);
			};
		} forEach units _Group;
	} forEach _PlayersInAir;

	sleep 10;
};