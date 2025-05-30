// [_this,"lot"] execVM "Training\Medical\MedicalDamage.sqf";

params ["_Unit", "_Severe"];
Private ["_SelectedSeverity","_lot","_large","_fatal","_dead"];

_NoOfWounds = (round ((random [0.1, 0.25, 0.4])* 5));
_BodyPart = selectRandom ["RightLeg", "LeftLeg", "Body", "RightArm", "LeftArm"];
_Severe = toLower _Severe;
_SelectedSeverity = _Severe;

_some = 5.6;
_lot = 5.1;
_large = 4.2;
_fatal = 3.6;
_dead = selectRandom [_some,_lot,_large,_fatal];

switch (_SelectedSeverity) do {

	case "lot": {
		_Unit setUnitPos "DOWN";
		_unit setVariable ["ace_medical_bloodVolume", _lot, true];
		[_unit, true] call ace_medical_fnc_setUnconscious;

		for "_j" from 0 to 3 do {
			[_Unit, selectRandom [0.1,0.2,0.3], selectRandom ["LeftLeg", "RightLeg"], selectRandom ["avulsion", "stab"]] remoteExec ["ace_medical_fnc_addDamageToUnit", 2];
			[_Unit, selectRandom [0.1,0.2,0.3], selectRandom ["LeftArm", "RightArm"], selectRandom ["avulsion", "stab"]] remoteExec ["ace_medical_fnc_addDamageToUnit", 2];
			sleep 0.1;
		};
		[_Unit, 0.2, "Body", selectRandom ["avulsion", "stab"]] remoteExec ["ace_medical_fnc_addDamageToUnit", 2];
		[_Unit, 0.05, "Head", selectRandom ["avulsion"]] remoteExec ["ace_medical_fnc_addDamageToUnit", 2];
	};

	case "large": {
		_unit setVariable ["ace_medical_bloodVolume", _large, true];
		_Unit setUnitPos "DOWN";
		[_unit, true] call ace_medical_fnc_setUnconscious;

		for "_j" from 0 to 3 do {
			[_Unit, selectRandom [0.1,0.2,0.3], selectRandom ["LeftLeg", "RightLeg"], selectRandom ["avulsion", "stab"]] remoteExec ["ace_medical_fnc_addDamageToUnit", 2];
			[_Unit, selectRandom [0.1,0.2,0.3], selectRandom ["LeftArm", "RightArm"], selectRandom ["avulsion", "stab"]] remoteExec ["ace_medical_fnc_addDamageToUnit", 2];
			sleep 0.1;
		};
		[_Unit, 0.4, "Body", selectRandom ["avulsion", "stab"]] remoteExec ["ace_medical_fnc_addDamageToUnit", 2];
		[_Unit, 0.05, "Head", selectRandom ["avulsion"]] remoteExec ["ace_medical_fnc_addDamageToUnit", 2];
	};

	case "fatal": {
		_Unit setUnitPos "DOWN";
		[_unit, true] call ace_medical_fnc_setUnconscious;
		_unit setVariable ["ace_medical_bloodVolume", _fatal, true];
		for "_j" from 0 to 3 do {
			[_Unit, selectRandom [0.1,0.2,0.3], selectRandom ["LeftLeg", "RightLeg"], selectRandom ["avulsion", "stab"]] remoteExec ["ace_medical_fnc_addDamageToUnit", 2];
			[_Unit, selectRandom [0.1,0.2,0.3], selectRandom ["LeftArm", "RightArm"], selectRandom ["avulsion", "stab"]] remoteExec ["ace_medical_fnc_addDamageToUnit", 2];
			sleep 0.1;
		};
		[_Unit, 0.4, "Body", selectRandom ["avulsion", "stab"]] remoteExec ["ace_medical_fnc_addDamageToUnit", 2];
		//[_Unit, 0.2, "Head", selectRandom ["avulsion", "stab"]] remoteExec ["ace_medical_fnc_addDamageToUnit", 2];
	};
};
if (_SelectedSeverity isEqualTo "dead") then {
	_Unit hideObjectGlobal false;
	_Unit setDamage 1;
};
