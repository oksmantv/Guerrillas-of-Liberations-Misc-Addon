/*
    OKS_fnc_SatCamPipCycleVisionMode

    Cycles camera vision mode: Normal (0) -> Night Vision (1) -> Thermal (2) -> back to Normal
    Uses setPiPEffect on the render surface to apply the vision mode.

    Usage:
      [] call OKS_fnc_SatCamPipCycleVisionMode;
*/

if (!hasInterface) exitWith {};

private _camera = missionNamespace getVariable ["OKS_SatCamPip_Camera", objNull];
if (isNull _camera) exitWith {};

private _currentMode = missionNamespace getVariable ["OKS_SatCamPip_VisionMode", 0];
private _thermalEnabled = missionNamespace getVariable ["OKS_SatCamPip_ThermalEnabled", false];
private _maxModes = if (_thermalEnabled) then { 3 } else { 2 };
private _newMode = (_currentMode + 1) mod _maxModes;
missionNamespace setVariable ["OKS_SatCamPip_VisionMode", _newMode];

// setPiPEffect params: 0 = Normal, 1 = NV, 2 = Thermal (white-hot)
"OKS_SAT_PIP" setPiPEffect [_newMode];

private _modeNames = ["NORMAL", "NIGHT VISION", "THERMAL"];
systemChat format ["Camera: %1", _modeNames select _newMode];
