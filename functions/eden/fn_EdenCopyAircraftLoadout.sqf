/*
    Function: OKS_fnc_EdenCopyAircraftLoadout

    Description:
        Eden Editor right-click action (GEAR → Copy Loadout).
        Reads the pylon loadout from each selected aircraft and copies a
        ready-to-use OKS_fnc_AirSpawn _Airframes template array to clipboard.

        Output format (paste directly as the _Airframes parameter in AirSpawn):
            [["className", ["pylonMag1", "pylonMag2", ...]], ...]

        Multiple selected aircraft are exported as separate template entries.

    Usage from CfgEden:
        [] call OKS_fnc_EdenCopyAircraftLoadout;

    Returns:
        Nothing
*/

private _debug3DEN = uiNamespace getVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", false]];

private _selectedObjects = get3DENSelected "object";

private _isAirframe = {
    params ["_object"];
    if (isNull _object) exitWith {false};
    private _cfg = configFile >> "CfgVehicles" >> typeOf _object;
    (_object isKindOf "Air")
    || {_object isKindOf "UAV"}
    || {getNumber (_cfg >> "isUav") isEqualTo 1}
    || {getNumber (_cfg >> "uavCamera") > 0}
};

private _selectedAirframes = _selectedObjects select {[_x] call _isAirframe};

if (_selectedAirframes isEqualTo []) exitWith {
    if (_debug3DEN) then {
        ["[3DEN] CopyAircraftLoadout: No aircraft selected", false, true] call OKS_fnc_LogDebug;
    };
    ["Copy Loadout: select one or more aircraft first", 1, 5, true] call BIS_fnc_3DENNotification;
};

// Build template array: [[classname, [pylonMag1, ...]], ...]
// This maps directly to the _Airframes template format used by OKS_fnc_AirSpawn.
private _templates = _selectedAirframes apply {
    private _className = typeOf _x;
    private _pylons = getPylonMagazines _x;
    [_className, _pylons]
};

private _templatesStr = str _templates;

copyToClipboard _templatesStr;
[_templatesStr] call OKS_fnc_EdenClipboardCacheAdd;

private _aircraftCount = count _selectedAirframes;
private _cacheCount = count (uiNamespace getVariable ["OKS_3DEN_CLIPBOARD_CACHE", []]);

if (_debug3DEN) then {
    [format ["[3DEN] CopyAircraftLoadout: Copied %1 airframe(s) | Result=%2 | Cache=%3", _aircraftCount, _templatesStr, _cacheCount], false, true] call OKS_fnc_LogDebug;
};

systemChat format ["CopiedToClipboard | Aircraft loadout: %1 airframe(s) copied as AirSpawn template | Cache=%2", _aircraftCount, _cacheCount];
[format ["Loadout copied (%1 airframe(s)) — paste as _Airframes in AirSpawn | Cache=%2", _aircraftCount, _cacheCount], 0, 10, true] call BIS_fnc_3DENNotification;
