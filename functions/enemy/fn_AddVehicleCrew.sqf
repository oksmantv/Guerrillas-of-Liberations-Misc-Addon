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

    // Handle "fill cargo" request
    if (_CargoSlots == -1) then {
        // Set _CargoSlots to whatever the maximum cargo slots are for this vehicle type
        _CargoSlots = ([TypeOf _Vehicle,true] call BIS_fnc_crewCount) - ([TypeOf _Vehicle,false] call BIS_fnc_crewCount);
    };

    Private ["_UnitClass","_Group","_Commander","_Gunner","_Driver"];

    private _isAirVehicle = (!isNull _Vehicle) && {
        (_Vehicle isKindOf "Air")
        || {_Vehicle isKindOf "UAV"}
        || {getNumber (configFile >> "CfgVehicles" >> typeOf _Vehicle >> "isUav") isEqualTo 1}
    };

    private _isHelicopter = _isAirVehicle && { _Vehicle isKindOf "Helicopter" };

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

    // For air vehicles, use pilots for the driver seat.
    // For helicopters, use helicrew for turret seats (gunner/commander) when possible.
    private _driverUnitClass = _unitClass;
    private _turretUnitClass = _unitClass;
    if (_isAirVehicle) then {
        switch (_side) do {
            case WEST: {
                _driverUnitClass = if (_isHelicopter) then {"B_Helipilot_F"} else {"B_Pilot_F"};
                _turretUnitClass = if (_isHelicopter) then {"B_Helicrew_F"} else {"B_crew_F"};
            };
            case EAST: {
                _driverUnitClass = if (_isHelicopter) then {"O_Helipilot_F"} else {"O_Pilot_F"};
                _turretUnitClass = if (_isHelicopter) then {"O_Helicrew_F"} else {"O_crew_F"};
            };
            case INDEPENDENT: {
                _driverUnitClass = if (_isHelicopter) then {"I_Helipilot_F"} else {"I_Pilot_F"};
                _turretUnitClass = if (_isHelicopter) then {"I_Helicrew_F"} else {"I_crew_F"};
            };
            case civilian: {
                _driverUnitClass = "C_man_pilot_F";
                _turretUnitClass = "C_man_pilot_F";
            };
            default {
                _driverUnitClass = if (_isHelicopter) then {"O_Helipilot_F"} else {"O_Pilot_F"};
                _turretUnitClass = if (_isHelicopter) then {"O_Helicrew_F"} else {"O_crew_F"};
            };
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
            _Commander = _Group CreateUnit [_turretUnitClass, [0,0,0], [], 5, "NONE"];
            _Commander setRank "SERGEANT";
            _Commander moveinCommander _Vehicle;
        };

        if(_Vehicle emptyPositions "gunner" > 0 && (_CrewSlots == 0 || _CrewSlots == 2)) then {
            if(_Debug_Variable) then {
                "[ADDVEHICLECREW] Creating Gunner" spawn OKS_fnc_LogDebug;
            };
            _Gunner = _Group CreateUnit [_turretUnitClass, [0,0,0], [], 5, "NONE"];
            _Gunner setRank "CORPORAL";
            _Gunner moveinGunner _Vehicle;
        };

        if(_Vehicle emptyPositions "driver" > 0 && (_CrewSlots == 0 || _CrewSlots == 1)) then {
            if(_Debug_Variable) then {
                "[ADDVEHICLECREW] Creating Driver" spawn OKS_fnc_LogDebug;
            };
            _Driver = _Group CreateUnit [_driverUnitClass, [0,0,0], [], 5, "NONE"];
            _Driver setRank "PRIVATE";
            _Driver moveinDriver _Vehicle;
        };

        // Fill any additional weapon turrets (e.g., secondary MG turrets) when we're adding gunners.
        // Note: `moveInGunner/moveInCommander` only covers the primary seats; extra turrets need `moveInTurret`.
        if (_CrewSlots == 0 || _CrewSlots == 2) then {
            private _turretPaths = allTurrets [_Vehicle, true];
            {
                private _turretPath = _x;
                private _turretCfg = [_Vehicle, _turretPath] call BIS_fnc_turretConfig;
                private _isPersonTurret = (getNumber (_turretCfg >> "isPersonTurret")) isEqualTo 1;
                private _turretHasWeapons = (count (_Vehicle weaponsTurret _turretPath)) > 0;
                private _turretIsEmpty = isNull (_Vehicle turretUnit _turretPath);

                if (!_isPersonTurret && _turretHasWeapons && _turretIsEmpty) then {
                    if(_Debug_Variable) then {
                        format ["[ADDVEHICLECREW] Filling turret gunner %1", _turretPath] spawn OKS_fnc_LogDebug;
                    };
                    private _turretGunner = _Group CreateUnit [_turretUnitClass, [0,0,0], [], 5, "NONE"];
                    _turretGunner setRank "CORPORAL";
                    _turretGunner moveInTurret [_Vehicle, _turretPath];
                };
            } forEach _turretPaths;
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



