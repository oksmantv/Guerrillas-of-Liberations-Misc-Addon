/*
    OKS_fnc_SatCamPipToggleCommanderView

    Client keybind helper: toggles a PiP camera feed that follows the current
    vehicle commander's view.

    Behavior:
    - If any PiP session is running, toggling stops it.
    - If on-foot, does nothing.
    - If vehicle has no commander seat, falls back to effectiveCommander, then driver, then gunner.

        Note:
        - The global "OKS_SatCamPip_ForceOff" switch is reserved for the satellite PiP only.
*/

if (!hasInterface) exitWith { false };

// Toggle: if already running, stop.
private _pfhId = missionNamespace getVariable ["OKS_SatCamPip_PFH", -1];
private _cam = missionNamespace getVariable ["OKS_SatCamPip_Camera", objNull];
if (_pfhId isNotEqualTo -1 || {!isNull _cam}) exitWith {
    [] call OKS_fnc_SatCamPipStop;
    true
};

private _veh = vehicle player;
if (_veh isEqualTo player) exitWith { false };

// Land vehicles only (avoid accidental activation for pilots/aircraft/boats).
if !(_veh isKindOf "LandVehicle") exitWith { false };

// Driver gets a dedicated rear camera.
if (player isEqualTo driver _veh) exitWith {
    [_veh, [0.35, -1]] call OKS_fnc_SatCamPipStartVehicleDriverReverse;
    true
};

// Block gunner/commander.
if (player isEqualTo gunner _veh) exitWith { false };
if (player isEqualTo commander _veh) exitWith { false };

// Start commander-view PiP for this vehicle.
// No automatic stop on leaving seat/vehicle; only ESC or toggling off.
if ((count (allTurrets [_veh, true])) == 0) exitWith { false };
[_veh, [0.35, -1]] call OKS_fnc_SatCamPipStartFollowVehicleCommanderView;
true
