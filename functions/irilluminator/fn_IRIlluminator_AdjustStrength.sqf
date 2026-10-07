/*
    Adjust IR illuminator strength for local player.
    
    Parameters:
    0: BOOL - True to increase, False to decrease
    
    Returns:
    NUMBER - New strength percentage (2.5-100)
    
    Example:
    true call OKS_fnc_IRIlluminator_AdjustStrength; // Increase (2.5→5→15→25→50→100)
    false call OKS_fnc_IRIlluminator_AdjustStrength; // Decrease (100→50→25→15→5→2.5)
*/

if (!hasInterface) exitWith { 
    ["[IR Illuminator] AdjustStrength: No interface", false, false, true] spawn OKS_fnc_LogDebug;
    0 
};

// Only allow adjustment when on foot
if (vehicle player != player) exitWith { player getVariable ["GOL_IRIlluminator_Strength", 1] };

// Only allow adjustment when in NVG/IR mode (prevents conflicts with other keybinds like ACE speed limiter)
if (currentVisionMode player != 1) exitWith { player getVariable ["GOL_IRIlluminator_Strength", 1] };

// Only allow adjustment when holding primary weapon with a GOL illuminator attached
if (currentWeapon player != primaryWeapon player) exitWith { player getVariable ["GOL_IRIlluminator_Strength", 1] };
private _flashlightItem = (primaryWeaponItems player) param [1, ""];
if !(_flashlightItem in ["GOL_OX3000", "GOL_OX3000_LR", "GOL_OX3000_II", "GOL_OX3000_LR_II"]) exitWith { player getVariable ["GOL_IRIlluminator_Strength", 1] };

params [
    ["_increase", true, [true]]
];

private _debugEnabled = missionNamespace getVariable ["GOL_IRIlluminator_Debug", false];
if (_debugEnabled) then {
    systemChat format ["[IR Illuminator] AdjustStrength: Called with increase=%1", _increase];
};
[format ["[IR Illuminator] AdjustStrength: Called with increase=%1", _increase], false, false, true] spawn OKS_fnc_LogDebug;

// Throttle to prevent network spam (max 1 update per 0.2 seconds)
private _lastUpdate = missionNamespace getVariable ["GOL_IRIlluminator_LastUpdate", -999];
private _timeSinceUpdate = CBA_missionTime - _lastUpdate;

if (_timeSinceUpdate < 0.2) exitWith {
    if (_debugEnabled) then {
        systemChat "[IR Illuminator] AdjustStrength: Throttled (too soon)";
    };
    player getVariable ["GOL_IRIlluminator_Strength", 1]
};
missionNamespace setVariable ["GOL_IRIlluminator_LastUpdate", CBA_missionTime];

// Get current strength (default 1% - minimum)
private _currentStrength = player getVariable ["GOL_IRIlluminator_Strength", 1];
if (_debugEnabled) then {
    systemChat format ["[IR Illuminator] AdjustStrength: Current strength: %1%%", _currentStrength];
};

// Strength levels with descriptive names (conditionally add extended levels)
private _extendedEnabled = missionNamespace getVariable ["GOL_IRIlluminator_ExtendedStrength", false];
private _strengthLevels = if (_extendedEnabled) then {
    [1, 1.5, 2, 2.5, 3]  // Extended levels for dark/stealth missions
} else {
    [1, 1.5, 2]  // Standard levels
};
private _strengthNames = if (_extendedEnabled) then {
    ["Low", "Medium", "High", "Very High", "Maximum"]
} else {
    ["Low", "Medium", "High"]
};
private _currentIndex = _strengthLevels find _currentStrength;

// If current strength not in array, find closest
if (_currentIndex == -1) then {
    _currentIndex = 0;
    {
        if (_currentStrength <= _x) exitWith { _currentIndex = _forEachIndex; };
    } forEach _strengthLevels;
};

private _newStrength = if (_increase) then {
    private _nextIndex = (_currentIndex + 1) min ((count _strengthLevels) - 1);
    _strengthLevels select _nextIndex
} else {
    private _prevIndex = (_currentIndex - 1) max 0;
    _strengthLevels select _prevIndex
};

if (_debugEnabled) then {
    systemChat format ["[IR Illuminator] AdjustStrength: New strength: %1%%", _newStrength];
};
[format ["[IR Illuminator] AdjustStrength: New strength: %1%%", _newStrength], false, false, true] spawn OKS_fnc_LogDebug;

// Only update if changed
if (_newStrength != _currentStrength) then {
    if (_debugEnabled) then {
        systemChat "[IR Illuminator] AdjustStrength: Strength changed, updating...";
    };
    ["[IR Illuminator] AdjustStrength: Strength changed, updating...", false, false, true] spawn OKS_fnc_LogDebug;
    
    // Set variable with public flag for multiplayer sync
    // This automatically syncs through server to all clients
    player setVariable ["GOL_IRIlluminator_Strength", _newStrength, true];
    
    // Store in profile for persistence across respawns
    profileNamespace setVariable ["GOL_IRIlluminator_Strength", _newStrength];
    
    // Play click sound
    playSound "ClickSoft";
    
    // Get current weapon to determine which image to show
    private _weapon = currentWeapon player;
    private _accessories = switch (_weapon) do {
        case (primaryWeapon player): { primaryWeaponItems player };
        case (handgunWeapon player): { handgunItems player };
        case (secondaryWeapon player): { secondaryWeaponItems player };
        default { [] };
    };
    private _flashlightItem = _accessories param [1, ""];
    
    // Determine model image and name
    private _modelImage = "\A3\weapons_F\Data\UI\gear_accv_pointer_CA.paa";
    private _modelName = "IR Illuminator";
    if (_flashlightItem in ["GOL_OX3000", "GOL_OX3000_LR"]) then {
        _modelName = "Dual Mode";
    } else {
        if (_flashlightItem in ["GOL_OX3000_II", "GOL_OX3000_LR_II"]) then {
            _modelName = "IR Illuminator";
        };
    };
    
    // Get strength name
    private _strengthIndex = _strengthLevels find _newStrength;
    private _strengthName = if (_strengthIndex >= 0) then {
        _strengthNames select _strengthIndex
    } else {
        "Custom"
    };
    
    // Show hint if enabled (local setting)
    private _showHint = missionNamespace getVariable ["GOL_IRIlluminator_ShowHint", true];
    if (_showHint) then {
        private _hintText = format [
            "<t align='center'><img image='%1' size='2'/><br/>" +
            "<t size='1.5' font='PuristaBold' color='#FFFFFF'>%2</t><br/>" +
            "<t size='1.2' color='#FFFFFF'>%3</t></t>",
            _modelImage,
            _modelName,
            _strengthName
        ];
        
        hintSilent parseText _hintText;
        
        // Clear hint after 3.5 seconds (longer for better visibility)
        [{ hintSilent ""; }, [], 3.5] call CBA_fnc_waitAndExecute;
    };
    
    // Force monitor to recreate light with new strength
    missionNamespace setVariable ["GOL_IRIlluminator_ForceUpdate", true];
    
    [format ["[IR Illuminator] Strength adjusted to %1%%", _newStrength], false, false, true] spawn OKS_fnc_LogDebug;
} else {
    if (_debugEnabled) then {
        systemChat "[IR Illuminator] AdjustStrength: No change (already at min/max)";
    };
};

_newStrength
