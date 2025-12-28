/*
    OKS_fnc_EdenFrontlineNodePlace

    Eden tool: place a numbered Frontline "Node" as a Logic entity.

    Usage (from 3DEN context menu):
      [(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), 'WEST'] call OKS_fnc_EdenFrontlineNodePlace;

    Node naming:
      FLN_<SIDE>_<N>
      Example: FLN_WEST_1, FLN_WEST_2 ...

    Notes:
      - Uses OKS_fnc_next3DENName to ensure numbering continues.
      - Designed to be copy/paste friendly; optional auto-renumber on paste is handled elsewhere.
*/

params [
    ["_menuData", [], [[]]],
    ["_sideName", "WEST", [""]]
];

if (!is3DEN) exitWith {false};

private _dbg = uiNamespace getVariable ["OKS_3DEN_DEBUG_FRONTLINE", true];

if (_dbg) then {
    diag_log format ["[OKS][3DEN][FrontlineNodes][Place] start | sideName=%1 menuDataType=%2 menuData=%3", _sideName, typeName _menuData, _menuData];
};

private _sideKey = toUpper _sideName;
if !(_sideKey in ["WEST", "EAST", "GUER", "INDEPENDENT"]) then { _sideKey = "WEST"; };

if (_dbg) then { diag_log format ["[OKS][3DEN][FrontlineNodes][Place] normalized side=%1", _sideKey]; };

private _clickPos = [];

// Some Eden contexts pass menuData as [x,y,z] directly.
if (_menuData isEqualType []) then {
    _clickPos = [_menuData] call OKS_fnc_EdenPosFromArray;
};

if (_dbg) then { diag_log format ["[OKS][3DEN][FrontlineNodes][Place] after menuData-direct parse | clickPos=%1", _clickPos]; };

// Other contexts pass menuData as [[x,y,z], <entity>, ...] or [<entity>, ...].
if (_clickPos isEqualTo []) then {
    private _md0 = _menuData param [0, []];
    if (_md0 isEqualType objNull) then {
        if (!isNull _md0) then { _clickPos = getPosATL _md0; };
    } else {
        if (_md0 isEqualType []) then { _clickPos = [_md0] call OKS_fnc_EdenPosFromArray; };
    };
};

if (_dbg) then { diag_log format ["[OKS][3DEN][FrontlineNodes][Place] after md0 parse | md0Type=%1 clickPos=%2", typeName (_menuData param [0, []]), _clickPos]; };

if (_clickPos isEqualTo []) then {
    private _stw = screenToWorld getMousePosition;
    if (_stw isEqualType []) then {
        _clickPos = [_stw] call OKS_fnc_EdenPosFromArray;
    };
};
_clickPos set [2, 0];
_clickPos = [_clickPos] call OKS_fnc_EdenSanitizePos;

if (_dbg) then { diag_log format ["[OKS][3DEN][FrontlineNodes][Place] final clickPos=%1", _clickPos]; };

if (_clickPos isEqualTo []) exitWith {
    ["Frontline Node: invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _prefix = format ["FLN_%1", _sideKey];
private _name = [_prefix] call OKS_fnc_next3DENName;

if (_dbg) then { diag_log format ["[OKS][3DEN][FrontlineNodes][Place] prefix=%1 nextName=%2", _prefix, _name]; };

private _logic = create3DENEntity ["Logic", "Logic", _clickPos];
if (isNull _logic) exitWith {
    ["Frontline Node: failed to create Logic", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _aoLayer = ["Area of Operations Markers"] call OKS_fnc_EdenGetOrCreateLayer;
private _aoLayerValid = (_aoLayer isEqualType 0 && {_aoLayer >= 0}) || {(_aoLayer isEqualType objNull) && {!isNull _aoLayer}};
if (_aoLayerValid) then {
    [_logic, _aoLayer] call OKS_fnc_EdenSetLayerSafe;
};

if (_dbg) then { diag_log format ["[OKS][3DEN][FrontlineNodes][Place] created logic=%1 typeOf=%2 pos=%3", _logic, typeOf _logic, getPosATL _logic]; };

_logic set3DENAttribute ["name", _name];
_logic set3DENAttribute ["text", _name];
_logic set3DENAttribute ["description", format ["Frontline Node (%1)", _sideKey]];

if (_dbg) then {
    diag_log format ["[OKS][3DEN][FrontlineNodes][Place] set attrs | name=%1 text=%2 desc=%3", (_logic get3DENAttribute "name") select 0, (_logic get3DENAttribute "text") select 0, (_logic get3DENAttribute "description") select 0];
};

systemChat format ["Frontline Node placed: %1", _name];

["OKS_fnc_EdenFrontlineNodePlace", [_sideName], []] call OKS_fnc_EdenRememberLastAction;
true
