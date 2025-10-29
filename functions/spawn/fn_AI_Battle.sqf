/*
    Function: AI Battle - Continuous Background Combat System
    
    Creates persistent AI vs AI vehicle battles with looping rounds, player interference prevention,
    and intelligent resource management. Battles continue until manually stopped.

    Example:
    _battleRef = [
        west_1,                     // Faction 1 spawn object
        east_1,                     // Faction 2 spawn object  
        meet_1,                     // Meeting point object (returned for control)
        west,                       // Faction 1 side
        east,                       // Faction 2 side
        ["B_APC_Tracked_01_rcws_F"], // Faction 1 vehicle classes
        ["O_APC_Wheeled_02_rcws_v2_F"], // Faction 2 vehicle classes
        sideUnknown,                // Defending side (optional)
        true,                       // Enable looping battles
        90,                         // Delay between rounds (seconds)
        -1,                         // Max rounds (-1 = infinite)
        30,                         // Victory delay before cleanup
        12,                         // Maximum total units per round
        3000                        // Player observation range (meters)
    ] call OKS_fnc_AI_Battle;
    
    // Control the battle:
    _battleRef setVariable ["OKS_AIBattle_On", false]; // Stop after current round
    _battleRef getVariable ["OKS_AIBattle_Round", 0];  // Get current round number
*/

if (!isServer) exitWith {};

params [
    ["_Faction1Spawn", objNull, [objNull]],
    ["_Faction2Spawn", objNull, [objNull]],
    ["_MeetingPos", objNull, [objNull]],
    ["_Side1", west, [sideUnknown]],
    ["_Side2", east, [sideUnknown]],
    ["_Faction1Classes", ["UK3CB_CW_US_B_EARLY_M1A1"], [[]]],
    ["_Faction2Classes", ["UK3CB_CHD_O_T72A"], [[]]],
    ["_DefendingSide", sideUnknown, [sideUnknown]],
    ["_ShouldLoop", true, [false]],                     // Enable continuous battles
    ["_RoundDelay", 90, [0]],                          // Delay between rounds (seconds)
    ["_MaxRounds", -1, [0]],                           // Maximum rounds (-1 = infinite)
    ["_RoundVictoryDelay", 30, [0]],                   // Delay after victory before cleanup
    ["_MaxUnitsPerRound", 12, [0]],                    // Maximum total units per round
    ["_PlayerObservationRange", 3000, [0]]             // Range for simulation activation
];

// Debug initialization
if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
    format["[AI_BATTLE] Initializing battle system - Loop: %1, MaxRounds: %2, MaxUnits: %3, ObsRange: %4m", 
        _ShouldLoop, _MaxRounds, _MaxUnitsPerRound, _PlayerObservationRange] call OKS_fnc_LogDebug;
    format["[AI_BATTLE] Faction1: %1 (%2 classes), Faction2: %3 (%4 classes)", 
        _Side1, count _Faction1Classes, _Side2, count _Faction2Classes] call OKS_fnc_LogDebug;
};

// Validation checks
private _validatePosition = {
    params ["_pos"];
    (!surfaceIsWater _pos) && 
    (_pos distance [0,0,0] > 100) && 
    (count (allPlayers select {(_x distance _pos) < 500}) == 0) // No players within 500m of spawn
};

// Check for water-based battle scenario
private _isWaterBattle = surfaceIsWater (getPos _MeetingPos);

if (!([getPos _Faction1Spawn] call _validatePosition)) exitWith {
    format["[AI_BATTLE] Invalid Faction1 spawn position %1 - battle cancelled", getPos _Faction1Spawn] call OKS_fnc_LogDebug;
    objNull
};

if (!([getPos _Faction2Spawn] call _validatePosition)) exitWith {
    format["[AI_BATTLE] Invalid Faction2 spawn position %1 - battle cancelled", getPos _Faction2Spawn] call OKS_fnc_LogDebug;
    objNull
};

// Modified validation for meeting position - allow water if it's a water battle
if (!_isWaterBattle && !([getPos _MeetingPos] call _validatePosition)) exitWith {
    format["[AI_BATTLE] Invalid meeting position %1 - battle cancelled", getPos _MeetingPos] call OKS_fnc_LogDebug;
    objNull
};

// Additional validation for water battles
if (_isWaterBattle) then {
    if ((getPos _MeetingPos) distance [0,0,0] < 100) exitWith {
        format["[AI_BATTLE] Invalid water battle meeting position %1 - too close to origin", getPos _MeetingPos] call OKS_fnc_LogDebug;
        objNull
    };
    if ((count (allPlayers select {(_x distance (getPos _MeetingPos)) < 500}) > 0)) exitWith {
        format["[AI_BATTLE] Invalid water battle meeting position %1 - players too close", getPos _MeetingPos] call OKS_fnc_LogDebug;
        objNull
    };
    
    if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
        format["[AI_BATTLE] Water battle detected - meeting point %1 is on water, enabling static firefight mode", getPos _MeetingPos] call OKS_fnc_LogDebug;
    };
};

// Initialize battle control variables on meeting object
_Faction1Spawn setVariable ["OKS_AIBattle_On", true, true];
_Faction1Spawn setVariable ["OKS_AIBattle_Round", 0, true];
_Faction1Spawn setVariable ["OKS_AIBattle_Pause", false, true];

if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
    "[AI_BATTLE] Battle control variables initialized on meeting object" call OKS_fnc_LogDebug;
};

// Calculate faction positions for proper battle line formation (center, left, right)
// Use direction from spawn to meeting point to ensure proper orientation regardless of object placement
// For static fights, use closer spacing to avoid terrain blocking
private _formationDistance = if (_isWaterBattle) then {25} else {50}; // Closer for static water battles

private _Faction1Dir = (getPos _Faction1Spawn) getDir (getPos _MeetingPos);
private _Faction1Positions = [
    getPos _Faction1Spawn,                                                      // Center position
    _Faction1Spawn getPos [_formationDistance, _Faction1Dir + 90],             // Left flank (90° left of battle direction)
    _Faction1Spawn getPos [_formationDistance, _Faction1Dir - 90]              // Right flank (90° right of battle direction)
];

private _Faction2Dir = (getPos _Faction2Spawn) getDir (getPos _MeetingPos);
private _Faction2Positions = [
    getPos _Faction2Spawn,                                                      // Center position
    _Faction2Spawn getPos [_formationDistance, _Faction2Dir + 90],             // Left flank (90° left of battle direction)
    _Faction2Spawn getPos [_formationDistance, _Faction2Dir - 90]              // Right flank (90° right of battle direction)
];

private _MeetingPosOriginal = getPos _MeetingPos;
private _DataObject = _Faction1Spawn;
private _DefendingSideOriginal = _DefendingSide;

if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
    format["[AI_BATTLE] Calculated spawn positions - F1: %1, F2: %2, Meeting: %3", 
        _Faction1Positions select 0, _Faction2Positions select 0, _MeetingPosOriginal] call OKS_fnc_LogDebug;
};

// Main battle system - spawned internally to handle suspension
private _battleSystem = {
    params ["_MeetingPos", "_DataObject", "_Faction1Positions", "_Faction2Positions", "_MeetingPosOriginal", "_DefendingSideOriginal", "_Side1", "_Side2", "_Faction1Classes", "_Faction2Classes", "_ShouldLoop", "_RoundDelay", "_MaxRounds", "_RoundVictoryDelay", "_MaxUnitsPerRound", "_PlayerObservationRange", "_isWaterBattle"];
    
    // Player observation check (inverted logic - only simulate when players nearby)
    private _shouldSimulate = {
        private _playersNearby = false;
        {
            if (alive _x && (_x distance _MeetingPosOriginal) < _PlayerObservationRange) then {
                _playersNearby = true;
            };
        } forEach allPlayers;
        _playersNearby
    };

    // Enhanced spawn function with unit limits
    private _spawnWave = {
        params ["_positions", "_meetingPos", "_factionClasses", "_side", "_allUnitsArray", "_allVehiclesArray", "_defendingSide", "_maxUnits", ["_enemyPositions", []], ["_enemySide", sideUnknown], ["_isWaterBattle", false]];
        
        private _spawnedThisWave = 0;
        
        if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
            format["[AI_BATTLE] Starting spawn wave for %1 - %2 positions, %3 vehicle classes available", 
                _side, count _positions, count _factionClasses] call OKS_fnc_LogDebug;
        };
        
        {
            // Check if battle is still active
            if (!(_MeetingPos getVariable ["OKS_AIBattle_On", true])) exitWith {
                if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                    "[AI_BATTLE] Battle stopped during spawn wave - exiting" call OKS_fnc_LogDebug;
                };
            };
            
            // Check unit limits
            if ((count _allUnitsArray) >= _maxUnits) exitWith {
                format["[AI_BATTLE] Unit limit reached (%1/%2) - stopping spawn for %3", 
                    count _allUnitsArray, _maxUnits, _side] call OKS_fnc_LogDebug;
            };
            
            private _selectedClass = selectRandom _factionClasses;
            private _vehicle = createVehicle [_selectedClass, _x, [], -1, "NONE"];
            
            if (isNull _vehicle) then {
                format["[AI_BATTLE] Failed to create vehicle %1 at position %2", _selectedClass, _x] call OKS_fnc_LogDebug;
            } else {
                _allVehiclesArray pushBack _vehicle;
                
                private _crew = [_vehicle, _side] call OKS_fnc_AddVehicleCrew;
                {_allUnitsArray pushBack _x} forEach units _crew;
                
                // Enhanced crew setup for battle persistence
                {
                    _unit = _x;
                    if (!isNull _unit) then {
                        // Prevent fleeing behavior (can be applied immediately)
                        _unit allowFleeing 0;
                        
                        // Store original vehicle reference for distance monitoring
                        _unit setVariable ["OKS_AIBattle_OriginalVehicle", _vehicle, true];
                        
                        // Enhanced combat behavior settings (can be applied immediately)
                        _unit setBehaviour "COMBAT";
                        _unit setCombatMode "RED"; // Engage all targets
                        _unit setSkill ["courage", 1.0]; // Maximum courage to prevent retreat
                        
                        // Delay equipment application until after gear system finishes
                        [_unit] spawn {
                            params ["_unit"];
                            
                            // Wait for gear system to finish (max 30 seconds timeout)
                            private _timeout = time + 30;
                            waitUntil {
                                sleep 0.5;
                                (_unit getVariable ["GW_Gear_appliedGear", false]) || (time > _timeout) || !alive _unit
                            };
                            
                            if (alive _unit && !isNull _unit) then {
                                // Add RPG equipment for dismounted combat
                                _unit addMagazines ["RPG7_F", 3];  // Give 3 RPG rounds
                                _unit addWeapon "launch_RPG7_F";
                                
                                // Add additional combat equipment
                                private _primaryMag = primaryWeaponMagazine _unit;
                                if (count _primaryMag > 0) then {
                                    _unit addMagazines [_primaryMag select 0, 4]; // Extra primary ammo
                                };
                                _unit addMagazines ["HandGrenade", 2]; // Combat grenades
                                
                                if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                                    format["[AI_BATTLE] Delayed equipment applied to %1 - RPG and extra gear added", name _unit] call OKS_fnc_LogDebug;
                                };
                            };
                        };
                        
                        if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                            format["[AI_BATTLE] Enhanced crew setup for %1 - no fleeing, equipment will be applied after gear system", name _unit] call OKS_fnc_LogDebug;
                        };
                    };
                } forEach units _crew;
                
                // Set unlimited ammo for vehicle with enhanced monitoring
                _vehicle setVehicleAmmo 1;
                _vehicle setVariable ["OKS_AIBattle_UnlimitedAmmo", true, true];
                
                [_vehicle] spawn {
                    params ["_veh"];
                    while {alive _veh && !isNull _veh && (_veh getVariable ["OKS_AIBattle_UnlimitedAmmo", false])} do {
                        sleep 30; // Check every 30 seconds for more responsive rearming
                        if (alive _veh && !isNull _veh) then {
                            private _currentAmmo = _veh ammo (currentWeapon _veh);
                            if (_currentAmmo < 0.3) then { // Rearm when below 30%
                                _veh setVehicleAmmo 1;
                                
                                if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                                    format["[AI_BATTLE] Rearmed %1 (was at %2% ammo)", typeOf _veh, round(_currentAmmo * 100)] call OKS_fnc_LogDebug;
                                };
                            };
                        };
                    };
                };
                
                if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                    format["[AI_BATTLE] Spawned %1 for %2 with %3 crew members at %4 - unlimited ammo enabled", 
                        _selectedClass, _side, count units _crew, _x] call OKS_fnc_LogDebug;
                };
                
                // Set up waypoints based on battle type and role
                if (_defendingSide == sideUnknown) then {
                    _defendingSide = _side;
                };
                
                if (_isWaterBattle) then {
                    // Water battle: Both sides defensive, static firefight
                    // Calculate enemy center position for proper orientation
                    private _enemyCenter = [0,0,0];
                    if (count _enemyPositions > 0) then {
                        {
                            _enemyCenter = _enemyCenter vectorAdd _x;
                        } forEach _enemyPositions;
                        _enemyCenter = _enemyCenter vectorMultiply (1 / (count _enemyPositions));
                    } else {
                        _enemyCenter = _meetingPos; // Fallback to meeting point
                    };
                    
                    private _holdWP = _crew addWaypoint [_vehicle getPos [5, (_vehicle getDir _enemyCenter)], -1];
                    _holdWP setWaypointType "HOLD";
                    _vehicle setFuel 0; // Both sides are stationary for water battles
                    
                    if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                        format["[AI_BATTLE] WATER BATTLE: Set %1 (%2) as STATIC DEFENDER with HOLD waypoint, facing %3 at %4", 
                            typeOf _vehicle, _side, _enemySide, _enemyCenter] call OKS_fnc_LogDebug;
                    };
                } else {
                    // Land battle: Normal attacker/defender roles
                    if (_side == _defendingSide) then {
                        private _holdWP = _crew addWaypoint [_vehicle getPos [5, (_vehicle getDir _meetingPos)], -1];
                        _holdWP setWaypointType "HOLD";
                        _vehicle setFuel 0; // Defenders are stationary
                        
                        if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                            format["[AI_BATTLE] Set %1 as DEFENDER with HOLD waypoint", typeOf _vehicle] call OKS_fnc_LogDebug;
                        };
                    } else {
                        // Attacking force: First waypoint to meeting point
                        private _meetingWP = _crew addWaypoint [_meetingPos, 0];
                        _meetingWP setWaypointType "MOVE";
                        _meetingWP setWaypointCompletionRadius 150;
                        _meetingWP setWaypointSpeed "FULL";
                        
                        // Second waypoint: Attack the defenders' positions (if available)
                        if (count _enemyPositions > 0) then {
                            // Calculate center of enemy positions for attack waypoint
                            private _enemyCenter = [0,0,0];
                            {
                                _enemyCenter = _enemyCenter vectorAdd _x;
                            } forEach _enemyPositions;
                            _enemyCenter = _enemyCenter vectorMultiply (1 / (count _enemyPositions));
                            
                            private _attackWP = _crew addWaypoint [_enemyCenter, 1];
                            _attackWP setWaypointType "SAD";
                            _attackWP setWaypointCompletionRadius 200;
                            _attackWP setWaypointSpeed "FULL";
                            
                            if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                                format["[AI_BATTLE] Set %1 as ATTACKER - WP1: Meeting point %2, WP2: Assault %3 at %4", 
                                    typeOf _vehicle, _meetingPos, _enemySide, _enemyCenter] call OKS_fnc_LogDebug;
                            };
                        } else {
                            // Fallback: Just use meeting point as SAD waypoint
                            private _sadWP = _crew addWaypoint [_meetingPos, 1];
                            _sadWP setWaypointType "SAD";
                            _sadWP setWaypointCompletionRadius 200;
                            
                            if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                                format["[AI_BATTLE] Set %1 as ATTACKER - WP1: Meeting point %2, WP2: SAD at meeting point (no enemy positions)", 
                                    typeOf _vehicle, _meetingPos] call OKS_fnc_LogDebug;
                            };
                        };
                    };
                };
                
                // Set vehicle direction based on battle type
                if (_isWaterBattle && count _enemyPositions > 0) then {
                    // Water battle: Face enemy spawn positions
                    private _enemyCenter = [0,0,0];
                    {
                        _enemyCenter = _enemyCenter vectorAdd _x;
                    } forEach _enemyPositions;
                    _enemyCenter = _enemyCenter vectorMultiply (1 / (count _enemyPositions));
                    _vehicle setDir (_vehicle getDir _enemyCenter);
                    
                    if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                        format["[AI_BATTLE] WATER BATTLE: Oriented %1 to face enemy at %2 (bearing %3°)", 
                            typeOf _vehicle, _enemyCenter, round(_vehicle getDir _enemyCenter)] call OKS_fnc_LogDebug;
                    };
                } else {
                    // Land battle: Face meeting point (original behavior)
                    _vehicle setDir (_vehicle getDir _meetingPos);
                };
                
                // Vehicle combat enhancements
                _vehicle setVariable ["OKS_AIBattle_Vehicle", true, true];
                _vehicle allowCrewInImmobile true; // Allow crew to stay in immobilized vehicles
                
                // Set crew combat behaviors
                {
                    if (!isNull _x) then {
                        _x setBehaviour "COMBAT";
                        _x setCombatMode "RED";
                        _x setSkill ["commanding", 0.8];
                        _x setSkill ["general", 0.7];
                    };
                } forEach crew _vehicle;
                
                _spawnedThisWave = _spawnedThisWave + (count units _crew);
            };
            
            sleep 30; // Original spawn delay
        } forEach _positions;
        
        if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
            format["[AI_BATTLE] Spawn wave complete for %1 - spawned %2 units total", _side, _spawnedThisWave] call OKS_fnc_LogDebug;
        };
        
        _spawnedThisWave
    };

    // Round cleanup function
    private _cleanupRound = {
        params ["_allUnits", "_allVehicles"];
        
        private _unitsToDelete = _allUnits select {!isNull _x};
        private _vehiclesToDelete = _allVehicles select {!isNull _x};
        
        if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
            format["[AI_BATTLE] Starting cleanup - %1 units, %2 vehicles to delete", 
                count _unitsToDelete, count _vehiclesToDelete] call OKS_fnc_LogDebug;
        };
        
        {
            if (!isNull _x) then {
                deleteVehicle _x;
            };
        } forEach _allUnits;
        
        {
            if (!isNull _x) then {
                // Stop unlimited ammo monitoring
                _x setVariable ["OKS_AIBattle_UnlimitedAmmo", false, true];
                
                {deleteVehicle _x} forEach crew _x;
                deleteVehicle _x;
            };
        } forEach _allVehicles;
        
        if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
            "[AI_BATTLE] Round cleanup completed successfully" call OKS_fnc_LogDebug;
        };
    };

    // Simulation monitoring runs alongside the battle loop (no separate thread needed)
    private _simulationMonitor = {
        private _currentUnits = _DataObject getVariable ["OKS_AIBattle_CurrentUnits", []];
        private _currentVehicles = _DataObject getVariable ["OKS_AIBattle_CurrentVehicles", []];

        // Simulation management system
        private _updateSimulation = {
            params ["_allUnits", "_allVehicles"];
            private _simulate = call _shouldSimulate;
            private _lastSimState = _DataObject getVariable ["OKS_AIBattle_LastSimState", true];
            
            // Only log when simulation state changes
            if (_simulate != _lastSimState && (missionNamespace getVariable ["GOL_AI_Battle_Debug", false])) then {
                format["[AI_BATTLE] Simulation state changed: %1 -> %2 (%3 units, %4 vehicles)", 
                    _lastSimState, _simulate, count _allUnits, count _allVehicles] call OKS_fnc_LogDebug;
                _DataObject setVariable ["OKS_AIBattle_LastSimState", _simulate];
            };
            
            {
                if (!isNull _x) then {
                    _x enableSimulationGlobal _simulate;
                };
            } forEach _allUnits;
            
            {
                if (!isNull _x) then {
                    _x enableSimulationGlobal _simulate;
                };
            } forEach _allVehicles;
            
            _simulate
        };
             
        private _isSimulating = [_currentUnits, _currentVehicles] call _updateSimulation;
        
        _Debug = (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]);
        if (!_isSimulating && _Debug) then {
            "[AI BATTLE] Combat suspended - no players within observation range" call OKS_fnc_LogDebug;
        };
    };
    
    // Main battle loop
    private _currentRound = 1;
    private _battleStartTime = time;
    
    if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
        format["[AI_BATTLE] Battle system starting - Max rounds: %1, Loop enabled: %2", 
            if (_MaxRounds == -1) then {"INFINITE"} else {str _MaxRounds}, _ShouldLoop] call OKS_fnc_LogDebug;
    };
    
    while {_DataObject getVariable ["OKS_AIBattle_On", true] && (_MaxRounds == -1 || _currentRound <= _MaxRounds)} do {
        
        // Wait if paused
        if (_DataObject getVariable ["OKS_AIBattle_Pause", false]) then {
            if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                "[AI_BATTLE] Battle paused - waiting for resume" call OKS_fnc_LogDebug;
            };
        };
        waitUntil {!(_DataObject getVariable ["OKS_AIBattle_Pause", false])};
        
        // Check if still active (might have been stopped during pause)
        if (!(_DataObject getVariable ["OKS_AIBattle_On", true])) exitWith {
            if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                "[AI_BATTLE] Battle stopped during pause - exiting main loop" call OKS_fnc_LogDebug;
            };
        };
        
        // Update round number
        _DataObject setVariable ["OKS_AIBattle_Round", _currentRound, true];
        
        if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
            format["[AI_BATTLE] === ROUND %1 START === (Battle time: %2 min)", 
                _currentRound, round((time - _battleStartTime) / 60)] call OKS_fnc_LogDebug;
        };
        
        // Initialize round arrays
        private _AllUnitsArray = [];
        private _AllVehiclesArray = [];
        
        // Store current battle state for simulation monitor
        _DataObject setVariable ["OKS_AIBattle_CurrentUnits", _AllUnitsArray, true];
        _DataObject setVariable ["OKS_AIBattle_CurrentVehicles", _AllVehiclesArray, true];
        
        // Spawn both factions concurrently (with additional position data for attack waypoints)
        private _faction1Spawn = [_Faction1Positions, _MeetingPos, _Faction1Classes, _Side1, _AllUnitsArray, _AllVehiclesArray, _DefendingSideOriginal, _MaxUnitsPerRound, _Faction2Positions, _Side2, _isWaterBattle] spawn _spawnWave;
        private _faction2Spawn = [_Faction2Positions, _MeetingPos, _Faction2Classes, _Side2, _AllUnitsArray, _AllVehiclesArray, _DefendingSideOriginal, _MaxUnitsPerRound, _Faction1Positions, _Side1, _isWaterBattle] spawn _spawnWave;
        
        // Wait for spawning to complete
        if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
            "[AI_BATTLE] Waiting for both faction spawns to complete..." call OKS_fnc_LogDebug;
        };
        waitUntil {scriptDone _faction1Spawn && scriptDone _faction2Spawn};
        
        // Set up player ignore system for all spawned units
        // Player interference prevention
        private _setupPlayerIgnore = {
            params ["_allUnits"];
            private _playerCount = count allPlayers;
            private _processedUnits = 0;
            
            if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                format["[AI_BATTLE] Setting up player ignore for %1 units against %2 players", 
                    count _allUnits, _playerCount] call OKS_fnc_LogDebug;
            };
            
            {
                _unit = _x;
                if (!isNull _unit) then {
                    // Make AI ignore all players completely using ignoreTarget command
                    {
                        _player = _X;
                        _unit ignoreTarget _player;     // AI will ignore this player as a target
                    } forEach allPlayers;
                    
                    // Disable AI chatter for background operation
                    _unit setVariable ["BIS_noCoreConversations", true];
                    _unit disableConversation true;
                    _unit setSpeaker "NoVoice";
                    
                    // Mark as battle unit
                    _unit setVariable ["OKS_AIBattle_Unit", true, true];
                    _processedUnits = _processedUnits + 1;
                };
            } forEach _allUnits;
            
            if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                format["[AI_BATTLE] Player ignore setup complete - %1/%2 units processed", 
                    _processedUnits, count _allUnits] call OKS_fnc_LogDebug;
            };
        };       
        [_AllUnitsArray] call _setupPlayerIgnore;
        
        // Update arrays for simulation monitor
        _DataObject setVariable ["OKS_AIBattle_CurrentUnits", _AllUnitsArray, true];
        _DataObject setVariable ["OKS_AIBattle_CurrentVehicles", _AllVehiclesArray, true];
        
        if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
            format["[AI_BATTLE] Round %1 spawning complete - %2 units, %3 vehicles. Starting combat phase...", 
                _currentRound, count _AllUnitsArray, count _AllVehiclesArray] call OKS_fnc_LogDebug;
        };
        
        // Wait for round completion
        private _victor = sideUnknown;
        waitUntil {
            sleep 15;
            
            // Update simulation state during battle
            call _simulationMonitor;
            
            // Distance monitoring and dismount detection for crew members
            private _eliminatedCount = 0;
            {
                _unit = _x;
                if (alive _unit && !isNull _unit) then {
                    private _originalVehicle = _unit getVariable ["OKS_AIBattle_OriginalVehicle", objNull];
                    if (!isNull _originalVehicle) then {
                        // Check if unit is dismounted (not in any vehicle)
                        if (isNull (vehicle _unit) || vehicle _unit == _unit) then {
                            private _dismountTime = _unit getVariable ["OKS_AIBattle_DismountTime", -1];
                            
                            // First time detected as dismounted - record the time
                            if (_dismountTime == -1) then {
                                _unit setVariable ["OKS_AIBattle_DismountTime", time, true];
                                
                                if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                                    format["[AI_BATTLE] %1 dismounted from %2 - 30 second countdown started", 
                                        name _unit, typeOf _originalVehicle] call OKS_fnc_LogDebug;
                                };
                            } else {
                                // Check if 30 seconds have passed since dismount
                                if ((time - _dismountTime) > 30) then {
                                    _unit setDamage 1;
                                    _eliminatedCount = _eliminatedCount + 1;
                                    
                                    if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                                        format["[AI_BATTLE] Eliminated %1 after %2 seconds dismounted from %3", 
                                            name _unit, round(time - _dismountTime), typeOf _originalVehicle] call OKS_fnc_LogDebug;
                                    };
                                };
                            };
                        } else {
                            // Unit is back in a vehicle - reset dismount timer
                            _unit setVariable ["OKS_AIBattle_DismountTime", -1, true];
                        };
                        
                        // Original distance check (keep for units that flee too far)
                        private _distance = _unit distance _originalVehicle;
                        if (_distance > 30) then {
                            _unit setDamage 1;
                            _eliminatedCount = _eliminatedCount + 1;
                            
                            if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                                format["[AI_BATTLE] Eliminated %1 for straying %2m from vehicle %3", 
                                    name _unit, round _distance, typeOf _originalVehicle] call OKS_fnc_LogDebug;
                            };
                        };
                    };
                };
            } forEach _AllUnitsArray;
            
            if (_eliminatedCount > 0 && (missionNamespace getVariable ["GOL_AI_Battle_Debug", false])) then {
                format["[AI_BATTLE] Distance check eliminated %1 fleeing crew members", _eliminatedCount] call OKS_fnc_LogDebug;
            };
            
            // Check for external stop
            if (!(_DataObject getVariable ["OKS_AIBattle_On", true])) exitWith {true};
            
            // Victory condition check
            private _checkVictory = {
                params ["_allUnits", "_side1", "_side2"];
                
                private _side1Alive = {(alive _x || [_x] call ace_common_fnc_isAwake) && side _x == _side1} count _allUnits;
                private _side2Alive = {(alive _x || [_x] call ace_common_fnc_isAwake) && side _x == _side2} count _allUnits;
                
                // Log periodic battle status (only on some checks to avoid spam)
                private _checkCount = _DataObject getVariable ["OKS_AIBattle_CheckCount", 0];
                _checkCount = _checkCount + 1;
                _DataObject setVariable ["OKS_AIBattle_CheckCount", _checkCount];
                
                if (_checkCount mod 4 == 0 && (missionNamespace getVariable ["GOL_AI_Battle_Debug", false])) then {
                    format["[AI_BATTLE] Battle status - %1: %2 alive, %3: %4 alive", 
                        _side1, _side1Alive, _side2, _side2Alive] call OKS_fnc_LogDebug;
                };
                
                if (_side1Alive == 0) exitWith {
                    if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                        format["[AI_BATTLE] %1 eliminated! %2 wins with %3 survivors", _side1, _side2, _side2Alive] call OKS_fnc_LogDebug;
                    };
                    _side2
                };
                if (_side2Alive == 0) exitWith {
                    if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                        format["[AI_BATTLE] %1 eliminated! %2 wins with %3 survivors", _side2, _side1, _side1Alive] call OKS_fnc_LogDebug;
                    };
                    _side1
                };
                
                sideUnknown // No victory yet
            };

            // Check victory conditions
            _victor = [_AllUnitsArray, _Side1, _Side2] call _checkVictory;
            _victor != sideUnknown
        };
        
        // Handle round completion
        if (_victor != sideUnknown) then {
            if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                format["[AI_BATTLE] === ROUND %1 COMPLETE === %2 VICTORY! Waiting %3s before cleanup", 
                    _currentRound, _victor, _RoundVictoryDelay] call OKS_fnc_LogDebug;
            };
            sleep _RoundVictoryDelay;
        } else {
            if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                "[AI_BATTLE] Battle stopped externally during combat" call OKS_fnc_LogDebug;
            };
        };
        
        // Clean up round
        [_AllUnitsArray, _AllVehiclesArray] call _cleanupRound;
        
        // Clear simulation monitor arrays
        _DataObject setVariable ["OKS_AIBattle_CurrentUnits", [], true];
        _DataObject setVariable ["OKS_AIBattle_CurrentVehicles", [], true];
        
        // Check if should continue looping
        if (!_ShouldLoop) exitWith {
            if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                "[AI_BATTLE] Single round mode - battle complete" call OKS_fnc_LogDebug;
            };
        };
        
        // Break if externally stopped
        if (!(_DataObject getVariable ["OKS_AIBattle_On", true])) exitWith {
            if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                "[AI_BATTLE] Battle stopped externally - exiting loop" call OKS_fnc_LogDebug;
            };
        };
        
        // Delay before next round
        if (_RoundDelay > 0) then {
            if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
                format["[AI_BATTLE] Waiting %1 seconds before round %2", _RoundDelay, _currentRound + 1] call OKS_fnc_LogDebug;
            };
            sleep _RoundDelay;
        };
        
        _currentRound = _currentRound + 1;
    };
    
    // Final cleanup and battle completion
    _DataObject setVariable ["OKS_AIBattle_On", false, true];
    _DataObject setVariable ["OKS_AIBattle_CurrentUnits", [], true];
    _DataObject setVariable ["OKS_AIBattle_CurrentVehicles", [], true];
    
    private _totalDuration = time - _battleStartTime;
    if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
        format["[AI_BATTLE] === BATTLE SYSTEM COMPLETE === Rounds: %1, Duration: %2 minutes", 
            _currentRound - 1, round(_totalDuration / 60)] call OKS_fnc_LogDebug;
    };
};

// Spawn the battle system (all suspension happens here)
if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
    format["[AI_BATTLE] Spawning battle system thread - returning control object %1", _DataObject] call OKS_fnc_LogDebug;
};

[_MeetingPos, _DataObject, _Faction1Positions, _Faction2Positions, _MeetingPosOriginal, _DefendingSideOriginal, _Side1, _Side2, _Faction1Classes, _Faction2Classes, _ShouldLoop, _RoundDelay, _MaxRounds, _RoundVictoryDelay, _MaxUnitsPerRound, _PlayerObservationRange, _isWaterBattle] spawn _battleSystem;

// Return meeting object for external control
if (missionNamespace getVariable ["GOL_AI_Battle_Debug", false]) then {
    format["[AI_BATTLE] Function complete - battle control object: %1", _DataObject] call OKS_fnc_LogDebug;
};

_DataObject