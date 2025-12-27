/*
    OKS_fnc_EdenMarkFrontlineDoubleRect

    Description:
        Creates a paired "frontline" marker set (outer + inner rectangle) for each selected marker.
        The two markers share the same position and angle (parallel/stacked):
          - Outer: deep rectangle using Grid brush
          - Inner: shallow rectangle using Solid brush (non-transparent)

    Parameter(s):
        _width - NUMBER: Marker TOTAL width (edge-to-edge) in meters. Supported presets: 50/100/200/400 (default: 100)
        _side  - STRING: Which color to use ("WEST", "EAST", "GUER")

    Returns:
        NUMBER - Count of marker pairs created

    Example:
        [100, "WEST"] call OKS_fnc_EdenMarkFrontlineDoubleRect;

    Notes:
        - Creates shape markers (rectangle) with empty class name.
        - Depths are hard-coded:
            inner depth: 15m (Eden "Size B")
            outer depth: 100m (Eden "Size B")
*/

params [
    ["_frontlineTotalWidthMeters", 100, [0]],
    ["_frontlineSideName", "WEST", [""]]
];

private _contextMenuData = uiNamespace getVariable ["BIS_fnc_3DENEntityMenu_data", []];
diag_log format ["[OKS][3DEN][FrontlineDoubleRect] called with width=%1 side=%2 menuData=%3", _frontlineTotalWidthMeters, _frontlineSideName, _contextMenuData];

private _allowedWidths = [250, 500, 750, 1000];
private _innerDepth = 15;
private _outerDepth = 60;

// Eden marker size2 is HALF-SIZE (center-to-edge), so convert totals.
private _frontlineHalfWidthMeters = _frontlineTotalWidthMeters / 2;
private _innerHalfDepthMeters = _innerDepth / 2;
private _outerHalfDepthMeters = _outerDepth / 2;

private _markerColorClassName = switch (toUpper _frontlineSideName) do {
    case "WEST": { "ColorWEST" };
    case "EAST": { "ColorEAST" };
    case "GUER": { "ColorGUER" };
    default {
        systemChat format ["Unknown side '%1', defaulting to WEST", _frontlineSideName];
        "ColorWEST"
    };
};

// Get all marker entities from Eden (used for name collision avoidance)
private _allMarkers = all3DENEntities select 5; // Index 5 is markers

// Build a quick list of existing marker names for collision-avoidance
private _existingMarkerNames = [];
{
    private _markerEntity = _x;
    private _markerEntityAsString = str _markerEntity;
    if ((count _markerEntityAsString) >= 2) then {
        private _markerName = _markerEntityAsString select [1, (count _markerEntityAsString) - 2];
        _existingMarkerNames pushBackUnique _markerName;
    };
} forEach _allMarkers;

private _makeUniqueName = {
    params ["_base", "_existing"]; 
    private _candidate = _base;
    private _suffixIndex = 1;
    while { _candidate in _existing } do {
        _candidate = format ["%1_%2", _base, _suffixIndex];
        _suffixIndex = _suffixIndex + 1;
    };
    _existing pushBack _candidate;
    _candidate
};

private _logPrefix = "[OKS][3DEN][FrontlineDoubleRect]";

private _debugLoggingEnabled = true;
private _logDebug = {
    params ["_message", ["_data", []]];
    if (!_debugLoggingEnabled) exitWith {};
    diag_log format ["%1 %2 | %3", _logPrefix, _message, _data];
};

systemChat format ["%1 running (width=%2 side=%3)", _logPrefix, _frontlineTotalWidthMeters, _frontlineSideName];
["running", ["menuData", _contextMenuData, "mouse", get3DENMousePosition, "colorClass", _markerColorClassName]] call _logDebug;

// Map-only enforcement (safe): require a map-click position inside the 3DEN context menu data.
// If this action is triggered outside the map, menuData typically won't contain a valid click position.
private _mapClickPosATL = [];
if (_contextMenuData isEqualType []) then {
    {
        private _menuItem = _x;
        if (_menuItem isEqualType []) then {
            private _parsed = _menuItem call OKS_fnc_EdenPosFromArray;
            if !(_parsed isEqualTo []) exitWith { _mapClickPosATL = _parsed; };
        };
    } forEach _contextMenuData;

    if (_mapClickPosATL isEqualTo []) then {
        private _parsed = _contextMenuData call OKS_fnc_EdenPosFromArray;
        if !(_parsed isEqualTo []) then { _mapClickPosATL = _parsed; };
    };
};

if (_mapClickPosATL isEqualTo []) exitWith {
    ["map-only abort", ["menuData", _contextMenuData, "mouse3DEN", get3DENMousePosition]] call _logDebug;
    if (!isNil "BIS_fnc_3DENNotification") then {
        ["Frontline markers: open the Map in Eden and run this action from the map.", 1, 6, true] call BIS_fnc_3DENNotification;
    } else {
        systemChat "Frontline markers: open the Map in Eden and run this action from the map.";
    };
    0
};

_mapClickPosATL set [2, 0];
_mapClickPosATL = [_mapClickPosATL] call OKS_fnc_EdenSanitizePos;

private _applyRect = {
    params [
        ["_markerEntity", nil],
        ["_markerUniqueName", "", [""]],
        ["_markerColorClassName", "ColorWEST", [""]],
        ["_markerBrushName", "grid", [""]],
        ["_markerHalfDepthMeters", 15, [0]],
        ["_markerHalfWidthMeters", 250, [0]],
        ["_logPrefix", "", [""]]
    ];

    if (isNil "_markerEntity") exitWith {};

    _markerEntity set3DENAttribute ["name", _markerUniqueName];
    _markerEntity set3DENAttribute ["markerName", _markerUniqueName];

    // Minimal, proven-working marker setup:
    // - markerType 0 => rectangle (not ellipse)
    // - baseColor as a string class name (e.g. ColorWEST)
    // - brush set to "grid"/"solid"
    // - size2 with [depth,width]
    // - rotation only (direction hard-coded to 0)
    _markerUniqueName set3DENAttribute ["markerType", 0];
    _markerUniqueName set3DENAttribute ["baseColor", _markerColorClassName];
    _markerUniqueName set3DENAttribute ["alpha", 1];
    _markerUniqueName set3DENAttribute ["brush", toLower _markerBrushName];
    _markerUniqueName set3DENAttribute ["size2", [_markerHalfDepthMeters, _markerHalfWidthMeters]];
    _markerUniqueName set3DENAttribute ["rotation", 0];

    if (_debugLoggingEnabled) then {
        diag_log format [
            "%1 applied marker=%2 name=%3 color=%4 brush=%5 size2=%6",
            _logPrefix,
            _markerEntity,
            _markerUniqueName,
            _markerColorClassName,
            _markerBrushName,
            [_markerHalfDepthMeters, _markerHalfWidthMeters]
        ];
    };
};

private _getContextPosATL = {
    params ["_contextMenuData"]; 

    private _pos = [];

    // Most reliable: scan menuData for a position-like array.
    if (_contextMenuData isEqualType []) then {
        {
            private _menuItem = _x;
            if (_menuItem isEqualType []) then {
                private _parsedPosition = _menuItem call OKS_fnc_EdenPosFromArray;
                if !(_parsedPosition isEqualTo []) exitWith { _pos = _parsedPosition; };
            };
        } forEach _contextMenuData;

        // Sometimes menuData is directly [x,y,z]
        if (_pos isEqualTo []) then {
            private _p = _contextMenuData call OKS_fnc_EdenPosFromArray;
            if !(_p isEqualTo []) then { _pos = _p; };
        };
    };

    // Fallback: mouse position (works in map + 3D depending on cursor focus)
    if (_pos isEqualTo []) then {
        private _mp = get3DENMousePosition;
        if (_mp isEqualType [] && {count _mp >= 2}) then {
            _pos = _mp call OKS_fnc_EdenPosFromArray;
        };
    };

    // Last resort: camera position
    if (_pos isEqualTo []) then {
        private _cam = get3DENCamera;
        _pos = [getPosATL _cam] call OKS_fnc_EdenSanitizePos;
    };

    if (_pos isEqualTo []) exitWith {[]};
    _pos set [2, 0];
    [_pos] call OKS_fnc_EdenSanitizePos
};

// Get selected marker NAMES (strings, not entities)
private _selectedMarkerNames = get3DENSelected "marker";

// If no markers are selected, create at the current 3DEN camera position/direction.
// This makes the tool usable as a pure "spawn markers" action.
if (_selectedMarkerNames isEqualTo []) then {
    private _markerPos = _mapClickPosATL;
    if (_markerPos isEqualTo []) exitWith {
        systemChat "Frontline Double Rectangle: couldn't resolve cursor/click position.";
        ["could not resolve cursor/click position", ["menuData", _contextMenuData, "mouse", get3DENMousePosition]] call _logDebug;
        0
    };

    ["resolved position", _markerPos] call _logDebug;

    // Hard-coded rotation 0 means "vertical" for the user.
    // Offset the thin marker to the WEST (negative X).
    private _offsetDirectionVector = [-1, 0, 0];

    private _outerBase = format ["frontline_fl_outer_%1", _frontlineTotalWidthMeters];
    private _innerBase = format ["frontline_fl_inner_%1", _frontlineTotalWidthMeters];

    private _outerName = [_outerBase, _existingMarkerNames] call _makeUniqueName;
    private _innerName = [_innerBase, _existingMarkerNames] call _makeUniqueName;

    // NOTE (BI Wiki): to create a shape marker, create the marker with empty class name.
    // NOTE (BI Wiki): to create a shape marker, create the marker with empty class name.
    private _outerMarker = create3DENEntity ["Marker", "", _markerPos];
    [_outerMarker, _outerName, _markerColorClassName, "DiagGrid", _outerHalfDepthMeters, _frontlineHalfWidthMeters, _logPrefix] call _applyRect;

    // Place the shallow marker just outside the outer marker edge.
    private _innerOffsetMeters = _outerHalfDepthMeters + _innerHalfDepthMeters;
    private _innerMarkerPos = _markerPos vectorAdd (_offsetDirectionVector vectorMultiply _innerOffsetMeters);
    private _innerMarker = create3DENEntity ["Marker", "", _innerMarkerPos];
    [_innerMarker, _innerName, _markerColorClassName, "SolidFull", _innerHalfDepthMeters, _frontlineHalfWidthMeters, _logPrefix] call _applyRect;

    ["computed", ["outerPos", _markerPos, "innerPos", _innerMarkerPos, "innerOffset", _innerOffsetMeters, "offsetDir", _offsetDirectionVector]] call _logDebug;

    private _createdPairs = if (!isNil "_outerMarker" && !isNil "_innerMarker") then { 1 } else { 0 };
    if (_createdPairs > 0) then {
        systemChat format ["Created %1 frontline marker pair(s) (width=%2m, innerDepth=%3m, outerDepth=%4m, color=%5)", _createdPairs, _frontlineTotalWidthMeters, _innerDepth, _outerDepth, _markerColorClassName];
        ["created pair", ["pos", _markerPos, "width", _frontlineTotalWidthMeters]] call _logDebug;
    } else {
        systemChat "No frontline markers created.";
        ["no markers created (create3DENEntity returned nil?)", []] call _logDebug;
    };
    _createdPairs
};

private _createdPairs = 0;

{
    private _markerName = _x;

    // Find the marker entity from all markers by matching the string representation
    private _markerEntity = objNull;
    private _found = false;
    {
        private _candidateMarkerEntity = _x;
        private _candidateMarkerEntityAsString = str _candidateMarkerEntity;
        private _cleanEntityName = _candidateMarkerEntityAsString select [1, (count _candidateMarkerEntityAsString) - 2];
        if (_cleanEntityName == _markerName) exitWith {
            _markerEntity = _candidateMarkerEntity;
            _found = true;
        };
    } forEach _allMarkers;

    if (!_found) then {
        systemChat format ["Warning: Could not find marker entity for '%1', skipping...", _markerName];
    } else {
        private _posResult = _markerEntity get3DENAttribute "position";
        private _markerPos = if (count _posResult > 0) then { _posResult select 0 } else { [0, 0, 0] };

        private _outerBase = format ["%1_fl_outer_%2", _markerName, _frontlineTotalWidthMeters];
        private _innerBase = format ["%1_fl_inner_%2", _markerName, _frontlineTotalWidthMeters];

        private _outerName = [_outerBase, _existingMarkerNames] call _makeUniqueName;
        private _innerName = [_innerBase, _existingMarkerNames] call _makeUniqueName;

        private _offsetDirectionVector = [-1, 0, 0];

        // Outer marker (grid)
        private _outerMarker = create3DENEntity ["Marker", "", _markerPos];
        [_outerMarker, _outerName, _markerColorClassName, "grid", _outerHalfDepthMeters, _frontlineHalfWidthMeters, _logPrefix] call _applyRect;

        // Inner marker (solid) placed just outside outer edge
        private _innerOffsetMeters = _outerHalfDepthMeters + _innerHalfDepthMeters;
        private _innerMarkerPos = _markerPos vectorAdd (_offsetDirectionVector vectorMultiply _innerOffsetMeters);
        private _innerMarker = create3DENEntity ["Marker", "", _innerMarkerPos];
        [_innerMarker, _innerName, _markerColorClassName, "solid", _innerHalfDepthMeters, _frontlineHalfWidthMeters, _logPrefix] call _applyRect;

        ["computed", ["outerPos", _markerPos, "innerPos", _innerMarkerPos, "innerOffset", _innerOffsetMeters, "offsetDir", _offsetDirectionVector]] call _logDebug;

        if (!isNil "_outerMarker" && !isNil "_innerMarker") then {
            _createdPairs = _createdPairs + 1;
            systemChat format ["Created frontline pair '%1' + '%2'", _outerName, _innerName];
        };
    };
} forEach _selectedMarkerNames;

if (_createdPairs > 0) then {
    systemChat format ["Created %1 frontline marker pair(s) (width=%2m, innerDepth=%3m, outerDepth=%4m, color=%5)", _createdPairs, _frontlineTotalWidthMeters, _innerDepth, _outerDepth, _markerColorClassName];
} else {
    systemChat "No frontline markers created.";
};

_createdPairs
