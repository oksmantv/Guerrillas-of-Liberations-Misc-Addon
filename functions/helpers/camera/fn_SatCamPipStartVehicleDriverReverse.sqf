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

// Disable reverse camera if vehicle is in water (use same check as amphibious boost)
private _isInWater = surfaceIsWater (getPosATL _vehicle);
if (!_isInWater) then {
    _isInWater = surfaceIsWater (getPosWorld _vehicle);
};
if (_isInWater) exitWith { objNull };

// Driver-only
if (player isNotEqualTo driver _vehicle) exitWith { objNull };

[] call OKS_fnc_SatCamPipStop;

private _fov = _opts param [0, 0.35, [0]];
private _durationSec = _opts param [1, -1, [0]];

private _profiles = missionNamespace getVariable ["OKS_SatCamPip_VehicleProfiles", createHashMap];
private _profile = _profiles getOrDefault [toLower typeOf _vehicle, createHashMap];

// How far behind the vehicle rear-most bbox face the camera should sit.
// 0.15m = ~15cm.
private _camBackDistance = (_profile getOrDefault ["driverRear_distance", 0.15]) max 0.05 min 5;

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

    private _anchorType = _anchorSpec param [0, "bboxRearBottom", [""]];
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

[format ["[Rear Cam] Anchor type: %1, offset: %2", _anchorSpec#0, _anchorSpec#2]] spawn OKS_fnc_LogDebug;

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
    private _vehASL = getPosASL _vehicle;
    private _vehATL = getPosATL _vehicle;
    private _vehWorld = getPosWorld _vehicle;
    private _terrainASL = getTerrainHeightASL [_vehASL#0, _vehASL#1];
    [format ["[Rear Cam] === INITIAL VEHICLE POSITION DATA ==="]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Vehicle ASL: %1", _vehASL]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Vehicle ATL: %1", _vehATL]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Vehicle World: %1", _vehWorld]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Terrain ASL at vehicle: %1", _terrainASL]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Vehicle height above terrain: %1m", (_vehASL#2) - _terrainASL]] spawn OKS_fnc_LogDebug;
};

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
        [format ["[Rear Cam] Using bboxRearTop - positioning at max Z: %1", _max#2]] spawn OKS_fnc_LogDebug;
    };
    case "bboxRearBottom": {
        _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), (_min#2)];
        if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
            [format ["[Rear Cam] Using bboxRearBottom - positioning at min Z: %1", _min#2]] spawn OKS_fnc_LogDebug;
        };
    };
    case "bboxRearLow": {
        // Calculate 25% of vehicle HEIGHT, but position it relative to ground level
        // The bbox bottom might be below ground, so we need to offset from vehicle ATL position
        private _h = (_max#2) - (_min#2);
        private _targetHeightAboveGround = _h * 0.25;  // 25% of total height
        // Vehicle's getPosATL gives us the model center's height above ground
        // We want camera at specific height above ground, so: targetHeight - vehicleATL
        private _vehATL = getPosATL _vehicle;
        _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), _targetHeightAboveGround - (_vehATL#2)];
        if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
            [format ["[Rear Cam] Using bboxRearLow - 25%% height (vehicle height=%1m, target height above ground=%2m, vehicle ATL Z=%3m, final model Z=%4m)", _h, _targetHeightAboveGround, _vehATL#2, _pModel#2]] spawn OKS_fnc_LogDebug;
        };
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

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
    [format ["[Rear Cam] === MODEL SPACE CALCULATIONS ==="]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   pModel (initial): %1", _pModel]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Offset to apply: %1", _offset]] spawn OKS_fnc_LogDebug;
};

private _pAnchorModel = (_pModel vectorAdd _offset);

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
    [format ["[Rear Cam]   pAnchorModel (after offset): %1", _pAnchorModel]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Inset to apply: %1m", _bboxInset]] spawn OKS_fnc_LogDebug;
};

// creep forward from rear face
_pAnchorModel = _pAnchorModel vectorAdd [0, _bboxInset, 0];

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
    [format ["[Rear Cam]   pAnchorModel (final model space): %1", _pAnchorModel]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Vehicle ASL: %1", getPosASL _vehicle]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Expected world Z if simple add: %1", (getPosASL _vehicle)#2 + (_pAnchorModel#2)]] spawn OKS_fnc_LogDebug;
};

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
    [format ["[Rear Cam] === BOUNDING BOX & ANCHOR DATA ==="]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   BBox min: %1", _min]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   BBox max: %1", _max]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Anchor model space: %1", _pAnchorModel]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   BBox inset applied: %1m", _bboxInset]] spawn OKS_fnc_LogDebug;
};

// Manual transformation: model space to world space
// modelToWorldVisualWorld doesn't correctly apply negative Z offsets
// We must manually transform using the vehicle's orientation vectors
private _vehForward = vectorDir _vehicle;
private _vehUp = vectorUp _vehicle;
private _vehRight = _vehForward vectorCrossProduct _vehUp;

// Transform model space coordinates to world offset
private _worldOffset = ((_vehRight vectorMultiply (_pAnchorModel#0)) vectorAdd 
                        (_vehForward vectorMultiply (_pAnchorModel#1)) vectorAdd 
                        (_vehUp vectorMultiply (_pAnchorModel#2)));

// Add to vehicle position to get actual world position
private _pos = (getPosASL _vehicle) vectorAdd _worldOffset;

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
    [format ["[Rear Cam] === MANUAL WORLD SPACE TRANSFORMATION ==="]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Vehicle orientation - Right: %1", _vehRight]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Vehicle orientation - Forward: %1", _vehForward]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Vehicle orientation - Up: %1", _vehUp]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   World offset from model space: %1", _worldOffset]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Anchor world space (manual calc): %1", _pos]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Expected Z if level: %1", (getPosASL _vehicle)#2 + (_pAnchorModel#2)]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Actual Z: %1 (difference accounts for vehicle pitch/roll)", _pos#2]] spawn OKS_fnc_LogDebug;
    private _terrainAtAnchor = getTerrainHeightASL [_pos#0, _pos#1];
    [format ["[Rear Cam]   Anchor height above terrain: %1m", (_pos#2) - _terrainAtAnchor]] spawn OKS_fnc_LogDebug;
};

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
        
        // Manual transformation for inside point
        private _offsetInside = ((_vehRight vectorMultiply (_mInside#0)) vectorAdd 
                                 (_vehForward vectorMultiply (_mInside#1)) vectorAdd 
                                 (_vehUp vectorMultiply (_mInside#2)));
        private _inside = (getPosASL _vehicle) vectorAdd _offsetInside;
        
        // Manual transformation for outside point
        private _offsetOutside = ((_vehRight vectorMultiply (_mOutside#0)) vectorAdd 
                                  (_vehForward vectorMultiply (_mOutside#1)) vectorAdd 
                                  (_vehUp vectorMultiply (_mOutside#2)));
        private _outside = (getPosASL _vehicle) vectorAdd _offsetOutside;

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

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
    [format ["[Rear Cam] STEP 1: Calculating initial camera position"]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Rear surface pos: %1", _rearSurface]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Direction vector: %1", _dir]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Back distance: %1m", _camBackDistance]] spawn OKS_fnc_LogDebug;
};

private _camPos = _rearSurface vectorAdd (_dir vectorMultiply _camBackDistance);

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
    private _terrainZ = getTerrainHeightASL [_camPos#0, _camPos#1];
    private _heightAboveTerrain = (_camPos#2) - _terrainZ;
    [format ["[Rear Cam] STEP 2: Initial camera position calculated"]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Camera ASL: %1", _camPos]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Height above terrain: %1m", _heightAboveTerrain]] spawn OKS_fnc_LogDebug;
};

// Avoid placing the camera behind walls/terrain: pull it forward if obstructed.
if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
    [format ["[Rear Cam] STEP 3: Checking for obstructions between rear surface and camera"]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Ray from: %1", _rearSurface]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Ray to: %1", _camPos]] spawn OKS_fnc_LogDebug;
};

private _hits = lineIntersectsSurfaces [_rearSurface, _camPos, _vehicle, objNull, true, 1, "GEOM", "NONE"];
if ((count _hits) > 0) then {
    if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
        [format ["[Rear Cam] STEP 4: Obstruction detected! Adjusting camera position"]] spawn OKS_fnc_LogDebug;
        [format ["[Rear Cam]   Hit count: %1", count _hits]] spawn OKS_fnc_LogDebug;
        [format ["[Rear Cam]   Hit position: %1", (_hits#0)#0]] spawn OKS_fnc_LogDebug;
    };
    
    private _hitPos = (_hits#0)#0;
    // Move slightly towards the vehicle from the hit point.
    _camPos = _hitPos vectorAdd ((_dir vectorMultiply -1) vectorMultiply 0.05);
    
    if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
        private _terrainZ = getTerrainHeightASL [_camPos#0, _camPos#1];
        private _heightAboveTerrain = (_camPos#2) - _terrainZ;
        [format ["[Rear Cam]   Adjusted camera ASL: %1", _camPos]] spawn OKS_fnc_LogDebug;
        [format ["[Rear Cam]   New height above terrain: %1m", _heightAboveTerrain]] spawn OKS_fnc_LogDebug;
    };
} else {
    if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
        [format ["[Rear Cam] STEP 4: No obstruction detected, camera position unchanged"]] spawn OKS_fnc_LogDebug;
    };
};

// Note: AGL height clamping removed - camera stays vehicle-relative

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
    [format ["[Rear Cam] STEP 5: FINAL camera position"]] spawn OKS_fnc_LogDebug;
    private _terrainZ = getTerrainHeightASL [_camPos#0, _camPos#1];
    private _heightAboveTerrain = (_camPos#2) - _terrainZ;
    private _vehPos = getPosASL _vehicle;
    private _vehATL = getPosATL _vehicle;
    [format ["[Rear Cam] VEHICLE:"]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   ASL: %1, Z: %2", _vehPos, _vehPos#2]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   ATL: %1, Z: %2", _vehATL, _vehATL#2]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Terrain at vehicle: %1", _terrainZ]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Vehicle above terrain: %1m", (_vehPos#2) - _terrainZ]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Is on water: %1", surfaceIsWater (getPosATL _vehicle)]] spawn OKS_fnc_LogDebug;
    
    [format ["[Rear Cam] CAMERA:"]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   ASL: %1, Z: %2", _camPos, _camPos#2]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   ATL: %1, Z: %2", ASLToATL _camPos, (ASLToATL _camPos)#2]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Camera above vehicle: %1m", (_camPos#2) - (_vehPos#2)]] spawn OKS_fnc_LogDebug;
};

// Convert to ATL because camCreate uses ATL coordinates
private _camPosATL = ASLToATL _camPos;

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
    [format ["[Rear Cam] === CAMERA CREATION ==="]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Calculated ASL: %1", _camPos]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Converted to ATL: %1", _camPosATL]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Creating camera at ATL: %1", _camPosATL]] spawn OKS_fnc_LogDebug;
};

private _camera = "camera" camCreate _camPosATL;
_camera camSetTarget (_pos vectorAdd (_dir vectorMultiply 2000));
_camera camSetFov _fov;
_camera camCommit 0;

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", false]) then {
    // Verify actual camera position after creation
    private _actualPosASL = getPosASL _camera;
    private _actualPosATL = getPosATL _camera;
    [format ["[Rear Cam]   Camera actual ASL: %1", _actualPosASL]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Camera actual ATL: %1", _actualPosATL]] spawn OKS_fnc_LogDebug;
    [format ["[Rear Cam]   Position match: %1", if (_actualPosATL distance _camPosATL < 0.1) then {"YES"} else {format ["NO - Off by %1m", _actualPosATL distance _camPosATL]}]] spawn OKS_fnc_LogDebug;
};

private _rtName = "OKS_SAT_PIP";
missionNamespace setVariable ["OKS_SatCamPip_VisionMode", 0]; // 0=normal, 1=NV, 2=thermal
_camera cameraEffect ["INTERNAL", "BACK", _rtName];
cutRsc ["OKS_SatCamHUD", "PLAIN", 0, false];

[{ 
    private _display = uiNamespace getVariable ["OKS_SatCamHUD_Display", displayNull];
    if (isNull _display) exitWith {};
    private _bg = _display displayCtrl 9510;
    private _feed = _display displayCtrl 9511;
    if (isNull _feed) exitWith {};
    _feed ctrlSetText format ["#(argb,512,512,1)r2t(%1,1.0)", "OKS_SAT_PIP"];

    // cTab android frame dimensions (from cTab config.cpp, 2048px reference)
    // Background: centered, w = safezoneW * 0.8, h = safezoneW * 0.8 * 4/3
    // Full screen area within texture: origin (452, 713), size (1098, 626) in 2048-space
    //
    // Strategy: anchor the screen area's bottom-right to the viewport edge (with margin),
    // then compute frame position from that. The frame extends off-screen — we only care
    // about the visible camera screen area.
    private _scaleFactor = 0.4;
    private _frameW = safezoneW * _scaleFactor;
    private _frameH = _frameW * 4/3;

    // Full screen area size within the android frame (pixel ratios from 2048-space)
    private _screenW = (1098 / 2048) * _frameW;
    private _screenH = (626 / 2048) * _frameH;

    // Desired screen area bottom-right: flush with viewport edge + small margin
    private _margin = 0.01;
    private _screenX = safezoneX + safezoneW - _screenW - _margin;
    private _screenY = safezoneY + safezoneH - _screenH - _margin;

    // Derive frame position from the screen area (frame origin is above-left of screen area)
    private _frameX = _screenX - (452 / 2048) * _frameW;
    private _frameY = _screenY - (713 / 2048) * _frameH;

    // Oversize the feed slightly so the frame bezel masks the edges cleanly
    private _bleed = 0.003;
    _feed ctrlSetPosition [_screenX - _bleed, _screenY - _bleed, _screenW + 2 * _bleed, _screenH + 2 * _bleed];
    _feed ctrlCommit 0;

    // Hide the old BG border (android frame replaces it)
    _bg ctrlSetPosition [0, 0, 0, 0];
    _bg ctrlCommit 0;

    // Show cTab android frame overlay on top
    private _deviceFrame = _display displayCtrl 9518;
    if (!isNull _deviceFrame) then {
        _deviceFrame ctrlSetText "\cTab\img\android_background_ca.paa";
        _deviceFrame ctrlSetPosition [_frameX, _frameY, _frameW, _frameH];
        _deviceFrame ctrlCommit 0;
    };

    // Hide UAV optics overlay (android frame is the visual wrapper now)
    private _overlay = _display displayCtrl 9515;
    if (!isNull _overlay) then {
        _overlay ctrlSetPosition [0, 0, 0, 0];
        _overlay ctrlCommit 0;
    };

    // Hide vignette
    private _vignette = _display displayCtrl 9516;
    if (!isNull _vignette) then {
        _vignette ctrlSetPosition [0, 0, 0, 0];
        _vignette ctrlCommit 0;
    };

    // Position center crosshair within screen area
    private _crosshair = _display displayCtrl 9517;
    if (!isNull _crosshair) then {
        private _chSize = 0.02;
        private _chX = _screenX + (_screenW * 0.5) - (_chSize * 0.5);
        private _chY = _screenY + (_screenH * 0.5) - (_chSize * 0.5);
        _crosshair ctrlSetPosition [_chX, _chY, _chSize, _chSize];
        _crosshair ctrlCommit 0;
    };

    // Label: top-left inside the android screen
    private _labelCtrl = _display displayCtrl 9513;
    if (!isNull _labelCtrl) then {
        private _lh = 0.025;
        _labelCtrl ctrlSetPosition [_screenX + 0.005, _screenY + 0.003, _screenW - 0.01, _lh];
        _labelCtrl ctrlSetFontHeight 0.025;
        _labelCtrl ctrlSetText "REAR CAM";
        _labelCtrl ctrlCommit 0;
    };

    // Hint: bottom-left inside the android screen
    private _hintCtrl = _display displayCtrl 9514;
    if (!isNull _hintCtrl) then {
        private _hh = 0.02;
        _hintCtrl ctrlSetPosition [_screenX + 0.005, _screenY + _screenH - (_hh + 0.005), _screenW - 0.01, _hh];
        _hintCtrl ctrlSetFontHeight 0.02;
        _hintCtrl ctrlSetText "ESC to exit";
        _hintCtrl ctrlCommit 0;
    };
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

// Fail safe: stop camera when player dies
private _idKilled = player addEventHandler ["Killed", {
    [] call OKS_fnc_SatCamPipStop;
}];
_ehIds pushBack ["player", "Killed", _idKilled];

// Fail safe: stop camera when player becomes unconscious (ACE)
if (isClass (configFile >> "CfgPatches" >> "ace_medical")) then {
    private _idUnconscious = player addEventHandler ["HandleDamage", {
        if (player getVariable ["ACE_isUnconscious", false]) then {
            [] call OKS_fnc_SatCamPipStop;
        };
    }];
    _ehIds pushBack ["player", "HandleDamage", _idUnconscious];
};

// Fail safe: stop camera when player dismounts or switches seat
private _idGetOut = player addEventHandler ["GetOutMan", {
    params ["_unit", "_role", "_veh"];
    if (_veh isEqualTo _vehicle) then {
        [] call OKS_fnc_SatCamPipStop;
    };
}];
_ehIds pushBack ["player", "GetOutMan", _idGetOut];

private _idSeatSwitch = player addEventHandler ["SeatSwitchedMan", {
    params ["_unit", "_oldVeh", "_newVeh"];
    if (_newVeh isEqualTo _vehicle) then {
        // Driver-only camera: stop if switched to any other seat
        if (_unit isNotEqualTo driver _vehicle) then {
            [] call OKS_fnc_SatCamPipStop;
        };
    };
}];
_ehIds pushBack ["player", "SeatSwitchedMan", _idSeatSwitch];

missionNamespace setVariable ["OKS_SatCamPip_EHs", _ehIds];

private _startT = diag_tickTime;
private _pfhId = [{
    params ["_args", "_pfhId"];
    _args params ["_camera", "_vehicle", "_anchorSpec", "_fov", "_durationSec", "_startT", "_camBackDistance", "_camHeightAGL"];

    if (isNull _camera) exitWith { [_pfhId] call CBA_fnc_removePerFrameHandler; };

    // Fail safe: stop if player died or unconscious
    if (!alive player) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };
    if (isClass (configFile >> "CfgPatches" >> "ace_medical") && {player getVariable ["ACE_isUnconscious", false]}) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

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
        case "bboxRearBottom": {
            _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), (_min#2)];
        };
        case "bboxRearLow": {
            private _h = (_max#2) - (_min#2);
            private _targetHeightAboveGround = _h * 0.25;
            private _vehATL = getPosATL _vehicle;
            _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), _targetHeightAboveGround - (_vehATL#2)];
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
    
    // Manual transformation: modelToWorldVisualWorld doesn't correctly apply negative Z offsets
    private _vehForward = vectorDir _vehicle;
    private _vehUp = vectorUp _vehicle;
    private _vehRight = _vehForward vectorCrossProduct _vehUp;
    private _worldOffset = ((_vehRight vectorMultiply (_pAnchorModel#0)) vectorAdd 
                            (_vehForward vectorMultiply (_pAnchorModel#1)) vectorAdd 
                            (_vehUp vectorMultiply (_pAnchorModel#2)));
    private _pos = (getPosASL _vehicle) vectorAdd _worldOffset;
    
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
            
            // Manual transformation for inside point
            private _offsetInside = ((_vehRight vectorMultiply (_mInside#0)) vectorAdd 
                                     (_vehForward vectorMultiply (_mInside#1)) vectorAdd 
                                     (_vehUp vectorMultiply (_mInside#2)));
            private _inside = (getPosASL _vehicle) vectorAdd _offsetInside;
            
            // Manual transformation for outside point
            private _offsetOutside = ((_vehRight vectorMultiply (_mOutside#0)) vectorAdd 
                                      (_vehForward vectorMultiply (_mOutside#1)) vectorAdd 
                                      (_vehUp vectorMultiply (_mOutside#2)));
            private _outside = (getPosASL _vehicle) vectorAdd _offsetOutside;

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

    // Note: AGL height clamping removed - camera stays vehicle-relative
    
    // Convert to ATL because camSetPos uses ATL coordinates
    private _camPosATL = ASLToATL _camPos;

    _camera camSetFov _fov;
    _camera camSetPos _camPosATL;
    _camera camSetTarget (_pos vectorAdd (_dir vectorMultiply 2000));
    _camera camCommit 0;
}, 0.05, [_camera, _vehicle, _anchorSpec, _fov, _durationSec, _startT, _camBackDistance, _camHeightAGL]] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable ["OKS_SatCamPip_PFH", _pfhId];

_camera
