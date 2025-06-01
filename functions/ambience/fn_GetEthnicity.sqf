// File: fn_GetEthnicity.sqf
/*
    [unit] call OKS_fnc_GetEthnicity;
*/

params [
    ["_unit", objNull, [objNull]]
];

private _ethnicity = "middleeast"; // Default fallback
private _faceswapDebug = missionNamespace getVariable ["GOL_FaceSwap_Debug", false];

// Check if unit is valid and has a group
if (isNull _unit || isNull (group _unit)) exitWith {
    if(_faceswapDebug) then {
        "[DEBUG] FaceSwap: Unit or group is null, using default ethnicity." remoteExec ["systemChat",0];;
    };
    _ethnicity
};

switch (side (group _unit)) do {
    case west: { 
        _ethnicity = ["GOL_FaceSwap_BLUFOR"] call CBA_settings_fnc_get;
    };
    case east: { 
        _ethnicity = ["GOL_FaceSwap_OPFOR"] call CBA_settings_fnc_get;    
    };
    case independent: { 
        _ethnicity = ["GOL_FaceSwap_INDEPENDENT"] call CBA_settings_fnc_get;
    };
    case civilian: { 
        _ethnicity = ["GOL_FaceSwap_CIVILIAN"] call CBA_settings_fnc_get;
    };                           
    default {
        if(_faceswapDebug) then {
            format ["[DEBUG] FaceSwap: Failed to identify unit's side (%1), using default ethnicity.", side (group _unit)] remoteExec ["systemChat",0];;
        };
    };
};

_ethnicity   
