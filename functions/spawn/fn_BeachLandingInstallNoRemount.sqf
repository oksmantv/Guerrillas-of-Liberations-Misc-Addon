/*
    Function: OKS_fnc_BeachLandingInstallNoRemount

    Description:
        Installs a local GetInMan event handler on AI units that prevents them from
        re-boarding a specific boat vehicle after dismounting. Used internally by
        OKS_fnc_BeachLanding to ensure dismounted troops push inland rather than
        attempting to re-enter the landing craft. The handler is only installed once
        per unit; subsequent calls update the blocked boat reference. Player units
        are skipped. Must run where the units are local (server or HC).

    Parameters:
        0: _unitsOrGroup - ARRAY or GROUP - Units array or group to protect from re-mounting
        1: _boatVehicle  - OBJECT         - Boat vehicle to block re-entry into

    Returns:
        BOOLEAN - true on success, false if boat is null or no valid units provided

    Example:
        [units _dismountGroup, _boat] call OKS_fnc_BeachLandingInstallNoRemount;
        [_dismountGroup, _boat] call OKS_fnc_BeachLandingInstallNoRemount;
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
