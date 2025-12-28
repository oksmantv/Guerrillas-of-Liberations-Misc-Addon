/*
    Exports the current 3DEN clipboard cache to clipboard and clears it.

    Format:
      - Joined with newline (paste-ready SQF lines)
      - No wrapping quotes/brackets

    Returns:
      ARRAY [BOOL exported, NUMBER lineCount]
*/

private _cache = uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []];
if !(_cache isEqualType []) then { _cache = [] };

private _count = count _cache;
if (_count <= 0) exitWith {
  ["[3DEN] Clipboard cache is empty", false, true, true] call OKS_fnc_LogDebug;
    ["Export: clipboard cache is empty", 0, 5, true, 0.5] call BIS_fnc_3DENNotification;
    [false, 0]
};

private _text = _cache joinString toString [13,10];
copyToClipboard _text;
systemChat format ["Export: copied %1 line%2 (cache cleared)", _count, ["", "s"] select (_count != 1)];

uiNamespace setVariable ["OKS_3DEN_CLIPBOARD_CACHE", []];

[format ["[3DEN] Exported & cleared clipboard cache (%1 lines)", _count], false, true, true] call OKS_fnc_LogDebug;
[format ["Export: copied %1 line%2 (cache cleared)", _count, ["", "s"] select (_count != 1)], 0, 5, true, 0.5] call BIS_fnc_3DENNotification;

[true, _count]
