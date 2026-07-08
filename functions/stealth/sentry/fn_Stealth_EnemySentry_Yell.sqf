/*
	[_UnitOrGroup] call OKS_fnc_Stealth_EnemySentry_Yell;
*/

params ["_UnitOrGroup"];
private ["_Yeller", "_Unit"];

switch (typeName _UnitOrGroup) do {
	case "OBJECT": { _Yeller = [_UnitOrGroup]; };
	case "GROUP": { _Yeller = units _UnitOrGroup; };
	default { systemChat format ["What the fuck am I going to do with a %1 value in _UNITorGROUP?", typeName _UnitOrGroup] };
};

_Unit = selectRandom _Yeller;
if (alive _Unit && [_Unit] call ace_common_fnc_isAwake) then {
	private _SoundFileName = selectRandom ["yell_1", "yell_2", "yell_3", "yell_4", "yell_5", "yell_6", "yell_7", "yell_8", "yell_9"];
	[_Unit, _SoundFileName] remoteExec ["say3D", 0];
	_Unit setBehaviour "COMBAT";
	_Unit setCombatMode "RED";
};