/*
    Function: OKS_fnc_AmphibiousAssault

    Description:
        Spawns a boat with crew and infantry passengers at a water position, then drives it
        through optional intermediate waypoints to a dismount position on or near shore. On
        arrival the passengers dismount and are assigned a behaviour (HUNT, STAY, or MOVE)
        via the dismountBehavior parameter. The boat uses a 3-level waypoint system: an
        auto-generated initial heading waypoint, user-provided mid waypoints for navigation
        around obstacles, and the final dismount position. If no mid waypoints are provided
        and the distance exceeds 800m, one is auto-generated at 60% of the route. Includes
        active beaching assistance with velocity nudging when near shore, and a final forced
        push if the boat hasn't reached land. After dismount, passengers join a new group
        and crew (driver, gunner, commander) remain with the boat. The boat can be set to
        STAY (immobilised), PATROL (water patrol), or DESPAWN after the assault. Note: the
        crew group is currently hardcoded to east side regardless of the _Side parameter.

    Parameters:
        0: _spawnPos         - ARRAY or OBJECT - Water spawn position [x,y,z] or spawn object
        1: _waypointArray    - ARRAY           - Intermediate waypoint positions (each element is [x,y,z] or object)
        2: _dismountPos      - ARRAY or OBJECT - Shore/dismount position [x,y,z] or object
        3: _dismountBehavior - STRING          - Passenger behaviour after dismounting: "HUNT", "STAY", or "MOVE" (default: "HUNT")
        4: _boatClassname    - STRING          - Boat vehicle classname (default: "B_Boat_Armed_01_minigun_F")
        5: _numUnits         - NUMBER          - Number of infantry passengers to spawn (default: 6)
        6: _postBehavior     - STRING          - Post-assault boat behaviour: "STAY", "PATROL", or "DESPAWN" (default: "STAY")
        7: _debug            - BOOLEAN         - Enable debug logging (default: false)

    Returns:
        ARRAY - [boat vehicle, mainGroup, crew array, passengerGroup]

    Example:
        [
            getPos boatSpawn_1,
            [getPos navWP_1, getPos navWP_2],
            getPos beach_1,
            "HUNT",
            "B_Boat_Armed_01_minigun_F",
            6,
            "STAY",
            false
        ] spawn OKS_fnc_AmphibiousAssault;
*/

if (!isServer) exitWith {};

params [
    ["_spawnPos", [0,0,0], [[], objNull]],
    ["_waypointArray", [], [[]]],
    ["_dismountPos", [0,0,0], [[], objNull]],
    ["_dismountBehavior", "HUNT", [""]],
    ["_boatClassname", "B_Boat_Armed_01_minigun_F", [""]],
    ["_numUnits", 6, [0]],
    ["_postBehavior", "STAY", [""]],
    ["_debug", false, [false]]
];

// Convert objects to positions
if (_spawnPos isEqualType objNull) then { _spawnPos = getPosASL _spawnPos; };
if (_dismountPos isEqualType objNull) then { _dismountPos = getPosASL _dismountPos; };

// Validate parameters
if (_spawnPos isEqualTo [0,0,0] || _dismountPos isEqualTo [0,0,0]) exitWith {
    "[AMPHIBIOUS_ASSAULT_V2] Invalid spawn or dismount position" spawn OKS_fnc_LogDebug;
    [objNull, grpNull, [], []]
};

if (_debug) then {
    format["[AMPHIBIOUS_ASSAULT_V2] Starting: %1 -> %2, %3 units, %4 behavior", 
        _spawnPos, _dismountPos, _numUnits, _dismountBehavior] spawn OKS_fnc_LogDebug;
};

// Create main group and spawn boat
private _mainGroup = createGroup east;
private _boat = createVehicle [_boatClassname, _spawnPos, [], 0, "CAN_COLLIDE"];
_boat setPosASL _spawnPos;

// Orient boat to face the dismount position (or first waypoint direction)
private _targetDirection = _spawnPos getDir _dismountPos;
_boat setDir _targetDirection;

if (_debug) then {
    format["[AMPHIBIOUS_ASSAULT_V2] Boat spawned: %1 at %2, facing %3°", _boat, _spawnPos, _targetDirection] spawn OKS_fnc_LogDebug;
};

// Initialize boat settings
_boat allowDamage false;
_boat engineOn true;
_boat limitSpeed 80; // High speed for assault
sleep 0.5;

// Create crew
private _crew = [];
private _driverUnit = _mainGroup createUnit ["O_Soldier_F", _spawnPos, [], 0, "CAN_COLLIDE"];
_driverUnit moveInDriver _boat;
_crew pushBack _driverUnit;

// Create gunner if available
if (_boat emptyPositions "gunner" > 0) then {
    private _gunnerUnit = _mainGroup createUnit ["O_Soldier_F", _spawnPos, [], 0, "CAN_COLLIDE"];
    _gunnerUnit moveInGunner _boat;
    _crew pushBack _gunnerUnit;
};

// Create commander if available
if (_boat emptyPositions "commander" > 0) then {
    private _commanderUnit = _mainGroup createUnit ["O_Soldier_F", _spawnPos, [], 0, "CAN_COLLIDE"];
    _commanderUnit moveInCommander _boat;
    _crew pushBack _commanderUnit;
};

if (_debug) then {
    format["[AMPHIBIOUS_ASSAULT_V2] Crew created: %1 members", count _crew] spawn OKS_fnc_LogDebug;
};

sleep 1;

// Create passengers
private _passengers = [];
for "_i" from 1 to _numUnits do {
    private _unit = _mainGroup createUnit ["O_Soldier_F", _spawnPos, [], 0, "CAN_COLLIDE"];
    _unit moveInCargo _boat;
    _passengers pushBack _unit;
    sleep 0.1;
};

if (_debug) then {
    format["[AMPHIBIOUS_ASSAULT_V2] Passengers created: %1", count _passengers] spawn OKS_fnc_LogDebug;
};

sleep 2;

// Re-enable damage after setup
_boat allowDamage true;

// Set group behavior for water travel
_mainGroup setBehaviour "CARELESS";
_mainGroup setCombatMode "BLUE";
_mainGroup setSpeedMode "FULL";

// Create 3-level waypoint system: spawn -> mid waypoints -> dismount
private _allWaypoints = [];

// Level 1: Starting waypoint (optional - for initial navigation away from spawn)
// This can help boats get oriented properly from spawn
private _initialWaypoint = _spawnPos getPos [300, _spawnPos getDir _dismountPos];
if (surfaceIsWater _initialWaypoint) then {
    _allWaypoints pushBack _initialWaypoint;
    if (_debug) then {
        format["[AMPHIBIOUS_ASSAULT_V2] Initial waypoint added: %1", _initialWaypoint] spawn OKS_fnc_LogDebug;
    };
};

// Level 2: Mid waypoints (user-provided guidance waypoints)
if (count _waypointArray > 0) then {
    {
        private _wpPos = _x;
        if (_wpPos isEqualType objNull) then { _wpPos = getPosASL _wpPos; };
        if (_wpPos isEqualType []) then {
            // Ensure waypoint is valid position
            if (count _wpPos >= 2) then {
                _allWaypoints pushBack _wpPos;
                if (_debug) then {
                    format["[AMPHIBIOUS_ASSAULT_V2] Mid waypoint %1 added: %2", _forEachIndex + 1, _wpPos] spawn OKS_fnc_LogDebug;
                };
            };
        };
    } forEach _waypointArray;
} else {
    // Auto-generate mid waypoint if none provided (helps with navigation)
    private _midDistance = _spawnPos distance _dismountPos;
    if (_midDistance > 800) then {
        private _autoMidWaypoint = _spawnPos getPos [_midDistance * 0.6, _spawnPos getDir _dismountPos];
        if (surfaceIsWater _autoMidWaypoint) then {
            _allWaypoints pushBack _autoMidWaypoint;
            if (_debug) then {
                format["[AMPHIBIOUS_ASSAULT_V2] Auto mid waypoint added: %1", _autoMidWaypoint] spawn OKS_fnc_LogDebug;
            };
        };
    };
};

// Level 3: Final dismount waypoint (always added)
_allWaypoints pushBack _dismountPos;
if (_debug) then {
    format["[AMPHIBIOUS_ASSAULT_V2] Final dismount waypoint: %1", _dismountPos] spawn OKS_fnc_LogDebug;
};

// Create waypoints for the group
private _waypointIndex = 1;
{
    private _wp = _mainGroup addWaypoint [_x, 0, _waypointIndex];
    _wp setWaypointType "MOVE";
    _wp setWaypointSpeed "FULL";
    
    // Adjust completion radius based on waypoint type
    if (_waypointIndex == count _allWaypoints) then {
        // Final waypoint - smaller radius for precise beaching
        _wp setWaypointCompletionRadius 20;
    } else {
        // Mid waypoints - larger radius for smoother navigation
        _wp setWaypointCompletionRadius 50;
    };
    
    if (_debug) then {
        private _wpType = if (_waypointIndex == 1 && count _allWaypoints > 2) then {"Initial"} else {
            if (_waypointIndex == count _allWaypoints) then {"Final"} else {"Mid"}
        };
        private _radiusSet = if (_waypointIndex == count _allWaypoints) then {20} else {50};
        format["[AMPHIBIOUS_ASSAULT_V2] %1 waypoint %2 set to %3 (radius: %4m)", 
            _wpType, _waypointIndex, _x, _radiusSet] spawn OKS_fnc_LogDebug;
    };
    
    _waypointIndex = _waypointIndex + 1;
} forEach _allWaypoints;

if (_debug) then {
    format["[AMPHIBIOUS_ASSAULT_V2] Total waypoints created: %1", count _allWaypoints] spawn OKS_fnc_LogDebug;
};

// Movement enhancement system - spawn to avoid blocking
[_boat, _dismountPos, _mainGroup, _debug] spawn {
    params ["_boat", "_targetPos", "_group", "_debug"];

    private _driver = driver _boat;
    if (isNull _driver) exitWith {};

    sleep 3; // Allow initial waypoint system to start

    while {alive _boat && canMove _boat && !isNull _driver} do {
        private _currentPos = getPosASL _boat;
        private _distToTarget = _currentPos distance _targetPos;

        // Exit when beached
        if (!(surfaceIsWater _currentPos)) exitWith {
            if (_debug) then {
                format["[AMPHIBIOUS_ASSAULT_V2] Beached. Distance to target: %1m", round _distToTarget] spawn OKS_fnc_LogDebug;
            };
        };

        private _beachRunComplete = false;

        if (_distToTarget <= 150) then {
            // --- Final beaching run ---
            // Take direct control: lock direction to shore and push hard every 0.2s.
            // AI waypoints are left in place but velocity impulses dominate at this frequency.
            if (_debug) then {
                format["[AMPHIBIOUS_ASSAULT_V2] Beaching run started at %1m", round _distToTarget] spawn OKS_fnc_LogDebug;
            };

            while {alive _boat && canMove _boat && surfaceIsWater (getPosASL _boat)} do {
                private _pos = getPosASL _boat;
                private _dirToShore = _pos getDir _targetPos;
                _boat setDir _dirToShore;
                _boat setVelocity ([sin _dirToShore, cos _dirToShore, 0] vectorMultiply 18);
                _boat forceSpeed 18;
                _boat limitSpeed 65;

                if (_debug && (time mod 3) < 0.2) then {
                    format["[AMPHIBIOUS_ASSAULT_V2] Beaching: %1m remaining", round (_pos distance _targetPos)] spawn OKS_fnc_LogDebug;
                };

                sleep 0.2;
            };
            _beachRunComplete = true;
        } else {
            // --- Long-range travel: AI drives, we assist speed ---
            private _currentSpeed = vectorMagnitude (velocity _boat);
            private _boatDir = getDir _boat;

            if (_distToTarget > 500) then {
                _boat limitSpeed 80; _boat forceSpeed 22;
            } else {
                if (_distToTarget > 200) then {
                    _boat limitSpeed 60; _boat forceSpeed 17;
                } else {
                    _boat limitSpeed 40; _boat forceSpeed 11;
                };
            };

            // Nudge if stuck in deep water
            if (_currentSpeed < 8) then {
                _boat setVelocity ([sin _boatDir, cos _boatDir, 0] vectorMultiply 15);
            };

            // Periodic doMove so AI doesn't idle
            if ((time mod 5) < 0.5) then { _driver doMove _targetPos; };

            if (_debug && (time mod 8) < 0.5) then {
                format["[AMPHIBIOUS_ASSAULT_V2] Travel: %1m at %2 m/s", round _distToTarget, round _currentSpeed] spawn OKS_fnc_LogDebug;
            };

            sleep 1;
        };

        if (_beachRunComplete) exitWith {}; // Beached or boat lost — exit outer loop
    };
};

// Wait for boat to reach shore - must be properly beached for safe dismount
private _maxWaitTime = 120; // 2 minute hard timeout
private _startTime = time;
private _nearShoreTime = -1;
waitUntil {
    sleep 2;
    private _currentPos = getPosASL _boat;
    private _distToTarget = _currentPos distance _dismountPos;
    private _onLand = !(surfaceIsWater _currentPos);
    private _timeout = (time - _startTime) > _maxWaitTime;

    // If stuck within 60m for >20s, proceed with dismount regardless of beaching
    if (_distToTarget < 60 && _nearShoreTime < 0) then { _nearShoreTime = time; };
    private _stuckNearShore = (_nearShoreTime > 0) && ((time - _nearShoreTime) > 20);

    (_distToTarget < 30 && !surfaceIsWater _currentPos) || _onLand || !alive _boat || !canMove _boat || _timeout || _stuckNearShore
};

// Final beaching attempt - more aggressive to ensure proper landing
private _finalPos = getPosASL _boat;
private _finalDist = _finalPos distance _dismountPos;
private _isOnLand = !(surfaceIsWater _finalPos);

// Always attempt final beaching if not on land - remove distance check
if (!_isOnLand && alive _boat && canMove _boat) then {
    if (_debug) then {
        format["[AMPHIBIOUS_ASSAULT_V2] Final beaching attempt - distance: %1m", _finalDist] spawn OKS_fnc_LogDebug;
    };
    
    // Continuous velocity application until beached
    private _beachingStart = time;
    private _maxBeachingTime = 45; // Increased time limit
    
    while {time - _beachingStart < _maxBeachingTime && alive _boat && canMove _boat} do {
        private _currentPos3 = getPosASL _boat;
        
        // Check if we're finally on land
        if (!surfaceIsWater _currentPos3) exitWith {
            if (_debug) then {
                "[AMPHIBIOUS_ASSAULT_V2] Successfully beached during final push" spawn OKS_fnc_LogDebug;
            };
        };
        
        // Calculate direction to shore for accurate velocity
        private _boatDir = getDir _boat;
        private _dirToShore = _currentPos3 getDir _dismountPos;
        
        // Apply velocity toward shore direction, not just boat direction
        private _shoreVelocity = [sin _dirToShore, cos _dirToShore, 0] vectorMultiply 18;
        _boat setVelocity _shoreVelocity;
        
        // Also force boat to face shore
        _boat setDir _dirToShore;
        
        // Force speed and limit adjustments
        _boat forceSpeed 15;
        _boat limitSpeed 50;
        
        if (_debug && (time mod 3) < 0.5) then {
            private _currentDist = _currentPos3 distance _dismountPos;
            format["[AMPHIBIOUS_ASSAULT_V2] Beaching push: %1m to shore, dir %2°", _currentDist, round _dirToShore] spawn OKS_fnc_LogDebug;
        };
        
        sleep 0.2; // Shorter sleep for more frequent velocity application
    };
};

if (_debug) then {
    private _finalDist = (getPosASL _boat) distance _dismountPos;
    private _onShore = !(surfaceIsWater (getPosASL _boat));
    format["[AMPHIBIOUS_ASSAULT_V2] Boat arrival complete. Final distance: %1m, On shore: %2", _finalDist, _onShore] spawn OKS_fnc_LogDebug;
};

// Verify boat is properly beached before dismounting - with active velocity assistance
private _boatPos = getPosASL _boat;
if (surfaceIsWater _boatPos) then {
    if (_debug) then {
        "[AMPHIBIOUS_ASSAULT_V2] WARNING: Boat still in water - applying continuous beaching velocity" spawn OKS_fnc_LogDebug;
    };
    
    // Actively push boat onto land with continuous velocity
    private _beachWaitStart = time;
    while {surfaceIsWater (getPosASL _boat) && (time - _beachWaitStart) < 60 && alive _boat && canMove _boat} do {
        private _currentBoatPos = getPosASL _boat;
        private _dirToShore = _currentBoatPos getDir _dismountPos;
        
        // Strong continuous push toward shore
        private _beachVelocity = [sin _dirToShore, cos _dirToShore, 0] vectorMultiply 20;
        _boat setVelocity _beachVelocity;
        _boat setDir _dirToShore;
        _boat forceSpeed 18;
        
        if (_debug && (time mod 4) < 0.5) then {
            private _distToShore = _currentBoatPos distance _dismountPos;
            format["[AMPHIBIOUS_ASSAULT_V2] Active beaching: %1m to shore", _distToShore] spawn OKS_fnc_LogDebug;
        };
        
        sleep 0.3;
    };
    
    // Final status check
    if (!surfaceIsWater (getPosASL _boat)) then {
        if (_debug) then {
            "[AMPHIBIOUS_ASSAULT_V2] Boat successfully forced onto land" spawn OKS_fnc_LogDebug;
        };
    } else {
        if (_debug) then {
            "[AMPHIBIOUS_ASSAULT_V2] WARNING: Boat still in water after extended beaching attempt" spawn OKS_fnc_LogDebug;
        };
    };
};

// Dismount passengers - GETOUT waypoint triggers AI dismount, moveOut as fallback
sleep 1;

// Add GETOUT waypoint so the AI handles dismount naturally
private _getoutWP = _mainGroup addWaypoint [_dismountPos, 0];
_getoutWP setWaypointType "GETOUT";
_getoutWP setWaypointCompletionRadius 5;

if (_debug) then {
    "[AMPHIBIOUS_ASSAULT_V2] GETOUT waypoint added - waiting for AI dismount" spawn OKS_fnc_LogDebug;
};

// Wait for AI to dismount passengers (up to 15 seconds)
private _dismountWaitStart = time;
waitUntil {
    sleep 0.5;
    private _stillInBoat = _passengers select {alive _x && vehicle _x == _boat};
    (count _stillInBoat == 0) || (time - _dismountWaitStart > 15)
};

// Force dismount any passengers still in boat
{
    if (alive _x && vehicle _x == _boat) then {
        unassignVehicle _x;
        moveOut _x;
        if (_debug) then {
            format["[AMPHIBIOUS_ASSAULT_V2] Forced moveOut of unit %1", name _x] spawn OKS_fnc_LogDebug;
        };
    };
} forEach _passengers;

sleep 0.5;

// Create separate group for passengers
private _passengerGroup = createGroup east;

// Calculate inland rally point 25m beyond dismount position
private _inlandDir = _spawnPos getDir _dismountPos;
private _rallyPos = _dismountPos getPos [25, _inlandDir];

// Reassign passengers to new group with AI re-enabled
{
    if (alive _x) then {
        [_x] joinSilent _passengerGroup;
        _x enableAI "MOVE";
        _x enableAI "TARGET";
        _x enableAI "AUTOTARGET";
        _x enableAI "FSM";
        _x setBehaviour "AWARE";
        _x setCombatMode "YELLOW";
        if (_debug) then {
            format["[AMPHIBIOUS_ASSAULT_V2] Unit %1 reassigned to passenger group", name _x] spawn OKS_fnc_LogDebug;
        };
    };
} forEach _passengers;

// Move passengers to inland rally point before starting assault behavior
private _rallyWP = _passengerGroup addWaypoint [_rallyPos, 0];
_rallyWP setWaypointType "MOVE";
_rallyWP setWaypointSpeed "FULL";
_rallyWP setWaypointCompletionRadius 10;

if (_debug) then {
    format["[AMPHIBIOUS_ASSAULT_V2] Passengers moving to rally point %1 (25m inland)", _rallyPos] spawn OKS_fnc_LogDebug;
};

sleep 1; // Brief pause before behavior switch

// Handle dismount behavior
switch (toUpper _dismountBehavior) do {
    case "HUNT": {
        if (count (units _passengerGroup) > 0) then {
            // Wait for passengers to reach the inland rally point, then activate HUNT
            [_passengerGroup, _rallyPos, _debug] spawn {
                params ["_passengerGroup", "_rallyPos", "_debug"];
                
                private _huntWaitStart = time;
                waitUntil {
                    sleep 1;
                    private _grpLeader = leader _passengerGroup;
                    (count (units _passengerGroup) == 0) ||
                    (!isNull _grpLeader && _grpLeader distance _rallyPos < 30) ||
                    (time - _huntWaitStart > 60)
                };
                
                if (count (units _passengerGroup) > 0) then {
                    _passengerGroup setBehaviour "COMBAT";
                    _passengerGroup setCombatMode "RED";
                    _passengerGroup setSpeedMode "FULL";
                    
                    {
                        if (alive _x) then {
                            _x setSkill ["aimingAccuracy", 0.6];
                            _x setSkill ["aimingSpeed", 0.7];
                            _x setSkill ["spotDistance", 0.8];
                            _x setSkill ["spotTime", 0.7];
                            _x setSkill ["courage", 0.9];
                            _x setSkill ["commanding", 0.8];
                        };
                    } forEach (units _passengerGroup);
                    
                    if (_debug) then {
                        format["[AMPHIBIOUS_ASSAULT_V2] %1 passengers engaged HUNT at rally point", count (units _passengerGroup)] spawn OKS_fnc_LogDebug;
                    };
                };
            };
        };
    };
    
    case "STAY": {
        if (count (units _passengerGroup) > 0) then {
            _passengerGroup setBehaviour "AWARE";
            _passengerGroup setCombatMode "YELLOW";
            _passengerGroup setSpeedMode "LIMITED";
            
            {
                if (alive _x) then {
                    _x setUnitPos "MIDDLE";
                    _x doWatch objNull; // Stop watching anything specific
                };
            } forEach (units _passengerGroup);
            
            if (_debug) then {
                "[AMPHIBIOUS_ASSAULT_V2] Passengers set to STAY behavior" spawn OKS_fnc_LogDebug;
            };
        };
    };
    
    case "MOVE": {
        if (count (units _passengerGroup) > 0) then {
            _passengerGroup setBehaviour "AWARE";
            _passengerGroup setCombatMode "YELLOW";
            _passengerGroup setSpeedMode "NORMAL";
            
            private _movePos = _dismountPos getPos [200, random 360];
            private _wp = _passengerGroup addWaypoint [_movePos, 0];
            _wp setWaypointType "MOVE";
            _wp setWaypointSpeed "NORMAL";
            _wp setWaypointCompletionRadius 50;
            
            if (_debug) then {
                format["[AMPHIBIOUS_ASSAULT_V2] Passengers moving to %1", _movePos] spawn OKS_fnc_LogDebug;
            };
        };
    };
};

// Handle post-boat behavior
switch (toUpper _postBehavior) do {
    case "DESPAWN": {
        sleep 10;
        if (alive _boat) then {
            {
                if (alive _x && vehicle _x == _boat) then {
                    deleteVehicle _x;
                };
            } forEach _crew;
            deleteVehicle _boat;
            
            if (_debug) then {
                "[AMPHIBIOUS_ASSAULT_V2] Boat and crew despawned" spawn OKS_fnc_LogDebug;
            };
        };
    };
    
    case "PATROL": {
        sleep 5;
        if (alive _boat && canMove _boat && count _crew > 0) then {
            // Create patrol waypoints around the area
            private _patrolRadius = 800;
            for "_i" from 1 to 3 do {
                private _patrolPos = _dismountPos getPos [_patrolRadius, (120 * _i)];
                // Ensure patrol position is in water
                if (surfaceIsWater _patrolPos) then {
                    private _wp = _mainGroup addWaypoint [_patrolPos, 0];
                    _wp setWaypointType "MOVE";
                    _wp setWaypointSpeed "LIMITED";
                    _wp setWaypointCompletionRadius 100;
                };
            };
            
            // Set final waypoint to cycle
            private _cycleWp = _mainGroup addWaypoint [_dismountPos, 0];
            _cycleWp setWaypointType "CYCLE";
            
            _mainGroup setBehaviour "AWARE";
            _mainGroup setCombatMode "YELLOW";
            
            if (_debug) then {
                "[AMPHIBIOUS_ASSAULT_V2] Boat set to patrol behavior" spawn OKS_fnc_LogDebug;
            };
        };
    };
    
    default { // "STAY"
        if (alive _boat && count _crew > 0) then {
            // Immobilize the boat completely for STAY behavior
            _boat engineOn false;
            _boat setFuel 0; // Prevent movement
            _boat limitSpeed 0;
            _boat forceSpeed 0;
            
            _mainGroup setBehaviour "SAFE";
            _mainGroup setCombatMode "RED";
            _mainGroup setSpeedMode "NORMAL";
            
            // Ensure crew stays put
            {
                if (alive _x) then {
                    _x disableAI "MOVE";
                    _x disableAI "FSM";
                };
            } forEach _crew;
            
            if (_debug) then {
                "[AMPHIBIOUS_ASSAULT_V2] Boat immobilized and staying in position" spawn OKS_fnc_LogDebug;
            };
        };
    };
};

// Ensure crew stays with boat and doesn't dismount
sleep 1;
{
    if (alive _x && vehicle _x != _boat) then {
        // If crew somehow got out, force them back in
        if (_x == driver _boat) then {
            _x moveInDriver _boat;
        } else {
            if (_boat emptyPositions "gunner" > 0 && !isNull gunner _boat && gunner _boat != _x) then {
                _x moveInGunner _boat;
            } else {
                if (_boat emptyPositions "commander" > 0 && !isNull commander _boat && commander _boat != _x) then {
                    _x moveInCommander _boat;
                };
            };
        };
    };
} forEach _crew;

// Set crew to defensive mode to avoid leaving boat
_mainGroup setBehaviour "SAFE";
_mainGroup setCombatMode "BLUE"; // Hold fire unless fired upon

if (_debug) then {
    format["[AMPHIBIOUS_ASSAULT_V2] Amphibious assault complete. Passengers in group: %1, Crew in boat: %2", 
        count (units _passengerGroup), count _crew] spawn OKS_fnc_LogDebug;
};

// Return created objects - note _passengerGroup instead of _passengers array
[_boat, _mainGroup, _crew, _passengerGroup]