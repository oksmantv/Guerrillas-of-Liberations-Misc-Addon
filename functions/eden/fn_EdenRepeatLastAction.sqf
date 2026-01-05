/*
    OKS_fnc_EdenRepeatLastAction

    Re-runs the last remembered Eden clipboard-generator action.
    - Keeps the same fixed parameters
    - Forces a fresh position from the current mouse hover (3DEN)
    - Tries with current selection first; if it returns false, retries once using
      the last remembered context objects (if any), then restores selection.

    Returns:
      BOOL
*/

if (!is3DEN) exitWith { false };

// Silent marker to help verify which version is loaded in-game.
uiNamespace setVariable ["OKS_3DEN_REPEAT_LASTACTION_VERSION", 3];

private _notifyFail = {
    params ["_msg"];
    [_msg, 1, 6, true] call BIS_fnc_3DENNotification;
    if (uiNamespace getVariable ["OKS_3DEN_DEBUG", false]) then {
        diag_log format ["OKS_GOL_Misc: RepeatLastAction: %1", _msg];
    };
};

private _payload = uiNamespace getVariable ["OKS_3DEN_LAST_ACTION", []];
if !(_payload isEqualType []) exitWith { false };
if ((count _payload) < 2) exitWith {
    ["Repeat: no last Eden action recorded"] call _notifyFail;
    false
};

_payload params [
    ["_fnName", "", [""]],
    ["_fixedArgs", [], [[]]],
    ["_lastObjs", [], [[]]]
];

if (_fnName isEqualTo "") exitWith {
    ["Repeat: no last Eden action recorded"] call _notifyFail;
    false
};

private _fn = missionNamespace getVariable [_fnName, {}];
if !(_fn isEqualType {}) exitWith {
    [format ["Repeat: function not found (%1)", _fnName]] call _notifyFail;
    false
};

private _pos = [];

// Prefer Eden Map cursor position when the map is being used.
// In map mode, screenToWorld can be misleading because it uses the 3D viewport.
disableSerialization;
private _disp3DEN = findDisplay 313;
if (!isNull _disp3DEN) then {
    // Find visible map controls in the 3DEN display (CT_MAP = 101).
    private _mapCtrls = (allControls _disp3DEN) select { (ctrlType _x) == 101 && { ctrlShown _x } };
    private _mapCtrl = _mapCtrls param [0, controlNull];
    if (!isNull _mapCtrl) then {
        private _mapPos2D = _mapCtrl ctrlMapScreenToWorld getMousePosition;
        if (_mapPos2D isEqualType [] && { (count _mapPos2D) >= 2 }) then {
            _pos = [_mapPos2D select 0, _mapPos2D select 1, 0];
        };

        if (uiNamespace getVariable ["OKS_3DEN_DEBUG", false]) then {
            diag_log format [
                "OKS_GOL_Misc: RepeatLastAction mapPos | ctrlIDC=%1 pos2D=%2 mouse=%3",
                ctrlIDC _mapCtrl,
                _mapPos2D,
                getMousePosition
            ];
        };
    } else {
        if (uiNamespace getVariable ["OKS_3DEN_DEBUG", false]) then {
            diag_log format ["OKS_GOL_Misc: RepeatLastAction mapPos | no visible map ctrl found (maps=%1)", count _mapCtrls];
        };
    };
};

// Fallback: screen-to-world under cursor (works even when Eden mouse pos is flaky).
if (_pos isEqualTo []) then {
    private _stw = screenToWorld getMousePosition;
    if (_stw isEqualType []) then {
        _pos = [_stw] call OKS_fnc_EdenPosFromArray;
    };
};

// Last resort: current 3DEN camera position.
if (_pos isEqualTo []) then {
    private _cam = get3DENCamera;
    if (!isNull _cam) then {
        private _cp = getPosATL _cam;
        if (_cp isEqualType []) then {
            _pos = [_cp] call OKS_fnc_EdenPosFromArray;
        };
    };
};

if (_pos isEqualTo []) exitWith {
    ["Repeat: invalid mouse/camera position"] call _notifyFail;
    false
};

_pos set [2, 0];
_pos = [_pos] call OKS_fnc_EdenSanitizePos;
if (_pos isEqualTo []) exitWith {
    ["Repeat: invalid mouse/camera position"] call _notifyFail;
    false
};

private _origSel = get3DENSelected "object";
// Eden menu actions pass BIS_fnc_3DENEntityMenu_data as param 0 (an array whose first element is the click position).
// Many Eden helpers expect that shape and unpack it via `_menuData params ["_position"];`.
private _menuData = [_pos];
private _callParams = [_menuData] + _fixedArgs;

private _fallback = _lastObjs select { _x isEqualType objNull && {!isNull _x} };

// If nothing is selected right now, prefer reusing the last context objects.
private _didSwap = false;
if ((_origSel isEqualTo []) && {!(_fallback isEqualTo [])}) then {
    set3DENSelected ["object", _fallback];
    _didSwap = true;
};

private _result = false;
uiNamespace setVariable ["OKS_3DEN_IS_REPEAT", true];
_result = _callParams call _fn;
uiNamespace setVariable ["OKS_3DEN_IS_REPEAT", false];
if (isNil "_result") then { _result = false; };

private _isSuccess = {
    params ["_value"];
    if (_value isEqualType false) exitWith { _value };
    if (_value isEqualType 0) exitWith { _value > 0 };
    if (_value isEqualType "") exitWith { !(_value isEqualTo "") };
    if (_value isEqualType []) exitWith { !(_value isEqualTo []) };
    true
};

private _ok = [_result] call _isSuccess;

// If the action failed with the current selection, retry once using last remembered objects.
if (!_ok && {!(_fallback isEqualTo [])} && {!_didSwap}) then {
    set3DENSelected ["object", _fallback];
    uiNamespace setVariable ["OKS_3DEN_IS_REPEAT", true];
    _result = _callParams call _fn;
    uiNamespace setVariable ["OKS_3DEN_IS_REPEAT", false];
    if (isNil "_result") then { _result = false; };
    _ok = [_result] call _isSuccess;
};

// Restore selection
set3DENSelected ["object", _origSel];

_ok;
