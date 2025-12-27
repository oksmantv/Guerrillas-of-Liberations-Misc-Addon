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

private _spawnObj = objNull;
private _wpObj = objNull;
private _endObj = objNull;

// Eden context menu can be opened on an entity without it being in the selection.
// Collect any object-typed entries from menuData so vehicle/side inference matches editor intent.
private _menuObjs = [];
{
    if (_x isEqualType objNull && {!isNull _x}) then {
        _menuObjs pushBackUnique _x;
    };
} forEach (_menuData select { _x isNotEqualTo [] });

private _contextObjs = _selected + (_menuObjs select { !(_x in _selected) });

// If the user selected at least 3 objects, use the first 3 as spawn/wp/end.
// Otherwise create helper Logic objects.
// IMPORTANT: do NOT treat vehicles as helper objects.
// Only use explicitly selected Logic entities as helpers; otherwise we create new Logic helpers.
private _selectedHelpers = _selected select { _x isKindOf "Logic" };

if ((count _selectedHelpers) >= 3) then {
    _spawnObj = _selectedHelpers select 0;
    _wpObj = _selectedHelpers select 1;
    _endObj = _selectedHelpers select 2;
    _spawnName = [_spawnObj, "ConvoySpawn"] call _ensureNamed;
    _wpName = [_wpObj, "ConvoyWP"] call _ensureNamed;
    _endName = [_endObj, "ConvoyEnd"] call _ensureNamed;
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

private _side = [_contextObjs] call _sideFromSelection;
private _sideStr = [_side] call _sideToString;

// Vehicle class/count defaults from selection (optional)
private _vehicleCount = 4;
private _cargoCount = 6;

private _vehicleClasses = [];
private _selectedVehicles = _contextObjs select { _x isKindOf "LandVehicle" };
if !(_selectedVehicles isEqualTo []) then {
    // Preserve the selected mix (incl duplicates) so the output reflects exactly what the editor selection contains.
    _vehicleClasses = _selectedVehicles apply { typeOf _x };
    _vehicleCount = (count _vehicleClasses) max 1;

    // Pick a safe cargo size that fits all selected vehicles (min positive capacity).
    private _caps = _vehicleClasses apply {
        getNumber (configFile >> "CfgVehicles" >> _x >> "transportSoldier")
    };
    private _posCaps = _caps select { _x > 0 };
    if !(_posCaps isEqualTo []) then {
        _cargoCount = selectMin _posCaps;
    };
};

// If no vehicle was selected, leave a safe-ish placeholder and let user edit.
if (_vehicleClasses isEqualTo []) then {
    _vehicleClasses = ["O_MRAP_02_F"];
};

private _vehParams = [_vehicleCount, _vehicleClasses, 35, 50];
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
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);
[format ["CopiedToClipboard: %1", _example], true] call OKS_fnc_LogDebug;
[format ["Convoy Spawn copied (%1) (helpers: %2, %3, %4) | Cache=%5", _sideStr, _spawnName, _wpName, _endName, _cacheCount], 0, 5, true] call BIS_fnc_3DENNotification;

// Optional editor cleanup: remove the selected vehicle entities after generating the call.
// Never delete the 3 helper objects (Spawn/WP/End) when the user provided them via selection.
if (is3DEN && {!(_selectedVehicles isEqualTo [])}) then {
    private _protected = [_spawnObj, _wpObj, _endObj] select { !isNull _x };
    private _toDelete = _selectedVehicles select { !(_x in _protected) };
    if !(_toDelete isEqualTo []) then {
        delete3DENEntities _toDelete;
        diag_log (format ["Convoy Spawn: deleted %1 selected vehicles", count _toDelete]);
    };
};

true
