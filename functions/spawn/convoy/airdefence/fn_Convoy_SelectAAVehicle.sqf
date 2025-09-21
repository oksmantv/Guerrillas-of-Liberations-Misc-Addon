
/*
    OKS_fnc_Convoy_SelectAAVehicle
    Selects the best AA vehicle from a given array of vehicles.
    Usage: [_vehicleArray, _isConvoyDebugEnabled] call OKS_fnc_Convoy_SelectAAVehicle;
    Returns: AA vehicle object or objNull
*/

// OKS_fnc_Convoy_SelectAAVehicle
// Usage: [_vehicleArray, _nearestAirTarget] call OKS_fnc_Convoy_SelectAAVehicle;
params ["_vehicleArray", "_nearestAirTarget"];

private _isConvoyAADebug = missionNamespace getVariable ["GOL_Convoy_AA_Debug", false];

private _aaArray = [];
if ((count _vehicleArray) > 0) then {
    _aaArray = _vehicleArray select 0 getVariable ["OKS_Convoy_AAArray", []];
};

if ((count _aaArray) == 0) exitWith {
    if (_isConvoyAADebug) then {
        "[CONVOY_AA_SELECT] No AA vehicles found in dynamic AA array." spawn OKS_fnc_LogDebug;
    };
    objNull
};

private _closestAA = objNull;
private _minDist = 1e9;
{
    if (isNull _x || !alive _x || !canMove _x) then { continue };
    private _dist = _x distance _nearestAirTarget;
    if (_dist < _minDist) then {
        _minDist = _dist;
        _closestAA = _x;
    };
} forEach _aaArray;

if (_isConvoyAADebug) then {
    format [
        "[CONVOY_AIR] Closest AA: %1 (dist=%.1f) to target %2 from %3 dynamic AA candidates",
        typeOf _closestAA,
        _minDist,
        _nearestAirTarget,
        count _aaArray
    ] spawn OKS_fnc_LogDebug;
};

_closestAA;
