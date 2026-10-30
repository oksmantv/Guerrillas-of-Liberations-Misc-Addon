/*
    Produces evenly spaced, dry-land search positions around an alert source.

    Usage:
    _positions = [_centerPosition, _radius, _cellSize] call OKS_fnc_Stealth_Alert_SearchGrid;
*/

params [
    ["_centerPosition", [0, 0, 0], [[]], [2, 3]],
    ["_radius", 250, [0]],
    ["_cellSize", 60, [0]]
];

private _center = +_centerPosition;
if (count _center == 2) then {
    _center pushBack 0;
};

_radius = _radius max 0;
_cellSize = _cellSize max 10;

private _positions = [];
for "_offsetX" from (-_radius) to _radius step _cellSize do {
    for "_offsetY" from (-_radius) to _radius step _cellSize do {
        if ((_offsetX * _offsetX) + (_offsetY * _offsetY) <= (_radius * _radius)) then {
            private _candidate = [
                (_center select 0) + _offsetX,
                (_center select 1) + _offsetY,
                0
            ];

            if !(surfaceIsWater _candidate) then {
                _positions pushBack _candidate;
            };
        };
    };
};

_positions