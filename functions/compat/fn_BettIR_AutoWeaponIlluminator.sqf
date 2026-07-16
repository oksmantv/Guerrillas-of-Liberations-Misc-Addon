/*
    Auto-activates BettIR weapon illuminator for GOL_OX3000 attachments.
    
    Mode switching behavior:
    - IR modes (Dual/Pointer/Illuminator): Laser state preserved as a group
      * Dual ↔ Pointer: Keep laser state
      * Illuminator → Dual/Pointer: Auto-enable laser
      * Dual/Pointer → Illuminator: Illuminator auto-starts (no laser in _II)
    - Flashlight mode: Always manual (OFF when entering/exiting)
    
    Auto-activation:
    - _II modes (illuminator): Auto-on when NVGs on, no laser capability
    - Dual modes: Auto-on when IR laser + NVGs on
    - _IP modes (pointer): Manual BettIR control only (Ctrl+Shift+L)
    
    Usage:
    [] call OKS_fnc_BettIR_AutoWeaponIlluminator;
*/

if (!hasInterface) exitWith {};
if (!isClass (configFile >> "CfgPatches" >> "BettIR_Core")) exitWith {
    ["[BettIR_AutoWeaponIlluminator] BettIR not detected, auto-illuminator disabled.", false, false, true] spawn OKS_fnc_LogDebug;
};

// Mode classifications
private _illuminatorModes = [
    "gol_ox3000_ii",        // Dedicated illuminator (no laser)
    "gol_ox3000_lr_ii"      // Compat stub (same as standard)
];

private _dualModes = [
    "gol_ox3000",           // Dual mode (laser + illuminator)
    "gol_ox3000_lr"         // Compat stub (same as standard)
];

private _pointerModes = [
    "gol_ox3000_ip",        // IR pointer only
    "gol_ox3000_lr_ip"      // Compat stub (same as standard)
];

private _flashlightModes = [
    "gol_ox3000_fl",        // Visible flashlight (High)
    "gol_ox3000_fl_low",    // Visible flashlight (Low)
    "gol_ox3000_lr_fl",     // Compat stub (same as standard)
    "gol_ox3000_lr_fl_low"  // Compat stub low
];

private _allIRModes = _illuminatorModes + _dualModes + _pointerModes;
private _laserCapableModes = _dualModes + _pointerModes;

[{
    params ["_args", "_handle"];
    _args params ["_illuminatorModes", "_dualModes", "_pointerModes", "_flashlightModes", "_allIRModes", "_laserCapableModes"];
    
    if (!alive player) exitWith {};
    
    // Check if BettIR functions are available
    if (isNil "BettIR_fnc_weaponIlluminatorOn") exitWith {};
    
    private _currentWeapon = primaryWeapon player;
    if (_currentWeapon == "") exitWith {
        // No weapon, deactivate and clear auto state
        private _wasAutoActive = player getVariable ["OKS_BettIR_AutoActive", false];
        private _bettirWeaponOn = player getVariable ["BettIR_weapon_illuminator_on", false];
        
        if (_wasAutoActive && _bettirWeaponOn) then {
            [player] call BettIR_fnc_weaponIlluminatorOff;
        };
        
        player setVariable ["OKS_BettIR_AutoActive", false];
        player setVariable ["OKS_BettIR_AutoMode", ""];
        player setVariable ["OKS_BettIR_LastAttachment", ""];
    };
    
    private _weaponItems = primaryWeaponItems player;
    private _attachment = toLower (_weaponItems param [1, ""]);
    private _lastAttachment = player getVariable ["OKS_BettIR_LastAttachment", ""];
    
    // Classify current and previous attachments
    private _isIlluminatorMode = _attachment in _illuminatorModes;
    private _isDualMode = _attachment in _dualModes;
    private _isPointerMode = _attachment in _pointerModes;
    private _isFlashlightMode = _attachment in _flashlightModes;
    private _isIRMode = _attachment in _allIRModes;
    private _isGOLAttachment = _isIRMode || _isFlashlightMode;
    
    // Exit if not a GOL attachment at all
    if (!_isGOLAttachment && _attachment != "") exitWith {
        player setVariable ["OKS_BettIR_LastAttachment", ""];
        player setVariable ["OKS_BettIR_LaserStateBeforeSwitch", false];
    };
    
    // Store laser state BEFORE detecting mode switch (critical for preservation)
    private _currentLaserState = false;
    if (_attachment in _laserCapableModes) then {
        _currentLaserState = player isIRLaserOn _currentWeapon;
    };
    
    // Detect mode switch
    private _modeSwitched = (_attachment != _lastAttachment) && (_lastAttachment != "");
    
    // Handle mode switching
    if (_modeSwitched) then {
        private _wasIRMode = _lastAttachment in _allIRModes;
        private _wasFlashlight = _lastAttachment in _flashlightModes;
        private _wasIlluminator = _lastAttachment in _illuminatorModes;
        private _laserWasOn = player getVariable ["OKS_BettIR_LaserStateBeforeSwitch", false];
        private _canUseLaser = _attachment in _laserCapableModes;
        private _bettirWeaponOn = player getVariable ["BettIR_weapon_illuminator_on", false];
        
        if (missionNamespace getVariable ["GOL_Stealth_PlayerVisibilityDebug", false]) then {
            [format ["[BettIR_Auto] Mode switch: %1 → %2 (laser was: %3)", _lastAttachment, _attachment, _laserWasOn], false, false, true] spawn OKS_fnc_LogDebug;
        };
        
        // Switching TO flashlight → turn off BettIR illuminator AND flashlight (prevent auto-on)
        if (_isFlashlightMode && _bettirWeaponOn) then {
            [player] call BettIR_fnc_weaponIlluminatorOff;
            player setVariable ["OKS_BettIR_AutoActive", false];
            
            // Force flashlight OFF to prevent auto-activation
            [{
                params ["_unit", "_weapon"];
                if (_unit isFlashlightOn _weapon) then {
                    _unit action ["gunLightOff", _unit];
                };
            }, [player, currentWeapon player], 0.1] call CBA_fnc_waitAndExecute;
            
            if (missionNamespace getVariable ["GOL_Stealth_PlayerVisibilityDebug", false]) then {
                ["[BettIR_Auto] Switched to flashlight: disabled BettIR illuminator and forced flashlight OFF", false, false, true] spawn OKS_fnc_LogDebug;
            };
        };
        
        // Switching between IR modes (preserve laser state)
        if (_wasIRMode && _isIRMode && !_wasFlashlight && !_isFlashlightMode) then {
            // FROM illuminator TO laser-capable mode → auto-enable laser
            if (_wasIlluminator && _canUseLaser) then {
                [{
                    params ["_unit", "_weapon"];
                    if (!(_unit isIRLaserOn _weapon)) then {
                        _unit action ["IRLaserOn", _unit];
                        if (missionNamespace getVariable ["GOL_Stealth_PlayerVisibilityDebug", false]) then {
                            ["[BettIR_Auto] Illuminator→Dual/Pointer: auto-enabled laser", false, false, true] spawn OKS_fnc_LogDebug;
                        };
                    };
                }, [player, _currentWeapon], 0.1] call CBA_fnc_waitAndExecute;
            };
            
            // Between laser-capable modes → restore laser state
            if (!_wasIlluminator && _canUseLaser && _laserWasOn) then {
                [{
                    params ["_unit", "_weapon"];
                    if (!(_unit isIRLaserOn _weapon)) then {
                        _unit action ["IRLaserOn", _unit];
                        if (missionNamespace getVariable ["GOL_Stealth_PlayerVisibilityDebug", false]) then {
                            ["[BettIR_Auto] Dual↔Pointer: restored laser", false, false, true] spawn OKS_fnc_LogDebug;
                        };
                    };
                }, [player, _currentWeapon], 0.1] call CBA_fnc_waitAndExecute;
            };
        };
    };
    
    // Store state for next iteration
    player setVariable ["OKS_BettIR_LastAttachment", _attachment];
    player setVariable ["OKS_BettIR_LaserStateBeforeSwitch", _currentLaserState];
    
    // Only auto-manage illuminator for Dual and Illuminator modes
    // Pointer and Flashlight modes are manual-only
    if (!_isIlluminatorMode && !_isDualMode) exitWith {
        // Clear auto-activation state if leaving managed modes
        private _lastAutoMode = player getVariable ["OKS_BettIR_AutoMode", ""];
        if (_lastAutoMode != "") then {
            private _wasAutoActive = player getVariable ["OKS_BettIR_AutoActive", false];
            private _bettirWeaponOn = player getVariable ["BettIR_weapon_illuminator_on", false];
            if (_wasAutoActive && _bettirWeaponOn) then {
                [player] call BettIR_fnc_weaponIlluminatorOff;
            };
            player setVariable ["OKS_BettIR_AutoActive", false];
            player setVariable ["OKS_BettIR_AutoMode", ""];
        };
    };
    
    // Auto-activation logic (only for Dual and Illuminator modes)
    private _nvgOn = currentVisionMode player == 1;
    private _irLaserOn = player isIRLaserOn _currentWeapon;
    private _bettirWeaponOn = player getVariable ["BettIR_weapon_illuminator_on", false];
    private _wasAutoActive = player getVariable ["OKS_BettIR_AutoActive", false];
    
    // Auto-activation logic (only for Dual and Illuminator modes)
    private _nvgOn = currentVisionMode player == 1;
    private _irLaserOn = player isIRLaserOn _currentWeapon;
    private _bettirWeaponOn = player getVariable ["BettIR_weapon_illuminator_on", false];
    private _wasAutoActive = player getVariable ["OKS_BettIR_AutoActive", false];
    private _lastAutoMode = player getVariable ["OKS_BettIR_AutoMode", ""];
    
    // Determine if illuminator SHOULD be on based on mode
    private _shouldBeOn = false;
    private _currentMode = "";
    
    if (_isIlluminatorMode) then {
        // Dedicated illuminator: activate when NVGs on
        _shouldBeOn = _nvgOn;
        _currentMode = "illuminator";
    } else {
        // Dual mode: activate when NVGs on AND IR laser on
        _shouldBeOn = _nvgOn && _irLaserOn;
        _currentMode = "dual";
    };
    
    // Mode type changed? (illuminator ↔ dual) → deactivate first
    if ((_lastAutoMode != "") && (_lastAutoMode != _currentMode) && _wasAutoActive && _bettirWeaponOn) then {
        [player] call BettIR_fnc_weaponIlluminatorOff;
        player setVariable ["OKS_BettIR_AutoActive", false];
        
        if (missionNamespace getVariable ["GOL_Stealth_PlayerVisibilityDebug", false]) then {
            [format ["[BettIR_Auto] Mode type changed %1→%2, deactivating", _lastAutoMode, _currentMode], false, false, true] spawn OKS_fnc_LogDebug;
        };
    };
    
    player setVariable ["OKS_BettIR_AutoMode", _currentMode];
    
    // Auto-activate when conditions met
    if (_shouldBeOn && !_bettirWeaponOn) then {
        // Use GOL's wrapper to create light with correct strength from the start
        [player] call OKS_fnc_IRIlluminator_WeaponIlluminatorOn;
        player setVariable ["OKS_BettIR_AutoActive", true];
        
        if (missionNamespace getVariable ["GOL_Stealth_PlayerVisibilityDebug", false]) then {
            [format ["[BettIR_Auto] Activated %1 mode for %2", _currentMode, _attachment], false, false, true] spawn OKS_fnc_LogDebug;
        };
    };
    
    // Auto-deactivate when conditions no longer met (only if WE activated it)
    if (!_shouldBeOn && _bettirWeaponOn && _wasAutoActive) then {
        [player] call BettIR_fnc_weaponIlluminatorOff;
        player setVariable ["OKS_BettIR_AutoActive", false];
        
        if (missionNamespace getVariable ["GOL_Stealth_PlayerVisibilityDebug", false]) then {
            [format ["[BettIR_Auto] Deactivated %1 mode", _currentMode], false, false, true] spawn OKS_fnc_LogDebug;
        };
    };
    
    // Clear auto flag if BettIR was manually toggled off (respect manual control)
    if (!_bettirWeaponOn && _wasAutoActive) then {
        player setVariable ["OKS_BettIR_AutoActive", false];
    };
    
}, 0.25, [_illuminatorModes, _dualModes, _pointerModes, _flashlightModes, _allIRModes, _laserCapableModes]] call CBA_fnc_addPerFrameHandler;

["[BettIR_AutoWeaponIlluminator] Started monitoring GOL_OX3000 attachments (illuminator + dual modes).", false, false, true] spawn OKS_fnc_LogDebug;
