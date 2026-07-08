/*
	[_Unit,_HuntRange,_NearbyHunterRange] call OKS_fnc_Stealth_InitiateHunterResponse;
*/

params [
	["_Unit", objNull, [objNull]],
	["_HuntRange", 500, [0]],
	["_NearbyHunterRange", 500, [0]]
];

if (!isServer) exitWith {};
if (isNull _Unit) exitWith {};

if (!isNil "lambs_wp_fnc_taskHunt") then {
	{
		[_X, _HuntRange] spawn OKS_fnc_Stealth_EnemySentry_Call_Hunters_Lambs;
		sleep (15 + (random 15));
	} forEach (allGroups select {
		{
			side _X == [_Unit] call GW_Common_Fnc_getSide &&
			_X distance2D _Unit < _NearbyHunterRange &&
			alive _X &&
			!isPlayer _X &&
			[_X] call ace_common_fnc_isAwake
		} count units _X >= 2 &&
		!(_X getVariable ["LAMBS_HUNTING", false]) &&
		!(_X getVariable ["GOL_IsStatic", false])
	});
} else {
	{
		[_X, _NearbyHunterRange, _Unit] spawn OKS_fnc_Stealth_EnemySentry_Call_Hunters;
		sleep (15 + (random 15));
	} forEach (allGroups select {
		{
			side _X == [_Unit] call GW_Common_Fnc_getSide &&
			_X distance2D _Unit < _NearbyHunterRange &&
			alive _X &&
			!isPlayer _X &&
			[_X] call ace_common_fnc_isAwake
		} count units _X >= 2 &&
		!(_X getVariable ["LAMBS_HUNTING", false]) &&
		!(_X getVariable ["GOL_IsStatic", false])
	});
};