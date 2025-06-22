/*
	OKS_Garrison_Rooftops

	Example:
	[5,getPos player] spawn OKS_fnc_Garrison_Rooftops;

	[6,getPos _X] execVM "fn_Garrison_Rooftops.sqf";

	Do note this code only puts the units on the highest building positions available. It could may not have rooftop positions.
	If units are below 1.5 meters they will be deleted automatically.
*/

if(HasInterface && !isServer) exitWith {};

Params [
	"_NumberInfantry",
	"_Position",
	["_Side",east,[sideUnknown]],
	["_UnitArray",[],[[],""]],
	["_Range",20,[0]]
];

Private ["_Settings","_GarrisonPositions","_GarrisonMaxSize","_GarrisonMaxSize","_Unit"];
if(_UnitArray isEqualTo []) then {
	_Settings = [_Side] call OKS_fnc_Dynamic_Settings;
};
_Settings Params ["_UnitArray"];
_UnitArray Params ["_Leaders","_Units","_Officer"];
Private _Debug_Variable = true;
systemChat str _UnitArray;
_Group = CreateGroup _Side;
_Group setVariable ["lambs_danger_disableGroupAI", true];

for "_i" from 1 to _NumberInfantry do
{
	Private "_Unit";
	if ( (count (units _Group)) == 0 ) then
	{
		_Unit = _Group CreateUnit [(_Leaders call BIS_FNC_selectRandom), _Position, [], 0, "NONE"];
		_Unit setRank "SERGEANT";
	} else {
		_RandomPosition = _Position getPos [(random 8),(random 360)];
		_Unit = _Group CreateUnit [(_Units call BIS_FNC_selectRandom), _RandomPosition, [], 0, "NONE"];
		_Unit setRank "PRIVATE";
	};
	if(_Debug_Variable) then {SystemChat format ["%1 Pos %2",group _unit,getPos _Unit]};
	_Unit disableAI "PATH";
	if(_Side isNotEqualTo civilian) then {
		_Unit setUnitPos (selectRandom ["UP","MIDDLE"]);
	};

	sleep 0.2;
};
/* Arguments:
	* 0: The building(s) nearest this position are used <POSITION>
	* 1: Limit the building search to those type of building <ARRAY>
	* 2: Units that will be garrisoned <ARRAY>
	* 3: Radius to fill building(s) <SCALAR> (default: 50)
	* 4: 0: even filling, 1: building by building, 2: random filling <SCALAR> (default: 0)
	* 5: True to fill building(s) from top to bottom <BOOL> (default: false) (note: only works with filling mode 0 and 1)
	* 6: Teleport units <BOOL> (default: false)
*/

_Houses = _Position nearObjects ["House",_Range];
{_X setVariable ["OKS_isGarrisoned",true]} foreach _Houses;
if(_Debug_Variable) then {
	SystemChat format ["Compound at %1 Units: %2 Range: %3",_Position,count units _Group,_Range];
};

waitUntil {sleep 5; !(isNil "ace_ai_fnc_garrison") && !(isNil "OKS_fnc_EnablePath")};
[_Position, nil, units _Group, (_Range - 10), 0, true, true] remoteExec  ["ace_ai_fnc_garrison",0];
sleep 2;
[_Group] remoteExec ["OKS_fnc_SetStatic",0];
_Group setVariable ["GOL_IsStatic",true,true];
{
	[_x] remoteExec ["GW_SetDifficulty_fnc_setSkill",0]
} foreach units _Group;

private _loops = 0;
waitUntil {sleep 1; _loops = _loops + 1; {(getPosATL _X select 2) > 1} count units _Group > 1 || _loops > 20};
sleep 5;
{
	private _IsEnclosedWithNoVisibility = (([_X] call OKS_fnc_Has_Sight) isEqualTo false);
	private _AtBottomFloor = ((getPosATL _X select 2) < 1.5);
	if(_IsEnclosedWithNoVisibility || _AtBottomFloor) then {
		deleteVehicle _X;
		if(_Debug_Variable) then {
			SystemChat format ["Deleted %1 at height %2",typeOf _X,(getPosATL _X select 2)];
		};
	};
	sleep 0.1;
} foreach units _Group;
