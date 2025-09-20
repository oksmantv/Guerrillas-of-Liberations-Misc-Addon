/*
  OKS_fnc_Convoy_AssignReserveWaypoint
  Assigns a reserve parking waypoint to a vehicle that has fallen behind the convoy.
  This function finds the first available reserve position and replaces the vehicle's
  final waypoint with that position, marking it as occupied.
  
  Params:
    0: OBJECT - Vehicle that needs a reserve waypoint
    
  Returns:
    BOOLEAN - True if reserve waypoint was assigned, false if no positions available
*/

params ["_vehicle"];

if (isNull _vehicle || !alive _vehicle || !canMove _vehicle) exitWith { false };

// Get the lead vehicle and reserve queue
private _leadVeh = _vehicle getVariable ["OKS_Convoy_LeadVehicle", objNull];
if (isNull _leadVeh) exitWith { 
    if (missionNamespace getVariable ["GOL_Convoy_Debug", false]) then {
        format ["[CONVOY-RESERVE-WAYPOINT] Vehicle %1 has no lead vehicle reference", _vehicle] spawn OKS_fnc_LogDebug;
    };
    false 
};

private _reserveQueue = _leadVeh getVariable ["OKS_Convoy_ReserveQueue", []];
if (_reserveQueue isEqualTo []) exitWith { 
    if (missionNamespace getVariable ["GOL_Convoy_Debug", false]) then {
        format ["[CONVOY-RESERVE-WAYPOINT] No reserve positions available for vehicle %1", _vehicle] spawn OKS_fnc_LogDebug;
    };
    false 
};

// Debug: Log all reserve positions before assignment
if (missionNamespace getVariable ["GOL_Convoy_Debug", false]) then {
    private _debugQueue = [];
    {
        _x params ["_pos", "_occupied"];
        _debugQueue pushBack format ["Pos %1: %2 (occupied: %3)", _forEachIndex, _pos, _occupied];
    } forEach _reserveQueue;
    format ["[CONVOY-RESERVE-WAYPOINT] Available reserve queue for %1: %2", _vehicle, _debugQueue joinString " | "] spawn OKS_fnc_LogDebug;
};

// Find first unoccupied reserve position
private _selectedIndex = -1;
private _assignedPosition = [];
{
    _x params ["_position", "_isOccupied"];
    if (!_isOccupied) exitWith {
        _selectedIndex = _forEachIndex;
        _assignedPosition = _position;
    };
} forEach _reserveQueue;

if (_selectedIndex == -1) exitWith { 
    if (missionNamespace getVariable ["GOL_Convoy_Debug", false]) then {
        format ["[CONVOY-RESERVE-WAYPOINT] All reserve positions occupied for vehicle %1", _vehicle] spawn OKS_fnc_LogDebug;
    };
    false 
};

// Debug: Log which position was selected
if (missionNamespace getVariable ["GOL_Convoy_Debug", false]) then {
    format ["[CONVOY-RESERVE-WAYPOINT] Vehicle %1 assigned to reserve index %2 at position %3", _vehicle, _selectedIndex, _assignedPosition] spawn OKS_fnc_LogDebug;
};

// Mark the position as occupied
_reserveQueue set [_selectedIndex, [_assignedPosition, true]];
_leadVeh setVariable ["OKS_Convoy_ReserveQueue", _reserveQueue, true];

// Move the vehicle's last waypoint to the reserve position
private _group = group driver _vehicle;
private _waypoints = waypoints _group;
private _lastWaypointIndex = (count _waypoints) - 1;

if (_lastWaypointIndex >= 0) then {
    // Move the existing last waypoint to the reserve position
    private _lastWaypoint = _waypoints select _lastWaypointIndex;
    _lastWaypoint setWPPos _assignedPosition;
    _lastWaypoint setWaypointDescription "OKS_RESERVE_PARKING";
    
    if (missionNamespace getVariable ["GOL_Convoy_Debug", false]) then {
        format ["[CONVOY-RESERVE-WAYPOINT] Moved last waypoint for vehicle %1 to reserve position", _vehicle] spawn OKS_fnc_LogDebug;
    };
} else {
    // No existing waypoint, create new one at reserve position
    private _newWaypoint = _group addWaypoint [_assignedPosition, 0];
    _newWaypoint setWaypointType "MOVE";
    _newWaypoint setWaypointCompletionRadius 4;
    _newWaypoint setWaypointDescription "OKS_RESERVE_PARKING";
    
    if (missionNamespace getVariable ["GOL_Convoy_Debug", false]) then {
        format ["[CONVOY-RESERVE-WAYPOINT] Created new waypoint for vehicle %1 at reserve position", _vehicle] spawn OKS_fnc_LogDebug;
    };
};

// Mark vehicle as assigned to reserve
_vehicle setVariable ["OKS_Convoy_AssignedReserveIndex", _selectedIndex, true];
_vehicle setVariable ["OKS_Convoy_HasReserveWaypoint", true, true];

if (missionNamespace getVariable ["GOL_Convoy_Debug", false]) then {
    format ["[CONVOY-RESERVE-WAYPOINT] Vehicle %1 assigned to reserve position %2 (index %3)", _vehicle, _assignedPosition, _selectedIndex] spawn OKS_fnc_LogDebug;
};

true