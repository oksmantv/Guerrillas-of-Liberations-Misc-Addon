/*
    OKS_fnc_SatCamPipStartVehicleDriverReverse

    Starts a client-local PiP overlay that acts as a driver-only rear camera.

    Design:
    - ONLY intended for the driver seat.
    - Exits automatically if the player is no longer the driver.
    - Uses bounding-box (or profile) anchors; does NOT fall back to eyePos.

    Usage (client):
      [_vehicle, [_fov,_durationSec]] call OKS_fnc_SatCamPipStartVehicleDriverReverse;

        Note:
        - The global "OKS_SatCamPip_ForceOff" switch is reserved for the satellite PiP only.
*/

if (!hasInterface) exitWith { objNull };

params [
    ["_vehicle", objNull, [objNull]],
    ["_opts", [], [[]]]
];

if (isNull _vehicle) exitWith { objNull };

// Land vehicles only (avoid aircraft/boats/pilots).
if !(_vehicle isKindOf "LandVehicle") exitWith { objNull };

// Driver-only
if (player isNotEqualTo driver _vehicle) exitWith { objNull };

[] call OKS_fnc_SatCamPipStop;

private _fov = _opts param [0, 0.35, [0]];
private _durationSec = _opts param [1, -1, [0]];

private _profiles = missionNamespace getVariable ["OKS_SatCamPip_VehicleProfiles", createHashMap];
private _profile = _profiles getOrDefault [toLower typeOf _vehicle, createHashMap];

// How far behind the vehicle rear-most bbox face the camera should sit.
// 0.05m = ~5cm.
private _camBackDistance = (_profile getOrDefault ["driverRear_distance", 0.05]) max 0.05 min 5;

// Optional clamp camera height above terrain (AGL).
// Default is 0 (disabled) so the camera remains purely vehicle-relative.
private _camHeightAGL = (_profile getOrDefault ["driverRear_heightAGL", 0]) max 0 min 5;

// Optional: align camera X/Z to driver optics. Disabled by default because it often places the rear cam too high.
private _alignToDriverOptics = _profile getOrDefault ["driverRear_alignToDriverOptics", false];

// Use vehicle geometry to find the true rear surface (helps vehicles with sloppy bounding boxes).
private _useGeomRear = _profile getOrDefault ["driverRear_useGeomRear", true];

// Push the rear reference point forward (model +Y) to compensate for loose bbox rear faces.
// This makes the camera sit closer to the actual model even when boundingBoxReal extends behind it.
private _bboxInset = (_profile getOrDefault ["driverRear_bboxInset", 0.30]) max 0 min 2;

private _getAnchorWorld = {
    params ["_veh", "_anchorSpec"];

    private _anchorType = _anchorSpec param [0, "bboxRearLow", [""]];
    private _anchorData = _anchorSpec param [1, [], [[],""]];
    private _offset = _anchorSpec param [2, [0,0,0], [[]]];

    private _pModel = [0,0,0];

    private _bb = boundingBoxReal _veh;
    private _min = _bb#0;
    private _max = _bb#1;

    switch (_anchorType) do {
        case "mem": {
            if (_anchorData isEqualType "") then {
                _pModel = _veh selectionPosition _anchorData;
            };
        };
        case "model": {
            if (_anchorData isEqualType []) then {
                _pModel = _anchorData;
            };
        };
        case "bboxTop": {
            _pModel = [(_min#0 + _max#0) * 0.5, (_min#1 + _max#1) * 0.5, (_max#2)];
        };
        case "bboxRearTop": {
            _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), (_max#2)];
        };
        case "bboxRearLow": {
            private _h = (_max#2) - (_min#2);
            _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), (_min#2) + (_h * 0.25)];
        };
        default {
            // bboxRearMid (default)
            _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), (_min#2 + _max#2) * 0.5];
        };
    };

    if (_alignToDriverOptics) then {
        // If driver optics exist, align the camera height (and lateral offset) to driver level.
        private _driverOptics = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "memoryPointDriverOptics");
        if (_driverOptics isNotEqualTo "" && {_driverOptics in (selectionNames _veh)}) then {
            private _d = _veh selectionPosition _driverOptics;
            _pModel set [0, _d#0];
            _pModel set [2, _d#2];
        };
    };

    _veh modelToWorldVisualWorld (_pModel vectorAdd _offset)
};

private _anchorSpec = _profile getOrDefault ["driverRear_anchor", ["bboxRearLow", [], [0,0,0]]];

// Get anchor MODEL position so we can do reliable model-space insets / raycasts.
private _bb = boundingBoxReal _vehicle;
private _min = _bb#0;
private _max = _bb#1;

private _anchorType = _anchorSpec param [0, "bboxRearLow", [""]];
private _anchorData = _anchorSpec param [1, [], [[] ,""]];
private _offset = _anchorSpec param [2, [0,0,0], [[]]];

private _pModel = [0,0,0];
switch (_anchorType) do {
    case "mem": {
        if (_anchorData isEqualType "") then { _pModel = _vehicle selectionPosition _anchorData; };
    };
    case "model": {
        if (_anchorData isEqualType []) then { _pModel = _anchorData; };
    };
    case "bboxTop": {
        _pModel = [(_min#0 + _max#0) * 0.5, (_min#1 + _max#1) * 0.5, (_max#2)];
    };
    case "bboxRearTop": {
        _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), (_max#2)];
    };
    case "bboxRearLow": {
        private _h = (_max#2) - (_min#2);
        _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), (_min#2) + (_h * 0.25)];
    };
    default {
        // bboxRearMid
        _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), (_min#2 + _max#2) * 0.5];
    };
};

if (_alignToDriverOptics) then {
    private _driverOptics = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "memoryPointDriverOptics");
    if (_driverOptics isNotEqualTo "" && {_driverOptics in (selectionNames _vehicle)}) then {
        private _d = _vehicle selectionPosition _driverOptics;
        _pModel set [0, _d#0];
        _pModel set [2, _d#2];
    };
};

private _pAnchorModel = (_pModel vectorAdd _offset);
// creep forward from rear face
_pAnchorModel = _pAnchorModel vectorAdd [0, _bboxInset, 0];

private _pos = _vehicle modelToWorldVisualWorld _pAnchorModel;

// Reverse direction: look backwards along vehicle direction.
private _fwd = vectorDirVisual _vehicle;
private _dir = _fwd vectorMultiply -1;

// Try to get the actual rear surface by raycasting the vehicle GEOM from just inside -> behind.
private _rearSurface = _pos;
if (_useGeomRear) then {
    private _step = 0.05;
    private _maxCreep = 2.0;
    private _tries = floor ((_maxCreep / _step) max 1);
    private _found = false;

    for "_i" from 0 to _tries do {
        private _creep = _i * _step;
        private _mInside = _pAnchorModel vectorAdd [0, 0.05 + _creep, 0];
        private _mOutside = _pAnchorModel vectorAdd [0, -5 + _creep, 0];
        private _inside = _vehicle modelToWorldVisualWorld _mInside;
        private _outside = _vehicle modelToWorldVisualWorld _mOutside;

        private _hitsVeh = lineIntersectsSurfaces [_inside, _outside, objNull, objNull, true, 5, "GEOM", "NONE"];
        {
            if ((_x param [2, objNull]) isEqualTo _vehicle) exitWith {
                _rearSurface = _x#0;
                _found = true;
            };
        } forEach _hitsVeh;
        if (_found) exitWith {};
    };
};

private _camPos = _rearSurface vectorAdd (_dir vectorMultiply _camBackDistance);

// Avoid placing the camera behind walls/terrain: pull it forward if obstructed.
private _hits = lineIntersectsSurfaces [_rearSurface, _camPos, _vehicle, objNull, true, 1, "GEOM", "NONE"];
if ((count _hits) > 0) then {
    private _hitPos = (_hits#0)#0;
    // Move slightly towards the vehicle from the hit point.
    _camPos = _hitPos vectorAdd ((_dir vectorMultiply -1) vectorMultiply 0.05);
};

if (_camHeightAGL > 0) then {
    private _pAtl = ASLToATL _camPos;
    // Only clamp on land. In water, clamping tends to put the camera inside/under the hull.
    if !(surfaceIsWater _pAtl) then {
        _pAtl set [2, _camHeightAGL];
        _camPos = ATLToASL _pAtl;
    };
};

private _camera = "camera" camCreate _camPos;
_camera camSetTarget (_pos vectorAdd (_dir vectorMultiply 2000));
_camera camSetFov _fov;
_camera camCommit 0;

private _rtName = "OKS_SAT_PIP";
_camera cameraEffect ["INTERNAL", "BACK", _rtName];
cutRsc ["OKS_SatCamHUD", "PLAIN", 0, false];

[{ 
    private _display = uiNamespace getVariable ["OKS_SatCamHUD_Display", displayNull];
    if (isNull _display) exitWith {};
    private _feed = _display displayCtrl 9511;
    if (!isNull _feed) then {
        _feed ctrlSetText format ["#(argb,512,512,1)r2t(%1,1.0)", "OKS_SAT_PIP"];
    };
    private _label = _display displayCtrl 9513;
    if (!isNull _label) then { _label ctrlSetText "REAR CAM"; };
    private _hint = _display displayCtrl 9514;
    if (!isNull _hint) then { _hint ctrlSetText "ESC to exit"; };
}] call CBA_fnc_execNextFrame;

missionNamespace setVariable ["OKS_SatCamPip_Camera", _camera];

private _ehIds = [];
private _d46 = findDisplay 46;
if (!isNull _d46) then {
    private _idKey = _d46 displayAddEventHandler ["KeyDown", {
        params ["_disp", "_key"];
        if (_key == 1) then {
            [] call OKS_fnc_SatCamPipStop;
            true
        } else {
            false
        };
    }];
    _ehIds pushBack ["display46", "KeyDown", _idKey];
};
missionNamespace setVariable ["OKS_SatCamPip_EHs", _ehIds];

private _startT = diag_tickTime;
private _pfhId = [{
    params ["_args", "_pfhId"];
    _args params ["_camera", "_vehicle", "_anchorSpec", "_fov", "_durationSec", "_startT", "_camBackDistance", "_camHeightAGL"];

    if (isNull _camera) exitWith { [_pfhId] call CBA_fnc_removePerFrameHandler; };

    if (isNull _vehicle) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    // Driver-only: exit if player is no longer driver.
    if (player isNotEqualTo driver _vehicle) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    if (_durationSec > 0 && {(diag_tickTime - _startT) > _durationSec}) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    private _bb = boundingBoxReal _vehicle;
    private _min = _bb#0;
    private _max = _bb#1;

    private _anchorType = _anchorSpec param [0, "bboxRearLow", [""]];
    private _anchorData = _anchorSpec param [1, [], [[],""]];
    private _offset = _anchorSpec param [2, [0,0,0], [[]]];

    private _pModel = [0,0,0];
    switch (_anchorType) do {
        case "mem": {
            if (_anchorData isEqualType "") then { _pModel = _vehicle selectionPosition _anchorData; };
        };
        case "model": {
            if (_anchorData isEqualType []) then { _pModel = _anchorData; };
        };
        case "bboxTop": {
            _pModel = [(_min#0 + _max#0) * 0.5, (_min#1 + _max#1) * 0.5, (_max#2)];
        };
        case "bboxRearTop": {
            _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), (_max#2)];
        };
        case "bboxRearLow": {
            private _h = (_max#2) - (_min#2);
            _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), (_min#2) + (_h * 0.25)];
        };
        default {
            // bboxRearMid
            _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), (_min#2 + _max#2) * 0.5];
        };
    };

    private _profiles = missionNamespace getVariable ["OKS_SatCamPip_VehicleProfiles", createHashMap];
    private _profile = _profiles getOrDefault [toLower typeOf _vehicle, createHashMap];
    private _alignToDriverOptics = _profile getOrDefault ["driverRear_alignToDriverOptics", false];

    if (_alignToDriverOptics) then {
        private _driverOptics = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "memoryPointDriverOptics");
        if (_driverOptics isNotEqualTo "" && {_driverOptics in (selectionNames _vehicle)}) then {
            private _d = _vehicle selectionPosition _driverOptics;
            _pModel set [0, _d#0];
            _pModel set [2, _d#2];
        };
    };

    private _useGeomRear = _profile getOrDefault ["driverRear_useGeomRear", true];
    private _bboxInset = (_profile getOrDefault ["driverRear_bboxInset", 0.30]) max 0 min 2;
    private _pAnchorModel = (_pModel vectorAdd _offset) vectorAdd [0, _bboxInset, 0];
    private _pos = _vehicle modelToWorldVisualWorld _pAnchorModel;
    private _fwd = vectorDirVisual _vehicle;
    private _dir = _fwd vectorMultiply -1;

    private _rearSurface = _pos;
    if (_useGeomRear) then {
        private _step = 0.05;
        private _maxCreep = 2.0;
        private _tries = floor ((_maxCreep / _step) max 1);
        private _found = false;

        for "_i" from 0 to _tries do {
            private _creep = _i * _step;
            private _mInside = _pAnchorModel vectorAdd [0, 0.05 + _creep, 0];
            private _mOutside = _pAnchorModel vectorAdd [0, -5 + _creep, 0];
            private _inside = _vehicle modelToWorldVisualWorld _mInside;
            private _outside = _vehicle modelToWorldVisualWorld _mOutside;

            private _hitsVeh = lineIntersectsSurfaces [_inside, _outside, objNull, objNull, true, 5, "GEOM", "NONE"];
            {
                if ((_x param [2, objNull]) isEqualTo _vehicle) exitWith {
                    _rearSurface = _x#0;
                    _found = true;
                };
            } forEach _hitsVeh;
            if (_found) exitWith {};
        };
    };

    private _camPos = _rearSurface vectorAdd (_dir vectorMultiply _camBackDistance);

    private _hits = lineIntersectsSurfaces [_rearSurface, _camPos, _vehicle, objNull, true, 1, "GEOM", "NONE"];
    if ((count _hits) > 0) then {
        private _hitPos = (_hits#0)#0;
        _camPos = _hitPos vectorAdd ((_dir vectorMultiply -1) vectorMultiply 0.05);
    };

    if (_camHeightAGL > 0) then {
        private _pAtl = ASLToATL _camPos;
        if !(surfaceIsWater _pAtl) then {
            _pAtl set [2, _camHeightAGL];
            _camPos = ATLToASL _pAtl;
        };
    };

    _camera camSetFov _fov;
    _camera camSetPos _camPos;
    _camera camSetTarget (_pos vectorAdd (_dir vectorMultiply 2000));
    _camera camCommit 0;
}, 0.05, [_camera, _vehicle, _anchorSpec, _fov, _durationSec, _startT, _camBackDistance, _camHeightAGL]] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable ["OKS_SatCamPip_PFH", _pfhId];

_camera
