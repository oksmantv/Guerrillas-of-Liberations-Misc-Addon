/*
    OKS_fnc_EdenEvacuateHVT

    Eden helper:
    - Always creates an ExfilSite helper (hidden Logic) at click position.
    - If units are selected: uses selected men as HVTs (names them if missing).
      - If all in one group: uses GROUP reference.
      - If mixed groups: uses ARRAY reference.
    - If no units selected: creates a default 3-civilian group at click position.

    Copies a spawnList-ready call to OKS_fnc_Evacuate_HVT.
*/

params ["_menuData"];

private _md = if (_menuData isEqualType []) then {_menuData} else {[]};

private _selected = get3DENSelected "object";
private _men = _selected select { _x isKindOf "Man" };

private _fnc_sanitizePos0 = {
    params ["_pos"];
    private _p = [_pos] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith {[]};
    _p set [2, 0];
    _p
};

private _anchorPos = {
    params ["_objs", "_md"];
    private _p = [];

    // Some Eden contexts pass menuData as [x,y,z] directly.
    if (_md isEqualType []) then {
        _p = [_md] call OKS_fnc_EdenPosFromArray;
    };

    // Other contexts pass menuData as [[x,y,z], <entity>, ...] or [<entity>, ...].
    if (_p isEqualTo []) then {
        private _md0 = _md param [0, []];
        if (_md0 isEqualType objNull) then {
            if (!isNull _md0) then { _p = getPosATL _md0; };
        } else {
            if (_md0 isEqualType []) then { _p = [_md0] call OKS_fnc_EdenPosFromArray; };
        };
    };

    if (_p isEqualTo [] && {!(_objs isEqualTo [])}) then {
        _p = getPosATL (_objs select 0);
    };

    if (_p isEqualTo []) then { _p = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray; };
    _p = [_p] call _fnc_sanitizePos0;
    if (_p isEqualTo []) exitWith {[]};
    _p
};

private _ensureNamed = {
    params ["_obj", "_prefix"]; 
    private _n = (_obj get3DENAttribute "name") select 0;
    if (_n isEqualTo "") then {
        _n = [_prefix] call OKS_fnc_next3DENName;
        _obj set3DENAttribute ["name", _n];
    };
    _n
};

private _createHiddenLogic = {
    params ["_prefix", "_pos"]; 
    private _p = [_pos] call _fnc_sanitizePos0;
    if (_p isEqualTo []) then { _p = [0,0,0]; };
    private _obj = create3DENEntity ["Logic", "Logic", _p];
    if (isNull _obj) exitWith {""};
    private _n = [_prefix] call OKS_fnc_next3DENName;
    _obj set3DENAttribute ["name", _n];
    _obj set3DENAttribute ["hideObject", true];
    if (((_obj get3DENAttribute "name") select 0) isEqualTo "") then {
        _obj set3DENAttribute ["name", _n];
    };
    _n
};

private _p0 = [_selected, _md] call _anchorPos;
if (_p0 isEqualTo []) exitWith {
    (format ["EdenEvacuateHVT: invalid click position. menuData=%1", _md]) call OKS_fnc_LogDebug;
    ["Evacuate HVT: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _offsetPosFrom = {
    params ["_pos", "_dist", "_dirDeg"];
    private _p = +_pos;
    if ((count _p) < 2) exitWith {[]};
    if ((count _p) == 2) then { _p pushBack 0; };
    _p set [0, (_p select 0) + (sin _dirDeg) * _dist];
    _p set [1, (_p select 1) + (cos _dirDeg) * _dist];
    _p set [2, 0];
    [_p] call _fnc_sanitizePos0
};

// Exfil site always created. Offset 5m when units are selected so it doesn't overlap them.
private _exfilPos = _p0;
if !(_men isEqualTo []) then {
    private _dir = if ((count _men) > 0) then { getDir (_men select 0) } else { 0 };
    private _p = ([_p0, 5, _dir + 90] call _offsetPosFrom);
    if !(_p isEqualTo []) then { _exfilPos = _p; };
};

private _exfilName = ["ExfilSite", _exfilPos] call _createHiddenLogic;
if (_exfilName isEqualTo "") exitWith {
    ["Evacuate HVT: Failed to create ExfilSite helper", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

// Ensure selected men are named + immobilized for task start.
private _hvtNames = [];
{
    private _init = (_x get3DENAttribute "init") select 0;
    private _needle = 'this disableAI "MOVE";';
    if (_init isEqualTo "") then {
        _init = _needle;
    } else {
        if ((_init find _needle) == -1) then {
            _init = _init + " " + _needle;
        };
    };
    _x set3DENAttribute ["init", _init];
    _hvtNames pushBack ([_x, "hvt"] call _ensureNamed);
} forEach _men;

private _example = "";
if (_men isEqualTo []) then {
    // Default: create 3 civilians near click.
    private _dir = 0;
    private _firstName = ["hvt"] call OKS_fnc_next3DENName;
    private _firstUnit = create3DENEntity ["Object", "C_man_1", (_p0 getPos [0, 0])];
    _firstUnit set3DENAttribute ["name", _firstName];
    _firstUnit set3DENAttribute ["init", 'this disableAI "MOVE";'];
    private _grp = group _firstUnit;

    _dir = _dir + 45;
    for "_i" from 2 to 3 do {
        private _unitName = ["hvt"] call OKS_fnc_next3DENName;
        private _unit = _grp create3DENEntity ["Object", "C_man_1", (_p0 getPos [3, _dir])];
        _unit set3DENAttribute ["name", _unitName];
        _unit set3DENAttribute ["presence", 1];
        _unit set3DENAttribute ["init", 'this disableAI "MOVE";'];
        _dir = _dir + 45;
    };

    ["No unit selected: created example HVT group (3 civilians)", 0, 5, true] call BIS_fnc_3DENNotification;
    _example = format ["[group %1, getPos %2, west, false, nil, true, false] spawn OKS_fnc_Evacuate_HVT;", _firstName, _exfilName];
} else {
    private _groups = [];
    { _groups pushBackUnique (group _x); } forEach _men;
    _groups = _groups select { !isNull _x };

    private _unitsExpr = "";
    if ((count _groups) == 1) then {
        _unitsExpr = format ["group %1", _hvtNames select 0];
    } else {
        _unitsExpr = format ["[%1]", _hvtNames joinString ", "];
    };

    _example = format ["[%1, getPos %2, west, false, nil, true, false] spawn OKS_fnc_Evacuate_HVT;", _unitsExpr, _exfilName];
};

copyToClipboard _example;
[format ["CopiedToClipboard: %1", _example], true] call OKS_fnc_LogDebug;
[format ["Evacuate HVT copied (exfil: %1)", _exfilName], 0, 5, true] call BIS_fnc_3DENNotification;

true