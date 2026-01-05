/*
	OKS_fnc_EdenAirSpawn

	Eden helper for OKS_fnc_AirSpawn.
	- Select one or more airframes (helicopter/plane/UAV)
	- Right-click terrain to choose target/strike position
	- Creates a named helper logic for spawn position: AirSpawnPosition_X
	- Creates a named helper logic at the clicked position: AirSpawnTarget_X
	- Copies an OKS_fnc_AirSpawn call to clipboard with:
		- AirSpawnPosition_X as spawn position
		- AirSpawnTarget_X as waypoint/target
		- The selected airframes exported as templates including pylon magazines
		- Side defaulted to the copied side (first selected airframe)

	Usage from CfgEden:
	  [(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data')] call OKS_fnc_EdenAirSpawn;
*/

// Support two calling conventions:
// 1) Raw: (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenAirSpawn;
//    In this case, _this IS the menuData array and may contain objects/positions.
// 2) Wrapped (preferred): [(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), <sideOverride>] call OKS_fnc_EdenAirSpawn;
//    In this case, _this is [menuData, side].
private _menuData = [];
private _sideOverride = sideUnknown;

if (_this isEqualType []) then {
	private _maybeMenuData = _this param [0, []];
	private _maybeSide = _this param [1, sideUnknown];

	if (_maybeMenuData isEqualType [] && { _maybeSide isEqualType sideUnknown }) then {
		// Wrapped convention.
		_menuData = _maybeMenuData;
		_sideOverride = _maybeSide;
	} else {
		// Raw convention.
		_menuData = _this;
		_sideOverride = sideUnknown;
	};
};

private _menuDataNormalized = if (_menuData isEqualType []) then {_menuData} else {[]};
private _selectedObjects = get3DENSelected "object";

private _isAirframe = {
	params ["_object"];
	if (isNull _object) exitWith {false};
	private _vehicleConfiguration = configFile >> "CfgVehicles" >> typeOf _object;
	(_object isKindOf "Air")
	|| {_object isKindOf "UAV"}
	|| {getNumber (_vehicleConfiguration >> "isUav") isEqualTo 1}
	|| {getNumber (_vehicleConfiguration >> "uavCamera") > 0}
};

private _selectedAirframes = _selectedObjects select {[_x] call _isAirframe};

if (_selectedAirframes isEqualTo []) exitWith {
	["AirSpawn: You must select one or more airframes", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

private _sideToString = {
	params ["_side"];
	if (_side isEqualTo west) exitWith {"west"};
	if (_side isEqualTo east) exitWith {"east"};
	if (_side isEqualTo independent) exitWith {"independent"};
	if (_side isEqualTo civilian) exitWith {"civilian"};
	"east"
};

private _sideFrom3DENAttribute = {
	params ["_object"];
	private _sideAttribute = (_object get3DENAttribute "side") param [0, -1];
	if (_sideAttribute isEqualType 0) then {
		switch (_sideAttribute) do {
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
	params ["_menuData", "_fallbackObject"];
	private _position = [];

	// Some Eden contexts pass menuData as [x,y,z] directly.
	if (_menuData isEqualType []) then {
		_position = [_menuData] call OKS_fnc_EdenPosFromArray;
	};

	// Other contexts pass menuData as [[x,y,z], <entity>, ...] or [<entity>, ...].
	if (_position isEqualTo []) then {
		private _firstMenuDataEntry = _menuData param [0, []];
		if (_firstMenuDataEntry isEqualType objNull) then {
			if (!isNull _firstMenuDataEntry) then { _position = getPosATL _firstMenuDataEntry; };
		} else {
			if (_firstMenuDataEntry isEqualType []) then { _position = [_firstMenuDataEntry] call OKS_fnc_EdenPosFromArray; };
		};
	};

	if (_position isEqualTo [] && {!isNull _fallbackObject}) then {
		_position = getPosATL _fallbackObject;
	};

	if (_position isEqualTo []) then { _position = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray; };
	_position set [2, 0];
	_position = [_position] call OKS_fnc_EdenSanitizePos;
	if (_position isEqualTo []) exitWith {[]};
	_position
};

private _layer = ["Air Spawn", "OKS Eden - Spawn Helpers"] call OKS_fnc_EdenGetOrCreateLayer;

private _createLogic = {
	params ["_namePrefix", "_position"];
	private _sanitizedPosition = [_position] call OKS_fnc_EdenSanitizePos;
	if (_sanitizedPosition isEqualTo []) then { _sanitizedPosition = [0, 0, 0]; };
	_sanitizedPosition set [2, 0];

	private _logicObject = create3DENEntity ["Logic", "Logic", _sanitizedPosition];
	if (isNull _logicObject) exitWith {""};
	if (!isNil "_layer") then { [_logicObject, _layer] call OKS_fnc_EdenSetLayerSafe; };

	private _name = [_namePrefix] call OKS_fnc_next3DENName;
	_logicObject set3DENAttribute ["name", _name];
	_name
};

private _targetPosition = [_menuDataNormalized, _selectedAirframes select 0] call _anchorPos;
if (_targetPosition isEqualTo []) exitWith {
	["AirSpawn: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

private _spawnPosition = getPosATL (_selectedAirframes select 0);
_spawnPosition set [2, 0];
_spawnPosition = [_spawnPosition] call OKS_fnc_EdenSanitizePos;
if (_spawnPosition isEqualTo []) exitWith {
	["AirSpawn: Invalid spawn position", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

private _spawnName = ["AirSpawnPosition", _spawnPosition] call _createLogic;
if (_spawnName isEqualTo "") exitWith {
	["AirSpawn: Failed to create AirSpawnPosition logic", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

private _targetName = ["AirSpawnTarget", _targetPosition] call _createLogic;
if (_targetName isEqualTo "") exitWith {
	["AirSpawn: Failed to create AirSpawnTarget logic", 1, 6, true] call BIS_fnc_3DENNotification;
	false
};

private _resolvedSide = _sideOverride;
if (_resolvedSide isEqualTo sideUnknown) then {
	_resolvedSide = side (_selectedAirframes select 0);
};
if (_resolvedSide isEqualTo sideUnknown) then {
	_resolvedSide = [(_selectedAirframes select 0)] call _sideFrom3DENAttribute;
};
if (_resolvedSide isEqualTo sideUnknown) then {
	_resolvedSide = east;
};

// Export templates: [classname, pylons]
private _templates = _selectedAirframes apply {
	private _className = typeOf _x;
	private _pylonMagazines = getPylonMagazines _x;
	[_className, _pylonMagazines]
};

private _sideStr = [_resolvedSide] call _sideToString;
private _templatesStr = str _templates;

// Defaults kept simple; adjust after paste if needed.
private _example = format [
	"null = [%1, %2, %3, %4] spawn OKS_fnc_AirSpawn;",
	_spawnName,
	_targetName,
	_templatesStr,
	_sideStr
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenAirSpawn", [_resolvedSide], _selectedAirframes] call OKS_fnc_EdenRememberLastAction;

systemChat format ["CopiedToClipboard | AirSpawn copied to clipboard | Cache=%1", _cacheCount];
[format ["AirSpawn copied to clipboard | Cache=%1", _cacheCount], 0, 10, true] call BIS_fnc_3DENNotification;

// Delete the template airframes (keeps the created AirSpawnPosition/AirSpawnTarget logics).
// Note: Eden may auto-create crew for some classes; deleting the vehicle is typically enough.
if !(_selectedAirframes isEqualTo []) then {
	if (!(uiNamespace getVariable ["OKS_3DEN_IS_REPEAT", false])) then {
		delete3DENEntities _selectedAirframes;
	};
};

true
