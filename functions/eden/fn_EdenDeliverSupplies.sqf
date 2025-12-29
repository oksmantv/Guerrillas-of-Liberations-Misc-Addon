/*
    OKS_fnc_EdenDeliverSupplies

    3DEN helper:
    - Right-click terrain (or run from context menu)
    - Creates a destination trigger for deliver-supplies drop-off
    - Copies default function calls (ammo/water/food/fuel) to clipboard
    - Adds the copied text to the Eden clipboard cache
*/

params ["_menuData"];

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

private _md = if (_menuData isEqualType []) then { _menuData } else { [] };

private _anchorPos = {
    params ["_md"];
    private _p = [];

    if (_md isEqualType []) then {
        _p = [_md] call OKS_fnc_EdenPosFromArray;
    };

    if (_p isEqualTo []) then {
        private _md0 = _md param [0, []];
        if (_md0 isEqualType []) then {
            _p = [_md0] call OKS_fnc_EdenPosFromArray;
        };
    };

    if (_p isEqualTo []) then { _p = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray; };
    _p set [2, 0];
    _p = [_p] call OKS_fnc_EdenSanitizePos;
    if (_p isEqualTo []) exitWith { [] };
    _p
};

private _p0 = [_md] call _anchorPos;
if (_p0 isEqualTo []) exitWith {
    ["Deliver Supplies: Invalid click position", 1, 6, true] call BIS_fnc_3DENNotification;
    false
};

private _trg = create3DENEntity ["Trigger", "EmptyDetector", _p0];
if (isNull _trg) exitWith {
    ["Deliver Supplies: Failed to create trigger", 1, 6, true] call BIS_fnc_3DENNotification;
    false
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

private _trgName = [_trg, "DeliveryTrigger"] call _ensureNamed;

// Visual defaults in Eden.
_trg set3DENAttribute ["size3", [15, 15, 0]];
_trg set3DENAttribute ["IsRectangle", false];
_trg set3DENAttribute ["text", format ["Deliver Supplies Drop-off: %1", _trgName]];
_trg set3DENAttribute ["activationBy", "ANYPLAYER"];
_trg set3DENAttribute ["activationType", "PRESENT"];
_trg set3DENAttribute ["repeatable", false];
_trg set3DENAttribute ["repeating", false];

private _exampleLines = [
    format ["[%1, \"ammo\", 1, \"OKS_Delivery_MainTask\", \"Delivery to Area\", \"Deliver Ammo\"] spawn OKS_fnc_Deliver_Supplies;", _trgName],
    format ["[%1, \"water\", 1, \"OKS_Delivery_MainTask\", \"Delivery to Area\", \"Deliver Water\"] spawn OKS_fnc_Deliver_Supplies;", _trgName],
    format ["[%1, \"food\", 1, \"OKS_Delivery_MainTask\", \"Delivery to Area\", \"Deliver Food\"] spawn OKS_fnc_Deliver_Supplies;", _trgName],
    format ["[%1, \"fuel\", 1, \"OKS_Delivery_MainTask\", \"Delivery to Area\", \"Deliver Fuel\"] spawn OKS_fnc_Deliver_Supplies;", _trgName]
];

private _example = _exampleLines joinString "\n";

copyToClipboard _example;
[_example] call OKS_fnc_EdenClipboardCacheAdd;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

["OKS_fnc_EdenDeliverSupplies", [], [_trg]] call OKS_fnc_EdenRememberLastAction;

private _logExample = _example splitString "\r\n" joinString " ";
private _logText = format ["CopiedToClipboard | Deliver Supplies copied to clipboard | Cache=%1 | %2", _cacheCount, _logExample];
[_logText, false, true, true] call OKS_fnc_LogDebug;

if (_debug3DEN) then {
    [format ["Deliver Supplies | trigger=%1 pos=%2", _trgName, _p0], false, true, true] call OKS_fnc_LogDebug;
};

systemChat format ["CopiedToClipboard | Deliver Supplies copied to clipboard | Cache=%1", _cacheCount];
[format ["Deliver Supplies copied to clipboard (trigger: %1) | Cache=%2", _trgName, _cacheCount], 0, 10, true] call BIS_fnc_3DENNotification;
true
