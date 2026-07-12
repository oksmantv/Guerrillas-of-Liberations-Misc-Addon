/*
    Creates a local lightpoint attached to a flare projectile.
    Kept client-local to reduce network overhead and to ensure visuals render
    for every observer.
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
if (_projectile getVariable ["GOL_IRLightLocal", false]) exitWith {};
_projectile setVariable ["GOL_IRLightLocal", true];

private _light = "#lightpoint" createVehicleLocal (getPosATL _projectile);
// Very faint red-tinted light — nearly invisible to naked eye, strong on NVG
_light setLightBrightness 0.5;
_light setLightColor [0.08, 0, 0];  // Red tint — imperceptible naked eye, bright on NVG
_light setLightAmbient [0, 0, 0];
_light setLightIntensity 150000;     // High intensity to overcome dim color
_light setLightUseFlare false;
_light setLightFlareSize 0;
_light setLightFlareMaxDistance 0;
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
