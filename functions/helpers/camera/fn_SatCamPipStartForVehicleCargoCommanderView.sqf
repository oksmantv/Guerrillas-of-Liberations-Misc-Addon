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

// Always include commander/gunner in target list (they'll check debug setting client-side)
private _targetPlayers = _cargoPlayers;
private _cmdr = commander _vehicle;
private _gunner = gunner _vehicle;
if (!isNull _cmdr && {isPlayer _cmdr}) then {
    _targetPlayers pushBackUnique _cmdr;
};
if (!isNull _gunner && {isPlayer _gunner}) then {
    _targetPlayers pushBackUnique _gunner;
};

// Exit if no targets
if (_targetPlayers isEqualTo []) exitWith { false };

diag_log format ["[CargoCommanderView] Sending camera to %1 players (cargo + crew)", count _targetPlayers];

private _forwardOpts = +_opts;
// Ensure option index 2 is the vehicle so clients stop cam when leaving it.
if ((count _forwardOpts) < 3) then {
    _forwardOpts resize 3;
};
_forwardOpts set [2, _vehicle];

// Apply default vertical offset if not specified (lower camera from turret optics)
if ((count _forwardOpts) < 4 || {(_forwardOpts param [3, 0]) == 0}) then {
    if ((count _forwardOpts) < 4) then { _forwardOpts resize 4; };
    _forwardOpts set [3, 1.0]; // Default: lower camera 1.0m from memory point
};

[_commander, _forwardOpts] remoteExecCall ["OKS_fnc_SatCamPipStartFollowUnitView", _targetPlayers];
true
