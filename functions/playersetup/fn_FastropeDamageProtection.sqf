/*
 * fn_FastropeDamageProtection.sqf
 *
 * Description:
 *     Simple and effective fastrope damage protection using invincibility.
 *     Makes unit invulnerable during fastrope animation and for a short period after.
 *
 * Parameters:
 *     _unit - The unit to protect [OBJECT]
 *
 * Return Value:
 *     Success [BOOLEAN]
 *
 * Example:
 *     [player] call OKS_fnc_FastropeDamageProtection;
 *
 * Author: OKS Team
 */

params ["_unit"];

if (isNull _unit || !alive _unit) exitWith {
    "[FASTROPE-PROTECTION] Invalid or dead unit provided" spawn OKS_fnc_LogDebug;
    false
};

// Get debug setting
private _debug = missionNamespace getVariable ["GOL_FastropeDamage_Debug", false];

if (_debug) then {
    format["[FASTROPE-PROTECTION] Setting up protection for: %1", name _unit] spawn OKS_fnc_LogDebug;
};

// Initialize protection variables
_unit setVariable ["OKS_FastropeProtectionTime", 0];
_unit setVariable ["OKS_WasFastroping", false];

// Main protection monitoring
[_unit] spawn {
    params ["_unit"];
    
    private _wasInvincible = false;
    
    while {alive _unit} do {
        sleep 0.1; // Check every 100ms
        
        private _debug = missionNamespace getVariable ["GOL_FastropeDamage_Debug", false];
        private _animationState = animationState _unit;
        private _currentTime = time;
        private _protectionDuration = missionNamespace getVariable ["GOL_FastropeDamage_ProtectionDuration", 3];
        
        // Check if currently fastroping
        if (_animationState == "ACE_FastRoping") then {
            _unit setVariable ["OKS_FastropeProtectionTime", _currentTime + _protectionDuration];
            _unit setVariable ["OKS_WasFastroping", true];
        };
        
        // Check if we should be protected
        private _protectionEndTime = _unit getVariable ["OKS_FastropeProtectionTime", 0];
        private _wasFastroping = _unit getVariable ["OKS_WasFastroping", false];
        private _shouldProtect = (_wasFastroping && _currentTime <= _protectionEndTime);
        
        // Enable/disable invincibility as needed
        if (_shouldProtect && !_wasInvincible) then {
            _unit allowDamage false;
            _wasInvincible = true;
            
            if (_debug) then {
                format["[FASTROPE-PROTECTION] Enabled invincibility for %1", name _unit] spawn OKS_fnc_LogDebug;
            };
            
        } else {
            if (!_shouldProtect && _wasInvincible) then {
                _unit allowDamage true;
                _wasInvincible = false;
                
                if (_debug) then {
                    format["[FASTROPE-PROTECTION] Disabled invincibility for %1", name _unit] spawn OKS_fnc_LogDebug;
                };
                
                // Clear variables and exit monitoring
                _unit setVariable ["OKS_WasFastroping", false];
                _unit setVariable ["OKS_FastropeProtectionTime", 0];
                
                if (_debug) then {
                    format["[FASTROPE-PROTECTION] Protection ended for %1", name _unit] spawn OKS_fnc_LogDebug;
                };
                break;
            };
        };
    };
    
    // Cleanup on exit
    if (!isNull _unit) then {
        _unit allowDamage true;
        _unit setVariable ["OKS_WasFastroping", false];
        _unit setVariable ["OKS_FastropeProtectionTime", 0];
    };
};

if (_debug) then {
    format["[FASTROPE-PROTECTION] Protection monitoring started for %1", name _unit] spawn OKS_fnc_LogDebug;
};

true