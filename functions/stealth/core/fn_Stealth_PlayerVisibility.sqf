/*
    Applies local player camouflage/audible traits based on light conditions.
    This must run on each client because player units are local to their owner.

    Usage:
    [] spawn OKS_fnc_Stealth_PlayerVisibility;
*/

if (!hasInterface) exitWith { false };
if (missionNamespace getVariable ["OKS_Stealth_PlayerVisibility_Started", false]) exitWith { true };
missionNamespace setVariable ["OKS_Stealth_PlayerVisibility_Started", true];

[] spawn {
    waitUntil { sleep 0.25; !isNull player };

    private _lastCamo = -1;
    private _lastAudible = -1;
    private _lastNight = "";
    private _lastDetected = false;
    private _lastDetectorKnowsAbout = -1;
    
    // Initialize server lighting cache (used to avoid NVG-influenced IR light)
    missionNamespace setVariable ["OKS_Stealth_ServerLighting", nil];
    missionNamespace setVariable ["OKS_Stealth_ServerLightingTime", -1];

    while { true } do {
        private _interval = missionNamespace getVariable ["GOL_Stealth_PlayerVisibilityInterval", 0.75];
        private _enabled = missionNamespace getVariable ["GOL_Stealth_Enabled", false]
            && { missionNamespace getVariable ["GOL_Stealth_PlayerVisibilityEnabled", true] };

        if (!_enabled || { !alive player }) then {
            if ((_lastCamo != 1) || (_lastAudible != 1)) then {
                player setUnitTrait ["camouflageCoef", 1];
                player setUnitTrait ["audibleCoef", 1];
                _lastCamo = 1;
                _lastAudible = 1;
            };

            _lastDetected = false;
            _lastDetectorKnowsAbout = -1;

            missionNamespace setVariable ["OKS_Stealth_PlayerVisibility_Watch", [
                ["enabled", false],
                ["alive", alive player],
                ["lightLevel", 0],
                ["ambientLight", 0],
                ["dynamicLight", 0],
                ["dark", false],
                ["lit", false],
                ["flashlight", false],
                ["flashlightState", false],
                ["irLaser", false],
                ["stance", toUpper (stance player)],
                ["camoBase", _lastCamo],
                ["camoStanceMul", 1],
                ["vegetationMul", 1],
                ["vegetationCount", 0],
                ["camo", _lastCamo],
                ["audible", _lastAudible],
                ["overcast", overcast],
                ["rain", rain],
                ["weatherMul", 1],
                ["detected", false],
                ["detector", objNull],
                ["detectorName", ""],
                ["detectorKnowsAbout", 0],
                ["detectorKnowsAboutUnit", 0],
                ["detectorKnowsAboutGroup", 0],
                ["detectThreshold", missionNamespace getVariable ["GOL_Stealth_PlayerDetectThreshold", 0.8]]
            ], false];

            sleep (_interval max 0.5);
            continue;
        };

        // Request lighting from server (NVG-agnostic measurement)
        // IMPORTANT: This ONLY works on TRUE DEDICATED SERVERS (not SP or player-hosted MP).
        // On dedicated servers, getLightingAt has NVG state permanently OFF, excluding IR-only lights.
        // In SP/local testing, server IS the player client, so IR lights still contaminate the result.
        [player, clientOwner] remoteExecCall ["OKS_fnc_Stealth_GetLightingServer", 2];
        
        // Use cached server lighting data (async response from previous frame)
        private _serverLighting = missionNamespace getVariable ["OKS_Stealth_ServerLighting", nil];
        private _serverLightingTime = missionNamespace getVariable ["OKS_Stealth_ServerLightingTime", -1];
        
        // If no server data yet, fall back to local measurement (will be inaccurate with NVGs on, but temporary)
        private _lighting = if (isNil "_serverLighting" || (_serverLightingTime < 0)) then {
            getLightingAt player
        } else {
            _serverLighting
        };
        
        _lighting params ["_sunLight", "_ambientLightBrightness", "_moonLight", "_dynamicLightBrightness"];
        private _totalLight = _ambientLightBrightness + _dynamicLightBrightness;
        
        private _hasIrLaser = player isIRLaserOn (currentWeapon player);
        private _hasFlashlightState = player isFlashlightOn (currentWeapon player);
        
        // Detect IR-only illuminators: they show as "flashlight on" but are invisible to naked eye.
        // Check if current weapon accessory is a known IR illuminator model or variant.
        private _currentWeapon = currentWeapon player;
        private _currentAccessories = switch (_currentWeapon) do {
            case (primaryWeapon player): { primaryWeaponItems player };
            case (handgunWeapon player): { handgunItems player };
            case (secondaryWeapon player): { secondaryWeaponItems player };
            default { [] };
        };
        private _flashlightItem = _currentAccessories param [1, ""]; // Index 1 = flashlight/laser slot
        
        // Known IR-only illuminators (no visibility penalty to AI)
        // IMPORTANT: When BettIR is present, these use BettIR's weapon illuminator system.
        // Without BettIR, they use scripted lights via OKS_fnc_IRIlluminator_Monitor.
        // Both methods keep irLight OFF in configs to prevent AI detection.
        private _irOnlyIlluminators = [
            "ACE_SPIR",         // ACE dedicated IR illuminator
            "GOL_OX3000",       // Base GOL dual (BettIR weapon illuminator when available)
            "GOL_OX3000_LR"     // Long range GOL dual (BettIR weapon illuminator when available)
        ];
        
        // GOL OX3000 modes:
        // GOL_OX3000, GOL_OX3000_LR = dual mode (empty config, BettIR/scripted light, no penalty)
        // GOL_OX3000_II, GOL_OX3000_LR_II = dedicated illuminator (empty config, STRONGER light, no penalty)
        // GOL_OX3000_FL, GOL_OX3000_LR_FL = visible flashlight (real config, DOES trigger penalty)
        private _hasIrIlluminator = (_flashlightItem in _irOnlyIlluminators) 
            || {(_flashlightItem find "_II") > -1};
        
        // IR illuminator modes may report flashlight-on; do not treat those as visible light.
        // Visible flashlight = flashlight on AND (no IR laser OR no IR illuminator accessory)
        private _hasVisibleFlashlight = _hasFlashlightState && !_hasIrLaser && !_hasIrIlluminator;
        private _stance = toUpper (stance player);

        // Granular darkness thresholds for very low stealth values
        // pitch_black (0-20): nearly invisible
        // very_dark (20-50): extremely hard to see
        // dark (50-100): hard to see
        // dim (100-200): reduced visibility
        // lit (200+): normal/increased visibility
        private _darknessLevel = if (_totalLight < 20) then {
            "pitch_black"
        } else {
            if (_totalLight < 50) then { "very_dark" } else {
                if (_totalLight < 100) then { "dark" } else {
                    if (_totalLight < 200) then { "dim" } else { "lit" }
                }
            }
        };

        // Base camouflage values scale dramatically with darkness
        private _targetCamo = switch (_darknessLevel) do {
            case "pitch_black": { 
                missionNamespace getVariable ["GOL_Stealth_PlayerCamoPitchBlack", 0.05] 
            };
            case "very_dark": { 
                missionNamespace getVariable ["GOL_Stealth_PlayerCamoVeryDark", 0.12] 
            };
            case "dark": { 
                missionNamespace getVariable ["GOL_Stealth_PlayerCamoDark", 0.25] 
            };
            case "dim": { 
                missionNamespace getVariable ["GOL_Stealth_PlayerCamoDim", 0.6] 
            };
            default { 
                missionNamespace getVariable ["GOL_Stealth_PlayerCamoLit", 1.0] 
            };
        };

        // Flashlight drastically increases visibility regardless of darkness
        if (_hasVisibleFlashlight) then {
            _targetCamo = (_targetCamo * 8) min 2.5;
        };

        // Vegetation concealment - check for nearby bushes/trees
        private _vegetationEnabled = missionNamespace getVariable ["GOL_Stealth_VegetationConcealmentEnabled", true];
        private _vegetationMultiplier = 1;
        private _nearVegetation = [];
        
        if (_vegetationEnabled) then {
            private _vegetationRadius = missionNamespace getVariable ["GOL_Stealth_VegetationRadius", 2.5];
            private _vegetationThreshold = missionNamespace getVariable ["GOL_Stealth_VegetationThreshold", 2];
            private _vegetationBonus = missionNamespace getVariable ["GOL_Stealth_VegetationMultiplier", 0.7];
            
            _nearVegetation = nearestTerrainObjects [
                player,
                ["BUSH", "TREE", "SMALL TREE", "HIDE"],
                _vegetationRadius,
                false,
                true
            ];
            
            if (count _nearVegetation >= _vegetationThreshold) then {
                _vegetationMultiplier = _vegetationBonus;
            };
        };

        private _camoStanceMultiplier = switch (_stance) do {
            case "PRONE": { missionNamespace getVariable ["GOL_Stealth_PlayerCamoMulProne", 0.8] };
            case "CROUCH": { missionNamespace getVariable ["GOL_Stealth_PlayerCamoMulCrouch", 0.9] };
            default { missionNamespace getVariable ["GOL_Stealth_PlayerCamoMulStand", 1.05] };
        };

        // Audible coefficient also benefits from darkness (harder to locate sounds)
        private _targetAudible = switch (_darknessLevel) do {
            case "pitch_black": { 
                missionNamespace getVariable ["GOL_Stealth_PlayerAudiblePitchBlack", 0.4] 
            };
            case "very_dark": { 
                missionNamespace getVariable ["GOL_Stealth_PlayerAudibleVeryDark", 0.55] 
            };
            case "dark": { 
                missionNamespace getVariable ["GOL_Stealth_PlayerAudibleDark", 0.7] 
            };
            case "dim": { 
                missionNamespace getVariable ["GOL_Stealth_PlayerAudibleDim", 0.85] 
            };
            default { 
                missionNamespace getVariable ["GOL_Stealth_PlayerAudibleLit", 1.0] 
            };
        };

        private _weatherEnabled = missionNamespace getVariable ["GOL_Stealth_PlayerAudibleWeatherEnabled", true];
        private _overcastThreshold = missionNamespace getVariable ["GOL_Stealth_PlayerAudibleWeatherOvercastMin", 0.5];
        private _rainThreshold = missionNamespace getVariable ["GOL_Stealth_PlayerAudibleWeatherRainMin", 0.15];
        private _weatherMinMultiplier = missionNamespace getVariable ["GOL_Stealth_PlayerAudibleWeatherMinMultiplier", 0.65];
        private _weatherAudibleMultiplier = 1;

        if (_weatherEnabled) then {
            private _weatherOvercast = overcast;
            private _weatherRain = rain;

            if ((_weatherOvercast >= _overcastThreshold) && (_weatherRain >= _rainThreshold)) then {
                private _overcastFactor = linearConversion [_overcastThreshold, 1, _weatherOvercast, 0, 1, true];
                private _rainFactor = linearConversion [_rainThreshold, 1, _weatherRain, 0, 1, true];
                private _weatherStrength = ((_rainFactor * 0.7) + (_overcastFactor * 0.3)) min 1;
                _weatherAudibleMultiplier = linearConversion [0, 1, _weatherStrength, 1, _weatherMinMultiplier, true];
            };
        };

        _targetAudible = _targetAudible * _weatherAudibleMultiplier;

        // Apply stance and vegetation modifiers to camouflage
        private _baseCamo = _targetCamo;
        _targetCamo = (_baseCamo * _camoStanceMultiplier * _vegetationMultiplier) min 1.5;
        
        // Allow very low values for extreme darkness - only enforce safety minimum
        private _absoluteMin = missionNamespace getVariable ["GOL_Stealth_PlayerAbsoluteMin", 0.01];
        _targetCamo = _targetCamo max _absoluteMin;
        _targetAudible = (_targetAudible max _absoluteMin) min 1.5;

        if (_targetCamo != _lastCamo) then {
            player setUnitTrait ["camouflageCoef", _targetCamo];
            _lastCamo = _targetCamo;
        };

        if (_targetAudible != _lastAudible) then {
            player setUnitTrait ["audibleCoef", _targetAudible];
            _lastAudible = _targetAudible;
        };

        private _detectThreshold = missionNamespace getVariable ["GOL_Stealth_PlayerDetectThreshold", 0.8];
        private _isDetected = false;
        private _detector = objNull;
        private _detectorKnowsAbout = 0;
        private _detectorKnowsAboutUnit = 0;
        private _detectorKnowsAboutGroup = 0;
        private _detectorName = "";

        // Debug-only detection probe: track the strongest enemy AI awareness of player.
        if (missionNamespace getVariable ["GOL_Stealth_PlayerVisibilityDebug", false]) then {
            private _playerSide = side group player;
            {
                if (alive _x && { !isPlayer _x } && { ((side group _x) getFriend _playerSide) < 0.6 }) then {
                    private _unitKnowledge = _x knowsAbout player;
                    private _groupKnowledge = (group _x) knowsAbout player;
                    private _knowledge = _unitKnowledge max _groupKnowledge;
                    if (_knowledge > _detectorKnowsAbout) then {
                        _detectorKnowsAbout = _knowledge;
                        _detectorKnowsAboutUnit = _unitKnowledge;
                        _detectorKnowsAboutGroup = _groupKnowledge;
                        _detector = _x;
                    };
                };
            } forEach allUnits;

            _isDetected = _detectorKnowsAbout >= _detectThreshold;

            if (!isNull _detector) then {
                _detectorName = name _detector;
            };

            // Log awareness progression so debug shows buildup before full detection.
            if (_detectorKnowsAbout > 0 && { (_lastDetectorKnowsAbout < 0) || (_detectorKnowsAbout >= (_lastDetectorKnowsAbout + 0.2)) }) then {
                private _probeDist = if (isNull _detector) then { -1 } else { round (_detector distance player) };
                [format ["[Stealth.DetectProbe] by=%1 k=%2 unitK=%3 groupK=%4 threshold=%5 d=%6m", _detectorName, _detectorKnowsAbout, _detectorKnowsAboutUnit, _detectorKnowsAboutGroup, _detectThreshold, _probeDist], false, false, true] spawn OKS_fnc_LogDebug;
                _lastDetectorKnowsAbout = _detectorKnowsAbout;
            };

            if (_detectorKnowsAbout <= 0) then {
                _lastDetectorKnowsAbout = 0;
            };

            if (_isDetected && !_lastDetected) then {
                private _liveCamo = player getUnitTrait "camouflageCoef";
                private _liveAudible = player getUnitTrait "audibleCoef";
                private _detectorDist = if (isNull _detector) then { -1 } else { round (_detector distance player) };

                systemChat format ["[Stealth.Detect] Spotted by %1 (k=%2, d=%3m) | camo=%4 audible=%5 light=%6", _detectorName, _detectorKnowsAbout, _detectorDist, _liveCamo, _liveAudible, _totalLight];
                [format ["[Stealth.Detect] by=%1 k=%2 d=%3m camo=%4 audible=%5 light=%6 level=%7 flash=%8 ir=%9", _detectorName, _detectorKnowsAbout, _detectorDist, _liveCamo, _liveAudible, _totalLight, _darknessLevel, _hasVisibleFlashlight, _hasIrLaser], false, false, true] spawn OKS_fnc_LogDebug;

                missionNamespace setVariable ["OKS_Stealth_PlayerVisibility_DetectionSnapshot", [
                    ["time", time],
                    ["detector", _detector],
                    ["detectorName", _detectorName],
                    ["detectorKnowsAbout", _detectorKnowsAbout],
                    ["detectorKnowsAboutUnit", _detectorKnowsAboutUnit],
                    ["detectorKnowsAboutGroup", _detectorKnowsAboutGroup],
                    ["detectThreshold", _detectThreshold],
                    ["detectorDistance", _detectorDist],
                    ["camo", _liveCamo],
                    ["audible", _liveAudible],
                    ["lightLevel", _totalLight],
                    ["darknessLevel", _darknessLevel],
                    ["flashlight", _hasVisibleFlashlight],
                    ["irLaser", _hasIrLaser],
                    ["overcast", overcast],
                    ["rain", rain]
                ], false];
            };
        };

        _lastDetected = _isDetected;

        missionNamespace setVariable ["OKS_Stealth_PlayerVisibility_Watch", [
            ["enabled", true],
            ["alive", alive player],
            ["lightLevel", _totalLight],
            ["ambientLight", _ambientLightBrightness],
            ["dynamicLight", _dynamicLightBrightness],
            ["darknessLevel", _darknessLevel],
            ["flashlight", _hasVisibleFlashlight],
            ["flashlightState", _hasFlashlightState],
            ["irLaser", _hasIrLaser],
            ["stance", _stance],
            ["camoBase", _baseCamo],
            ["camoStanceMul", _camoStanceMultiplier],
            ["vegetationMul", _vegetationMultiplier],
            ["vegetationCount", if (_vegetationEnabled) then { count _nearVegetation } else { 0 }],
            ["camo", _targetCamo],
            ["audible", _targetAudible],
            ["overcast", overcast],
            ["rain", rain],
            ["weatherMul", _weatherAudibleMultiplier],
            ["detected", _isDetected],
            ["detector", _detector],
            ["detectorName", _detectorName],
            ["detectorKnowsAbout", _detectorKnowsAbout],
            ["detectorKnowsAboutUnit", _detectorKnowsAboutUnit],
            ["detectorKnowsAboutGroup", _detectorKnowsAboutGroup],
            ["detectThreshold", _detectThreshold]
        ], false];

        // Optional one-line state snapshot, only when darkness level changes.
        if ((_darknessLevel != _lastNight) && { missionNamespace getVariable ["GOL_Stealth_PlayerVisibilityDebug", false] }) then {
            [format ["[Stealth.Player] light=%1 level=%2 flash=%3 ir=%4 stance=%5 camo=%6 audible=%7 overcast=%8 rain=%9 weatherMul=%10", _totalLight, _darknessLevel, _hasVisibleFlashlight, _hasIrLaser, _stance, _targetCamo, _targetAudible, overcast, rain, _weatherAudibleMultiplier], false, false, true] spawn OKS_fnc_LogDebug;
        };
        _lastNight = _darknessLevel;

        sleep (_interval max 0.5);
    };
};

true
