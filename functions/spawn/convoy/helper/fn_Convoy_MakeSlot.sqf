/*
	Helper: Build a slot 15m to side at ±45°, with obstacle flip (ATL positions)
	
	Params:
	1. centerATL (array)
	2. roadDir (number)
	3. preferLeft (bool)
	
	Returns: [slotPosATL, slotDir, useLeft]
*/

params ["_centerATL", "_roadDir", "_preferLeft"];
private _sideSignPref = 1;
if (_preferLeft) then { _sideSignPref = -1 };

private _sideDir = _roadDir + (_sideSignPref * 90);
private _posPrefATL = [
    (_centerATL select 0) + 15 * (sin _sideDir),
    (_centerATL select 1) + 15 * (cos _sideDir),
    (_centerATL select 2)
];
private _dirPref = _roadDir + (_sideSignPref * 45);
private _useLeft = _preferLeft;
private _slotPosATL = _posPrefATL;
private _slotDir = _dirPref;

if ([_posPrefATL, 7] call OKS_fnc_Convoy_IsBlocked) then {
    private _sideSignAlt = -_sideSignPref;
    private _sideDirAlt = _roadDir + (_sideSignAlt * 90);
    private _posAltATL = [
        (_centerATL select 0) + 15 * (sin _sideDirAlt),
        (_centerATL select 1) + 15 * (cos _sideDirAlt),
        (_centerATL select 2)
    ];
    private _dirAlt = _roadDir + (_sideSignAlt * 45);
    if (!([_posAltATL, 7] call OKS_fnc_Convoy_IsBlocked)) then {
        _useLeft = !_preferLeft;
        _slotPosATL = _posAltATL;
        _slotDir = _dirAlt;
    };
};

[_slotPosATL, _slotDir, _useLeft]