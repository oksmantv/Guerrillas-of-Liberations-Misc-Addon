/*
    File: fn_Has_Sight.sqf
    Usage: [unit] call OKS_fnc_Has_Sight;

    Returns: true if unit is exposed to outside (not fully enclosed), false otherwise
*/

params ["_unit"];

private _origin = getPosATL _unit;
_origin set [2, (_origin select 2) + 1.5]; // Rifle height

private _clearCount = 0;
private _angleStep = 20;
private _maxDistance = 10;

for "_i" from 0 to 340 step _angleStep do {
    private _rad = _i * (pi / 180);
    private _dx = sin _rad;
    private _dy = cos _rad;

    private _targetPos = [
        (_origin select 0) + _dx * _maxDistance,
        (_origin select 1) + _dy * _maxDistance,
        _origin select 2
    ];

    // Optional: Visual debug
    // drawLine3D [_origin, _targetPos, [1,1,0,1]];

    private _hitData = lineIntersectsSurfaces [
        AGLToASL _origin,
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
    };
};

// Final evaluation
private _isExposed = _clearCount >= 3;

if (_isExposed) then {
    systemChat "Exposed: TRUE";
} else {
    systemChat "Exposed: FALSE";
};

_isExposed
