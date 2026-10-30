/*
    OKS_fnc_SearchLight

    Makes an existing static searchlight scan a horizontal sector and track
    hostile targets that its gunner has already detected.

    Parameters:
        _Unit               - Searchlight vehicle. A gunner is created when empty.
        _Range              - Scan arc in degrees, centred on the vehicle's initial
                              facing direction. Clamped to 0-360. Default: 360.
        _LightBeforeCombat  - true: light remains enabled until the vehicle is
                              destroyed. false: light is enabled only while the
                              gunner has detected a hostile target. Default: false.
        _Sequential         - true: sweeps from the left arc limit to the right,
                              then reverses direction. false: selects each scan
                              direction randomly. Default: false.
        _ScanInterval       - Seconds to hold each scan position before moving to
                              the next one. Default: 3.

    Usage:
        [this, 90, false, true, 2] spawn OKS_fnc_SearchLight;
        [searchlight_1, 180, true, false, 5] spawn OKS_fnc_SearchLight;
*/

params [
    ["_unit", objNull, [objNull]],
    ["_range", 360, [0]],
    ["_lightBeforeCombat", false, [false]],
    ["_sequential", false, [false]],
    ["_scanInterval", 3, [0]]
];

if (!isServer || {isNull _unit} || {!alive _unit}) exitWith {};

_range = (_range max 0) min 360;
_scanInterval = _scanInterval max 0.1;

if (_unit getVariable ["OKS_SearchLight_Running", false]) exitWith {};
_unit setVariable ["OKS_SearchLight_Running", true, true];
_unit setVariable ["OKS_SearchLight", true, true];

// Infer a suitable faction for crew creation from the placed searchlight.
if (isNull (gunner _unit)) then {
    private _crewSide = switch (getNumber (configFile >> "CfgVehicles" >> typeOf _unit >> "side")) do {
        case 0: { east };
        case 1: { west };
        case 2: { independent };
        case 3: { civilian };
        default { east };
    };
    [_unit, _crewSide, 2] call OKS_fnc_AddVehicleCrew;
};

private _gunner = gunner _unit;
if (isNull _gunner) exitWith {
    _unit setVariable ["OKS_SearchLight_Running", false, true];
};

_gunner disableAI "PATH";
_gunner disableAI "MOVE";
_gunner setVariable ["lambs_danger_disableAI", true, true];

private _gunnerGroup = group _gunner;
_gunnerGroup setVariable ["lambs_danger_disableAI", true, true];
_gunnerGroup setVariable ["acex_headless_blacklist", true, true];

private _originDirection = getDir _unit;
private _halfRange = _range / 2;
private _detectionRange = 2000;
private _detectionThreshold = 1.5;
private _scanStep = if (_range > 0) then {_range / 12} else {0};
private _scanDirection = _originDirection - _halfRange - _scanStep;
private _scanDirectionDelta = _scanStep;

_unit setPilotLight _lightBeforeCombat;

private _isInScanArc = {
    params ["_source", "_target", "_centreDirection", "_halfArc"];
    if (_halfArc >= 180) exitWith {true};

    private _targetDirection = _source getDir _target;
    private _difference = abs (((_targetDirection - _centreDirection + 540) % 360) - 180);
    _difference <= _halfArc
};

while {alive _unit} do {
    _gunner = gunner _unit;

    if (_lightBeforeCombat) then {
        _unit setPilotLight true;
    };

    if (isNull _gunner || {!alive _gunner}) then {
        if (!_lightBeforeCombat) then {
            _unit setPilotLight false;
        };
        sleep 2;
    } else {
        private _detectedTargets = (_unit nearEntities [["Man", "LandVehicle", "Air", "Ship"], _detectionRange]) select {
            alive _x
            && {!captive _x}
            && {((side _gunner) getFriend (side _x)) < 0.6}
            && {[_unit, _x, _originDirection, _halfRange] call _isInScanArc}
            && {(_gunner knowsAbout _x) > _detectionThreshold}
        };

        if !(_detectedTargets isEqualTo []) then {
            private _target = selectRandom _detectedTargets;
            _unit doTarget _target;
            _unit doWatch _target;
            _unit setPilotLight true;
        } else {
            if (!_lightBeforeCombat) then {
                _unit setPilotLight false;
            };

            if (_sequential && {_range > 0}) then {
                private _leftLimit = _originDirection - _halfRange;
                private _rightLimit = _originDirection + _halfRange;
                _scanDirection = _scanDirection + _scanDirectionDelta;

                if (_scanDirection >= _rightLimit) then {
                    _scanDirection = _rightLimit;
                    _scanDirectionDelta = -_scanStep;
                };
                if (_scanDirection <= _leftLimit) then {
                    _scanDirection = _leftLimit;
                    _scanDirectionDelta = _scanStep;
                };
            } else {
                _scanDirection = if (_range > 0) then {
                    _originDirection - _halfRange + random _range
                } else {
                    _originDirection
                };
            };
            _unit doWatch (_unit getPos [50, _scanDirection]);
        };

        sleep (if (_detectedTargets isEqualTo []) then {_scanInterval} else {1});
    };
};

_unit setVariable ["OKS_SearchLight_Running", false, true];