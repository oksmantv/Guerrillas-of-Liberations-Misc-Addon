/*
    OKS_fnc_SatCamPipStop

    Stops and cleans up the PiP satellite camera overlay.
*/

if (!hasInterface) exitWith {};

private _pfhId = missionNamespace getVariable ["OKS_SatCamPip_PFH", -1];
if (_pfhId isNotEqualTo -1) then {
    [_pfhId] call CBA_fnc_removePerFrameHandler;
    missionNamespace setVariable ["OKS_SatCamPip_PFH", -1];
};

private _ehs = missionNamespace getVariable ["OKS_SatCamPip_EHs", []];
{
    _x params ["_who", "_type", "_id"];
    switch (_who) do {
        case "display46": {
            private _d46 = findDisplay 46;
            if (!isNull _d46) then {
                _d46 displayRemoveEventHandler [_type, _id];
            };
        };
        case "player": {
            player removeEventHandler [_type, _id];
        };
        case "cba": {
            [_type, _id] call CBA_fnc_removeEventHandler;
        };
    };
} forEach _ehs;
missionNamespace setVariable ["OKS_SatCamPip_EHs", []];

private _camera = missionNamespace getVariable ["OKS_SatCamPip_Camera", objNull];
missionNamespace setVariable ["OKS_SatCamPip_Camera", objNull];

// Save rear camera pivot for this vehicle class (persisted to profileNamespace)
private _rearClass = missionNamespace getVariable ["OKS_SatCamPip_RearVehicleClass", ""];
if (_rearClass isNotEqualTo "") then {
    private _pitch = missionNamespace getVariable ["OKS_SatCamPip_RearPitchDeg", 0];
    private _yaw   = missionNamespace getVariable ["OKS_SatCamPip_RearYawDeg", 0];
    private _pivots = profileNamespace getVariable ["OKS_SatCamPip_RearPivots", createHashMap];
    _pivots set [_rearClass, [_pitch, _yaw]];
    profileNamespace setVariable ["OKS_SatCamPip_RearPivots", _pivots];
    saveProfileNamespace;
    missionNamespace setVariable ["OKS_SatCamPip_RearVehicleClass", ""];
};

// Clear mode-specific state
missionNamespace setVariable ["OKS_SatCamPip_Mode", ""];
missionNamespace setVariable ["OKS_SatCamPip_CommanderZoomLevels", nil];
missionNamespace setVariable ["OKS_SatCamPip_CommanderZoomIndex", nil];
missionNamespace setVariable ["OKS_SatCamPip_CommanderFov", nil];
missionNamespace setVariable ["OKS_SatCamPip_RearPitchDeg", 0];
missionNamespace setVariable ["OKS_SatCamPip_RearYawDeg", 0];

// Remove overlay
cutText ["", "PLAIN"]; 
uiNamespace setVariable ["OKS_SatCamHUD_Display", displayNull];

if (!isNull _camera) then {
    "OKS_SAT_PIP" setPiPEffect [0];
    _camera cameraEffect ["terminate", "back"];
    camDestroy _camera;
};
