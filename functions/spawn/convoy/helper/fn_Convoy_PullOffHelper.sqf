/*
    OKS_fnc_Convoy_PullOffHelper
    Generic helper for making convoy vehicles pull off the road to a specified offset (left/right/ahead),
    with options for formation and behavior. Used by both AA and ambush/formation logic.
    
    Params:
        0: _vehicle (Object) - The vehicle to move
        1: _offset (Array) - [distanceAhead, lateralOffset] in meters
        2: _behavior (String) - AI behavior (e.g., "AWARE", "COMBAT")
        3: _combatMode (String) - AI combat mode (e.g., "YELLOW", "RED")
        4: _debug (Bool) - Enable debug logs
        5: _customVars (HashMap) - Optional, custom variables to set on vehicle/group

    Example usage:
        [_vehicle, [50, 18], "AWARE", "YELLOW", true, ["OKS_Convoy_AAEngaging", true]] call OKS_fnc_Convoy_PullOffHelper;
*/

params ["_vehicle", "_offset", "_behavior", "_combatMode", ["_debug", false], ["_customVars", []], ["_pullOffMaxSlopeDeg", 15], ["_pullOffMinRoadDist", 10]];

if (isNull _vehicle || {!canMove _vehicle}) exitWith {};
private _group = group _vehicle;
private _pos = getPosATL _vehicle;
private _dir = getDir _vehicle;
private _ahead = _offset select 0;
private _side = _offset select 1;

// Compute candidate positions
private _posAhead = [
    (_pos select 0) + _ahead * (sin _dir),
    (_pos select 1) + _ahead * (cos _dir),
    (_pos select 2)
];
private _leftDir = _dir - 90;
private _rightDir = _dir + 90;
private _leftPos = [(_posAhead select 0) + abs _side * (sin _leftDir), (_posAhead select 1) + abs _side * (cos _leftDir), _posAhead select 2];
private _rightPos = [(_posAhead select 0) + abs _side * (sin _rightDir), (_posAhead select 1) + abs _side * (cos _rightDir), _posAhead select 2];
private _pullOffPos = _posAhead;
private _sideChosen = "ahead";

// Try left, then right, then ahead
if ((!([_leftPos, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_leftPos, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) then {
    _pullOffPos = _leftPos;
    _sideChosen = "left";
} else {
    if ((!([_rightPos, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_rightPos, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) then {
        _pullOffPos = _rightPos;
        _sideChosen = "right";
    };
};

// If pull-off equals current location (no offset possible), force a short forward move to avoid blocking
if (_pullOffPos distance2D _pos < 6) then {
    private _posShortAhead = [
        (_pos select 0) + 20 * (sin _dir),
        (_pos select 1) + 20 * (cos _dir),
        (_pos select 2)
    ];
    private _leftShort = [(_posShortAhead select 0) + abs _side * 0.7 * (sin _leftDir), (_posShortAhead select 1) + abs _side * 0.7 * (cos _leftDir), _posShortAhead select 2];
    private _rightShort = [(_posShortAhead select 0) + abs _side * 0.7 * (sin _rightDir), (_posShortAhead select 1) + abs _side * 0.7 * (cos _rightDir), _posShortAhead select 2];
    if (!([_leftShort, 7] call OKS_fnc_Convoy_IsBlocked)) then {
        _pullOffPos = _leftShort;
        _sideChosen = "left-short";
    } else {
        if (!([_rightShort, 7] call OKS_fnc_Convoy_IsBlocked)) then {
            _pullOffPos = _rightShort;
            _sideChosen = "right-short";
        } else {
            _pullOffPos = _posShortAhead;
            _sideChosen = "ahead-short";
        };
    };
};

// Extra nudge further off-road along the chosen lateral direction if possible (adds ~5m more margin)
if (!(_pullOffPos isEqualTo _posAhead)) then {
    private _useLeft = (_pullOffPos distance2D _leftPos) <= (_pullOffPos distance2D _rightPos);
    private _nudgeDir = if (_useLeft) then {_leftDir} else {_rightDir};
    private _nudged = [
        (_pullOffPos select 0) + 6.5 * (sin _nudgeDir),
        (_pullOffPos select 1) + 6.5 * (cos _nudgeDir),
        (_pullOffPos select 2)
    ];
    if ((!([_nudged, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_nudged, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) then { _pullOffPos = _nudged; };
    // Enforce minimum distance from road after nudge
    _pullOffPos = [_pullOffPos, _nudgeDir, _pullOffMinRoadDist] call OKS_fnc_Convoy_EnsureMinRoadDistance;
};


// Ensure the pull-off is not on the road; if it is, step laterally further until off-road or try the other side
private _foundSafe = false;
if (isOnRoad _pullOffPos) then {
    private _tryDir = if ((_pullOffPos distance2D _leftPos) <= (_pullOffPos distance2D _rightPos)) then { _leftDir } else { _rightDir };
    private _fixed = false;
    {
        private _candidate = [
            (_pullOffPos select 0) + _x * (sin _tryDir),
            (_pullOffPos select 1) + _x * (cos _tryDir),
            (_pullOffPos select 2)
        ];
        if ((!([_candidate, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_candidate] call OKS_fnc_Convoy_IsOffRoad) && ([_candidate, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) exitWith { _pullOffPos = _candidate; _fixed = true; _foundSafe = true; };
    } forEach [5,10,15,20,25];
    if (!_fixed) then {
        // Try opposite lateral
        private _altDir = if (_tryDir isEqualTo _leftDir) then { _rightDir } else { _leftDir };
        {
            private _candidate2 = [
                (_pullOffPos select 0) + _x * (sin _altDir),
                (_pullOffPos select 1) + _x * (cos _altDir),
                (_pullOffPos select 2)
            ];
            if ((!([_candidate2, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_candidate2] call OKS_fnc_Convoy_IsOffRoad) && ([_candidate2, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) exitWith { _pullOffPos = _candidate2; _fixed = true; _foundSafe = true; };
        } forEach [5,10,15,20,25];
    };
    if (!_fixed) then {
        // Last resort: move a bit further forward and re-check lateral 15m
        private _posAheadFurther = [
            (_pullOffPos select 0) + 15 * (sin _dir),
            (_pullOffPos select 1) + 15 * (cos _dir),
            (_pullOffPos select 2)
        ];
        private _candidateLeft = [(_posAheadFurther select 0) + 15 * (sin _leftDir), (_posAheadFurther select 1) + 15 * (cos _leftDir), _posAheadFurther select 2];
        private _candidateRight = [(_posAheadFurther select 0) + 15 * (sin _rightDir), (_posAheadFurther select 1) + 15 * (cos _rightDir), _posAheadFurther select 2];
        if ((!([_candidateLeft, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_candidateLeft] call OKS_fnc_Convoy_IsOffRoad) && ([_candidateLeft, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) then { _pullOffPos = _candidateLeft; _fixed = true; _foundSafe = true; };
        if (!_fixed && (!([_candidateRight, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_candidateRight] call OKS_fnc_Convoy_IsOffRoad) && ([_candidateRight, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) then { _pullOffPos = _candidateRight; _fixed = true; _foundSafe = true; };
        if (!_fixed) then { _pullOffPos = _posAheadFurther; };
    };
    // Enforce minimum distance from road after lateral stepping
    private _finalLatDir = if ((_pullOffPos distance2D _leftPos) <= (_pullOffPos distance2D _rightPos)) then { _leftDir } else { _rightDir };
    _pullOffPos = [_pullOffPos, _finalLatDir, _pullOffMinRoadDist] call OKS_fnc_Convoy_EnsureMinRoadDistance;
    if (_debug) then {
        format ["[CONVOY-PULLOFF] Pull-off adjusted off-road. Pos: %1", _pullOffPos] spawn OKS_fnc_LogDebug;
    };
    _foundSafe = _fixed;
};

// Fallback: spiral/grid search for a safe spot if all above failed
if (!_foundSafe) then {
    private _searchRadius = 20;
    private _searchStep = 7;
    private _maxRadius = 60;
    private _angleStep = 30;
    private _safeFound = false;
    for [{_r = _searchRadius}, {_r <= _maxRadius && !_safeFound}, {_r = _r + _searchStep}] do {
        for [{_a = 0}, {_a < 360 && !_safeFound}, {_a = _a + _angleStep}] do {
            private _rad = _a * 0.0174533;
            private _candidate = [
                (_pos select 0) + _r * (sin _rad),
                (_pos select 1) + _r * (cos _rad),
                (_pos select 2)
            ];
            if (
                (!([_candidate, 7] call OKS_fnc_Convoy_IsBlocked)) &&
                ([_candidate] call OKS_fnc_Convoy_IsOffRoad) &&
                ([_candidate, _pullOffMaxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)
            ) exitWith {
                _pullOffPos = _candidate;
                _safeFound = true;
            };
        };
    };
    if (!_safeFound && _debug) then {
        format ["[CONVOY-PULLOFF] Fallback: No safe spot found in spiral search, using original position: %1", _pos] spawn OKS_fnc_LogDebug;
    };
    if (_safeFound && _debug) then {
        format ["[CONVOY-PULLOFF] Fallback: Safe spot found at %1", _pullOffPos] spawn OKS_fnc_LogDebug;
    };
};

if (_debug) then {
    format ["[CONVOY-PULLOFF] %1 moving to %2 (side: %3, beh: %4, mode: %5)", _vehicle, _pullOffPos, _sideChosen, _behavior, _combatMode] spawn OKS_fnc_LogDebug;
};

// Assign waypoint or doMove
private _wp = _group addWaypoint [_pullOffPos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 8;
_wp setWaypointSpeed "FULL";
_group setBehaviour _behavior;
_group setCombatMode _combatMode;

// Optionally set custom variables
{
    _vehicle setVariable [_x select 0, _x select 1, true];
} forEach _customVars;

if (_debug && isNil "_pullOffPos") then {
    format ["[CONVOY-PULLOFF] Failed to get _pullOffPos"] spawn OKS_fnc_LogDebug;
};

_pullOffPos
