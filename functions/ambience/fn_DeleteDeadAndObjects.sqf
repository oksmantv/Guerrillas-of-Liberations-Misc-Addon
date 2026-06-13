/*

    Use this code to delete corpses and objects as well as vehicles from the trigger area.

    Example:
    [DeleteTrigger_1] spawn OKS_fnc_DeleteDeadAndObjects;

    Params:
    1 - Trigger Object or Position
    2 - Delay Per Deletion (Default 0.01)
    3 - Delete Static Vehicles (Default true. False = only patrol vehicles with waypoints deleted, static threats remain)
    4 - Should Delete Placed Objects
    5 - Range of Trigger (If position is used)
    6 - Vehicle Side Filter (Array of sides to delete, [] = all sides. Example: [west, east])
*/


Params [
    "_TriggerNameOrPosition",
    ["_DeleteDelayPerDelete",0.01,[0]],
    ["_DeleteStaticVehicles",true,[false]],
    ["_ShouldDeleteObjects",true,[false]],
    ["_Range",250,[0]],
    ["_VehicleSideFilter",[],[[]]]  // Whitelist of sides to delete vehicles from. Empty = all sides.
];

private _Trigger = _TriggerNameOrPosition;
if (typename _TriggerNameOrPosition == "ARRAY") then {
    _Trigger = createTrigger ["EmptyDetector", _TriggerNameOrPosition];
    _Trigger setTriggerArea [_Range, _Range, 0, false];
};


// If players are inside the zone, delay until they have left.
if ({_X inArea _Trigger} count allPlayers > 0) then {
    private _Debug = missionNamespace getVariable ["GOL_Ambience_Debug", false];
    if (_Debug) then {
        "Player inside deletion zone. Waiting until cleared." spawn OKS_fnc_LogDebug;
    };
    waitUntil { sleep 60; {_X inArea _Trigger} count allPlayers == 0 };
};



// Deletes vehicle wrecks and corpses inside them. Always runs.
{
    deleteVehicle _X;
    sleep _DeleteDelayPerDelete;
} foreach ((allDead inAreaArray _Trigger) select { private _vehicle = vehicle _X; vehicle _X != _X && (_VehicleSideFilter isEqualTo [] || side _vehicle in _VehicleSideFilter) && !({[(_X), str (vehicleVarName _vehicle)] call BIS_fnc_inString} count ["Vehicle_","Mhq_","Helicopter_","Jet_"] > 0) });

// Deletes AI-only vehicles. Patrol vehicles (with waypoints) are always deleted.
// Static vehicles (no waypoints) are only deleted when _DeleteStaticVehicles is true, so they can remain as threats to helicopters.
{
    private _vehicle = vehicle _X;
    if (
        (_VehicleSideFilter isEqualTo [] || side _vehicle in _VehicleSideFilter) &&
        (crew _vehicle) findIf { isPlayer _X } == -1 &&
        !({[(_X), str (vehicleVarName _vehicle)] call BIS_fnc_inString} count ["Vehicle_","Mhq_"] > 0) &&
        (_DeleteStaticVehicles || count waypoints (group _vehicle) > 0)
    ) then {
        deleteVehicle _vehicle;
        sleep _DeleteDelayPerDelete;
    };
} forEach (vehicles inAreaArray _Trigger);


// Deletes all dead soldiers that aren't vehicles.
{
    deleteVehicle _X;
    sleep _DeleteDelayPerDelete;
} foreach ((allDead inAreaArray _Trigger) select { vehicle _X == _X });

// Deletes all non-player soldiers.
{
    deleteVehicle _X;
    sleep _DeleteDelayPerDelete;
} foreach ((allUnits inAreaArray _Trigger) select { !isPlayer _X && (vehicle _X == _X || _DeleteStaticVehicles || count waypoints (group (vehicle _X)) > 0) });


// Deletes all objects placed in editor or Zeus.
if (_ShouldDeleteObjects) then {
    private _nearObjects = (8 allObjects 0) inAreaArray _Trigger select {
        !( ["EmptyDetector", typeof _X] call BIS_fnc_inString) && ( _X != _Trigger )
    };
    {
        deleteVehicle _X;
        sleep _DeleteDelayPerDelete;
    } foreach _nearObjects;
};

format["Finished deleting objects in %1", _Trigger] spawn OKS_fnc_LogDebug;