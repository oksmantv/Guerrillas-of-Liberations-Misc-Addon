/*
    [_center, _radius, _units, _fillRatio, _debug] spawn OKS_fnc_GarrisonBuildingsInArea;

    Description:
        Finds all buildings within _radius of _center and collects every building
        position using the native buildingPos command (same source ACE uses).
        Positions are sorted by 2D distance from center (closest first), then the
        innermost (fillRatio * 100)% are selected as available garrison slots.
        That inner set is shuffled for random placement within the zone.

        Each unit is sent to its assigned slot via doMove (not teleport), with
        FSM disabled during movement so the unit stays focused on pathing.
        An arrival monitor checks every 0.5 s (mirroring ACE garrisonMove's PFH);
        on arrival, PATH is disabled, FSM re-enabled, and OKS_fnc_Has_Sight is
        called to determine stance:
            exposed (near window)  → setUnitPos "UP"   (stand to shoot out)
            enclosed (inner room)  → setUnitPos "MIDDLE" (crouch, take cover)

        Three doMove retries are attempted before falling back to teleport.

    Parameters:
        0: _center    (ARRAY|OBJECT) - Village/area center position
        1: _radius    (NUMBER)       - Building search radius in meters (default 80)
        2: _units     (ARRAY)        - Units to garrison (should be on foot)
        3: _fillRatio (NUMBER)       - Fraction of slots to use, 0..1 (default 0.75)
        4: _debug     (BOOL)         - Piggyback on ACE's Zeus garrison visualization:
                                       appends move targets to ace_ai_garrison_unitMoveList
                                       so ace_ai_fnc_drawCuratorGarrisonPathing draws a red
                                       line + waypoint icon per unit while Zeus is open.
                                       Lines vanish as each unit arrives. (default false)

    Returns: BOOL - true when units are dispatched, false on early exit

    Notes:
        - Must be spawned (not called) — contains sleep.
        - A building with 12 positions and fillRatio 0.75 yields 9 slots used,
          all in the positions closest to _center.
        - Pass no more units than ceil(totalBuildingPositions * fillRatio); excess
          units are ignored rather than handed off to a fallback.

    Example:
        [
            getPos MyCenter,
            80,
            (units GarrisonGroup) select { alive _x },
            0.75
        ] spawn OKS_fnc_GarrisonBuildingsInArea;
*/

params [
    ["_center",    [0,0,0], [[], objNull]],
    ["_radius",    80,      [0]],
    ["_units",     [],      [[]]],
    ["_fillRatio", 0.75,    [0]],
    ["_debug",     false,   [false]]
];

if (_units isEqualTo []) exitWith { false };
if (_center isEqualType objNull) then { _center = getPosATL _center; };
_fillRatio = (_fillRatio max 0) min 1;

if (_debug) then {
    diag_log format ["[GBA] Start — center=%1 radius=%2m units=%3 fillRatio=%4",
        _center, _radius, count (_units select { alive _x }), _fillRatio];
};

private _buildings = nearestObjects [_center, ["Building"], _radius];
if (_buildings isEqualTo []) exitWith {
    if (_debug) then { diag_log "[GBA] EXIT — no buildings found within radius."; };
    false
};

if (_debug) then {
    diag_log format ["[GBA] %1 building(s) found within %2m.", count _buildings, _radius];
};

// Assign slots by processing buildings nearest-first.
// Per-slot claims are stored on each building object (OKS_GBA_ClaimedPos array)
// so concurrent garrison spawns skip already-claimed positions without blocking
// an entire building. Claims are released after the monitoring loop ends.
private _aliveUnits    = _units select { alive _x };
private _placed        = 0;
private _skippedOccupied = 0;
private _moveList      = []; // [[unit, pos, lastMoveTime, attemptsLeft], ...]
private _touchedBldgs  = []; // buildings where we added claims (for cleanup)

{
    if (_placed >= count _aliveUnits) exitWith {};

    private _bldg          = _x;
    private _bldgPositions = _bldg buildingPos -1;
    if (_bldgPositions isEqualTo []) then { continue };

    // Innermost (fillRatio * 100)% positions, shuffled for random placement within the building.
    _bldgPositions = [_bldgPositions, [], { _x distance2D _center }, "ASCEND"] call BIS_fnc_sortBy;
    private _take     = (ceil (count _bldgPositions * _fillRatio)) max 1;
    private _selected = (_bldgPositions select [0, _take]) call BIS_fnc_arrayShuffle;

    if (_debug) then {
        diag_log format ["[GBA]   Building %1 (%2): %3 positions total, %4 selected (fillRatio %5)",
            _forEachIndex, typeOf _bldg, count _bldgPositions, count _selected, _fillRatio];
    };

    // Retrieve the per-slot claim list stored on this building object.
    // All concurrent garrison spawns share this list, so a slot claimed by
    // spawn A is visible to spawn B before any unit physically moves there.
    private _bldgClaimed = _bldg getVariable ["OKS_GBA_ClaimedPos", []];

    {
        if (_placed >= count _aliveUnits) exitWith {};

        private _slotPos = _x;

        // Skip if another concurrent spawn already claimed this slot.
        if (_slotPos in _bldgClaimed) then {
            _skippedOccupied = _skippedOccupied + 1;
            continue;
        };

        // Skip if physically occupied at the same floor level (later-arriving groups).
        private _slotFloor = if (surfaceIsWater _slotPos) then {
            floor ((AGLToASL _slotPos) select 2)
        } else {
            floor (_slotPos select 2)
        };
        private _occupied = (_slotPos nearEntities ["CAManBase", 2]) select {
            alive _x && {
                private _uFloor = if (surfaceIsWater getPos _x) then {
                    floor ((getPosASL _x) select 2)
                } else {
                    floor ((getPosATL _x) select 2)
                };
                _uFloor == _slotFloor
            }
        };
        if (_occupied isNotEqualTo []) then {
            _skippedOccupied = _skippedOccupied + 1;
            continue;
        };

        // Claim this slot and assign a unit.
        _bldgClaimed pushBack _slotPos;
        _bldg setVariable ["OKS_GBA_ClaimedPos", _bldgClaimed];
        if (!(_bldg in _touchedBldgs)) then { _touchedBldgs pushBack _bldg; };

        private _unit = _aliveUnits select _placed;
        _placed = _placed + 1;
        _moveList pushBack [_unit, _slotPos, time, 3];

    } forEach _selected;

} forEach _buildings;

if (_debug) then {
    diag_log format ["[GBA] Slot assignment done — assigned=%1 occupied/skipped=%2 unitsAvailable=%3 totalBuildings=%4",
        _placed, _skippedOccupied, count _aliveUnits, count _buildings];
};

if (_moveList isEqualTo []) exitWith {
    if (_debug) then { diag_log "[GBA] EXIT — no units were assigned to slots."; };
    false
};

// Issue initial move orders.
// Disable FSM so the combat FSM doesn't interrupt pathing (ACE garrisonMove pattern).
{
    _x params ["_unit", "_pos"];
    _unit enableAI "PATH";
    _unit disableAI "FSM";
    _unit setBehaviour "AWARE";
    doStop _unit;
    _unit doMove _pos;
} forEach _moveList;

if (_debug) then {
    diag_log format ["[GBA] Move orders issued for %1 unit(s). Monitoring arrival...", count _moveList];
};

// Append our targets to ACE's garrison move list. ace_ai_fnc_drawCuratorGarrisonPathing
// runs as a Draw3D EH on the Zeus client and reads this variable every frame, drawing
// a red drawLine3D from each unit to its destination + a drawIcon3D waypoint marker.
// Our format [unit, pos, time, attempts] is compatible — ACE reads only elements 0 and 1.
if (_debug) then {
    private _aceList = missionNamespace getVariable ["ace_ai_garrison_unitMoveList", []];
    { _aceList pushBack _x; } forEach _moveList;
    missionNamespace setVariable ["ace_ai_garrison_unitMoveList", _aceList, true];
};

// --- Arrival monitoring loop ---
// Mirrors ACE garrisonMove's 0.5 s PFH: check distance, retry doMove on stuck units,
// teleport as last resort after three failed attempts.
private _remaining = +_moveList;

while { _remaining isNotEqualTo [] } do {
    sleep 0.5;

    private _toRemove  = [];
    private _failedAll = [];

    {
        _x params ["_unit", "_pos", "_lastMoveTime", "_attemptsLeft"];

        if (!alive _unit) then {
            _toRemove pushBack _x;
            continue;
        };

        private _unitPos = if (surfaceIsWater getPos _unit) then {
            getPosASL _unit
        } else {
            getPosATL _unit
        };

        if (_unitPos distance _pos < 1.5) then {
            // Unit has arrived.
            _toRemove pushBack _x;
        } else {
            if (unitReady _unit && { (time - _lastMoveTime) > 15 }) then {
                if (_attemptsLeft > 0) then {
                    // Retry doMove (unit may have stalled on geometry).
                    _unit doMove _pos;
                    _x set [2, time];
                    _x set [3, _attemptsLeft - 1];
                    if (_debug) then {
                        diag_log format ["[GBA] RETRY doMove for %1 — %2 attempt(s) remaining.", name _unit, _attemptsLeft - 1];
                    };
                } else {
                    // Out of retries — teleport fallback.
                    if (_debug) then {
                        diag_log format ["[GBA] TELEPORT fallback for %1 — doMove exhausted.", name _unit];
                    };
                    _failedAll pushBack _x;
                    _toRemove  pushBack _x;
                };
            };
        };
    } forEach _remaining;

    // Configure each placed unit: stance based on window exposure.
    {
        _x params ["_unit", "_pos"];
        if (!alive _unit) then { continue };

        private _isFailed = (_failedAll findIf { (_x select 0) == _unit }) >= 0;
        if (_isFailed) then {
            doStop _unit;
            _unit setPosATL _pos;
        };

        _unit disableAI "PATH";
        _unit enableAI "FSM";

        // Has_Sight: true = exposed (near window) → stand to shoot out.
        //            false = enclosed (inner room)  → crouch.
        private _exposed = [_unit] call OKS_fnc_Has_Sight;
        _unit setUnitPos (["MIDDLE", "UP"] select _exposed);

        if (_debug) then {
            private _stance  = ["MIDDLE (enclosed)", "UP (window)"] select _exposed;
            private _method  = if (_isFailed) then {"teleport"} else {"doMove"};
            diag_log format ["[GBA] Placed %1 via %2 — stance=%3", name _unit, _method, _stance];
        };

        // Remove this unit from ACE's list — the Zeus line disappears on arrival.
        if (_debug) then {
            private _u = _unit;
            private _aceList = missionNamespace getVariable ["ace_ai_garrison_unitMoveList", []];
            _aceList = _aceList select { (_x select 0) != _u };
            missionNamespace setVariable ["ace_ai_garrison_unitMoveList", _aceList, true];
        };
    } forEach _toRemove;

    // Remove processed entries from remaining.
    {
        private _u = _x select 0;
        _remaining = _remaining select { (_x select 0) != _u };
    } forEach _toRemove;
};

// Units beyond the inner slot count are not placed — size your unit array to match
// the expected slot count (count _aliveUnits <= ceil(totalPositions * _fillRatio)).

// Final cleanup: remove any stale entries we added (e.g. units that died mid-move).
if (_debug) then {
    private _survived = { alive (_x select 0) } count _moveList;
    private _died     = (count _moveList) - _survived;
    diag_log format ["[GBA] Complete — %1/%2 units placed (%3 died during move).",
        _survived, count _moveList, _died];
};
if (_debug) then {
    private _ourUnits = _moveList apply { _x select 0 };
    private _aceList  = missionNamespace getVariable ["ace_ai_garrison_unitMoveList", []];
    _aceList = _aceList select { !(_ourUnits find (_x select 0) >= 0) };
    missionNamespace setVariable ["ace_ai_garrison_unitMoveList", _aceList, true];
};

// Release per-slot claims — units are now physically present (or the monitoring
// loop timed out); future garrison calls will find them via nearEntities directly.
{ _x setVariable ["OKS_GBA_ClaimedPos", nil]; } forEach _touchedBldgs;

true;
