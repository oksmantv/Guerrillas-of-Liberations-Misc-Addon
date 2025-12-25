/*
    Returns the next available unique name for a 3DEN object, given a prefix.
    Example: ["HuntBase"] call OKS_fnc_next3DENName; // returns "HuntBase_1", "HuntBase_2", etc.
*/

params ["_prefix"];
private ["_name"];
private _i = 1;
// Collect all editor-placed objects (including Game Logics) so names increment correctly.
// Note: Some entity categories (e.g., Game Logic) are not always present in (all3DENEntities select 0).
private _allObjects = [];
{
    if (_x isEqualType objNull) then {
        _allObjects pushBack _x;
    };
} forEach (flatten all3DENEntities);

// Also include triggers explicitly (paranoia / compatibility).
if ((count all3DENEntities) > 2) then {
    {
        if (_x isEqualType objNull) then {
            _allObjects pushBackUnique _x;
        };
    } forEach (all3DENEntities select 2);
};

while {
    _name = format ["%1_%2", _prefix, _i];
    _allObjects findIf { ((_x get3DENAttribute "name") select 0) isEqualTo _name } != -1
} do { _i = _i + 1; };

_name