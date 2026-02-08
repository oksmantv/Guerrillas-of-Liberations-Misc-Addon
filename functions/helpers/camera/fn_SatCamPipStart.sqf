/*
    OKS_fnc_SatCamPipStart

    Starts a client-local PiP satellite-style camera overlay.

    Usage (client):
        [_targetOrPos, [_height,_radius,_startDir,_rotateMode,_rotateDegPerSec,_fov,_durationSec,_vehicleToStopOnExit]] call OKS_fnc_SatCamPipStart;

    Params:
      0: target OR position (OBJECT or ARRAY [x,y,z?])
      1: options ARRAY (all optional)
         0 _height (m, default 180)
         1 _radius (m, default 0 = straight overhead)
         2 _startDir (deg, default 0)
         3 _rotateMode (-1 ccw, 0 fixed, 1 cw; default 0)
         4 _rotateDegPerSec (default 10)
         5 _fov (default 0.35)
         6 _durationSec (default -1 = until exit)
         7 _vehicleToStopOnExit (OBJECT, default vehicle player)

    Notes:
    - Overlay is defined in configs/CfgSatCamHUD.cpp (RscTitles: OKS_SatCamHUD)
    - Render target name: "OKS_SAT_PIP"
*/

if (!hasInterface) exitWith { objNull };

// Global force-off: when true, all clients stop/refuse the PiP cam.
if (missionNamespace getVariable ["OKS_SatCamPip_ForceOff", false]) exitWith { objNull };

params [
    ["_target", objNull, [objNull, []]],
    ["_opts", [], [[]]]
];

// Stop any existing session first.
[] call OKS_fnc_SatCamPipStop;

private _height = _opts param [0, 180, [0]];
private _radius = _opts param [1, 0, [0]];
private _startDir = _opts param [2, 0, [0]];
private _rotateMode = _opts param [3, 0, [0]];
private _rotateDegPerSec = _opts param [4, 10, [0]];
private _fov = _opts param [5, 0.35, [0]];
private _durationSec = _opts param [6, -1, [0]];
private _vehicleToStopOnExit = _opts param [7, vehicle player, [objNull]];

private _centerASL = [0,0,0];
if (_target isEqualType objNull) then {
    if (isNull _target) exitWith { objNull };
    _centerASL = getPosASLVisual _target;
} else {
    _centerASL = +_target;
    if ((count _centerASL) == 2) then { _centerASL pushBack 0; };
    // treat provided pos as ASL-ish; if it looks like ATL, that's on the caller.
};

private _angle = _startDir;
private _camPos2D = if (_radius <= 0) then {
    _centerASL
} else {
    private _p = _centerASL getPos [_radius, _angle];
    [_p#0, _p#1, _centerASL#2]
};

private _camPosASL = [_camPos2D#0, _camPos2D#1, (_centerASL#2) + _height];

private _camera = "camera" camCreate _camPosASL;
_camera camSetTarget (_centerASL vectorAdd [0,0,0]);
_camera camSetFov _fov;
_camera camCommit 0;

// Pipe the camera into a render target and show our overlay.
private _rtName = "OKS_SAT_PIP";
_camera cameraEffect ["INTERNAL", "BACK", _rtName];

cutRsc ["OKS_SatCamHUD", "PLAIN", 0, false];

// Populate the PiP texture onto the overlay control.
[{ 
    private _display = uiNamespace getVariable ["OKS_SatCamHUD_Display", displayNull];
    if (isNull _display) exitWith {};
    private _feed = _display displayCtrl 9511;
    if (isNull _feed) exitWith {};
    _feed ctrlSetText format ["#(argb,512,512,1)r2t(%1,1.0)", "OKS_SAT_PIP"];

    private _label = _display displayCtrl 9513;
    if (!isNull _label) then { _label ctrlSetText "SAT VIEW"; };
    private _hint = _display displayCtrl 9514;
    if (!isNull _hint) then { _hint ctrlSetText "ESC to exit"; };
}] call CBA_fnc_execNextFrame;

// Track state for stop/cleanup.
missionNamespace setVariable ["OKS_SatCamPip_Camera", _camera];

private _ehIds = [];
private _d46 = findDisplay 46;
if (!isNull _d46) then {
    private _idKey = _d46 displayAddEventHandler ["KeyDown", {
        // ESC stops
        params ["_disp", "_key"];
        if (_key == 1) then {
            [] call OKS_fnc_SatCamPipStop;
            true
        } else {
            false
        };
    }];
    _ehIds pushBack ["display46", "KeyDown", _idKey];
};

// Fail safe: stop camera when player dies
private _idKilled = player addEventHandler ["Killed", {
    [] call OKS_fnc_SatCamPipStop;
}];
_ehIds pushBack ["player", "Killed", _idKilled];

// Fail safe: stop camera when player becomes unconscious (ACE)
if (isClass (configFile >> "CfgPatches" >> "ace_medical")) then {
    private _idUnconscious = player addEventHandler ["HandleDamage", {
        if (player getVariable ["ACE_isUnconscious", false]) then {
            [] call OKS_fnc_SatCamPipStop;
        };
    }];
    _ehIds pushBack ["player", "HandleDamage", _idUnconscious];
};

// Fail safe: stop camera when player dismounts (if vehicleToStopOnExit was provided)
if (!isNull _vehicleToStopOnExit) then {
    private _idGetOut = player addEventHandler ["GetOutMan", {
        params ["_unit", "_role", "_vehicle"];
        [] call OKS_fnc_SatCamPipStop;
    }];
    _ehIds pushBack ["player", "GetOutMan", _idGetOut];
};

missionNamespace setVariable ["OKS_SatCamPip_EHs", _ehIds];

// Orbit / follow PFH
private _startT = diag_tickTime;
private _pfhId = [{
    params ["_args", "_pfhId"];
    _args params ["_camera", "_target", "_height", "_radius", "_rotateMode", "_rotateDegPerSec", "_durationSec", "_startT", "_angle", "_vehicleToStopOnExit"];

    if (isNull _camera) exitWith { [_pfhId] call CBA_fnc_removePerFrameHandler; };

    if (missionNamespace getVariable ["OKS_SatCamPip_ForceOff", false]) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    // Fail safe: stop if player died or unconscious
    if (!alive player) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };
    if (isClass (configFile >> "CfgPatches" >> "ace_medical") && {player getVariable ["ACE_isUnconscious", false]}) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    if (_durationSec > 0 && {(diag_tickTime - _startT) > _durationSec}) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    private _centerASL = [0,0,0];
    if (_target isEqualType objNull) then {
        if (isNull _target) exitWith { [] call OKS_fnc_SatCamPipStop; [_pfhId] call CBA_fnc_removePerFrameHandler; };
        _centerASL = getPosASLVisual _target;
    } else {
        _centerASL = +_target;
        if ((count _centerASL) == 2) then { _centerASL pushBack 0; };
    };

    private _dt = diag_deltaTime max 0;
    if (_rotateMode != 0 && _rotateDegPerSec > 0) then {
        _angle = _angle + (_rotateMode * _rotateDegPerSec * _dt);
    };

    private _cam2D = if (_radius <= 0) then {
        _centerASL
    } else {
        private _p = _centerASL getPos [_radius, _angle];
        [_p#0, _p#1, _centerASL#2]
    };

    _camera camSetTarget _centerASL;
    _camera camSetPos [_cam2D#0, _cam2D#1, (_centerASL#2) + _height];
    _camera camCommit 0;

    // write angle back
    _args set [8, _angle];
}, 0, [_camera, _target, _height, _radius, _rotateMode, _rotateDegPerSec, _durationSec, _startT, _angle, _vehicleToStopOnExit]] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable ["OKS_SatCamPip_PFH", _pfhId];

_camera
