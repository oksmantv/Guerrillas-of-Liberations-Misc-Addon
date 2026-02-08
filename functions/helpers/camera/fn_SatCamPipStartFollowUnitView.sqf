/*
    OKS_fnc_SatCamPipStartFollowUnitView

    Starts a client-local PiP camera overlay that follows a unit's current view
    (memory point position + turret/vehicle direction). Automatically matches
    the unit's current zoom/FOV in real-time.

    Usage (client):
      [_unit, [_fov,_durationSec,_vehicleToStopOnExit,_verticalOffset]] call OKS_fnc_SatCamPipStartFollowUnitView;

    Params:
      0: Unit (OBJECT)
      1: Options ARRAY (optional)
         0 _fov (default 0.35, used as fallback if dynamic FOV unavailable)
         1 _durationSec (default -1 = until exit)
         2 _vehicleToStopOnExit (OBJECT, default vehicle player)
         3 _verticalOffset (NUMBER, meters to offset camera down from memory point, default 0)

        Note:
        - The global "OKS_SatCamPip_ForceOff" switch is reserved for the satellite PiP only.
        - FOV automatically syncs with unit's current zoom level (no manual controls needed)

    Notes:
    - Overlay defined in configs/CfgSatCamHUD.cpp (RscTitles: OKS_SatCamHUD)
    - Render target name: "OKS_SAT_PIP"
*/

if (!hasInterface) exitWith { objNull };

params [
    ["_unit", objNull, [objNull]],
    ["_opts", [], [[]]]
];

if (isNull _unit) exitWith { objNull };

// Debug mode check: if player is commander/gunner and debug is off, don't show camera
private _isDebugMode = missionNamespace getVariable ["GOL_VehicleCamera_Debug", false];
private _vehCheck = vehicle player;
if (!isNull _vehCheck && {_vehCheck != player}) then {
    if (player == commander _vehCheck || {player == gunner _vehCheck}) then {
        if (!_isDebugMode) exitWith {
            ["[Unit Cam] Debug mode OFF - camera disabled for commander/gunner"] spawn OKS_fnc_LogDebug;
            objNull
        };
        ["[Unit Cam] Debug mode ON - showing camera for commander/gunner"] spawn OKS_fnc_LogDebug;
    };
};

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
    [format ["[Unit Cam] Starting camera following unit: %1", name _unit]] spawn OKS_fnc_LogDebug;
};

[] call OKS_fnc_SatCamPipStop;

private _fov = _opts param [0, 0.35, [0]];
private _durationSec = _opts param [1, -1, [0]];
private _vehicleToStopOnExit = _opts param [2, objNull, [objNull]];
private _verticalOffset = _opts param [3, 0, [0]];

private _rtName = "OKS_SAT_PIP";

private _camForwardOffset = 0.8;

private _veh = vehicle _unit;

// Only works for units in vehicles
if (isNull _veh || {_veh == _unit}) exitWith { objNull };

private _eye = [0,0,0];
private _dir = [0,1,0];
private _mem = "";
private _turretPath = [];

private _role = assignedVehicleRole _unit;
private _roleType = if ((count _role) > 0) then { toLower (_role#0) } else { "" };

if (_roleType == "turret" && {(count _role) > 1}) then {
    _turretPath = _role#1;
    private _cfgTurret = [_veh, _turretPath] call BIS_fnc_turretConfig;
    if (!isNull _cfgTurret) then {
        _mem = getText (_cfgTurret >> "memoryPointGunnerOptics");
        if (_mem isEqualTo "") then { _mem = getText (_cfgTurret >> "memoryPointGun"); };
    };
} else {
    if (_unit isEqualTo driver _veh) then {
        _mem = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "memoryPointDriverOptics");
    };
};

if (_mem isNotEqualTo "") then {
    private _modelPos = _veh selectionPosition _mem;
    
    if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
        [format ["[Unit Cam] Memory point '%1' Z: %2, verticalOffset: %3", _mem, _modelPos#2, _verticalOffset]] spawn OKS_fnc_LogDebug;
    };
    
    // Apply vertical offset (lower the camera from memory point)
    if (_verticalOffset != 0) then {
        _modelPos set [2, (_modelPos#2) - _verticalOffset];
    };
    _eye = _veh modelToWorldVisualWorld _modelPos;
    
    // Get direction from memory point or turret
    if ((count _turretPath) > 0) then {
        private _angles = [_veh, _turretPath] call CBA_fnc_turretDir;
        if (_angles isEqualType [] && {(count _angles) >= 2}) then {
            private _v = ([1] + _angles) call CBA_fnc_polar2vect;
            if (_v isEqualType [] && {(count _v) == 3}) then {
                _dir = vectorNormalized _v;
            };
        };
    } else {
        private _vdu = _veh selectionVectorDirAndUp [_mem, "Memory"];
        private _dModel = _vdu param [0, [0,0,0], [[]]];
        if (!(_dModel isEqualTo [0,0,0])) then {
            _dir = vectorNormalized (_veh vectorModelToWorld _dModel);
        } else {
            _dir = vectorDirVisual _veh;
        };
    };
} else {
    // Fallback: use lower mid (25% height) and vehicle direction
    private _bb = boundingBoxReal _veh;
    private _h = (_bb#1#2) - (_bb#0#2);
    private _centerLowMid = [0, 0, (_bb#0#2) + (_h * 0.25)];
    _eye = _veh modelToWorldVisualWorld _centerLowMid;
    _dir = vectorDirVisual _veh;
};

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
    private _eyeATL = ASLToATL _eye;
    [format ["[Unit Cam] Camera created. Eye Z (ATL): %1m, Vertical offset: %2m", _eyeATL#2, _verticalOffset]] spawn OKS_fnc_LogDebug;
};

private _camera = "camera" camCreate (_eye vectorAdd (_dir vectorMultiply _camForwardOffset));
_camera camSetTarget (_eye vectorAdd (_dir vectorMultiply 2000));
_camera camSetFov _fov;
_camera camCommit 0;

_camera cameraEffect ["INTERNAL", "BACK", _rtName];
cutRsc ["OKS_SatCamHUD", "PLAIN", 0, false];

[{ 
    private _display = uiNamespace getVariable ["OKS_SatCamHUD_Display", displayNull];
    if (isNull _display) exitWith {};
    private _feed = _display displayCtrl 9511;
    if (isNull _feed) exitWith {};
    _feed ctrlSetText format ["#(argb,512,512,1)r2t(%1,1.0)", "OKS_SAT_PIP"];

    private _label = _display displayCtrl 9513;
    if (!isNull _label) then { _label ctrlSetText "UNIT VIEW"; };
    private _hint = _display displayCtrl 9514;
    if (!isNull _hint) then { _hint ctrlSetText "ESC to exit"; };
}] call CBA_fnc_execNextFrame;

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

// Fail safe: stop camera when player dismounts
if (!isNull _vehicleToStopOnExit) then {
    private _idGetOut = player addEventHandler ["GetOutMan", {
        params ["_unit", "_role", "_veh"];
        if (_veh isEqualTo _vehicleToStopOnExit) then {
            [] call OKS_fnc_SatCamPipStop;
        };
    }];
    _ehIds pushBack ["player", "GetOutMan", _idGetOut];
};

missionNamespace setVariable ["OKS_SatCamPip_EHs", _ehIds];

private _startT = diag_tickTime;
private _pfhId = [{
    params ["_args", "_pfhId"];
    _args params ["_camera", "_unit", "_fov", "_durationSec", "_startT", "_vehicleToStopOnExit", "_verticalOffset"];

    if (isNull _camera) exitWith { [_pfhId] call CBA_fnc_removePerFrameHandler; };

    // Fail safe: stop if player died or unconscious
    if (!alive player) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };
    if (isClass (configFile >> "CfgPatches" >> "ace_medical") && {player getVariable ["ACE_isUnconscious", false]}) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    if (isNull _unit || {!alive _unit}) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    if (!isNull _vehicleToStopOnExit && {vehicle player != _vehicleToStopOnExit}) exitWith {
        // Optional behavior: if caller provided a vehicle, stop when player leaves it.
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    // Safety: exit camera if local player becomes gunner/commander (took over main crew position)
    if (!isNull _vehicleToStopOnExit && {vehicle player == _vehicleToStopOnExit}) then {
        if (player == gunner _vehicleToStopOnExit || {player == commander _vehicleToStopOnExit}) exitWith {
            [] call OKS_fnc_SatCamPipStop;
            [_pfhId] call CBA_fnc_removePerFrameHandler;
        };
    };

    if (_durationSec > 0 && {(diag_tickTime - _startT) > _durationSec}) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    private _veh = vehicle _unit;
    
    // Exit if unit left vehicle
    if (isNull _veh || {_veh == _unit}) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    private _eye = [0,0,0];
    private _dir = [0,1,0];
    private _mem = "";
    private _turretPath = [];

    private _role = assignedVehicleRole _unit;
    private _roleType = if ((count _role) > 0) then { toLower (_role#0) } else { "" };
    
    if (_roleType == "turret" && {(count _role) > 1}) then {
        _turretPath = _role#1;
        private _cfgTurret = [_veh, _turretPath] call BIS_fnc_turretConfig;
        if (!isNull _cfgTurret) then {
            _mem = getText (_cfgTurret >> "memoryPointGunnerOptics");
            if (_mem isEqualTo "") then { _mem = getText (_cfgTurret >> "memoryPointGun"); };
        };
    } else {
        if (_unit isEqualTo driver _veh) then {
            _mem = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "memoryPointDriverOptics");
        };
    };
    
    if (_mem isNotEqualTo "") then {
        private _modelPos = _veh selectionPosition _mem;
        // Apply vertical offset (lower the camera from memory point)
        if (_verticalOffset != 0) then {
            _modelPos set [2, (_modelPos#2) - _verticalOffset];
        };
        _eye = _veh modelToWorldVisualWorld _modelPos;
        
        // Get direction from memory point or turret
        if ((count _turretPath) > 0) then {
            private _angles = [_veh, _turretPath] call CBA_fnc_turretDir;
            if (_angles isEqualType [] && {(count _angles) >= 2}) then {
                private _v = ([1] + _angles) call CBA_fnc_polar2vect;
                if (_v isEqualType [] && {(count _v) == 3}) then {
                    _dir = vectorNormalized _v;
                };
            };
        } else {
            private _vdu = _veh selectionVectorDirAndUp [_mem, "Memory"];
            private _dModel = _vdu param [0, [0,0,0], [[]]];
            if (!(_dModel isEqualTo [0,0,0])) then {
                _dir = vectorNormalized (_veh vectorModelToWorld _dModel);
            } else {
                _dir = vectorDirVisual _veh;
            };
        };
    } else {
        // Fallback: use lower mid (25% height) and vehicle direction
        private _bb = boundingBoxReal _veh;
        private _h = (_bb#1#2) - (_bb#0#2);
        private _centerLowMid = [0, 0, (_bb#0#2) + (_h * 0.25)];
        _eye = _veh modelToWorldVisualWorld _centerLowMid;
        _dir = vectorDirVisual _veh;
    };

    // Dynamic FOV: match unit's current optics zoom
    private _currentFov = _fov;
    
    // If we're the unit being followed, broadcast our FOV to the vehicle
    if (_unit == player && !isNull _veh && {_veh != _unit}) then {
        private _unitFov = getObjectFOV _unit;
        if (_unitFov > 0) then {
            _veh setVariable ["OKS_CommanderFOV", _unitFov, true]; // Network synced
            _currentFov = _unitFov;
            if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
                [format ["[Unit Cam] Broadcasting FOV: %1", _unitFov]] spawn OKS_fnc_LogDebug;
            };
        };
    } else {
        // We're cargo viewing commander - read their stored FOV
        if (!isNull _veh) then {
            private _storedFov = _veh getVariable ["OKS_CommanderFOV", -1];
            if (_storedFov > 0) then {
                _currentFov = _storedFov;
            };
        };
    };

    _camera camSetFov _currentFov;
    _camera camSetPos (_eye vectorAdd (_dir vectorMultiply 0.8));
    _camera camSetTarget (_eye vectorAdd (_dir vectorMultiply 2000));
    _camera camCommit 0;
}, 0, [_camera, _unit, _fov, _durationSec, _startT, _vehicleToStopOnExit, _verticalOffset]] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable ["OKS_SatCamPip_PFH", _pfhId];

_camera
