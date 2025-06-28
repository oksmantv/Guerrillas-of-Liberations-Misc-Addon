/*
    Returns the next available unique name for a 3DEN object, given a prefix.
    Example: ["HuntBase"] call OKS_fnc_next3DENName; // returns "HuntBase_1", "HuntBase_2", etc.
*/

params ["_prefix"];
private ["_name"];
private _i = 1;
private _allObjects = (all3DENEntities select 0) + (all3DENEntities select 2);

while {
    _name = format ["%1_%2", _prefix, _i];
    _allObjects findIf { ((_x get3DENAttribute "name") select 0) isEqualTo _name } != -1
} do { _i = _i + 1; };

_name