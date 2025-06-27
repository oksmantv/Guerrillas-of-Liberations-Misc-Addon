    // OKS_fnc_CreateVehicleWithCrew
    // [getPos this,getDir this, "rhs_btr60_msv", east, 0, 6] call OKS_fnc_CreateVehicleWithCrew;
    // Returns: Group

    if(HasInterface && !isServer) exitWith {};

    Params[
        ["_Position",[0,0,0],[[]]],
        ["_Direction",(random 360),[0]],
        ["_TypeOfVehicle","",[""]],
        ["_Side",east,[sideUnknown]],
        ["_CrewSlots",0,[-1]], // 0 = full crew, 1 = driver only, 2 = gunner only, 3 = commander only
        ["_CargoSlots",0,[-1]] // Amount of Infantry in Cargo
    ];

    _Vehicle = CreateVehicle [_TypeOfVehicle, _Position];
    _Vehicle setPosATL _Position;
    _Vehicle setDir _Direction;
    _Group = [_Vehicle,_Side,_CrewSlots,_CargoSlots] call OKS_fnc_AddVehicleCrew;
    _Group


