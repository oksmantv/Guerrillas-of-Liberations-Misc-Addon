/*
    Client-side IR illuminator strength adjuster (BettIR integration).
    Swaps BettIR's weapon light objects with strength-adjusted variants.
    
    HOW IT WORKS:
    - BettIR creates 'BettIR_Illuminator_Weapon' vehicle lights (reflector-based beam)
    - BettIR stores the light in unit variable: 'BettIR_weapon_illuminator_object'
    - BettIR's EachFrame handler positions the light but never recreates it
    - Vehicle reflector intensity is CONFIG-ONLY (can't use setLightIntensity on vehicles!)
    
    OUR APPROACH:
    - Created 10 vehicle classes: BettIR_Illuminator_Weapon (100%), _90 (90%), ..., _10 (10%)
    - Each class has different reflector intensity in config (70, 63, 56, ... 7)
    - When strength changes, delete BettIR's light and spawn correct class
    - Store our light in BettIR's variable - BettIR's positioning system works on OUR light!
    - Result: Adjustable intensity with BettIR's superior beam positioning
    
    Active variants:
    - GOL_OX3000 (Dual): IR laser + moderate illuminator
    - GOL_OX3000_II (Pure IR): Dedicated illuminator only
    
    Strength levels (adjustable 10-100% via Ctrl+Scroll):
    - 10%: BettIR_Illuminator_Weapon_10 (intensity 7)
    - 20%: BettIR_Illuminator_Weapon_20 (intensity 14)
    - ...
    - 100%: BettIR_Illuminator_Weapon (intensity 70)
    
    Multiplayer:
    - Each client runs this monitor independently
    - BettIR lights are createVehicleLocal (client-side only)
    - Strength setting is synced via unit variable (public)
    - Everyone sees the same adjusted intensity for each player
    
    Usage:
    [] spawn OKS_fnc_IRIlluminator_Monitor;
*/

if (!hasInterface) exitWith { false };
if (missionNamespace getVariable ["OKS_IRIlluminator_Monitor_Started", false]) exitWith { true };
missionNamespace setVariable ["OKS_IRIlluminator_Monitor_Started", true];

[] spawn {
    waitUntil { sleep 0.25; !isNull player };
    
    // Detect if BettIR is present (creates proper beam lights)
    private _hasBettIR = isClass (configFile >> "CfgPatches" >> "BettIR_Core");
    
    // Track lights per unit: [[unit, light], [unit, light], ...] (only used when BettIR NOT present)
    private _unitLights = [];
    
    while { true } do {
        private _enabled = missionNamespace getVariable ["GOL_IRIlluminator_Enabled", true];
        
        if (!_enabled) then {
            // Clean up all lights if system disabled (only if we're managing lights)
            if (!_hasBettIR) then {
                {
                    private _light = _x select 1;
                    if (!isNull _light) then {
                        deleteVehicle _light;
                    };
                } forEach _unitLights;
                _unitLights = [];
            };
            sleep 1;
            continue;
        };
        
        // Get all players within reasonable distance (optimization)
        private _maxDistance = missionNamespace getVariable ["GOL_IRIlluminator_MaxDistance", 150];
        private _nearPlayers = allPlayers select {
            alive _x && { (player distance _x) < _maxDistance }
        };
        
        // Track which units should have lights this frame
        private _unitsWithLights = [];
        
        // Check each nearby player
        {
            private _unit = _x;
            private _weapon = currentWeapon _unit;
            
            if (_weapon != "") then {
                // Get weapon accessories
                private _accessories = switch (_weapon) do {
                    case (primaryWeapon _unit): { primaryWeaponItems _unit };
                    case (handgunWeapon _unit): { handgunItems _unit };
                    case (secondaryWeapon _unit): { secondaryWeaponItems _unit };
                    default { [] };
                };
                private _flashlightItem = _accessories param [1, ""];
                
                // Check activation state based on mode
                // Dual mode (GOL_OX3000): Requires IR laser ON
                // Illuminator mode (GOL_OX3000_II): No laser, check BettIR weapon illuminator state
                private _irLaserActive = _unit isIRLaserOn _weapon;
                private _bettirWeaponOn = _unit getVariable ['BettIR_weapon_illuminator_on', false];
                
                private _isDualMode = (_flashlightItem in ["GOL_OX3000", "GOL_OX3000_LR"]);
                private _isIIMode = (_flashlightItem in ["GOL_OX3000_II", "GOL_OX3000_LR_II"]);
                private _isIRIlluminator = _isDualMode || _isIIMode;
                
                // Unit should have light if:
                // - Dual mode: IR laser is ON
                // - Illuminator mode: BettIR weapon illuminator is ON
                private _shouldHaveLight = if (_isDualMode) then {
                    _irLaserActive
                } else {
                    _isIIMode && _bettirWeaponOn
                };
                
                if (_isIRIlluminator && _shouldHaveLight) then {
                    _unitsWithLights pushBack _unit;
                    
                    // Get unit's strength setting (default 1% - minimum)
                    private _strengthMultiplier = (_unit getVariable ["GOL_IRIlluminator_Strength", 1]) / 100;
                    
                    // ** BettIR Integration: Replace BettIR's light with our adjustable variant **
                    if (_hasBettIR) then {
                        // BettIR stores weapon light in 'BettIR_weapon_illuminator_object'
                        private _currentLight = _unit getVariable ['BettIR_weapon_illuminator_object', objNull];
                        
                        // Determine which light class to use based on strength
                        private _strength = _strengthMultiplier * 100;
                        private _lightClass = if (_strength >= 3) then {
                            "BettIR_Illuminator_Weapon_3"  // Maximum (3%) - extended
                        } else {
                            if (_strength >= 2.5) then {
                                "BettIR_Illuminator_Weapon_2_5"  // Very High (2.5%) - extended
                            } else {
                                if (_strength >= 2) then {
                                    "BettIR_Illuminator_Weapon_2"  // High (2%)
                                } else {
                                    if (_strength >= 1.5) then {
                                        "BettIR_Illuminator_Weapon_1_5"  // Medium (1.5%)
                                    } else {
                                        "BettIR_Illuminator_Weapon_1"  // Low (1%)
                                    }
                                }
                            }
                        };
                        
                        // Check if light exists and is wrong class (strength changed)
                        private _needsReplacement = false;
                        if (!isNull _currentLight) then {
                            if (typeOf _currentLight != _lightClass) then {
                                _needsReplacement = true;
                            };
                        } else {
                            // Light hasn't been created yet, let BettIR create it first
                            _needsReplacement = false;
                        };
                        
                        // Replace light with correct strength variant
                        if (_needsReplacement) then {
                            // Delete old light
                            deleteVehicle _currentLight;
                            
                            // Create new light with correct intensity class
                            private _newLight = _lightClass createVehicleLocal (getPosATL _unit);
                            hideObject _newLight;  // BettIR will unhide it
                            _newLight setVariable ['BettIR_owner', _unit];
                            
                            // Store in BettIR's variable so BettIR's positioning system works
                            _unit setVariable ['BettIR_weapon_illuminator_object', _newLight, false];
                            
                            if (missionNamespace getVariable ["GOL_IRIlluminator_Debug", false]) then {
                                private _unitName = if (_unit == player) then { "YOU" } else { name _unit };
                                systemChat format ["[IR Illuminator] Replaced IR light for %1 - Strength: %2%%, Class: %3", _unitName, _strength, _lightClass];
                            };
                        } else {
                            // No replacement needed, light is correct class or doesn't exist yet
                            if (missionNamespace getVariable ["GOL_IRIlluminator_Debug", false] && !isNull _currentLight) then {
                                private _unitName = if (_unit == player) then { "YOU" } else { name _unit };
                                systemChat format ["[IR Illuminator] IR light OK for %1 - Strength: %2%%, Class: %3", _unitName, _strength, typeOf _currentLight];
                            };
                        };
                    } else {
                        // ** Fallback: Create scripted lights when BettIR not present **
                        // Get or create light for this unit
                        private _existingLight = objNull;
                        private _existingIndex = -1;
                        {
                            if ((_x select 0) == _unit) exitWith {
                                _existingLight = _x select 1;
                                _existingIndex = _forEachIndex;
                            };
                        } forEach _unitLights;
                        
                        if (isNull _existingLight) then {
                            // Create new light
                            private _light = "#lightpoint" createVehicleLocal (getPosATL _unit);
                            _light setLightBrightness _brightness;
                            _light setLightColor [1, 1, 1];
                            _light setLightAmbient [0.8, 0.8, 0.8];
                            _light setLightIntensity _intensity;
                            _light setLightUseFlare true;
                            _light setLightFlareSize 1.4;
                            _light setLightFlareMaxDistance _range;
                            _light setLightDayLight false;
                            _light attachTo [_unit, [0, 0.3, 0.1], "head"];
                            
                            private _currentStrength = round (_strengthMultiplier * 100);
                            _light setVariable ["GOL_LastStrength", _currentStrength];
                            
                            _unitLights pushBack [_unit, _light];
                            
                            if (missionNamespace getVariable ["GOL_IRIlluminator_Debug", false]) then {
                                private _unitName = if (_unit == player) then { "YOU" } else { name _unit };
                                private _strengthPct = round (_strengthMultiplier * 100);
                                systemChat format ["[IR Illuminator] Created scripted light for %1 (%2) - Strength: %3%%, Intensity: %4", _unitName, _flashlightItem, _strengthPct, round _intensity];
                            };
                        } else {
                            // Update existing light
                            private _lastStrength = _existingLight getVariable ["GOL_LastStrength", -1];
                            private _currentStrength = round (_strengthMultiplier * 100);
                            
                            if (_lastStrength != _currentStrength || (missionNamespace getVariable ["GOL_IRIlluminator_ForceUpdate", false])) then {
                                deleteVehicle _existingLight;
                                
                                private _light = "#lightpoint" createVehicleLocal (getPosATL _unit);
                                _light setLightBrightness _brightness;
                                _light setLightColor [1, 1, 1];
                                _light setLightAmbient [0.8, 0.8, 0.8];
                                _light setLightIntensity _intensity;
                                _light setLightUseFlare true;
                                _light setLightFlareSize 1.4;
                                _light setLightFlareMaxDistance _range;
                                _light setLightDayLight false;
                                _light attachTo [_unit, [0, 0.3, 0.1], "head"];
                                _light setVariable ["GOL_LastStrength", _currentStrength];
                                
                                _unitLights set [_existingIndex, [_unit, _light]];
                                
                                if (missionNamespace getVariable ["GOL_IRIlluminator_Debug", false]) then {
                                    private _unitName = if (_unit == player) then { "YOU" } else { name _unit };
                                    systemChat format ["[IR Illuminator] RECREATED scripted light for %1 - Strength: %2%%, Intensity: %3", _unitName, _currentStrength, round _intensity];
                                };
                            } else {
                                _existingLight setLightIntensity _intensity;
                                _existingLight setLightBrightness _brightness;
                            };
                        };
                    };
                };
            };
        } forEach _nearPlayers;
        
        // Clear force update flag
        if (missionNamespace getVariable ["GOL_IRIlluminator_ForceUpdate", false]) then {
            missionNamespace setVariable ["GOL_IRIlluminator_ForceUpdate", false];
        };
        
        // Clean up lights for units that no longer need them (only when managing scripted lights)
        if (!_hasBettIR) then {
            private _indicesToRemove = [];
            {
                private _unit = _x select 0;
                private _light = _x select 1;
                
                // Remove if unit no longer in active list, dead, or too far
                if (!(_unit in _unitsWithLights) || !alive _unit || (player distance _unit) >= _maxDistance) then {
                    if (!isNull _light) then {
                        deleteVehicle _light;
                        
                        if (missionNamespace getVariable ["GOL_IRIlluminator_Debug", false]) then {
                            private _unitName = if (_unit == player) then { "YOU" } else { name _unit };
                            systemChat format ["[IR Illuminator] Removed light for %1", _unitName];
                        };
                    };
                    _indicesToRemove pushBack _forEachIndex;
                };
            } forEach _unitLights;
            
            // Remove cleaned up entries from tracking (reverse order to preserve indices)
            reverse _indicesToRemove;
            {
                _unitLights deleteAt _x;
            } forEach _indicesToRemove;
        };
        
        sleep 0.15;  // Balanced update rate for multiplayer
    };
};

true
