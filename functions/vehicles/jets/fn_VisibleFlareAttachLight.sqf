/*
    Creates a local lightpoint attached to a visible flare projectile.
    Strong white light optimized for terrain illumination from altitude.
    Client-local to reduce network overhead.
*/

if (!hasInterface) exitWith {};

params [
    ["_projectileRef", "", ["", objNull]]
];

private _projectile = objNull;
if (_projectileRef isEqualType objNull) then {
    _projectile = _projectileRef;
} else {
    _projectile = objectFromNetId _projectileRef;
    if (isNull _projectile) then {
        private _timeout = time + 3;
        waitUntil {
            _projectile = objectFromNetId _projectileRef;
            (!isNull _projectile) || (time > _timeout)
        };
    };
};

if (isNull _projectile) exitWith {};
if (_projectile getVariable ["GOL_VisibleLightLocal", false]) exitWith {};
_projectile setVariable ["GOL_VisibleLightLocal", true];

private _light = "#lightpoint" createVehicleLocal (getPosATL _projectile);
// Strong white light for ground illumination - visible spectrum
_light setLightBrightness 1.0;
_light setLightColor [1.0, 0.9, 0.7];        // Warm white
_light setLightAmbient [0.3, 0.25, 0.2];     // Ambient contribution for softer shadows
_light setLightIntensity 500000;             // Extremely high intensity for daylight-level illumination
_light setLightUseFlare true;
_light setLightFlareSize 8;
_light setLightFlareMaxDistance 5000;
_light setLightDayLight false;
_light attachTo [_projectile, [0, 0, 0]];

[_light, _projectile] spawn {
    params ["_light", "_projectile"];
    waitUntil {
        sleep 0.1;
        isNull _projectile || {!alive _projectile}
    };
    deleteVehicle _light;
};
