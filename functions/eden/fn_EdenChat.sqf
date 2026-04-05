/*
    OKS_fnc_EdenChat

    Eden helper – copies a spawnList-ready OKS_fnc_ChatGlobal call to clipboard.

    Called from CfgEden context menu with the channel passed as argument:
      ["side"]  call OKS_fnc_EdenChat;
      ["local"] call OKS_fnc_EdenChat;

    - If an entity is selected its variable name is used as _Talker.
    - For "side" channel without a selected entity, defaults to preset callsign "HQ".
    - "local" channel requires an entity (object) – will warn if nothing is selected.
*/

params [["_channel", "side", [""]]];

private _selected = get3DENSelected "object";
private _talkerStr = "";

if (_selected isEqualTo []) then {
    if (toLower _channel == "local") exitWith {
        ["Chat: Local channel requires a selected entity.", 1, 5, true] call BIS_fnc_3DENNotification;
    };
    _talkerStr = """COMMAND HQ""";
} else {
    private _obj = _selected select 0;
    private _nameAttr = (_obj get3DENAttribute "name") select 0;
    if (_nameAttr isEqualTo "") then {
        private _newName = ["ChatTalker"] call OKS_fnc_next3DENName;
        _obj set3DENAttribute ["name", _newName];
        _nameAttr = _newName;
    };
    _talkerStr = _nameAttr;
};

if (_talkerStr isEqualTo "") exitWith { false };
private _example = format [
    "[%1,""%2"",""1st Platoon, insert your message here, HQ, out.""] spawn OKS_fnc_ChatGlobal;",
    _talkerStr,
    toLower _channel
];

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenChat", [_channel], _selected] call OKS_fnc_EdenRememberLastAction;
systemChat format ["CopiedToClipboard | Chat (%1) copied to clipboard | Cache=%2", _channel, _cacheCount];
[format ["CopiedToClipboard | Chat (%1) copied to clipboard | Cache=%2 | %3", _channel, _cacheCount, _example], false, true, true] call OKS_fnc_LogDebug;
[format ["Chat (%1) copied to clipboard | Cache=%2", _channel, _cacheCount], 0, 10, true] call BIS_fnc_3DENNotification;

true
