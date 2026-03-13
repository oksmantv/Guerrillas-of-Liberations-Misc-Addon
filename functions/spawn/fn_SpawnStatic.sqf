/*
    Function: OKS_fnc_SpawnStatic

    Description:
        Spawns static infantry and vehicle positions from a structured data array,
        matching the format used by the GW Copy function. Infantry units are placed
        at exact positions with specified directions and stances, with their PATH AI
        disabled so they hold position. Vehicles are created at positions with crew
        via OKS_fnc_AddVehicleCrew. The first infantry unit spawned is assigned as
        group leader with SERGEANT rank. Unit classnames are pulled from
        OKS_Dynamic_Setting based on the specified side. LAMBS group AI is disabled
        for the infantry group to prevent autonomous repositioning.

    Parameters:
        0: _Array - ARRAY - Spawn data array structured as:
            [
                infantryArray,  // ARRAY of [position, direction, stance, extras]
                vehicleArray,   // ARRAY of [classname, position, direction, crewArray]
                reserved,       // ARRAY (unused, pass [])
                side            // SIDE (e.g. east, west, independent)
            ]

    Returns:
        Nothing

    Example:
        [
            [
                [[4349.69,3973.94,3.58], 233, "Auto", []],
                [[4352.35,3972.95,3.65], 233, "Auto", []]
            ],
            [
                ["UK3CB_ADE_O_DSHKM", [4352.14,3975.61,3.66], 267, [["gunner",-1,[0]]]]
            ],
            [],
            east
        ] spawn OKS_fnc_SpawnStatic;
*/

	if(!isServer) exitWith {};
Params [
	"_Array"
];
_Array Params [
	["_InfantryArray",[],[[]]],
	["_VehicleArray",[],[[]]],
	["_UnknownArray",[],[[]]],
	["_Side",independent,[sideUnknown]]
];

	_Settings = [_Side] Call OKS_Dynamic_Setting;
	_Settings Params ["_Units"];
	_Units Params ["_Leaders","_Units","_Officer"];
	Private ["_GarrisonPositions","_GarrisonMaxSize","_GarrisonMaxSize","_Unit","_Group"];

	_Group = CreateGroup _Side;
	_Group setVariable ["lambs_danger_disableGroupAI", true];
	{
		_X Params ["_Position","_Direction","_Stance","_Unknown"];

		if ( (count (units _Group)) == 0 ) then
		{
			_Unit = _Group CreateUnit [(_Leaders call BIS_FNC_selectRandom), _Position, [], 0, "NONE"];
			_Unit setRank "SERGEANT";
		} else {
			_Unit = _Group CreateUnit [(_Units call BIS_FNC_selectRandom), _Position, [], 0, "NONE"];
			_Unit setRank "PRIVATE";
		};
		_Unit setRank "PRIVATE";
		_Unit setDir _Direction;
		[_Unit,"PATH"] remoteExec ["disableAI",0];
		[_Unit,_Stance] remoteExec ["setUnitPos",0];				
	} foreach _InfantryArray;

	{
		Params ["_Type","_Position","_Dir","_Crew"];
		str [_Type,_Position,_Dir,_Crew] spawn OKS_fnc_LogDebug;
		_Vehicle = CreateVehicle [_Type,_Position];
		_Vehicle setPosATL _Position;
		_Vehicle setDir _Dir;
		_Group = [_Vehicle,_Side,0,0] call OKS_fnc_AddVehicleCrew;
	} forEach _VehicleArray;