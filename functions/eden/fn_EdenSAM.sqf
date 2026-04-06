/*
    OKS_fnc_EdenSAM

    Eden helper for OKS_fnc_SAM.
    - Requires a selected/clicked SAM launcher (validation)
    - Uses a selected radar vehicle if available
    - Copies a spawnList-ready OKS_fnc_SAM call to clipboard

    Usage from CfgEden:
      [(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), 2] call OKS_fnc_EdenSAM;
*/

private _args = _this;
if !(_args isEqualType []) then { _args = [_args]; };

_args params [
    ["_menuData", [], [[], objNull]],
    ["_maxMissilesPerTarget", 2, [0]],
    ["_rateOfFire", 20, [0]],
    ["_ammo", 4, [0]],
    ["_reloadRate", 20, [0]],
    ["_minimumAltitude", 100, [0]],
    ["_maxRange", 3000, [0]]
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

private _layer = ["SAM", "OKS Eden - Support Helpers"] call OKS_fnc_EdenGetOrCreateLayer;

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

// --- Find SAM launcher among selected objects ---
private _samObj = objNull;
private _radarObj = objNull;
{
    if (_x isKindOf "AllVehicles") then {
        private _rt = getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "radarType");
        if (_rt isEqualTo 2) then {
            if (isNull _radarObj) then { _radarObj = _x; };
        } else {
            if (isNull _samObj) then { _samObj = _x; };
        };
    };
} forEach _contextObjects;

// If no SAM selected, spawn default at click position
if (isNull _samObj) then {
    private _p0 = [_contextObjects, _md] call _anchorPos;
    if (_p0 isEqualTo []) exitWith {
        ["SAM: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
        false
    };
    private _created = ["GOL_O_SAM_System_04_F", _p0, "SAM"] call _createVehicleAt;
    _samObj = _created select 0;
};

if (isNull _samObj) exitWith {
    ["SAM: Failed to create/select a launcher", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _samName = [_samObj, "SAM"] call _ensureNamed;

// Radar: use selected radar or create placeholder name
private _radarName = "radar_1";
if (!isNull _radarObj) then {
    _radarName = [_radarObj, "Radar"] call _ensureNamed;
};

private _example = format [
    "null = [%1,%2,%3,%4,%5,%6,%7,%8] spawn OKS_fnc_SAM;",
    _samName,
    _radarName,
    _rateOfFire,
    _ammo,
    _reloadRate,
    _minimumAltitude,
    _maxRange,
    _maxMissilesPerTarget
];

private _desc = format [
    "SAM copied to clipboard: Launcher=%1 | Radar=%2 | MaxPerTarget=%3 | ROF=%4 | Ammo=%5 | Range=%6",
    _samName,
    _radarName,
    _maxMissilesPerTarget,
    _rateOfFire,
    _ammo,
    _maxRange
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenSAM", [_maxMissilesPerTarget, _rateOfFire, _ammo, _reloadRate, _minimumAltitude, _maxRange], []] call OKS_fnc_EdenRememberLastAction;
private _chatText = format ["CopiedToClipboard | SAM copied to clipboard | Cache=%1", _cacheCount];
systemChat _chatText;

private _logExample = _example splitString "\r\n" joinString " ";
private _logText = format ["CopiedToClipboard | SAM copied to clipboard | Cache=%1 | %2", _cacheCount, _logExample];
[_logText, false, true, true] call OKS_fnc_LogDebug;
if (_debug3DEN) then {
    [format ["SAM | %1", _desc], false, true, true] call OKS_fnc_LogDebug;
};

private _notify = if (_debug3DEN) then {_desc} else {"SAM copied to clipboard"};
_notify = format ["%1 | Cache=%2", _notify, _cacheCount];
[_notify, 0, 10, true] call BIS_fnc_3DENNotification;
true;
