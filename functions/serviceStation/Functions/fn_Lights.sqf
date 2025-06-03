#include "..\fn_Service_Settings.sqf"

Params ["_SS"];

private _angles = [45, 135, 225, 315];
private _numLights = 10;
private _maxDistance = 15;
private _minDistance = 3; // Stop 3 meters short of center
private _distanceStep = (_maxDistance - _minDistance) / (_numLights - 1);

while {_SS in NEKY_ServiceStationActive && _Lights} do {
    private _pos = getPos _SS;
    private _angleOffset = direction _SS;

    // For each angle, spawn a thread for the pulse
    {
        private _angle = _angleOffset + _x;
        [_SS, _pos, _angle, _numLights, _maxDistance, _minDistance, _distanceStep] spawn {
            params ["_SS", "_pos", "_angle", "_numLights", "_maxDistance", "_minDistance", "_distanceStep"];
            private _light = objNull;
            for "_i" from 0 to (_numLights - 1) do {
                if (!isNull _light) then { deleteVehicle _light; };
                private _distance = _maxDistance - (_i * _distanceStep);
                // Ensure we don't go closer than _minDistance
                if (_distance < _minDistance) then { _distance = _minDistance; };
                _light = createVehicle [
                    "Sign_Sphere25cm_F",
                    ([_pos, _distance, _angle] call BIS_fnc_relPos),
                    [],
                    0,
                    "CAN_COLLIDE"
                ];
                _light setVectorUp surfaceNormal position _light;
                sleep 0.05; // 50% faster pulse
                if !(_SS in NEKY_ServiceStationActive) exitWith { if (!isNull _light) then { deleteVehicle _light; }; };
            };
            if (!isNull _light) then { deleteVehicle _light; };
        };
    } forEach _angles;

    sleep (_numLights * 0.05 + 0.05);
};