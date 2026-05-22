/*
OKS_fnc_Convoy_Spawn

Spawns a convoy from a position through a waypoint to a final destination.
This function is callable (call) and returns the task ID immediately.
The convoy execution runs in a separate spawned thread.

Params:
1  - Object - Spawn Position
2  - Object - First Waypoint
3  - Object - Final Waypoint (Where they spread out in the area)
4  - Side
5  - Vehicle Array
1 - Integer - Count of Vehicles
2 - Array of Classnames or String
3 - Integer M/S Speed
4 - Dispersion (convoy spacing while driving)
5 - ParkingDispersion (meters between parked vehicles in offroad/convoystop, default: 30)
6  - Troop Array
1 - Bool - Should spawn troop in cargo
2 - Integer - Max Number of Soldiers per vehicle
7  - Convoy Array (Array that gets filled with convoy units)
8  - Should be forced to careless (No reaction from Convoy)
9  - Should be deleted on reaching final waypoint
10 - Dismount Behaviour - Array of Types of waypoints for dismounts
Options: ["rush", "defend", "patrol", "assault", "hunt"]
Default: ["rush"]
11 - Parking Mode - String enum controlling how vehicles park at the end waypoint
Options:
"alternate"   - Vehicles alternate left/right sides of the road (herringbone)
"successive"  - Both sides of each road segment are filled before moving to the next
"convoystop"  - Vehicles stop on the road in convoy order (no lateral offset)
"offroad"     - Vehicles form a single-file line from the end object using its direction, spaced by dispersion
Default: "alternate"
Backwards compatible: false = "alternate", true = "successive" (deprecated, use strings)
12 - Task Array (Optional. If defined, creates a moving BIS task via OKS_fnc_Convoy_TaskTracker.)
Structure:
1 - String - Task Parent ("" for none)
2 - Bool   - Show Task Position (marker visible on map)
3 - Bool   - Task-Popup Notification
4 - String - Task Condition enum: "destroy" | "intercept"

Returns:
String - Pre-generated BIS task ID when param 12 is provided, "" otherwise.
The task is created in the convoy thread once vehicles have spawned (~10-30s after call).
Use taskState to poll (returns "" until the task is created, safe to poll from the start):

private _taskId = [convoy_1,convoy_2,convoy_3,east,[4,["rhs_t80u"],6,25],[true,6],[],false,false,["rush"],"alternate",["",true,true,"destroy"]] call OKS_fnc_Convoy_Spawn;
waitUntil { sleep 5; taskState _taskId in ["SUCCEEDED","FAILED"] };

Backwards compatible: old [params] spawn OKS_fnc_Convoy_Spawn calls still work.
Examples (spawn form, return value discarded):
[convoy_1,convoy_2,convoy_3,east,[4,["rhs_btr60_msv"], 6, 25],[true,6],[], false, false] spawn OKS_fnc_Convoy_Spawn;
[convoy_1,convoy_2,convoy_3,east,[4,["rhs_btr60_msv"], 6, 25],[true,6],[], false, false, ["rush"], "alternate"] spawn OKS_fnc_Convoy_Spawn;
[convoy_1,convoy_2,convoy_3,east,[4,["rhs_btr60_msv"], 6, 25],[true,6],[], false, false, ["rush"], "convoystop"] spawn OKS_fnc_Convoy_Spawn;
[convoy_1,convoy_2,convoy_3,east,[4,["rhs_btr60_msv"], 6, 25, 30],[true,6],[], false, false, ["rush"], "offroad"] spawn OKS_fnc_Convoy_Spawn;
*/

if (!isServer) exitWith { "" };

private _taskArray = _this param [11, nil];
private _taskId = "";
if (!isNil "_taskArray" && { _taskArray isEqualType [] } && { count _taskArray > 0 }) then {
_taskId = format ["OKS_ConvoyTask_%1_%2", round (random 99999), round (diag_tickTime * 1000)];
};

(_this + [_taskId]) spawn OKS_fnc_Convoy_SpawnBody;

_taskId
