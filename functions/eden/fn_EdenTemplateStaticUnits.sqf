/*
    OKS_fnc_EdenTemplateStaticUnits

    3DEN helper: Right-click terrain to place a static infantry group template.
    - Spawns X infantry for given side (randomized using OKS_fnc_Dynamic_Settings)
    - Places units in a centered line (leader in the middle, alternating left/right)

    Params:
      0: ANY  - BIS_fnc_3DENEntityMenu_data
      1: SIDE - west/east/independent

    Returns:
      BOOL
*/

params [
    ["_menuData", [], [[], objNull]],
    ["_side", sideUnknown, [sideUnknown]],
    ["_unitCountOverride", -1, [0]]
];

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];
private _debugLines = [];

private _p0 = [];
// Some Eden contexts pass menuData as [x,y,z] directly.
if (_menuData isEqualType []) then {
    _p0 = [_menuData] call OKS_fnc_EdenPosFromArray;
};
// Other contexts pass menuData as [[x,y,z], <entity>, ...] or [<entity>, ...].
if (_p0 isEqualTo [] && {_menuData isEqualType []}) then {
    private _md0 = _menuData param [0, []];
    if (_md0 isEqualType objNull) then {
        if (!isNull _md0) then { _p0 = getPosATL _md0; };
    } else {
        if (_md0 isEqualType []) then { _p0 = [_md0] call OKS_fnc_EdenPosFromArray; };
    };
};

if (_p0 isEqualTo []) then {
    private _stw = screenToWorld getMousePosition;
    if (_stw isEqualType []) then {
        _p0 = [_stw] call OKS_fnc_EdenPosFromArray;
    };
};
_p0 set [2, 0];
_p0 = [_p0] call OKS_fnc_EdenSanitizePos;
if (_p0 isEqualTo []) exitWith {
    if (_debug3DEN) then {
        ["[3DEN] Template Static Units: invalid click position", false, true] call OKS_fnc_LogDebug;
    };
    ["Template Static Units: invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

if (_debug3DEN) then {
    _debugLines pushBack (format ["menuData=%1", _menuData]);
    _debugLines pushBack (format ["clickPos=%1", _p0]);
};

private _readNum = {
    params ["_varName", "_default"]; 
    private _v = missionNamespace getVariable [_varName, _default];
    if (_v isEqualType 0) exitWith { _v };
    parseNumber str _v
};

private _unitCount = if (_unitCountOverride > 0) then {_unitCountOverride} else { ["OKS_3DEN_TEMPLATE_UNITCOUNT", 8] call _readNum };
_unitCount = (_unitCount max 1) min 60;

private _spacing = ["OKS_3DEN_TEMPLATE_SPACING", 3] call _readNum;
_spacing = (_spacing max 1) min 20;

private _settings = [_side] call OKS_fnc_Dynamic_Settings;
_settings params ["_unitArray"];
_unitArray params ["_leaders", "_units", "_officer"]; // _officer unused

private _leaderClass = selectRandom _leaders;

// Orient the line using the 3DEN camera direction so "left/right" feels natural.
private _dirToCam = [_p0, position get3DENCamera] call BIS_fnc_dirTo;
private _facingDir = _dirToCam;
private _dirLeft = _facingDir - 90;
private _dirRight = _facingDir + 90;

private _layer = ["Template Static Units", "OKS Eden - Template Helpers"] call OKS_fnc_EdenGetOrCreateLayer;

private _created = [];
private _spawn = objNull;

collect3DENHistory {
    for "_idx" from 0 to (_unitCount - 1) do {
        // Positions:
        // - idx 0: leader at center
        // - idx 1: left 1
        // - idx 2: right 1
        // - idx 3: left 2
        // - idx 4: right 2
        private _pos = +_p0;
        if (_idx > 0) then {
            private _step = ceil (_idx / 2);
            private _isLeft = (_idx % 2) == 1;
            private _dir = if (_isLeft) then {_dirLeft} else {_dirRight};
            _pos = _p0 getPos [_step * _spacing, _dir];
            _pos set [2, 0];
        };

        private _class = if (_idx == 0) then {_leaderClass} else { selectRandom _units };
        private _u = if (isNull _spawn) then {
            create3DENEntity ["Object", _class, [0,0,0]]
        } else {
            (group _spawn) create3DENEntity ["Object", _class, [0,0,0]]
        };
        if (!isNull _u) then {
            if (isNull _spawn) then { _spawn = _u; };
			if (!isNil "_layer") then { [_u, _layer] call OKS_fnc_EdenSetLayerSafe; };
            _u set3DENAttribute ["position", _pos];
            _u set3DENAttribute ["rotation", [0, 0, _facingDir]];
            _created pushBack _u;
        };
    };
};

private _countCreated = count _created;
if (_countCreated <= 0) exitWith {
    if (_debug3DEN) then {
        ["[3DEN] Template Static Units: failed to create units", false, true] call OKS_fnc_LogDebug;
    };
    ["Template Static Units: failed to create units", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _sideName = switch (_side) do {
    case west: {"WEST"};
    case east: {"EAST"};
    case independent: {"INDEPENDENT"};
    default {"UNKNOWN"};
};

if (_debug3DEN) then {
    _debugLines pushBack (format ["side=%1 count=%2 spacing=%3 facing=%4", _sideName, _countCreated, _spacing, _facingDir]);
    if !(_debugLines isEqualTo []) then {
        [format ["[3DEN] Template Static Units | %1", _debugLines joinString " | "], false, true] call OKS_fnc_LogDebug;
    };
};

[format ["Template Static Units placed (%1) | Count=%2", _sideName, _countCreated], 0, 5, false] call BIS_fnc_3DENNotification;

["OKS_fnc_EdenTemplateStaticUnits", [_side, _unitCountOverride], []] call OKS_fnc_EdenRememberLastAction;
true
