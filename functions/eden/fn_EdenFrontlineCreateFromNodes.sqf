/*
    OKS_fnc_EdenFrontlineCreateFromNodes

    Builds a continuous Frontline (double-rectangle markers) between numbered Logic nodes.

    Nodes:
      - Must be Logic entities named: FLN_<SIDE>_<N>
        Example: FLN_WEST_1, FLN_WEST_2, FLN_WEST_3
      - Linking is done strictly by N (sorted ascending).

    Usage:
      ['WEST'] call OKS_fnc_EdenFrontlineCreateFromNodes;
      ['WEST', true] call OKS_fnc_EdenFrontlineCreateFromNodes; // rounded corners approximation

    Notes / realism:
      - Eden markers are rectangles; "smooth" curves are approximated by many short segments.
      - This is feasible in SQF, but a long curved frontline will create lots of markers.
      - Running this twice creates duplicates by design (user deletes old ones).
*/

params [
    ["_sideName", "WEST", [""]],
    ["_roundCorners", true, [true]],
    ["_cornerRadius", 30, [0]],
    ["_segmentsPer90", 3, [0]]
];

if (!is3DEN) exitWith {0};

private _dbg = uiNamespace getVariable ["OKS_3DEN_DEBUG_FRONTLINE", true];
if (_dbg) then {
    diag_log format [
        "[OKS][3DEN][FrontlineNodes][Create] start | side=%1 round=%2 radius=%3 segPer90=%4",
        _sideName,
        _roundCorners,
        _cornerRadius,
        _segmentsPer90
    ];
};

private _sideKey = toUpper _sideName;
if !(_sideKey in ["WEST", "EAST", "GUER", "INDEPENDENT"]) then { _sideKey = "WEST"; };

if (_dbg) then { diag_log format ["[OKS][3DEN][FrontlineNodes][Create] normalized sideKey=%1", _sideKey]; };

private _markerColorClassName = switch (_sideKey) do {
    case "WEST": { "ColorWEST" };
    case "EAST": { "ColorEAST" };
    case "GUER": { "ColorGUER" };
    case "INDEPENDENT": { "ColorGUER" };
    default { "ColorWEST" };
};

private _innerDepth = 15;
private _outerDepth = 60;
private _innerHalfDepth = _innerDepth / 2;
private _outerHalfDepth = _outerDepth / 2;
private _innerOffset = _innerHalfDepth + _outerHalfDepth;

private _isFrontlineNodeName = {
    params ["_n"]; 
    if !(_n isEqualType "") exitWith {false};
    private _u = toUpper _n;
    private _pfx = format ["FLN_%1_", _sideKey];
    if ((_u find _pfx) isEqualTo 0) exitWith {true};
    if (_sideKey isEqualTo "INDEPENDENT") exitWith {(_u find "FLN_GUER_") isEqualTo 0};
    false
};

private _parseNodeIndex = {
    params ["_n"]; 
    private _parts = (toUpper _n) splitString "_";
    if ((count _parts) < 3) exitWith {-1};
    parseNumber (_parts select ((count _parts) - 1))
};

// Gather nodes
private _nodes = [];
{
    private _logic = _x;
    private _name = (_logic get3DENAttribute "name") select 0;
    if !([_name] call _isFrontlineNodeName) then { continue; };

    private _idx = [_name] call _parseNodeIndex;
    if (_idx < 1) then { continue; };

    private _pos = getPosATL _logic;
    _pos set [2, 0];

    _nodes pushBack [_idx, _pos, _logic];

    if (_dbg) then {
        diag_log format ["[OKS][3DEN][FrontlineNodes][Create] node | name=%1 idx=%2 pos=%3 logic=%4", _name, _idx, _pos, _logic];
    };
} forEach (all3DENEntities select 3);

if (_dbg) then { diag_log format ["[OKS][3DEN][FrontlineNodes][Create] nodesFound=%1", count _nodes]; };

if ((count _nodes) < 2) exitWith {
    [format ["Frontline: need at least 2 nodes for %1 (found %2)", _sideKey, count _nodes], 1, 6, true] call BIS_fnc_3DENNotification;
    0
};

_nodes sort true;

if (_dbg) then {
    private _sortedSummary = _nodes apply {[_x select 0, _x select 1]};
    diag_log format ["[OKS][3DEN][FrontlineNodes][Create] nodesSorted=%1", _sortedSummary];
};

// Build an ordered point list, optionally replacing sharp corners with an arc approximation.
private _points = [];
{
    _x params ["_idx", "_pos"]; // ignore logic handle
    _points pushBack _pos;
} forEach (_nodes apply {[_x select 0, _x select 1]});

if (_dbg) then { diag_log format ["[OKS][3DEN][FrontlineNodes][Create] basePoints=%1", _points]; };

private _normalizeAngle = {
    params ["_a"]; 
    private _x = _a % 360;
    if (_x < 0) then { _x = _x + 360; };
    _x
};

private _angleDeltaSigned = {
    params ["_from", "_to"]; 
    private _a = [_from] call _normalizeAngle;
    private _b = [_to] call _normalizeAngle;
    private _d = _b - _a;
    if (_d > 180) then { _d = _d - 360; };
    if (_d < -180) then { _d = _d + 360; };
    _d
};

private _forwardVec = {
    params ["_dirDeg"]; 
    [sin _dirDeg, cos _dirDeg, 0]
};

private _dirTo = {
    params ["_a", "_b"]; 
    if (!isNil "BIS_fnc_dirTo") exitWith { [_a, _b] call BIS_fnc_dirTo };
    private _dx = (_b select 0) - (_a select 0);
    private _dy = (_b select 1) - (_a select 1);
    (_dx atan2 _dy)
};

// Indices into final _points[] where the segment starting at that index is a corner "bridge"
// produced by rounding/beveling. Used to selectively widen only those segments.
private _bridgeSegmentStarts = [];

if (_roundCorners) then {
    private _r = _cornerRadius max 0;
    private _kPer90 = _segmentsPer90 max 1; // parameter kept for menu compatibility

    if (_r > 0 && {(count _points) >= 3}) then {
        private _rounded = [];
        _rounded pushBack (_points select 0);

        for "_i" from 1 to ((count _points) - 2) do {
            private _pPrev = _points select (_i - 1);
            private _p = _points select _i;
            private _pNext = _points select (_i + 1);

            private _dPrev = [_p, _pPrev] call _dirTo;
            private _dNext = [_p, _pNext] call _dirTo;

            private _lenPrev = _p distance2D _pPrev;
            private _lenNext = _p distance2D _pNext;

            private _t = _r;
            _t = _t min ((_lenPrev / 2) - 0.1);
            _t = _t min ((_lenNext / 2) - 0.1);

            if (_dbg) then {
                diag_log format [
                    "[OKS][3DEN][FrontlineNodes][Create] corner | i=%1 p=%2 dPrev=%3 dNext=%4 lenPrev=%5 lenNext=%6 t=%7",
                    _i,
                    _p,
                    _dPrev,
                    _dNext,
                    _lenPrev,
                    _lenNext,
                    _t
                ];
            };

            if (_t <= 0.5) then {
                _rounded pushBack _p;
            } else {
                // Use the incoming heading (prev -> p) and outgoing heading (p -> next)
                // for correct corner orientation.
                private _dIn = [_pPrev, _p] call _dirTo;
                private _dOut = [_p, _pNext] call _dirTo;

                // Tangency points: move back along incoming and forward along outgoing.
                private _a = _p vectorAdd (([_dIn] call _forwardVec) vectorMultiply (-_t));
                private _b = _p vectorAdd (([_dOut] call _forwardVec) vectorMultiply _t);

                _rounded pushBack _a;
                // Single bridge segment between _a and _b.
                // Record its start index so we can widen it (25%) during marker creation.
                _bridgeSegmentStarts pushBack ((count _rounded) - 1);

                if (_dbg) then {
                    private _delta = [_dIn, _dOut] call _angleDeltaSigned;
                    diag_log format [
                        "[OKS][3DEN][FrontlineNodes][Create] corner bevel | i=%1 dIn=%2 dOut=%3 delta=%4 t=%5 (segPer90=%6 ignored)",
                        _i,
                        _dIn,
                        _dOut,
                        _delta,
                        _t,
                        _kPer90
                    ];
                };

                _rounded pushBack _b;
            };
        };

        _rounded pushBack (_points select ((count _points) - 1));
        _points = _rounded;
    };
};

if (_dbg) then { diag_log format ["[OKS][3DEN][FrontlineNodes][Create] finalPoints=%1", _points]; };

// Build list of existing marker names for collision-avoidance
private _allMarkers = all3DENEntities select 5;
private _existingMarkerNames = [];
{
    private _s = str _x;
    if ((count _s) >= 2) then {
        _existingMarkerNames pushBackUnique (_s select [1, (count _s) - 2]);
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

private _applyRectMarker = {
    params [
        ["_markerEntity", nil],
        ["_markerUniqueName", "", [""]],
        ["_markerColorClassName", "ColorWEST", [""]],
        ["_markerBrushName", "grid", [""]],
        ["_halfDepth", 15, [0]],
        ["_halfWidth", 100, [0]],
        ["_rot", 0, [0]]
    ];

    if (isNil "_markerEntity") exitWith {false};

    _markerEntity set3DENAttribute ["name", _markerUniqueName];
    _markerEntity set3DENAttribute ["markerName", _markerUniqueName];

    // Eden markers can be finicky about whether attributes are applied via the 3DEN marker entity
    // handle or via the marker NAME string. Our older, known-working save point used the name.
    // To be robust across Eden versions/mod contexts we apply to BOTH.
    private _brush = switch (toUpper _markerBrushName) do {
        case "GRID": { "DiagGrid" };
        case "DIAGGRID": { "DiagGrid" };
        case "SOLID": { "SolidFull" };
        case "SOLIDFULL": { "SolidFull" };
        default { _markerBrushName };
    };

    {
        _x set3DENAttribute ["markerType", 0];
        _x set3DENAttribute ["baseColor", _markerColorClassName];
        _x set3DENAttribute ["alpha", 1];
        _x set3DENAttribute ["brush", _brush];
        _x set3DENAttribute ["size2", [_halfDepth, _halfWidth]];
        _x set3DENAttribute ["rotation", _rot];
    } forEach [_markerEntity, _markerUniqueName];
    true
};

// Prevent ultra-short segments from creating a visually stacked blob.
// Lowered to allow the (few) corner-bridge segments to be created.
private _minSegmentLength = 10;

private _createdPairs = 0;

private _aoLayer = ["Area of Operations Markers"] call OKS_fnc_EdenGetOrCreateLayer;
private _aoLayerValid = (_aoLayer isEqualType 0 && {_aoLayer >= 0}) || {(_aoLayer isEqualType objNull) && {!isNull _aoLayer}};

// Segment creation
for "_i" from 0 to ((count _points) - 2) do {
    private _a = _points select _i;
    private _b = _points select (_i + 1);

    private _len = _a distance2D _b;
    if (_len < _minSegmentLength) then {
        if (_dbg) then {
            diag_log format [
                "[OKS][3DEN][FrontlineNodes][Create] seg skip (too short) | i=%1 len=%2 a=%3 b=%4 min=%5",
                _i,
                _len,
                _a,
                _b,
                _minSegmentLength
            ];
        };
        continue;
    };

    private _dir = [_a, _b] call _dirTo;
    private _mid = [
        ((_a select 0) + (_b select 0)) / 2,
        ((_a select 1) + (_b select 1)) / 2,
        0
    ];

    private _dirVec = [_dir] call _forwardVec;
    private _left = [-(_dirVec select 1), (_dirVec select 0), 0];

    private _outerPos = _mid;
    private _innerPos = _mid vectorAdd (_left vectorMultiply _innerOffset);

    private _outerNameBase = format ["FLNSEG_%1_%2_OUTER", _sideKey, (_i + 1)];
    private _innerNameBase = format ["FLNSEG_%1_%2_INNER", _sideKey, (_i + 1)];
    private _outerName = [_outerNameBase, _existingMarkerNames] call _makeUniqueName;
    private _innerName = [_innerNameBase, _existingMarkerNames] call _makeUniqueName;

    private _halfWidth = (_len / 2);
    // Widen only the corner bridge segments (single bevel segment) by 25% to hide gaps.
    if (_i in _bridgeSegmentStarts) then {
        _halfWidth = _halfWidth * 1.25;
        if (_dbg) then {
            diag_log format ["[OKS][3DEN][FrontlineNodes][Create] seg widen (bridge) | i=%1 halfWidth=%2", _i, _halfWidth];
        };
    };

    if (_dbg) then {
        diag_log format [
            "[OKS][3DEN][FrontlineNodes][Create] seg | i=%1 a=%2 b=%3 len=%4 dir=%5 mid=%6 left=%7 innerOffset=%8 outerPos=%9 innerPos=%10 outerName=%11 innerName=%12",
            _i,
            _a,
            _b,
            _len,
            _dir,
            _mid,
            _left,
            _innerOffset,
            _outerPos,
            _innerPos,
            _outerName,
            _innerName
        ];
    };

    private _outerEnt = create3DENEntity ["Marker", "", _outerPos];
    private _innerEnt = create3DENEntity ["Marker", "", _innerPos];

    if (_aoLayerValid) then {
        [_outerEnt, _aoLayer] call OKS_fnc_EdenSetLayerSafe;
        [_innerEnt, _aoLayer] call OKS_fnc_EdenSetLayerSafe;
    };

    if (_dbg) then {
        diag_log format ["[OKS][3DEN][FrontlineNodes][Create] created markers | outerEnt=%1 innerEnt=%2", _outerEnt, _innerEnt];
    };

    private _okOuter = [_outerEnt, _outerName, _markerColorClassName, "DiagGrid", _outerHalfDepth, _halfWidth, _dir] call _applyRectMarker;
    private _okInner = [_innerEnt, _innerName, _markerColorClassName, "SolidFull", _innerHalfDepth, _halfWidth, _dir] call _applyRectMarker;

    if (_dbg) then {
        diag_log format [
            "[OKS][3DEN][FrontlineNodes][Create] applied attrs | okOuter=%1 okInner=%2 color=%3 halfWidth=%4",
            _okOuter,
            _okInner,
            _markerColorClassName,
            _halfWidth
        ];
    };

    if (_okOuter && _okInner) then { _createdPairs = _createdPairs + 1; };
};

if (_dbg) then { diag_log format ["[OKS][3DEN][FrontlineNodes][Create] done | createdPairs=%1", _createdPairs]; };

systemChat format ["Frontline built for %1: %2 segment pair(s)", _sideKey, _createdPairs];

// Delete the nodes we just used, so the user can immediately start a new line for the same side.
if (_createdPairs > 0) then {
    private _toDelete = _nodes apply { _x select 2 };
    delete3DENEntities _toDelete;
    if (_dbg) then { diag_log format ["[OKS][3DEN][FrontlineNodes][Create] deleted nodes | count=%1 nodes=%2", count _toDelete, _toDelete]; };
    systemChat format ["Frontline nodes cleared for %1 (%2 deleted)", _sideKey, count _toDelete];
};

_createdPairs
