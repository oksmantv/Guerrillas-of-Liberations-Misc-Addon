/*
    Function: OKS_fnc_InterceptHvtTask

    Description:
    Spawns an HVT with guards, inserts units directly into convoy vehicles,
     and runs an intercept task that can resolve by capture or capture-or-kill.
     Optional extraction site turns the task into a two-phase objective where surrender
     is required first and then transport on foot to extraction.

     Parameters:
     0: _spawnPos (ARRAY|OBJECT)
         HVT anchor spawn position.
     1: _endPos (ARRAY|OBJECT)
         Destination used for movement and end behavior.
         When passed as an OBJECT, its facing direction is used as the convoy's
         approach direction for overflow vehicle parking road-walk.
         Orient the object to face the direction of travel (toward the destination).
         The road walk will step backward in the opposite direction (toward spawn).
     2: _side (SIDE|ARRAY)
         Either a single side for both or [hvtSide, guardSide]. Sides must be friendly.
     3: _endBehavior (STRING)
         "DISAPPEAR" or "GARRISON".
     4: _designatedVehicle (OBJECT|ARRAY)
         Optional vehicle input. Accepts one object (legacy) or ordered array.
         Array semantics: [mainVehicle, overflowVehicle1, overflowVehicle2, ...].
     5: _delay (NUMBER|ARRAY)
         Escort follow delay in seconds, or [min,max] random range. Default 180.
         Main HVT vehicle moves immediately; overflow/escort vehicles wait this long before following.
     6: _guardData (ARRAY)
         [guardCount, surrenderThresholdPercent, convoySpeedKmh].
         convoySpeedKmh caps the convoy driving speed via forceSpeed. Default 50. Pass 0 to disable.
     7: _taskData (ARRAY)
         [showTaskPosition, taskParentId, showVehicleType, hvtProfileImagePath].
     8: _failOnKill (BOOL|STRING legacy)
         Primary mode bool. true = capture (HVT death fails), false = capture-or-kill.
         Legacy strings still accepted: "CAPTURE", "CAPTUREORKILL", "KILL".
     9: _extractionSite (NIL|ARRAY|OBJECT)
         Optional extraction objective. If set, completion requires surrendered HVT
         on foot within 50m of extraction.

    Returns: HVT unit object (or objNull on failure)

    Notes:
    The provided spawn position is the HVT anchor point used for initial unit spawn and
    fallback vehicle selection. Units are placed directly into assigned convoy vehicles.
    The returned HVT unit can be customized (name/face/loadout) by caller code; the
    main task profile text is assembled later after movement starts.

    Example:
    [
        getPosATL SpawnLogic,
        getPosATL EndLogic,
        [east, east],
        "GARRISON",
        objNull,
        [120, 240],
        [8, 30, 50],
        [true, "MainTask", true, ""],
        true,
        nil
    ] call OKS_fnc_InterceptHvtTask;
*/

if (!isServer) exitWith {
    if (missionNamespace getVariable ["GOL_HVT_Debug", false]) then {
        "[INTERCEPT HVT] fn_InterceptHvtTask ignored: called on non-server machine." call OKS_fnc_LogDebug;
    };
    objNull
};

params [
    ["_spawnPos", [0,0,0], [[], objNull]],
    ["_endPos", [0,0,0], [[], objNull]],
    ["_side", east, [sideUnknown, []]],
    ["_endBehavior", "DISAPPEAR", [""]],
    ["_designatedVehicle", objNull, [objNull, []]],
    ["_delay", 180, [0, []]],
    ["_guardData", [6, 35, 50], [[]]],  
    ["_taskData", [true, "", true, ""], [[]]],
    ["_failOnKill", true, [true, ""]],
    ["_extractionSite", nil]
];

private _hvtDebug = missionNamespace getVariable ["GOL_HVT_Debug", false];

if (_hvtDebug) then {
    "[INTERCEPT HVT] fn_InterceptHvtTask entered." call OKS_fnc_LogDebug;
};

private _spawnPosition = if (_spawnPos isEqualType objNull) then {getPosATL _spawnPos} else {_spawnPos};
private _endPosition = if (_endPos isEqualType objNull) then {getPosATL _endPos} else {_endPos};
// When _endPos is a placed object, capture its facing as the convoy's approach direction.
// Orient the object to face the direction of travel (toward the destination).
// The road walk inverts this (+180) to step backward toward spawn.
// Value -1 means no explicit direction — fall back to local per-hop bearing toward spawn.
private _convoyApproachDir = if (_endPos isEqualType objNull && {!isNull _endPos}) then {(getDir _endPos + 180) % 360} else {-1};

private _hvtSide = _side;
private _guardSide = _side;
if (_side isEqualType []) then {
    _hvtSide = _side param [0, sideUnknown, [sideUnknown]];
    _guardSide = _side param [1, sideUnknown, [sideUnknown]];
};

if (
    _hvtSide isEqualTo sideUnknown ||
    _guardSide isEqualTo sideUnknown ||
    (_hvtSide getFriend _guardSide) < 0.6 ||
    (_guardSide getFriend _hvtSide) < 0.6
) exitWith {
    format ["[INTERCEPT HVT] Invalid side relation. HVT side=%1 Guard side=%2", _hvtSide, _guardSide] call OKS_fnc_LogDebug;
    objNull
};

private _hvtClass = switch (_hvtSide) do {
    case west: {"B_officer_F"};
    case east: {"O_officer_F"};
    case independent: {"I_officer_F"};
    case civilian: {"C_man_1"};
    default {"O_officer_F"};
};

_guardData params [
    ["_guardCount", 6, [0]],
    ["_surrenderThresholdPct", 35, [0]],
    ["_convoySpeedKmh", 50, [0]]
];
_guardCount = _guardCount max 0;
_surrenderThresholdPct = (_surrenderThresholdPct max 0) min 100;
// Convert km/h → m/s. Pass 0 to disable speed cap (-1 = forceSpeed default/unlimited).
private _convoySpeedMS = if (_convoySpeedKmh > 0) then {_convoySpeedKmh / 3.6} else {-1};

_taskData params [
    ["_showTaskPosition", true, [false]],
    ["_taskParent", "", [""]],
    ["_showVehicleType", true, [false]],
    ["_hvtProfileImagePath", "", [""]]
];

// Primary mode is now bool: true=Capture (kill fails), false=CaptureOrKill (kill succeeds).
// Backward compatibility: accept old string mode in this same slot.
private _killFailsTask = true;
if (_failOnKill isEqualType "") then {
    private _legacyMode = toUpperANSI _failOnKill;
    _killFailsTask = !(_legacyMode in ["CAPTUREORKILL", "CAPTURE_OR_KILL", "KILL"]);
    if (_hvtDebug) then {
        "[INTERCEPT HVT] Legacy mode string detected. Prefer bool FailOnKill (true/false)." call OKS_fnc_LogDebug;
    };
} else {
    _killFailsTask = _failOnKill;
};

private _hasExtraction = false;
private _extractionPos = [0,0,0];
if (!isNil "_extractionSite") then {
    if (_extractionSite isEqualType objNull) then {
        if (!isNull _extractionSite) then {
            _hasExtraction = true;
            _extractionPos = getPosATL _extractionSite;
        };
    } else {
        if (_extractionSite isEqualType []) then {
            if ((count _extractionSite) >= 2) then {
                _hasExtraction = true;
                _extractionPos = _extractionSite;
            };
        };
    };
};

private _waitDelay = 180;
if (_delay isEqualType 0) then {
    _waitDelay = _delay max 0;
};
if (_delay isEqualType []) then {
    private _from = _delay param [0, 180, [0]];
    private _to = _delay param [1, _from, [0]];
    if (_to < _from) then {
        private _tmp = _from;
        _from = _to;
        _to = _tmp;
    };
    _waitDelay = _from + random (_to - _from);
};

private _taskSettings = [_guardSide] call OKS_fnc_Task_Settings;
_taskSettings params [
    ["_leaders", []],
    ["_units", []]
];

if (_leaders isEqualTo [] || {_units isEqualTo []}) exitWith {
    format ["[INTERCEPT HVT] Missing guard class settings for side %1", _guardSide] call OKS_fnc_LogDebug;
    objNull
};

private _guardGroup = createGroup [_guardSide, true];
_guardGroup setVariable ["lambs_danger_disableGroupAI", true, true];

// Create group leader first (Colonel rank) to establish hierarchy and prevent HVT from becoming leader
private _leaderUnit = _guardGroup createUnit [selectRandom _leaders, _spawnPosition, [], 0, "NONE"];
_leaderUnit setRank "COLONEL";
_leaderUnit setVariable ["GOL_HVT_Guard", true, true];

// Create HVT as second unit (subordinate, not group leader)
private _hvtUnit = _guardGroup createUnit [_hvtClass, _spawnPosition, [], 0, "NONE"];
_hvtUnit setVariable ["GOL_HVT", true, true];
_hvtUnit setVariable ["GOL_SurrenderEnabled", true, true];
_hvtUnit setVariable ["OKS_InterceptHvt_AllowExit", false, true];
_hvtUnit setVariable ["OKS_InterceptHvt_SurrenderActionDone", false, true];

// Create remaining guards (reduced by 1 since colonel leader already created)
for "_i" from 2 to _guardCount do {
    private _className = selectRandom _units;
    private _u = _guardGroup createUnit [_className, _spawnPosition, [], 0, "NONE"];
    _u setVariable ["GOL_HVT_Guard", true, true];
};

if (_hvtDebug) then {
    format ["[INTERCEPT HVT] Spawned HVT=%1 with %2 guards. EscortDelay=%3s", _hvtUnit, _guardCount, round _waitDelay] call OKS_fnc_LogDebug;
};

[
    _hvtUnit,
    _guardGroup,
    _spawnPosition,
    _endPosition,
    _endBehavior,
    _designatedVehicle,
    _waitDelay,
    _guardCount,
    _surrenderThresholdPct,
    _convoySpeedMS,
    _showTaskPosition,
    _taskParent,
    _showVehicleType,
    _hvtProfileImagePath,
    _killFailsTask,
    _hasExtraction,
    _extractionPos,
    _hvtDebug,
    _convoyApproachDir
] spawn {
    params [
        "_hvtUnit",
        "_guardGroup",
        "_spawnPosition",
        "_endPosition",
        "_endBehavior",
        "_designatedVehicle",
        "_waitDelay",
        "_initialGuardCount",
        "_surrenderThresholdPct",
        "_convoySpeedMS",
        "_showTaskPosition",
        "_taskParent",
        "_showVehicleType",
        "_hvtProfileImagePath",
        "_killFailsTask",
        "_hasExtraction",
        "_extractionPos",
        "_hvtDebug",
        "_convoyApproachDir"
    ];

    if (!alive _hvtUnit) exitWith {};

    private _designatedVehicles = [];
    if (_designatedVehicle isEqualType objNull) then {
        _designatedVehicles pushBack _designatedVehicle;
    } else {
        if (_designatedVehicle isEqualType []) then {
            {
                _designatedVehicles pushBack (if (_x isEqualType objNull) then {_x} else {objNull});
            } forEach _designatedVehicle;

            // For convoy startup reliability, pick the designated vehicle closest to end as the main lead.
            // This prevents delayed overflow vehicles from blocking the HVT main vehicle at spawn.
            _designatedVehicles = _designatedVehicles select {!isNull _x};
            if ((count _designatedVehicles) > 1) then {
                _designatedVehicles = [_designatedVehicles, [], { _x distance2D _endPosition }, "ASCEND"] call BIS_fnc_sortBy;
                if (_hvtDebug) then {
                    {
                        format [
                            "[INTERCEPT HVT][DESIGNATED_ORDER] idx=%1 veh=%2 netId=%3 distToEnd=%4",
                            _forEachIndex,
                            typeOf _x,
                            netId _x,
                            round (_x distance2D _endPosition)
                        ] call OKS_fnc_LogDebug;
                    } forEach _designatedVehicles;
                };
            };
        };
    };

    private _designatedQueue = +_designatedVehicles;
    private _mainDesignated = if (_designatedQueue isEqualTo []) then {objNull} else {_designatedQueue deleteAt 0};
    private _vehicle = [_spawnPosition, _mainDesignated, _guardGroup, _hvtUnit, 250] call OKS_fnc_InterceptHvt_SelectVehicle;
    private _hvtInVehicle = false;
    private _overflowGroup = grpNull;
    private _overflowGroups = [];
    private _overflowAssignments = [];

    private _allGuards = (units _guardGroup) select {alive _x};
    private _immediateGuards = +_allGuards;

    if (!isNull _vehicle) then {
        private _driverSeats = _vehicle emptyPositions "driver";
        private _commanderSeats = _vehicle emptyPositions "commander";
        private _gunnerSeats = _vehicle emptyPositions "gunner";
        private _cargoSeats = _vehicle emptyPositions "cargo";
        // Reserve one cargo seat for the HVT in the main vehicle.
        private _mainGuardCapacity = (_driverSeats + _commanderSeats + _gunnerSeats + ((_cargoSeats - 1) max 0)) max 0;

        private _guardOnlyList = _allGuards select {_x != _hvtUnit};
        private _selectedGuards = _guardOnlyList select [0, _mainGuardCapacity min (count _guardOnlyList)];
        _immediateGuards = _selectedGuards + [_hvtUnit];
        
        if (_hvtDebug) then {
            format ["[INTERCEPT HVT][SEATING] Vehicle guard capacity=%1 seats (+1 reserved for HVT). AllGuards=%2 units. Array order: guards=%3, HVT at index=%4", 
                _mainGuardCapacity, count _allGuards, count _guardOnlyList, count _guardOnlyList] call OKS_fnc_LogDebug;
        };
        
        if (_hvtDebug) then {
            format ["[INTERCEPT HVT][SEATING] Selected %1 units for main vehicle. Guards selected=%2, HVT in selection: %3", 
                count _immediateGuards,
                count (_immediateGuards select {_x != _hvtUnit}),
                (_immediateGuards find _hvtUnit >= 0)
            ] call OKS_fnc_LogDebug;
        };
        
        private _overflowPool = [];
        private _selectedGuardCount = count _selectedGuards;
        if ((count _guardOnlyList) > _selectedGuardCount) then {
            _overflowPool = _guardOnlyList select [_selectedGuardCount, (count _guardOnlyList) - _selectedGuardCount];
        };

        while {_overflowPool isNotEqualTo []} do {
            private _grp = createGroup [side _guardGroup, true];
            _grp setVariable ["lambs_danger_disableGroupAI", true, true];

            private _designatedOverflowVeh = if (_designatedQueue isEqualTo []) then {objNull} else {_designatedQueue deleteAt 0};
            private _veh = [_spawnPosition, _designatedOverflowVeh, _grp, _hvtUnit, 250] call OKS_fnc_InterceptHvt_SelectVehicle;
            if (isNull _veh) exitWith {
                {
                    [_x] joinSilent _guardGroup;
                } forEach _overflowPool;
                _overflowPool = [];
                deleteGroup _grp;
            };

            private _teamCapacity = (
                (_veh emptyPositions "driver") +
                (_veh emptyPositions "commander") +
                (_veh emptyPositions "gunner") +
                (_veh emptyPositions "cargo")
            ) max 1;

            private _teamUnits = [];
            for "_i" from 1 to _teamCapacity do {
                if (_overflowPool isEqualTo []) exitWith {};
                private _u = _overflowPool deleteAt 0;
                [_u] joinSilent _grp;
                _teamUnits pushBack _u;
            };

            if (_teamUnits isEqualTo []) then {
                deleteGroup _grp;
            } else {
                _overflowGroups pushBack _grp;
                _overflowAssignments pushBack [_grp, _veh, _teamUnits];
            };
        };

        _overflowGroup = if (_overflowGroups isEqualTo []) then {grpNull} else {_overflowGroups select 0};
        _hvtUnit setVariable ["OKS_InterceptHvt_MainVehicle", _vehicle, true];
        _hvtUnit setVariable ["OKS_InterceptHvt_OverflowGroups", _overflowGroups, true];
        _hvtUnit setVariable ["OKS_InterceptHvt_OverflowAssignments", _overflowAssignments, true];
        _hvtUnit setVariable ["OKS_InterceptHvt_AllGuards", _immediateGuards, true];

        // Ensure vehicle is unlocked during mounting
        _vehicle lock 0;

        // PRE-MOUNT LOG: Show seat assignments before any movement
        if (_hvtDebug) then {
            format ["[INTERCEPT HVT][SEATING] ===== BEFORE MOUNT ====="] call OKS_fnc_LogDebug;
            {
                private _unitName = if (_x == _hvtUnit) then {"[HVT]"} else {"Guard"};
                private _assigned = assignedVehicleRole _x;
                format ["[INTERCEPT HVT][SEATING] %1 %2: assigned role=%3", _unitName, name _x, _assigned] call OKS_fnc_LogDebug;
            } forEach _immediateGuards;
        };

        // HVT MUST mount to cargo first before any guards, to lock him in place and prevent seat swapping chaos
        if (alive _hvtUnit) then {
            _hvtUnit disableAI "PATH";
            private _emptyCargoSlots = (fullCrew [_vehicle, "cargo", true]) select {isNull (_x select 0)};
            if (_emptyCargoSlots isNotEqualTo []) then {
                private _slot = selectRandom _emptyCargoSlots;
                private _cargoIdx = _slot param [2, -1, [0]];
                if (_cargoIdx >= 0) then {
                    _hvtUnit moveInCargo [_vehicle, _cargoIdx];
                    if (_hvtDebug) then {
                        format ["[INTERCEPT HVT][SEATING] HVT moved to cargo seat %1", _cargoIdx] call OKS_fnc_LogDebug;
                    };
                } else {
                    _hvtUnit moveInCargo _vehicle;
                    if (_hvtDebug) then {
                        format ["[INTERCEPT HVT][SEATING] HVT moved to random cargo seat"] call OKS_fnc_LogDebug;
                    };
                };
            } else {
                _hvtUnit moveInCargo _vehicle;
                if (_hvtDebug) then {
                    format ["[INTERCEPT HVT][SEATING] HVT moved to cargo (no empty slots)"] call OKS_fnc_LogDebug;
                };
            };
            
            // Give HVT mount time to complete before guards start mounting
            sleep 0.5;
            
            _hvtInVehicle = (vehicle _hvtUnit == _vehicle);
            
            if (_hvtDebug) then {
                private _hvtRole = assignedVehicleRole _hvtUnit;
                private _hvtVeh = vehicle _hvtUnit;
                private _hvtSeat = "UNKNOWN";
                if (_hvtVeh == _vehicle) then {
                    if (_hvtUnit == driver _vehicle) then {_hvtSeat = "driver"};
                    if (_hvtUnit == commander _vehicle) then {_hvtSeat = "commander"};
                    if (_hvtUnit == gunner _vehicle) then {_hvtSeat = "gunner"};
                    if (_hvtSeat == "UNKNOWN") then {
                        private _allCargo = fullCrew [_vehicle, "cargo", true];
                        private _idx = _allCargo findIf {(_x select 0) == _hvtUnit};
                        if (_idx >= 0) then {_hvtSeat = format ["cargo[%1]", _idx]};
                    };
                };
                format ["[INTERCEPT HVT][SEATING] HVT assigned role=%1, actual seat=%2, in main vehicle=%3", _hvtRole, _hvtSeat, _hvtInVehicle] call OKS_fnc_LogDebug;
            };
        };

        // Mount guards with explicit seat assignment to avoid AI seat arbitration displacing HVT.
        if (_hvtDebug) then {
            format ["[INTERCEPT HVT][SEATING] Mounting %1 guards (explicit seats)...", count _selectedGuards] call OKS_fnc_LogDebug;
        };

        private _pendingMain = (_selectedGuards select {alive _x});

        if ((_vehicle emptyPositions "driver") > 0 && {_pendingMain isNotEqualTo []}) then {
            private _driverUnit = _pendingMain deleteAt 0;
            _driverUnit moveInDriver _vehicle;
        };
        if ((_vehicle emptyPositions "commander") > 0 && {_pendingMain isNotEqualTo []}) then {
            private _cmdUnit = _pendingMain deleteAt 0;
            _cmdUnit moveInCommander _vehicle;
        };
        if ((_vehicle emptyPositions "gunner") > 0 && {_pendingMain isNotEqualTo []}) then {
            private _gunnerUnit = _pendingMain deleteAt 0;
            _gunnerUnit moveInGunner _vehicle;
        };

        {
            if (alive _x) then {
                private _emptyCargoSlots = (fullCrew [_vehicle, "cargo", true]) select {isNull (_x select 0)};
                if (_emptyCargoSlots isNotEqualTo []) then {
                    private _slot = _emptyCargoSlots select 0;
                    private _cargoIdx = _slot param [2, -1, [0]];
                    if (_cargoIdx >= 0) then {
                        _x moveInCargo [_vehicle, _cargoIdx];
                    } else {
                        _x moveInCargo _vehicle;
                    };
                };
            };
        } forEach _pendingMain;

        // Hard invariant: HVT must remain in the main vehicle.
        if (alive _hvtUnit && {vehicle _hvtUnit != _vehicle}) then {
            _hvtUnit moveInCargo _vehicle;
            if (_hvtDebug) then {
                "[INTERCEPT HVT][SEATING] HVT was not in main vehicle after explicit mount; forced back to cargo." call OKS_fnc_LogDebug;
            };
        };

        if (_hvtDebug) then {
            {
                private _guardUnit = _x;
                private _assignedRole = assignedVehicleRole _guardUnit;
                private _actualSeat = "UNKNOWN";
                if (vehicle _guardUnit == _vehicle) then {
                    if (_guardUnit == driver _vehicle) then {_actualSeat = "driver"};
                    if (_guardUnit == commander _vehicle) then {_actualSeat = "commander"};
                    if (_guardUnit == gunner _vehicle) then {_actualSeat = "gunner"};
                    if (_actualSeat == "UNKNOWN") then {
                        private _allCargo = fullCrew [_vehicle, "cargo", true];
                        private _idx = _allCargo findIf {(_x select 0) == _guardUnit};
                        if (_idx >= 0) then {_actualSeat = format ["cargo[%1]", _idx]};
                    };
                } else {
                    _actualSeat = "NOT IN VEHICLE";
                };
                format ["[INTERCEPT HVT][SEATING] Guard %1 mounted: assigned=%2, actual seat=%3", name _guardUnit, _assignedRole, _actualSeat] call OKS_fnc_LogDebug;
            } forEach _selectedGuards;
        };

        // POST-MOUNT LOG: Show all seat positions after mounting
        if (_hvtDebug) then {
            format ["[INTERCEPT HVT][SEATING] ===== AFTER MOUNT ====="] call OKS_fnc_LogDebug;
            private _allCrew = crew _vehicle;
            {
                private _crewUnit = _x;
                private _role = assignedVehicleRole _crewUnit;
                private _seat = "UNKNOWN";
                if (_crewUnit == driver _vehicle) then {_seat = "driver"};
                if (_crewUnit == commander _vehicle) then {_seat = "commander"};
                if (_crewUnit == gunner _vehicle) then {_seat = "gunner"};
                if (_seat == "UNKNOWN") then {
                    private _allCargo = fullCrew [_vehicle, "cargo", true];
                    private _idx = _allCargo findIf {(_x select 0) == _crewUnit};
                    if (_idx >= 0) then {_seat = format ["cargo[%1]", _idx]};
                };
                private _label = if (_crewUnit == _hvtUnit) then {"[HVT]"} else {"Guard"};
                format ["[INTERCEPT HVT][SEATING] %1 %2: assigned=%3, actual seat=%4", _label, name _crewUnit, _role, _seat] call OKS_fnc_LogDebug;
            } forEach _allCrew;
            format ["[INTERCEPT HVT][SEATING] Vehicle crew: %1 units. Driver=%2, Commander=%3, Gunner=%4", 
                count _allCrew, name (driver _vehicle), name (commander _vehicle), name (gunner _vehicle)] call OKS_fnc_LogDebug;
        };

        {
            _x params ["_grp", "_veh", "_units"];
            if (isNull _veh) then { continue; };

            private _pendingOverflow = (_units select {alive _x});

            if ((_veh emptyPositions "driver") > 0 && {_pendingOverflow isNotEqualTo []}) then {
                private _ovDriver = _pendingOverflow deleteAt 0;
                _ovDriver moveInDriver _veh;
            };
            if ((_veh emptyPositions "commander") > 0 && {_pendingOverflow isNotEqualTo []}) then {
                private _ovCmd = _pendingOverflow deleteAt 0;
                _ovCmd moveInCommander _veh;
            };
            if ((_veh emptyPositions "gunner") > 0 && {_pendingOverflow isNotEqualTo []}) then {
                private _ovGunner = _pendingOverflow deleteAt 0;
                _ovGunner moveInGunner _veh;
            };

            {
                if (alive _x) then {
                    private _emptyCargoSlots = (fullCrew [_veh, "cargo", true]) select {isNull (_x select 0)};
                    if (_emptyCargoSlots isNotEqualTo []) then {
                        private _slot = _emptyCargoSlots select 0;
                        private _cargoIdx = _slot param [2, -1, [0]];
                        if (_cargoIdx >= 0) then {
                            _x moveInCargo [_veh, _cargoIdx];
                        } else {
                            _x moveInCargo _veh;
                        };
                    };
                };
            } forEach _pendingOverflow;

            if (_hvtDebug) then {
                private _missing = {_x == vehicle _x} count (_units select {alive _x});
                if (_missing > 0) then {
                    format ["[INTERCEPT HVT][OVERFLOW] %1 alive units could not mount in %2", _missing, typeOf _veh] call OKS_fnc_LogDebug;
                };
            };
        } forEach _overflowAssignments;

        // Ensure each vehicle has a driver after direct insertion.
        {
            _x params ["_grp", "_veh", "_units"];
            if (isNull driver _veh) then {
                private _driverCandidate = (_units select {alive _x && {_x != _hvtUnit} && {vehicle _x == _veh}}) param [0, objNull, [objNull]];
                if (!isNull _driverCandidate) then {
                    _driverCandidate moveInDriver _veh;
                };
            };
        } forEach ([[ _guardGroup, _vehicle, _immediateGuards ]] + _overflowAssignments);

        _hvtInVehicle = alive _hvtUnit && {vehicle _hvtUnit == _vehicle};

        if (!isNull _vehicle && {alive _hvtUnit} && {vehicle _hvtUnit == _vehicle}) then {
            [_vehicle, _guardGroup, _hvtUnit] spawn OKS_fnc_InterceptHvt_HandleDisabledVehicle;
        };
    } else {
        _hvtUnit setVariable ["OKS_InterceptHvt_AllGuards", units _guardGroup, true];
        _hvtUnit setVariable ["OKS_InterceptHvt_OverflowGroups", [], true];
        _hvtUnit setVariable ["OKS_InterceptHvt_OverflowAssignments", [], true];
    };

    private _moveTarget = _endPosition;
    private _nearestRoad = [_endPosition, 250] call BIS_fnc_nearestRoad;
    if (!isNull _nearestRoad) then {
        _moveTarget = getPosATL _nearestRoad;
    };

    private _ensureHvtCargoFn = {
        params ["_hvt", "_veh", "_debug"];
        if (isNull _hvt || {isNull _veh} || {!alive _hvt} || {!alive _veh}) exitWith {false};
        if (vehicle _hvt != _veh) exitWith {false};

        private _isCrewSeat = (_hvt == driver _veh) || {_hvt == commander _veh} || {_hvt == gunner _veh};
        if (!_isCrewSeat) exitWith {false};

        private _moved = false;
        private _emptyCargoSlots = (fullCrew [_veh, "cargo", true]) select {isNull (_x select 0)};
        if (_emptyCargoSlots isNotEqualTo []) then {
            private _slot = selectRandom _emptyCargoSlots;
            private _cargoIdx = _slot param [2, -1, [0]];
            if (_cargoIdx >= 0) then {
                _hvt moveInCargo [_veh, _cargoIdx];
                _moved = true;
            };
        };

        if (!_moved) then {
            _hvt moveInCargo _veh;
            _moved = true;
        };

        if (_debug) then {
            format ["[INTERCEPT HVT] HVT was in crew seat and was moved back to cargo. Veh=%1", typeOf _veh] call OKS_fnc_LogDebug;
        };
        true
    };

    if (!isNull _vehicle && {_hvtInVehicle}) then {
        // FIRST: ensure HVT is locked in cargo before ANY movement
        if (alive _hvtUnit) then {
            _hvtUnit disableAI "PATH";
            _hvtUnit disableAI "AUTOCOMBAT";
            _hvtUnit setBehaviour "CARELESS";
            _hvtUnit setCombatMode "BLUE";
        };

        [_hvtUnit, _vehicle, _hvtDebug] call _ensureHvtCargoFn;

        // Store main guard group so surrender handler can update it to SAD.
        _hvtUnit setVariable ["OKS_InterceptHvt_MainGuardGroup", _guardGroup, true];

        // SECOND: add event handler to block unauthorized exits
        _vehicle allowCrewInImmobile true;
        _vehicle setVariable ["OKS_InterceptHvt_MainUnit", _hvtUnit, false];
        _vehicle addEventHandler ["GetOut", {
            params ["_veh", "_role", "_unit"];

            private _hvt = _veh getVariable ["OKS_InterceptHvt_MainUnit", objNull];
            private _hvtDebug = missionNamespace getVariable ["GOL_HVT_Debug", false];
            
            if (_hvtDebug) then {
                format ["[INTERCEPT HVT][GETOUT] Event fired: role=%1, unit=%2, is HVT=%3", _role, name _unit, (_unit == _hvt)] call OKS_fnc_LogDebug;
            };
            
            if (!isNull _hvt && {_unit == _hvt}) then {
                private _allowExit = _hvt getVariable ["OKS_InterceptHvt_AllowExit", false];
                private _surrendered = _hvt getVariable ["OKS_InterceptHvt_Surrendered", false];
                private _behavior = behaviour _hvt;
                private _combatMode = combatMode _hvt;
                
                if (_hvtDebug) then {
                    format ["[INTERCEPT HVT][GETOUT] HVT exit attempt: allowExit=%1, surrendered=%2, behavior=%3, combatMode=%4", 
                        _allowExit, _surrendered, _behavior, _combatMode] call OKS_fnc_LogDebug;
                };
                
                if (!_allowExit) then {
                    // Prevent recursive GetOut->moveInCargo loops while we reinsert once.
                    if (_hvt getVariable ["OKS_InterceptHvt_Reinserting", false]) exitWith {};
                    _hvt setVariable ["OKS_InterceptHvt_Reinserting", true];
                    if (_hvtDebug) then {
                        "[INTERCEPT HVT][GETOUT] HVT BLOCKED: Reinserting into cargo." call OKS_fnc_LogDebug;
                    };
                    _hvt moveInCargo _veh;
                    _hvt disableAI "PATH";
                    _hvt setVariable ["OKS_InterceptHvt_Reinserting", false];
                } else {
                    if (_hvtDebug) then {
                        "[INTERCEPT HVT][GETOUT] HVT exit ALLOWED." call OKS_fnc_LogDebug;
                    };
                };
            };
        }];

        // THIRD: NOW set waypoints only after HVT is secured
        if (_hvtDebug) then {
            format ["[INTERCEPT HVT][SEATING] ===== FINAL STATE BEFORE MOVEMENT ====="] call OKS_fnc_LogDebug;
            format ["[INTERCEPT HVT][SEATING] HVT unit: %1", name _hvtUnit] call OKS_fnc_LogDebug;
            format ["[INTERCEPT HVT][SEATING] HVT vehicle: %1", vehicle _hvtUnit] call OKS_fnc_LogDebug;
            format ["[INTERCEPT HVT][SEATING] HVT assigned role: %1", assignedVehicleRole _hvtUnit] call OKS_fnc_LogDebug;
            format ["[INTERCEPT HVT][SEATING] HVT in vehicle: %1", vehicle _hvtUnit == _vehicle] call OKS_fnc_LogDebug;
            format ["[INTERCEPT HVT][SEATING] Vehicle locked: %1", locked _vehicle] call OKS_fnc_LogDebug;
            format ["[INTERCEPT HVT][SEATING] Vehicle crew count: %1", count (crew _vehicle)] call OKS_fnc_LogDebug;
        };
        
        _guardGroup setBehaviour "CARELESS";
        _guardGroup setSpeedMode "FULL";
        if (_hvtDebug) then {
            "[INTERCEPT HVT] Main guard heading to end waypoint immediately." call OKS_fnc_LogDebug;
        };

        // Lights off for all convoy vehicles until each is cleared to move.
        _vehicle setPilotLight false;
        _vehicle setCollisionLight false;
        { _x disableAI "LIGHTS"; } forEach (crew _vehicle);
        {
            _x params ["", "_ovVeh"];
            _ovVeh setPilotLight false;
            _ovVeh setCollisionLight false;
            { _x disableAI "LIGHTS"; } forEach (crew _ovVeh);
        } forEach _overflowAssignments;

        [_guardGroup] call OKS_fnc_ClearWaypoints;
        private _wp = _guardGroup addWaypoint [_moveTarget, 15];
        _wp setWaypointType "MOVE";
        _wp setWaypointBehaviour "CARELESS";
        _wp setWaypointSpeed "FULL";
        _guardGroup setCurrentWaypoint _wp;

        // Re-enable lights on main vehicle as it starts moving.
        _vehicle setPilotLight true;
        _vehicle setCollisionLight true;
        { _x enableAI "LIGHTS"; } forEach (crew _vehicle);

        if (_convoySpeedMS > 0) then {
            _vehicle limitSpeed (_convoySpeedMS * 3.6);
        } else {
            _vehicle limitSpeed 5000;
        };

        // Lock main vehicle after everyone is mounted.
        _vehicle lock 2;

        // Pre-compute road-based stop positions for each overflow vehicle by walking
        // backward along connected road segments from the destination toward spawn.
        // Direction source (in priority order):
        //   1. _convoyApproachDir — getDir of the _endPos logic object, set by the mission
        //      designer to face the direction the convoy arrives FROM. Exact, handles
        //      any road geometry including intersections and curved routes.
        //   2. Local per-hop bearing from each current road node toward _spawnPosition.
        //      Better than a fixed global bearing: adapts at each step as we walk the
        //      road, so curves in the route are partially compensated.
        private _startRoad = [_moveTarget, 100] call BIS_fnc_nearestRoad;
        if (isNull _startRoad) then { _startRoad = [_moveTarget, 500] call BIS_fnc_nearestRoad; };

        // Seed with _moveTarget so the minimum-spacing check keeps overflow 0 ≥ 25 m behind it.
        private _ovRoadStops = [_moveTarget];

        if (!isNull _startRoad) then {
            private _currentRoad = _startRoad;
            for "_i" from 0 to (count _overflowAssignments - 1) do {
                for "_hop" from 1 to 30 do {
                    // Use the explicit approach direction when the caller supplied a directed
                    // object for _endPos. Otherwise compute a local bearing from the current
                    // road node toward spawn (better than a fixed global straight-line bearing).
                    private _dir = if (_convoyApproachDir >= 0)
                        then { _convoyApproachDir }
                        else { (getPos _currentRoad) getDir _spawnPosition };
                    private _nextRoad = [_currentRoad, _dir] call OKS_fnc_Convoy_NearestRoadTowardsOrigin;
                    if (isNull _nextRoad) exitWith {};
                    private _nextPos = getPos _nextRoad;
                    _nextPos set [2, 0]; // ground level
                    _currentRoad = _nextRoad;
                    // Accept this road only if it is ≥ 25 m from every already-chosen stop.
                    if ((_ovRoadStops findIf { _x distance2D _nextPos < 25 }) < 0) exitWith {
                        _ovRoadStops pushBack _nextPos;
                    };
                };
            };
        };

        _ovRoadStops deleteAt 0; // remove the _moveTarget placeholder

        // Fallback: pad with evenly-spaced angular offsets if road walking ran out.
        while { count _ovRoadStops < count _overflowAssignments } do {
            private _i = count _ovRoadStops;
            _ovRoadStops pushBack ([_moveTarget, 30 + _i * 25, _i * (360 / (count _overflowAssignments max 1))] call BIS_fnc_relPos);
        };

        if (_hvtDebug) then {
            format ["[INTERCEPT HVT][OVERFLOW] Road stop positions (%1): %2", count _ovRoadStops, _ovRoadStops] call OKS_fnc_LogDebug;
        };

        {
            _x params ["_grp", "_veh", "_units"];
            _grp setBehaviour "CARELESS";
            _grp setSpeedMode "NORMAL";

            if (_convoySpeedMS > 0) then {
                _veh limitSpeed (_convoySpeedMS * 3.6);
            } else {
                _veh limitSpeed 5000;
            };

            // Overflow vehicles are standard escorts; keep unlocked to avoid stranding units on transient dismount/re-seat.
            _veh lock 0;
            _veh allowCrewInImmobile true;
            [_veh, _grp, _hvtUnit] spawn OKS_fnc_InterceptHvt_HandleDisabledVehicle;
            private _staggerDelay = _waitDelay * (_forEachIndex + 1);
            if (_hvtDebug) then {
                format ["[INTERCEPT HVT][OVERFLOW] Group %1 stagger delay: %2s", _forEachIndex + 1, round _staggerDelay] call OKS_fnc_LogDebug;
            };
            // Each overflow vehicle stops on its own road segment.
            private _ovMoveTarget = _ovRoadStops select _forEachIndex;
            [_grp, _veh, _vehicle, _ovMoveTarget, _convoySpeedMS, _staggerDelay, _hvtUnit, _hvtDebug] spawn OKS_fnc_InterceptHvt_StartEscortTrail;

            // Independent garrison watcher — fires only when THIS vehicle arrives.
            // Each overflow group acts individually; not coupled to the main vehicle.
            if ((toUpperANSI _endBehavior) == "GARRISON") then {
                // Pass _ovMoveTarget (this vehicle's own road stop) — NOT the shared
                // _moveTarget — so the arrival check fires at the right distance.
                [_grp, _veh, _units, _ovMoveTarget, _endPosition, _hvtDebug] spawn {
                    params ["_grp", "_veh", "_units", "_moveTarget", "_endPosition", "_debug"];
                    waitUntil {
                        sleep 1;
                        !alive _veh ||
                        (_veh distance2D _moveTarget < 60 && { vectorMagnitude velocity _veh <= 0.14 })
                    };
                    if (!alive _veh) exitWith {};
                    _veh lock 0;
                    {
                        if (alive _x && { vehicle _x == _veh }) then {
                            _x setVariable ["OKS_InterceptHvt_ShouldExit", true];
                            [_x] allowGetIn false;
                            _x leaveVehicle _veh;
                            doGetOut _x;
                            unassignVehicle _x;
                            _x enableAI "FSM";
                            _x enableAI "PATH";
                            _x setBehaviour "AWARE";
                        };
                    } forEach _units;
                    sleep 1;
                    private _aliveTeam = _units select { alive _x };
                    if (_aliveTeam isNotEqualTo []) then {
                        // Use the vehicle's actual parked position, NOT the shared _endPosition.
                        // Every overflow vehicle stopped at a unique offset, so each group
                        // gets a different nearestObjects sort and fills different buildings.
                        private _vehCenter = getPos _veh;
                        [_vehCenter, 150, _aliveTeam, 0.75, _debug] spawn OKS_fnc_GarrisonBuildingsInArea;
                        if (_debug) then {
                            format ["[INTERCEPT HVT][OVERFLOW] Garrison spawned for %1 units, center=veh pos %2", count _aliveTeam, _vehCenter] call OKS_fnc_LogDebug;
                        };
                    };
                };
            };
        } forEach _overflowAssignments;
    } else {
        [_guardGroup] call OKS_fnc_ClearWaypoints;
        private _onFootWp = _guardGroup addWaypoint [_moveTarget, 0];
        _onFootWp setWaypointType "MOVE";
        _onFootWp setWaypointBehaviour "AWARE";
        _onFootWp setWaypointSpeed "FULL";
        _guardGroup setCurrentWaypoint _onFootWp;

        {
            [_x] call OKS_fnc_ClearWaypoints;
            private _ovWp = _x addWaypoint [_moveTarget, 0];
            _ovWp setWaypointType "MOVE";
            _ovWp setWaypointBehaviour "AWARE";
            _ovWp setWaypointSpeed "NORMAL";
            _x setCurrentWaypoint _ovWp;
        } forEach _overflowGroups;

        if (!isNull _overflowGroup) then {
            _overflowGroup setBehaviour "AWARE";
        };
        _hvtUnit setBehaviour "CARELESS";
    };

    waitUntil {
        sleep 1;
        if (!alive _hvtUnit) exitWith {true};
        private _referenceObj = if (!isNull _vehicle && {vehicle _hvtUnit == _vehicle}) then {_vehicle} else {_hvtUnit};
        (_referenceObj distance2D _spawnPosition) >= 50
    };

    if (!alive _hvtUnit) exitWith {};

    private _isCaptureOrKill = !_killFailsTask;
    _hvtUnit setVariable ["OKS_InterceptHvt_CaptureOrKill", _isCaptureOrKill, true];

    private _vehicleTaskType = "danger";
    if (!isNull _vehicle) then {
        if (_vehicle isKindOf "Car") then {
            _vehicleTaskType = "car";
        };
        if (_vehicle isKindOf "Truck") then {
            _vehicleTaskType = "truck";
        };
        if (_vehicle isKindOf "Tank" || {_vehicle isKindOf "Wheeled_APC_F"} || {_vehicle isKindOf "Tracked_APC_F"}) then {
            _vehicleTaskType = "danger";
        };
    };

    private _vehicleText = "";
    if (_showVehicleType && {!isNull _vehicle}) then {
        private _vehicleCfg = configFile >> "CfgVehicles" >> typeOf _vehicle;
        private _vehicleName = getText (_vehicleCfg >> "displayName");
        private _vehiclePicture = getText (_vehicleCfg >> "editorPreview");
        private _texturePath = (getObjectTextures _vehicle) param [0, ""];
        private _textureDisplayName = "N/A";

        if !(_texturePath isEqualTo "") then {
            private _texturePathLower = toLowerANSI _texturePath;
            private _textureSourcesCfg = _vehicleCfg >> "TextureSources";

            for "_i" from 0 to ((count _textureSourcesCfg) - 1) do {
                private _srcCfg = _textureSourcesCfg select _i;
                if (isClass _srcCfg) then {
                    private _srcTextures = getArray (_srcCfg >> "textures");
                    private _matched = false;
                    {
                        private _srcTexLower = toLowerANSI _x;
                        if (
                            (_srcTexLower find _texturePathLower) >= 0 ||
                            (_texturePathLower find _srcTexLower) >= 0
                        ) exitWith {
                            _matched = true;
                        };
                    } forEach _srcTextures;

                    if (_matched) exitWith {
                        _textureDisplayName = getText (_srcCfg >> "displayName");
                        if (_textureDisplayName isEqualTo "") then {
                            _textureDisplayName = configName _srcCfg;
                        };
                    };
                };
            };

            if (_textureDisplayName isEqualTo "N/A") then {
                private _parts = _texturePath splitString "\\/";
                if (_parts isNotEqualTo []) then {
                    _textureDisplayName = _parts select ((count _parts) - 1);
                    if ((toLowerANSI _textureDisplayName) find ".paa" >= 0) then {
                        _textureDisplayName = _textureDisplayName select [0, (count _textureDisplayName) - 4 max 0];
                    };
                };
            };
        };

        if (_vehiclePicture isEqualTo "") then {
            _vehiclePicture = getText (_vehicleCfg >> "picture");
        };

        // Structured text requires ampersands to be escaped.
        _vehicleName = _vehicleName splitString "&" joinString "&amp;";
        _textureDisplayName = _textureDisplayName splitString "&" joinString "&amp;";

        private _vehicleImageText = "";
        if !(_vehiclePicture isEqualTo "") then {
            _vehicleImageText = format ["<br/><img image='%1' width='320' height='213' />", _vehiclePicture];
        };
        _vehicleText = format [
            "<br/><br/><t size='1.4' color='#6EC1E4'>TRANSPORT</t>%1" +
            "<br/><t color='#C8D6E5'>Vehicle:</t> <t color='#FFFFFF'>%2</t>" +
            "<br/><t color='#C8D6E5'>Variant:</t> <t color='#FFFFFF'>%3</t>",
            _vehicleImageText,
            _vehicleName,
            _textureDisplayName
        ];
    };

    // Build HVT profile after delay/movement so caller-side identity/appearance overrides are reflected.
    private _itemDisplayNameFn = {
        params ["_className", "_noneText"];
        if (_className isEqualTo "") exitWith {_noneText};

        private _cfg = configNull;
        private _hasCfg = false;
        if (isClass (configFile >> "CfgWeapons" >> _className)) then {
            _cfg = configFile >> "CfgWeapons" >> _className;
            _hasCfg = true;
        } else {
            if (isClass (configFile >> "CfgGlasses" >> _className)) then {
                _cfg = configFile >> "CfgGlasses" >> _className;
                _hasCfg = true;
            } else {
                if (isClass (configFile >> "CfgVehicles" >> _className)) then {
                    _cfg = configFile >> "CfgVehicles" >> _className;
                    _hasCfg = true;
                };
            };
        };

        if (!_hasCfg) exitWith {_className};
        private _dn = getText (_cfg >> "displayName");
        if (_dn isEqualTo "") then {_className} else {_dn}
    };

    private _hvtName = name _hvtUnit;
    private _hvtFaceClass = face _hvtUnit;
    private _hvtRace = [_hvtUnit] call OKS_fnc_GetEthnicityFromFace;
    if (isNil "_hvtRace" || {_hvtRace isEqualTo ""}) then {
        _hvtRace = "Unknown";
    };

    // Only use explicitly defined portrait image path provided in taskData.
    private _hvtProfileImage = _hvtProfileImagePath;

    private _hvtHeadgearName = [headgear _hvtUnit, "None"] call _itemDisplayNameFn;
    private _hvtGogglesName = [goggles _hvtUnit, "None"] call _itemDisplayNameFn;
    private _hvtUniformName = [uniform _hvtUnit, "None"] call _itemDisplayNameFn;
    private _hvtVestName = [vest _hvtUnit, "None"] call _itemDisplayNameFn;
    private _hvtBackpackName = [backpack _hvtUnit, "None"] call _itemDisplayNameFn;

    // Structured text safety.
    _hvtName = _hvtName splitString "&" joinString "&amp;";
    _hvtRace = _hvtRace splitString "&" joinString "&amp;";
    _hvtHeadgearName = _hvtHeadgearName splitString "&" joinString "&amp;";
    _hvtGogglesName = _hvtGogglesName splitString "&" joinString "&amp;";
    _hvtUniformName = _hvtUniformName splitString "&" joinString "&amp;";
    _hvtVestName = _hvtVestName splitString "&" joinString "&amp;";
    _hvtBackpackName = _hvtBackpackName splitString "&" joinString "&amp;";

    private _hvtProfileImageText = "";
    if !(_hvtProfileImage isEqualTo "") then {
        _hvtProfileImageText = format ["<br/><img image='%1' width='320' height='320' />", _hvtProfileImage];
    };
    private _identityText = format [
        "<br/><br/><t size='1.4' color='#F4D35E'>HVT PROFILE</t>%1" +
        "<br/><t color='#C8D6E5'>Name:</t> <t color='#FFFFFF'>%2</t><br/>" +
        "<t color='#C8D6E5'>Ethnicity:</t> <t color='#FFFFFF'>%3</t><br/>" +
        "<t color='#C8D6E5'>Headgear:</t> <t color='#FFFFFF'>%4</t><br/>" +
        "<t color='#C8D6E5'>Eyewear:</t> <t color='#FFFFFF'>%5</t><br/>" +
        "<t color='#C8D6E5'>Uniform:</t> <t color='#FFFFFF'>%6</t><br/>" +
        "<t color='#C8D6E5'>Vest:</t> <t color='#FFFFFF'>%7</t><br/>" +
        "<t color='#C8D6E5'>Backpack:</t> <t color='#FFFFFF'>%8</t>",
        _hvtProfileImageText,
        _hvtName,
        _hvtRace,
        _hvtHeadgearName,
        _hvtGogglesName,
        _hvtUniformName,
        _hvtVestName,
        _hvtBackpackName
    ];

    private _mainTaskTitle = "Intercept HVT";
    private _mainTaskDescription = format [
        "<t size='1.8' color='#F4D35E'>HIGH VALUE TARGET INTERCEPT</t><br/><br/>" +
        "<t color='#FFFFFF'>A high-value target has been identified moving through the AO." +
        " Intercept and contain the convoy before the target reaches its destination.</t>%1%2",
        _vehicleText,
        _identityText
    ];
    private _locateTaskTitle = "Locate HVT";
    private _locateTaskDescription = format [
        "<t size='1.8' color='#F7B267'>LOCATE HIGH VALUE TARGET</t><br/><br/>" +
        "<t color='#FFFFFF'>The HVT has dismounted and garrisoned in a nearby structure." +
        " Proceed with caution — the target may have reached a fortified position.</t>%1%2",
        _vehicleText,
        _identityText
    ];
    private _secureTaskTitle = "Secure HVT";
    private _secureTaskDescription = format [
        "<t size='1.8' color='#6EC1E4'>HVT IN CUSTODY</t><br/><br/>" +
        "<t color='#FFFFFF'>The HVT has surrendered and is now in custody." +
        " Maintain positive control and prepare for transfer to the extraction point.</t>%1%2",
        _vehicleText,
        _identityText
    ];

    private _captureTaskTitle = if (_isCaptureOrKill && {!_hasExtraction}) then {"Capture or Kill HVT"} else {"Capture HVT"};
    private _captureTaskDescription = if (_isCaptureOrKill && {!_hasExtraction}) then {
        "<t size='1.6' color='#F7B267'>CAPTURE PHASE</t><br/><br/>" +
        "<t color='#FFFFFF'>Intercept the HVT. Lethal resolution is authorized if capture is not viable.</t>"
    } else {
        "<t size='1.6' color='#F7B267'>CAPTURE PHASE</t><br/><br/>" +
        "<t color='#FFFFFF'>Force the HVT to surrender. The target must be secured alive — lethal force is not authorized.</t>"
    };

    private _extractTaskTitle = "Extract HVT";
    private _extractTaskDescription = format [
        "<t size='1.6' color='#6EC1E4'>EXTRACTION PHASE</t><br/><br/>" +
        "<t color='#FFFFFF'>Escort the surrendered HVT to the extraction point at grid </t>" +
        "<t color='#F4D35E'>%1</t><t color='#FFFFFF'> (within 50 m).</t>",
        mapGridPosition _extractionPos
    ];

    private _mainTaskId = format ["InterceptHVT_Main_%1", floor (random 1000000)];
    private _captureTaskId = format ["InterceptHVT_Capture_%1", floor (random 1000000)];
    private _extractTaskId = format ["InterceptHVT_Extract_%1", floor (random 1000000)];

    private _mainTaskArray = [_mainTaskId];
    if !(_taskParent isEqualTo "") then {
        _mainTaskArray pushBack _taskParent;
    };

    private _captureTaskArray = [_captureTaskId, _mainTaskId];
    private _mainTaskPos = if (_showTaskPosition) then {getPosATL _hvtUnit} else {[]};

    [
        true,
        _mainTaskArray,
        [_mainTaskDescription, _mainTaskTitle, "Intercept"],
        _mainTaskPos,
        "ASSIGNED",
        -1,
        true,
        _vehicleTaskType,
        false
    ] call BIS_fnc_taskCreate;

    [
        true,
        _captureTaskArray,
        [_captureTaskDescription, _captureTaskTitle, "Capture"],
        objNull,
        "CREATED",
        -1,
        false,
        "run",
        false
    ] call BIS_fnc_taskCreate;

    if (_showTaskPosition) then {
        [_mainTaskId, _hvtUnit] spawn OKS_fnc_InterceptHvt_UpdateTrackedTaskPos;
    };

    // Base the threshold on actual immediate guards (excluding HVT).
    // AllGuards now includes HVT as first member, so count only units with GOL_HVT_Guard variable.
    private _allImmediateGuards = _hvtUnit getVariable ["OKS_InterceptHvt_AllGuards", units _guardGroup];
    private _immediateGuardCount = {_x getVariable ["GOL_HVT_Guard", false]} count _allImmediateGuards;
    private _thresholdCount = ceil (_immediateGuardCount * (_surrenderThresholdPct / 100));
    private _garrisonTriggered = false;
    private _locatePhaseStarted = false;
    private _extractionPhaseStarted = false;
    private _finished = false;
    private _securedSince = -1;
    private _postSurrenderDelay = 5 + random 5;

    while {!_finished} do {
        sleep 1;

        if (!alive _hvtUnit) then {
            if (_isCaptureOrKill && {!_hasExtraction}) then {
                [_captureTaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
                [_mainTaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
            } else {
                [_captureTaskId, "FAILED", true] call BIS_fnc_taskSetState;
                [_mainTaskId, "FAILED", true] call BIS_fnc_taskSetState;
                if (_extractionPhaseStarted) then {
                    [_extractTaskId, "FAILED", true] call BIS_fnc_taskSetState;
                };
            };
            _finished = true;
        } else {
            // Count only immediate guards (exclude HVT) that are alive and not incapacitated.
            // Wounded-down guards cannot protect the HVT so they are treated as eliminated.
            private _aliveGuards = {alive _x && {lifeState _x != "INCAPACITATED"} && {_x getVariable ["GOL_HVT_Guard", false]}} count (_hvtUnit getVariable ["OKS_InterceptHvt_AllGuards", units _guardGroup]);
            // Guard against repeated calls: SetHvtSurrendered is idempotent but calling it
            // every loop tick is wasteful and can produce noisy logs.
            if (
                !(_hvtUnit getVariable ["OKS_InterceptHvt_Surrendered", false]) &&
                !(_hvtUnit getVariable ["OKS_InterceptHvt_RefusedSurrender", false]) &&
                {_aliveGuards <= _thresholdCount}
            ) then {
                [_hvtUnit] call OKS_fnc_InterceptHvt_SetHvtSurrendered;
            };

            if (_hvtUnit getVariable ["OKS_InterceptHvt_Surrendered", false]) then {
                if (_hasExtraction) then {
                    private _hvtReadyForExtraction =
                        (_hvtUnit getVariable ["OKS_InterceptHvt_SurrenderActionDone", false]) &&
                        {vehicle _hvtUnit == _hvtUnit};

                    if (!_extractionPhaseStarted && {_hvtReadyForExtraction}) then {
                        _extractionPhaseStarted = true;
                        [_captureTaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
                        [_mainTaskId, [_secureTaskDescription, _secureTaskTitle, "Secure"]] call BIS_fnc_taskSetDescription;

                        [
                            true,
                            [_extractTaskId, _mainTaskId],
                            [_extractTaskDescription, _extractTaskTitle, "Extract"],
                            _extractionPos,
                            "CREATED",
                            -1,
                            false,
                            "land",
                            false
                        ] call BIS_fnc_taskCreate;

                        [_mainTaskId, _extractionPos] call BIS_fnc_taskSetDestination;
                        [_extractTaskId, true] call BIS_fnc_taskSetCurrent;
                    };

                    if (_extractionPhaseStarted) then {
                        private _onFootAtExtract = (vehicle _hvtUnit == _hvtUnit) && {(_hvtUnit distance2D _extractionPos) <= 50};
                        if (_onFootAtExtract) then {
                            _hvtUnit setVariable ["GOL_HVT_SECURED", true, true];
                            [_extractTaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
                            [_mainTaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
                            _finished = true;
                        };
                    };
                } else {
                    if ((_hvtUnit getVariable ["OKS_InterceptHvt_SurrenderActionDone", false]) && {vehicle _hvtUnit == _hvtUnit}) then {
                        if (_securedSince < 0) then {
                            _securedSince = time;
                            if (_hvtDebug) then {
                                format ["[INTERCEPT HVT] HVT surrendered on foot. Waiting %1s before task success.", round _postSurrenderDelay] call OKS_fnc_LogDebug;
                            };
                        };

                        if ((time - _securedSince) >= _postSurrenderDelay) then {
                            _hvtUnit setVariable ["GOL_HVT_SECURED", true, true];
                            [_captureTaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
                            [_mainTaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
                            _finished = true;
                        };
                    } else {
                        _securedSince = -1;
                    };
                };
            };

            if (!_finished) then {
                private _movingAsset = if (vehicle _hvtUnit == _hvtUnit) then {_hvtUnit} else {vehicle _hvtUnit};
                // Use _moveTarget (the road stop point) rather than _endPosition so the
                // vehicle's actual stopping point triggers arrival, not the abstract end pos.
                private _atDestination = _movingAsset distance2D _moveTarget < 60;
                if (_atDestination) then {
                    private _behaviorUpper = toUpperANSI _endBehavior;
                    private _assetSpeed = vectorMagnitude velocity _movingAsset;

                    if (!_locatePhaseStarted && {_assetSpeed <= 0.14}) then {
                        _locatePhaseStarted = true;
                        [_mainTaskId, [_locateTaskDescription, _locateTaskTitle, "Locate"]] call BIS_fnc_taskSetDescription;
                        [_mainTaskId, "search"] call BIS_fnc_taskSetType;
                    };

                    if (_behaviorUpper == "DISAPPEAR") then {
                        [_captureTaskId, "FAILED", true] call BIS_fnc_taskSetState;
                        [_mainTaskId, "FAILED", true] call BIS_fnc_taskSetState;
                        if (_extractionPhaseStarted) then {
                            [_extractTaskId, "FAILED", true] call BIS_fnc_taskSetState;
                        };
                        if (!isNull (vehicle _hvtUnit) && {vehicle _hvtUnit != _hvtUnit}) then {
                            deleteVehicle (vehicle _hvtUnit);
                        };
                        deleteVehicle _hvtUnit;
                        _finished = true;
                    } else {
                        if (isNil "_garrisonTriggered") then {
                            _garrisonTriggered = false;
                        };
                        if (!_garrisonTriggered) then {
                            if (_assetSpeed <= 0.14) then {
                                // Unlock before garrison so scripted doGetOut/leaveVehicle can eject occupants.
                                if (!isNull _vehicle && {alive _vehicle}) then { _vehicle lock 0; };
                                _garrisonTriggered = [_guardGroup, _hvtUnit, _endPosition, _overflowGroup, _hvtDebug] call OKS_fnc_InterceptHvt_GarrisonEnd;
                            };
                        };

                    };
                };
            };
        };
    };

    if (alive _hvtUnit) then {
        _hvtUnit setVariable ["OKS_InterceptHvt_TaskDone", true, true];
    };

    if (_hvtDebug) then {
        format ["[INTERCEPT HVT] Task loop ended for HVT %1", _hvtUnit] call OKS_fnc_LogDebug;
    };
};

_hvtUnit;