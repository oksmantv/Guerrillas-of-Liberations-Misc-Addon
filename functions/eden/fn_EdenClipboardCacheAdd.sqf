/*
    Adds a clipboard snippet line to the 3DEN clipboard cache.
    Cache lives in uiNamespace for the current editor session.

    Params:
      0: STRING - snippet to cache

    Returns:
      BOOL - true if added
*/

params [
    ["_snippet", "", [""]]
];

if (_snippet isEqualTo "") exitWith { false };

private _cache = uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []];
if !(_cache isEqualType []) then { _cache = [] };

_cache pushBack _snippet;
uiNamespace setVariable ["OKS_3DEN_CLIPBOARD_CACHE", _cache];

true;
