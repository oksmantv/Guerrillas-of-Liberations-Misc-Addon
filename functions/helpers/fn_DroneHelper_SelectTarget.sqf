/*
	OKS_fnc_DroneHelper_SelectTarget
	
	Scans for hostile targets within a zone with priority-based selection.
	priority: Armored vehicles > land vehicles > Infantry/Static weapons
	
	Parameters:
	0: OBJECT - Drone vehicle doing the scanning
	1: ARRAY - Zone center position ATL [x, y, z]
	2: NUMBER - Zone radius in meters
	3: side - Drone side (for friend/foe detection)
	4: OBJECT - (Optional) Zone trigger object for precise area filtering (default: objNull)
	
	Returns:
	OBJECT - Selected hostile target, or objNull if none found
	
	Example:
	private _target = [_droneVehicle, _zoneCenterATL, 1000, east] call OKS_fnc_DroneHelper_SelectTarget;
	private _target = [_droneVehicle, _zoneCenterATL, 1000, east, _zoneTrigger] call OKS_fnc_DroneHelper_SelectTarget;
*/

params [
	["_droneVehicle", objNull, [objNull]],
	["_zoneCenterPositionATL", [0, 0, 0], [[]]],
	["_zoneRadiusMeters", 750, [0]],
	["_droneSide", east, [sideUnknown]],
	["_zoneTriggerObject", objNull, [objNull]]
];

private _filterHostile = {
	params ["_candidateObjects", "_droneSide", "_zoneTriggerObject"];
	_candidateObjects select {
		alive _x
		&& {
			side _x != sideLogic
		}
		&& {
			(_droneSide getFriend side _x) < 0.6
		}
		&& {
			isNull _zoneTriggerObject || {
				_x inArea _zoneTriggerObject
			}
		}
	}
};

private _targetCandidates = [];

// priority 1: Armored vehicles
private _armoredCandidatesAll = (_zoneCenterPositionATL nearEntities [["Tank", "Wheeled_APC_F", "APC_Tracked_01_base_F", "APC_Tracked_02_base_F"], _zoneRadiusMeters]);
_targetCandidates = [_armoredCandidatesAll, _droneSide, _zoneTriggerObject] call _filterHostile;
if !(_targetCandidates isEqualTo []) exitWith {
	selectRandom _targetCandidates
};

// priority 2: Any land vehicle
private _landVehicleCandidatesAll = (_zoneCenterPositionATL nearEntities [["LandVehicle"], _zoneRadiusMeters]);
_targetCandidates = [_landVehicleCandidatesAll, _droneSide, _zoneTriggerObject] call _filterHostile;
if !(_targetCandidates isEqualTo []) exitWith {
	selectRandom _targetCandidates
};

// priority 3: Infantry and static weapons
private _infantryCandidatesAll = (_zoneCenterPositionATL nearEntities [["Man", "StaticWeapon"], _zoneRadiusMeters]);
_targetCandidates = [_infantryCandidatesAll, _droneSide, _zoneTriggerObject] call _filterHostile;
if !(_targetCandidates isEqualTo []) exitWith {
	selectRandom _targetCandidates
};

objNull