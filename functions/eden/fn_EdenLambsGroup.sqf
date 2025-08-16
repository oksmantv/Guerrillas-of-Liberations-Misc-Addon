/*
    OKS_fnc_EdenLambsGroup
*/

params ["_positionArray","_lambsType"];
_positionArray params ["_position"];

private _spawnName = ["LambsGroupSpawn"] call OKS_fnc_next3DENName;
_position set [2, 0];
private _spawn = create3DENEntity ["Object", "Land_Matches_F", _position];
_spawn set3DENAttribute ["name", _spawnName];
_spawn set3DENAttribute ["hideObject", true];

private _selected = get3DENSelected "object";
private _vehicleClasses = [];
private _unitCount = 0;
private _side = "EAST";

{
    private _type = typeOf _x;
    _side = side _x;
    if (_x isKindOf "Man") then {
        _unitCount = _unitCount + 1;
    } else {
        _vehicleClasses pushBack _type;
    };
} forEach _selected;

if(_unitCount == 0 && _vehicleClasses isEqualTo []) then {
    _unitCount = 6
};

private _example = "";
if (_vehicleClasses isNotEqualTo []) then {
    _vehicleArray = [_vehicleClasses, 6];
    _example = format [
        "[gtpos %1, %2, %3, %4, 500] spawn OKS_fnc_Lambs_SpawnGroup;",
        _spawnName, str _lambsType, _vehicleArray, _side
    ]
} else {
    _example = format [
        "[getpos %1, %2, %3, %4, 500] spawn OKS_fnc_Lambs_SpawnGroup;",
        _spawnName, str _lambsType, _unitCount, _side
    ]
};
copyToClipboard _example;
systemChat format["CopiedToClipboard: %1",_example];
delete3DENEntities _selected;


