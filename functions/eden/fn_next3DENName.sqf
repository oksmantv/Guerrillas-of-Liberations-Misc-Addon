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

// Reservation list prevents name collisions when multiple entities are created
// in the same action chain (e.g., rapid-fire repeat or OnPaste renumber).
private _reserved = uiNamespace getVariable ["OKS_3DEN_RESERVED_NAMES", []];

while {
    _name = format ["%1_%2", _prefix, _i];
    (_name in _reserved)
    || {_allObjects findIf { ((_x get3DENAttribute "name") select 0) isEqualTo _name } != -1}
} do { _i = _i + 1; };

// Reserve this name so subsequent calls in the same frame won't reuse it.
_reserved pushBack _name;
uiNamespace setVariable ["OKS_3DEN_RESERVED_NAMES", _reserved];

// Schedule cleanup for next frame so reservations don't persist indefinitely.
if (isNil {uiNamespace getVariable "OKS_3DEN_RESERVED_NAMES_CLEANUP"}) then {
    uiNamespace setVariable ["OKS_3DEN_RESERVED_NAMES_CLEANUP", true];
    [{
        uiNamespace setVariable ["OKS_3DEN_RESERVED_NAMES", []];
        uiNamespace setVariable ["OKS_3DEN_RESERVED_NAMES_CLEANUP", nil];
    }, [], 0] call CBA_fnc_waitAndExecute;
};

_name