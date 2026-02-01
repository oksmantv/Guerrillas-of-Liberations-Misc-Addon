/*
    OKS_fnc_SatCamPipStartForVehicleCargo

    Server helper: starts the PiP satellite camera for player units that are passengers (Cargo) in a vehicle.

    Usage (server):
      [_vehicle, _targetOrPos, _opts] call OKS_fnc_SatCamPipStartForVehicleCargo;

    _opts is forwarded to OKS_fnc_SatCamPipStart (client) with the vehicle injected as option index 7.
*/

if (!isServer) exitWith { false };

params [
    ["_vehicle", objNull, [objNull]],
    ["_target", objNull, [objNull, []]],
    ["_opts", [], [[]]]
];

if (isNull _vehicle) exitWith { false };

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
// Ensure option index 7 is the vehicle so clients stop cam when leaving it.
if ((count _forwardOpts) < 8) then {
    _forwardOpts resize 8;
};
_forwardOpts set [7, _vehicle];

[_target, _forwardOpts] remoteExecCall ["OKS_fnc_SatCamPipStart", _cargoPlayers];
true
