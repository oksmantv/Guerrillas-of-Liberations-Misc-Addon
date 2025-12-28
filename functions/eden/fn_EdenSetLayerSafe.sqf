/*
    OKS_fnc_EdenSetLayerSafe

    Applies a 3DEN layer to an entity in a way that works across entity types.

    Why this exists:
      - Some 3DEN entity handles are returned as STRINGs (notably markers)
      - set3DENLayer can be picky about which handle type it accepts

    Params:
      0: ANY - 3DEN entity handle (OBJECT/SCALAR/STRING/etc)
      1: ANY - Layer handle (OBJECT/SCALAR)

    Returns:
      BOOL
*/

params [
    ["_entity", nil],
    ["_layer", nil]
];

if (!is3DEN) exitWith { false };
if (isNil "_entity" || {isNil "_layer"}) exitWith { false };

private _ok = false;

// First attempt: direct.
_entity set3DENLayer _layer;
_ok = true;

// Marker special-case: resolve the marker "entity" from all3DENEntities and apply the layer there too.
if ((typeName _entity) == "STRING") then {
    private _markerName = _entity;
    private _allMarkers = all3DENEntities select 5;
    if (_allMarkers isEqualType []) then {
        {
            private _candidate = _x;
            private _s = str _candidate;
            if ((count _s) >= 2) then {
                private _cleanName = _s select [1, (count _s) - 2];
                if (_cleanName == _markerName) exitWith {
                    _candidate set3DENLayer _layer;
                    _ok = true;
                };
            };
        } forEach _allMarkers;
    };
};

_ok;
