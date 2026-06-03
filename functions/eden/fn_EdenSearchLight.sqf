/*
    OKS_fnc_EdenSearchLight

    Eden helper for OKS_fnc_SearchLight.
    - Right-click in Eden or select an existing searchlight vehicle
    - Spawns the correct UK3CB searchlight class for the chosen side in Eden
      (or re-uses the selected vehicle if it is already a searchlight type)
    - Names it "searchlight_N" and copies a spawnList-ready call to clipboard

    Vehicle classes by side:
      east        -> UK3CB_O_SearchlightAA_CSAT_B
      west        -> UK3CB_B_SearchlightAA_NATO
      independent -> UK3CB_I_SearchlightAA_AAF

    Usage from CfgEden:
      [(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), "east"] call OKS_fnc_EdenSearchLight;
*/

private _args = _this;
if !(_args isEqualType []) then { _args = [_args]; };

_args params [
    ["_menuData", [], [[], objNull]],
    ["_sideStr",  "east", [""]]
];

if (_menuData isEqualType objNull) then {
    _menuData = [_menuData];
};

private _md = if (_menuData isEqualType []) then {_menuData} else {[]};

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

// --- Resolve click / anchor position ---
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

private _layer = ["Searchlight", "OKS Eden - Spawn Helpers"] call OKS_fnc_EdenGetOrCreateLayer;

private _createVehicleAt = {
    params ["_class", "_pos", "_namePrefix"];
    private _p = [_pos] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) then { _p = [0, 0, 0]; };
    _p set [2, 0];
    private _obj = create3DENEntity ["Object", _class, _p];
    if (isNull _obj) exitWith {[objNull, ""]};
    if (!isNil "_layer") then { [_obj, _layer] call OKS_fnc_EdenSetLayerSafe; };
    private _n = [_namePrefix] call OKS_fnc_next3DENName;
    _obj set3DENAttribute ["name", _n];
    [_obj, _n]
};

// --- Side -> vehicle class ---
private _searchlightClasses = ["UK3CB_O_SearchlightAA_CSAT_B", "UK3CB_B_SearchlightAA_NATO", "UK3CB_I_SearchlightAA_AAF"];

private _vehicleClass = switch (toLower _sideStr) do {
    case "west":        { "UK3CB_B_SearchlightAA_NATO" };
    case "independent": { "UK3CB_I_SearchlightAA_AAF" };
    default             { "UK3CB_O_SearchlightAA_CSAT_B" };
};

// --- Reuse selected searchlight vehicle, or spawn a new one ---
private _slObj = objNull;
{
    if ((typeOf _x) in _searchlightClasses) then {
        if (isNull _slObj) then { _slObj = _x; };
    };
} forEach _contextObjects;

if (isNull _slObj) then {
    private _p0 = [_contextObjects, _md] call _anchorPos;
    if (_p0 isEqualTo []) exitWith {
        ["Searchlight: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
        false
    };
    private _created = [_vehicleClass, _p0, "searchlight"] call _createVehicleAt;
    _slObj = _created select 0;
};

if (isNull _slObj) exitWith {
    ["Searchlight: Failed to create vehicle", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _slName = [_slObj, "searchlight"] call _ensureNamed;

private _example = format [
    "[%1, %2] spawn OKS_fnc_SearchLight;",
    _slName,
    _sideStr
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenSearchLight", [_sideStr], []] call OKS_fnc_EdenRememberLastAction;
systemChat format ["CopiedToClipboard | Searchlight (%1) copied to clipboard | Cache=%2", _sideStr, _cacheCount];

[format ["CopiedToClipboard | Searchlight copied to clipboard | Cache=%1 | %2", _cacheCount, _example], false, true, true] call OKS_fnc_LogDebug;
[format ["Searchlight (%1): %2 | Cache=%3", _sideStr, _slName, _cacheCount], 0, 10, true] call BIS_fnc_3DENNotification;
true;
