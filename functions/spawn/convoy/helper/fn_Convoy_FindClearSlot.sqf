/*
	Helper: Find clear position by nudging towards the selected side
	
	Params:
	1. centerATL (array) - Road center position
	2. roadDir (number) - Road direction
	3. preferLeft (bool) - Side preference
	4. maxDistance (number) - Maximum distance from road center (default 5m)
	
	Returns: [slotPosATL, slotDir, useLeft, isBlocked]
*/

params ["_centerATL", "_roadDir", "_preferLeft", ["_maxDistance", 5, [0]]];

private _sideSignPref = if (_preferLeft) then { -1 } else { 1 };
private _stepSize = 1; // 1 meter steps
private _currentDistance = 15; // Start at normal herringbone distance
private _foundClearPosition = false;
private _finalPosition = [];
private _finalDirection = 0;
private _finalUseLeft = _preferLeft;
private _isBlocked = true;

// First, try the preferred side
for "_distance" from _currentDistance to _maxDistance step -_stepSize do {
    private _sideDir = _roadDir + (_sideSignPref * 90);
    private _testPosATL = [
        (_centerATL select 0) + _distance * (sin _sideDir),
        (_centerATL select 1) + _distance * (cos _sideDir),
        (_centerATL select 2)
    ];
    
    if (!([_testPosATL, 7] call OKS_fnc_Convoy_IsBlocked)) then {
        _foundClearPosition = true;
        _finalPosition = _testPosATL;
        _finalDirection = _roadDir + (_sideSignPref * 45);
        _finalUseLeft = _preferLeft;
        _isBlocked = false;
        break;
    };
};

// If preferred side is blocked, try the opposite side
if (!_foundClearPosition) then {
    private _sideSignAlt = -_sideSignPref;
    
    for "_distance" from _currentDistance to _maxDistance step -_stepSize do {
        private _sideDir = _roadDir + (_sideSignAlt * 90);
        private _testPosATL = [
            (_centerATL select 0) + _distance * (sin _sideDir),
            (_centerATL select 1) + _distance * (cos _sideDir),
            (_centerATL select 2)
        ];
        
        if (!([_testPosATL, 7] call OKS_fnc_Convoy_IsBlocked)) then {
            _foundClearPosition = true;
            _finalPosition = _testPosATL;
            _finalDirection = _roadDir + (_sideSignAlt * 45);
            _finalUseLeft = !_preferLeft;
            _isBlocked = false;
            break;
        };
    };
};

// If still no clear position found, use the minimum distance position (closest to road)
if (!_foundClearPosition) then {
    private _sideDir = _roadDir + (_sideSignPref * 90);
    _finalPosition = [
        (_centerATL select 0) + _maxDistance * (sin _sideDir),
        (_centerATL select 1) + _maxDistance * (cos _sideDir),
        (_centerATL select 2)
    ];
    _finalDirection = _roadDir + (_sideSignPref * 45);
    _finalUseLeft = _preferLeft;
    _isBlocked = true;
};

[_finalPosition, _finalDirection, _finalUseLeft, _isBlocked]