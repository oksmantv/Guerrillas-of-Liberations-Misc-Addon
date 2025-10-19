/*
    Self-contained flood-fill helper: Given a starting vehicle and an array of convoy vehicles, set all vehicles within 60m clusters to COMBAT.
    - _detector: The vehicle that first detects a threat
    - _convoyArray: Array of all convoy vehicles
    - _range: Proximity range (default 60)
    Vehicles are marked with setVariable ["GOL_ConvoyAmbushed", true, true] to avoid repeats.
    Returns: Array of all vehicles set to COMBAT in this call.

    [_Vehicle, _ConvoyArray, 80] call OKS_fnc_Convoy_ProximityCombatFill;
*/
params ["_detector", "_convoyArray", ["_range", 60]];

private _toCheck = [];
private _combatSet = [];

if (!(_detector getVariable ["GOL_ConvoyAmbushed", false])) then {
    _toCheck pushBack _detector;
};

while {count _toCheck > 0} do {
    private _current = _toCheck deleteAt 0;
    if (!(_current getVariable ["GOL_ConvoyAmbushed", false])) then {
        _current setBehaviour "COMBAT";
        _current setVariable ["GOL_ConvoyAmbushed", true, true];  
        _combatSet pushBack _current;
        // Find all unmarked vehicles within range
        private _nearby = _convoyArray select {
            _x != _current && { !(_x getVariable ["GOL_ConvoyAmbushed", false]) } && { _x distance _current <= _range }
        };
        _toCheck append _nearby;
    };
};

_combatSet;