Params [
	"_SpawnPosition",
	"_Units",
	"_Numbers",
	["_IsBaseOfFire",false,[false]],
	["_SpawnAngle",nil,[0]],
	["_SpawnDistance",0,[0]]
];
_Units Params ["_Leaders","_Units","_Officer"];
Private ["_Unit","_Group","_SelectedUnits","_SelectedSpawnPosition","_SpawnDistance"];

if(_IsBaseOfFire) then {
	_SelectedSpawnPosition = _SpawnPosition;
} else {
	_BaseDir = getDir _SpawnPosition;
	_SelectedSpawnPosition = _SpawnPosition getPos [_SpawnDistance, (_BaseDir + _SpawnAngle)];
};

_Group = CreateGroup _Side;
for "_i" from 1 to _Numbers do {					
	if ((count (units _Group)) == 0) then
	{
		_Unit = _Group CreateUnit [(_Leaders call BIS_FNC_selectRandom), _SelectedSpawnPosition, [], 5, "NONE"];
		_Unit setRank "SERGEANT";
	} else {

		if(_i % 2 == 0 && _IsBaseOfFire) then {
			_SelectedUnits = _Units select {					
				["heavygunner", _X] call BIS_fnc_inString || ["ar", _X] call BIS_fnc_inString  
			};
		} else {
			_SelectedUnits = _Units;
		};

		_Unit = _Group CreateUnit [(_SelectedUnits call BIS_FNC_selectRandom), _SelectedSpawnPosition, [], 5, "NONE"];
		_Unit setRank "PRIVATE";
	};
	_Unit setRank "PRIVATE";	
};

_Group
