/*
    OKS_fnc_Convoy_SelectAAVehicle
    Selects the best AA vehicle from a given array of vehicles.
    Usage: [_VehicleArray, _ConvoyDebug] call OKS_fnc_Convoy_SelectAAVehicle;
    Returns: AA vehicle object or objNull
*/

params ["_vehicleArray", "_isConvoyDebugEnabled"];
private _bestAAVehicle = objNull;
private _bestScore = -1e9;
private _debugScores = [];
{
    if (isNull _x || !alive _x || !canMove _x) then { continue };
    private _vehicleTypeLower = toLower (typeOf _x);
    private _vehicleConfig = configFile >> "CfgVehicles" >> typeOf _x;
    private _vehicleWeapons = getArray (_vehicleConfig >> "weapons");
    private _hasGunner = (count (fullCrew [_x, "gunner", true])) > 0;
    private _hasRadar = (getNumber (_vehicleConfig >> "radarType")) > 0;
    private _radarComponent = _vehicleConfig >> "Components" >> "SensorsManagerComponent" >> "Components" >> "ActiveRadarSensorComponent";
    private _hasActiveRadarComponent = isClass _radarComponent;
    private _hasAirTargetClass = if (_hasActiveRadarComponent) then { isClass (_radarComponent >> "AirTarget") } else { false };
    private _isTank = _x isKindOf "Tank_F";
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
    private _score = 0;
    if (_isKnownAAVehicle) then { _score = _score + 1000; };
    if (_hasRadar) then { _score = _score + 400; };
    if (_hasActiveRadarComponent) then { _score = _score + 450; };
    if (_hasAirTargetClass) then { _score = _score + 300; };
    if (_hasAAMissiles) then { _score = _score + 400; };
    if (_hasAAAutoCannon) then { _score = _score + 250; };
    if (_hasAnyAAAmmo) then { _score = _score + 150; };
    if (((_hasAAMissiles || _hasAAAutoCannon)) && !_hasAnyAAAmmo) then { _score = _score - 600; };
    if (_hasGunner) then { _score = _score + 50; };
    if (_isTank) then { _score = _score - 300; };
    _debugScores pushBack [
        typeOf _x,
        _score,
        [
            "KnownAAVehicle", _isKnownAAVehicle,
            "RadarType", _hasRadar,
            "ActiveRadarComponent", _hasActiveRadarComponent,
            "AirTargetClass", _hasAirTargetClass,
            "AAMissiles", _hasAAMissiles,
            "AAAutoCannon", _hasAAAutoCannon,
            "AnyAAAmmo", _hasAnyAAAmmo,
            "HasGunner", _hasGunner,
            "IsTank", _isTank
        ]
    ];
    if (_score > _bestScore) then { _bestScore = _score; _bestAAVehicle = _x; };
} forEach _vehicleArray;
if (_isConvoyDebugEnabled) then {
    private _sortedScores = [_debugScores, [], { _x select 1 }, "ASCEND"] call BIS_fnc_sortBy;
    private _topScore = if ((count _sortedScores) > 0) then { _sortedScores select ((count _sortedScores) - 1) } else { [] };
    format [
        "[CONVOY_AIR] AA selection scores (sorted): %1 | picked=%2 score=%3 | top=%4",
        _sortedScores,
        typeOf _bestAAVehicle,
        _bestScore,
        _topScore
    ] spawn OKS_fnc_LogDebug;
};
if (_bestScore < 200) exitWith { objNull };
_bestAAVehicle;
