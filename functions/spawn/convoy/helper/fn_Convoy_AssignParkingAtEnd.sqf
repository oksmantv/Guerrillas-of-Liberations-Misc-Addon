/*
   OKS_fnc_Convoy_AssignParkingAtEnd

   {
        _x params ["_veh","_slotIdx","_isReserve"];
        
        // Skip vehicles that already have reserve waypoints assigned
        private _hasReserveWaypoint = _veh getVariable ["OKS_Convoy_HasReserveWaypoint", false];
        if (_hasReserveWaypoint) then {
            private _isConvoyDebugEnabled = missionNamespace getVariable ["GOL_Convoy_Debug", false];
            if (_isConvoyDebugEnabled) then {
                format ["[CONVOY-PARKING-ASSIGN] Vehicle %1 already has reserve waypoint, skipping parking assignment", _veh] spawn OKS_fnc_LogDebug;
            };
        } else {
            // Assign normal parking position
            private _pos = _positions select _slotIdx;
            private _grp = group driver _veh;
            while { (count waypoints _grp) > 0 } do { deleteWaypoint ((waypoints _grp) select 0); };
            private _wp = _grp addWaypoint [_pos, 0]; 
            _wp setWaypointType "MOVE"; 
            _wp setWaypointCompletionRadius 4; 
            // Tag waypoint so dispersion helper doesn't increase spacing or spam logs at destination
            _wp setWaypointDescription "OKS_SUPPRESS_DISPERSION";
            
            private _isConvoyDebugEnabled = missionNamespace getVariable ["GOL_Convoy_Debug", false];
            if (_isConvoyDebugEnabled) then {
                format ["[CONVOY-PARKING-ASSIGN] Vehicle %1 assigned to normal parking slot %2 at position %3", _veh, _slotIdx, _pos] spawn OKS_fnc_LogDebug;
            };
        };
    } forEach _assign;

  Assigns parking slots at destination using helper and sets waypoints.
  Params:
    0: OBJECT - lead vehicle
    1: ARRAY or OBJECT - end position
    2: NUMBER - primary slot count
    3: NUMBER - reserve slot count

    [OBSOLETE]
*/

params ["_LeaderVehicle", "_EndPosition", "_PrimaryParkingSlotCount", "_ReserveParkingSlotCount"];

private _VehicleArray = _LeaderVehicle getVariable ["OKS_Convoy_VehicleArray", []];
private _assign = [_LeaderVehicle, _PrimaryParkingSlotCount, _ReserveParkingSlotCount, _VehicleArray] call OKS_fnc_Convoy_EndParking_AssignIndices;
private _positions = [];
for "_i" from 0 to ((_PrimaryParkingSlotCount + _ReserveParkingSlotCount) - 1) do {
    private _hb = [_EndPosition, false, true, false, false] call OKS_fnc_Convoy_SetupHerringBone; // Use traditional alternating by default
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
    _wp setWaypointDescription "OKS_SUPPRESS_DISPERSION";
} forEach _assign;
