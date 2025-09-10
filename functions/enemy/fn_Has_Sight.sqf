/*
    File: fn_Has_Sight.sqf
    Usage: [unit] call OKS_fnc_Has_Sight;

    Returns: true if unit is exposed to outside (not fully enclosed), false otherwise
*/

params [
    "_unit",
    ["_AddDebug",false,[false]]
];

private _clearCount = 0;
private _maxDistance = 10;
private _angleStep = 15;

private _origin = getPosASL _unit;
_origin set [2, (_origin select 2) + 0.8];

private _nearestBuilding = nearestBuilding _unit;
if(!isNil "_nearestBuilding") then {
    _Size = sizeOf (typeOf _nearestBuilding);
    _Positions = ([_nearestBuilding] call BIS_fnc_buildingPositions);
    if(!isNil "_Positions") then {
        _NearestPosition = ([_Positions, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy) select 0;
        if(!isNil "_NearestPosition") then {
            if(_NearestPosition distance _unit < 10) then {
                _maxDistance = (_Size * 0.6);
            };
        };
    };
};

for "_i" from 0 to 360 step _angleStep do {
    _NewPosition = _origin getPos [_maxDistance,_i];
    private _targetPos = [
        (_NewPosition select 0),
        (_NewPosition select 1),
        0
    ];
    _targetPos = AGLToASL _targetPos;
    _targetPos set [2, (_origin select 2)];

    private _hitData = lineIntersectsSurfaces [
        _origin,
        AGLToASL _targetPos,
        _unit,
        objNull,
        true,
        1,
        "FIRE",
        "NONE"
    ];

    if (_hitData isEqualTo []) then {
        _clearCount = _clearCount + 1;
        if(_AddDebug) then {
            _Arrow = "Sign_Arrow_Direction_Green_F" createVehicle _targetPos;
            _Arrow setPosASL _targetPos;
            _Arrow setDir (_origin getDir _targetPos);
        };           
    } else {
        if(_AddDebug) then {
            _Arrow = "Sign_Arrow_Direction_F" createVehicle _targetPos;
            _Arrow setPosASL _targetPos;
            _Arrow setDir (_origin getDir _targetPos);
        };     
    };
};

// Final evaluation
private _isExposed = _clearCount >= 5;
_isExposed
