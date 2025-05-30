/*

    [
        getPos civilianStart_1,
        getPos CivilianEnd_1,     
        selectRandom ["UK3CB_ADC_C_Datsun_Civ_Open","UK3CB_ADC_C_Hatchback","UK3CB_ADC_C_V3S_Repair","UK3CB_ADC_C_Skoda","UK3CB_ADC_C_Sedan","UK3CB_ADC_C_UAZ_Open","UK3CB_ADC_C_UAZ_Closed"],
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
    ["_ShouldDelete",true,[true]]
];

_vehicle = createVehicle [_VehicleType, _SpawnPosition, [], 0, "CAN_COLLIDE"];
_civilianGroup = createGroup civilian;
_driver = _civilianGroup createUnit ["C_man_polo_1_F", [0,0,0], [], 0, "NONE"];
_driver moveInDriver _vehicle;
[_driver] spawn OKS_fnc_FaceSwap;

_waypoint = _civilianGroup addWaypoint [_EndPosition,0];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointBehaviour "CARELESS";

_vehicle forceSpeed _Speed;

waitUntil {sleep 5; _vehicle distance _EndPosition < 20};

if(_ShouldDelete) then {
    deleteVehicle _driver;
    deleteVehicle _vehicle;
} else {
    _waypointGetout = _civilianGroup addWaypoint [_EndPosition,0];
    _waypointGetout setWaypointType "GETOUT";   
    _waypointEnd = _civilianGroup addWaypoint [_EndPosition,0];
    _waypoint setWaypointType "DISMISS";
    _waypoint setWaypointBehaviour "SAFE";
};
