    // OKS_fnc_AddVehicleCrew
    // [_this,west,0] call OKS_fnc_AddVehicleCrew
    // 

    if(HasInterface && !isServer) exitWith {};

    Params[
        ["_Vehicle",objNull,[objnull]],
        ["_Side",east,[sideUnknown]],
        ["_CrewSlots",0,[-1]], // 0 = full crew, 1 = driver only, 2 = gunner only, 3 = commander only, -1 = None
        ["_CargoSlots",0,[-1]], // Amount of Infantry in Cargo
        ["_ShouldBlacklistHeadless",false,[false]],
        ["_AddCargoCommander",false,[false]] // If true, add first cargo slot and set as effectiveCommander
    ];
    Private ["_UnitClass","_Group","_Commander","_Gunner","_Driver"];

    _Settings = [_Side] call OKS_fnc_Dynamic_Settings;
    _Settings Params ["_UnitArray","_SideMarker","_SideColor","_Vehicles","_Civilian"];
	_UnitArray Params ["_Leaders","_Units","_Officer"];
    _Debug_Variable = false;

    switch (_side) do {
        case WEST: {
            _unitClass = "B_crew_F";
        };

        case EAST: {
            _unitClass = "O_crew_F";
        };

        case INDEPENDENT: {
            _unitClass = "I_crew_F";
        };

        case civilian:{
            _unitClass = "C_man_1_1_F";
        };

        default {
            _unitClass = "O_crew_F";
        };
    };

    _Group = createGroup _Side;
    _Group setVariable ["acex_headless_blacklist",true,true];

    if(_CrewSlots != -1) then {
        if(_Debug_Variable) then {
            format ["[ADDVEHICLECREW] Group: %3 Side: %2 - %1 Class Selected",_unitClass,_Side,_Group] spawn OKS_fnc_LogDebug;
        };
        if(_Vehicle emptyPositions "commander" > 0 && (_CrewSlots == 0 || _CrewSlots == 3)) then {
            if(_Debug_Variable) then {
                "[ADDVEHICLECREW] Creating Commander" spawn OKS_fnc_LogDebug;
            };
            _Commander = _Group CreateUnit [_UnitClass, [0,0,0], [], 5, "NONE"];
            _Commander setRank "SERGEANT";
            _Commander moveinCommander _Vehicle;
        };

        if(_Vehicle emptyPositions "gunner" > 0 && (_CrewSlots == 0 || _CrewSlots == 2)) then {
            if(_Debug_Variable) then {
                "[ADDVEHICLECREW] Creating Gunner" spawn OKS_fnc_LogDebug;
            };
            _Gunner = _Group CreateUnit [_UnitClass, [0,0,0], [], 5, "NONE"];
            _Gunner setRank "CORPORAL";
            _Gunner moveinGunner _Vehicle;
        };

        if(_Vehicle emptyPositions "driver" > 0 && (_CrewSlots == 0 || _CrewSlots == 1)) then {
            if(_Debug_Variable) then {
                "[ADDVEHICLECREW] Creating Driver" spawn OKS_fnc_LogDebug;
            };
            _Driver = _Group CreateUnit [_UnitClass, [0,0,0], [], 5, "NONE"];
            _Driver setRank "PRIVATE";
            _Driver moveinDriver _Vehicle;
        };
    };

    if(_CargoSlots > 0 || _AddCargoCommander) then {
        if(([TypeOf _Vehicle,true] call BIS_fnc_crewCount) - ([TypeOf _Vehicle,false] call BIS_fnc_crewCount) >= 1) then {
            _CargoSeats = ([TypeOf _Vehicle,true] call BIS_fnc_crewCount) - ([TypeOf _Vehicle,false] call BIS_fnc_crewCount);
            if(_AddCargoCommander) then {
                // Add first cargo slot and set as effectiveCommander
                _Unit = _Group CreateUnit [(_Leaders call BIS_FNC_selectRandom), [0,0,0], [], 0, "NONE"];
                _Unit setRank "SERGEANT";
                _Unit MoveInCargo _Vehicle;
                _Group selectLeader _Unit;
                _Vehicle setEffectiveCommander _Unit;
                if(_Debug_Variable) then {
                    format["[ADDVEHICLECREW] Added cargo commander %1 to %2",_Unit,_Vehicle] spawn OKS_fnc_LogDebug;
                };
                _CargoSeats = _CargoSeats - 1;
            };
            if(_CargoSeats > _CargoSlots) then { _CargoSeats = _CargoSlots };
            for "_i" from 1 to (_CargoSeats) do
            {
                Private "_Unit";
                _Unit = _Group CreateUnit [(_Units call BIS_FNC_selectRandom), [0,0,0], [], 0, "NONE"];
                _Unit setRank "PRIVATE";
                _Unit MoveInCargo _Vehicle;
            };
        } else {
            format["[ADDVEHICLECREW] Vehicle Type: %1 does not have cargo slots",typeOf _Vehicle] spawn OKS_fnc_LogDebug;
        };
    };

     {[_x] remoteExec ["GW_SetDifficulty_fnc_setSkill",0]} foreach units _Group;

    _Group



