// File: fn_GetEthnicity.sqf
/*
    [unit] call OKS_fnc_GetEthnicity;
*/

params [
    ["_unit", objNull, [objNull]],
    ["_Side", sideUnknown, [sideUnknown]]
];

if(hasInterface && !isServer) exitWith {};

private _ethnicity = "middleeast"; // Default fallback
private _faceswapDebug = missionNamespace getVariable ["GOL_FaceSwap_Debug", false];
If(_Side isEqualTo sideUnknown) then {
    if(_faceswapDebug) then {
        "[FaceSwap] ForceSide is unknown, fallback to default" spawn OKS_fnc_LogDebug;
    };

    _Side = side (group _unit);
};

// Check if unit is valid and has a group
if (isNull _unit || isNull (group _unit)) exitWith {
    if(_faceswapDebug) then {
        "FaceSwap: Unit or group is null, using default ethnicity." spawn OKS_fnc_LogDebug;
    };
    _ethnicity
};

switch (_Side) do {
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
            format ["FaceSwap: Failed to identify unit's side (%1), using default ethnicity.", side (group _unit)] spawn OKS_fnc_LogDebug;
        };
    };
};

_ethnicity   
