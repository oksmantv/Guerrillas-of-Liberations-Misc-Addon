/*
	[_NearFriendliesWithRadio,_Unit,_HuntRange,_NearbyHunterRange] call OKS_fnc_Stealth_FindNearestRadioAndCallForHelp;
*/

params [
	["_NearFriendliesWithRadio", [], [[]]],
	["_Unit", objNull, [objNull]],
	["_HuntRange", 500, [0]],
	["_NearbyHunterRange", 500, [0]]
];

_NearFriendliesWithRadio = _NearFriendliesWithRadio select {
	!(isPlayer _x || { _x in playableUnits } || { _x in switchableUnits })
	&& { alive _x }
	&& { isNil "ace_common_fnc_isAwake" || { [_x] call ace_common_fnc_isAwake } }
};
if (_NearFriendliesWithRadio isEqualTo []) exitWith { false };

private _sortedNearFriendliesWithRadio = [_NearFriendliesWithRadio, [], { _x distance _Unit }, "ASCEND"] call BIS_fnc_sortBy;
private _nearestFriendlyWithRadio = selectRandom _sortedNearFriendliesWithRadio;

if (isNull _nearestFriendlyWithRadio) exitWith { false };

if (
	{ _X getVariable ["RadioCalled", false] } count _NearFriendliesWithRadio == 0 &&
	{ [_X] call ace_common_fnc_isAwake } count _NearFriendliesWithRadio > 0
) then {
	private _soundFileName = selectRandom ["radio_1", "radio_2", "radio_3", "radio_4", "radio_5"];
	_nearestFriendlyWithRadio say3D _soundFileName;
	_nearestFriendlyWithRadio setVariable ["RadioCalled", true, true];

	sleep 3;
	if (alive _nearestFriendlyWithRadio || [_nearestFriendlyWithRadio] call ace_common_fnc_isAwake) then {
		[group _Unit] call OKS_fnc_Stealth_SendDetectionFlare;
		sleep 15 + (random 15);
		[_Unit, _HuntRange, _NearbyHunterRange] call OKS_fnc_Stealth_InitiateHunterResponse;
	};
};

true