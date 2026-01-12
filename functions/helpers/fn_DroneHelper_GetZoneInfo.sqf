/*
	OKS_fnc_DroneHelper_GetZoneInfo

	Extracts zone center position and radius from various zone types (marker, trigger, position).
	Handles automatic radius detection from markers and triggers.

	Parameters:
		0: STRING/OBJECT/ARRAY - Zone identifier (marker name, trigger object, or position)
		1: NUMBER - Fallback radius if zone type doesn't define one (default: 750)

	Returns:
		ARRAY - [centerPositionATL, radiusMeters]
			centerPositionATL: ARRAY - Zone center as [x,y,z]
			radiusMeters: NUMBER - Zone radius in meters

	Example:
		private _info = ["targetMarker", 1000] call OKS_fnc_DroneHelper_GetZoneInfo;
		_info params ["_center", "_radius"];
*/

params [
	["_zoneValue", "", ["", [], objNull]],
	["_fallbackRadiusMeters", 750, [0]]
];

private _centerPositionATL = [0,0,0];
private _radiusMeters = _fallbackRadiusMeters;

// Marker: use marker position and size
if (_zoneValue isEqualType "" && {_zoneValue != ""}) then {
	_centerPositionATL = getMarkerPos _zoneValue;
	private _markerSize = getMarkerSize _zoneValue;
	_radiusMeters = (_markerSize select 0) max (_markerSize select 1);
};

// Trigger: use trigger position and area
if (_zoneValue isEqualType objNull && {!isNull _zoneValue} && {_zoneValue isKindOf "EmptyDetector"}) then {
	_centerPositionATL = getPosATL _zoneValue;
	private _triggerArea = triggerArea _zoneValue;
	if (_triggerArea isEqualType [] && {(count _triggerArea) >= 2}) then {
		_radiusMeters = (_triggerArea select 0) max (_triggerArea select 1);
	};
};

// Position array: use as-is
if (_zoneValue isEqualType []) then {
	_centerPositionATL = [_zoneValue] call OKS_fnc_DroneHelper_NormalizePos;
};

[_centerPositionATL, _radiusMeters]
