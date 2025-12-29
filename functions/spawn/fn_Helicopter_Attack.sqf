/*
    OKS_fnc_Helicopter_Attack

    Ported from legacy script: Scripts\OKS_Spawn\OKS_Helicopter_Attack.sqf

    Params:
    0: Spawn object (object)
    1: Attack waypoint object (object)
    2: Side (side)
    3: Helicopter classname (string)
    4: Reveal range around waypoint (number)

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
