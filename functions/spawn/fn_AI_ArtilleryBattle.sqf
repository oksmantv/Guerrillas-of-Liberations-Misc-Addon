/*
    Function: AI Artillery Battle - Continuous Background Artillery Combat System
    
    Creates persistent AI vs AI artillery battles with progressive accuracy improvement,
    burst fire missions, and intelligent target selection. Battles continue until manually stopped.

    Example:
    _artilleryBattleRef = [
        arty_spawn_1,               // Side 1 artillery spawn object
        arty_spawn_2,               // Side 2 artillery spawn object  
        west,                       // Side 1 faction
        east,                       // Side 2 faction
        ["B_MBT_01_arty_F"],        // Side 1 artillery classes
        ["O_MBT_02_arty_F"],        // Side 2 artillery classes
        45,                         // Base delay between fire missions (seconds)
        4,                          // Rounds per fire mission
        true,                       // Enable looping battles
        -1,                         // Max fire missions (-1 = infinite)
        30                          // Victory delay before cleanup
    ] call OKS_fnc_AI_ArtilleryBattle;
    
    // Control the battle:
    _artilleryBattleRef setVariable ["OKS_ArtilleryBattle_On", false]; // Stop battle
    _artilleryBattleRef getVariable ["OKS_ArtilleryBattle_FireMission", 0]; // Get current fire mission number
*/

if (!isServer) exitWith {};

params [
    ["_Side1Spawn", objNull, [objNull]],
    ["_Side2Spawn", objNull, [objNull]],
    ["_Side1", west, [sideUnknown]],
    ["_Side2", east, [sideUnknown]],
    ["_Side1Classes", ["B_MBT_01_arty_F"], [[]]],
    ["_Side2Classes", ["O_MBT_02_arty_F"], [[]]],
    ["_BaseFireMissionDelay", 45, [0]],              // Base delay between fire missions (seconds)
    ["_RoundsPerFireMission", 4, [0]],               // Number of rounds per fire mission
    ["_ShouldLoop", true, [false]],                  // Enable continuous battles
    ["_MaxFireMissions", -1, [0]],                   // Maximum fire missions (-1 = infinite)
    ["_VictoryDelay", 30, [0]]                       // Delay after victory before cleanup
];

// Debug initialization
if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
    format["[AI_ARTILLERY] Initializing artillery battle system - Loop: %1, MaxFireMissions: %2, BaseDelay: %3s, RoundsPerMission: %4", 
        _ShouldLoop, _MaxFireMissions, _BaseFireMissionDelay, _RoundsPerFireMission] call OKS_fnc_LogDebug;
    format["[AI_ARTILLERY] Side1: %1 (%2 classes), Side2: %3 (%4 classes)", 
        _Side1, count _Side1Classes, _Side2, count _Side2Classes] call OKS_fnc_LogDebug;
};

// Validation checks
private _validateSpawnPosition = {
    params ["_pos"];
    (_pos distance [0,0,0] > 100) && 
    (count (allPlayers select {(_x distance _pos) < 500}) == 0) // No players within 500m of spawn
};

if (!([getPos _Side1Spawn] call _validateSpawnPosition)) exitWith {
    format["[AI_ARTILLERY] Invalid Side1 spawn position %1 - artillery battle cancelled", getPos _Side1Spawn] call OKS_fnc_LogDebug;
    objNull
};

if (!([getPos _Side2Spawn] call _validateSpawnPosition)) exitWith {
    format["[AI_ARTILLERY] Invalid Side2 spawn position %1 - artillery battle cancelled", getPos _Side2Spawn] call OKS_fnc_LogDebug;
    objNull
};

// Generate unique battle ID for this artillery battle
private _battleId = format["ArtilleryBattle_%1", round(time * 1000)];

// Initialize battle control variables on Side1 spawn object (returned as control object)
_Side1Spawn setVariable ["OKS_ArtilleryBattle_On", true, true];
_Side1Spawn setVariable ["OKS_ArtilleryBattle_FireMission", 0, true];
_Side1Spawn setVariable ["OKS_ArtilleryBattle_Pause", false, true];
_Side1Spawn setVariable ["OKS_ArtilleryBattle_BattleId", _battleId, true];

if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
    format["[AI_ARTILLERY] Battle control variables initialized - Battle ID: %1", _battleId] call OKS_fnc_LogDebug;
};

// Main artillery battle system - spawned internally to handle suspension
private _artilleryBattleSystem = {
    params ["_Side1Spawn", "_Side2Spawn", "_Side1", "_Side2", "_Side1Classes", "_Side2Classes", "_BaseFireMissionDelay", "_RoundsPerFireMission", "_ShouldLoop", "_MaxFireMissions", "_VictoryDelay", "_battleId"];
    
    // Spawn artillery function
    private _spawnArtillery = {
        params ["_spawnObj", "_artilleryClasses", "_side", "_battleId"];
        
        private _spawnPos = getPos _spawnObj;
        private _spawnDir = getDir _spawnObj;
        private _selectedClass = selectRandom _artilleryClasses;
        private _artillery = createVehicle [_selectedClass, _spawnPos, [], 0, "NONE"];
        
        if (isNull _artillery) exitWith {
            format["[AI_ARTILLERY] Failed to create artillery %1 at position %2", _selectedClass, _spawnPos] call OKS_fnc_LogDebug;
            objNull
        };
        
        // Set artillery direction to match spawn object
        _artillery setDir _spawnDir;
        
        // Add crew
        private _crew = [_artillery, _side] call OKS_fnc_AddVehicleCrew;
        
        // Set artillery battle variables for target identification
        _artillery setVariable [format["OKS_ArtilleryBattle_%1_Side", _battleId], _side, true];
        _artillery setVariable ["OKS_ArtilleryBattle_Vehicle", true, true];
        _artillery setVariable ["OKS_ArtilleryBattle_BattleId", _battleId, true];
        
        // Setup crew behavior
        {
            if (!isNull _x) then {
                _x allowFleeing 0;
                _x setBehaviour "COMBAT";
                _x setCombatMode "RED";
                _x setSkill ["courage", 1.0];
                
                // Store original artillery reference for dismount monitoring
                _x setVariable ["OKS_ArtilleryBattle_OriginalArtillery", _artillery, true];
                _x setVariable ["OKS_ArtilleryBattle_BattleId", _battleId, true];
                _unit = _x;
                // Player interference prevention
                {
                    private _player = _x;
                    _unit ignoreTarget _player;
                } forEach allPlayers;
                
                // Disable AI chatter
                _x setVariable ["BIS_noCoreConversations", true];
                _x disableConversation true;
                _x setSpeaker "NoVoice";
            };
        } forEach units _crew;
        
        // Set unlimited ammo
        _artillery setVehicleAmmo 1;
        _artillery setVariable ["OKS_ArtilleryBattle_UnlimitedAmmo", true, true];
        
        // Unlimited ammo monitoring
        [_artillery] spawn {
            params ["_arty"];
            while {alive _arty && !isNull _arty && (_arty getVariable ["OKS_ArtilleryBattle_UnlimitedAmmo", false])} do {
                sleep 10;
                if (alive _arty && !isNull _arty) then {
                    private _currentAmmo = _arty ammo (currentWeapon _arty);
                    if (_currentAmmo < 0.5) then {
                        _arty setVehicleAmmo 1;
                        
                        if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
                            format["[AI_ARTILLERY] Rearmed %1 (was at %2% ammo)", typeOf _arty, round(_currentAmmo * 100)] call OKS_fnc_LogDebug;
                        };
                    };
                };
            };
        };
        
        if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
            format["[AI_ARTILLERY] Spawned %1 for %2 with %3 crew members at %4", 
                _selectedClass, _side, count units _crew, _spawnPos] call OKS_fnc_LogDebug;
        };
        
        _artillery
    };
    
    // Target selection function with range validation
    private _selectTargets = {
        params ["_artillery", "_enemySide", "_battleId"];
        
        private _allTargets = [];
        private _validTargets = [];
        
        // Find enemy artillery from any battle (not just this one)
        {
            private _vehicle = _x;
            if (!isNull _vehicle && alive _vehicle) then {
                // Check for any artillery battle vehicle on the enemy side
                private _isArtilleryBattleVehicle = _vehicle getVariable ["OKS_ArtilleryBattle_Vehicle", false];
                if (_isArtilleryBattleVehicle) then {
                    // Check if this vehicle belongs to the enemy side by checking crew side
                    private _vehicleSide = sideUnknown;
                    private _crew = crew _vehicle;
                    if (count _crew > 0) then {
                        _vehicleSide = side (_crew select 0);
                    };
                    
                    // Include enemy artillery from any battle
                    if (_vehicleSide == _enemySide) then {
                        _allTargets pushBack _vehicle;
                    };
                };
            };
        } forEach vehicles;
        
        // Check which targets are within artillery range
        {
            private _target = _x;
            private _distance = _artillery distance _target;
            
            // Check if artillery can engage this target (using knowsAbout and weapon range)
            // Check if target is within artillery range using proper Arma 3 command with magazine type
            private _currentMagazine = currentMagazine _artillery;
            private _canEngage = false;
            
            if (_currentMagazine != "") then {
                _canEngage = (getPos _target) inRangeOfArtillery [[_artillery], _currentMagazine];
            };
            
            if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
                if (_canEngage) then {
                    format["[AI_ARTILLERY] %1 can engage %2 (distance: %3m) with magazine: %4 - inRangeOfArtillery: true", 
                        typeOf _artillery, typeOf _target, round _distance, _currentMagazine] call OKS_fnc_LogDebug;
                } else {
                    format["[AI_ARTILLERY] %1 cannot engage %2 (distance: %3m) with magazine: %4 - inRangeOfArtillery: false", 
                        typeOf _artillery, typeOf _target, round _distance, _currentMagazine] call OKS_fnc_LogDebug;
                };
            };
            
            if (_canEngage) then {
                _validTargets pushBack _target;
            };
        } forEach _allTargets;
        
        if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
            format["[AI_ARTILLERY] %1 found %2 total targets, %3 valid targets within range for battle %4", 
                typeOf _artillery, count _allTargets, count _validTargets, _battleId] call OKS_fnc_LogDebug;
        };
        
        _validTargets
    };
    
    // Artillery replacement function for out-of-range pieces
    private _replaceArtillery = {
        params ["_oldArtillery", "_spawnObj", "_artilleryClasses", "_side", "_battleId"];
        
        private _spawnPos = getPos _oldArtillery;
        private _spawnDir = getDir _oldArtillery;
        private _oldClass = typeOf _oldArtillery;
        
        // Try different artillery class
        private _availableClasses = _artilleryClasses - [_oldClass]; // Remove current class
        if (count _availableClasses == 0) then {
            _availableClasses = _artilleryClasses; // Fallback to all classes if only one available
        };
        
        private _newClass = selectRandom _availableClasses;
        
        if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
            format["[AI_ARTILLERY] Replacing %1 with %2 due to range limitations", _oldClass, _newClass] call OKS_fnc_LogDebug;
        };
        
        // Store crew for transfer
        private _oldCrew = crew _oldArtillery;
        
        // Delete old artillery
        {deleteVehicle _x} forEach _oldCrew;
        deleteVehicle _oldArtillery;
        
        // Create new artillery
        private _newArtillery = createVehicle [_newClass, _spawnPos, [], 0, "NONE"];
        _newArtillery setDir _spawnDir;
        
        // Add crew and setup (reuse existing spawn artillery logic)
        private _crew = [_newArtillery, _side] call OKS_fnc_AddVehicleCrew;
        
        // Set artillery battle variables
        _newArtillery setVariable [format["OKS_ArtilleryBattle_%1_Side", _battleId], _side, true];
        _newArtillery setVariable ["OKS_ArtilleryBattle_Vehicle", true, true];
        _newArtillery setVariable ["OKS_ArtilleryBattle_BattleId", _battleId, true];
        
        // Setup crew behavior (simplified version)
        {
            if (!isNull _x) then {
                _x allowFleeing 0;
                _x setBehaviour "COMBAT";
                _x setCombatMode "RED";
                _x setSkill ["courage", 1.0];
                _x setVariable ["OKS_ArtilleryBattle_OriginalArtillery", _newArtillery, true];
                _x setVariable ["OKS_ArtilleryBattle_BattleId", _battleId, true];
                
                // Player interference prevention
                {
                    private _player = _x;
                    _x ignoreTarget _player;
                } forEach allPlayers;
                
                _x setVariable ["BIS_noCoreConversations", true];
                _x disableConversation true;
                _x setSpeaker "NoVoice";
            };
        } forEach units _crew;
        
        // Set unlimited ammo
        _newArtillery setVehicleAmmo 1;
        _newArtillery setVariable ["OKS_ArtilleryBattle_UnlimitedAmmo", true, true];
        
        if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
            format["[AI_ARTILLERY] Successfully replaced artillery with %1", _newClass] call OKS_fnc_LogDebug;
        };
        
        _newArtillery
    };
    
    // Fire mission function
    private _executeFireMission = {
        params ["_artillery", "_targets", "_rounds", "_accuracy", "_fireMissionNumber"];
        
        if (count _targets == 0) exitWith {
            if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
                format["[AI_ARTILLERY] %1 has no targets for fire mission %2", typeOf _artillery, _fireMissionNumber] call OKS_fnc_LogDebug;
            };
        };
        
        private _target = selectRandom _targets;
        private _targetPos = getPos _target;
        
        if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
            format["[AI_ARTILLERY] Fire Mission %1: %2 engaging %3 with %4 rounds at target %5", 
                _fireMissionNumber, typeOf _artillery, typeOf _target, _rounds, _targetPos] call OKS_fnc_LogDebug;
        };
        
        // Fire complete volley in one command (let artillery handle natural firing sequence and dispersion)
        _artillery doArtilleryFire [_targetPos, currentMagazine _artillery, _rounds];
        
        if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
            format["[AI_ARTILLERY] Fire Mission %1: %2 firing %3 round volley at %4", 
                _fireMissionNumber, typeOf _artillery, _rounds, _targetPos] call OKS_fnc_LogDebug;
        };
        
        // Wait for the complete fire mission to finish (longer wait for rocket artillery)
        private _missionDuration = if (typeOf _artillery find "rocket" > -1 || typeOf _artillery find "Rocket" > -1) then {
            _rounds * 8 + 10 // Rocket artillery: 8 seconds per round + 10 second buffer
        } else {
            _rounds * 5 + 5  // Tube artillery: 5 seconds per round + 5 second buffer
        };
        
        sleep _missionDuration;
        
        if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
            format["[AI_ARTILLERY] Fire mission %1 complete for %2 - %3 round volley finished", 
                _fireMissionNumber, typeOf _artillery, _rounds] call OKS_fnc_LogDebug;
        };
    };
    

    
    // Victory check function
    private _checkVictory = {
        params ["_battleId", "_side1", "_side2"];
        
        private _side1Artillery = [];
        private _side2Artillery = [];
        
        {
            if (!isNull _x && alive _x) then {
                private _vehicleSide = _x getVariable [format["OKS_ArtilleryBattle_%1_Side", _battleId], sideUnknown];
                private _vehicleBattleId = _x getVariable ["OKS_ArtilleryBattle_BattleId", ""];
                
                if (_vehicleBattleId == _battleId) then {
                    if (_vehicleSide == _side1) then {
                        _side1Artillery pushBack _x;
                    } else {
                        if (_vehicleSide == _side2) then {
                            _side2Artillery pushBack _x;
                        };
                    };
                };
            };
        } forEach vehicles;
        
        if (count _side1Artillery == 0) exitWith {
            if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
                format["[AI_ARTILLERY] %1 artillery eliminated! %2 wins!", _side1, _side2] call OKS_fnc_LogDebug;
            };
            _side2
        };
        
        if (count _side2Artillery == 0) exitWith {
            if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
                format["[AI_ARTILLERY] %1 artillery eliminated! %2 wins!", _side2, _side1] call OKS_fnc_LogDebug;
            };
            _side1
        };
        
        sideUnknown // No victory yet
    };
    
    // Main battle loop
    private _currentFireMission = 1;
    private _battleStartTime = time;
    private _currentAccuracy = 500; // Start with 500m dispersion
    
    if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
        format["[AI_ARTILLERY] Artillery battle system starting - Max fire missions: %1, Loop enabled: %2", 
            if (_MaxFireMissions == -1) then {"INFINITE"} else {str _MaxFireMissions}, _ShouldLoop] call OKS_fnc_LogDebug;
    };
    
    // Spawn both artillery pieces
    private _side1Artillery = [_Side1Spawn, _Side1Classes, _Side1, _battleId] call _spawnArtillery;
    private _side2Artillery = [_Side2Spawn, _Side2Classes, _Side2, _battleId] call _spawnArtillery;
    
    if (isNull _side1Artillery || isNull _side2Artillery) exitWith {
        format["[AI_ARTILLERY] Failed to spawn artillery - battle cancelled"] call OKS_fnc_LogDebug;
    };
    
    // Wait for both artillery pieces to be fully spawned and ready
    waitUntil {
        sleep 2;
        (!isNull _side1Artillery && alive _side1Artillery && count (crew _side1Artillery) > 0) &&
        (!isNull _side2Artillery && alive _side2Artillery && count (crew _side2Artillery) > 0)
    };
    
    if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
        "[AI_ARTILLERY] Both artillery pieces spawned and crewed - checking target availability" call OKS_fnc_LogDebug;
    };
    
    // Check if artillery can engage each other, replace if necessary
    private _side1Targets = [_side1Artillery, _Side2, _battleId] call _selectTargets;
    private _side2Targets = [_side2Artillery, _Side1, _battleId] call _selectTargets;
    
    // Replace side1 artillery if it can't engage any targets
    if (count _side1Targets == 0) then {
        if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
            format["[AI_ARTILLERY] Side1 artillery %1 cannot engage any targets - attempting replacement", typeOf _side1Artillery] call OKS_fnc_LogDebug;
        };
        
        private _newArtillery = [_side1Artillery, _Side1Spawn, _Side1Classes, _Side1, _battleId] call _replaceArtillery;
        if (!isNull _newArtillery) then {
            _side1Artillery = _newArtillery;
        };
    };
    
    // Replace side2 artillery if it can't engage any targets
    if (count _side2Targets == 0) then {
        if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
            format["[AI_ARTILLERY] Side2 artillery %1 cannot engage any targets - attempting replacement", typeOf _side2Artillery] call OKS_fnc_LogDebug;
        };
        
        private _newArtillery = [_side2Artillery, _Side2Spawn, _Side2Classes, _Side2, _battleId] call _replaceArtillery;
        if (!isNull _newArtillery) then {
            _side2Artillery = _newArtillery;
        };
    };
    
    // Final validation - wait up to 5 minutes for targets to become available
    private _validationStartTime = time;
    private _maxValidationTime = 300; // 5 minutes maximum
    private _validationPassed = false;
    private _lastLogTime = 0;
    
    if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
        "[AI_ARTILLERY] Waiting up to 5 minutes for artillery pieces to find valid targets..." call OKS_fnc_LogDebug;
    };
    
    while {!_validationPassed && (time - _validationStartTime) < _maxValidationTime} do {
        sleep 10; // Check every 10 seconds to reduce spam
        private _s1Targets = [_side1Artillery, _Side2, _battleId] call _selectTargets;
        private _s2Targets = [_side2Artillery, _Side1, _battleId] call _selectTargets;
        
        if (count _s1Targets > 0 && count _s2Targets > 0) then {
            _validationPassed = true;
            if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
                format["[AI_ARTILLERY] Target validation successful after %1 seconds - both sides can engage", 
                    round(time - _validationStartTime)] call OKS_fnc_LogDebug;
            };
        } else {
            // Log progress every 60 seconds
            if ((time - _lastLogTime) > 60) then {
                _lastLogTime = time;
                if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
                    format["[AI_ARTILLERY] Still waiting for targets... %1 seconds elapsed (S1 targets: %2, S2 targets: %3)", 
                        round(time - _validationStartTime), count _s1Targets, count _s2Targets] call OKS_fnc_LogDebug;
                };
            };
        };
    };
    
    // If validation failed after 5 minutes, exit with error
    if (!_validationPassed) then {
        private _distance = _side1Artillery distance _side2Artillery;
        format["[AI_ARTILLERY] ERROR: Artillery battle cancelled - no valid targets found after 5 minutes"] call OKS_fnc_LogDebug;
        format["[AI_ARTILLERY] ERROR: Distance between artillery pieces: %1m", round _distance] call OKS_fnc_LogDebug;
        format["[AI_ARTILLERY] ERROR: Side1 (%1) at %2, Side2 (%3) at %4", 
            typeOf _side1Artillery, getPos _side1Artillery, typeOf _side2Artillery, getPos _side2Artillery] call OKS_fnc_LogDebug;
        
        // Clean up artillery and crew before exiting
        {
            if (!isNull _x) then {
                _x setVariable ["OKS_ArtilleryBattle_UnlimitedAmmo", false, true];
                {deleteVehicle _x} forEach crew _x;
                deleteVehicle _x;
            };
        } forEach [_side1Artillery, _side2Artillery];
        
        // Mark battle as complete
        _Side1Spawn setVariable ["OKS_ArtilleryBattle_On", false, true];
        
        format["[AI_ARTILLERY] Artillery battle system terminated due to range/target issues"] call OKS_fnc_LogDebug;
        exit
    };
    
    if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
        "[AI_ARTILLERY] Artillery validation complete - battle ready to commence" call OKS_fnc_LogDebug;
    };
    
    private _allUnits = (units (group _side1Artillery)) + (units (group _side2Artillery));
    
    while {_Side1Spawn getVariable ["OKS_ArtilleryBattle_On", true] && (_MaxFireMissions == -1 || _currentFireMission <= _MaxFireMissions)} do {
        
        // Wait if paused
        waitUntil {!(_Side1Spawn getVariable ["OKS_ArtilleryBattle_Pause", false])};
        
        // Check if still active
        if (!(_Side1Spawn getVariable ["OKS_ArtilleryBattle_On", true])) exitWith {
            if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
                "[AI_ARTILLERY] Battle stopped externally - exiting main loop" call OKS_fnc_LogDebug;
            };
        };
        
        // Update fire mission number
        _Side1Spawn setVariable ["OKS_ArtilleryBattle_FireMission", _currentFireMission, true];
        
        if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
            format["[AI_ARTILLERY] === FIRE MISSION %1 START === (Battle time: %2 min, Accuracy: %3m)", 
                _currentFireMission, round((time - _battleStartTime) / 60), _currentAccuracy] call OKS_fnc_LogDebug;
        };
        
        // Monitor dismounted crew
        // Dismount monitoring function
        private _monitorDismountedCrew = {
            params ["_allUnits"];
            
            private _eliminatedCount = 0;
            
            {
                private _unit = _x;
                if (alive _unit && !isNull _unit) then {
                    private _originalArtillery = _unit getVariable ["OKS_ArtilleryBattle_OriginalArtillery", objNull];
                    if (!isNull _originalArtillery) then {
                        // Check if unit is dismounted
                        if (isNull (vehicle _unit) || vehicle _unit == _unit) then {
                            private _dismountTime = _unit getVariable ["OKS_ArtilleryBattle_DismountTime", -1];
                            
                            if (_dismountTime == -1) then {
                                _unit setVariable ["OKS_ArtilleryBattle_DismountTime", time, true];
                                
                                if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
                                    format["[AI_ARTILLERY] %1 dismounted from artillery - 30 second countdown started", name _unit] call OKS_fnc_LogDebug;
                                };
                            } else {
                                if ((time - _dismountTime) > 30) then {
                                    _unit setDamage 1;
                                    _eliminatedCount = _eliminatedCount + 1;
                                    
                                    if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
                                        format["[AI_ARTILLERY] Eliminated %1 after %2 seconds dismounted", 
                                            name _unit, round(time - _dismountTime)] call OKS_fnc_LogDebug;
                                    };
                                };
                            };
                        } else {
                            // Unit is back in artillery - reset timer
                            _unit setVariable ["OKS_ArtilleryBattle_DismountTime", -1, true];
                        };
                    };
                };
            } forEach _allUnits;
            
            _eliminatedCount
        };
        [_allUnits] call _monitorDismountedCrew;
        
        // Execute fire missions for both sides (using spawn to allow sleep functions)
        private _fireMissionHandles = [];
        private _side1Targets = [];
        private _side2Targets = [];
        
        if (alive _side1Artillery && !isNull _side1Artillery) then {
            _side1Targets = [_side1Artillery, _Side2, _battleId] call _selectTargets;
            if (count _side1Targets > 0) then {
                private _handle1 = [_side1Artillery, _side1Targets, _RoundsPerFireMission, _currentAccuracy, _currentFireMission] spawn _executeFireMission;
                _fireMissionHandles pushBack _handle1;
            };
        };
        
        if (alive _side2Artillery && !isNull _side2Artillery) then {
            _side2Targets = [_side2Artillery, _Side1, _battleId] call _selectTargets;
            if (count _side2Targets > 0) then {
                private _handle2 = [_side2Artillery, _side2Targets, _RoundsPerFireMission, _currentAccuracy, _currentFireMission] spawn _executeFireMission;
                _fireMissionHandles pushBack _handle2;
            };
        };
        
        // If no fire missions were started, skip to delay
        if (count _fireMissionHandles == 0) then {
            if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
                format["[AI_ARTILLERY] Fire Mission %1: No valid targets available (S1 targets: %2, S2 targets: %3) - skipping mission", 
                    _currentFireMission, count _side1Targets, count _side2Targets] call OKS_fnc_LogDebug;
            };
        };
        
        // Wait for both fire missions to complete before continuing
        {
            waitUntil {scriptDone _x};
        } forEach _fireMissionHandles;
        
        // Check victory conditions
        private _victor = [_battleId, _Side1, _Side2] call _checkVictory;
        if (_victor != sideUnknown) exitWith {
            if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
                format["[AI_ARTILLERY] === ARTILLERY BATTLE COMPLETE === %1 VICTORY! Waiting %2s before cleanup", 
                    _victor, _VictoryDelay] call OKS_fnc_LogDebug;
            };
            sleep _VictoryDelay;
        };
        
        // Check if should continue looping
        if (!_ShouldLoop) exitWith {
            if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
                "[AI_ARTILLERY] Single fire mission mode - battle complete" call OKS_fnc_LogDebug;
            };
        };
        
        // Improve accuracy for next fire mission (minimum 50m dispersion)
        _currentAccuracy = _currentAccuracy - 50;
        if (_currentAccuracy < 50) then {_currentAccuracy = 50};
        
        // Delay before next fire mission (base + random variation)
        private _actualDelay = _BaseFireMissionDelay + (random 30) - 15; // ±15 seconds variation
        if (_actualDelay < 10) then {_actualDelay = 10}; // Minimum 10 seconds
        
        if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
            format["[AI_ARTILLERY] Waiting %1 seconds before fire mission %2 (improved accuracy: %3m)", 
                round _actualDelay, _currentFireMission + 1, _currentAccuracy] call OKS_fnc_LogDebug;
        };
        
        sleep _actualDelay;
        _currentFireMission = _currentFireMission + 1;
    };
    
    // Final cleanup
    _Side1Spawn setVariable ["OKS_ArtilleryBattle_On", false, true];
    
    // Clean up artillery and crew
    {
        if (!isNull _x) then {
            _x setVariable ["OKS_ArtilleryBattle_UnlimitedAmmo", false, true];
            {deleteVehicle _x} forEach crew _x;
            deleteVehicle _x;
        };
    } forEach [_side1Artillery, _side2Artillery];
    
    private _totalDuration = time - _battleStartTime;
    if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
        format["[AI_ARTILLERY] === ARTILLERY BATTLE SYSTEM COMPLETE === Fire Missions: %1, Duration: %2 minutes", 
            _currentFireMission - 1, round(_totalDuration / 60)] call OKS_fnc_LogDebug;
    };
};

// Spawn the artillery battle system
if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
    format["[AI_ARTILLERY] Spawning artillery battle system thread - Battle ID: %1", _battleId] call OKS_fnc_LogDebug;
};

[_Side1Spawn, _Side2Spawn, _Side1, _Side2, _Side1Classes, _Side2Classes, _BaseFireMissionDelay, _RoundsPerFireMission, _ShouldLoop, _MaxFireMissions, _VictoryDelay, _battleId] spawn _artilleryBattleSystem;

// Return Side1 spawn object for external control
if (missionNamespace getVariable ["GOL_AI_ArtilleryBattle_Debug", false]) then {
    format["[AI_ARTILLERY] Function complete - artillery battle control object: %1", _Side1Spawn] call OKS_fnc_LogDebug;
};

_Side1Spawn