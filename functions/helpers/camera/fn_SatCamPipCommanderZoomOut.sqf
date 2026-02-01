/*
    OKS_fnc_SatCamPipCommanderZoomOut

    Commander/gunner PiP only: steps the PiP zoom one level wider.

    Returns:
      BOOL - true if applied, false otherwise.
*/

if (!hasInterface) exitWith { false };

if ((missionNamespace getVariable ["OKS_SatCamPip_Mode", ""]) != "commander") exitWith { false };

private _camera = missionNamespace getVariable ["OKS_SatCamPip_Camera", objNull];
if (isNull _camera) exitWith { false };

private _levels = missionNamespace getVariable ["OKS_SatCamPip_CommanderZoomLevels", []];
if (_levels isEqualTo [] || {(count _levels) < 2}) exitWith { false };

private _idx = missionNamespace getVariable ["OKS_SatCamPip_CommanderZoomIndex", 0];
_idx = (_idx - 1) max 0;

missionNamespace setVariable ["OKS_SatCamPip_CommanderZoomIndex", _idx];

private _fov = _levels#_idx;
missionNamespace setVariable ["OKS_SatCamPip_CommanderFov", _fov];

_camera camSetFov _fov;
_camera camCommit 0;

private _display = uiNamespace getVariable ["OKS_SatCamHUD_Display", displayNull];
if (!isNull _display) then {
    private _hint = _display displayCtrl 9514;
    if (!isNull _hint) then {
        _hint ctrlSetText format ["ESC to exit | Zoom %1/%2", _idx + 1, (count _levels)];
    };
};

true
