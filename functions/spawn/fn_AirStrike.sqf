/*
    OKS_fnc_AirStrike

    Ported from legacy script: Scripts\OKS_Spawn\OKS_AirStrike.sqf

    Params:
    0: Spawn (position or object)
    1: Strike anchor (object preferred, position supported)
    2: End (position or object)
    3: Aircraft classname (string)
    4: Side (side)
    5: Height (number)

    Example:
    [getPos jetspawn_1, jetstrike_1, getPos jetexit_1, "B_Plane_Fighter_01_Stealth_F", west, 250] spawn OKS_fnc_AirStrike;
*/

if (!isServer) exitWith {};

params [
    ["_spawnIn", [0,0,0], [[], objNull]],
    ["_strikeIn", objNull, [[], objNull]],
    ["_endIn", [0,0,0], [[], objNull]],
    ["_classname", "", [""]],
    ["_side", east, [sideUnknown]],
    ["_height", 250, [0]]
];

private _spawnPos = if (_spawnIn isEqualType objNull) then { getPosATL _spawnIn } else { _spawnIn };
private _endPos = if (_endIn isEqualType objNull) then { getPosATL _endIn } else { _endIn };

private _strikeObj = if (_strikeIn isEqualType objNull) then { _strikeIn } else { objNull };
private _strikeAnchorPos = if (!isNull _strikeObj) then { getPosATL _strikeObj } else { _strikeIn };

private _direction = if (!isNull _strikeObj) then { getDir _strikeObj } else { _spawnPos getDir _strikeAnchorPos };

private _strikePos = if (!isNull _strikeObj) then {
    _strikeObj getPos [350, (getDir _strikeObj - 180)]
} else {
    [_strikeAnchorPos, 350, (_direction - 180)] call BIS_fnc_relPos
};

private _spawnPos3d = [_spawnPos#0, _spawnPos#1, _height];

private _aircraft = createVehicle [_classname, _spawnPos3d, [], 0, "FLY"];
_aircraft setPosATL _spawnPos3d;
_aircraft setDir (_aircraft getDir _strikePos);
_aircraft setVelocityModelSpace [0, 500, 0];

private _crewGroup = [_aircraft, _side] call OKS_fnc_AddVehicleCrew;
_aircraft flyInHeight _height;

{
    _x disableAI "AUTOCOMBAT";
    _x disableAI "TARGET";
    _x disableAI "AUTOTARGET";
    _x disableAI "LIGHTS";
} forEach units _crewGroup;

_crewGroup setBehaviour "CARELESS";
_crewGroup setCombatMode "BLUE";

private _moveWp = _crewGroup addWaypoint [_strikePos, 0];
_moveWp setWaypointType "MOVE";

private _exitWp = _crewGroup addWaypoint [_endPos, 0];
_exitWp setWaypointType "MOVE";
_exitWp setWaypointCompletionRadius 1000;
_exitWp setWaypointStatements ["true", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach (units group this);"];

waitUntil { sleep 0.2; _aircraft distance2D _strikePos < 500 || !alive _aircraft };
if (!alive _aircraft) exitWith {};

sleep 1;
private _bomb = createVehicle ["BombCluster_01_Ammo_F", [_strikePos#0, _strikePos#1, 60], [], 0, "NONE"];
_bomb setDir _direction;
_bomb setVelocityModelSpace [0, 50, -150];
