/*
    OKS_fnc_EdenGetOrCreateLayer

    Gets an existing top-level 3DEN Layer by exact name, or creates it.

        Params:
            0: STRING - Layer name (exact match)
            1: ANY (Optional) - Parent layer
                        - STRING: parent layer name (top-level)
                        - SCALAR/OBJECT: parent layer handle
                        - nil/"": top-level

        Returns:
            ANY - Layer handle usable with set3DENLayer.
                        Prefer returning the layer entity (OBJECT) when possible.
*/

private _args = if (isNil "_this") then { [] } else { _this };
if (!(_args isEqualType [])) then { _args = []; };

_args params [
    ["_layerName", "", [""]],
    ["_parent", nil, ["", 0, objNull]]
];

if (!is3DEN) exitWith { objNull };
if (_layerName isEqualTo "") exitWith { objNull };

// Helps verify which version is loaded in-game.
// - Primary: RPT log (easy to find)
// - Secondary: debug console variable (optional)
private _version = 260104;
if (isNil { uiNamespace getVariable "OKS_3DEN_LAYER_GETORCREATE_LOGGED" }) then {
    uiNamespace setVariable ["OKS_3DEN_LAYER_GETORCREATE_LOGGED", true];
    diag_log format ["[OKS][3DEN] OKS_fnc_EdenGetOrCreateLayer version %1", _version];
};
uiNamespace setVariable ["OKS_3DEN_LAYER_GETORCREATE_VERSION", _version];

private _hasParent = !(isNil { _parent });
if (_hasParent && {_parent isEqualType "" && {_parent isEqualTo ""}}) then {
    _parent = nil;
    _hasParent = false;
};

private _parentHandle = -1;
private _parentName = "";

if (_hasParent) then {
    switch (typeName _parent) do {
        case "STRING": {
            _parentName = _parent;
            private _resolved = [_parentName] call OKS_fnc_EdenGetOrCreateLayer;
            if (!isNil "_resolved") then { _parentHandle = _resolved; };
        };
        case "SCALAR": {
            _parentHandle = _parent;
        };
        case "OBJECT": {
            if (!isNull _parent) then { _parentHandle = _parent; };
        };
    };
};

if (_parentName isEqualTo "" && {_hasParent}) then {
    private _canReadName = false;
    switch (typeName _parentHandle) do {
        case "OBJECT": { _canReadName = !isNull _parentHandle; };
        case "SCALAR": { _canReadName = _parentHandle >= 0; };
    };

    if (_canReadName) then {
        private _attr = _parentHandle get3DENAttribute "name";
        private _n = if (_attr isEqualType [] && {(count _attr) > 0}) then { _attr select 0 } else { "" };
        if (_n isEqualType "" && {_n isNotEqualTo ""}) then {
            _parentName = _n;
        } else {
            _parentName = str _parentHandle;
        };
    } else {
        _parentName = "(top)";
    };
};

private _cacheKey = if (_hasParent && {_parentName isNotEqualTo ""}) then {
    format ["%1/%2", _parentName, _layerName]
} else {
    _layerName
};

// Cache to avoid creating duplicate layers if the engine representation is hard to resolve.
private _cache = uiNamespace getVariable ["OKS_3DEN_LAYER_CACHE", createHashMap];
private _cached = _cache getOrDefault [_cacheKey, nil];
if (!isNil "_cached") then {
    private _cachedOk = false;
    switch (typeName _cached) do {
        case "OBJECT": { _cachedOk = !isNull _cached; };
        case "SCALAR": { _cachedOk = _cached >= 0; };
        default { _cachedOk = false; };
    };
    if (_cachedOk) exitWith { _cached };
};

private _layers = all3DENEntities select 6;
private _layer = objNull;
private _matchScalar = nil;
private _matchObject = objNull;

private _fnc_layerName = {
    params ["_h"];
    if (isNil { _h }) exitWith { "" };
    private _ok = false;
    switch (typeName _h) do {
        case "OBJECT": { _ok = !isNull _h; };
        case "SCALAR": { _ok = _h >= 0; };
    };
    if (!_ok) exitWith { "" };

    private _attr = _h get3DENAttribute "name";
    if (!(_attr isEqualType []) || {(count _attr) == 0}) exitWith { "" };
    private _n = _attr select 0;
    if (_n isEqualType "") then { _n } else { "" };
};

if (_layers isEqualType []) then {
    {
        private _candidateLayer = _x;
        private _candidateName = "";
        if ((typeName _candidateLayer) == "SCALAR") then {
            private _attr = _candidateLayer get3DENAttribute "name";
            _candidateName = if (_attr isEqualType [] && {(count _attr) > 0}) then { _attr select 0 } else { "" };
            if (_candidateName isEqualTo _layerName) then {
                if (!_hasParent) then {
                    _matchScalar = _candidateLayer;
                } else {
                    private _parentOk = false;

                    // Determine candidate's parent name (engine attribute key varies by build).
                    private _candidateParentName = "";
                    {
                        private _k = _x;
                        private _a = _candidateLayer get3DENAttribute _k;
                        if (_a isEqualType [] && {(count _a) > 0}) exitWith {
                            private _ph = _a select 0;
                            if(!isNil "_ph") then {
                            _candidateParentName = [_ph] call _fnc_layerName;
                            }
                        };
                    } forEach ["parent", "parentLayer", "layerParent"];

                    if (_candidateParentName isNotEqualTo "") then {
                        _parentOk = (_candidateParentName isEqualTo _parentName);
                    } else {
                        // If we can't read parent name, fall back to accepting the first match
                        // to avoid spamming duplicate child layers.
                        _parentOk = true;
                    };
                    if (_parentOk) then { _matchScalar = _candidateLayer; };
                };
            };
        } else {
            if ((_candidateLayer isEqualType objNull) && {!isNull _candidateLayer}) then {
                private _attr = _candidateLayer get3DENAttribute "name";
                _candidateName = if (_attr isEqualType [] && {(count _attr) > 0}) then { _attr select 0 } else { "" };
                if (_candidateName isEqualTo _layerName) then {
                    if (!_hasParent) then {
                        _matchObject = _candidateLayer;
                    } else {
                        private _parentOk = false;

                        private _candidateParentName = "";
                        {
                            private _k = _x;
                            private _a = _candidateLayer get3DENAttribute _k;
                            if (_a isEqualType [] && {(count _a) > 0}) exitWith {
                                private _ph = _a select 0;
                                _candidateParentName = [_ph] call _fnc_layerName;
                            };
                        } forEach ["parent", "parentLayer", "layerParent"];

                        if (_candidateParentName isNotEqualTo "") then {
                            _parentOk = (_candidateParentName isEqualTo _parentName);
                        } else {
                            _parentOk = true;
                        };
                        if (_parentOk) then { _matchObject = _candidateLayer; };
                    };
                };
            };
        };
    } forEach _layers;
};

if (!isNil "_matchScalar") then {
    _layer = _matchScalar;
} else {
    if (!isNull _matchObject) then {
        _layer = _matchObject;
    };
};

private _missing = true;
switch (typeName _layer) do {
    case "OBJECT": {
        _missing = isNull _layer;
    };
    case "SCALAR": {
        // Some Eden builds represent layers as numeric ids.
        _missing = (_layer < 0);
    };
    default {
        // Some builds / failure states can yield BOOL/ARRAY/etc.
        // Treat as missing and attempt to create/resolve.
        _missing = true;
    };
};

if (_missing) then {
    // add3DENLayer returns a layer handle (often a SCALAR). Keep that stable handle.
    private _parentToUse = -1;
    if (_hasParent) then {
        switch (typeName _parentHandle) do {
            case "OBJECT": { if (!isNull _parentHandle) then { _parentToUse = _parentHandle; }; };
            case "SCALAR": { if (_parentHandle >= 0) then { _parentToUse = _parentHandle; }; };
        };
    };
    _layer = (_parentToUse add3DENLayer _layerName);
};

_cache set [_cacheKey, _layer];
uiNamespace setVariable ["OKS_3DEN_LAYER_CACHE", _cache];

_layer;
