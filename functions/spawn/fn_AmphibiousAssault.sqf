/*
    OKS_fnc_AmphibiousAssault_v2 - Boat-specific movement version
    
    Creates a boat with crew and passengers that moves to a beach position using boat-compatible commands.
    Uses 3-level waypoint system + forceSpeed/limitSpeed + setVelocityModelSpace for reliable boat movement.
    
    3-LEVEL WAYPOINT SYSTEM:
    Level 1: Spawn -> Initial orientation waypoint (auto-generated)
    Level 2: Mid waypoints -> User-provided guidance waypoints (optional)
    Level 3: Final -> Dismount/beach position (always present)
    
    Parameters:
    0. _spawnPos         - Array or Object: Spawn position for the boat
    1. _waypointArray    - Array: Mid-level waypoint positions [pos1, pos2, ...] [Optional]
    2. _dismountPos      - Array or Object: Target beach/dismount position  
    3. _dismountBehavior - String: What units do after dismount ("HUNT", "STAY", "MOVE")
    4. _boatClassname    - String: Classname of boat to spawn
    5. _numUnits         - Number: Number of passenger units to create (excluding crew)
    6. _postBehavior     - String: What boat does after dismount ("STAY", "DESPAWN", "PATROL") [Optional]
    7. _debug           - Boolean: Enable debug logging [Optional, default: false]
    
    Returns: Array - [boat object, main group, crew array, passenger array]
    
    Examples:
    // Basic assault (auto waypoints)
    [getMarkerPos "boat_spawn", [], getMarkerPos "beach_assault", "HUNT", "B_Boat_Armed_01_minigun_F", 8] call OKS_fnc_AmphibiousAssault_v2;
    
    // With custom mid waypoints
    private _midWP1 = getMarkerPos "nav_point_1";
    private _midWP2 = getMarkerPos "nav_point_2"; 
    [boat_spawn_pos, [_midWP1, _midWP2], beach_pos, "HUNT", "B_Boat_Armed_01_minigun_F", 6, "PATROL", true] call OKS_fnc_AmphibiousAssault_v2;
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
        private _currentSpeed = vectorMagnitude (velocity _boat);
        private _boatDir = getDir _boat;
        private _dirToTarget = _currentPos getDir _targetPos;
        
        // Calculate angle difference to target
        private _angleDiff = _dirToTarget - _boatDir;
        while {_angleDiff > 180} do {_angleDiff = _angleDiff - 360};
        while {_angleDiff < -180} do {_angleDiff = _angleDiff + 360};
        private _isPointingAtTarget = (abs _angleDiff) < 45; // Within 45 degrees
        
        // Check if we've reached the shore
        if (_distToTarget < 30 || !(surfaceIsWater _currentPos)) exitWith {
            if (_debug) then {
                format["[AMPHIBIOUS_ASSAULT_V2] Reached shore. Distance: %1m", _distToTarget] spawn OKS_fnc_LogDebug;
            };
        };
        
        // Speed management based on distance
        if (_distToTarget > 500) then {
            _boat limitSpeed 80;
            _boat forceSpeed 22; // ~80 kph
        } else {
            if (_distToTarget > 200) then {
                _boat limitSpeed 60;
                _boat forceSpeed 17; // ~60 kph
            } else {
                _boat limitSpeed 40;
                _boat forceSpeed 11; // ~40 kph - slower for beaching
            };
        };
        
        // Beach approach system - smart nudging when close to shore
        if (_distToTarget < 150 && _distToTarget > 30) then {
            // Check if boat is moving too slowly near beach
            if (_currentSpeed < 5) then {
                if (_isPointingAtTarget) then {
                    // Gentle forward nudge in current direction (don't force alignment)
                    private _currentVelocity = velocity _boat;
                    private _forwardNudge = [sin _boatDir, cos _boatDir, 0] vectorMultiply 8;
                    _boat setVelocity (_currentVelocity vectorAdd _forwardNudge);
                    
                    if (_debug) then {
                        format["[AMPHIBIOUS_ASSAULT_V2] Beach nudge applied - pointing at target (angle: %1°)", _angleDiff] spawn OKS_fnc_LogDebug;
                    };
                } else {
                    // Boat not pointing at beach, let AI reorient first
                    _driver doWatch _targetPos;
                    _driver doMove _targetPos;
                    
                    if (_debug) then {
                        format["[AMPHIBIOUS_ASSAULT_V2] Reorienting boat toward beach (angle off: %1°)", _angleDiff] spawn OKS_fnc_LogDebug;
                    };
                };
            };
        } else {
            // Normal velocity boost for boats stuck in deep water
            if (_currentSpeed < 8 && _distToTarget > 150) then {
                private _boostVelocity = [sin _boatDir, cos _boatDir, 0] vectorMultiply 15;
                _boat setVelocity _boostVelocity;
                
                if (_debug) then {
                    format["[AMPHIBIOUS_ASSAULT_V2] Deep water velocity boost: %1 m/s", 15] spawn OKS_fnc_LogDebug;
                };
            };
        };
        
        // Backup doMove commands every few seconds
        if ((time mod 5) < 0.5) then {
            _driver doMove _targetPos;
        };
        
        // Status logging
        if (_debug && (time mod 8) < 0.5) then {
            format["[AMPHIBIOUS_ASSAULT_V2] Status - Dist: %1m, Speed: %2 m/s, Angle: %3°, Pointing: %4", 
                _distToTarget, _currentSpeed, round _angleDiff, _isPointingAtTarget] spawn OKS_fnc_LogDebug;
        };
        
        sleep 1;
    };
};

// Wait for boat to reach shore - must be properly beached for safe dismount
private _maxWaitTime = 300; // 5 minute timeout
private _startTime = time;
waitUntil {
    sleep 2;
    private _currentPos = getPosASL _boat;
    private _distToTarget = _currentPos distance _dismountPos;
    private _onLand = !(surfaceIsWater _currentPos);
    private _timeout = (time - _startTime) > _maxWaitTime;
    
    // Only dismount when actually on land or very close AND not in deep water
    (_distToTarget < 30 && !surfaceIsWater _currentPos) || _onLand || !alive _boat || !canMove _boat || _timeout
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

// Dismount passengers properly - only when safe
sleep 1;

// First, create separate group for passengers BEFORE dismounting
private _passengerGroup = createGroup east;

// Dismount and reassign passengers
{
    if (alive _x && vehicle _x == _boat) then {
        // Unassign from vehicle first to prevent re-mounting
        unassignVehicle _x;
        
        // Force dismount
        moveOut _x;
        
        // Join new group immediately to break ties with crew
        [_x] joinSilent _passengerGroup;
        
        // Enable AI combat abilities
        _x enableAI "MOVE";
        _x enableAI "TARGET";
        _x enableAI "AUTOTARGET";
        _x enableAI "FSM";
        
        // Override careless behavior from transport - set to combat ready
        _x setBehaviour "AWARE";
        _x setCombatMode "YELLOW";
        
        if (_debug) then {
            format["[AMPHIBIOUS_ASSAULT_V2] Unit %1 dismounted, reassigned, and set to AWARE", name _x] spawn OKS_fnc_LogDebug;
        };
    };
} forEach _passengers;

sleep 2; // Allow time for dismount to complete

// Handle dismount behavior
switch (toUpper _dismountBehavior) do {
    case "HUNT": {
        if (count (units _passengerGroup) > 0) then {
            _passengerGroup setBehaviour "COMBAT";
            _passengerGroup setCombatMode "RED";
            _passengerGroup setSpeedMode "FULL";
            
            // Enable aggressive AI settings for hunt mode
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
                format["[AMPHIBIOUS_ASSAULT_V2] %1 passengers set to HUNT behavior with aggressive settings", count (units _passengerGroup)] spawn OKS_fnc_LogDebug;
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
            _mainGroup setCombatMode "BLUE";
            _mainGroup setSpeedMode "NO CHANGE";
            
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