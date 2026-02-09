/*
    OKS_fnc_EdenFrontlineNodeOnPasteRenumber

    Renumbers pasted Frontline Node logics so copy/paste automatically produces the next nodes.

    Intended to be called from a 3DEN event handler (e.g., OnPaste):
      add3DENEventHandler ["OnPaste", { _this call OKS_fnc_EdenFrontlineNodeOnPasteRenumber; }];

    Behavior:
      - Only touches Logic entities whose name matches FLN_<SIDE>_<N>
      - Replaces the name/text with the next available FLN_<SIDE>_<next>

    Params:
      _this is usually an ARRAY containing pasted entities (varies by EH).
*/

if (!is3DEN) exitWith {false};

// Clear name reservations so paste-renumber picks truly free names.
uiNamespace setVariable ["OKS_3DEN_RESERVED_NAMES", []];

private _dbg = uiNamespace getVariable ["OKS_3DEN_DEBUG_FRONTLINE", true];
if (_dbg) then { diag_log format ["[OKS][3DEN][FrontlineNodes][OnPasteRenumber] start | rawThis=%1", _this]; };

private _entities = _this;

// Some EHs pass [entities] as first arg.
if (_entities isEqualType [] && {(count _entities) == 1} && {(_entities select 0) isEqualType []}) then {
    _entities = _entities select 0;
};

if (_dbg) then {
  diag_log format ["[OKS][3DEN][FrontlineNodes][OnPasteRenumber] normalized entities | type=%1 count=%2 value=%3", typeName _entities, if (_entities isEqualType []) then {count _entities} else {-1}, _entities];
};

if !(_entities isEqualType []) exitWith {false};

private _isFrontlineNodeName = {
    params ["_n"]; 
    if !(_n isEqualType "") exitWith {false};
    private _u = toUpper _n;
    if !(_u select [0, 4] isEqualTo "FLN_") exitWith {false};
    private _parts = _u splitString "_";
    if ((count _parts) < 3) exitWith {false};
    private _side = _parts select 1;
    if !(_side in ["WEST", "EAST", "GUER", "INDEPENDENT"]) exitWith {false};
    true
};

private _renamed = 0;
{
    private _ent = _x;
    if !(_ent isEqualType objNull) then { continue; };
    if (isNull _ent) then { continue; };

    // Only logics
    if !((typeOf _ent) isEqualTo "Logic") then { continue; };

    private _oldName = (_ent get3DENAttribute "name") select 0;
    if (_dbg) then {
      diag_log format ["[OKS][3DEN][FrontlineNodes][OnPasteRenumber] candidate | ent=%1 typeOf=%2 oldName=%3", _ent, typeOf _ent, _oldName];
    };
    if !([_oldName] call _isFrontlineNodeName) then { continue; };

    private _parts = (toUpper _oldName) splitString "_";
    private _prefix = format ["FLN_%1", _parts select 1];
    private _newName = [_prefix] call OKS_fnc_next3DENName;

    if (_dbg) then { diag_log format ["[OKS][3DEN][FrontlineNodes][OnPasteRenumber] rename | old=%1 new=%2 prefix=%3", _oldName, _newName, _prefix]; };

    _ent set3DENAttribute ["name", _newName];
    _ent set3DENAttribute ["text", _newName];
    _renamed = _renamed + 1;
} forEach _entities;

if (_renamed > 0) then {
  diag_log format ["[OKS][3DEN][FrontlineNodes][OnPasteRenumber] done | renamed=%1", _renamed];
  if (_dbg) then { systemChat format ["Frontline Nodes: renumbered %1 pasted node(s)", _renamed]; };
} else {
  if (_dbg) then { diag_log "[OKS][3DEN][FrontlineNodes][OnPasteRenumber] done | renamed=0"; };
};

true
