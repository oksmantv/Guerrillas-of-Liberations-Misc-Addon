/*
	OKS_fnc_EdenAirScout

	Eden helper for OKS_fnc_AirScout.
	- Requires selecting a flying rotary airframe (helicopter or rotary UAV)
	- Right-click terrain to choose loiter/target position
	- Ensures the selected airframe has a unique variable name
	- Creates a target helper logic at the clicked position
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

private _ensureNamed = {
	params ["_entity", "_namePrefix"];
	private _n = (_entity get3DENAttribute "name") select 0;
	if (_n isEqualTo "") then {
		_n = [_namePrefix] call OKS_fnc_next3DENName;
		_entity set3DENAttribute ["name", _n];
	};
	_n
};

private _createLogic = {
	params ["_namePrefix", "_pos"];
	private _p = [_pos] call OKS_fnc_EdenSanitizePos;
	if (_p isEqualTo []) then { _p = [0, 0, 0]; };
	_p set [2, 0];

	private _obj = create3DENEntity ["Logic", "Logic", _p];
	if (isNull _obj) exitWith {""};

	private _n = [_namePrefix] call OKS_fnc_next3DENName;
	_obj set3DENAttribute ["name", _n];
	_n
};

// Validate selected rotary airframe.
private _airObj = objNull;
{
	if (_x isKindOf "Air") exitWith { _airObj = _x; };
} forEach _contextObjects;

if (isNull _airObj) exitWith {
	["Air Scout: You must select an airframe", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

private _isRotary = (_airObj isKindOf "Helicopter") || ((_airObj isKindOf "UAV") && {!(_airObj isKindOf "Plane")});

if (!_isRotary) exitWith {
	["Air Scout: Selected airframe must be a flying rotary airframe (helicopter/rotary UAV)", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

private _p0 = [_contextObjects, _md] call _anchorPos;
if (_p0 isEqualTo []) exitWith {
	(format ["[3DEN] Air Scout: invalid click position. menuData=%1", _md]) call OKS_fnc_LogDebug;
	["Air Scout: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

private _airName = [_airObj, "AirScout"] call _ensureNamed;
private _targetName = ["AirScoutTarget", _p0] call _createLogic;

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
	_airName,
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
	"[3DEN] Air Scout copied: Air=%1 | Target=%2 | Side=%3 | Class=%4 | WP=LOITER | Careless=false | Spot=%5 | Fly=%6 | Mortars=%7",
	_airName,
	_targetName,
	_sideStr,
	_classStr,
	_spottingStr,
	_flyingStr,
	_mortarsStr
];

copyToClipboard _example;
[format ["CopiedToClipboard: %1\n%2", _desc, _example], true] call OKS_fnc_LogDebug;
[_desc, 0, 5, true] call BIS_fnc_3DENNotification;
true;
