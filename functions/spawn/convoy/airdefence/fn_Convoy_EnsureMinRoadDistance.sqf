// Ensures position is at least minDist from nearest road, nudges laterally if needed
params ["_position", "_lateralDirection", "_minRoadDistance"];
private _maxSlopeDeg = missionNamespace getVariable ["GOL_Convoy_PullOffMaxSlopeDeg", 15];
private _resultPosition = _position;
private _nearestRoad = [_position, 50] call BIS_fnc_nearestRoad;
private _ok = false;

if (!isNull _nearestRoad) then {
    private _roadPos = getPosATL _nearestRoad;
    private _distance = _resultPosition distance2D _roadPos;
    if (_distance >= _minRoadDistance) exitWith { _ok = true; };
    private _steps = [5,10,15,20,25,30,35,40,45,50];
    {
        private _candidate = [(_resultPosition select 0) + _x * (sin _lateralDirection), (_resultPosition select 1) + _x * (cos _lateralDirection), _resultPosition select 2];
        private _nearRoad = [_candidate, 50] call BIS_fnc_nearestRoad;
        private _nearRoadPos = if (isNull _nearRoad) then {
			[1e9,1e9,0]
		} else {
			getPosATL _nearRoad
		};
        private _okRoad = (_candidate distance2D _nearRoadPos) >= _minRoadDistance;
        if (_okRoad && ([_candidate] call OKS_fnc_Convoy_IsOffRoad) && (!([_candidate, 7] call OKS_fnc_Convoy_IsBlocked)) && ([_candidate, _maxSlopeDeg] call OKS_fnc_Convoy_IsFlatTerrain)) exitWith {
			_resultPosition = _candidate; _ok = true; 
		};
    } forEach _steps;
};
_resultPosition;
