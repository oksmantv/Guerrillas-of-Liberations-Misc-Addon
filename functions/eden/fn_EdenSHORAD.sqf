/*
	OKS_fnc_EdenSHORAD

	Eden helper for OKS_fnc_SHORAD.
	- Requires a selected/clicked SHORAD vehicle (validation)
	- Copies a spawnList-ready OKS_fnc_SHORAD call to clipboard

	Usage from CfgEden:
	  [(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), "medium", 4, 10] call OKS_fnc_EdenSHORAD;
*/

private _args = _this;
if !(_args isEqualType []) then { _args = [_args]; };

_args params [
	["_menuData", [], [[], objNull]],
	["_missileType", "medium", [""]],
	["_ammo", 4, [0]],
	["_reloadTime", 10, [0]]
];

if (_menuData isEqualType objNull) then {
	_menuData = [_menuData];
};

private _md = if (_menuData isEqualType []) then {_menuData} else {[]};

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

private _anchorPos = {
	params ["_objs", "_md"];
	private _p = [];

	if (_md isEqualType []) then {
		_p = [_md] call OKS_fnc_EdenPosFromArray;
	};

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

	if (_p isEqualTo []) then { _p = [screenToWorld getMousePosition] call OKS_fnc_EdenPosFromArray; };
	_p set [2, 0];
	_p = [_p] call OKS_fnc_EdenSanitizePos;
	if (_p isEqualTo []) exitWith {[]};
	_p
};

private _selectedObjects = get3DENSelected "object";

private _md0 = _md param [0, objNull];
private _clickedObj = if (_md0 isEqualType objNull && {!isNull _md0}) then {_md0} else {objNull};
private _contextObjects = +_selectedObjects;
if (!isNull _clickedObj && { !(_clickedObj in _contextObjects) }) then {
	_contextObjects pushBack _clickedObj;
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

private _layer = ["SHORAD", "OKS Eden - Support Helpers"] call OKS_fnc_EdenGetOrCreateLayer;

// --- Find SHORAD vehicle among selected objects ---
private _shoradObj = objNull;
{
	if (_x isKindOf "AllVehicles") then {
		if (isNull _shoradObj) then { _shoradObj = _x; };
	};
} forEach _contextObjects;

if (isNull _shoradObj) exitWith {
	["SHORAD: No vehicle selected", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

private _shoradName = [_shoradObj, "SHORAD"] call _ensureNamed;

private _example = format [
	"null = [%1,""%2"",%3,%4] spawn OKS_fnc_SHORAD;",
	_shoradName,
	_missileType,
	_ammo,
	_reloadTime
];

private _desc = format [
	"SHORAD copied to clipboard: Vehicle=%1 | Type=%2 | Ammo=%3 | Reload=%4s",
	_shoradName,
	_missileType,
	_ammo,
	_reloadTime
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenSHORAD", [_missileType, _ammo, _reloadTime], []] call OKS_fnc_EdenRememberLastAction;
private _chatText = format ["CopiedToClipboard | SHORAD copied to clipboard | Cache=%1", _cacheCount];
systemChat _chatText;

private _logExample = _example splitString "\r\n" joinString " ";
private _logText = format ["CopiedToClipboard | SHORAD copied to clipboard | Cache=%1 | %2", _cacheCount, _logExample];
[_logText, false, true, true] call OKS_fnc_LogDebug;
if (_debug3DEN) then {
	[format ["SHORAD | %1", _desc], false, true, true] call OKS_fnc_LogDebug;
};

private _notify = if (_debug3DEN) then {_desc} else {"SHORAD copied to clipboard"};
_notify = format ["%1 | Cache=%2", _notify, _cacheCount];
[_notify, 0, 10, true] call BIS_fnc_3DENNotification;
true;
