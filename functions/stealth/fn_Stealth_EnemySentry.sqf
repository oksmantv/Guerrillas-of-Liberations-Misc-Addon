/*
	[Unit/Position/Group, Side, ChanceForRadioGear, RequiresRadioToCallHunt, ShouldStartHunt, RangeFromUnitFindHunters, HuntersRange, VariableToSetToTrue] spawn OKS_fnc_Stealth_EnemySentry;
*/

if (!isServer) exitWith {};

params [
	["_Unit", objNull, [objNull, [], grpNull]],
	["_Side", east, [sideUnknown]],
	["_ChanceForRadioEquipment", 0.35, [0]],
	["_RequiresRadioToCallHunt", true, [true]],
	["_ShouldSetNearbyToHunt", true, [true]],
	["_NearbyHunterRange", 500, [0]],
	["_HuntRange", 500, [0]],
	["_Variable", nil, [""]]
];

private _unitArray = [_Unit, _Side, _ChanceForRadioEquipment, _RequiresRadioToCallHunt] call OKS_fnc_Stealth_EnemySentry_CreateUnit;

{
	[_X, _NearbyHunterRange, _RequiresRadioToCallHunt, _ShouldSetNearbyToHunt, _Side, _HuntRange] spawn {
		params ["_Unit", "_NearbyHunterRange", "_RequiresRadioToCallHunt", "_ShouldSetNearbyToHunt", "_Side", "_HuntRange"];

		[_Unit] call OKS_fnc_Stealth_EnemySentry_SetupUnit;
		waitUntil {
			sleep 0.1;
			{
				_Unit knowsAbout _X > 2 &&
				isPlayer _X &&
				!((vehicle _X) isKindOf "AIR") &&
				!((_X getVariable ["GOL_SelectedRole", [""]] select 0) in ["p", "jetp"])
			} count (_Unit targets [true]) > 0 || !alive _Unit
		};

		if (alive _Unit || [_Unit] call ace_common_fnc_isAwake) then {
			[_Unit] call OKS_fnc_Stealth_EnemySentry_Yell;
			sleep 3;
		};
		if (alive _Unit || [_Unit] call ace_common_fnc_isAwake) then {
			private _radioData = [_Unit] call OKS_fnc_Stealth_FindNearRadioMen;
			_radioData params ["_radioNearby", "_nearFriendliesWithRadio"];
			if (_ShouldSetNearbyToHunt && _radioNearby) then {
				[_nearFriendliesWithRadio, _Unit, _HuntRange, _NearbyHunterRange] call OKS_fnc_Stealth_FindNearestRadioAndCallForHelp;
			};
		};
	};
} forEach _unitArray;