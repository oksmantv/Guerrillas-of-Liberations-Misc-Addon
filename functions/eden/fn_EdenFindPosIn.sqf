/*
    OKS_fnc_EdenFindPosIn

    Recursively searches any value (typically BIS_fnc_3DENEntityMenu_data)
    for a position.

    Supports:
    - object: returns getPosATL object
    - arrays: tries OKS_fnc_EdenPosFromArray, otherwise walks nested arrays

    Params:
      0: Any      - value to search
      1: Number   - current depth (optional, default 0)
      2: Number   - depth limit (optional, default 4)

    Returns [] if nothing found.
*/

params ["_v", ["_depth", 0], ["_depthLimit", 4]];

if (_depth > _depthLimit) exitWith {[]};

if (_v isEqualType objNull) exitWith {
    if (isNull _v) then {[]} else { getPosATL _v };
};

if (!(_v isEqualType [])) exitWith {[]};

private _direct = [_v] call OKS_fnc_EdenPosFromArray;
if (_direct isNotEqualTo []) exitWith { _direct };

{
    private _found = [_x, _depth + 1, _depthLimit] call OKS_fnc_EdenFindPosIn;
    if (_found isNotEqualTo []) exitWith { _found };
} forEach _v;

[]
