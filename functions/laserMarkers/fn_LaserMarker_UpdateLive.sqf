/*
    OKS_fnc_LaserMarker_UpdateLive

    Client-side update for the live laser-search drawing. The source operator
    remote-executes this only to player crew in the same aircraft, so no outside
    players can see the transient source icon, turret-aim/range line, or
    aircraft-heading line.
*/

if (!hasInterface) exitWith {};

params [
    ["_vehicle", objNull, [objNull]],
    ["_impactASL", [], [[]]],
    ["_sourceATL", [], [[]]],
    ["_groundRange", 0, [0]],
    ["_turretBearing", 0, [0]],
    ["_vehicleHeading", 0, [0]],
    ["_minimumHeadingLength", 5000, [0]],
    ["_isActive", false, [true]]
];

if (isNull _vehicle) exitWith {};

private _id = netId _vehicle;
if (_id isEqualTo "") then {
    _id = str _vehicle;
};
private _baseName = format ["GOL_LaseLive_%1", _id];
private _sourceName = format ["%1_Source", _baseName];
private _aimDotName = format ["%1_Dot", _baseName];
private _rangeLineName = format ["%1_Range", _baseName];
private _bearingLineName = format ["%1_Bearing", _baseName];

private _trackedVehicles = missionNamespace getVariable ["OKS_LaserMarker_VisibleVehicles", []];
if (!_isActive || {!(_vehicle isKindOf "Air")} || {!(player in (crew _vehicle))}) exitWith {
    deleteMarkerLocal _baseName;
    deleteMarkerLocal _sourceName;
    deleteMarkerLocal _aimDotName;
    deleteMarkerLocal _rangeLineName;
    deleteMarkerLocal _bearingLineName;
    _trackedVehicles = _trackedVehicles - [_vehicle];
    missionNamespace setVariable ["OKS_LaserMarker_VisibleVehicles", _trackedVehicles];
};

if (_impactASL isEqualTo [] || {(count _impactASL) < 3} || {_sourceATL isEqualTo []} || {(count _sourceATL) < 2}) exitWith {};

private _positionATL = ASLToATL _impactASL;
private _sourceMarkerColor = switch (side player) do {
    case west: { "ColorWEST" };
    case east: { "ColorEAST" };
    case independent: { "ColorGUER" };
    default { "ColorCivilian" };
};

_groundRange = _groundRange max 0;
_turretBearing = _turretBearing mod 360;
_vehicleHeading = _vehicleHeading mod 360;
private _headingLength = _groundRange max 50;
private _headingEndATL = _sourceATL getPos [_headingLength, _vehicleHeading];

if ((markerShape _baseName) isEqualTo "") then {
    createMarkerLocal [_baseName, _positionATL];
    _baseName setMarkerShapeLocal "ICON";
    _baseName setMarkerColorLocal "ColorGreen";
};

if ((markerShape _sourceName) isEqualTo "") then {
    createMarkerLocal [_sourceName, _sourceATL];
    _sourceName setMarkerShapeLocal "ICON";
};

if ((markerShape _aimDotName) isEqualTo "") then {
    createMarkerLocal [_aimDotName, _positionATL];
    _aimDotName setMarkerShapeLocal "ICON";
    _aimDotName setMarkerTypeLocal "mil_dot";
    _aimDotName setMarkerColorLocal "ColorGreen";
    _aimDotName setMarkerSizeLocal [0.7, 0.7];
};

if ((markerShape _rangeLineName) isEqualTo "") then {
    createMarkerLocal [_rangeLineName, _sourceATL];
    _rangeLineName setMarkerShapeLocal "POLYLINE";
    _rangeLineName setMarkerColorLocal "ColorGreen";
    _rangeLineName setMarkerSizeLocal [0.1, 0.1];
};

if ((markerShape _bearingLineName) isEqualTo "") then {
    createMarkerLocal [_bearingLineName, _sourceATL];
    _bearingLineName setMarkerShapeLocal "POLYLINE";
    _bearingLineName setMarkerSizeLocal [0.1, 0.1];
};

_baseName setMarkerPosLocal _positionATL;
_baseName setMarkerTextLocal format ["   | %1 km | %2°", (_groundRange / 1000) toFixed 1, round _turretBearing];
_baseName setMarkerTypeLocal "selector_selectedEnemy";
_baseName setMarkerSizeLocal [0.8, 0.8];
_baseName setMarkerDirLocal 0;
_aimDotName setMarkerPosLocal _positionATL;
_aimDotName setMarkerSizeLocal [0.7, 0.7];
_sourceName setMarkerPosLocal _headingEndATL;
_sourceName setMarkerTypeLocal "selector_selectable";
_sourceName setMarkerColorLocal _sourceMarkerColor;
_sourceName setMarkerTextLocal format ["   | %1 km | %2°", (_groundRange / 1000) toFixed 1, round _vehicleHeading];
_sourceName setMarkerSizeLocal [0.8, 0.8];
_sourceName setMarkerDirLocal _vehicleHeading;
_bearingLineName setMarkerColorLocal _sourceMarkerColor;
_bearingLineName setMarkerPolylineLocal [
    _sourceATL # 0,
    _sourceATL # 1,
    _headingEndATL # 0,
    _headingEndATL # 1
];
// Update the heading first. If the aircraft and turret share a bearing, the
// green aim line remains visible above the side-coloured heading line.
_rangeLineName setMarkerPolylineLocal [
    _sourceATL # 0,
    _sourceATL # 1,
    _positionATL # 0,
    _positionATL # 1
];
_trackedVehicles pushBackUnique _vehicle;
missionNamespace setVariable ["OKS_LaserMarker_VisibleVehicles", _trackedVehicles];
