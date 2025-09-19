/*
  OKS_fnc_Convoy_AssignParkingAtEnd
  Assigns parking slots at destination using helper and sets waypoints.
  Params:
    0: OBJECT - lead vehicle
    1: ARRAY or OBJECT - end position
    2: NUMBER - primary slot count
    3: NUMBER - reserve slot count
*/
params ["_leadVeh", "_endPos", "_primarySlots", "_reserveSlots"];
private _arr = _leadVeh getVariable ["OKS_Convoy_VehicleArray", []];
private _assign = [_leadVeh, _primarySlots, _reserveSlots, _arr] call OKS_fnc_Convoy_EndParking_AssignIndices;
private _positions = [];
for "_i" from 0 to ((_primarySlots + _reserveSlots) - 1) do {
    private _hb = [_endPos, false, true] call OKS_fnc_Convoy_SetupHerringBone;
    _positions pushBack (_hb select 0);
};
{
    _x params ["_veh","_slotIdx","_isReserve"];
    private _pos = _positions select _slotIdx;
    private _grp = group driver _veh;
    while { (count waypoints _grp) > 0 } do { deleteWaypoint ((waypoints _grp) select 0); };
    private _wp = _grp addWaypoint [_pos, 0]; 
    _wp setWaypointType "MOVE"; 
    _wp setWaypointCompletionRadius 4; 
    // Tag waypoint so dispersion helper doesn’t increase spacing or spam logs at destination
    _wp setWaypointDescription "OKS_SUPPRESS_DISPERSION";
} forEach _assign;
