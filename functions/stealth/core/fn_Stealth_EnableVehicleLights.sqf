/*
    Enables light behaviour for an AI-crewed vehicle.

    Usage:
    [_vehicle] call OKS_fnc_Stealth_EnableVehicleLights;

    The function is intended to be called after vehicle crew have been assigned.
    It is server/locality-safe and is controlled by GOL_Stealth_EnableVehicleLights.
*/

params [
    ["_vehicle", objNull, [objNull]]
];

if (isNull _vehicle || {!local _vehicle}) exitWith { false };
if !(missionNamespace getVariable ["GOL_Stealth_EnableVehicleLights", false]) exitWith { false };

// Keep aircraft collision lights off while enabling the vehicle's normal driving/pilot lights.
_vehicle setCollisionLight false;
_vehicle setPilotLight true;

// Vehicle lights are controlled by the driver. Turn them on, then prevent the AI from changing the state.
private _driver = driver _vehicle;
if !(isNull _driver) then {
    _driver enableAI "LIGHTS";
    _driver action ["LightOn", _vehicle];
    _driver disableAI "LIGHTS";
};

true
