/*
    OKS_fnc_EdenGetOrCreateLayer

    Gets an existing top-level 3DEN Layer by exact name, or creates it.

    Params:
      0: STRING - Layer name (exact match)

        Returns:
            ANY - Layer handle usable with set3DENLayer.
                        Prefer returning the layer entity (OBJECT) when possible.
*/

params [
    ["_layerName", "", [""]]
];

if (!is3DEN) exitWith { objNull };
if (_layerName isEqualTo "") exitWith { objNull };

// Cache to avoid creating duplicate layers if the engine representation is hard to resolve.
private _cache = uiNamespace getVariable ["OKS_3DEN_LAYER_CACHE", createHashMap];
private _cached = _cache getOrDefault [_layerName, nil];
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
if (_layers isEqualType []) then {
    {
        if ((typeName _x) == "SCALAR") then {
            private _attr = _x get3DENAttribute "name";
            private _n = if (_attr isEqualType [] && {(count _attr) > 0}) then { _attr select 0 } else { "" };
            if (_n isEqualTo _layerName) then { _matchScalar = _x; };
        } else {
            if ((_x isEqualType objNull) && {!isNull _x}) then {
                private _attr = _x get3DENAttribute "name";
                private _n = if (_attr isEqualType [] && {(count _attr) > 0}) then { _attr select 0 } else { "" };
                if (_n isEqualTo _layerName) then { _matchObject = _x; };
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
    _layer = (-1 add3DENLayer _layerName);
};

_cache set [_layerName, _layer];
uiNamespace setVariable ["OKS_3DEN_LAYER_CACHE", _cache];

_layer;
