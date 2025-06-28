/*
    OKS_fnc_EdenHuntBase
*/

params ["_Position"];

private _baseName = ["HuntBase"] call OKS_fnc_next3DENName;
private _spawnName = ["HuntSpawn"] call OKS_fnc_next3DENName;
private _triggerName = ["HuntTrigger"] call OKS_fnc_next3DENName;
private _dirToCam = [_Position, position get3DENCamera] call BIS_fnc_dirTo;

private _basePos =+ _Position;
_basePos set [2, 0];
private _base = create3DENEntity ["Object", "Land_Cargo_HQ_V2_F", _basePos];
_base set3DENAttribute ["name", _baseName];
_base set3DENAttribute ["rotation", [0,0,_dirToCam]];

private _triggerPos = _basePos getPos [15, _dirToCam];
_triggerPos set [2, 0];
private _trigger = create3DENEntity ["Trigger", "EmptyDetector", _triggerPos];
_trigger set3DENAttribute ["name", _triggerName];
_trigger set3DENAttribute ["size3", [3000,3000,0]];
_trigger set3DENAttribute ["IsRectangle", false];        
_trigger set3DENAttribute ["ActivationBy", "ANYPLAYER"]; 
_trigger set3DENAttribute ["repeatable", true];

private _spawnPos = _basePos getPos [25, _dirToCam];
_spawnPos set [2, 0];
private _spawn = create3DENEntity ["Object", "Land_Matches_F", _spawnPos];
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
    _example = format [
        "[%1, %2, %3, 5, 900, %4, %5, 120] spawn OKS_fnc_HuntBase;",
        _baseName, _spawnName, _triggerName, _side, str _vehicleClasses
    ]
} else {
    _example = format [
        "[%1, %2, %3, 5, 900, %4, %5, 120] spawn OKS_fnc_HuntBase;",
        _baseName, _spawnName, _triggerName, _side, _unitCount
    ]
};
copyToClipboard _example;
systemChat format["CopiedToClipboard: %1",_example];
delete3DENEntities _selected;


