/*
    OKS_fnc_LaserMarker_Create

    Server-side shared marker creation. Markers are created in the operator's
    side channel, making them visible to every player on that side.
*/

if (!isServer) exitWith {};

params [
    ["_operator", objNull, [objNull]],
    ["_vehicle", objNull, [objNull]],
    ["_impactASL", [], [[]]]
];

if (isNull _operator || {isNull _vehicle} || {!alive _operator}) exitWith {};
if !((vehicle _operator) isEqualTo _vehicle) exitWith {};
if !(_vehicle isKindOf "Air") exitWith {};
if (_impactASL isEqualTo [] || {(count _impactASL) < 3}) exitWith {};

private _isDriver = (driver _vehicle) isEqualTo _operator;
private _vehicleRole = assignedVehicleRole _operator;
private _turretPath = if (_isDriver) then { [-1] } else { _vehicleRole param [1, []] };
if (!_isDriver && {_turretPath isEqualTo []}) exitWith {};
private _laserWeapons = if (_isDriver) then {
    weapons _vehicle
} else {
    _vehicle weaponsTurret _turretPath
};
private _laserWeaponAvailable = _laserWeapons findIf {
    ((toLower _x) find "laserdesignator") > -1
};

private _validImpact = (getPosASL _vehicle distance _impactASL) <= 12000;
if (_laserWeaponAvailable isNotEqualTo -1) then {
    private _laserTarget = laserTarget _vehicle;
    if (!isNull _laserTarget && {(_impactASL distance (getPosASL _laserTarget)) <= 100}) then {
        _validImpact = true;
    };
};
if (!_validImpact) exitWith {};

private _nextId = missionNamespace getVariable ["OKS_LaserMarker_NextId", 0];
_nextId = _nextId + 1;
missionNamespace setVariable ["OKS_LaserMarker_NextId", _nextId];

private _impactATL = ASLToATL _impactASL;
private _operatorSide = side group _operator;
private _target = objNull;
{
    private _candidateSide = side _x;
    if (
        alive _x
        && {_candidateSide isNotEqualTo civilian}
        && {_candidateSide isNotEqualTo _operatorSide}
    ) exitWith {
        _target = _x;
    };
} forEach (nearestObjects [_impactATL, ["Man", "LandVehicle", "Air", "Ship"], 35]);

private _targetSide = if (isNull _target) then {
    switch (_operatorSide) do {
        case west: { east };
        case east: { west };
        default { east };
    };
} else {
    side _target
};
private _markerPrefix = switch (_targetSide) do {
    case west: { "b" };
    case east: { "o" };
    case independent: { "n" };
    default { "o" };
};
private _markerSuffix = if (isNull _target) then {
    "unknown"
} else {
    if (_target isKindOf "Man") then {
        "inf"
    } else {
        if (_target isKindOf "Air") then {
            "air"
        } else {
            if (_target isKindOf "Ship") then {
                "naval"
            } else {
                if (_target isKindOf "Tank") then {
                    "armor"
                } else {
                    if (_target isKindOf "Car") then {
                        "motor_inf"
                    } else {
                        "unknown"
                    };
                };
            };
        };
    };
};
private _markerType = format ["%1_%2", _markerPrefix, _markerSuffix];
private _markerColor = switch (_targetSide) do {
    case west: { "ColorWEST" };
    case east: { "ColorEAST" };
    case independent: { "ColorGUER" };
    default { "ColorEAST" };
};

private _markerName = format ["GOL_Lase_%1_%2", _nextId, floor (diag_tickTime * 1000)];
private _marker = createMarker [_markerName, _impactATL, 1, _operator];
_marker setMarkerShape "ICON";
_marker setMarkerType _markerType;
_marker setMarkerColor _markerColor;
_marker setMarkerSize [0.8, 0.8];
_marker setMarkerAlpha 1;
_marker setMarkerText toUpper _markerSuffix;

private _expiry = missionNamespace getVariable ["GOL_LaserMarker_Expiry", 900];
if (_expiry > 0) then {
    [_marker, _expiry] spawn {
        params ["_marker", "_expiry"];
        sleep _expiry;
        deleteMarker _marker;
    };
};
