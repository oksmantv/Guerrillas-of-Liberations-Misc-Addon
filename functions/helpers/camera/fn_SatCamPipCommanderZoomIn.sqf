/*
    OKS_fnc_SatCamPipCommanderZoomIn

    Commander/gunner PiP only: steps the PiP zoom one level closer.

    Zoom is implemented by adjusting camera FOV through a small set of discrete levels.
    Levels are configured at start of OKS_fnc_SatCamPipStartFollowVehicleCommanderView.

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
private _max = (count _levels) - 1;
_idx = (_idx + 1) min _max;

missionNamespace setVariable ["OKS_SatCamPip_CommanderZoomIndex", _idx];

private _fov = _levels#_idx;
missionNamespace setVariable ["OKS_SatCamPip_CommanderFov", _fov];

_camera camSetFov _fov;
_camera camCommit 0;

private _display = uiNamespace getVariable ["OKS_SatCamHUD_Display", displayNull];
if (!isNull _display) then {
    private _hint = _display displayCtrl 9514;
    if (!isNull _hint) then {
        _hint ctrlSetText format ["ESC to exit | Zoom %1/%2", _idx + 1, _max + 1];
    };
};

true
