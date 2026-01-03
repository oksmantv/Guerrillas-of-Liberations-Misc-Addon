/*
    OKS_fnc_BeachLandingInstallNoRemount

    Installs a local GetInMan handler on AI units to prevent them from re-boarding
    the beach landing boat after dismount.

    Must run where the units are local (server/HC).

    Params:
      0: ARRAY or GROUP - units or group to protect
      1: OBJECT        - boat vehicle to block

    Returns:
      BOOL
*/

params [
    ["_unitsOrGroup", [], [[], grpNull]],
    ["_boatVehicle", objNull, [objNull]]
];

if (isNull _boatVehicle) exitWith { false };

private _units = if (_unitsOrGroup isEqualType grpNull) then { units _unitsOrGroup } else { _unitsOrGroup };
if (_units isEqualTo []) exitWith { false };

{
    private _unit = _x;
    if (isNull _unit) then { continue; };
    if (!alive _unit) then { continue; };
    if (isPlayer _unit) then { continue; };

    // Only install once.
    if (!isNil { _unit getVariable "OKS_BeachLanding_NoRemount_EH" }) then {
        _unit setVariable ["OKS_BeachLanding_BlockedBoat", _boatVehicle, false];
    } else {
        _unit setVariable ["OKS_BeachLanding_BlockedBoat", _boatVehicle, false];

        private _ehId = _unit addEventHandler ["GetInMan", {
            params ["_u", "_role", "_veh", "_turret"];
            private _blocked = _u getVariable ["OKS_BeachLanding_BlockedBoat", objNull];
            if (!isNull _blocked && {_veh == _blocked}) then {
                moveOut _u;
                unassignVehicle _u;
                [_u] orderGetIn false;
            };
        }];

        _unit setVariable ["OKS_BeachLanding_NoRemount_EH", _ehId, false];
    };
} forEach _units;

true;
