/*
    OKS_fnc_EdenTemplatePatrol

    3DEN helper: Right-click terrain to place a patrol group template.
    - Spawns X infantry for given side (randomized using OKS_fnc_Dynamic_Settings)
    - Creates 4 waypoints in a cardinal pattern around the click point
      - WP1: Move (behaviour SAFE)
      - WP2: Move
      - WP3: Move
      - WP4: Cycle

    Params:
      0: ANY  - BIS_fnc_3DENEntityMenu_data
      1: SIDE - west/east/independent

    Returns:
      BOOL
*/

params [
    ["_menuData", [], [[], objNull]],
    ["_side", sideUnknown, [sideUnknown]],
    ["_unitCountOverride", -1, [0]],
    ["_profile", "SLOW", [""]]
];

private _profileUp = toUpper _profile;
private _isFast = _profileUp isEqualTo "FAST";
private _radiusMul = 0.5;

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];
private _debugLines = [];

private _p0 = [];
if (_menuData isEqualType []) then {
    _p0 = [_menuData] call OKS_fnc_EdenPosFromArray;
};
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
    ["Template Patrol: invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
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

private _unitCount = if (_unitCountOverride > 0) then {
    _unitCountOverride
} else {
    ["OKS_3DEN_TEMPLATE_PATROL_UNITCOUNT", ["OKS_3DEN_TEMPLATE_UNITCOUNT", 8] call _readNum] call _readNum
};
_unitCount = (_unitCount max 1) min 60;

private _spacing = ["OKS_3DEN_TEMPLATE_SPACING", 3] call _readNum;
_spacing = (_spacing max 1) min 20;

private _radius = ["OKS_3DEN_TEMPLATE_PATROL_RADIUS", 200] call _readNum;
_radius = (_radius max 20) min 1000;
_radius = _radius * _radiusMul;

private _settings = [_side] call OKS_fnc_Dynamic_Settings;
_settings params ["_unitArray"];
_unitArray params ["_leaders", "_units", "_officer"]; // _officer unused

private _leaderClass = selectRandom _leaders;

private _cols = ceil (sqrt _unitCount);
private _rows = ceil (_unitCount / _cols);
private _startX = -((_cols - 1) * _spacing) / 2;
private _startY = -((_rows - 1) * _spacing) / 2;

private _created = [];
private _spawn = objNull;

private _mkPos = {
    params ["_base", "_dist", "_dir"]; 
    private _p = _base getPos [_dist, _dir];
    _p set [2, 0];
    [_p] call OKS_fnc_EdenSanitizePos
};

collect3DENHistory {
    private _idx = 0;
    for "_r" from 0 to (_rows - 1) do {
        for "_c" from 0 to (_cols - 1) do {
            if (_idx >= _unitCount) exitWith {};

            private _pos = [
                (_p0 select 0) + _startX + (_c * _spacing),
                (_p0 select 1) + _startY + (_r * _spacing),
                0
            ];

            private _class = if (_idx == 0) then {_leaderClass} else { selectRandom _units };
            private _u = if (isNull _spawn) then {
                create3DENEntity ["Object", _class, [0,0,0]]
            } else {
                (group _spawn) create3DENEntity ["Object", _class, [0,0,0]]
            };
            if (!isNull _u) then {
                if (isNull _spawn) then { _spawn = _u; };
                _u set3DENAttribute ["position", _pos];
                _u set3DENAttribute ["rotation", [0, 0, floor (random 360)]];
                _created pushBack _u;
            };

            _idx = _idx + 1;
        };
        if (_idx >= _unitCount) exitWith {};
    };

};

private _countCreated = count _created;
if (_countCreated <= 0) exitWith {
    ["Template Patrol: failed to create units", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _sideName = switch (_side) do {
    case west: {"WEST"};
    case east: {"EAST"};
    case independent: {"INDEPENDENT"};
    default {"UNKNOWN"};
};

// Prefer GW's 3DEN helper if present (uses GW_WaypointRadius + GW_WaypointCount).
if (!isNull _spawn) then {
    private _gwWpFncName = "";
    if (!isNil "GW_3den_fnc_createWaypoints") then { _gwWpFncName = "GW_3den_fnc_createWaypoints"; };
    if (_gwWpFncName isEqualTo "" && {!isNil "GW_3DEN_fnc_createWaypoints"}) then { _gwWpFncName = "GW_3DEN_fnc_createWaypoints"; };

    if (!(_gwWpFncName isEqualTo "")) then {
        private _gwFnc = missionNamespace getVariable [_gwWpFncName, {}];
        if (_debug3DEN) then {
            _debugLines pushBack (format ["calling %1 (leader=%2 radiusMul=%3 profile=%4)", _gwWpFncName, _spawn, _radiusMul, _profileUp]);
        };
        [_spawn, _radiusMul, _profileUp] call _gwFnc;
    } else {
        if (_debug3DEN) then {
            _debugLines pushBack "GW waypoint function not found; using fallback";
        };
        // Fallback: keep the predictable 4 waypoint cardinal pattern.
        private _wpPos1 = [_p0, _radius, 0] call _mkPos;   // North
        private _wpPos2 = [_p0, _radius, 90] call _mkPos;  // East
        private _wpPos3 = [_p0, _radius, 180] call _mkPos; // South
        private _wpPos4 = [_p0, _radius, 270] call _mkPos; // West

        if (_wpPos1 isEqualTo []) then { _wpPos1 = _p0; };
        if (_wpPos2 isEqualTo []) then { _wpPos2 = _p0; };
        if (_wpPos3 isEqualTo []) then { _wpPos3 = _p0; };
        if (_wpPos4 isEqualTo []) then { _wpPos4 = _p0; };

        collect3DENHistory {
            private _wp1 = (group _spawn) create3DENEntity ["Waypoint", "MOVE", _wpPos1];
            (group _spawn) create3DENEntity ["Waypoint", "MOVE", _wpPos2];
            (group _spawn) create3DENEntity ["Waypoint", "MOVE", _wpPos3];
            (group _spawn) create3DENEntity ["Waypoint", "CYCLE", _wpPos4];
            if (!isNull _wp1) then {
                if (_isFast) then {
                    _wp1 set3DENAttribute ["formation", 5];
                    _wp1 set3DENAttribute ["speedMode", 3];
                    _wp1 set3DENAttribute ["behaviour", "AWARE"];
                } else {
                    _wp1 set3DENAttribute ["speedMode", 1];
                    _wp1 set3DENAttribute ["behaviour", "SAFE"];
                };
            };
        };
    };
};

if (_debug3DEN) then {
    _debugLines pushBack (format ["side=%1 units=%2 radius=%3", _sideName, _countCreated, _radius]);
    if !(_debugLines isEqualTo []) then {
        [format ["[3DEN] Template Patrol | %1", _debugLines joinString " | "], false, true] call OKS_fnc_LogDebug;
    };
};

[format ["Template Patrol placed (%1) | Units=%2", _sideName, _countCreated], 0, 5, false] call BIS_fnc_3DENNotification;

["OKS_fnc_EdenTemplatePatrol", [_side, _unitCountOverride, _profile], []] call OKS_fnc_EdenRememberLastAction;
true
