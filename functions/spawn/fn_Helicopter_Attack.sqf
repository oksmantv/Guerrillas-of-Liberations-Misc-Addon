/*
    Function: OKS_fnc_Helicopter_Attack

    Description:
        Spawns a crewed attack helicopter at 150m altitude, assigns it an SAD (Search
        and Destroy) waypoint at a target position, and reveals nearby enemy units to
        the crew within the specified range. The helicopter is set to COMBAT behaviour
        with RED combat mode for immediate engagement. The crew is created via
        OKS_fnc_AddVehicleCrew and the vehicle is locked to prevent player boarding.
        Useful for scripting helicopter CAS attacks against known enemy positions.

    Parameters:
        0: _spawn     - OBJECT - Spawn position object (helicopter appears at 150m above it)
        1: _waypoint  - OBJECT - Target waypoint object (SAD waypoint destination)
        2: _side      - SIDE   - Faction side for the crew (default: east)
        3: _classname - STRING - Helicopter classname (e.g. "RHS_AH64DGrey")
        4: _range     - NUMBER - Reveal radius in meters; enemy units within this range of the waypoint are revealed to the crew (default: 500)

    Returns:
        Nothing

    Example:
        [attackheli_1, attacktarget_1, west, "RHS_AH64DGrey", 500] spawn OKS_fnc_Helicopter_Attack;
*/

if (!isServer) exitWith {};

params [
    ["_spawn", objNull, [objNull]],
    ["_waypoint", objNull, [objNull]],
    ["_side", east, [sideUnknown]],
    ["_classname", "", [""]],
    ["_range", 500, [0]]
];

if (isNull _spawn || {isNull _waypoint}) exitWith {};

private _vehicle = createVehicle [_classname, [getPos _spawn#0, getPos _spawn#1, 150], [], 0, "FLY"];
_vehicle setDir (getDir _spawn);
_vehicle flyInHeight 125;
_vehicle setVehicleLock "LOCKED";

private _group = [_vehicle, _side, 0] call OKS_fnc_AddVehicleCrew;

_group setBehaviour "COMBAT";
_group setCombatMode "RED";

private _wp = _group addWaypoint [getPos _waypoint, 0];
_wp setWaypointType "SAD";

private _enemyUnitsNearby = (_waypoint nearEntities ["Man", _range]) select { !isPlayer _x && {side _x != _side} };
{ _group reveal [_x, 4] } forEach _enemyUnitsNearby;
