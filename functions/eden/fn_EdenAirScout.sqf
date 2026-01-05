/*
	OKS_fnc_EdenAirScout

	Eden helper for OKS_fnc_AirScout.
	- Requires selecting an airframe (helicopter/plane/UAV)
	- Right-click terrain to choose loiter/target position
	- Creates a named ground helper logic for spawn position
	- Creates a target helper logic at the clicked position
	- Deletes the selected Eden airframe (and any placed crew) after copy
	- Copies a spawnList-ready OKS_fnc_AirScout call to clipboard

	Usage from CfgEden:
	  [(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), east] call OKS_fnc_EdenAirScout;
*/

params [
	"_menuData",
	["_side", sideUnknown, [sideUnknown]],
	["_shouldCallMortars", true, [false]]
];

private _md = if (_menuData isEqualType []) then {_menuData} else {[]};

if (missionNamespace getVariable ["OKS_3DEN_DEBUG", false]) then {
	["[3DEN] EdenAirScout: action fired", 0, 2, true] call BIS_fnc_3DENNotification;
};

private _selectedObjects = get3DENSelected "object";

// Some Eden context menus pass a clicked entity even when not selected.
private _md0 = _md param [0, objNull];
private _clickedObj = if (_md0 isEqualType objNull && {!isNull _md0}) then {_md0} else {objNull};
private _contextObjects = +_selectedObjects;
if (!isNull _clickedObj && { !(_clickedObj in _contextObjects) }) then {
	_contextObjects pushBack _clickedObj;
};

private _sideToString = {
	params ["_s"];
	if (_s isEqualTo west) exitWith {"west"};
	if (_s isEqualTo east) exitWith {"east"};
	if (_s isEqualTo independent) exitWith {"independent"};
	if (_s isEqualTo civilian) exitWith {"civilian"};
	"east"
};

private _sideFrom3DENAttribute = {
	params ["_obj"];
	private _attr = (_obj get3DENAttribute "side") param [0, -1];
	if (_attr isEqualType 0) then {
		switch (_attr) do {
			case 0: { east };
			case 1: { west };
			case 2: { independent };
			case 3: { civilian };
			default { sideUnknown };
		};
	} else {
		sideUnknown
	};
};

private _anchorPos = {
	params ["_objs", "_md"];
	private _p = [];

	// Some Eden contexts pass menuData as [x,y,z] directly.
	if (_md isEqualType []) then {
		_p = [_md] call OKS_fnc_EdenPosFromArray;
	};

	// Other contexts pass menuData as [[x,y,z], <entity>, ...] or [<entity>, ...].
	if (_p isEqualTo []) then {
		private _md0 = _md param [0, []];
		if (_md0 isEqualType objNull) then {
			if (!isNull _md0) then { _p = getPosATL _md0; };
		} else {
			if (_md0 isEqualType []) then { _p = [_md0] call OKS_fnc_EdenPosFromArray; };
		};
	};

	if (_p isEqualTo [] && {!(_objs isEqualTo [])}) then {
		_p = getPosATL (_objs select 0);
	};

	if (_p isEqualTo []) then { _p = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray; };
	_p set [2, 0];
	_p = [_p] call OKS_fnc_EdenSanitizePos;
	if (_p isEqualTo []) exitWith {[]};
	_p
};

private _offsetPosFrom = {
	params ["_pos", "_dist", "_dirDeg"];
	private _p = +_pos;
	if ((count _p) < 2) exitWith {[]};
	if ((count _p) == 2) then { _p pushBack 0; };
	_p set [
		0,
		(_p select 0) + (sin _dirDeg) * _dist
	];
	_p set [
		1,
		(_p select 1) + (cos _dirDeg) * _dist
	];
	_p set [2, 0];
	[_p] call OKS_fnc_EdenSanitizePos
};

private _ensureNamed = {
	params ["_entity", "_namePrefix"];
	private _n = (_entity get3DENAttribute "name") select 0;
	if (_n isEqualTo "") then {
		_n = [_namePrefix] call OKS_fnc_next3DENName;
		_entity set3DENAttribute ["name", _n];
	};
	_n
};

private _layer = ["Air Scout", "OKS Eden - Spawn Helpers"] call OKS_fnc_EdenGetOrCreateLayer;

private _createLogic = {
	params ["_namePrefix", "_pos"];
	private _p = [_pos] call OKS_fnc_EdenSanitizePos;
	if (_p isEqualTo []) then { _p = [0, 0, 0]; };
	_p set [2, 0];

	private _obj = create3DENEntity ["Logic", "Logic", _p];
	if (isNull _obj) exitWith {""};
	if (!isNil "_layer") then { [_obj, _layer] call OKS_fnc_EdenSetLayerSafe; };

	private _n = [_namePrefix] call OKS_fnc_next3DENName;
	_obj set3DENAttribute ["name", _n];
	_n
};

private _isAirframe = {
	params ["_obj"];
	if (isNull _obj) exitWith {false};
	private _cfg = configFile >> "CfgVehicles" >> typeOf _obj;
	(_obj isKindOf "Air")
	|| {_obj isKindOf "UAV"}
	|| {getNumber (_cfg >> "isUav") isEqualTo 1}
	|| {getNumber (_cfg >> "uavCamera") > 0}
};

// Validate selected airframe (supports mod UAVs like Pchela).
private _airObj = objNull;
{
	if ([_x] call _isAirframe) exitWith { _airObj = _x; };
} forEach _contextObjects;

if (isNull _airObj) exitWith {
	["Air Scout: You must select an airframe (helicopter/plane/UAV)", 1, 6, true] call BIS_fnc_3DENNotification;
	if (missionNamespace getVariable ["OKS_3DEN_DEBUG", false]) then {
		[format ["[3DEN] Air Scout: selection types=%1", (_contextObjects apply {typeOf _x})], false, true] call OKS_fnc_LogDebug;
	};
	false
};

private _p0 = [_contextObjects, _md] call _anchorPos;
if (_p0 isEqualTo []) exitWith {
	if (missionNamespace getVariable ["OKS_3DEN_DEBUG", false]) then {
		[format ["[3DEN] Air Scout: invalid click position. menuData=%1", _md], false, true] call OKS_fnc_LogDebug;
	};
	["Air Scout: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

private _spawnPos = getPosATL _airObj;
_spawnPos set [2, 0];

private _spawnName = ["AirScout", _spawnPos] call _createLogic;

// If the click lands on top of the spawn position (common when right-clicking the airframe),
// offset the target helper so both are easy to grab/move.
private _targetPos = _p0;
if ((_targetPos distance2D _spawnPos) < 2) then {
	private _dir = getDir _airObj;
	private _tp = ([_spawnPos, 25, _dir] call _offsetPosFrom);
	if !(_tp isEqualTo []) then {
		_targetPos = _tp;
	};
};

private _targetName = ["AirScoutTarget", _targetPos] call _createLogic;

if (_spawnName isEqualTo "") exitWith {
	["Air Scout: Failed to create spawn helper", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

if (_targetName isEqualTo "") exitWith {
	["Air Scout: Failed to create target helper", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

private _resolvedSide = _side;
if (_resolvedSide isEqualTo sideUnknown) then {
	_resolvedSide = side _airObj;
};
if (_resolvedSide isEqualTo sideUnknown) then {
	_resolvedSide = [_airObj] call _sideFrom3DENAttribute;
};
if (_resolvedSide isEqualTo sideUnknown) then {
	_resolvedSide = east;
};

private _sideStr = [ _resolvedSide ] call _sideToString;
private _classStr = str (typeOf _airObj);

// Defaults kept simple; adjust after paste if needed.
private _behaviourStr = str ["LOITER", false];
private _spottingStr = str [500, 4];
private _flyingStr = str [250, 500];
private _loadoutStr = "nil";
private _mortarsStr = if (_shouldCallMortars) then {"true"} else {"false"};

private _example = format [
	"null = [getPos %1,getPos %2,%3,%4,%5,%6,%7,%8,%9] spawn OKS_fnc_AirScout;",
	_spawnName,
	_targetName,
	_sideStr,
	_classStr,
	_behaviourStr,
	_spottingStr,
	_flyingStr,
	_loadoutStr,
	_mortarsStr
];

private _desc = format [
	"[3DEN] Air Scout copied to clipboard: Spawn=%1 | Target=%2 | Side=%3 | Class=%4 | Mortars=%5",
	_spawnName,
	_targetName,
	_sideStr,
	_classStr,
	_mortarsStr
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenAirScout", [_side, _shouldCallMortars], _contextObjects] call OKS_fnc_EdenRememberLastAction;

// Remove the Eden airframe and any placed crew (the script spawns its own).
private _crewToDelete = (crew _airObj) select { _x isKindOf "Man" };
private _toDelete = [];
if !(_crewToDelete isEqualTo []) then { _toDelete append _crewToDelete; };
_toDelete pushBack _airObj;
if (!(uiNamespace getVariable ["OKS_3DEN_IS_REPEAT", false])) then {
	delete3DENEntities _toDelete;
};

private _deletedCrewCount = count _crewToDelete;
private _desc2 = if (_deletedCrewCount > 0) then {
	format ["%1 | DeletedAirframe=1 | DeletedCrew=%2", _desc, _deletedCrewCount]
} else {
	format ["%1 | DeletedAirframe=1", _desc]
};

private _debug = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];
private _chatText = format ["CopiedToClipboard | Air Scout copied to clipboard | Cache=%1", _cacheCount];
systemChat _chatText;

private _logExample = _example splitString "\r\n" joinString " ";
private _logText = format ["CopiedToClipboard | Air Scout copied to clipboard | Cache=%1 | %2", _cacheCount, _logExample];
[_logText, false, true, true] call OKS_fnc_LogDebug;
if (_debug) then {
	[format ["Air Scout | %1", _desc2], false, true, true] call OKS_fnc_LogDebug;
};

private _notify = if (_debug) then {_desc2} else {"Air Scout copied to clipboard"};
_notify = format ["%1 | Cache=%2", _notify, _cacheCount];
[_notify, 0, 10, true] call BIS_fnc_3DENNotification;
true;
