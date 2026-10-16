/*
    OKS_fnc_LaserMarker_GetLaserAim

    Resolves the current camera/turret aim point for an aircraft crew member.
    An active seat laser uses the engine laser target. Aircraft without a laser
    designator fall back to a terrain/geometry raycast from the active camera.

    Returns:
        [camera origin ASL, impact ASL, ground range, vehicle, source ATL,
         turret bearing, vehicle heading]
        [] when there is no eligible aircraft crew aim point.
*/

if (!hasInterface || {isNull player} || {!alive player}) exitWith { [] };
if !(missionNamespace getVariable ["GOL_LaserMarker_Enabled", false]) exitWith { [] };

private _unit = player;
private _vehicle = vehicle _unit;
if (_vehicle isEqualTo _unit) exitWith { [] };
if !(_vehicle isKindOf "Air") exitWith { [] };

private _isDriver = (driver _vehicle) isEqualTo _unit;
private _vehicleRole = assignedVehicleRole _unit;
private _turretPath = if (_isDriver) then { [-1] } else { _vehicleRole param [1, []] };
if (!_isDriver && {_turretPath isEqualTo []}) exitWith { [] };

private _weapon = _vehicle currentWeaponTurret _turretPath;
private _seatWeapons = if (_isDriver) then {
    weapons _vehicle
} else {
    _vehicle weaponsTurret _turretPath
};
if (_weapon isEqualTo "") then {
    _weapon = _seatWeapons param [0, ""];
};

private _hasLaserWeapon = ((toLower _weapon) find "laserdesignator") > -1;
if (!_hasLaserWeapon) then {
    _hasLaserWeapon = (_seatWeapons findIf {((toLower _x) find "laserdesignator") > -1}) isNotEqualTo -1;
};

private _originASL = positionCameraToWorld [0, 0, 0];
private _cameraForwardASL = positionCameraToWorld [0, 0, 1000];
private _cameraDirection = _originASL vectorFromTo _cameraForwardASL;
if ((vectorMagnitude _cameraDirection) < 0.001) exitWith { [] };

private _impactASL = [];
private _laserTarget = laserTarget _vehicle;
if (_hasLaserWeapon && {!isNull _laserTarget}) then {
    // Keep the engine laser point while the designator remains active. This
    // deliberately does not require the current camera to still face it: a
    // pilot may leave a turret optic after designating without losing the aim.
    _impactASL = getPosASL _laserTarget;
    missionNamespace setVariable ["OKS_LaserMarker_LastLaserAim", [_vehicle, _impactASL]];
};

if (_impactASL isEqualTo []) then {
    private _lastLaserAim = missionNamespace getVariable ["OKS_LaserMarker_LastLaserAim", []];
    private _lastCameraAim = missionNamespace getVariable ["OKS_LaserMarker_LastCameraAim", []];
    private _isTurretView = (cameraView isEqualTo "GUNNER");
    if ((count _lastLaserAim) isEqualTo 2 && {(_lastLaserAim # 0) isEqualTo _vehicle}) then {
        _impactASL = _lastLaserAim # 1;
    } else {
        if (
            !_isTurretView
            && {(count _lastCameraAim) isEqualTo 4}
            && {(_lastCameraAim # 0) isEqualTo _vehicle}
        ) then {
            _lastCameraAim params ["", "_savedImpactASL", "_isGroundLocked", "_vehicleOffsetASL"];
            _impactASL = if (_isGroundLocked) then {
                _savedImpactASL
            } else {
                (getPosASL _vehicle) vectorAdd _vehicleOffsetASL
            };
        };
    };

    if (_impactASL isEqualTo []) then {
        private _normalizedCameraDirection = vectorNormalized _cameraDirection;
        private _rayEndASL = _originASL vectorAdd (_normalizedCameraDirection vectorMultiply 12000);
        private _hits = lineIntersectsSurfaces [
            _originASL vectorAdd (_normalizedCameraDirection vectorMultiply 0.25),
            _rayEndASL,
            _vehicle,
            objNull,
            true,
            1,
            "GEOM",
            "NONE"
        ];
        _impactASL = if (_hits isNotEqualTo []) then { (_hits # 0) # 0 } else { _rayEndASL };
        if (_isTurretView) then {
            missionNamespace setVariable [
                "OKS_LaserMarker_LastCameraAim",
                [
                    _vehicle,
                    _impactASL,
                    _hits isNotEqualTo [],
                    _impactASL vectorDiff (getPosASL _vehicle)
                ]
            ];
        };
    };
};
if (_impactASL isEqualTo []) exitWith { [] };
if ((_originASL distance _impactASL) < 1) exitWith { [] };

if !(missionNamespace getVariable ["OKS_LaserMarker_AimLogged", false]) then {
    diag_log format [
        "OKS_GOL_Misc: Aircraft aim active for %1 in %2",
        name _unit,
        typeOf _vehicle
    ];
    missionNamespace setVariable ["OKS_LaserMarker_AimLogged", true];
};

private _sourceATL = getPosATL _vehicle;
private _impactATL = ASLToATL _impactASL;
private _turretBearing = _sourceATL getDir _impactATL;
private _vehicleHeading = getDir _vehicle;
private _groundRange = _sourceATL distance2D _impactATL;

[_originASL, _impactASL, _groundRange, _vehicle, _sourceATL, _turretBearing, _vehicleHeading]
