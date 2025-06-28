/*
    OKS_fnc_EdenAirBase
    _this: [position, ...] from Eden context menu
*/

params ["_Position"];

// Helper to get next available name with prefix
private _baseName = ["AirBase"] call OKS_fnc_next3DENName;
private _spawnName = ["AirSpawn"] call OKS_fnc_next3DENName;
private _triggerName = ["AirHuntTrigger"] call OKS_fnc_next3DENName;
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
_trigger set3DENAttribute ["size3", [5000,5000,0]];
_trigger set3DENAttribute ["IsRectangle", false]; 
_trigger set3DENAttribute ["ActivationBy", "ANYPLAYER"]; 
_trigger set3DENAttribute ["repeatable", true];

private _spawnPos = _basePos getPos [25, _dirToCam];
_spawnPos set [2, 0];
private _spawn = create3DENEntity ["Object", "Land_HelipadCivil_F", _spawnPos];
_spawn set3DENAttribute ["name", _spawnName];
_spawn set3DENAttribute ["rotation", [0,0,_dirToCam]];
_spawn set3DENAttribute ["hideObject", true];

private _selected = get3DENSelected "object";
private _helicopterClass = "O_Heli_Light_02_unarmed_F";
private _side = "EAST";

{
    private _type = typeOf _x;
    _side = side _x;
    if (_x isKindOf "air") then {
        _helicopterClass = _type;
    };
} forEach _selected;

private _example = format [
    "[%1, %2, %3, %4, %5, 'Unload', [2,1], 900, 100, 90, 5] spawn OKS_fnc_Airbase;",
    _baseName, _spawnName, _triggerName, _side, _helicopterClass
];

copyToClipboard _example;
systemChat format["CopiedToClipboard: %1",_example];
delete3DENEntities _selected;


