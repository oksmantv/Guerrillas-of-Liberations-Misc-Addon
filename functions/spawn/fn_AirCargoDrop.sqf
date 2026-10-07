/*
    Function: OKS_fnc_AirCargoDrop

    Description:
        Spawns a crewed aircraft that flies from a spawn position toward a drop position,
        releases three parachute-delivered cargo crates (Box_NATO_AmmoVeh_F) when within
        500m of the drop waypoint, then continues to an exit position where it is deleted.
        The aircraft is spawned at 900m altitude if the provided Z is below 500m, and flies
        at 700m. The aircraft is set captive (ignored by AI) regardless of other settings.
        If the careless flag is set, crew behaviour is additionally set to STEALTH/BLUE.
        The exit waypoint auto-deletes the aircraft and crew on completion, but only if
        the waypoint type is not SAD. Crew is added via OKS_fnc_AddVehicleCrew and
        blacklisted from headless client transfer.

    Parameters:
        0: _spawnPos         - ARRAY   [x,y,z] - Spawn position for the aircraft (altitude auto-raised to 900m if below 500m)
        1: _dropToPos        - ARRAY   [x,y,z] - Position where cargo is released (waypoint completion radius 1000m)
        2: _moveToPos        - ARRAY   [x,y,z] - Exit position; aircraft and crew are deleted on arrival
        3: _classname         - STRING          - Aircraft classname (e.g. "B_T_VTOL_01_vehicle_F")
        4: _side              - SIDE            - Faction side for the crew (east/west/independent/civilian)
        5: _shouldBeCareless  - BOOLEAN         - If true, crew is set to STEALTH/BLUE (non-combat transit)
        6: _waypointType      - STRING          - Waypoint type for both drop and exit waypoints (e.g. "MOVE", "SAD")

    Returns:
        Nothing

    Example:
        [getPos plane_1, getPos drop_1, getPos exit_1, "B_T_VTOL_01_vehicle_F", west, true, "MOVE"] spawn OKS_fnc_AirCargoDrop;
*/

if (!isServer) exitWith {};

params [
    ["_spawnPos", [0,0,0], [[]]],
    ["_dropToPos", [0,0,0], [[]]],
    ["_moveToPos", [0,0,0], [[]]],
    ["_classname", "", [""]],
    ["_side", east, [sideUnknown]],
    ["_shouldBeCareless", false, [true]],
    ["_waypointType", "MOVE", [""]]
];

private _spawnPos3d = _spawnPos;
if ((_spawnPos3d select 2) < 500) then {
    _spawnPos3d = [_spawnPos3d#0, _spawnPos3d#1, 900];
};

private _aircraft = createVehicle [_classname, _spawnPos3d, [], 0, "FLY"];
_aircraft setPosATL _spawnPos3d;
_aircraft setDir (_aircraft getDir _moveToPos);
_aircraft setVelocityModelSpace [0, 150, 0];

private _crewGroup = [_aircraft, _side] call OKS_fnc_AddVehicleCrew;
_crewGroup setVariable ["acex_headless_blacklist", true, true];

_aircraft flyInHeight 700;
_aircraft setCaptive true;

if (_shouldBeCareless) then {
    _crewGroup setBehaviour "CARELESS";
    _crewGroup setCombatMode "BLUE";
    _aircraft setPilotLight false;
    _aircraft setCollisionLight false;
    { _x disableAI "LIGHTS"; } forEach (units _crewGroup);
};

private _dropWp = _crewGroup addWaypoint [_dropToPos, 0];
_dropWp setWaypointType _waypointType;
_dropWp setWaypointCompletionRadius 1000;

private _moveWp = _crewGroup addWaypoint [_moveToPos, 0];
_moveWp setWaypointType _waypointType;

if (waypointType _moveWp != "SAD") then {
    _moveWp setWaypointCompletionRadius 1000;
    _moveWp setWaypointStatements ["true", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach (units group this);"];
};

waitUntil {
    sleep 1;
    (_aircraft distance2D (waypointPosition _dropWp) < 500) || {!alive _aircraft}
};

deleteWaypoint _dropWp;

if (!alive _aircraft) exitWith {};

_aircraft spawn {
    {
        private _box = createVehicle ["Box_NATO_AmmoVeh_F", [0,0,0], [], 0, "NONE"];
        _box disableCollisionWith _this;
        _box hideObjectGlobal true;

        private _chute = createVehicle ["B_Parachute_02_F", [0,0,0], [], 0, "NONE"];
        _chute allowDamage false;
        _chute disableCollisionWith _this;
        _chute disableCollisionWith _box;
        _chute hideObjectGlobal true;

        _box attachTo [_chute, [0,0,0]];

        private _temp = [_this, 50, (getDir _this)] call BIS_fnc_relPos;
        _temp = [_temp#0, _temp#1, (_temp#2 - 10)];

        _chute setPosATL _temp;
        _chute setDir (getDir _this);

        private _pitchBank = _chute call BIS_fnc_getPitchBank;
        [_chute, 25, (_pitchBank select 1)] call BIS_fnc_setPitchBank;

        sleep 0.7;
        _box hideObjectGlobal false;
        _chute hideObjectGlobal false;

        _chute setVelocity [velocity _this select 0, velocity _this select 1, -5];
        [_chute] spawn {
            params ["_chuteLocal"];
            for "_i" from 1 to 10 do {
                _chuteLocal setVelocity [velocity _chuteLocal select 0, velocity _chuteLocal select 1, -5];
                sleep 0.5;
            };
        };
    } forEach [1,2,3];
};
