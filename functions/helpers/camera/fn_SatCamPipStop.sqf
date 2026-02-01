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
    };
} forEach _ehs;
missionNamespace setVariable ["OKS_SatCamPip_EHs", []];

private _camera = missionNamespace getVariable ["OKS_SatCamPip_Camera", objNull];
missionNamespace setVariable ["OKS_SatCamPip_Camera", objNull];

// Clear mode-specific state
missionNamespace setVariable ["OKS_SatCamPip_Mode", ""];
missionNamespace setVariable ["OKS_SatCamPip_CommanderZoomLevels", nil];
missionNamespace setVariable ["OKS_SatCamPip_CommanderZoomIndex", nil];
missionNamespace setVariable ["OKS_SatCamPip_CommanderFov", nil];

// Remove overlay
cutText ["", "PLAIN"]; 
uiNamespace setVariable ["OKS_SatCamHUD_Display", displayNull];

if (!isNull _camera) then {
    _camera cameraEffect ["terminate", "back"];
    camDestroy _camera;
};
