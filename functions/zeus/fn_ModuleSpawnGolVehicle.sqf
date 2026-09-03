/*
    OKS_fnc_ModuleSpawnGolVehicle

    Zeus module - spawns a fresh vehicle that copies the CURRENT "Vehicle_1"
    or "MHQ_1" template's classname + exported appearance (per the module's
    "OKS_GolVehicleType" config property, "Vehicle"/"MHQ"), names it the next
    free "Vehicle_N"/"MHQ_N", then applies the Mechanized/MHQ setup to it.

    This is a replacement of whatever the mission's standard supply
    vehicle/MHQ currently is (e.g. an M-ATV or Badger IFV placed & named in
    Eden) - NOT a hardcoded default classname. "Vehicle_1"/"MHQ_1" must
    already exist for this module to have something to copy from.

    Runs server-side only (isGlobal = 1 still calls this on every machine, so
    non-server machines bail out immediately) - createVehicle must only ever
    happen once, not once per machine.

    Arguments:
    0: Logic <OBJECT> - the module logic object
    1: Units <ARRAY> - synchronized units (engine-provided, unused)
    2: Activated <BOOL>

    Return Value: NO

    Public: NO
*/

params [
    ["_logic", objNull, [objNull]],
    ["_units", [], [[]]],
    ["_activated", true, [true]]
];

if (isNull _logic) exitWith {};
if !(_activated) exitWith {};
if !(isServer) exitWith { deleteVehicle _logic; };

private _type = getText (configFile >> "CfgVehicles" >> (typeOf _logic) >> "OKS_GolVehicleType");

if (_type isEqualTo "") exitWith {
    deleteVehicle _logic;
};

private _templateVarName = _type + "_1";

if (isNil _templateVarName) exitWith {
    hint format ["GOL Supply - Spawn New GOL %1: '%2' does not exist yet. Place/name a template vehicle first.", _type, _templateVarName];
    deleteVehicle _logic;
};

private _template = missionNamespace getVariable _templateVarName;

if (isNull _template) exitWith {
    hint format ["GOL Supply - Spawn New GOL %1: '%2' no longer exists (destroyed/deleted).", _type, _templateVarName];
    deleteVehicle _logic;
};

private _vehicleClass = typeOf _template;
private _appearanceCode = compile ([_template, ""] call BIS_fnc_exportVehicle);

private _index = 1;
private _varName = format ["%1_%2", _type, _index];
while { !(isNil _varName) } do {
    _index = _index + 1;
    _varName = format ["%1_%2", _type, _index];
};

private _pos = getPosATL _logic;
_pos resize 2; // 2D only - lets createVehicle auto-snap to ground height, avoids burying the vehicle on sloped/elevated terrain
private _dir = getDir _logic;

private _veh = createVehicle [_vehicleClass, _pos, [], 0, "NONE"];
_veh setDir _dir;
_veh call _appearanceCode;
_veh setVehicleVarName _varName;
missionNamespace setVariable [_varName, _veh, true];

if (_type isEqualTo "Vehicle") then {
    [_veh] spawn OKS_fnc_Mechanized;
} else {
    [_veh, "medium"] call GW_MHQ_Fnc_Handler;
    [_veh] spawn OKS_fnc_Mechanized;
};

deleteVehicle _logic;
