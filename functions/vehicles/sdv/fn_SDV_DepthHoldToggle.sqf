/*
    OKS_fnc_SDV_DepthHoldToggle

    Enables or disables depth hold for a local GOL SDV. The controller preserves
    the SDV's horizontal velocity and only corrects vertical drift toward the
    depth at which the driver enabled it.

    Usage:
        [vehicle player] call OKS_fnc_SDV_DepthHoldToggle;
*/

params [
    ["_vehicle", objNull, [objNull]]
];

if (isNull _vehicle || { !local _vehicle }) exitWith { false };

private _enabled = _vehicle getVariable ["GOL_SDV_DepthHold", false];

if (_enabled) exitWith {
    _vehicle setVariable ["GOL_SDV_DepthHold", false, true];
    _vehicle setVariable ["GOL_SDV_DepthHoldDepth", nil, false];
    true
};

private _targetDepth = (getPosASL _vehicle) select 2;

// Depth hold is only useful while properly submerged; do not lock a surfaced SDV.
if (_targetDepth > -0.5) exitWith { false };

_vehicle setVariable ["GOL_SDV_DepthHoldDepth", _targetDepth, false];
_vehicle setVariable ["GOL_SDV_DepthHold", true, true];

[_vehicle] spawn {
    params ["_vehicle"];

    while {
        alive _vehicle
        && { local _vehicle }
        && { _vehicle getVariable ["GOL_SDV_DepthHold", false] }
        && { !isNull driver _vehicle }
    } do {
        private _targetDepth = _vehicle getVariable ["GOL_SDV_DepthHoldDepth", 0];
        private _currentDepth = (getPosASL _vehicle) select 2;

        if (_targetDepth >= -0.5 || { !underwater _vehicle }) exitWith {
            _vehicle setVariable ["GOL_SDV_DepthHold", false, true];
        };

        // Positive error means the SDV is too deep; negative means it has risen.
        // Directly cap its world-space vertical velocity without altering forward
        // motion, yaw, or pitch. This is deliberately gentle to avoid visible snaps.
        private _depthError = _targetDepth - _currentDepth;
        private _velocity = velocity _vehicle;
        private _verticalVelocity = linearConversion [-2, 2, _depthError, -1.25, 1.25, true];
        _velocity set [2, _verticalVelocity];
        _vehicle setVelocity _velocity;

        sleep 0.1;
    };

    if (_vehicle getVariable ["GOL_SDV_DepthHold", false]) then {
        _vehicle setVariable ["GOL_SDV_DepthHold", false, true];
    };
};

true
