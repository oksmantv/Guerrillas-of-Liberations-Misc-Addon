/*
    OKS_fnc_SatCamPipStartFollowVehicleCommanderView

    Starts a client-local PiP overlay that follows the CURRENT COMMANDER VIEW
    of a specific vehicle.

    Intended use:
    - Cargo and non-main turret seats can toggle "commander camera".

    Stop behavior:
    - Only ESC (or calling OKS_fnc_SatCamPipStop / toggle again).
    - No automatic stop when leaving seat/vehicle.

    Usage (client):
      [_vehicle, [_fov,_durationSec]] call OKS_fnc_SatCamPipStartFollowVehicleCommanderView;

        Notes:
        - View position uses turret/optics memory points when available (commander/gunner optics).
        - Falls back to the vehicle profile/bounding-box anchor only when no suitable memory point exists.
        - The global "OKS_SatCamPip_ForceOff" switch is reserved for the satellite PiP only.
*/

if (!hasInterface) exitWith { objNull };

params [
    ["_vehicle", objNull, [objNull]],
    ["_opts", [], [[]]]
];

if (isNull _vehicle) exitWith { objNull };

// Safety: land vehicles with turrets only (prevents issues for pilots/aircraft and turret-less vehicles).
if !(_vehicle isKindOf "LandVehicle") exitWith { objNull };
if ((count (allTurrets [_vehicle, true])) == 0) exitWith { objNull };

[] call OKS_fnc_SatCamPipStop;

private _fov = _opts param [0, 0.35, [0]];
private _durationSec = _opts param [1, -1, [0]];

private _rtName = "OKS_SAT_PIP";

private _camForwardOffset = 0.8;

// Get vehicle profile for commander camera adjustments
private _profiles = missionNamespace getVariable ["OKS_SatCamPip_VehicleProfiles", createHashMap];
private _profile = _profiles getOrDefault [toLower typeOf _vehicle, createHashMap];
private _commanderVerticalOffset = _profile getOrDefault ["commander_verticalOffset", 0]; // No fake offset - fix the transformation properly

// Commander/gunner PiP zoom (5 fixed levels)
private _zoomLevels = [0.7, 0.175, 0.0583333, 0.0291667, 0.0145833];

missionNamespace setVariable ["OKS_SatCamPip_Mode", "commander"];
missionNamespace setVariable ["OKS_SatCamPip_CommanderZoomLevels", _zoomLevels];
missionNamespace setVariable ["OKS_SatCamPip_CommanderZoomIndex", 0];
missionNamespace setVariable ["OKS_SatCamPip_CommanderFov", _zoomLevels#0];
missionNamespace setVariable ["OKS_SatCamPip_VisionMode", 0]; // 0=normal, 1=NV, 2=thermal

private _getAnchorWorld = {
    params ["_veh", "_anchorSpec"];

    private _anchorType = _anchorSpec param [0, "bboxTop", [""]];
    private _anchorData = _anchorSpec param [1, [], [[],""]];
    private _offset = _anchorSpec param [2, [0,0,0], [[]]];

    private _pModel = [0,0,0];
    private _bb = boundingBoxReal _veh;
    private _min = _bb#0;
    private _max = _bb#1;

    switch (_anchorType) do {
        case "mem": {
            if (_anchorData isEqualType "") then { _pModel = _veh selectionPosition _anchorData; };
        };
        case "model": {
            if (_anchorData isEqualType []) then { _pModel = _anchorData; };
        };
        case "bboxRearTop": {
            _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), (_max#2)];
        };
        default {
            // bboxTop
            _pModel = [(_min#0 + _max#0) * 0.5, (_min#1 + _max#1) * 0.5, (_max#2)];
        };
    };

    // Manual transformation instead of modelToWorldVisualWorld
    private _pFinal = _pModel vectorAdd _offset;
    private _vehForward = vectorDir _veh;
    private _vehUp = vectorUp _veh;
    private _vehRight = _vehForward vectorCrossProduct _vehUp;
    private _worldOffset = ((_vehRight vectorMultiply (_pFinal#0)) vectorAdd 
                            (_vehForward vectorMultiply (_pFinal#1)) vectorAdd 
                            (_vehUp vectorMultiply (_pFinal#2)));
    (getPosASL _veh) vectorAdd _worldOffset
};

private _getViewerViewInfo = {
    params ["_veh", "_viewer"];

    if (isNull _veh || {isNull _viewer}) exitWith { ["", "COMMANDER VIEW"] };
    if (vehicle _viewer != _veh) exitWith { ["", "COMMANDER VIEW"] };

    private _mem = "";
    private _srcKey = "";
    private _role = assignedVehicleRole _viewer;
    private _roleType = if ((count _role) > 0) then { toLower (_role#0) } else { "" };

    if (_roleType == "turret" && {(count _role) > 1}) then {
        private _path = _role#1;
        private _cfgTurret = [_veh, _path] call BIS_fnc_turretConfig;
        if (!isNull _cfgTurret) then {
            // Prefer optics memory points; fall back to weapon/gun memory points.
            {
                if (_mem isEqualTo "") then {
                    private _candidate = getText (_cfgTurret >> _x);
                    if (_candidate isNotEqualTo "") then {
                        private _p = _veh selectionPosition _candidate;
                        private _vdu = _veh selectionVectorDirAndUp [_candidate, "Memory"];
                        private _d = _vdu param [0, [0,0,0], [[]]];
                        private _isKnown = (_candidate in (selectionNames _veh));
                        private _isValid = _isKnown || {!(_p isEqualTo [0,0,0])} || {!(_d isEqualTo [0,0,0])};
                        if (_isValid) then {
                        _mem = _candidate;
                        _srcKey = _x;
                        };
                    };
                };
            } forEach [
                "memoryPointGunnerOptics",
                "memoryPointCommanderOptics",
                "memoryPointGun",
                "memoryPointGunner"
            ];
        };
    } else {
        // Driver optics is a reasonable last-resort when there is no turret optics.
        if (_viewer isEqualTo driver _veh) then {
            private _candidate = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "memoryPointDriverOptics");
            if (_candidate isNotEqualTo "") then {
                private _p = _veh selectionPosition _candidate;
                private _vdu = _veh selectionVectorDirAndUp [_candidate, "Memory"];
                private _d = _vdu param [0, [0,0,0], [[]]];
                private _isKnown = (_candidate in (selectionNames _veh));
                private _isValid = _isKnown || {!(_p isEqualTo [0,0,0])} || {!(_d isEqualTo [0,0,0])};
                if (_isValid) then {
                _mem = _candidate;
                _srcKey = "memoryPointDriverOptics";
                };
            };
        };
    };

    private _label = "COMMANDER VIEW";
    if (_mem isNotEqualTo "") then {
            if (toLower _mem == "commanderview") exitWith { ["commanderview", "COMMANDER VIEW"] };
        switch (_srcKey) do {
            case "memoryPointGunnerOptics": { _label = "GUNNER OPTICS"; };
            case "memoryPointCommanderOptics": { _label = "COMMANDER OPTICS"; };
            case "memoryPointDriverOptics": { _label = "DRIVER OPTICS"; };
            default { _label = "TURRET VIEW"; };
        };
    };

    [_mem, _label]
};

private _getTurretViewInfo = {
    params ["_veh", ["_preferredPath", [], [[]]]];

    private _bestMem = "";
    private _bestLabel = "COMMANDER VIEW";
    private _bestPath = [];
    private _bestScore = -1;

    private _paths = [];
    if ((count _preferredPath) > 0) then { _paths pushBack _preferredPath; };
    _paths append (allTurrets [_veh, true]);

    {
        private _path = _x;
        private _cfgTurret = [_veh, _path] call BIS_fnc_turretConfig;
        if (!isNull _cfgTurret) then {
            // Even if we can't validate a memory point, keep a path candidate so we can still rotate via turretDir.
            if (_bestPath isEqualTo []) then {
                _bestPath = _path;
                _bestLabel = "TURRET VIEW";
                _bestScore = 0;
            };

            {
                private _key = _x;
                private _candidate = getText (_cfgTurret >> _key);
                if (_candidate isNotEqualTo "") then {
                    private _p = _veh selectionPosition _candidate;
                    private _vdu = _veh selectionVectorDirAndUp [_candidate, "Memory"];
                    private _d = _vdu param [0, [0,0,0], [[]]];
                    private _isKnown = (_candidate in (selectionNames _veh));
                    private _isValid = _isKnown || {!(_p isEqualTo [0,0,0])} || {!(_d isEqualTo [0,0,0])};
                    if (_isValid) then {
                    private _score = 0;
                    // Prefer optics over gun/gunner points
                    if (_key in ["memoryPointGunnerOptics", "memoryPointCommanderOptics"]) then { _score = _score + 100; } else { _score = _score + 50; };
                    // Prefer specific known optics mempoint names (common pattern in your vehicles)
                    if (toLower _candidate == "commanderview") then { _score = _score + 1000; };
                    // Slight preference for commander optics over gunner optics when both exist
                    if (_key == "memoryPointCommanderOptics") then { _score = _score + 10; };

                    if (_score > _bestScore) then {
                        _bestScore = _score;
                        _bestMem = _candidate;
                        _bestPath = _path;
                                if (toLower _candidate == "commanderview") then {
                                    _bestLabel = "COMMANDER VIEW";
                                } else {
                        switch (_key) do {
                            case "memoryPointGunnerOptics": { _bestLabel = "GUNNER OPTICS"; };
                            case "memoryPointCommanderOptics": { _bestLabel = "COMMANDER OPTICS"; };
                            default { _bestLabel = "TURRET VIEW"; };
                        };
                                };
                    };
                    };
                };
            } forEach [
                "memoryPointGunnerOptics",
                "memoryPointCommanderOptics",
                "memoryPointGun",
                "memoryPointGunner"
            ];
        };
    } forEach _paths;

    if (_bestPath isEqualTo []) exitWith { ["", "COMMANDER VIEW", []] };
    // Return a path even if mempoint is missing; that still enables turretDir-based rotation.
    [_bestMem, _bestLabel, _bestPath]
};

// Lock to a specific viewer at start so the feed doesn't jump around when the local player changes seats.
// Do NOT use effectiveCommander here; it can resolve to the local player in some vehicles.
private _viewer = commander _vehicle;
if (isNull _viewer) then { _viewer = gunner _vehicle; };
if (isNull _viewer) then { _viewer = driver _vehicle; };

private _anchorSpec = _profile getOrDefault ["commander_anchor", ["bboxTop", [], [0,0,0]]];

// Prefer tracking a turret memory point directly (works even if turret is empty).
// If the local player is in a turret, prefer that turret path.
private _preferredPath = [];
private _pRole = assignedVehicleRole player;
if ((count _pRole) > 1 && {toLower (_pRole#0) == "turret"}) then { _preferredPath = _pRole#1; };

private _turInfo = [_vehicle, _preferredPath] call _getTurretViewInfo;
private _memPoint = _turInfo#0;
private _uiLabel = _turInfo#1;
private _trackTurretPath = _turInfo#2;

missionNamespace setVariable ["OKS_SatCamPip_Commander_MemPoint", _memPoint];
missionNamespace setVariable ["OKS_SatCamPip_Commander_TurretPath", _trackTurretPath];
missionNamespace setVariable ["OKS_SatCamPip_Commander_Label", _uiLabel];

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", true]) then {
    [format ["[Commander View] === TURRET ANALYSIS ==="]] spawn OKS_fnc_LogDebug;
    [format ["[Commander View]   Turret path: %1", _trackTurretPath]] spawn OKS_fnc_LogDebug;
    [format ["[Commander View]   Memory point: %1", _memPoint]] spawn OKS_fnc_LogDebug;
    
    // Get turret position if we can
    private _turretUnit = objNull;
    if ((count _trackTurretPath) > 0) then {
        _turretUnit = _vehicle turretUnit _trackTurretPath;
        if (!isNull _turretUnit) then {
            private _turretASL = getPosASL _turretUnit;
            private _turretATL = getPosATL _turretUnit;
            private _turretAGL = ASLToAGL _turretASL;
            private _turretWorld = getPosWorld _turretUnit;
            [format ["[Commander View]   Turret unit found: %1", _turretUnit]] spawn OKS_fnc_LogDebug;
            [format ["[Commander View]   Turret ASL: %1 (Z: %2)", _turretASL, _turretASL#2]] spawn OKS_fnc_LogDebug;
            [format ["[Commander View]   Turret ATL: %1 (Z: %2)", _turretATL, _turretATL#2]] spawn OKS_fnc_LogDebug;
            [format ["[Commander View]   Turret AGL: %1 (Z: %2)", _turretAGL, _turretAGL#2]] spawn OKS_fnc_LogDebug;
            [format ["[Commander View]   Turret World: %1 (Z: %2)", _turretWorld, _turretWorld#2]] spawn OKS_fnc_LogDebug;
            private _turretEyePos = eyePos _turretUnit;
            private _turretEyeATL = ASLToATL _turretEyePos;
            [format ["[Commander View]   Turret eyePos (ASL): %1 (Z: %2)", _turretEyePos, _turretEyePos#2]] spawn OKS_fnc_LogDebug;
            [format ["[Commander View]   Turret eyePos (ATL): %1 (Z: %2)", _turretEyeATL, _turretEyeATL#2]] spawn OKS_fnc_LogDebug;
        } else {
            [format ["[Commander View]   No turret unit in turret path"]] spawn OKS_fnc_LogDebug;
        };
    };
    
    // Check various memory points that might be turret-related
    private _memPoints = ["gunner", "gunnerview", "view_gunner", "gunner_view", "View_CROWS", "commanderview", "turret", "usti hlavne"];
    [format ["[Commander View] === MEMORY POINT POSITIONS ==="]] spawn OKS_fnc_LogDebug;
    {
        private _mp = _x;
        private _pos = _vehicle selectionPosition _mp;
        if !(_pos isEqualTo [0,0,0]) then {
            // Transform to world space to check
            private _vehForward = vectorDir _vehicle;
            private _vehUp = vectorUp _vehicle;
            private _vehRight = _vehForward vectorCrossProduct _vehUp;
            private _worldOffset = ((_vehRight vectorMultiply (_pos#0)) vectorAdd 
                                    (_vehForward vectorMultiply (_pos#1)) vectorAdd 
                                    (_vehUp vectorMultiply (_pos#2)));
            private _worldASL = (getPosASL _vehicle) vectorAdd _worldOffset;
            private _worldATL = ASLToATL _worldASL;
            [format ["[Commander View]   %1: Model %2 → World ATL Z: %3m", _mp, _pos, _worldATL#2]] spawn OKS_fnc_LogDebug;
        };
    } forEach _memPoints;
    
    [format ["[Commander View] === INITIAL TRANSFORMATION START ==="]] spawn OKS_fnc_LogDebug;
    [format ["[Commander View]   Vertical offset config: %1m", _commanderVerticalOffset]] spawn OKS_fnc_LogDebug;
};

// Compute turret forward direction in model space (for 0.15m forward offset to avoid turret clipping).
// NOTE: CBA_fnc_turretDir (default) returns WORLD-space compass bearings.
//       polar2vect produces a WORLD direction → must convert to model space.
private _turretFwdModel = [0,1,0];
if ((count _trackTurretPath) > 0) then {
    private _cfgT = [_vehicle, _trackTurretPath] call BIS_fnc_turretConfig;
    if (!isNull _cfgT && {getNumber (_cfgT >> "primaryObserver") == 1}) then {
        _turretFwdModel = _vehicle vectorWorldToModel (eyeDirection _vehicle);
    } else {
        private _a = [_vehicle, _trackTurretPath] call CBA_fnc_turretDir;
        if (_a isEqualType [] && {(count _a) >= 2}) then {
            private _v = ([1] + _a) call CBA_fnc_polar2vect;
            if (_v isEqualType [] && {(count _v) == 3}) then {
                // polar2vect of world bearings → world direction → convert to model
                _turretFwdModel = vectorNormalized (_vehicle vectorWorldToModel _v);
            };
        };
    };
} else {
    if (_memPoint isNotEqualTo "") then {
        private _vdu = _vehicle selectionVectorDirAndUp [_memPoint, "Memory"];
        private _d = _vdu param [0, [0,0,0], [[]]];
        if (!(_d isEqualTo [0,0,0])) then { _turretFwdModel = vectorNormalized _d; };
    };
};

private _cameraAttachOffset = if (_memPoint isNotEqualTo "") then {
    // Use the optics/commanderview memory point position directly.
    // Offset 0.15m along turret forward direction to avoid clipping.
    private _opticsModel = _vehicle selectionPosition _memPoint;
    private _baseOffset = [
        _opticsModel#0,
        _opticsModel#1,
        (_opticsModel#2) + _commanderVerticalOffset
    ];
    _baseOffset vectorAdd ((vectorNormalized _turretFwdModel) vectorMultiply 0.15);
} else {
    private _anchorType = _anchorSpec param [0, "bboxTop", [""]];
    private _anchorData = _anchorSpec param [1, [], [[],""]];
    private _offset = _anchorSpec param [2, [0,0,0], [[]]];

    private _pModel = [0,0,0];
    private _bb = boundingBoxReal _vehicle;
    private _min = _bb#0;
    private _max = _bb#1;

    switch (_anchorType) do {
        case "mem": {
            if (_anchorData isEqualType "") then { _pModel = _vehicle selectionPosition _anchorData; };
        };
        case "model": {
            if (_anchorData isEqualType []) then { _pModel = _anchorData; };
        };
        case "bboxRearTop": {
            _pModel = [(_min#0 + _max#0) * 0.5, (_min#1), (_max#2)];
        };
        default {
            _pModel = [(_min#0 + _max#0) * 0.5, (_min#1 + _max#1) * 0.5, (_max#2)];
        };
    };
    
    _pModel vectorAdd _offset
};

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", true]) then {
    [format ["[Commander View] Camera attach offset (model space): %1", _cameraAttachOffset]] spawn OKS_fnc_LogDebug;
};

// Calculate initial direction
private _dirFallback = if (!isNull _viewer) then { eyeDirection _viewer } else { vectorDirVisual _vehicle };
private _dirWorld = _dirFallback;
private _hasDir = false;

// 1) Prefer turret-path direction (updates with turret rotation)
if ((count _trackTurretPath) > 0) then {
    private _cfgTurret = [_vehicle, _trackTurretPath] call BIS_fnc_turretConfig;
    if (!isNull _cfgTurret && {getNumber (_cfgTurret >> "primaryObserver") == 1}) then {
        _dirWorld = eyeDirection _vehicle;
        _hasDir = true;
    } else {
        private _angles = [_vehicle, _trackTurretPath] call CBA_fnc_turretDir;
        if (_angles isEqualType [] && {(count _angles) >= 2}) then {
            private _v = ([1] + _angles) call CBA_fnc_polar2vect;
            if (_v isEqualType [] && {(count _v) == 3}) then {
                _dirWorld = vectorNormalized _v;
                _hasDir = true;
            };
        };
    };
};

// 2) Fallback: memory-point orientation vectors
if (!_hasDir && {_memPoint isNotEqualTo ""}) then {
    private _vdu = _vehicle selectionVectorDirAndUp [_memPoint, "Memory"];
    private _dModel = _vdu param [0, [0,0,0], [[]]];
    if (!(_dModel isEqualTo [0,0,0])) then {
        _dirWorld = vectorNormalized (_vehicle vectorModelToWorld _dModel);
        _hasDir = true;
    };
};

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", true]) then {
    [format ["[Commander View] Direction calculation"]] spawn OKS_fnc_LogDebug;
    [format ["[Commander View]   Direction world: %1", _dirWorld]] spawn OKS_fnc_LogDebug;
    [format ["[Commander View]   Direction method: %1", if (_hasDir) then {"Turret/MemPoint"} else {"Fallback"}]] spawn OKS_fnc_LogDebug;
};

// Calculate target position for camera to look at.
// _dirWorld is in WORLD space (from turretDir/eyeDirection), so compute target in world space.
private _camWorldPos = _vehicle modelToWorld _cameraAttachOffset;
private _targetWorld = _camWorldPos vectorAdd (_dirWorld vectorMultiply 2000);

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", true]) then {
    [format ["[Commander View] === CAMERA CREATION ==="]] spawn OKS_fnc_LogDebug;
    [format ["[Commander View]   Using attachTo with offset: %1", _cameraAttachOffset]] spawn OKS_fnc_LogDebug;
};

private _camera = "camera" camCreate [0,0,0];
_camera attachTo [_vehicle, _cameraAttachOffset];
_camera camSetTarget _targetWorld;
_camera camSetFov (missionNamespace getVariable ["OKS_SatCamPip_CommanderFov", _fov]);
_camera camCommit 0;

if (missionNamespace getVariable ["GOL_VehicleCamera_Debug", true]) then {
    // Verify actual camera position after creation
    private _actualPosASL = getPosASL _camera;
    private _actualPosATL = getPosATL _camera;
    [format ["[Commander View]   Camera actual ASL: %1", _actualPosASL]] spawn OKS_fnc_LogDebug;
    [format ["[Commander View]   Camera actual ATL: %1", _actualPosATL]] spawn OKS_fnc_LogDebug;
    [format ["[Commander View]   Position match: %1", if (_actualPosATL distance _camPosATL < 0.1) then {"YES"} else {format ["NO - Off by %1m", _actualPosATL distance _camPosATL]}]] spawn OKS_fnc_LogDebug;
};

_camera cameraEffect ["INTERNAL", "BACK", _rtName];
cutRsc ["OKS_SatCamHUD", "PLAIN", 0, false];

[{ 
    params ["_uiLabel"]; 
    private _display = uiNamespace getVariable ["OKS_SatCamHUD_Display", displayNull];
    if (isNull _display) exitWith {};
    private _bg = _display displayCtrl 9510;
    private _feed = _display displayCtrl 9511;
    if (isNull _feed) exitWith {};
    _feed ctrlSetText format ["#(argb,512,512,1)r2t(%1,1.0)", "OKS_SAT_PIP"];

    // cTab tablet frame dimensions (from cTab config.cpp, 2048px reference)
    // Background: w = safezoneH * 1.2 * 3/4, h = safezoneH * 1.2
    // Background has a 96.5px X offset within the texture
    // Full screen area within texture: origin (257, 491), size (1341, 993) in 2048-space
    private _frameH = safezoneH * 1.2;
    private _frameW = _frameH * 3/4;
    private _frameX = safezoneX + (safezoneW - _frameW) / 2 + (96.5 / 2048) * _frameW;
    private _frameY = safezoneY + (safezoneH - _frameH) / 2;

    // Full screen area within the tablet frame (pixel ratios from 2048-space)
    private _screenX = _frameX + (257 / 2048) * _frameW;
    private _screenY = _frameY + (491 / 2048) * _frameH;
    private _screenW = (1341 / 2048) * _frameW;
    private _screenH = (993 / 2048) * _frameH;

    // Oversize the feed slightly so the frame bezel masks the edges cleanly
    private _bleed = 0.005;
    _feed ctrlSetPosition [_screenX - _bleed, _screenY - _bleed, _screenW + 2 * _bleed, _screenH + 2 * _bleed];
    _feed ctrlCommit 0;

    // Hide the old BG border (tablet frame replaces it)
    _bg ctrlSetPosition [0, 0, 0, 0];
    _bg ctrlCommit 0;

    // Show cTab tablet frame overlay on top
    private _deviceFrame = _display displayCtrl 9518;
    if (!isNull _deviceFrame) then {
        _deviceFrame ctrlSetText "\cTab\img\tablet_background_ca.paa";
        _deviceFrame ctrlSetPosition [_frameX, _frameY, _frameW, _frameH];
        _deviceFrame ctrlCommit 0;
    };

    // Hide overlays (tablet frame is the visual wrapper)
    private _overlay = _display displayCtrl 9515;
    if (!isNull _overlay) then {
        _overlay ctrlSetPosition [0, 0, 0, 0];
        _overlay ctrlCommit 0;
    };

    // Hide targeting overlay controls
    {
        private _ctrl = _display displayCtrl _x;
        if (!isNull _ctrl) then { _ctrl ctrlSetPosition [0,0,0,0]; _ctrl ctrlCommit 0; };
    } forEach [9520,9521,9522,9523,9524,9525,9526,9527,9528,9529];

    // Hide vignette (tablet frame already provides edge styling)
    private _vignette = _display displayCtrl 9516;
    if (!isNull _vignette) then {
        _vignette ctrlSetPosition [0, 0, 0, 0];
        _vignette ctrlCommit 0;
    };

    // Hide center crosshair (not needed for commander view)
    private _crosshair = _display displayCtrl 9517;
    if (!isNull _crosshair) then {
        _crosshair ctrlSetPosition [0, 0, 0, 0];
        _crosshair ctrlCommit 0;
    };

    // Label: top-left inside the tablet screen
    private _labelCtrl = _display displayCtrl 9513;
    if (!isNull _labelCtrl) then {
        private _lh = 0.035;
        _labelCtrl ctrlSetPosition [_screenX + 0.01, _screenY + 0.005, _screenW - 0.02, _lh];
        _labelCtrl ctrlSetFontHeight 0.035;
        _labelCtrl ctrlCommit 0;
    };

    // Hint: bottom-left inside the tablet screen
    private _hintCtrl = _display displayCtrl 9514;
    if (!isNull _hintCtrl) then {
        private _hh = 0.028;
        _hintCtrl ctrlSetPosition [_screenX + 0.01, _screenY + _screenH - (_hh + 0.01), _screenW - 0.02, _hh];
        _hintCtrl ctrlSetFontHeight 0.028;
        _hintCtrl ctrlCommit 0;
    };

    private _label = _display displayCtrl 9513;
    if (!isNull _label) then { _label ctrlSetText _uiLabel; };
    private _hint = _display displayCtrl 9514;
    if (!isNull _hint) then {
        private _levels = missionNamespace getVariable ["OKS_SatCamPip_CommanderZoomLevels", []];
        private _idx = missionNamespace getVariable ["OKS_SatCamPip_CommanderZoomIndex", 0];
        private _total = (count _levels) max 1;
        _hint ctrlSetText format ["ESC to exit | Zoom %1/%2", _idx + 1, _total];
    };
}, [_uiLabel]] call CBA_fnc_execNextFrame;

missionNamespace setVariable ["OKS_SatCamPip_Camera", _camera];

private _ehIds = [];
private _d46 = findDisplay 46;
if (!isNull _d46) then {
    private _idKey = _d46 displayAddEventHandler ["KeyDown", {
        // ESC stops
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

// Fail safe: stop camera when player dismounts
private _idGetOut = player addEventHandler ["GetOutMan", {
    params ["_unit", "_role", "_veh"];
    if (_veh isEqualTo _vehicle) then {
        [] call OKS_fnc_SatCamPipStop;
    };
}];
_ehIds pushBack ["player", "GetOutMan", _idGetOut];

// Fail safe: stop camera when player switches to unsupported seat (driver in land vehicle without turrets, cargo)
private _idSeatSwitch = player addEventHandler ["SeatSwitchedMan", {
    params ["_unit", "_oldVeh", "_newVeh"];
    if (_newVeh isEqualTo _vehicle) then {
        private _role = assignedVehicleRole _unit;
        private _roleType = if ((count _role) > 0) then { toLower (_role#0) } else { "" };
        // Stop if switched to cargo
        if (_roleType == "cargo") then {
            [] call OKS_fnc_SatCamPipStop;
        };
    };
}];
_ehIds pushBack ["player", "SeatSwitchedMan", _idSeatSwitch];

missionNamespace setVariable ["OKS_SatCamPip_EHs", _ehIds];

private _startT = diag_tickTime;
private _pfhId = [{
    params ["_args", "_pfhId"];
    _args params ["_camera", "_vehicle", "_viewer", "_fov", "_durationSec", "_startT", "_anchorSpec", "_commanderVerticalOffset", "_memPoint", "_uiLabel", "_trackTurretPath"]; 

    if (isNull _camera) exitWith { 
        [_pfhId] call CBA_fnc_removePerFrameHandler; 
    };

    // Fail safe: stop if player died or unconscious
    if (!alive player) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };
    if (isClass (configFile >> "CfgPatches" >> "ace_medical") && {player getVariable ["ACE_isUnconscious", false]}) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    // Commander camera should exit if the local player leaves the vehicle or switches into a main crew seat.
    private _pVeh = vehicle player;
    if (_pVeh isEqualTo player) exitWith {
        // Player is on foot — no longer inside any vehicle.
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };
    if (player isEqualTo driver _pVeh || {player isEqualTo gunner _pVeh} || {player isEqualTo commander _pVeh}) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    if (isNull _vehicle) exitWith {
        // Vehicle deleted: stop.
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    if (_durationSec > 0 && {(diag_tickTime - _startT) > _durationSec}) exitWith {
        [] call OKS_fnc_SatCamPipStop;
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    // If the locked viewer is gone, reacquire (used only for fallback direction).
    if (isNull _viewer || {!alive _viewer} || {vehicle _viewer != _vehicle}) then {
        _viewer = commander _vehicle;
        if (isNull _viewer) then { _viewer = gunner _vehicle; };
        if (isNull _viewer) then { _viewer = driver _vehicle; };
        _args set [2, _viewer];
    };

    // Pull latest mempoint/label from args (in case they were updated).
    _memPoint = _args#8;
    _uiLabel = _args#9;
    _trackTurretPath = _args#10;

    // Compute direction first (needed for both forward offset and camera target).
    private _dirFallback = if (!isNull _viewer) then { eyeDirection _viewer } else { vectorDirVisual _vehicle };
    private _dirWorld = _dirFallback;
    private _dirModelFwd = [0,1,0]; // default: vehicle forward
    private _hasDir = false;

    if ((count _trackTurretPath) > 0) then {
        private _cfgTurret = [_vehicle, _trackTurretPath] call BIS_fnc_turretConfig;
        if (!isNull _cfgTurret && {getNumber (_cfgTurret >> "primaryObserver") == 1}) then {
            _dirWorld = eyeDirection _vehicle;
            _dirModelFwd = _vehicle vectorWorldToModel (eyeDirection _vehicle);
            _hasDir = true;
        } else {
            private _angles = [_vehicle, _trackTurretPath] call CBA_fnc_turretDir;
            if (_angles isEqualType [] && {(count _angles) >= 2}) then {
                private _v = ([1] + _angles) call CBA_fnc_polar2vect;
                if (_v isEqualType [] && {(count _v) == 3}) then {
                    // turretDir (default) returns world bearings → polar2vect gives world direction
                    _dirWorld = vectorNormalized _v;
                    _dirModelFwd = vectorNormalized (_vehicle vectorWorldToModel _v);
                    _hasDir = true;
                };
            };
        };
    };

    if (!_hasDir && {_memPoint isNotEqualTo ""}) then {
        private _vdu = _vehicle selectionVectorDirAndUp [_memPoint, "Memory"];
        private _dModel = _vdu param [0, [0,0,0], [[]]];
        if (!(_dModel isEqualTo [0,0,0])) then {
            _dirWorld = vectorNormalized (_vehicle vectorModelToWorld _dModel);
            _dirModelFwd = vectorNormalized _dModel;
        };
    };

    // Calculate camera attach offset with 0.15m forward push along turret direction
    private _baseOffset = if (_memPoint isNotEqualTo "") then {
        private _om = _vehicle selectionPosition _memPoint;
        [_om#0, _om#1, (_om#2) + _commanderVerticalOffset]
    } else {
        [0,0,2]  // fallback
    };
    private _attachOffset = _baseOffset vectorAdd ((vectorNormalized _dirModelFwd) vectorMultiply 0.15);

    // Update attachment
    detach _camera;
    _camera attachTo [_vehicle, _attachOffset];

    // Update camera target — _dirWorld is in world space, so compute target in world space.
    private _camWorldPos = _vehicle modelToWorld _attachOffset;
    private _targetWorld = _camWorldPos vectorAdd (_dirWorld vectorMultiply 2000);
    _camera camSetFov (missionNamespace getVariable ["OKS_SatCamPip_CommanderFov", _fov]);
    _camera camSetTarget _targetWorld;
    _camera camCommit 0;
}, 0, [_camera, _vehicle, _viewer, _fov, _durationSec, _startT, _anchorSpec, _commanderVerticalOffset, _memPoint, _uiLabel, _trackTurretPath]] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable ["OKS_SatCamPip_PFH", _pfhId];

_camera
