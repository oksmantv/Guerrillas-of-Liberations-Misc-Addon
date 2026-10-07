/*
    Debug test function for IR Illuminator system.
    
    Call from debug console to test all components.
    
    Usage:
    [] call OKS_fnc_IRIlluminator_DebugTest;
*/

systemChat "=== IR Illuminator Debug Test ===";

// Check if interface exists
systemChat format ["1. Has Interface: %1", hasInterface];

// Check if functions exist
systemChat format ["2. AdjustStrength exists: %1", !isNil "OKS_fnc_IRIlluminator_AdjustStrength"];
systemChat format ["3. InitMouseWheel exists: %1", !isNil "OKS_fnc_IRIlluminator_InitMouseWheel"];

// Check initialization state
systemChat format ["4. MouseWheel Initialized: %1", missionNamespace getVariable ["OKS_IRIlluminator_MouseWheel_Initialized", false]];
systemChat format ["5. MouseWheel Handler ID: %1", missionNamespace getVariable ["OKS_IRIlluminator_MouseWheel_HandlerID", -1]];

// Check system enabled
systemChat format ["6. System Enabled: %1", missionNamespace getVariable ["GOL_IRIlluminator_Enabled", true]];
systemChat format ["7. Debug Mode: %1", missionNamespace getVariable ["GOL_IRIlluminator_Debug", false]];

// Check player state
systemChat format ["8. Player exists: %1", !isNull player];
systemChat format ["9. Current weapon: %1", currentWeapon player];

// Check weapon accessories
private _weapon = currentWeapon player;
private _accessories = [];
if (_weapon != "") then {
    _accessories = switch (_weapon) do {
        case (primaryWeapon player): { primaryWeaponItems player };
        case (handgunWeapon player): { handgunItems player };
        case (secondaryWeapon player): { secondaryWeaponItems player };
        default { [] };
    };
};
systemChat format ["10. Flashlight item: %1", _accessories param [1, "NONE"]];

// Check if GOL illuminator
private _flashlightItem = _accessories param [1, ""];
private _isGOL = (_flashlightItem find "GOL_OX3000") > -1;
systemChat format ["11. Is GOL Illuminator: %1", _isGOL];

// Check current strength
private _strength = player getVariable ["GOL_IRIlluminator_Strength", 1];
systemChat format ["12. Current Strength: %1%%", _strength];

// Check display
private _display = findDisplay 46;
systemChat format ["13. Display 46 exists: %1", !isNull _display];

// Check keyboard state
private _keyState = keyboardGetState;
private _leftCtrl = _keyState select 29;
private _rightCtrl = _keyState select 157;
systemChat format ["14. Ctrl keys - Left: %1, Right: %2", _leftCtrl, _rightCtrl];

// Test adjustment function
systemChat "15. Testing AdjustStrength function...";
private _testResult = true call OKS_fnc_IRIlluminator_AdjustStrength;
systemChat format ["16. AdjustStrength returned: %1", _testResult];

// Check if CBA exists
systemChat format ["17. CBA loaded: %1", isClass (configFile >> "CfgPatches" >> "cba_main")];

systemChat "=== End Debug Test ===";

true
