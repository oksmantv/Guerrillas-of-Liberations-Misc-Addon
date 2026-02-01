/*
    OKS_fnc_SatCamPipStartFollowUnitView

    Starts a client-local PiP camera overlay that follows a unit's current view
    (eyePos + eyeDirection). Useful for "commander view" sharing to cargo, or
    user-selected UAV/gunner POV feeds.

    Usage (client):
      [_unit, [_fov,_durationSec,_vehicleToStopOnExit]] call OKS_fnc_SatCamPipStartFollowUnitView;

    Params:
      0: Unit (OBJECT)
      1: Options ARRAY (optional)
         0 _fov (default 0.35)
         1 _durationSec (default -1 = until exit)
         2 _vehicleToStopOnExit (OBJECT, default vehicle player)

        Note:
        - The global "OKS_SatCamPip_ForceOff" switch is reserved for the satellite PiP only.

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

[] call OKS_fnc_SatCamPipStop;

private _fov = _opts param [0, 0.35, [0]];
private _durationSec = _opts param [1, -1, [0]];
private _vehicleToStopOnExit = _opts param [2, objNull, [objNull]];

private _rtName = "OKS_SAT_PIP";

private _camForwardOffset = 0.8;

private _eye = eyePos _unit;
private _dir = eyeDirection _unit;

// If the unit is in a vehicle, try to anchor to the optics memory point to avoid clipping.
private _veh = vehicle _unit;
if (!isNull _veh && {_veh != _unit}) then {
    private _role = assignedVehicleRole _unit;
    private _roleType = if ((count _role) > 0) then { toLower (_role#0) } else { "" };
    private _mem = "";
    if (_roleType == "turret" && {(count _role) > 1}) then {
        private _path = _role#1;
        private _cfgTurret = [_veh, _path] call BIS_fnc_turretConfig;
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
        _eye = _veh modelToWorldVisualWorld _modelPos;
    };
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

missionNamespace setVariable ["OKS_SatCamPip_EHs", _ehIds];

private _startT = diag_tickTime;
private _pfhId = [{
    params ["_args", "_pfhId"];
    _args params ["_camera", "_unit", "_fov", "_durationSec", "_startT", "_vehicleToStopOnExit"];

    if (isNull _camera) exitWith { [_pfhId] call CBA_fnc_removePerFrameHandler; };

    if (isNull _unit || {!alive _unit}) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    if (!isNull _vehicleToStopOnExit && {vehicle player != _vehicleToStopOnExit}) exitWith {
        // Optional behavior: if caller provided a vehicle, stop when player leaves it.
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    if (_durationSec > 0 && {(diag_tickTime - _startT) > _durationSec}) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    private _eye = eyePos _unit;
    private _dir = eyeDirection _unit;

    private _veh = vehicle _unit;
    if (!isNull _veh && {_veh != _unit}) then {
        private _role = assignedVehicleRole _unit;
        private _roleType = if ((count _role) > 0) then { toLower (_role#0) } else { "" };
        private _mem = "";
        if (_roleType == "turret" && {(count _role) > 1}) then {
            private _path = _role#1;
            private _cfgTurret = [_veh, _path] call BIS_fnc_turretConfig;
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
            _eye = _veh modelToWorldVisualWorld _modelPos;
        };
    };

    _camera camSetFov _fov;
    _camera camSetPos (_eye vectorAdd (_dir vectorMultiply 0.8));
    _camera camSetTarget (_eye vectorAdd (_dir vectorMultiply 2000));
    _camera camCommit 0;
}, 0, [_camera, _unit, _fov, _durationSec, _startT, _vehicleToStopOnExit]] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable ["OKS_SatCamPip_PFH", _pfhId];

_camera
