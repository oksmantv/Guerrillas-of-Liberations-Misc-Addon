/*
    OKS_fnc_EdenSetupIntel

    Eden helper for OKS_fnc_SetupIntel.

    Usage from CfgEden:
      (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenSetupIntel;

    Behavior:
    - Right-click terrain to choose intel position.
    - Spawns a simple intel prop (Land_File1_F) at click position and names it intel_X.
    - If objects/units are selected, they are treated as the intel target(s) (single object or array).
    - Copies a spawnList-ready OKS_fnc_SetupIntel call to clipboard.

    Notes:
    - This helper intentionally keeps parameters as clear defaults/placeholder values.
*/

params ["_menuData"];

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

private _md = if (_menuData isEqualType []) then {_menuData} else {[]};

private _selectedObjects = get3DENSelected "object";

// Some Eden context menus pass a clicked entity even when not selected.
private _md0 = _md param [0, objNull];
private _clickedObj = if (_md0 isEqualType objNull && {!isNull _md0}) then {_md0} else {objNull};
private _contextObjects = +_selectedObjects;
if (!isNull _clickedObj && { !(_clickedObj in _contextObjects) }) then {
    _contextObjects pushBack _clickedObj;
};

private _anchorPos = {
    params ["_objs", "_md"]; 
    private _p = [];

    if (_md isEqualType []) then {
        _p = [_md] call OKS_fnc_EdenPosFromArray;
    };

    if (_p isEqualTo []) then {
        private _md0 = _md param [0, []];
        // If the context is "right-clicked an entity", md0 is often an object.
        // We DO NOT want to use the entity's position for intel placement; prefer the ground click position.
        if (_md0 isEqualType []) then { _p = [_md0] call OKS_fnc_EdenPosFromArray; };
    };

    // Prefer the mouse/click position (ground) over selected/clicked objects.
    if (_p isEqualTo []) then { _p = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray; };

    // Only as a last-resort fallback, use the first selected object position.
    if (_p isEqualTo [] && {!(_objs isEqualTo [])}) then {
        _p = getPosATL (_objs select 0);
    };
    _p set [2, 0];
    _p = [_p] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith {[]};
    _p
};

private _ensureNamed = {
    params ["_entity", "_namePrefix"]; 
    private _n = (_entity get3DENAttribute "name") select 0;
    if (_n isEqualTo "") then {
        _n = [_namePrefix] call OKS_fnc_next3DENName;
        _entity set3DENAttribute ["name", _n];
    };
    _n
};

private _p0 = [_contextObjects, _md] call _anchorPos;
if (_p0 isEqualTo []) exitWith {
    if (_debug3DEN) then {
		[format ["[3DEN] EdenSetupIntel: invalid click position. menuData=%1", _md], false, true] call OKS_fnc_LogDebug;
    };
    ["Setup Intel: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

// Prefer spawning an ACE/ACEX intel *document* object when available.
// Fallback to a vanilla file prop so the helper always works.
private _intelClassOverride = missionNamespace getVariable ["OKS_3DEN_INTEL_CLASS", ""]; // optional
private _intelClass = "acex_intelitems_document";

if(!isNil _intelClassOverride && _intelClassOverride isNotEqualTo "") then {
    _intelClass = _intelClassOverride;
};

private _layer = ["Setup Intel", "OKS Eden - Task Helpers"] call OKS_fnc_EdenGetOrCreateLayer;

private _intelObj = create3DENEntity ["Object", _intelClass, _p0];
if (isNull _intelObj) exitWith {
    ["Setup Intel: Failed to create intel object", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

if (!isNil "_layer") then { [_intelObj, _layer] call OKS_fnc_EdenSetLayerSafe; };

private _intelName = [_intelObj, "intel"] call _ensureNamed;

// Treat selection as target(s). Exclude the intel prop we just created.
private _targets = _contextObjects select { _x isNotEqualTo _intelObj };

private _targetNames = [];
{
    _targetNames pushBack ([_x, "IntelTarget"] call _ensureNamed);
} forEach _targets;

private _targetExpr = "nil";
if ((count _targetNames) == 1) then {
    _targetExpr = _targetNames select 0;
} else {
    if ((count _targetNames) > 1) then {
        _targetExpr = format ["[%1]", _targetNames joinString ", "];
    };
};

private _customText = "ENEMY INTEL\nYou have found intel regarding enemy assets.\n\n%1\n\n%2";

private _example = format [
    "null = [%1, %2, nil, %3, nil, %4, true] spawn OKS_fnc_SetupIntel;",
    _intelName,
    _targetExpr,
    str _customText,
    str ""
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenSetupIntel", [], _contextObjects] call OKS_fnc_EdenRememberLastAction;
private _logText = format ["CopiedToClipboard | Setup Intel copied to clipboard | Cache=%1 | %2", _cacheCount, _example];
private _chatText = format ["CopiedToClipboard | Setup Intel copied to clipboard | Cache=%1", _cacheCount];
systemChat _chatText;

private _logExample = _example splitString "\r\n" joinString " ";
_logText = format ["CopiedToClipboard | Setup Intel copied to clipboard | Cache=%1 | %2", _cacheCount, _logExample];
[_logText, false, true, true] call OKS_fnc_LogDebug;

private _notify = if (_debug3DEN) then {
    format ["Setup Intel copied to clipboard: Intel=%1 (%2) | Targets=%3", _intelName, _intelClass, _targetExpr]
} else {
    "Setup Intel copied to clipboard"
};
_notify = format ["%1 | Cache=%2", _notify, _cacheCount];
[_notify, 0, 10, true] call BIS_fnc_3DENNotification;
true;
