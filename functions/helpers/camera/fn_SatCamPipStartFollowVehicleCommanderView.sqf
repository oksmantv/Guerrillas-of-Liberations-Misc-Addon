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

// Commander/gunner PiP zoom (4 levels: base + 3 closer)
private _baseFov = (_fov max 0.05) min 1.2;
private _zoomLevels = [
    _baseFov,
    (_baseFov * 0.70) max 0.05,
    (_baseFov * 0.50) max 0.05,
    (_baseFov * 0.35) max 0.05
];

missionNamespace setVariable ["OKS_SatCamPip_Mode", "commander"];
missionNamespace setVariable ["OKS_SatCamPip_CommanderZoomLevels", _zoomLevels];
missionNamespace setVariable ["OKS_SatCamPip_CommanderZoomIndex", 0];
missionNamespace setVariable ["OKS_SatCamPip_CommanderFov", _zoomLevels#0];

private _profiles = missionNamespace getVariable ["OKS_SatCamPip_VehicleProfiles", createHashMap];
private _profile = _profiles getOrDefault [toLower typeOf _vehicle, createHashMap];

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

    _veh modelToWorldVisualWorld (_pModel vectorAdd _offset)
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
private _eye = if (_memPoint isNotEqualTo "") then {
    _vehicle modelToWorldVisualWorld (_vehicle selectionPosition _memPoint)
} else {
    [_vehicle, _anchorSpec] call _getAnchorWorld
};

private _dirFallback = if (!isNull _viewer) then { eyeDirection _viewer } else { vectorDirVisual _vehicle };
private _dirWorld = _dirFallback;
private _hasDir = false;

// 1) Prefer turret-path direction (updates with turret rotation)
if ((count _trackTurretPath) > 0) then {
    private _cfgTurret = [_vehicle, _trackTurretPath] call BIS_fnc_turretConfig;
    if (!isNull _cfgTurret && {getNumber (_cfgTurret >> "primaryObserver") == 1}) then {
        // ACE-style fallback for commander observer turrets
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

// 2) Fallback: memory-point orientation vectors (some vehicles don't behave with turretDir)
if (!_hasDir && {_memPoint isNotEqualTo ""}) then {
    private _vdu = _vehicle selectionVectorDirAndUp [_memPoint, "Memory"];
    private _dModel = _vdu param [0, [0,0,0], [[]]];
    if (!(_dModel isEqualTo [0,0,0])) then {
        _dirWorld = vectorNormalized (_vehicle vectorModelToWorld _dModel);
        _hasDir = true;
    };
};

private _camPos = _eye vectorAdd (_dirWorld vectorMultiply _camForwardOffset);
private _camTarget = _eye vectorAdd (_dirWorld vectorMultiply 2000);

private _camera = "camera" camCreate _camPos;
_camera camSetTarget _camTarget;
_camera camSetFov (missionNamespace getVariable ["OKS_SatCamPip_CommanderFov", _fov]);
_camera camCommit 0;

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

    // Center + enlarge the PiP panel for commander/gunner/turret view.
    if (!isNull _bg) then {
        private _scale = 2;

        private _bgPos0 = ctrlPosition _bg;
        private _feedPos0 = if (!isNull _feed) then { ctrlPosition _feed } else { _bgPos0 };

        // Inset of feed within bg (so we can scale the margins cleanly).
        private _insetL = (_feedPos0#0) - (_bgPos0#0);
        private _insetT = (_feedPos0#1) - (_bgPos0#1);
        private _insetR = ((_bgPos0#0) + (_bgPos0#2)) - ((_feedPos0#0) + (_feedPos0#2));
        private _insetB = ((_bgPos0#1) + (_bgPos0#3)) - ((_feedPos0#1) + (_feedPos0#3));

        private _newW = (_bgPos0#2) * _scale;
        private _newH = (_bgPos0#3) * _scale;
        private _newX = safezoneX + (safezoneW - _newW) * 0.5;
        private _newY = safezoneY + (safezoneH - _newH) * 0.5;

        // BG resized and centered
        _bg ctrlSetPosition [_newX, _newY, _newW, _newH];
        _bg ctrlCommit 0;

        // Feed resized with the panel (preserving insets)
        if (!isNull _feed) then {
            private _fx = _newX + (_insetL * _scale);
            private _fy = _newY + (_insetT * _scale);
            private _fw = _newW - ((_insetL + _insetR) * _scale);
            private _fh = _newH - ((_insetT + _insetB) * _scale);
            _feed ctrlSetPosition [_fx, _fy, _fw, _fh];
            _feed ctrlCommit 0;
        };

        // Label: top-left of the panel, larger and readable
        private _labelCtrl = _display displayCtrl 9513;
        if (!isNull _labelCtrl) then {
            private _lh = 0.03 * _scale;
            _labelCtrl ctrlSetPosition [_newX + 0.01, _newY - (_lh + 0.005), _newW, _lh];
            _labelCtrl ctrlSetFontHeight (0.03 * _scale);
            _labelCtrl ctrlCommit 0;
        };

        // Hint: bottom-left inside the panel
        private _hintCtrl = _display displayCtrl 9514;
        if (!isNull _hintCtrl) then {
            private _hh = 0.025 * _scale;
            _hintCtrl ctrlSetPosition [_newX + 0.01, _newY + _newH - (_hh + 0.01), _newW - 0.02, _hh];
            _hintCtrl ctrlSetFontHeight (0.025 * _scale);
            _hintCtrl ctrlCommit 0;
        };
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

missionNamespace setVariable ["OKS_SatCamPip_EHs", _ehIds];

private _startT = diag_tickTime;
private _pfhId = [{
    params ["_args", "_pfhId"];
    _args params ["_camera", "_vehicle", "_viewer", "_fov", "_durationSec", "_startT", "_anchorSpec", "_camForwardOffset", "_memPoint", "_uiLabel", "_trackTurretPath"]; 

    if (isNull _camera) exitWith { [_pfhId] call CBA_fnc_removePerFrameHandler; };

    // Commander camera should exit if the local player switches into a main crew seat.
    private _pVeh = vehicle player;
    if (!isNull _pVeh && {_pVeh != player}) then {
        if (player isEqualTo driver _pVeh || {player isEqualTo gunner _pVeh} || {player isEqualTo commander _pVeh}) exitWith {
            [] call OKS_fnc_SatCamPipStop;
            [_pfhId] call CBA_fnc_removePerFrameHandler;
        };
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

    private _eye = if (_memPoint isNotEqualTo "") then {
        _vehicle modelToWorldVisualWorld (_vehicle selectionPosition _memPoint)
    } else {
        private _anchorType = _anchorSpec param [0, "bboxTop", [""]];
        private _anchorData = _anchorSpec param [1, [], [[] ,""]];
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
                // bboxTop
                _pModel = [(_min#0 + _max#0) * 0.5, (_min#1 + _max#1) * 0.5, (_max#2)];
            };
        };

        _vehicle modelToWorldVisualWorld (_pModel vectorAdd _offset)
    };

    private _dirFallback = if (!isNull _viewer) then { eyeDirection _viewer } else { vectorDirVisual _vehicle };
    private _dirWorld = _dirFallback;
    private _hasDir = false;

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

    if (!_hasDir && {_memPoint isNotEqualTo ""}) then {
        private _vdu = _vehicle selectionVectorDirAndUp [_memPoint, "Memory"];
        private _dModel = _vdu param [0, [0,0,0], [[]]];
        if (!(_dModel isEqualTo [0,0,0])) then {
            _dirWorld = vectorNormalized (_vehicle vectorModelToWorld _dModel);
        };
    };

    private _camPos = _eye vectorAdd (_dirWorld vectorMultiply _camForwardOffset);
    private _camTarget = _eye vectorAdd (_dirWorld vectorMultiply 2000);

    _camera camSetFov (missionNamespace getVariable ["OKS_SatCamPip_CommanderFov", _fov]);
    _camera camSetPos _camPos;
    _camera camSetTarget _camTarget;
    _camera camCommit 0;
}, 0, [_camera, _vehicle, _viewer, _fov, _durationSec, _startT, _anchorSpec, _camForwardOffset, _memPoint, _uiLabel, _trackTurretPath]] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable ["OKS_SatCamPip_PFH", _pfhId];

_camera
