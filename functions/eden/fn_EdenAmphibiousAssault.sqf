/*
    OKS_fnc_EdenAmphibiousAssault

    Eden helper for OKS_fnc_AmphibiousAssault (new signature).

    - Right-click terrain to choose amphibious spawn position
    - Creates named helper logics:
        * amphibiousSpawn_X
        * amphibiousTarget_X (placed near spawn so it is easy to grab/move onto shore)
    - Uses selected boat (optional) as classname template; defaults to B_Boat_Transport_01_F
    - Derives cargo count from boat cargo seats (BIS_fnc_crewCount cargo delta)
    - Uses GW global side selection (uiNamespace GW_FRAMEWORK_GLOBAL_SIDE)
    - Copies a spawnList-ready call to clipboard and caches it

    Usage from CfgEden:
      (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenAmphibiousAssault;
*/

params [
    "_menuData"
];

private _md = if (_menuData isEqualType []) then { _menuData } else { [] };

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

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
    };
};

private _createLogicAt = {
    params ["_positionATL", "_namePrefix"];

    private _sanitizedPositionATL = [_positionATL] call OKS_fnc_EdenSanitizePos;
    if (_sanitizedPositionATL isEqualTo []) then { _sanitizedPositionATL = [0, 0, 0]; };
    _sanitizedPositionATL set [2, 0];

    private _logicObject = create3DENEntity ["Logic", "Logic", _sanitizedPositionATL];
    if (isNull _logicObject) exitWith { [objNull, ""] };

    /*
    	DEPRECATED: OKS_fnc_EdenAmphibiousAssault

    	Renamed to OKS_fnc_EdenBeachLanding.
    	This wrapper remains so any old Eden menu entries or macros keep working.
    */

    params [
    	"_menuData"
    ];

    [_menuData] call OKS_fnc_EdenBeachLanding

