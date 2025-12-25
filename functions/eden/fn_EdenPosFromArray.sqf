/*
    OKS_fnc_EdenPosFromArray

    Parses a position-like array into a safe [x,y,z] array.
    - Accepts [x,y] or [x,y,z]
    - Converts strings via parseNumber
    - Rejects non-scalars and NaN

    Returns [] if invalid.
*/

params ["_arr"];

if (!(_arr isEqualType [])) exitWith {[]};
if ((count _arr) < 2) exitWith {[]};

private _x = _arr select 0;
private _y = _arr select 1;

if (_x isEqualType "") then { _x = parseNumber _x; };
if (_y isEqualType "") then { _y = parseNumber _y; };

if (!(_x isEqualType 0) || {!(_y isEqualType 0)}) exitWith {[]};
if (!(_x == _x) || {!(_y == _y)}) exitWith {[]};

private _z = 0;
if ((count _arr) > 2) then {
    private _zv = _arr select 2;
    if (_zv isEqualType "") then { _zv = parseNumber _zv; };
    if (_zv isEqualType 0 && {_zv == _zv}) then { _z = _zv; };
};

[_x, _y, _z]
