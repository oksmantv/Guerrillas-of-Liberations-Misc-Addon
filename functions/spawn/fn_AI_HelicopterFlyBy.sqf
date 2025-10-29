/*
    Function: AI Helicopter Fly-By - Looping Helicopter Transit System
    
    Creates persistent helicopter fly-by missions where helicopters spawn, fly to endpoint,
    return to spawn, and delete. Continues looping with configurable delays and helicopter types.

    Example:
    _helicopterFlyByRef = [
        heli_spawn_1,               // Helicopter spawn object
        heli_endpoint_1,            // Flight endpoint object
        west,                       // Side faction
        ["B_Heli_Transport_01_F"],  // Helicopter classes
        true,                        // Enable resupply drops (uses default supplies)
        [90, 180],                  // Delay between flyby missions [min, max] seconds
        150,                        // Flight altitude (meters)
        "STEALTH",                  // Flight behavior
        true,                       // Enable looping
        -1,                         // Max flyby missions (-1 = infinite)
        30                          // Cleanup delay after completion
        
    ] call OKS_fnc_AI_HelicopterFlyBy;
    
    // Control the flyby:
    _helicopterFlyByRef setVariable ["OKS_HeliFlyBy_On", false]; // Stop flyby
    _helicopterFlyByRef setVariable ["OKS_HeliFlyBy_Pause", true]; // Pause flyby
    _helicopterFlyByRef getVariable ["OKS_HeliFlyBy_Mission", 0]; // Get current mission number
*/

if (!isServer) exitWith {};

params [
    ["_SpawnPoint", objNull, [objNull]],
    ["_EndPoint", objNull, [objNull]],
    ["_Side", west, [sideUnknown]],
    ["_HelicopterClasses", ["B_Heli_Transport_01_F"], [[]]],
    ["_EnableResupplyDrop", false, [false]],         // Enable parachute resupply drops (uses defaults)
    ["_FlyByDelay", [90, 180], [[]]],                // Delay between flyby missions [min, max] seconds
    ["_FlightAltitude", 250, [0]],                   // Flight altitude in meters
    ["_FlightBehaviour", "STEALTH", [""]],           // Flight behavior mode
    ["_ShouldLoop", true, [false]],                  // Enable continuous flyby missions
    ["_MaxFlyByMissions", -1, [0]],                  // Maximum missions (-1 = infinite)
    ["_CleanupDelay", 30, [0]]                       // Delay before cleanup
];

// Validate and process delay array
private _minDelay = 60; // Default minimum 1 minute
private _maxDelay = 300; // Default maximum 5 minutes

if (typeName _FlyByDelay == "ARRAY" && count _FlyByDelay >= 2) then {
    _minDelay = _FlyByDelay select 0;
    _maxDelay = _FlyByDelay select 1;
    
    // Ensure min is not greater than max
    if (_minDelay > _maxDelay) then {
        private _temp = _minDelay;
        _minDelay = _maxDelay;
        _maxDelay = _temp;
    };
    
    // Ensure reasonable minimums
    if (_minDelay < 30) then {_minDelay = 30};
    if (_maxDelay < 60) then {_maxDelay = 60};
} else {
    // Handle backward compatibility - if single number provided
    if (typeName _FlyByDelay == "SCALAR") then {
        _minDelay = _FlyByDelay * 0.75; // 75% of provided value
        _maxDelay = _FlyByDelay * 1.25; // 125% of provided value
        if (_minDelay < 30) then {_minDelay = 30};
    };
};

// Debug initialization
if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
    format["[HELI_FLYBY] Initializing helicopter flyby system - Loop: %1, MaxMissions: %2, Delay: %3-%4s, Altitude: %5m", 
        _ShouldLoop, _MaxFlyByMissions, _minDelay, _maxDelay, _FlightAltitude] call OKS_fnc_LogDebug;
    format["[HELI_FLYBY] Side: %1 (%2 classes), Behavior: %3, ResupplyDrop: %4", 
        _Side, count _HelicopterClasses, _FlightBehaviour, _EnableResupplyDrop] call OKS_fnc_LogDebug;
    if (_EnableResupplyDrop) then {
        "[HELI_FLYBY] Resupply drops enabled - using default supplies" call OKS_fnc_LogDebug;
    };
};

// Validation checks
private _validatePosition = {
    params ["_pos"];
    (_pos distance [0,0,0] > 100) && 
    (count (allPlayers select {(_x distance _pos) < 200}) == 0) // No players within 200m
};

if (!([getPos _SpawnPoint] call _validatePosition)) exitWith {
    format["[HELI_FLYBY] Invalid spawn position %1 - helicopter flyby cancelled", getPos _SpawnPoint] call OKS_fnc_LogDebug;
    objNull
};

if (!([getPos _EndPoint] call _validatePosition)) exitWith {
    format["[HELI_FLYBY] Invalid endpoint position %1 - helicopter flyby cancelled", getPos _EndPoint] call OKS_fnc_LogDebug;
    objNull
};

// Generate unique flyby ID
private _flybyId = format["HeliFlyBy_%1", round(time * 1000)];

// Initialize flyby control variables on spawn object (returned as control object)
_SpawnPoint setVariable ["OKS_HeliFlyBy_On", true, true];
_SpawnPoint setVariable ["OKS_HeliFlyBy_Mission", 0, true];
_SpawnPoint setVariable ["OKS_HeliFlyBy_Pause", false, true];
_SpawnPoint setVariable ["OKS_HeliFlyBy_FlybyId", _flybyId, true];

if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
    format["[HELI_FLYBY] Flyby control variables initialized - Flyby ID: %1", _flybyId] call OKS_fnc_LogDebug;
};

// Main helicopter flyby system
private _helicopterFlyBySystem = {
    params ["_SpawnPoint", "_EndPoint", "_Side", "_HelicopterClasses", "_minDelay", "_maxDelay", "_FlightAltitude", "_FlightBehaviour", "_ShouldLoop", "_MaxFlyByMissions", "_CleanupDelay", "_flybyId", "_EnableResupplyDrop"];
    
    // Spawn helicopter function
    private _spawnHelicopter = {
        params ["_spawnObj", "_helicopterClasses", "_side", "_flybyId", "_flightAltitude", "_flightBehaviour"];
        
        private _spawnPos = getPos _spawnObj;
        private _spawnDir = getDir _spawnObj;
        private _selectedClass = selectRandom _helicopterClasses;
        
        // Spawn helicopter at altitude
        private _spawnPosAlt = [_spawnPos select 0, _spawnPos select 1, _flightAltitude];
        private _helicopter = createVehicle [_selectedClass, _spawnPosAlt, [], 0, "FLY"];
        
        if (isNull _helicopter) exitWith {
            format["[HELI_FLYBY] Failed to create helicopter %1 at position %2", _selectedClass, _spawnPosAlt] call OKS_fnc_LogDebug;
            objNull
        };
        
        // Store helicopter reference before crew call (in case OKS_fnc_AddVehicleCrew modifies variables)
        private _heliVehicle = _helicopter;
        
        // Set helicopter direction and position
        _heliVehicle setDir _spawnDir;
        _heliVehicle setPos _spawnPosAlt;
        
        // Add crew
        [_heliVehicle, _side] call OKS_fnc_AddVehicleCrew;
        
        // Set helicopter flyby variables for identification
        _heliVehicle setVariable ["OKS_HeliFlyBy_Vehicle", true, true];
        _heliVehicle setVariable ["OKS_HeliFlyBy_FlybyId", _flybyId, true];
        
        // Setup crew behavior - stealth and non-engaging
        {
            if (!isNull _x) then {
                _x allowFleeing 0;
                _x setBehaviour _flightBehaviour;
                _x setCombatMode "BLUE";  // Hold fire, defend only
                _x setSkill ["courage", 1.0];
                _x setSkill ["commanding", 0.1];  // Low commanding to reduce reactive behavior
                
                // Store original helicopter reference for dismount monitoring
                _x setVariable ["OKS_HeliFlyBy_OriginalHelicopter", _heliVehicle, true];
                _x setVariable ["OKS_HeliFlyBy_FlybyId", _flybyId, true];
                
                // Player interference prevention
                {
                    private _player = _x;
                    _x ignoreTarget _player;
                } forEach allPlayers;
                
                // Disable AI chatter
                _x setVariable ["BIS_noCoreConversations", true];
                _x disableConversation true;
                _x setSpeaker "NoVoice";
            };
        } forEach units (group driver _heliVehicle);
        
        // Disable collision lights and make careless
        _heliVehicle setPilotLight false;
        _heliVehicle setCollisionLight false;
        
        // Set fuel to full
        _heliVehicle setFuel 1;
        
        if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
            format["[HELI_FLYBY] Spawned %1 for %2 with %3 crew members at altitude %4m", 
                _selectedClass, _side, count units (group driver _heliVehicle), _FlightAltitude] call OKS_fnc_LogDebug;
        };
        
        _heliVehicle
    };
    
    // Flight mission function
    private _executeFlightMission = {
        params ["_helicopter", "_endPoint", "_spawnPoint", "_altitude", "_missionNumber", "_enableResupply", "_flightBehaviour"];
        
        if (isNull _helicopter || !alive _helicopter) exitWith {
            if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
                format["[HELI_FLYBY] Helicopter destroyed before mission %1 could start", _missionNumber] call OKS_fnc_LogDebug;
            };
            false
        };
        
        private _endPos = getPos _endPoint;
        private _spawnPos = getPos _spawnPoint;
        private _endPosAlt = [_endPos select 0, _endPos select 1, _altitude];
        private _spawnPosAlt = [_spawnPos select 0, _spawnPos select 1, _altitude];
        
        if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
            format["[HELI_FLYBY] Mission %1: %2 starting flyby from %3 to %4 (ResupplyDrop: %5)", 
                _missionNumber, typeOf _helicopter, _spawnPos, _endPos, _enableResupply] call OKS_fnc_LogDebug;
        };
        
        // Create waypoints for the flight
        private _group = group driver _helicopter;
        
        // Clear existing waypoints
        while {count waypoints _group > 0} do {
            deleteWaypoint [_group, 0];
        };
        
        // Waypoint 1: Fly to endpoint
        private _wp1 = _group addWaypoint [_endPosAlt, 0];
        _wp1 setWaypointType "MOVE";
        _wp1 setWaypointSpeed "NORMAL";
        _wp1 setWaypointBehaviour _FlightBehaviour;
        _wp1 setWaypointCombatMode "BLUE";
        _wp1 setWaypointCompletionRadius 200;
        
        // Waypoint 2: Return to spawn
        private _wp2 = _group addWaypoint [_spawnPosAlt, 0];
        _wp2 setWaypointType "MOVE";
        _wp2 setWaypointSpeed "NORMAL";
        _wp2 setWaypointBehaviour _FlightBehaviour;
        _wp2 setWaypointCombatMode "BLUE";
        _wp2 setWaypointCompletionRadius 200;
        
        if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
            format["[HELI_FLYBY] Mission %1: Waypoints set for %2 - flying to endpoint then returning", 
                _missionNumber, typeOf _helicopter] call OKS_fnc_LogDebug;
        };
        
        // Wait for helicopter to reach endpoint or be destroyed
        private _reachedEndpoint = false;
        private _resupplyDropped = false;
        private _startTime = time;
        private _maxFlightTime = 600; // 10 minutes maximum flight time
        private _allUnits = units (group driver _helicopter);

        // Dismount monitoring function for helicopter crew
        private _monitorDismountedCrew = {
            params ["_allUnits"];
            
            private _eliminatedCount = 0;
            
            {
                private _unit = _x;
                if (alive _unit && !isNull _unit) then {
                    private _originalHelicopter = _unit getVariable ["OKS_HeliFlyBy_OriginalHelicopter", objNull];
                    if (!isNull _originalHelicopter) then {
                        // Check if unit is dismounted (not in helicopter)
                        if (isNull (vehicle _unit) || vehicle _unit == _unit || vehicle _unit != _originalHelicopter) then {
                            private _dismountTime = _unit getVariable ["OKS_HeliFlyBy_DismountTime", -1];
                            
                            if (_dismountTime == -1) then {
                                _unit setVariable ["OKS_HeliFlyBy_DismountTime", time, true];
                                
                                if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
                                    format["[HELI_FLYBY] %1 dismounted from helicopter - 30 second countdown started", name _unit] call OKS_fnc_LogDebug;
                                };
                            } else {
                                if ((time - _dismountTime) > 30) then {
                                    _unit setDamage 1;
                                    _eliminatedCount = _eliminatedCount + 1;
                                    
                                    if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
                                        format["[HELI_FLYBY] Eliminated %1 after %2 seconds dismounted", 
                                            name _unit, round(time - _dismountTime)] call OKS_fnc_LogDebug;
                                    };
                                };
                            };
                        } else {
                            // Unit is back in helicopter - reset timer
                            _unit setVariable ["OKS_HeliFlyBy_DismountTime", -1, true];
                        };
                    };
                };
            } forEach _allUnits;
            
            _eliminatedCount
        };       
        
        while {alive _helicopter && !isNull _helicopter && !_reachedEndpoint && (time - _startTime) < _maxFlightTime} do {
            sleep 5;
            
            // Monitor dismounted crew
            [_allUnits] call _monitorDismountedCrew;
            
            private _distanceToEndpoint = _helicopter distance _endPosAlt;
            
            // Check for resupply drop when approaching endpoint
            if (_enableResupply && !_resupplyDropped && _distanceToEndpoint < 500 && _distanceToEndpoint > 200) then {
                _resupplyDropped = true;
                
                if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
                    format["[HELI_FLYBY] Mission %1: %2 dropping resupply at %3m from endpoint", 
                        _missionNumber, typeOf _helicopter, round _distanceToEndpoint] call OKS_fnc_LogDebug;
                };
                
                // Execute resupply drop using all defaults
                [_helicopter] call OKS_fnc_AI_ResupplyDrop;
            };
            
            // Check if helicopter reached endpoint (within 300m)
            if (_distanceToEndpoint < 300) then {
                _reachedEndpoint = true;
                
                if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
                    format["[HELI_FLYBY] Mission %1: %2 reached endpoint, beginning return flight", 
                        _missionNumber, typeOf _helicopter] call OKS_fnc_LogDebug;
                };
            };
        };
        
        // If helicopter was destroyed before reaching endpoint, mission is complete
        if (!alive _helicopter || isNull _helicopter) exitWith {
            if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
                format["[HELI_FLYBY] Mission %1: Helicopter destroyed during outbound flight - mission complete", 
                    _missionNumber] call OKS_fnc_LogDebug;
            };
            true
        };
        
        // Wait for helicopter to return to spawn or be destroyed
        private _returnedToSpawn = false;
        _startTime = time;
        
        while {alive _helicopter && !isNull _helicopter && !_returnedToSpawn && (time - _startTime) < _maxFlightTime} do {
            sleep 5;
            
            // Monitor dismounted crew during return flight
            [_allUnits] call _monitorDismountedCrew;
            
            // Check if helicopter returned to spawn (within 300m)
            if ((_helicopter distance _spawnPosAlt) < 300) then {
                _returnedToSpawn = true;
                
                if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
                    format["[HELI_FLYBY] Mission %1: %2 returned to spawn - flyby complete", 
                        _missionNumber, typeOf _helicopter] call OKS_fnc_LogDebug;
                };
            };
        };
        
        // Clean up helicopter
        if (!isNull _helicopter) then {
            {deleteVehicle _x} forEach crew _helicopter;
            deleteVehicle _helicopter;
            
            if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
                format["[HELI_FLYBY] Mission %1: Helicopter cleaned up", _missionNumber] call OKS_fnc_LogDebug;
            };
        };
        
        true // Mission completed
    };
    
    // Main flyby loop
    private _currentMission = 1;
    private _systemStartTime = time;
    
    if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
        format["[HELI_FLYBY] Helicopter flyby system starting - Max missions: %1, Loop enabled: %2", 
            if (_MaxFlyByMissions == -1) then {"INFINITE"} else {str _MaxFlyByMissions}, _ShouldLoop] call OKS_fnc_LogDebug;
    };
    
    while {_SpawnPoint getVariable ["OKS_HeliFlyBy_On", true] && (_MaxFlyByMissions == -1 || _currentMission <= _MaxFlyByMissions)} do {
        
        // Wait if paused
        waitUntil {!(_SpawnPoint getVariable ["OKS_HeliFlyBy_Pause", false])};
        
        // Check if still active
        if (!(_SpawnPoint getVariable ["OKS_HeliFlyBy_On", true])) exitWith {
            if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
                "[HELI_FLYBY] Flyby stopped externally - exiting main loop" call OKS_fnc_LogDebug;
            };
        };
        
        // Update mission number
        _SpawnPoint setVariable ["OKS_HeliFlyBy_Mission", _currentMission, true];
        
        if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
            format["[HELI_FLYBY] === FLYBY MISSION %1 START === (System time: %2 min)", 
                _currentMission, round((time - _systemStartTime) / 60)] call OKS_fnc_LogDebug;
        };
        
        // Spawn helicopter
        private _helicopter = [_SpawnPoint, _HelicopterClasses, _Side, _flybyId, _FlightAltitude, _FlightBehaviour] call _spawnHelicopter;
        
        if (!isNull _helicopter) then {
            // Execute flight mission
            private _missionSuccess = [_helicopter, _EndPoint, _SpawnPoint, _FlightAltitude, _currentMission, _EnableResupplyDrop, _FlightBehaviour] spawn _executeFlightMission;
            
            if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
                format["[HELI_FLYBY] Mission %1 completed with status: %2", _currentMission, _missionSuccess] call OKS_fnc_LogDebug;
            };
        } else {
            if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
                format["[HELI_FLYBY] Mission %1 failed to spawn helicopter", _currentMission] call OKS_fnc_LogDebug;
            };
        };
        
        // Check if should continue looping
        if (!_ShouldLoop) exitWith {
            if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
                "[HELI_FLYBY] Single mission mode - flyby complete" call OKS_fnc_LogDebug;
            };
        };
        
        // Generate random delay between min and max
        private _actualDelay = _minDelay + random(_maxDelay - _minDelay);
        
        if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
            format["[HELI_FLYBY] Waiting %1 seconds before mission %2 (range: %3-%4s)", 
                round _actualDelay, _currentMission + 1, _minDelay, _maxDelay] call OKS_fnc_LogDebug;
        };
        
        sleep _actualDelay;
        _currentMission = _currentMission + 1;
    };
    
    // Final cleanup
    _SpawnPoint setVariable ["OKS_HeliFlyBy_On", false, true];
    
    private _totalDuration = time - _systemStartTime;
    if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
        format["[HELI_FLYBY] === HELICOPTER FLYBY SYSTEM COMPLETE === Missions: %1, Duration: %2 minutes", 
            _currentMission - 1, round(_totalDuration / 60)] call OKS_fnc_LogDebug;
    };
    
    // Cleanup delay
    sleep _CleanupDelay;
};

// Spawn the helicopter flyby system
if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
    format["[HELI_FLYBY] Spawning helicopter flyby system thread - Flyby ID: %1", _flybyId] call OKS_fnc_LogDebug;
};

[_SpawnPoint, _EndPoint, _Side, _HelicopterClasses, _minDelay, _maxDelay, _FlightAltitude, _FlightBehaviour, _ShouldLoop, _MaxFlyByMissions, _CleanupDelay, _flybyId, _EnableResupplyDrop] spawn _helicopterFlyBySystem;

// Return spawn point object for external control
if (missionNamespace getVariable ["GOL_AI_HelicopterFlyBy_Debug", false]) then {
    format["[HELI_FLYBY] Function complete - helicopter flyby control object: %1", _SpawnPoint] call OKS_fnc_LogDebug;
};

_SpawnPoint