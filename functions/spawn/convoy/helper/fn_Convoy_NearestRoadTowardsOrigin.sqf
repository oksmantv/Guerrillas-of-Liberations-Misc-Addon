/*
	Helper: Pick connected road in the direction of origin

	Params:
	1. nearestRoad (object)
	2. originDirection (number)

	Returns: forwardRoad (object)
*/
params ["_nearestRoad", "_originDirection"];
private _posNearest = getPosWorld _nearestRoad;
private _connectedRoads = (roadsConnectedTo _nearestRoad);
private _bestRoad = objNull;
private _bestDiff = 1e9;
{
    private _dirTo = _posNearest getDir (getPosWorld _x);
    private _diff = abs ((_dirTo - _originDirection + 540) % 360 - 180);
    if (_diff < _bestDiff) then {
        _bestDiff = _diff;
        _bestRoad = _x;
    };
} forEach _connectedRoads;

private _forwardRoad = _bestRoad;

_forwardRoad;