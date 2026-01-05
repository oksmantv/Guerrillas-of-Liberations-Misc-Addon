/*
    OKS_fnc_EdenAIBattle

    Eden helper:
    - Ensures 3 named helper objects exist (Faction1Spawn / Faction2Spawn / Meeting)
    - Copies a spawnList-ready call to OKS_fnc_AI_Battle

    Usage from CfgEden:
      (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenAIBattle;
*/

params ["_menuData"];

private _selected = get3DENSelected "object";

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
    // Origin:
    // - Prefer menuData[0] (supports both terrain-click pos and entity-click object)
    // - Fall back to selection centroid
    // - Fall back to mouse position
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

private _layer = ["AI Battle", "OKS Eden - Spawn Helpers"] call OKS_fnc_EdenGetOrCreateLayer;

private _createHelper = {
    params ["_namePrefix", "_pos"];
    private _p = [_pos] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith {""};
    private _obj = create3DENEntity ["Logic", "Logic", _p];
    if (isNull _obj) exitWith {""};
	if (!isNil "_layer") then { [_obj, _layer] call OKS_fnc_EdenSetLayerSafe; };
    private _n = [_namePrefix] call OKS_fnc_next3DENName;
    _obj set3DENAttribute ["name", _n];
    _obj set3DENAttribute ["hideObject", true];
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

private _f1 = "";
private _f2 = "";
private _meet = "";

if ((count _selected) >= 3) then {
    // Use selection if the mission maker pre-placed and selected the three anchors.
    _f1 = [(_selected select 0), "AIBattle_SpawnA"] call _ensureNamed;
    _f2 = [(_selected select 1), "AIBattle_SpawnB"] call _ensureNamed;
    _meet = [(_selected select 2), "AIBattle_Meet"] call _ensureNamed;
    if (!isNil "_layer") then {
        [(_selected select 0), _layer] call OKS_fnc_EdenSetLayerSafe;
        [(_selected select 1), _layer] call OKS_fnc_EdenSetLayerSafe;
        [(_selected select 2), _layer] call OKS_fnc_EdenSetLayerSafe;
    };
} else {
    private _p0 = [_selected, _menuData] call _anchorPos;
    if (_p0 isEqualTo []) exitWith {
        [format ["AI Battle: invalid click position. menuData=%1", _menuData], false, true] call OKS_fnc_LogDebug;
        ["AI Battle: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
        false
    };

    // WaveSpawn-triple style: create the meet point in the middle (origin), then spawn A/B around it.
    _meet = ["AIBattle_Meet", _p0] call _createHelper;
    _f1 = ["AIBattle_SpawnA", ([_p0, 150, 0] call _offsetPos)] call _createHelper;
    _f2 = ["AIBattle_SpawnB", ([_p0, 150, 180] call _offsetPos)] call _createHelper;
};

if (_f1 isEqualTo "" || {_f2 isEqualTo ""} || {_meet isEqualTo ""}) exitWith {
    [format ["AI Battle: Failed to create helper objects. f1=%1 f2=%2 meet=%3", _f1, _f2, _meet], false, true] call OKS_fnc_LogDebug;
    ["AI Battle: Failed to create helper objects", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

// Defaults (keep minimal; edit later in spawnList if needed)
private _side1Str = [west] call _sideToString;
private _side2Str = [east] call _sideToString;

private _f1Classes = ["B_APC_Tracked_01_rcws_F"];
private _f2Classes = ["O_APC_Wheeled_02_rcws_v2_F"];

private _example = format [
    "[%1,%2,%3,%4,%5,%6,%7,sideUnknown,true,240,-1,60,12,3000] call OKS_fnc_AI_Battle;",
    _f1,
    _f2,
    _meet,
    _side1Str,
    _side2Str,
    str _f1Classes,
    str _f2Classes
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenAIBattle", [], _selected] call OKS_fnc_EdenRememberLastAction;
systemChat format ["CopiedToClipboard | AI Battle copied to clipboard | Cache=%1", _cacheCount];
[format ["CopiedToClipboard | AI Battle copied to clipboard | Cache=%1 | %2", _cacheCount, _example], false, true, true] call OKS_fnc_LogDebug;
[format ["AI Battle copied to clipboard (helpers: %1, %2, %3) | Cache=%4", _f1, _f2, _meet, _cacheCount], 0, 10, true] call BIS_fnc_3DENNotification;

true
