/*

    Use this code to delete corpses and objects as well as vehicles from the trigger area.

    Example:
    [DeleteTrigger_1] spawn OKS_fnc_DeleteDeadAndObjects;

    Params:
    1 - Trigger Object or Position
    2 - Delay Per Deletion (Default 0.01)
    3 - Should Delete Vehicles
    4 - Should Delete Placed Objects
    5 - Range of Trigger (If position is used)
*/

Params [
    "_TriggerNameOrPosition",
    ["_DeleteDelayPerDelete",0.01,[0]],
    ["_ShouldDeleteVehicles",true,[false]],
    ["_ShouldDeleteObjects",true,[false]],
    ["_Range",250,[0]]
];
private _Trigger = _TriggerOrPosition;
if(typename _TriggerOrPosition == "ARRAY") then {
    _Trigger = createTrigger ["EmptyDetector", getPos player];
    _Trigger setTriggerArea [_Range, _Range, 0, false];
};

// If players are inside the zone, delay until they have left.
if({_X inArea _Trigger} count allPlayers > 0) then {
    private _Debug = missionNamespace getVariable ["GOL_Ambience_Debug", false];
    if(_Debug) then {
        systemChat "Player inside deletion zone. Waiting until cleared." spawn OKS_fnc_LogDebug;
    };  
    waitUntil {sleep 30; {_X inArea _Trigger} count allPlayers == 0}
};


// Deletes all vehicle wrecks and empty vehicles.
if(_ShouldDeleteVehicles) then {
    {
        deleteVehicle _X;
        sleep _DeleteDelayPerDelete;
    } foreach ((allDead inAreaArray _Trigger) select { _vehicle = vehicle _X; vehicle _X != _X && !({[(_X), str (vehicleVarName _vehicle)] call BIS_fnc_inString} count ["Vehicle_","Mhq_"] > 0)});

    {
        _vehicle = vehicle _X;
        if ( (crew _x) findIf { isPlayer _x } == -1 && !({[(_X), str (vehicleVarName _vehicle)] call BIS_fnc_inString} count ["Vehicle_","Mhq_"] > 0)) then {
            deleteVehicle _x;
            sleep _DeleteDelayPerDelete;
        };
    } forEach (vehicles inAreaArray _Trigger);
};

// Deletes all dead soldiers that aren't vehicles.
{
    deleteVehicle _X;
    sleep _DeleteDelayPerDelete;
} foreach ((allDead inAreaArray _Trigger) select { vehicle _X == _X });

// Deletes all non-player soldiers.
{
    deleteVehicle _X;
    sleep _DeleteDelayPerDelete;
} foreach ((allUnits inAreaArray _Trigger) select { !isPlayer _X });

// Deletes all objects placed in editor or Zeus.
if(_ShouldDeleteObjects) then {
    _AreaArray = triggerArea _Trigger;
    _X = _AreaArray select 0;
    _Y = _AreaArray select 1;
    _MaxAxis = _X max _Y; 

    _nearObjects = (8 allObjects 0) inAreaArray _Trigger select { !(["EmptyDetector", typeof _X] call BIS_fnc_inString) };  
    {
        deleteVehicle _X;
        sleep _DeleteDelayPerDelete;   
    } foreach _nearObjects;
};