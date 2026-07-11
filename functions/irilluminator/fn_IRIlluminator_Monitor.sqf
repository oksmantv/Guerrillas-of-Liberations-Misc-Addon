/*
    Client-side IR illuminator light manager (multiplayer-aware).
    Creates scripted #lightpoint objects for BOTH dual and _II modes.
    
    CRITICAL: AI CAN SEE irLight=1 flashlights! Only IR laser BEAMS are invisible to AI.
    Therefore ALL IR modes use empty Flashlight configs and scripted lights when IR laser is ON.
    
    Intensity levels:
    - Dual modes (GOL_OX3000, GOL_OX3000_LR): 250/500 (moderate, simulating original configs)
    - _II modes (GOL_OX3000_II, GOL_OX3000_LR_II): 4000/8000 (MUCH stronger, dedicated illuminators)
    
    Like BettIR: Each client independently creates LOCAL lights for all nearby players.
    - No network traffic (createVehicleLocal)
    - Everyone sees everyone's IR illuminators through NVGs
    - No isFlashlightOn = true (empty Flashlight configs)
    - BettIR compatibility: Boosts goggle light when _II modes active
    
    Usage:
    [] spawn OKS_fnc_IRIlluminator_Monitor;
*/

if (!hasInterface) exitWith { false };
if (missionNamespace getVariable ["OKS_IRIlluminator_Monitor_Started", false]) exitWith { true };
missionNamespace setVariable ["OKS_IRIlluminator_Monitor_Started", true];

[] spawn {
    waitUntil { sleep 0.25; !isNull player };
    
    // Track lights per unit: [[unit, light], [unit, light], ...]
    private _unitLights = [];
    
    while { true } do {
        private _enabled = missionNamespace getVariable ["GOL_IRIlluminator_Enabled", true];
        
        if (!_enabled) then {
            // Clean up all lights if system disabled
            {
                private _light = _x select 1;
                if (!isNull _light) then {
                    deleteVehicle _light;
                };
            } forEach _unitLights;
            _unitLights = [];
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
                
                // Check if IR laser is active (trigger for IR illuminator mode)
                private _irLaserActive = _unit isIRLaserOn _weapon;
                
                // Create scripted lights for BOTH dual and _II modes when IR laser is ON
                // Dual (GOL_OX3000, GOL_OX3000_LR) = moderate intensity (simulates original 70/140 irLight)
                // _II (GOL_OX3000_II, GOL_OX3000_LR_II) = MUCH stronger (4000/8000 for dedicated illuminators)
                // Important: AI CAN see irLight=1 flashlights, only IR laser BEAMS are invisible
                private _isDualMode = (_flashlightItem in ["GOL_OX3000", "GOL_OX3000_LR"]);
                private _isIIMode = (_flashlightItem find "_II") > -1;
                private _isIRIlluminator = _isDualMode || _isIIMode;
                
                // Unit should have light if using IR illuminator mode
                if (_isIRIlluminator && _irLaserActive) then {
                    _unitsWithLights pushBack _unit;
                    
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
                        private _isLongRange = (_flashlightItem find "_LR") > -1;
                        
                        // Dual modes: moderate intensity (simulating original configs)
                        // _II modes: MUCH stronger intensity (dedicated illuminators)
                        private _intensity = if (_isIIMode) then {
                            if (_isLongRange) then {
                                missionNamespace getVariable ["GOL_IRIlluminator_Intensity_LR", 8000]
                            } else {
                                missionNamespace getVariable ["GOL_IRIlluminator_Intensity", 4000]
                            }
                        } else {
                            // Dual mode: lower intensity matching original irLight configs
                            if (_isLongRange) then { 500 } else { 250 }
                        };
                        
                        private _brightness = if (_isIIMode) then {
                            missionNamespace getVariable ["GOL_IRIlluminator_Brightness", 8]
                        } else {
                            // Dual mode: lower brightness
                            4
                        };
                        private _range = if (_isLongRange) then { 600 } else { 250 };
                        
                        // Create light at unit position
                        private _light = "#lightpoint" createVehicleLocal (getPosATL _unit);
                        _light setLightBrightness _brightness;
                        _light setLightColor [1, 1, 1];
                        _light setLightAmbient [0.8, 0.8, 0.8];
                        _light setLightIntensity _intensity;
                        _light setLightUseFlare true;
                        _light setLightFlareSize 1.4;
                        _light setLightFlareMaxDistance _range;
                        _light setLightDayLight false;
                        
                        // Attach to unit
                        _light attachTo [_unit, [0, 0.3, 0.1], "head"];
                        
                        _unitLights pushBack [_unit, _light];
                        
                        // BettIR Compatibility: Override goggle light intensity ONLY for _II modes
                        if (_isIIMode && isClass (configFile >> "CfgPatches" >> "BETT_IR")) then {
                            private _goggles = goggles _unit;
                            if (_goggles != "") then {
                                // Set BettIR goggle light to match our IR illuminator intensity
                                _unit setVariable ["BETT_IR_light_intensity", _intensity, false];
                                _unit setVariable ["BETT_IR_light_brightness", _brightness, false];
                            };
                        };
                        
                        if (missionNamespace getVariable ["GOL_IRIlluminator_Debug", false]) then {
                            private _unitName = if (_unit == player) then { "YOU" } else { name _unit };
                            systemChat format ["[IR Illuminator] Created light for %1 (%2)", _unitName, _flashlightItem];
                        };
                    };
                };
            };
        } forEach _nearPlayers;
        
        // Clean up lights for units that no longer need them
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
        
        sleep 0.15;  // Balanced update rate for multiplayer
    };
};

true
