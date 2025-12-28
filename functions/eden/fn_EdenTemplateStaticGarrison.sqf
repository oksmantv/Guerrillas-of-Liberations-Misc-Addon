/*
    OKS_fnc_EdenTemplateStaticGarrison

    3DEN helper: Right-click terrain to place a static infantry group template,
    then move as many units as possible into nearby building positions.

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
    ["Template Static Garrison: invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
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

private _radius = ["OKS_3DEN_TEMPLATE_GARRISON_RADIUS", 75] call _readNum;
_radius = (_radius max 5) min 500;

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
    ["Template Static Garrison: failed to create units", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _movedCount = 0;

_created = _created select {!isNull _x};

// Prefer GW's 3DEN helper if present (uses GW_GarrisonRadius mission attribute).
private _gwGarrisonFncName = "";
if (!isNil "GW_3den_fnc_setUnitGarrison") then { _gwGarrisonFncName = "GW_3den_fnc_setUnitGarrison"; };
if (_gwGarrisonFncName isEqualTo "" && {!isNil "GW_3DEN_fnc_setUnitGarrison"}) then { _gwGarrisonFncName = "GW_3DEN_fnc_setUnitGarrison"; };

if (!(_gwGarrisonFncName isEqualTo "")) then {
    private _gwFnc = missionNamespace getVariable [_gwGarrisonFncName, {}];
    if (_debug3DEN) then {
        _debugLines pushBack (format ["calling %1 (units=%2)", _gwGarrisonFncName, count _created]);
    };
    [_p0, _created] call _gwFnc;
    _movedCount = _countCreated;
} else {
    if (_debug3DEN) then {
        _debugLines pushBack "GW garrison function not found; using fallback";
    };
    // Fallback: local building-position garrison.
    private _buildingPositions = [];
    {
        if (!(isObjectHidden _x)) then {
            private _hp = [_x] call BIS_fnc_buildingPositions;
            if ((count _hp) > 0) then {
                _buildingPositions append _hp;
            };
        };
    } forEach (nearestObjects [_p0, ["House"], _radius]);

    _buildingPositions = [_buildingPositions, [], { _p0 distance _x }, "ASCEND"] call BIS_fnc_sortBy;
    _movedCount = (count _buildingPositions) min _countCreated;

    collect3DENHistory {
        {
            if (_forEachIndex >= (count _buildingPositions)) exitWith {};
            private _bp = _buildingPositions select _forEachIndex;
            _x set3DENAttribute ["position", _bp];
            _x set3DENAttribute ["rotation", [0, 0, floor (random 360)]];
        } forEach _created;
    };
};

private _sideName = switch (_side) do {
    case west: {"WEST"};
    case east: {"EAST"};
    case independent: {"INDEPENDENT"};
    default {"UNKNOWN"};
};

if (_debug3DEN) then {
    _debugLines pushBack (format ["side=%1 count=%2 moved=%3 radius=%4", _sideName, _countCreated, _movedCount, _radius]);
    if !(_debugLines isEqualTo []) then {
        [format ["[3DEN] Template Static Garrison | %1", _debugLines joinString " | "], false, true] call OKS_fnc_LogDebug;
    };
};

[format ["Template Static Garrison placed (%1) | Units=%2", _sideName, _countCreated], 0, 5, false] call BIS_fnc_3DENNotification;

["OKS_fnc_EdenTemplateStaticGarrison", [_side, _unitCountOverride], []] call OKS_fnc_EdenRememberLastAction;
true
