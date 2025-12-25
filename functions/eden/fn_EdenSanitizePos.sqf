/*
    OKS_fnc_EdenSanitizePos

    Ensures a position array is safe to pass into create3DENEntity.
    - Ensures 3 elements
    - Converts strings via parseNumber
    - Replaces invalid/non-scalar/NaN values with 0

    Returns [] if input is not an array with at least 2 elements.
*/

params ["_pos"];

if (!(_pos isEqualType [])) exitWith {[]};
if ((count _pos) < 2) exitWith {[]};

private _p = +_pos;
if ((count _p) == 2) then { _p pushBack 0; };

private _fnc_getScalarOrZero = {
    params ["_v"];
    if (_v isEqualType "") then { _v = parseNumber _v; };
    if (!(_v isEqualType 0)) exitWith {0};
    if !(_v == _v) exitWith {0};
    _v
};

_p set [0, [(_p select 0)] call _fnc_getScalarOrZero];
_p set [1, [(_p select 1)] call _fnc_getScalarOrZero];
_p set [2, [(_p select 2)] call _fnc_getScalarOrZero];

_p
