/*
    OKS_fnc_EdenEvacuateHVT

    Eden helper:
    - Always creates an ExfilSite helper (hidden Logic) at click position.
    - If units are selected: uses selected men as HVTs (names them if missing).
      - If all in one group: uses GROUP reference.
      - If mixed groups: uses ARRAY reference.
    - If no units selected: creates a default 3-civilian group at click position.

    Copies a spawnList-ready call to OKS_fnc_Evacuate_HVT.
*/

params ["_menuData"];

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

private _md = if (_menuData isEqualType []) then {_menuData} else {[]};

private _selected = get3DENSelected "object";
private _men = _selected select { _x isKindOf "Man" };

private _fnc_sanitizePos0 = {
    params ["_pos"];
    private _p = [_pos] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith {[]};
    _p set [2, 0];
    _p
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

    if (_p isEqualTo [] && {!(_objs isEqualTo [])}) then {
        _p = getPosATL (_objs select 0);
    };

    if (_p isEqualTo []) then { _p = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray; };
    _p = [_p] call _fnc_sanitizePos0;
    if (_p isEqualTo []) exitWith {[]};
    _p
};

private _ensureNamed = {
    params ["_obj", "_prefix"]; 
    private _n = (_obj get3DENAttribute "name") select 0;
    if (_n isEqualTo "") then {
        _n = [_prefix] call OKS_fnc_next3DENName;
        _obj set3DENAttribute ["name", _n];
    };
    _n
};

private _createHiddenLogic = {
    params ["_prefix", "_pos"]; 
    private _p = [_pos] call _fnc_sanitizePos0;
    if (_p isEqualTo []) then { _p = [0,0,0]; };
    private _obj = create3DENEntity ["Logic", "Logic", _p];
    if (isNull _obj) exitWith {""};
    private _n = [_prefix] call OKS_fnc_next3DENName;
    _obj set3DENAttribute ["name", _n];
    _obj set3DENAttribute ["hideObject", true];
    if (((_obj get3DENAttribute "name") select 0) isEqualTo "") then {
        _obj set3DENAttribute ["name", _n];
    };
    _n
};

private _p0 = [_selected, _md] call _anchorPos;
if (_p0 isEqualTo []) exitWith {
    (format ["EdenEvacuateHVT: invalid click position. menuData=%1", _md]) call OKS_fnc_LogDebug;
    ["Evacuate HVT: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _offsetPosFrom = {
    params ["_pos", "_dist", "_dirDeg"];
    private _p = +_pos;
    if ((count _p) < 2) exitWith {[]};
    if ((count _p) == 2) then { _p pushBack 0; };
    _p set [0, (_p select 0) + (sin _dirDeg) * _dist];
    _p set [1, (_p select 1) + (cos _dirDeg) * _dist];
    _p set [2, 0];
    [_p] call _fnc_sanitizePos0
};

private _getFriendlySideFromEden = {
    // Tries to infer "player" side from the Eden unit marked as Player (preferred), then Playable.
    // Falls back to west if no player/playable unit is detectable.
    params ["_selectedMen"]; 

    private _fallbackSide = west;

    private _objs = (all3DENEntities select 0);
    private _menAll = _objs select { _x isKindOf "Man" };

    // First, try strict detection: unit(s) explicitly marked as PLAYER.
    // Depending on Eden version/mods, Control/ControlMP may be numeric (1=Player, 2=Playable),
    // string ("PLAYER"/"PLAYABLE"), or boolean.
    private _playerCandidates = [];
    {
        private _cMP = ((_x get3DENAttribute "ControlMP") param [0, ""]);
        private _c = ((_x get3DENAttribute "Control") param [0, ""]);

        private _isPlayer = false;
        if (_cMP isEqualType 0) then { _isPlayer = _isPlayer || {_cMP == 1}; };
        if (_c isEqualType 0) then { _isPlayer = _isPlayer || {_c == 1}; };
        if (_cMP isEqualType "") then { _isPlayer = _isPlayer || {(toUpper _cMP) find "PLAYER" >= 0}; };
        if (_c isEqualType "") then { _isPlayer = _isPlayer || {(toUpper _c) find "PLAYER" >= 0}; };

        if (_isPlayer) then { _playerCandidates pushBackUnique _x; };
    } forEach _menAll;

    if ((count _playerCandidates) == 1) exitWith { side group (_playerCandidates select 0) };
    if ((count _playerCandidates) > 1) then {
        private _s0 = side group (_playerCandidates select 0);
        private _allSame = true;
        { if ((side group _x) != _s0) exitWith { _allSame = false; }; } forEach _playerCandidates;
        if (_allSame) exitWith { _s0 };
    };

    private _scoreControl = {
        params ["_v"]; 
        private _s = 0;
        if (_v isEqualType "") then {
            private _u = toUpper _v;
            if (_u find "PLAYER" >= 0) then { _s = 100; };
            if (_u find "PLAYABLE" >= 0) then { _s = 50 max _s; };
        } else {
            if (_v isEqualType true) then {
                // Some Eden builds expose Control/ControlMP as boolean.
                if (_v) then { _s = 50; };
            };
            if (_v isEqualType 0) then {
                // Some control attributes are numeric enums.
                // Typical Eden/mission.sqm mapping: 0=None, 1=Player, 2=Playable.
                if (_v == 1) then { _s = 100; };
                if (_v == 2) then { _s = 50; };
                if (_v > 2) then { _s = 50; };
            };
        };
        _s
    };

    private _best = objNull;
    private _bestScore = -1;
    private _bestC1 = "";
    private _bestC2 = "";
    private _candidatesDbg = [];
    private _sideVotes = createHashMap;
    private _strongCount = 0;
    {
        private _c1 = ((_x get3DENAttribute "ControlMP") param [0, ""]);
        private _c2 = ((_x get3DENAttribute "Control") param [0, ""]);
        private _s = ([_c1] call _scoreControl) max ([_c2] call _scoreControl);

        if (_s > 0) then {
            private _k = str (side group _x);
            _sideVotes set [_k, (_sideVotes getOrDefault [_k, 0]) + 1];
        };
        if (_s >= 100) then { _strongCount = _strongCount + 1; };

        if (_s > 0 && {_debug3DEN}) then {
            private _n = (_x get3DENAttribute "name") param [0, ""]; 
            if (_n isEqualTo "") then { _n = typeOf _x; };
            _candidatesDbg pushBack format ["%1:%2 c1=%3 c2=%4 s=%5", _n, side group _x, _c1, _c2, _s];
        };

        if (_s > _bestScore) then {
            _bestScore = _s;
            _best = _x;
            _bestC1 = _c1;
            _bestC2 = _c2;
        } else {
            // Tie-break: if scores match, prefer a non-civilian unit over a civilian one.
            if (_s == _bestScore && {!isNull _best}) then {
                if ((side group _best) == civilian && {(side group _x) != civilian}) then {
                    _best = _x;
                };
            };
        };
    } forEach _menAll;

    if (_debug3DEN) then {
        private _pickedSideDbg = if (!isNull _best) then {side group _best} else {_fallbackSide};
        (format ["[3DEN] EdenEvacuateHVT: player-detect best=%1 side=%2 score=%3 c1=%4 c2=%5 menAll=%6", _best, _pickedSideDbg, _bestScore, _bestC1, _bestC2, count _menAll]) call OKS_fnc_LogDebug;
        if !(_candidatesDbg isEqualTo []) then {
            (format ["[3DEN] EdenEvacuateHVT: player-detect candidates: %1", _candidatesDbg joinString " | "]) call OKS_fnc_LogDebug;
        };
        if ((count _sideVotes) > 0) then {
            private _votePairs = [];
            {
                _votePairs pushBack format ["%1=%2", _x, _sideVotes get _x];
            } forEach (keys _sideVotes);
            (format ["[3DEN] EdenEvacuateHVT: player-detect sideVotes: %1", _votePairs joinString " | "]) call OKS_fnc_LogDebug;
        };
        if ((count _playerCandidates) > 1) then {
            private _names = [];
            { _names pushBack (((_x get3DENAttribute "name") param [0, ""]) + ":" + str (side group _x)); } forEach _playerCandidates;
            (format ["[3DEN] EdenEvacuateHVT: WARNING multiple PLAYER candidates (Control==1): %1", _names joinString " | "]) call OKS_fnc_LogDebug;
        };
    };

    // Prefer a strong (PLAYER) candidate when we have one.
    if (!isNull _best && {_bestScore >= 100}) exitWith { side group _best };

    // If we have any playable/player hints, return the side with the most votes.
    if ((count _sideVotes) > 0) exitWith {
        private _bestKey = "";
        private _bestCount = -1;
        {
            private _c = _sideVotes get _x;
            if (_c > _bestCount) then { _bestCount = _c; _bestKey = _x; };
        } forEach (keys _sideVotes);

        if (_bestKey == str east) exitWith { east };
        if (_bestKey == str west) exitWith { west };
        if (_bestKey == str independent) exitWith { independent };
        if (_bestKey == str civilian) exitWith { civilian };
        _fallbackSide
    };

    _fallbackSide
};

private _sideToken = {
    params ["_s"]; 
    switch (_s) do {
        case west: {"west"};
        case east: {"east"};
        case independent: {"independent"};
        case civilian: {"civilian"};
        default {"west"};
    };
};

private _friendValue3DEN = {
    // In 3DEN, runtime side relations (getFriend) may NOT reflect the mission's Briefing/Intel side relations.
    // Prefer the mission attribute values where possible.
    params ["_a", "_b"]; 
    if (_a isEqualTo _b) exitWith {[1, "sameSide"]};

    private _v = _a getFriend _b;
    private _src = "getFriend";

    private _coerceNumber = {
        params ["_x"]; 
        if (isNil "_x") exitWith {nil};
        if (_x isEqualType 0) exitWith {_x};
        if (_x isEqualType "") exitWith {parseNumber _x};
        if (_x isEqualType true) exitWith {if (_x) then {1} else {0}};
        if (_x isEqualType []) exitWith {
            // Handle common Eden shapes like [value] or [value, changed] or nested arrays.
            if ((count _x) == 0) exitWith {nil};
            private _firstScalar = nil;
            {
                private _c = [_x] call _coerceNumber;
                if (!isNil "_c") exitWith { _firstScalar = _c; };
            } forEach _x;
            _firstScalar
        };
        nil
    };

    private _lcFirst = {
        params ["_s"]; 
        if !(_s isEqualType "") exitWith {""};
        if ((count _s) <= 0) exitWith {""};
        (toLower (_s select [0, 1])) + (_s select [1])
    };

    private _readMissionKey = {
        // Returns [valNumberOrNil, catUsed, keyUsed, rawString]
        params ["_cat", "_key"]; 
        private _raw = _cat get3DENMissionAttribute _key;
        private _keyUsed = _key;

        // Try a lower-cased first-letter variant if caller passed camelCase (some systems expose lowercase keys).
        if (isNil { _raw }) then {
            private _k2 = [_key] call _lcFirst;
            if (_k2 != "") then {
                _raw = _cat get3DENMissionAttribute _k2;
                _keyUsed = _k2;
            };
        };

        private _val = [_raw] call _coerceNumber;
        private _rawStr = if (isNil { _raw }) then {"<nil>"} else {str _raw};
        [_val, _cat, _keyUsed, _rawStr]
    };

    private _readIndepAllegiance = {
        // Returns [westValOrNil, eastValOrNil, keyUsed, rawString]
        // This is consistently exposed in your environment under "Intel".
        private _key = "IntelIndepAllegiance";
        private _r = ["Intel", _key] call _readMissionKey;
        private _keyUsed = _r select 2;
        private _raw = ("Intel" get3DENMissionAttribute _keyUsed);
        if (isNil { _raw }) exitWith {[nil, nil, _keyUsed, "<nil>"]};

        // Some implementations may store arrays as strings like "[1,0]".
        if (_raw isEqualType "") then {
            private _parsed = parseSimpleArray _raw;
            if (_parsed isEqualType []) then { _raw = _parsed; };
        };

        if !(_raw isEqualType []) exitWith {[nil, nil, _keyUsed, str _raw]};
        if ((count _raw) < 2) exitWith {[nil, nil, _keyUsed, str _raw]};

        // Documented as: [west:Number, east:Number]
        private _w = [_raw select 0] call _coerceNumber;
        private _e = [_raw select 1] call _coerceNumber;
        [_w, _e, _keyUsed, str _raw]
    };

    // Prefer the modern Indep allegiance attribute if present.
    // It maps INDEP friendliness to west/east explicitly.
    if ((_a isEqualTo independent || {_b isEqualTo independent}) && {(_a in [west, east, independent]) && (_b in [west, east, independent])}) then {
        private _al = call _readIndepAllegiance;
        private _w = _al select 0;
        private _e = _al select 1;
        private _keyUsed = _al select 2;
        private _rawStr = _al select 3;

        if (!isNil "_w" || {!isNil "_e"}) then {
            if ((_a isEqualTo west && {_b isEqualTo independent}) || (_a isEqualTo independent && {_b isEqualTo west})) then {
                if (!isNil "_w") then { _v = _w; _src = format ["Intel.%1=%2", _keyUsed, _rawStr]; };
            };
            if ((_a isEqualTo east && {_b isEqualTo independent}) || (_a isEqualTo independent && {_b isEqualTo east})) then {
                if (!isNil "_e") then { _v = _e; _src = format ["Intel.%1=%2", _keyUsed, _rawStr]; };
            };
        };
    };

    // Legacy "Resistance" side relations are stored under Mission->Intel as resistanceWest/resistanceEast/... in mission.sqm.
    // These are what the classic Eden "Briefing" side-relations UI used historically.
    if ((_a isEqualTo independent && {_b isEqualTo west}) || (_a isEqualTo west && {_b isEqualTo independent})) then {
        private _r = ["Intel", "resistanceWest"] call _readMissionKey;
        private _m = _r select 0;
        if (!isNil "_m") then { _v = _m; _src = format ["%1.%2=%3", _r select 1, _r select 2, _r select 3]; };
    };

    if ((_a isEqualTo independent && {_b isEqualTo east}) || (_a isEqualTo east && {_b isEqualTo independent})) then {
        private _r = ["Intel", "resistanceEast"] call _readMissionKey;
        private _m = _r select 0;
        if (!isNil "_m") then { _v = _m; _src = format ["%1.%2=%3", _r select 1, _r select 2, _r select 3]; };
    };

    if ((_a isEqualTo independent && {_b isEqualTo civilian}) || (_a isEqualTo civilian && {_b isEqualTo independent})) then {
        private _r = ["Intel", "resistanceCiv"] call _readMissionKey;
        private _m = _r select 0;
        if (!isNil "_m") then { _v = _m; _src = format ["%1.%2=%3", _r select 1, _r select 2, _r select 3]; };
    };

    [_v, _src]
};

// Exfil site always created. Offset 5m so it doesn't overlap the HVT(s).
private _exfilPos = _p0;
private _dir = if ((count _men) > 0) then { getDir (_men select 0) } else { 0 };
private _p = ([_p0, 5, _dir + 90] call _offsetPosFrom);
if !(_p isEqualTo []) then { _exfilPos = _p; };

private _exfilName = ["ExfilSite", _exfilPos] call _createHiddenLogic;
if (_exfilName isEqualTo "") exitWith {
    ["Evacuate HVT: Failed to create ExfilSite helper", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

// Ensure selected men are named + immobilized for task start.
private _hvtNames = [];
{
    private _init = (_x get3DENAttribute "init") select 0;
    private _needle = 'this disableAI "MOVE";';
    if (_init isEqualTo "") then {
        _init = _needle;
    } else {
        if ((_init find _needle) == -1) then {
            _init = _init + " " + _needle;
        };
    };
    _x set3DENAttribute ["init", _init];
    _hvtNames pushBack ([_x, "hvt"] call _ensureNamed);
} forEach _men;

private _friendlySide = [_men] call _getFriendlySideFromEden;
private _friendlySideToken = [_friendlySide] call _sideToken;
if (_debug3DEN) then {
    (format ["[3DEN] EdenEvacuateHVT: clickPos=%1 exfilPos=%2 friendlySide=%3 (%4) selectedMen=%5", _p0, _exfilPos, _friendlySideToken, _friendlySide, count _men]) call OKS_fnc_LogDebug;
};

private _example = "";
if (_men isEqualTo []) then {
    // Default: create 3 civilians near click.
    private _dir = 0;
    private _firstName = ["hvt"] call OKS_fnc_next3DENName;
    private _firstUnit = create3DENEntity ["Object", "C_man_1", (_p0 getPos [0, 0])];
    _firstUnit set3DENAttribute ["name", _firstName];
    _firstUnit set3DENAttribute ["init", 'this disableAI "MOVE";'];
    private _grp = group _firstUnit;

    _dir = _dir + 45;
    for "_i" from 2 to 3 do {
        private _unitName = ["hvt"] call OKS_fnc_next3DENName;
        private _unit = _grp create3DENEntity ["Object", "C_man_1", (_p0 getPos [3, _dir])];
        _unit set3DENAttribute ["name", _unitName];
        _unit set3DENAttribute ["presence", 1];
        _unit set3DENAttribute ["init", 'this disableAI "MOVE";'];
        _dir = _dir + 45;
    };

    ["No unit selected: created example HVT group (3 civilians)", 0, 5, true] call BIS_fnc_3DENNotification;
    // Civilians are never treated as enemy here, so IsCaptive stays true.
    _example = format ["[group %1, getPos %2, %3, false, nil, true, false] spawn OKS_fnc_Evacuate_HVT;", _firstName, _exfilName, _friendlySideToken];
} else {
    private _groups = [];
    { _groups pushBackUnique (group _x); } forEach _men;
    _groups = _groups select { !isNull _x };

    private _unitsExpr = "";
    if ((count _groups) == 1) then {
        _unitsExpr = format ["group %1", _hvtNames select 0];
    } else {
        _unitsExpr = format ["[%1]", _hvtNames joinString ", "];
    };

    // Enemy HVTs should NOT be captive (they will fight / surrender). Friendly/civ HVTs are captive by default.
    private _sideHvt = side group (_men select 0);
    private _fv = [_sideHvt, _friendlySide] call _friendValue3DEN;
    private _friendVal = _fv select 0;
    private _friendSrc = _fv select 1;
    private _isEnemy = (_sideHvt != civilian) && {_friendVal < 0.6};
    private _isCaptive = !_isEnemy;
    if (_debug3DEN) then {
        (format ["[3DEN] EdenEvacuateHVT: sideHvt=%1 friendlySide=%2 friend=%3 (%4) isEnemy=%5 isCaptive=%6", _sideHvt, _friendlySide, _friendVal, _friendSrc, _isEnemy, _isCaptive]) call OKS_fnc_LogDebug;
    };
    _example = format ["[%1, getPos %2, %3, false, nil, %4, false] spawn OKS_fnc_Evacuate_HVT;", _unitsExpr, _exfilName, _friendlySideToken, _isCaptive];
};

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);
private _logText = format ["CopiedToClipboard: %1", _example];
[_logText, true] call OKS_fnc_LogDebug;

private _notify = if (_debug3DEN) then {format ["Evacuate HVT copied (exfil: %1)", _exfilName]} else {"Evacuate HVT copied to clipboard"};
_notify = format ["%1 | Cache=%2", _notify, _cacheCount];
[_notify, 0, 5, true] call BIS_fnc_3DENNotification;

true