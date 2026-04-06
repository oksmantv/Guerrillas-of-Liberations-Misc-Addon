/*
	GOL FIR AWS Integration Init
	Hooks GOL aircraft into FIR Air Weapon System.
	Called from vehicle Init EventHandler.

	[_aircraft, _afterburner, _ecm, _ew] call OKS_fnc_JetAWSInit;
*/

params [
	["_plane", objNull, [objNull]],
	["_ab", false, [false]],
	["_ecm", false, [false]],
	["_ew", false, [false]]
];

if (isNull _plane) exitWith {};
if (isNil "fir_fnc_aws_enablefunction") exitWith {};

// ECM + EW via FIR AWS EnableFunction
if(_ecm || _ew) then {
	[_plane, false, _ecm, false, _ew] call fir_fnc_aws_enablefunction;
};

// Afterburner via FIR AWS Afterburner2
if (_ab) then {
	_plane setVariable ["AWS_AB", "off", true];
	_plane setVariable ["AWS_ABSound", "no", true];

	if (isServer) then {
		[[_plane, [
			"Afterburner On",
			"\FIR_AirWeaponSystem_US\Script\function\AWS_Afterburner2.sqf",
			[], 1, false, true, "User1",
			"player in _target and speed _target > 50 and _target getVariable ['AWS_AB','off'] == 'off' and airplaneThrottle _target == 1 and isEngineOn _target"
		]], "addAction", true, true] call BIS_fnc_MP;

		[[_plane, [
			"Afterburner Off",
			{(_this select 0) setVariable ["AWS_AB", "off"]},
			[], 1, false, true, "User1",
			"_target getVariable ['AWS_AB','off'] == 'on'"
		]], "addAction", true, true] call BIS_fnc_MP;
	};
};
