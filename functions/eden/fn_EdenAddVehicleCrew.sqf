/*
    OKS_fnc_EdenAddVehicleCrew

    Description:
    Eden context menu wrapper for OKS_fnc_AddVehicleCrew.
    Right-click a vehicle in Eden Editor > GOL Spawns > Add Vehicle Crew > (crew option).
    Adds an init line to the selected vehicle so it gets crewed at mission start.
    Side is read from the GW framework global side variable (GW_FRAMEWORK_GLOBAL_SIDE).

    Supports:
    - Clipboard cache (OKS_fnc_EdenClipboardCacheAdd)
    - Repeat last action (OKS_fnc_EdenRememberLastAction / OKS_fnc_EdenRepeatLastAction)

    Parameters:
    _crewSlots - NUMBER - Crew slot mode passed to OKS_fnc_AddVehicleCrew
                 0 = Full Crew, 1 = Driver Only, 2 = Gunner Only, 3 = Commander Only

    Usage (from CfgEden action):
    [0] call OKS_fnc_EdenAddVehicleCrew;  // Full Crew
    [1] call OKS_fnc_EdenAddVehicleCrew;  // Driver Only
    [2] call OKS_fnc_EdenAddVehicleCrew;  // Gunner Only
    [3] call OKS_fnc_EdenAddVehicleCrew;  // Commander Only
*/

params [
    ["_crewSlots", 0, [0]]
];

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

// Get selected objects in Eden — on repeat, fall back to last remembered context objects
private _selected = get3DENSelected "object";

if (count _selected == 0) then {
    // Repeat-last-action fallback: try last remembered context objects
    private _payload = uiNamespace getVariable ["OKS_3DEN_LAST_ACTION", []];
    if (_payload isEqualType [] && {count _payload >= 3}) then {
        private _lastObjs = _payload select 2;
        if (_lastObjs isEqualType [] && {count _lastObjs > 0}) then {
            _selected = _lastObjs select { !isNull _x };
        };
    };
};

if (count _selected == 0) exitWith {
    if (_debug3DEN) then {
        "[3DEN] Add Vehicle Crew: No objects selected" call OKS_fnc_LogDebug;
    };
    ["Add Vehicle Crew: select one or more vehicles first", 1, 5, true] call BIS_fnc_3DENNotification;
    false
};

// Read side from GW framework global
private _sideString = toUpper (uiNamespace getVariable ["GW_FRAMEWORK_GLOBAL_SIDE", "EAST"]);
private _side = switch (_sideString) do {
    case "WEST":        { "west" };
    case "EAST":        { "east" };
    case "INDEPENDENT": { "independent" };
    case "GUER":        { "independent" };
    default             { "east" };
};

private _crewLabel = switch (_crewSlots) do {
    case 0: { "Full Crew" };
    case 1: { "Driver Only" };
    case 2: { "Gunner Only" };
    case 3: { "Commander Only" };
    default { "Full Crew" };
};

private _count = 0;
private _snippets = [];
private _contextObjects = [];

{
    private _obj = _x;
    private _type = typeOf _obj;

    // Only process vehicles (not infantry / static objects without crew positions)
    private _isVehicle = (_type isKindOf "LandVehicle")
                      || (_type isKindOf "Air")
                      || (_type isKindOf "Ship")
                      || (_type isKindOf "StaticWeapon");

    if (!_isVehicle) then {
        if (_debug3DEN) then {
            format ["[3DEN] Add Vehicle Crew: Skipping non-vehicle %1", _type] call OKS_fnc_LogDebug;
        };
    } else {
        // Build the init line that will execute at mission start
        private _initLine = format [
            "[this, %1, %2] call OKS_fnc_AddVehicleCrew;",
            _side,
            _crewSlots
        ];

        // Get existing init and append (don't overwrite)
        private _existingInit = _obj get3DENAttribute "Init";
        private _currentInit = if (count _existingInit > 0) then { _existingInit select 0 } else { "" };

        if (_currentInit != "") then {
            // Check if we already have an AddVehicleCrew call - replace it
            if ("OKS_fnc_AddVehicleCrew" in _currentInit) then {
                private _lines = _currentInit splitString ";";
                private _newLines = [];
                {
                    private _line = _x;
                    if !("OKS_fnc_AddVehicleCrew" in _line) then {
                        _newLines pushBack _line;
                    };
                } forEach _lines;
                _newLines pushBack _initLine;
                _initLine = (_newLines joinString ";");
            } else {
                _initLine = _currentInit + " " + _initLine;
            };
        };

        _obj set3DENAttribute ["Init", _initLine];
        _count = _count + 1;
        _contextObjects pushBack _obj;

        // Build a clipboard snippet for this vehicle
        private _snippet = format [
            "[this, %1, %2] call OKS_fnc_AddVehicleCrew; // %3 (%4)",
            _side,
            _crewSlots,
            _type,
            _crewLabel
        ];
        _snippets pushBack _snippet;

        if (_debug3DEN) then {
            format ["[3DEN] Add Vehicle Crew: Set init on %1 (%2, %3)", _type, _side, _crewLabel] call OKS_fnc_LogDebug;
        };
    };
} forEach _selected;

if (_count > 0) then {
    // Copy to clipboard and add to cache
    private _clipboardText = _snippets joinString endl;
    copyToClipboard _clipboardText;
    [_clipboardText] call OKS_fnc_EdenClipboardCacheAdd;
    private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

    // Remember last action for repeat
    ["OKS_fnc_EdenAddVehicleCrew", [_crewSlots], _contextObjects] call OKS_fnc_EdenRememberLastAction;

    [format ["Add Vehicle Crew: %1 applied to %2 vehicle(s) [Side: %3] | Cache=%4", _crewLabel, _count, toUpper _side, _cacheCount], 0, 5, true] call BIS_fnc_3DENNotification;
    systemChat format ["CopiedToClipboard | Add Vehicle Crew (%1) | %2 vehicle(s) | Cache=%3", _crewLabel, _count, _cacheCount];
    true
} else {
    ["Add Vehicle Crew: No valid vehicles in selection", 1, 5, true] call BIS_fnc_3DENNotification;
    false
};
