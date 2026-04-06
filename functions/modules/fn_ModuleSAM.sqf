/*
    OKS_fnc_ModuleSAM

    Module function for OKS_Module_SAM.
    Called by the engine when the module activates (immediate or via synced trigger).

    Sync a SAM launcher to use it directly. If no launcher is synced,
    one is spawned from the fallback classname at the module position.
    A radar vehicle MUST also be synced or placed nearby.

    Standard module signature: [_logic, _units, _activated]
*/

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (isNull _logic) exitWith {};
if (hasInterface && !isServer) exitWith {};

// --- Read module attributes ---
private _fallbackVehicle     = _logic getVariable ["FallbackVehicle", "GOL_O_SAM_System_04_F"];
private _rateOfFire          = _logic getVariable ["RateOfFire", 20];
private _ammo                = _logic getVariable ["Ammo", 4];
private _reloadRate          = _logic getVariable ["ReloadRate", 20];
private _minimumAltitude     = _logic getVariable ["MinimumAltitude", 100];
private _maxRange            = _logic getVariable ["MaxRange", 3000];
private _maxMissilesPerTarget = _logic getVariable ["MaxMissilesPerTarget", 2];
private _delay               = _logic getVariable ["Delay", 0];

// --- Delay ---
if (_delay > 0) then { sleep _delay; };

// --- Resolve synced objects ---
private _samObj   = objNull;
private _radarObj = objNull;
// Separate synced objects into launcher vs radar.
// A vehicle with missile weapons is the launcher; a pure radarType=2 vehicle
// without missiles is the radar. If both have radarType=2 (common for SAM
// launchers with built-in radar), the one with missiles becomes the launcher.
private _candidates = [];
{
    if (_x isKindOf "Logic" || _x isKindOf "EmptyDetector") then { continue; };
    _candidates pushBack _x;
} forEach (synchronizedObjects _logic);

// First pass: identify launcher (has missile weapons) vs radar (radarType=2, no missiles)
{
    private _hasMissiles = false;
    {
        private _compatMags = compatibleMagazines _x;
        {
            private _ammoClass = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
            if (_ammoClass isKindOf "MissileBase") exitWith { _hasMissiles = true; };
        } forEach _compatMags;
        if (_hasMissiles) exitWith {};
    } forEach (weapons _x);

    if (_hasMissiles) then {
        if (isNull _samObj) then { _samObj = _x; };
    } else {
        private _rt = getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "radarType");
        if (_rt isEqualTo 2) then { _radarObj = _x; };
    };
} forEach _candidates;

// Fallback: if no launcher found by weapons, take any non-radar candidate
if (isNull _samObj) then {
    {
        if (_x isEqualTo _radarObj) then { continue; };
        _samObj = _x;
    } forEach _candidates;
};
// If no radar found, check all candidates for radarType=2
if (isNull _radarObj) then {
    {
        if (_x isEqualTo _samObj) then { continue; };
        private _rt = getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "radarType");
        if (_rt isEqualTo 2) exitWith { _radarObj = _x; };
    } forEach _candidates;
};

diag_log format ["[Module SAM] Sync resolved | launcher=%1 (%2) radar=%3 (%4) candidates=%5",
    _samObj, typeOf _samObj, _radarObj, typeOf _radarObj, count _candidates];

// Fallback: spawn SAM launcher at module position
if (isNull _samObj) then {
    private _spawnPos = getPosATL _logic;
    _spawnPos set [2, 0];
    _samObj = createVehicle [_fallbackVehicle, _spawnPos, [], 0, "CAN_COLLIDE"];
    if (isNull _samObj) exitWith {
        format ["[Module SAM] ERROR: Failed to spawn vehicle %1", _fallbackVehicle] spawn OKS_fnc_LogDebug;
    };
    _samObj setDir (getDir _logic);
    format ["[Module SAM] Spawned SAM: %1 at %2", _fallbackVehicle, _spawnPos] spawn OKS_fnc_LogDebug;
};

// If no radar synced, try to find one nearby
if (isNull _radarObj) then {
    private _nearRadars = (getPosATL _samObj) nearEntities ["StaticWeapon", 200];
    _nearRadars = _nearRadars + ((getPosATL _samObj) nearEntities ["LandVehicle", 200]);
    {
        private _rt = getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "radarType");
        if (_rt isEqualTo 2) exitWith { _radarObj = _x; };
    } forEach _nearRadars;
};

if (isNull _radarObj) exitWith {
    "[Module SAM] ERROR: No radar synced or found nearby. SAM requires a radar." spawn OKS_fnc_LogDebug;
};

// --- Build args and call core script ---
private _args = [
    _samObj,
    _radarObj,
    _rateOfFire,
    _ammo,
    _reloadRate,
    _minimumAltitude,
    _maxRange,
    _maxMissilesPerTarget
];

format ["[Module SAM] Executing with args: %1", _args] spawn OKS_fnc_LogDebug;

_args spawn OKS_fnc_SAM;

// Clean up module logic
deleteVehicle _logic;
