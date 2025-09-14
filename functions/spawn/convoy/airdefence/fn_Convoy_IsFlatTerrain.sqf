params ["_positionATL", "_maxSlopeDeg"];

if (surfaceIsWater _positionATL) exitWith {
	false
};
private _surfaceNormal = surfaceNormal _positionATL;
private _slopeDeg = acos (_surfaceNormal select 2);

_slopeDeg <= _maxSlopeDeg;