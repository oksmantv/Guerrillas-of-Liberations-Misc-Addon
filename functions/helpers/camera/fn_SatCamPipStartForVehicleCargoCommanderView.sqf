/*
    OKS_fnc_SatCamPipStartForVehicleCargoCommanderView

    Server helper: starts the PiP overlay for cargo players in a vehicle,
    using the vehicle commander's current view as the camera feed.

    Usage (server):
      [_vehicle, _opts] call OKS_fnc_SatCamPipStartForVehicleCargoCommanderView;

    _opts is forwarded to OKS_fnc_SatCamPipStartFollowUnitView (client)
    with the vehicle injected as option index 2.

        Note:
        - The global "OKS_SatCamPip_ForceOff" switch is reserved for the satellite PiP only.
*/

if (!isServer) exitWith { false };

params [
    ["_vehicle", objNull, [objNull]],
    ["_opts", [], [[]]]
];

if (isNull _vehicle) exitWith { false };

private _commander = commander _vehicle;
if (isNull _commander) then {
    // Fallbacks for vehicles without a commander seat.
    _commander = effectiveCommander _vehicle;
};
if (isNull _commander) then {
    _commander = driver _vehicle;
};

if (isNull _commander) exitWith { false };

private _cargoPlayers = (crew _vehicle) select {
    isPlayer _x
    && {alive _x}
    && {vehicle _x == _vehicle}
    && {
        private _r = assignedVehicleRole _x;
        (count _r) > 0 && {(toLower (_r#0)) == "cargo"}
    }
};

if (_cargoPlayers isEqualTo []) exitWith { false };

private _forwardOpts = +_opts;
// Ensure option index 2 is the vehicle so clients stop cam when leaving it.
if ((count _forwardOpts) < 3) then {
    _forwardOpts resize 3;
};
_forwardOpts set [2, _vehicle];

[_commander, _forwardOpts] remoteExecCall ["OKS_fnc_SatCamPipStartFollowUnitView", _cargoPlayers];
true
