/*
	[_UnitOrGroup] call OKS_fnc_Stealth_EnemySentry_Yell;
*/

params ["_UnitOrGroup"];
private _yellers = switch (typeName _UnitOrGroup) do {
	case "OBJECT": { [_UnitOrGroup] };
	case "GROUP": { units _UnitOrGroup };
	default { [] };
};

_yellers = _yellers select {
	alive _x &&
	!(isPlayer _x || { _x in playableUnits } || { _x in switchableUnits })
};
if (_yellers isEqualTo []) exitWith { false };

// The old say3D implementation referenced yell_1..yell_9 CfgSounds classes,
// but those classes do not exist. SentryAlert uses the side-language sound-path
// registry and playSound3D, so every selected reaction is a real packaged file.
[selectRandom _yellers, true, true, true] call OKS_fnc_Stealth_SentryAlert;