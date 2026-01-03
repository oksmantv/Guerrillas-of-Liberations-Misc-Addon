/*
	OKS_fnc_EdenDroneHuntZone

	Eden helper for OKS_fnc_DroneHuntZone.	
	- Right-click terrain to choose drone spawn position
	- Creates a named ground helper logic for spawn position
	- Creates a nearby trigger (EmptyDetector) used as the target zone
	- Uses GW global side selection (uiNamespace GW_FRAMEWORK_GLOBAL_SIDE)
	- Copies a spawnList-ready OKS_fnc_DroneHuntZone call to clipboard

	Usage from CfgEden:
	  (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenDroneHuntZone;
*/

params [
	"_menuData"
];

private _md = if (_menuData isEqualType []) then { _menuData } else { [] };

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

private _anchorPositionATL = {
	params ["_md"];
	private _positionATL = [];

	// Some Eden contexts pass menuData as [x,y,z] directly.
	if (_md isEqualType []) then {
		_positionATL = [_md] call OKS_fnc_EdenPosFromArray;
	};

	// Other contexts pass menuData as [[x,y,z], <entity>, ...] or [<entity>, ...].
	if (_positionATL isEqualTo []) then {
		private _menuDataFirst = _md param [0, []];
		if (_menuDataFirst isEqualType objNull) then {
			if (!isNull _menuDataFirst) then { _positionATL = getPosATL _menuDataFirst; };
		} else {
			if (_menuDataFirst isEqualType []) then { _positionATL = [_menuDataFirst] call OKS_fnc_EdenPosFromArray; };
		};
	};

	if (_positionATL isEqualTo []) then {
		_positionATL = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray;
	};

	_positionATL set [2, 0];
	_positionATL = [_positionATL] call OKS_fnc_EdenSanitizePos;
	if (_positionATL isEqualTo []) exitWith { [] };
	_positionATL
};

private _offsetPositionFromATL = {
	params ["_positionATL", "_distanceMeters", "_directionDegrees"];
	private _offsetPositionATL = +_positionATL;
	if ((count _offsetPositionATL) < 2) exitWith { [] };
	if ((count _offsetPositionATL) == 2) then { _offsetPositionATL pushBack 0; };
	_offsetPositionATL set [
		0,
		(_offsetPositionATL select 0) + (sin _directionDegrees) * _distanceMeters
	];
	_offsetPositionATL set [
		1,
		(_offsetPositionATL select 1) + (cos _directionDegrees) * _distanceMeters
	];
	_offsetPositionATL set [2, 0];
	[_offsetPositionATL] call OKS_fnc_EdenSanitizePos
};

private _sideToString = {
	params ["_side"];
	if (_side isEqualTo west) exitWith {"west"};
	if (_side isEqualTo east) exitWith {"east"};
	if (_side isEqualTo independent) exitWith {"independent"};
	if (_side isEqualTo civilian) exitWith {"civilian"};
	"west"
};

private _sideFromGWGlobalSelection = {
	private _sideString = toUpper (uiNamespace getVariable ["GW_FRAMEWORK_GLOBAL_SIDE", "WEST"]);
	switch (_sideString) do {
		case "EAST": { east };
		case "INDEPENDENT": { independent };
		case "GUER": { independent };
		default { west };
	}
};

private _createLogicAt = {
	params ["_positionATL", "_namePrefix"];

	private _sanitizedPositionATL = [_positionATL] call OKS_fnc_EdenSanitizePos;
	if (_sanitizedPositionATL isEqualTo []) then { _sanitizedPositionATL = [0, 0, 0]; };
	_sanitizedPositionATL set [2, 0];

	private _logicObject = create3DENEntity ["Logic", "Logic", _sanitizedPositionATL];
	if (isNull _logicObject) exitWith { [objNull, ""] };

	private _logicName = [_namePrefix] call OKS_fnc_next3DENName;
	_logicObject set3DENAttribute ["name", _logicName];
	[_logicObject, _logicName]
};

private _createTriggerAt = {
	params ["_positionATL", "_namePrefix", ["_radiusMeters", 750, [0]]];

	private _sanitizedPositionATL = [_positionATL] call OKS_fnc_EdenSanitizePos;
	if (_sanitizedPositionATL isEqualTo []) then { _sanitizedPositionATL = [0, 0, 0]; };
	_sanitizedPositionATL set [2, 0];

	private _triggerObject = create3DENEntity ["Trigger", "EmptyDetector", _sanitizedPositionATL];
	if (isNull _triggerObject) exitWith { [objNull, ""] };

	private _triggerName = [_namePrefix] call OKS_fnc_next3DENName;
	_triggerObject set3DENAttribute ["name", _triggerName];

	// Allow resizing in Eden; OKS_fnc_DroneHuntZone will read trigger radius at runtime.
	_triggerObject set3DENAttribute ["size3", [_radiusMeters, _radiusMeters, 0]];
	_triggerObject set3DENAttribute ["IsRectangle", false];

	[_triggerObject, _triggerName]
};

private _spawnPositionATL = [_md] call _anchorPositionATL;
if (_spawnPositionATL isEqualTo []) exitWith {
	["Drone Hunt Zone: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

private _createdSpawnLogic = [_spawnPositionATL, "DroneSpawn"] call _createLogicAt;
private _spawnLogicObject = _createdSpawnLogic select 0;
private _spawnLogicName = _createdSpawnLogic select 1;

if (isNull _spawnLogicObject || {_spawnLogicName isEqualTo ""}) exitWith {
	["Drone Hunt Zone: Failed to create spawn helper", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

// Place zone trigger near the spawn logic so it is easy to grab/move in Eden.
private _zoneTriggerPositionATL = [_spawnPositionATL, 25, 90] call _offsetPositionFromATL;
if (_zoneTriggerPositionATL isEqualTo []) then {
	_zoneTriggerPositionATL = [_spawnPositionATL, 25, 0] call _offsetPositionFromATL;
};

private _createdZoneTrigger = [_zoneTriggerPositionATL, "DroneHuntZone", 750] call _createTriggerAt;
private _zoneTriggerObject = _createdZoneTrigger select 0;
private _zoneTriggerName = _createdZoneTrigger select 1;

if (isNull _zoneTriggerObject || {_zoneTriggerName isEqualTo ""}) exitWith {
	["Drone Hunt Zone: Failed to create zone trigger", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

private _side = call _sideFromGWGlobalSelection;
private _sideString = [_side] call _sideToString;

// Drone classname left as "" so per-side CBA option is used.
private _example = format [
	"null = [%1, %2, """" , %3] spawn OKS_fnc_DroneHuntZone;",
	_spawnLogicName,
	_zoneTriggerName,
	_sideString
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
["OKS_fnc_EdenDroneHuntZone", [], [_spawnLogicObject, _zoneTriggerObject]] call OKS_fnc_EdenRememberLastAction;

private _description = format [
	"[3DEN] Drone Hunt Zone copied to clipboard: Spawn=%1 | Zone=%2 | Side=%3",
	_spawnLogicName,
	_zoneTriggerName,
	_sideString
];

if (_debug3DEN) then {
	[format ["[3DEN] EdenDroneHuntZone | %1", _description], false, true] call OKS_fnc_LogDebug;
};

systemChat _description;
true
