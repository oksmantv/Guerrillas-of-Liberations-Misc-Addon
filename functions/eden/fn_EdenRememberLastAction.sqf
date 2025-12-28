/*
    OKS_fnc_EdenRememberLastAction

    Stores the last successfully executed Eden clipboard-generator action
    so it can be repeated via keybind.

    Storage (uiNamespace):
      OKS_3DEN_LAST_ACTION = [STRING fnName, ARRAY fixedArgs, ARRAY contextObjects]

    Params:
      0: STRING - function variable name (e.g. "OKS_fnc_EdenMortars")
      1: ARRAY  - fixed args to pass after menuData on repeat
      2: ARRAY  - context objects to optionally reuse when repeating (selection fallback)

    Returns:
      BOOL
*/

params [
    ["_fnName", "", [""]],
    ["_fixedArgs", [], [[]]],
    ["_contextObjects", [], [[]]]
];

if (_fnName isEqualTo "") exitWith { false };

private _objs = [];
{
    if (_x isEqualType objNull && {!isNull _x}) then {
        _objs pushBackUnique _x;
    };
} forEach _contextObjects;

uiNamespace setVariable ["OKS_3DEN_LAST_ACTION", [_fnName, +_fixedArgs, _objs]];
true;
