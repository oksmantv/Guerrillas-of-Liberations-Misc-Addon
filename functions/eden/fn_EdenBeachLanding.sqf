/*
    OKS_fnc_EdenBeachLanding

    Eden helper for OKS_fnc_BeachLanding.

    - Right-click terrain to choose spawn position
    - Creates named helper logics:
        * beachLandingSpawn_X
        * beachLandingTarget_X (placed near spawn so it is easy to grab/move onto shore)
    - Uses selected boat (optional) as classname template; defaults to B_Boat_Transport_01_F
    - Derives cargo count from boat cargo seats (BIS_fnc_crewCount cargo delta)
    - Side is taken from the GW editor "Select Side" option (uiNamespace GW_FRAMEWORK_GLOBAL_SIDE)
    - Copies a spawnList-ready call to clipboard and caches it

    Usage from CfgEden:
      (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenBeachLanding;
*/

private _args = _this;
if !(_args isEqualType []) then { _args = [_args]; };

private _menuData = _args param [0, []];
private _boatClassOverride = _args param [1, ""];
private _cargoSeatCountOverride = _args param [2, -1];
private _sideStringOverride = _args param [3, ""];

if (_menuData isEqualType objNull) then { _menuData = [_menuData]; };
if !(_menuData isEqualType []) then { _menuData = []; };

private _md = if (_menuData isEqualType []) then { _menuData } else { [] };

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

// create3DENEntity takes ATL coordinates. Over water, ATL z=0 is the seafloor.
// If the position is over water, convert to an ATL Z such that ASL becomes 0 (sea surface).
private _snapATLToSeaSurfaceIfWater = {
    params ["_positionATL"];
    private _p = +_positionATL;
    if ((count _p) < 2) exitWith { _p };
    if ((count _p) == 2) then { _p pushBack 0; };

    private _probeATL = +_p;
    _probeATL set [2, 0];
    if !(surfaceIsWater _probeATL) exitWith { _p };

    private _terrainHeightASL = getTerrainHeightASL [_p select 0, _p select 1];
    _p set [2, 0 - _terrainHeightASL];
    _p
};

private _anchorPositionATL = {
    params ["_md"];
    private _positionATL = [];

    if (_md isEqualType []) then {
        _positionATL = [_md] call OKS_fnc_EdenPosFromArray;
    };

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
    _positionATL = [_positionATL] call _snapATLToSeaSurfaceIfWater;
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
    private _p = [_offsetPositionATL] call OKS_fnc_EdenSanitizePos;
    [_p] call _snapATLToSeaSurfaceIfWater
};

private _sideToString = {
    params ["_side"];
    if (_side isEqualTo west) exitWith {"west"};
    if (_side isEqualTo east) exitWith {"east"};
    if (_side isEqualTo independent) exitWith {"independent"};
    if (_side isEqualTo civilian) exitWith {"civilian"};
    "west"
};

private _sideFromCopySideOption = {
    private _sideString = toUpper (uiNamespace getVariable ["GW_FRAMEWORK_GLOBAL_SIDE", "WEST"]);
    switch (_sideString) do {
        case "EAST": { east };
        case "INDEPENDENT": { independent };
        case "GUER": { independent };
        default { west };
    };
};

private _layer = ["Beach Landing", "OKS Eden - Spawn Helpers"] call OKS_fnc_EdenGetOrCreateLayer;

private _createLogicAt = {
    params ["_positionATL", "_namePrefix"];

    private _sanitizedPositionATL = [_positionATL] call OKS_fnc_EdenSanitizePos;
    if (_sanitizedPositionATL isEqualTo []) then { _sanitizedPositionATL = [0, 0, 0]; };
    _sanitizedPositionATL = [_sanitizedPositionATL] call _snapATLToSeaSurfaceIfWater;

    private _logicObject = create3DENEntity ["Logic", "Logic", _sanitizedPositionATL];
    if (isNull _logicObject) exitWith { [objNull, ""] };
	if (!isNil "_layer") then { [_logicObject, _layer] call OKS_fnc_EdenSetLayerSafe; };

    private _logicName = [_namePrefix] call OKS_fnc_next3DENName;
    _logicObject set3DENAttribute ["name", _logicName];
    _logicObject set3DENAttribute ["hideObject", true];

    [_logicObject, _logicName]
};

private _spawnPositionATL = [_md] call _anchorPositionATL;
if (_spawnPositionATL isEqualTo []) exitWith {
    ["Beach Landing: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _createdSpawnLogic = [_spawnPositionATL, "beachLandingSpawn"] call _createLogicAt;
private _spawnLogicObject = _createdSpawnLogic select 0;
private _spawnLogicName = _createdSpawnLogic select 1;

if (isNull _spawnLogicObject || {_spawnLogicName isEqualTo ""}) exitWith {
    ["Beach Landing: Failed to create spawn helper", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _targetPositionATL = [_spawnPositionATL, 35, 90] call _offsetPositionFromATL;
if (_targetPositionATL isEqualTo []) then {
    _targetPositionATL = [_spawnPositionATL, 35, 0] call _offsetPositionFromATL;
};

private _createdTargetLogic = [_targetPositionATL, "beachLandingTarget"] call _createLogicAt;
private _targetLogicObject = _createdTargetLogic select 0;
private _targetLogicName = _createdTargetLogic select 1;

if (isNull _targetLogicObject || {_targetLogicName isEqualTo ""}) exitWith {
    ["Beach Landing: Failed to create target helper", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

// Boat classname template (optional)
private _boatClassname = "B_Boat_Transport_01_F";
private _selectedObjects = get3DENSelected "object";
private _boatsToDelete = [];

if (_boatClassOverride isEqualType "" && {!(_boatClassOverride isEqualTo "")}) then {
    _boatClassname = _boatClassOverride;
} else {
    private _selectedBoats = _selectedObjects select { _x isKindOf "Ship" };
    private _selectedBoat = _selectedBoats param [0, objNull];
    if (!isNull _selectedBoat) then {
        _boatClassname = typeOf _selectedBoat;
        _boatsToDelete = _selectedBoats;
    };
};

// Cargo count from boat cargo seats
private _crewCountWithCargo = [_boatClassname, true] call BIS_fnc_crewCount;
private _crewCountNoCargo = [_boatClassname, false] call BIS_fnc_crewCount;
private _cargoSeatCount = (_crewCountWithCargo - _crewCountNoCargo) max 0;

if (_cargoSeatCountOverride isEqualType 0 && {_cargoSeatCountOverride >= 0}) then {
    _cargoSeatCount = _cargoSeatCountOverride;
};

private _side = call _sideFromCopySideOption;
private _sideString = [_side] call _sideToString;

if (_sideStringOverride isEqualType "" && {!(_sideStringOverride isEqualTo "")}) then {
    _sideString = _sideStringOverride;
};

private _example = format [
    "null = [%1, %2, %3, %4, %5, %6, %7, %8] spawn OKS_fnc_BeachLanding;",
    _spawnLogicName,
    _targetLogicName,
    str _boatClassname,
    _cargoSeatCount,
    _sideString,
    str "rush",
    1500,
    str ""
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
["OKS_fnc_EdenBeachLanding", [_boatClassname, _cargoSeatCount, _sideString], [_spawnLogicObject, _targetLogicObject]] call OKS_fnc_EdenRememberLastAction;

if !(_boatsToDelete isEqualTo []) then {
    if (!(uiNamespace getVariable ["OKS_3DEN_IS_REPEAT", false])) then {
        delete3DENEntities _boatsToDelete;
    };
};

private _description = format [
    "[3DEN] Beach Landing copied to clipboard: Spawn=%1 | Target=%2 | Boat=%3 | Cargo=%4 | Side=%5",
    _spawnLogicName,
    _targetLogicName,
    _boatClassname,
    _cargoSeatCount,
    _sideString
];

if (_debug3DEN) then {
    [format ["[3DEN] EdenBeachLanding | %1 | %2", _description, _example], false, true] call OKS_fnc_LogDebug;
};

systemChat _description;
true
