/*
    OKS_fnc_EdenConvoySpawn

    Eden helper:
    - Ensures 3 named helper objects exist (Spawn / WP / End)
    - Copies a spawnList-ready call to OKS_fnc_Convoy_Spawn

    Usage from CfgEden:
      (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenConvoySpawn;
*/

params ["_menuData"];

private _selected = get3DENSelected "object";

private _sideFromSelection = {
    params ["_objs"];
    private _s = sideUnknown;
    {
        if (_x isKindOf "Man") exitWith {_s = side _x};
        if (_x isKindOf "LandVehicle" || {_x isKindOf "Air"} || {_x isKindOf "Ship"}) exitWith {_s = side _x};
    } forEach _objs;
    if (_s isEqualTo sideUnknown) then {_s = east};
    _s
};

private _sideToString = {
    params ["_side"];
    if (_side isEqualTo west) exitWith {"west"};
    if (_side isEqualTo east) exitWith {"east"};
    if (_side isEqualTo independent) exitWith {"independent"};
    if (_side isEqualTo civilian) exitWith {"civilian"};
    "east"
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

    // If user has any selection, use centroid as a reliable origin.
    if (_p isEqualTo [] && {!(_objs isEqualTo [])}) then {
        private _sum = [0, 0, 0];
        {
            _sum = _sum vectorAdd (getPosATL _x);
        } forEach _objs;
        _p = _sum vectorMultiply (1 / (count _objs));
    };

    if (_p isEqualTo []) then { _p = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray; };
    _p set [2, 0];
    _p = [_p] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith {[]};
    _p
};

private _offsetPos = {
    params ["_pos", "_dist", "_dirDeg"];
    private _p = [
        (_pos select 0) + (sin _dirDeg) * _dist,
        (_pos select 1) + (cos _dirDeg) * _dist,
        (_pos select 2)
    ];
    [_p] call OKS_fnc_EdenSanitizePos
};

private _createHelper = {
    params ["_namePrefix", "_pos"];
    private _p = [_pos] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith {""};
    private _obj = create3DENEntity ["Logic", "Logic", _p];
    private _n = [_namePrefix] call OKS_fnc_next3DENName;
    _obj set3DENAttribute ["name", _n];
    _n
};

private _ensureNamed = {
    params ["_obj", "_namePrefix"];
    private _n = (_obj get3DENAttribute "name") select 0;
    if (_n isEqualTo "") then {
        _n = [_namePrefix] call OKS_fnc_next3DENName;
        _obj set3DENAttribute ["name", _n];
    };
    _n
};

private _spawnName = "";
private _wpName = "";
private _endName = "";

// If the user selected at least 3 objects, use the first 3 as spawn/wp/end.
// Otherwise create helper Logic objects.
if ((count _selected) >= 3) then {
    _spawnName = [(_selected select 0), "ConvoySpawn"] call _ensureNamed;
    _wpName = [(_selected select 1), "ConvoyWP"] call _ensureNamed;
    _endName = [(_selected select 2), "ConvoyEnd"] call _ensureNamed;
} else {
    private _p0 = [_selected, _menuData] call _anchorPos;
    if (_p0 isEqualTo []) exitWith {
        (format ["Convoy Spawn: invalid click position. menuData=%1", _menuData]) call OKS_fnc_LogDebug;
        ["Convoy Spawn: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
        false
    };
    _spawnName = ["ConvoySpawn", ([_p0, 0, 0] call _offsetPos)] call _createHelper;
    _wpName = ["ConvoyWP", ([_p0, 30, 0] call _offsetPos)] call _createHelper;
    _endName = ["ConvoyEnd", ([_p0, 60, 0] call _offsetPos)] call _createHelper;
};

private _side = [_selected] call _sideFromSelection;
private _sideStr = [_side] call _sideToString;

// Vehicle class/count defaults from selection (optional)
private _vehicleClass = "";
private _vehicleCount = 4;
private _cargoCount = 6;

private _selectedVehicles = _selected select { _x isKindOf "LandVehicle" };
if !(_selectedVehicles isEqualTo []) then {
    _vehicleClass = typeOf (_selectedVehicles select 0);
    _vehicleCount = (count _selectedVehicles) max 1;

    private _cfg = configFile >> "CfgVehicles" >> _vehicleClass;
    private _ts = getNumber (_cfg >> "transportSoldier");
    if (_ts > 0) then { _cargoCount = _ts; };
};

// If no vehicle was selected, leave a safe-ish placeholder and let user edit.
if (_vehicleClass isEqualTo "") then {
    _vehicleClass = "O_MRAP_02_F";
};

private _vehParams = [_vehicleCount, [_vehicleClass], 35, 50];
private _cargoParams = [true, _cargoCount];
private _rushTypes = ["rush"];

private _example = format [
    "[%1,%2,%3,%4,%5,%6,[],%7,%8,%9,%10] spawn OKS_fnc_Convoy_Spawn;",
    _spawnName,
    _wpName,
    _endName,
    _sideStr,
    str _vehParams,
    str _cargoParams,
    false,
    false,
    str _rushTypes,
    false
];

copyToClipboard _example;
[format ["CopiedToClipboard: %1", _example], true] call OKS_fnc_LogDebug;
[format ["Convoy Spawn copied (%1) (helpers: %2, %3, %4)", _sideStr, _spawnName, _wpName, _endName], 0, 5, true] call BIS_fnc_3DENNotification;

true
