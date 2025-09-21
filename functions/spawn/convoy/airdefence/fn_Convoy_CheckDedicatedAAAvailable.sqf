/*
    OKS_fnc_Convoy_CheckDedicatedAAAvailable
    Checks if there are any dedicated AA vehicles available that don't have cargo seats.
    This prevents vehicles with passengers from being used for air defense (avoiding dismounts).
    
    Usage: [_vehicleArray] call OKS_fnc_Convoy_CheckDedicatedAAAvailable;
    Returns: Number of suitable dedicated AA vehicles (0 = no air defense should run)
*/

params ["_vehicleArray"];

private _isConvoyDebugEnabled = missionNamespace getVariable ["GOL_Convoy_AA_Debug", false];
private _dedicatedAACount = 0;
private _excludedVehicles = [];
private _aaVehicles = [];
{
    if (isNull _x || !alive _x || !canMove _x) then { continue };
    private _vehicleTypeLower = toLower (typeOf _x);
    private _vehicleConfig = configFile >> "CfgVehicles" >> typeOf _x;
    // Check if vehicle has cargo seats/slots (passengers that could dismount)
    private _cargoSeats = getNumber (_vehicleConfig >> "transportSoldier");
    private _hasCargoSeats = _cargoSeats > 0;
    // Check if vehicle has actual cargo units aboard
    private _cargoUnits = [];
    {
        if ((_x select 1) == "cargo") then {
            _cargoUnits pushBack (_x select 0);
        };
    } forEach (fullCrew _x);
    private _hasCargoAboard = (count _cargoUnits) > 0;
    // Only exclude from AA if cargo seats are actually occupied (cargo aboard)
    if (_hasCargoAboard) then {
        _excludedVehicles pushBack [typeOf _x, _cargoSeats, count _cargoUnits];
        if (_isConvoyDebugEnabled) then {
            format [
                "[CONVOY_AA_CHECK] Excluding %1 from AA selection - Cargo seats: %2, Cargo aboard: %3",
                typeOf _x, _cargoSeats, count _cargoUnits
            ] spawn OKS_fnc_LogDebug;
        };
        continue;
    };
    // Now check if this is a truly dedicated AA vehicle (high scoring criteria)
    private _hasGunner = (count (fullCrew [_x, "gunner", true])) > 0;
    private _hasRadar = (getNumber (_vehicleConfig >> "radarType")) > 0;
    private _radarComponent = _vehicleConfig >> "Components" >> "SensorsManagerComponent" >> "Components" >> "ActiveRadarSensorComponent";
    private _hasActiveRadarComponent = isClass _radarComponent;
    private _isKnownAAVehicle = (
        (_x isKindOf "APC_Tracked_01_AA_F") ||
        (_x isKindOf "APC_Tracked_02_AA_F") ||
        {(_vehicleTypeLower find "aa") >= 0} ||
        {(_vehicleTypeLower find "tigris") >= 0} ||
        {(_vehicleTypeLower find "cheetah") >= 0} ||
        {(_vehicleTypeLower find "zsu") >= 0} ||
        {(_vehicleTypeLower find "zu23") >= 0} ||
        {(_vehicleTypeLower find "shilka") >= 0}
    );
    private _hasAAMissiles = false;
    private _hasAAAutoCannon = false;
    private _vehicleWeapons = getArray (_vehicleConfig >> "weapons");
    {
        private _weaponLower = toLower _x;
        if (((_weaponLower find "missile") >= 0) || ((_weaponLower find "aa") >= 0)) then { _hasAAMissiles = true; };
        if (((_weaponLower find "autocannon") >= 0) || ((_weaponLower find "35mm") >= 0) || ((_weaponLower find "gatling") >= 0)) then { _hasAAAutoCannon = true; };
    } forEach _vehicleWeapons;
    private _hasAnyAAAmmo = false;
    private _vehicleMagazines = magazinesAmmoFull _x;
    {
        private _magazineInfo = _x;
        private _magazineClassLower = "";
        private _magazineAmmoLeft = 0;
        if (_magazineInfo isEqualType []) then {
            if ((count _magazineInfo) > 0) then { _magazineClassLower = toLower (_magazineInfo select 0); };
            if ((count _magazineInfo) > 1) then { _magazineAmmoLeft = _magazineInfo select 1; };
        };
        if ((_magazineAmmoLeft > 0) && (
            (_magazineClassLower find "titan") >= 0 ||
            (_magazineClassLower find "aa") >= 0 ||
            (_magazineClassLower find "autocannon") >= 0 ||
            (_magazineClassLower find "35mm") >= 0 ||
            (_magazineClassLower find "fla") >= 0 ||
            (_magazineClassLower find "zeus") >= 0
        )) exitWith { _hasAnyAAAmmo = true; };
    } forEach _vehicleMagazines;
    // Calculate dedication score (stricter than regular AA selection)
    private _dedicationScore = 0;
    if (_isKnownAAVehicle) then { _dedicationScore = _dedicationScore + 1000; };
    if (_hasRadar) then { _dedicationScore = _dedicationScore + 400; };
    if (_hasActiveRadarComponent) then { _dedicationScore = _dedicationScore + 450; };
    if (_hasAAMissiles) then { _dedicationScore = _dedicationScore + 400; };
    if (_hasAAAutoCannon) then { _dedicationScore = _dedicationScore + 250; };
    if (_hasAnyAAAmmo) then { _dedicationScore = _dedicationScore + 150; };
    if (_hasGunner) then { _dedicationScore = _dedicationScore + 50; };
    // Penalty for weapons without ammo
    if (((_hasAAMissiles || _hasAAAutoCannon)) && !_hasAnyAAAmmo) then { 
        _dedicationScore = _dedicationScore - 600; 
    };
    // Higher threshold for "dedicated" - must be a known AA vehicle OR have radar + missiles/autocannons
    private _isDedicated = (_dedicationScore >= 800) || 
                          (_isKnownAAVehicle) || 
                          ((_hasRadar || _hasActiveRadarComponent) && (_hasAAMissiles || _hasAAAutoCannon) && _hasAnyAAAmmo);
    if (_isDedicated) then {
        _dedicatedAACount = _dedicatedAACount + 1;
        _x setVariable ["isAAvehicle", true, true];
        _aaVehicles pushBack _x;
        if (_isConvoyDebugEnabled) then {
            format [
                "[CONVOY_AA_CHECK] Found dedicated AA vehicle: %1 (score: %2)",
                typeOf _x, _dedicationScore
            ] spawn OKS_fnc_LogDebug;
        };
    } else {
        if (_isConvoyDebugEnabled) then {
            format [
                "[CONVOY_AA_CHECK] Vehicle %1 not dedicated enough for AA (score: %2)",
                typeOf _x, _dedicationScore
            ] spawn OKS_fnc_LogDebug;
        };
    };
} forEach _vehicleArray;
// Store AA vehicle array on all convoy vehicles
{
    _x setVariable ["OKS_Convoy_AAArray", _aaVehicles, true];
} forEach _vehicleArray;

_dedicatedAACount = count _aaVehicles;

if (_isConvoyDebugEnabled) then {
    format [
        "[CONVOY_AA_CHECK] Found %1 dedicated AA vehicles (without cargo seats). Excluded %2 vehicles with cargo capacity.",
        _dedicatedAACount, count _excludedVehicles
    ] spawn OKS_fnc_LogDebug;
    
    if ((count _excludedVehicles) > 0) then {
        format [
            "[CONVOY_AA_CHECK] Excluded vehicles: %1",
            _excludedVehicles
        ] spawn OKS_fnc_LogDebug;
    };
};

_dedicatedAACount;