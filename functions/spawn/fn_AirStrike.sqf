/*
    Function: OKS_fnc_AirStrike

    Description:
        Spawns a crewed jet that performs a bombing run on a target position, then exits
        and deletes. The aircraft flies from the spawn position toward a strike anchor
        point (using the anchor's direction for attack heading), releases ordnance when
        within 500m, then continues to the exit waypoint where it is cleaned up.
        Supports guided bombs (GBU-12) and cluster munitions. For cluster strikes,
        unexploded ordnance (UXO) is automatically force-detonated after a short delay
        to prevent persistent ground hazards. The bomb ammo class can be overridden
        globally via the OKS_AirStrike_BombAmmoClass variable.

    Parameters:
        0: _spawnIn       - ARRAY or OBJECT - Spawn position [x,y,z] or spawn object
        1: _strikeIn      - OBJECT or ARRAY - Strike anchor object (preferred; uses its direction) or position
        2: _endIn         - ARRAY or OBJECT - Exit position [x,y,z] or object (aircraft deleted on arrival)
        3: _classname     - STRING          - Aircraft classname (e.g. "B_Plane_Fighter_01_Stealth_F")
        4: _side          - SIDE            - Faction side for the crew (default: east)
        5: _height        - NUMBER          - Flight altitude in meters (default: 250)
        6: _munitionSpec  - STRING          - Munition type: "BOMB" for guided bombs, "CLUSTER" for cluster munitions (default: "BOMB")

    Returns:
        Nothing

    Example:
        // Guided bomb strike
        [getPos jetspawn_1, jetstrike_1, getPos jetexit_1, "B_Plane_Fighter_01_Stealth_F", west, 250] spawn OKS_fnc_AirStrike;

        // Cluster bomb strike
        [getPos jetspawn_1, jetstrike_1, getPos jetexit_1, "B_Plane_Fighter_01_Stealth_F", west, 250, "CLUSTER"] spawn OKS_fnc_AirStrike;
*/

if (!isServer) exitWith {};

private _debugEnabled = missionNamespace getVariable ["OKS_AirStrike_Debug", false];
private _debugLog = {
    params ["_message"];
    if (!(missionNamespace getVariable ["OKS_AirStrike_Debug", false])) exitWith {};
    // Force LogDebug even if GOL_Core_Debug is disabled.
    [_message, false, false, true] spawn OKS_fnc_LogDebug;
};

params [
    ["_spawnIn", [0,0,0], [[], objNull]],
    ["_strikeIn", objNull, [[], objNull]],
    ["_endIn", [0,0,0], [[], objNull]],
    ["_classname", "", [""]],
    ["_side", east, [sideUnknown]],
    ["_height", 250, [0]],
    // Backward compatible: default to guided bombs.
    // Supported formats (case-insensitive):
    //   "BOMB" | "CLUSTER"
    ["_munitionSpec", "BOMB", [""]]
];

private _spawnPos = if (_spawnIn isEqualType objNull) then { getPosATL _spawnIn } else { _spawnIn };
private _endPos = if (_endIn isEqualType objNull) then { getPosATL _endIn } else { _endIn };

private _strikeObj = if (_strikeIn isEqualType objNull) then { _strikeIn } else { objNull };
private _strikeAnchorPos = if (!isNull _strikeObj) then { getPosATL _strikeObj } else { _strikeIn };

private _direction = if (!isNull _strikeObj) then { getDir _strikeObj } else { _spawnPos getDir _strikeAnchorPos };

private _strikePos = if (!isNull _strikeObj) then {
    _strikeObj getPos [350, (getDir _strikeObj - 180)]
} else {
    [_strikeAnchorPos, 350, (_direction - 180)] call BIS_fnc_relPos
};

private _spawnPos3d = [_spawnPos#0, _spawnPos#1, _height];

private _aircraft = createVehicle [_classname, _spawnPos3d, [], 0, "FLY"];
_aircraft setPosATL _spawnPos3d;
_aircraft setDir (_aircraft getDir _strikePos);
_aircraft setVelocityModelSpace [0, 500, 0];

private _crewGroup = [_aircraft, _side] call OKS_fnc_AddVehicleCrew;
_aircraft flyInHeight _height;

{
    _x disableAI "AUTOCOMBAT";
    _x disableAI "TARGET";
    _x disableAI "AUTOTARGET";
    _x disableAI "LIGHTS";
} forEach units _crewGroup;

_crewGroup setBehaviour "CARELESS";
_crewGroup setCombatMode "BLUE";

private _moveWp = _crewGroup addWaypoint [_strikePos, 0];
_moveWp setWaypointType "MOVE";

private _exitWp = _crewGroup addWaypoint [_endPos, 0];
_exitWp setWaypointType "MOVE";
_exitWp setWaypointCompletionRadius 1000;
_exitWp setWaypointStatements ["true", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach (units group this);"];

waitUntil { sleep 0.2; _aircraft distance2D _strikePos < 500 || !alive _aircraft };
if (!alive _aircraft) exitWith {};

sleep 1;

private _prefix = toUpper _munitionSpec;
private _munitionType = if (_prefix find "CLUSTER" == 0) then {"CLUSTER"} else {"BOMB"};

private _clusterAmmo = "BombCluster_01_Ammo_F";
private _defaultBombAmmo = "Bo_GBU12_LGB";
private _bombAmmo = missionNamespace getVariable ["OKS_AirStrike_BombAmmoClass", _defaultBombAmmo];
if !(_bombAmmo isEqualType "") then { _bombAmmo = _defaultBombAmmo; };
if (_bombAmmo isEqualTo "") then { _bombAmmo = _defaultBombAmmo; };
if !(isClass (configFile >> "CfgAmmo" >> _bombAmmo)) then { _bombAmmo = _defaultBombAmmo; };

[format ["[AIRSTRIKE] type=%1 aircraft=%2 strikeAnchorATL=%3 strikeRunInATL=%4 bombAmmo=%5", _munitionType, _aircraft, _strikeAnchorPos, _strikePos, _bombAmmo]] call _debugLog;

if (_munitionType == "CLUSTER") then {
    private _bomb = createVehicle [_clusterAmmo, [_strikePos#0, _strikePos#1, 60], [], 0, "NONE"];
    _bomb setDir _direction;
    _bomb setVelocityModelSpace [0, 50, -150];

    // --- UXO handling --------------------------------------------------------
    // Cluster bombs can leave unexploded ordnance (UXO) on the ground.
    // We don't want any persistent UXOs, so we force-trigger them shortly after impact.
    // Known example: "BombCluster_01_UXO4_Ammo_F"
    private _isCfgAmmoClass = {
        params ["_className"];
        isClass (configFile >> "CfgAmmo" >> _className)
    };

    private _knownUXO = [
        "BombCluster_01_UXO1_Ammo_F",
        "BombCluster_01_UXO2_Ammo_F",
        "BombCluster_01_UXO3_Ammo_F",
        "BombCluster_01_UXO4_Ammo_F",
        "BombCluster_02_UXO1_Ammo_F",
        "BombCluster_02_UXO2_Ammo_F",
        "BombCluster_02_UXO3_Ammo_F",
        "BombCluster_02_UXO4_Ammo_F"
    ] select { [_x] call _isCfgAmmoClass };

    private _broadAmmoBases = [
        "BombCore",
        "ShellCore",
        "SubmunitionBase",
        "TimeBombCore",
        "MineBase"
    ] select { [_x] call _isCfgAmmoClass };

    [_strikePos, _knownUXO, _broadAmmoBases] spawn {
        params ["_strikePos", "_knownUXO", "_broadAmmoBases"];

        private _scanRadius = 700;
        private _initialDelay = 6;
        private _scanInterval = 1;
        private _scanRuns = 45;

        sleep _initialDelay;

        private _alreadyTriggered = [];
        private _isUXOTypeName = {
            params ["_typeName"];
            (_typeName find "_UXO") >= 0 && { (_typeName find "_Ammo") >= 0 }
        };

        private _triggerUXO = {
            params ["_obj"];
            if (isNull _obj) exitWith {};
            _obj setDamage 1;
            triggerAmmo _obj;
        };

        for "_i" from 1 to _scanRuns do {
            private _candidates = [];

            if !(_knownUXO isEqualTo []) then {
                _candidates append (nearestObjects [_strikePos, _knownUXO, _scanRadius]);
            };
            if !(_broadAmmoBases isEqualTo []) then {
                _candidates append (nearestObjects [_strikePos, _broadAmmoBases, _scanRadius]);
            };

            {
                private _obj = _x;
                if (isNull _obj) then { continue; };

                private _t = typeOf _obj;
                if (!([_t] call _isUXOTypeName) && {!(_t in _knownUXO)}) then { continue; };

                private _id = netId _obj;
                if (_id isEqualTo "") then { _id = str _obj; };
                if (_id in _alreadyTriggered) then { continue; };
                _alreadyTriggered pushBack _id;

                [_obj] call _triggerUXO;
            } forEach _candidates;

            sleep _scanInterval;
        };
    };
} else {
    private _attackDirDeg = [_strikePos, _strikeAnchorPos, 0] call BIS_fnc_dirTo;
    private _spacing = missionNamespace getVariable ["OKS_AirStrike_BombSpacing", 40];
    if !(_spacing isEqualType 0) then { _spacing = 40; };
    _spacing = (_spacing max 5) min 150;

    private _bombCount = missionNamespace getVariable ["OKS_AirStrike_BombCount", 3];
    if !(_bombCount isEqualType 0) then { _bombCount = 3; };
    _bombCount = (round _bombCount) max 1 min 4;

    private _targetATL0 = [_strikeAnchorPos#0, _strikeAnchorPos#1, 0];
    private _bombTargetsATL0 = [];
    for "_i" from 0 to (_bombCount - 1) do {
        if (_i == 0) then {
            _bombTargetsATL0 pushBack _targetATL0;
        } else {
            _bombTargetsATL0 pushBack ([_targetATL0, _spacing * _i, _attackDirDeg] call BIS_fnc_relPos);
        };
    };

    [format ["[AIRSTRIKE] BOMB carpet: count=%1 dir=%2 spacing=%3 targets=%4", _bombCount, _attackDirDeg, _spacing, _bombTargetsATL0]] call _debugLog;

    private _guideBomb = {
        params ["_bomb", "_targetATL0", "_debugEnabled", "_bombIndex"];

        private _debugLogLocal = {
            params ["_message", "_debugEnabled"]; 
            if (!_debugEnabled) exitWith {};
            [_message, false, false, true] spawn OKS_fnc_LogDebug;
        };

        private _targetASL = ATLToASL _targetATL0;
        // No initial sleep here: we do an immediate first-step orientation at spawn time.

        private _tick = 0.02;
        private _maxTime = 45;
        private _t0 = diag_tickTime;
        private _lastLog = -1;

        // Guidance tuning
        private _maxSpeedXY = 200;
        private _minSpeedXY = 60;
        private _rampDuration = 0.6;
        private _stopDist = 50;   // stop steering close to target to prevent flip-flop
        private _stopAlt = 150;   // but don't stop too early while still high

        private _minVZ = -12;
        private _maxVZ = -140;

        private _prevDist2D = 1e12;

        while { !isNull _bomb && {alive _bomb} && {diag_tickTime - _t0 < _maxTime} } do {
            private _bombATL = getPosATL _bomb;
            private _bombASL = getPosASL _bomb;

            private _dist2D = _bombATL distance2D _targetATL0;
            private _altATL = _bombATL select 2;

            // If we start increasing distance very close in, we've likely overshot and will oscillate.
            if (_dist2D > (_prevDist2D + 5) && {_prevDist2D < (_stopDist + 30)}) exitWith {
                [format ["[AIRSTRIKE] BOMB[%1] stop steering (overshoot) | t=%2 prevDist=%3 dist2D=%4 altATL=%5", _bombIndex, (diag_tickTime - _t0) toFixed 2, _prevDist2D toFixed 1, _dist2D toFixed 1, _altATL toFixed 1], _debugEnabled] call _debugLogLocal;
            };
            _prevDist2D = _dist2D;

            if (_altATL < 0.8) exitWith {
                [format ["[AIRSTRIKE] BOMB[%1] stop steering (low alt) | t=%2 dist2D=%3 altATL=%4", _bombIndex, (diag_tickTime - _t0) toFixed 2, _dist2D toFixed 1, _altATL toFixed 2], _debugEnabled] call _debugLogLocal;
            };
            // Main "close-in" stop: prevents last-second flip/flop and unnatural snapping.
            if (_dist2D < _stopDist && {_altATL < _stopAlt}) exitWith {
                [format ["[AIRSTRIKE] BOMB[%1] stop steering (close-in) | t=%2 dist2D=%3 altATL=%4", _bombIndex, (diag_tickTime - _t0) toFixed 2, _dist2D toFixed 1, _altATL toFixed 1], _debugEnabled] call _debugLogLocal;
            };

            private _toTarget2D = [_targetASL#0 - _bombASL#0, _targetASL#1 - _bombASL#1, 0];
            private _dir2D = vectorNormalized _toTarget2D;
            if ((vectorMagnitude _dir2D) < 0.001) then {
                _dir2D = vectorNormalized (velocity _bomb);
                _dir2D set [2, 0];
                _dir2D = vectorNormalized _dir2D;
            };

            // Use actual XY speed for time-to-go so we don't "think" we're faster than the sim allows.
            // If we underestimate tGo, we dive too hard early, get low too soon, then glide near the ground.
            private _vNowPre = velocity _bomb;
            private _speedNowXY = sqrt ((_vNowPre#0)^2 + (_vNowPre#1)^2);

            private _elapsed = diag_tickTime - _t0;
            private _alpha = (_elapsed / _rampDuration) min 1;
            private _speedCmdXY = (_speedNowXY + (_maxSpeedXY - _speedNowXY) * _alpha) max _minSpeedXY;

            // Effective speed for tGo: blend current speed and command (helps stability when drag limits acceleration).
            private _speedForTgo = ((_speedNowXY max 1) + (_speedCmdXY max 1)) / 2;

            private _tGo = (_dist2D / (_speedForTgo max 1));
            _tGo = _tGo max 0.3;
            private _desiredVZ = -(_altATL / _tGo);
            _desiredVZ = (_desiredVZ min _minVZ) max _maxVZ;

            private _vXY = _dir2D vectorMultiply _speedCmdXY;
            private _vel = [_vXY#0, _vXY#1, _desiredVZ];

            private _velDir = vectorNormalized _vel;
            _bomb setVectorDirAndUp [_velDir, [0,0,1]];
            _bomb setVelocity _vel;

            if (_debugEnabled && {diag_tickTime - _lastLog > 0.5}) then {
                _lastLog = diag_tickTime;
                private _vNow = velocity _bomb;
                private _speedNowXY2 = sqrt ((_vNow#0)^2 + (_vNow#1)^2);
                [format ["[AIRSTRIKE] BOMB[%1] tick | t=%2 dist2D=%3 altATL=%4 tGo=%5 speedNowXY=%6 speedCmdXY=%7 vZcmd=%8 velNow=%9 posATL=%10", _bombIndex, (diag_tickTime - _t0) toFixed 2, _dist2D toFixed 1, _altATL toFixed 1, _tGo toFixed 2, _speedNowXY2 toFixed 1, _speedCmdXY toFixed 1, _desiredVZ toFixed 1, _vNow, _bombATL], _debugEnabled] call _debugLogLocal;
            };

            sleep _tick;
        };

        if (!isNull _bomb && {alive _bomb}) then {
            [format ["[AIRSTRIKE] BOMB[%1] timeout | t=%2 dist2D=%3 altATL=%4 (steering stopped)", _bombIndex, (diag_tickTime - _t0) toFixed 2, ((getPosATL _bomb) distance2D _targetATL0) toFixed 1, ((getPosATL _bomb) select 2) toFixed 1], _debugEnabled] call _debugLogLocal;
        };
    };

    {
        private _thisTargetATL0 = _x;
        private _bombIndex = _forEachIndex;
        if (_bombIndex > 0) then { sleep 0.15; };

        private _bb = boundingBoxReal _aircraft;
        private _bbMin = _bb param [0, [0,0,0]];
        private _bbMinZ = _bbMin param [2, -2.5];
        private _aircraftASL = getPosASL _aircraft;
        private _aircraftATL = getPosATL _aircraft;
        private _dirDeg = getDir _aircraft;

        private _clearanceMeters = (abs _bbMinZ) + 2;
        private _rearOffsetMeters = 10;

        private _dropPosASL = [
            (_aircraftASL select 0) - (sin _dirDeg) * _rearOffsetMeters,
            (_aircraftASL select 1) - (cos _dirDeg) * _rearOffsetMeters,
            (_aircraftASL select 2) - _clearanceMeters
        ];

        private _safeCreateASL = _aircraftASL vectorAdd ((vectorUp _aircraft) vectorMultiply 200);
        private _safeCreateATL = ASLToATL _safeCreateASL;

        private _bomb = createVehicle [_bombAmmo, _safeCreateATL, [], 0, "NONE"];
        _bomb disableCollisionWith _aircraft;
        _aircraft disableCollisionWith _bomb;
        _bomb setPosASL _dropPosASL;

        _bomb setDir (getDir _aircraft);
        private _airVel = velocity _aircraft;
        private _bombVel0 = [(_airVel select 0) * 0.75, (_airVel select 1) * 0.75, (_airVel select 2) - 10];
        _bomb setVelocity _bombVel0;

        // Immediate first-step guidance (same frame) to eliminate visible orientation snap.
        private _targetASL0 = ATLToASL _thisTargetATL0;
        private _bombATL0 = getPosATL _bomb;
        private _bombASL0 = getPosASL _bomb;
        private _dist2D0 = _bombATL0 distance2D _thisTargetATL0;
        private _altATL0 = _bombATL0 select 2;

        private _toTarget2D0 = [_targetASL0#0 - _bombASL0#0, _targetASL0#1 - _bombASL0#1, 0];
        private _dir2D0 = vectorNormalized _toTarget2D0;
        if ((vectorMagnitude _dir2D0) < 0.001) then {
            _dir2D0 = vectorNormalized _bombVel0;
            _dir2D0 set [2, 0];
            _dir2D0 = vectorNormalized _dir2D0;
        };

        private _speedNowXY0 = sqrt ((_bombVel0#0)^2 + (_bombVel0#1)^2);
        private _speedCmdXY0 = (_speedNowXY0 min 200) max 60;
        private _tGo0 = (_dist2D0 / (_speedCmdXY0 max 1)) max 0.3;
        private _desiredVZ0 = -(_altATL0 / _tGo0);
        _desiredVZ0 = (_desiredVZ0 min -12) max -140;

        private _vXY0 = _dir2D0 vectorMultiply _speedCmdXY0;
        private _vel0 = [_vXY0#0, _vXY0#1, _desiredVZ0];
        private _velDir0 = vectorNormalized _vel0;
        _bomb setVectorDirAndUp [_velDir0, [0,0,1]];
        _bomb setVelocity _vel0;

        [format ["[AIRSTRIKE] BOMB drop[%1]: bomb=%2 createdATL=%3 movedATL=%4 aircraftATL=%5 bbMinZ=%6 clearance=%7 rearOffset=%8 airVel=%9 bombVel0=%10 distToAircraft=%11 targetATL0=%12", _bombIndex, _bomb, _safeCreateATL, getPosATL _bomb, _aircraftATL, _bbMinZ, _clearanceMeters, _rearOffsetMeters, _airVel, _bombVel0, (_bomb distance _aircraft) toFixed 1, _thisTargetATL0]] call _debugLog;

        [_bomb, _thisTargetATL0, _debugEnabled, _bombIndex] spawn _guideBomb;
    } forEach _bombTargetsATL0;
};
