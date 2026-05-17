/*
    Function: OKS_fnc_Civilian_Vehicle

    Description:
        Spawns a civilian vehicle with a driver at a start position and sends it via a
        MOVE waypoint to an end position at a forced speed. Useful for ambient traffic or
        scripted civilian movement in missions. The driver is set to CARELESS behaviour
        so it ignores combat entirely. On arrival (within 20m of end position), the vehicle
        and driver are either deleted (default) or the driver receives GETOUT and DISMISS
        waypoints to exit the vehicle and go about civilian life.

    Parameters:
        0: _SpawnPosition - ARRAY   [x,y,z] - Spawn position for the vehicle
        1: _EndPosition   - ARRAY   [x,y,z] - Destination position for the vehicle
        2: _VehicleType   - STRING          - Vehicle classname to spawn
        3: _Speed         - NUMBER          - Forced speed of the vehicle in km/h (default: 8)
        4: _ShouldDelete  - BOOLEAN         - Delete vehicle and driver on arrival (default: true)

    Returns:
        Nothing

    Example:
        [
            getPos civilianStart_1,
            getPos civilianEnd_1,
            selectRandom ["UK3CB_ADC_C_Datsun_Civ_Open", "UK3CB_ADC_C_Hatchback", "UK3CB_ADC_C_Skoda"],
            10,
            true
        ] spawn OKS_fnc_Civilian_Vehicle;
*/

if(!isServer) exitWith {};

Params [
    "_SpawnPosition",
    "_EndPosition",   
    "_VehicleType",
    ["_Speed",8,[0]],
    ["_ShouldDelete",true,[true]],
    ["_RandomCargoSeats",true,[true]]
];

waitUntil { sleep 1; (nearestObjects [_SpawnPosition, ["LandVehicle", "Air", "Ship"], 15] isEqualTo []) };

_vehicle = createVehicle [_VehicleType, _SpawnPosition, [], 0, "CAN_COLLIDE"];
if(_SpawnPosition isEqualType objNull) then {
    _vehicle setDir (getDir _SpawnPosition)
};

_civilianGroup = createGroup civilian;
_driver = _civilianGroup createUnit ["C_man_polo_1_F", [0,0,0], [], 0, "NONE"];
_driver moveInDriver _vehicle;

if(_RandomCargoSeats) then {
    _vehicleCargoSeatCount = _vehicle emptyPositions "Cargo";
    _randomCargoCount = round(random _vehicleCargoSeatCount);
    for "_i" from 1 to _randomCargoCount do {
        _randomCargo = _civilianGroup createUnit ["C_man_polo_1_F", [0,0,0], [], 0, "NONE"];
        _randomCargo moveInCargo [_vehicle, round(random _vehicleCargoSeatCount)];
    };
};

_waypoint = _civilianGroup addWaypoint [_EndPosition,0];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointBehaviour "CARELESS";

_vehicle forceSpeed _Speed;

waitUntil {sleep 5; _vehicle distance _EndPosition < 20};

if(_ShouldDelete) then {
    {deleteVehicle _X} foreach crew _vehicle;
    deleteVehicle _vehicle;
} else {
    _waypointGetout = _civilianGroup addWaypoint [_EndPosition,0];
    _waypointGetout setWaypointType "GETOUT";   
    _waypointEnd = _civilianGroup addWaypoint [_EndPosition,0];
    _waypointEnd setWaypointType "DISMISS";
    _waypointEnd setWaypointBehaviour "SAFE";
};
