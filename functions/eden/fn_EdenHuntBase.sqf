/*
    OKS_fnc_EdenHuntBase

    Supports being called from 3DEN context menus and from OKS_fnc_EdenRepeatLastAction.
    Repeat passes menuData as param 0 and we also store resolved parameters as fixedArgs.
*/

private _args = _this;
if !(_args isEqualType []) then { _args = [_args]; };

private _menuData = _args param [0, []];
private _sideOverride = _args param [1, sideUnknown];
private _vehicleClassesOverride = _args param [2, []];
private _unitCountOverride = _args param [3, -1];

if (_menuData isEqualType objNull) then { _menuData = [_menuData]; };
if !(_menuData isEqualType []) then { _menuData = []; };

private _pos = [];
if (_menuData isEqualType []) then {
    // menuData might be a raw position [x,y,z]
    _pos = [_menuData] call OKS_fnc_EdenPosFromArray;

    // ...or a wrapped position like [[x,y,z], ...] or [[x,y,z]]
    if (_pos isEqualTo []) then {
        private _md0 = _menuData param [0, []];
        if (_md0 isEqualType []) then {
            _pos = [_md0] call OKS_fnc_EdenPosFromArray;
        };
    };
};

// Fallback: screen-to-world under cursor
if (_pos isEqualTo []) then {
    private _stw = screenToWorld getMousePosition;
    if (_stw isEqualType []) then {
        _pos = [_stw] call OKS_fnc_EdenPosFromArray;
    };
};

_pos set [2, 0];

// Keep old variable name used throughout
private _Position = _pos;

private _baseName = ["HuntBase"] call OKS_fnc_next3DENName;
private _spawnName = ["HuntSpawn"] call OKS_fnc_next3DENName;
private _triggerName = ["HuntTrigger"] call OKS_fnc_next3DENName;
private _dirToCam = [_Position, position get3DENCamera, 0] call BIS_fnc_dirTo;

private _basePos =+ _Position;
_basePos set [2, 0];
private _base = create3DENEntity ["Object", "Land_Cargo_HQ_V2_F", _basePos];
_base set3DENAttribute ["name", _baseName];
_base set3DENAttribute ["rotation", [0,0,_dirToCam]];

private _triggerPos = _basePos getPos [15, _dirToCam];
_triggerPos set [2, 0];
private _trigger = create3DENEntity ["Trigger", "EmptyDetector", _triggerPos];
_trigger set3DENAttribute ["name", _triggerName];
_trigger set3DENAttribute ["size3", [3000,3000,0]];
_trigger set3DENAttribute ["IsRectangle", false];        
_trigger set3DENAttribute ["ActivationBy", "ANYPLAYER"]; 
_trigger set3DENAttribute ["repeatable", true];

private _spawnPos = _basePos getPos [25, _dirToCam];
_spawnPos set [2, 0];
private _spawn = create3DENEntity ["Object", "Land_Matches_F", _spawnPos];
_spawn set3DENAttribute ["name", _spawnName];
_spawn set3DENAttribute ["hideObject", true];

private _selected = get3DENSelected "object";
private _vehicleClasses = [];
private _unitCount = 0;
private _side = east;

{
    private _type = typeOf _x;
    _side = side _x;
    if (_x isKindOf "Man") then {
        _unitCount = _unitCount + 1;
    } else {
        _vehicleClasses pushBack _type;
    };
} forEach _selected;

// Apply remembered overrides from RepeatLastAction, if present.
if (_sideOverride isEqualType west) then { _side = _sideOverride; };
if (_vehicleClassesOverride isEqualType [] && {!(_vehicleClassesOverride isEqualTo [])}) then {
    _vehicleClasses = _vehicleClassesOverride;
};
if (_unitCountOverride isEqualType 0 && {_unitCountOverride >= 0} && {(_vehicleClassesOverride isEqualType []) && (_vehicleClassesOverride isEqualTo [])}) then {
    _unitCount = _unitCountOverride;
};

if(_unitCount == 0 && _vehicleClasses isEqualTo []) then {
    _unitCount = 6
};

private _example = "";
if (_vehicleClasses isNotEqualTo []) then {
    _example = format [
        "[%1, %2, %3, 5, 900, %4, %5, 120] spawn OKS_fnc_HuntBase;",
        _baseName, _spawnName, _triggerName, _side, str _vehicleClasses
    ]
} else {
    _example = format [
        "[%1, %2, %3, 5, 900, %4, %5, 120] spawn OKS_fnc_HuntBase;",
        _baseName, _spawnName, _triggerName, _side, _unitCount
    ]
};
copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

private _rememberVehicles = if (_vehicleClasses isEqualTo []) then { [] } else { +_vehicleClasses };
["OKS_fnc_EdenHuntBase", [_side, _rememberVehicles, _unitCount], []] call OKS_fnc_EdenRememberLastAction;
systemChat format ["CopiedToClipboard | Hunt Base copied to clipboard | Cache=%1", _cacheCount];
[format ["CopiedToClipboard | Hunt Base copied to clipboard | Cache=%1 | %2", _cacheCount, _example], false, true, true] call OKS_fnc_LogDebug;
[format ["Hunter Base copied to clipboard | Cache=%1", _cacheCount], 0, 10, true] call BIS_fnc_3DENNotification;
delete3DENEntities _selected;


