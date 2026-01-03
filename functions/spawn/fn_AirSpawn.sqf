/*
    OKS_fnc_AirSpawn

    Spawns an aircraft at a given spawn position and routes it to a target/waypoint.
    Supports selecting aircraft templates (including pylons) and optionally revealing hostile
    ground targets near the waypoint so the aircraft starts with initial intel.

    Backward-compatible with old signature:
        [_spawnPos, _moveToPos, _classname, _side, _shouldBeCareless, _waypointType, _height] spawn OKS_fnc_AirSpawn;

    New signature (defaults are applied when omitted):
        [_spawnPos, _moveToPos, _airframes, _side, _shouldBeCareless, _waypointType, _height, _loadout, _revealTargets, _revealRadius, _revealAirRadius] spawn OKS_fnc_AirSpawn;

    _airframes formats:
        - String classname
        - Array of classnames
        - Array of templates: [ [classname, pylons], ... ]
            Where pylons is either:
            - Array of pylon magazine classnames (index 1..n)
            - Array of pylon tuples: [ [pylonIndex, magazineClass, ammoCount], ... ]
*/

params [
    ["_SpawnPos", objNull, [objNull, []]],
    ["_MoveToPos", objNull, [objNull, []]],
    ["_Airframes", "", ["", []]],
    ["_Side", sideUnknown, [sideUnknown]],
    ["_ShouldBeCareless", false, [true]],
    ["_WaypointType", "SAD", [""]],
    ["_Height", 500, [0]],
    ["_Loadout", nil, [nil, true, "", []]],
    ["_RevealTargets", true, [true]],
    ["_RevealRadius", 2000, [0]],
    ["_RevealAirRadius", 10000, [0]]
];

private _toPosATL = {
    params ["_positionOrObject"];
    if (_positionOrObject isEqualType objNull) exitWith {
        if (isNull _positionOrObject) then {[0,0,0]} else {getPosATL _positionOrObject}
    };
    if (_positionOrObject isEqualType []) exitWith {
        if ((count _positionOrObject) < 3) then {[_positionOrObject param [0,0], _positionOrObject param [1,0], 0]} else {_positionOrObject}
    };
    [0,0,0]
};

private _debugEnabled = missionNamespace getVariable ["OKS_AIRSPAWN_DEBUG", false];
private _debugLog = {
    params ["_message"];
    if (!(missionNamespace getVariable ["OKS_AIRSPAWN_DEBUG", false])) exitWith {};
    // Force LogDebug even if GOL_Core_Debug is disabled.
    [_message, false, false, true] spawn OKS_fnc_LogDebug;
};

private _spawnPositionATL = [_SpawnPos] call _toPosATL;
private _moveToPositionATL = [_MoveToPos] call _toPosATL;

// Waypoint/target positions for AirSpawn are intended to be ground-referenced.
// Eden context menus can sometimes pass a clicked entity (at altitude) instead of a ground click.
// Clamp target altitude to 0 to avoid placing the waypoint in the sky.
_moveToPositionATL set [2, 0];

// Small offset so spawn/target positions are not exactly on top of helper logics.
private _offsetDistance = 5;
private _offsetPosATL = {
    params ["_pos", "_dist", "_dirDeg"];
    private _p = +_pos;
    if ((count _p) < 3) exitWith {_p};
    _p set [0, (_p select 0) + (sin _dirDeg) * _dist];
    _p set [1, (_p select 1) + (cos _dirDeg) * _dist];
    _p
};

private _directionToTargetFlat = [_spawnPositionATL, _moveToPositionATL, 0] call BIS_fnc_dirTo;
_spawnPositionATL = [_spawnPositionATL, _offsetDistance, _directionToTargetFlat + 180] call _offsetPosATL;
_moveToPositionATL = [_moveToPositionATL, _offsetDistance, _directionToTargetFlat] call _offsetPosATL;

_spawnPositionATL set [2, _Height];

private _resolveAirframe = {
    params ["_airframes"];
    private _selectedClassName = "";
    private _templateLoadout = nil;

    if (_airframes isEqualType "") exitWith {[_airframes, nil]};
    if !(_airframes isEqualType []) exitWith {["", nil]};
    if (_airframes isEqualTo []) exitWith {["", nil]};

    private _selectedAirframe = selectRandom _airframes;
    if (_selectedAirframe isEqualType "") exitWith {[_selectedAirframe, nil]};
    if (_selectedAirframe isEqualType []) exitWith {
        _selectedClassName = _selectedAirframe param [0, ""];
        _templateLoadout = _selectedAirframe param [1, nil];
        [_selectedClassName, _templateLoadout]
    };
    ["", nil]
};

private _resolvedAirframe = [_Airframes] call _resolveAirframe;
private _className = _resolvedAirframe param [0, ""];
private _templateLoadout = _resolvedAirframe param [1, nil];

if (_className isEqualTo "") exitWith {};
if (_Side isEqualTo sideUnknown) then { _Side = east; };

private _directionToTarget = [_spawnPositionATL, _moveToPositionATL, 0] call BIS_fnc_dirTo;

[format ["[AIRSPAWN] SpawnPosATL=%1 MoveToATL=%2 Offset=%3m Class=%4 Side=%5 WP=%6 Height=%7", _spawnPositionATL, _moveToPositionATL, _offsetDistance, _className, _Side, _WaypointType, _Height]] call _debugLog;

private _aircraft = createVehicle [_className, _spawnPositionATL, [], -1, "FLY"];
_aircraft setPosATL _spawnPositionATL;
_aircraft setDir _directionToTarget;
_aircraft setVelocityModelSpace [0, 20, 0];
_aircraft flyInHeight _Height;

private _crewGroup = [_aircraft, _Side] call OKS_fnc_AddVehicleCrew;

[format ["[AIRSPAWN] Spawned aircraft=%1 group=%2 crew=%3", _aircraft, _crewGroup, units _crewGroup]] call _debugLog;

// Expose latest spawned entities for debugging (query from Server Exec / RPT).
if (missionNamespace getVariable ["OKS_AIRSPAWN_DEBUG", false]) then {
    missionNamespace setVariable ["OKS_AIRSPAWN_LAST_AIRCRAFT", _aircraft, true];
    missionNamespace setVariable ["OKS_AIRSPAWN_LAST_GROUP", _crewGroup, true];
    missionNamespace setVariable ["OKS_AIRSPAWN_LAST_LEADER", leader _crewGroup, true];
};

private _applyLoadout = {
    params ["_vehicle", "_loadout"];
    if (isNil "_loadout") exitWith {};

    // true / string => use OKS_fnc_AirLoadout fallback
    if (_loadout isEqualType true) exitWith { [_vehicle] spawn OKS_fnc_AirLoadout; };
    if (_loadout isEqualType "") exitWith { [_vehicle] spawn OKS_fnc_AirLoadout; };
    if !(_loadout isEqualType []) exitWith {};
    if (_loadout isEqualTo []) exitWith {};

    private _firstElement = _loadout select 0;

    // Array of magazine classnames => apply by pylon index (1..n)
    if (_firstElement isEqualType "") exitWith {
        { _vehicle setPylonLoadout [_forEachIndex + 1, _x, true]; } forEach _loadout;
    };

    // Array of tuples => [pylonIndex, magazineClass, ammoCount]
    if (_firstElement isEqualType []) exitWith {
        {
            _x params ["_pylonIndex", "_magazineClass", ["_ammoCount", -1]];
            _vehicle setPylonLoadout [_pylonIndex, _magazineClass, true];
            if (_ammoCount isEqualType 0 && {_ammoCount >= 0}) then {
                _vehicle setAmmoOnPylon [_pylonIndex, _ammoCount];
            };
        } forEach _loadout;
    };
};

private _effectiveLoadout = if (isNil "_Loadout") then {_templateLoadout} else {_Loadout};
[_aircraft, _effectiveLoadout] call _applyLoadout;

if (_ShouldBeCareless) then {
    _crewGroup setBehaviour "CARELESS";
    _crewGroup setCombatMode "BLUE";
} else {
    _crewGroup setBehaviour "COMBAT";
    _crewGroup setCombatMode "RED";
};

private _waypoint = _crewGroup addWaypoint [_moveToPositionATL, 0];
_waypoint setWaypointType _WaypointType;

// Mirror engagement settings on the waypoint (helps when group inherits other defaults).
if (_ShouldBeCareless) then {
    _waypoint setWaypointBehaviour "CARELESS";
    _waypoint setWaypointCombatMode "BLUE";
} else {
    _waypoint setWaypointBehaviour "COMBAT";
    _waypoint setWaypointCombatMode "RED";
};

// Give the aircraft some initial intel around the target/waypoint.
if (_RevealTargets) then {
    private _revealTick = {
        params ["_aircraft", "_crewGroup", "_moveToPositionATL", "_revealRadius", "_revealAirRadius", "_debugLog"];
        if (isNull _aircraft || {!alive _aircraft}) exitWith {};
        if (isNull _crewGroup || {(count (units _crewGroup)) == 0}) exitWith {};

        private _crewUnits = units _crewGroup;
        private _ownSide = side _crewGroup;
        private _isHostile = {
            params ["_sA", "_sB"];
            // Treat anything below "friendly" as hostile/engageable.
            (_sA getFriend _sB) < 0.6
        };

        private _resolveTargetSide = {
            params ["_obj"];
            private _s = side _obj;
            if (_s isEqualTo sideUnknown && { _obj isKindOf "AllVehicles" }) then {
                private _ec = effectiveCommander _obj;
                if (!isNull _ec) then { _s = side (group _ec); };
            };
            _s
        };

        private _revealToCrewAndVehicle = {
            params ["_target"];
            { _x reveal [_target, 4]; } forEach _crewUnits;
            // Some platforms behave as if the vehicle itself is the "sensor".
            // Revealing via the aircraft object can improve consistency.
            _aircraft reveal [_target, 4];
        };

        // 1) Air targets within radius of the aircraft (helps AA/A2A behavior).
        private _airTargets = _aircraft nearEntities ["Air", _revealAirRadius];
        private _revealedAirCount = 0;
        {
            private _target = _x;
            if (!alive _target) then { continue; };
            if (_target isEqualTo _aircraft) then { continue; };
            if ([_ownSide, [_target] call _resolveTargetSide] call _isHostile) then {
                [_target] call _revealToCrewAndVehicle;
                _revealedAirCount = _revealedAirCount + 1;
            };
        } forEach _airTargets;

        // 2) Ground targets near the waypoint/target position.
        // NOTE: nearEntities can be brittle depending on class filters and map content.
        // We therefore scan units/vehicles and use distance2D to the target position.
        private _groundTargets = (allUnits + vehicles) select {
            private _obj = _x;
            alive _obj
            && { !(_obj isEqualTo _aircraft) }
            && { !(_obj isKindOf "Air") }
            && { (_obj distance2D _moveToPositionATL) <= _revealRadius }
        };
        private _revealedGroundCount = 0;
        {
            private _target = _x;
            if (!alive _target) then { continue; };
            if ([_ownSide, [_target] call _resolveTargetSide] call _isHostile) then {
                [_target] call _revealToCrewAndVehicle;

                // If the target is a unit inside a vehicle, also reveal the vehicle.
                // AI often engages the vehicle, and knowsAbout for the unit can stay low when mounted.
                if (_target isKindOf "Man") then {
                    private _veh = vehicle _target;
                    if (!isNull _veh && { _veh != _target }) then {
                        [_veh] call _revealToCrewAndVehicle;
                    };
                };

                _revealedGroundCount = _revealedGroundCount + 1;
            };
        } forEach _groundTargets;

        // Help diagnose cases where nothing gets revealed.
        private _hostileNearTarget = _groundTargets select { [_ownSide, [_x] call _resolveTargetSide] call _isHostile };
        private _playersNearTarget = allPlayers select { alive _x && { (_x distance2D _moveToPositionATL) <= _revealRadius } };
        [format ["[AIRSPAWN] GroundScan: candidates=%1 hostile=%2 playersNearTarget=%3 (radius=%4m)", count _groundTargets, count _hostileNearTarget, count _playersNearTarget, _revealRadius]] call _debugLog;

        // Always ensure players near the target are revealed (and their vehicles if mounted).
        private _revealedPlayerCount = 0;
        {
            private _p = _x;
            private _pSide = side (group _p);
            private _friend = _ownSide getFriend _pSide;
            private _pVeh = vehicle _p;

            if ([_ownSide, _pSide] call _isHostile) then {
                [_p] call _revealToCrewAndVehicle;
                if (!isNull _pVeh && { _pVeh != _p }) then {
                    [_pVeh] call _revealToCrewAndVehicle;
                };
                _revealedPlayerCount = _revealedPlayerCount + 1;
            };

            if (missionNamespace getVariable ["OKS_AIRSPAWN_DEBUG", false]) then {
                private _leader = leader _crewGroup;
                private _kUnit = _leader knowsAbout _p;
                private _kVeh = if (!isNull _pVeh && { _pVeh != _p }) then { _leader knowsAbout _pVeh } else { -1 };
                [format ["[AIRSPAWN] PlayerDiag: name=%1 side=%2 friend=%3 hostile=%4 knowsUnit=%5 knowsVeh=%6", name _p, _pSide, _friend, ([_ownSide, _pSide] call _isHostile), _kUnit, _kVeh]] call _debugLog;
            };
        } forEach _playersNearTarget;

        [format ["[AIRSPAWN] RevealPlayers: %1/%2", _revealedPlayerCount, count _playersNearTarget]] call _debugLog;
        [format ["[AIRSPAWN] Reveal: air=%1/%2 within %3m, ground=%4/%5 within %6m", _revealedAirCount, count _airTargets, _revealAirRadius, _revealedGroundCount, count _groundTargets, _revealRadius]] call _debugLog;
    };

    if (_debugEnabled && {isDedicated}) then {
        [format ["[AIRSPAWN] NOTE: dedicated server context; 'player' is %1. Use allPlayers when testing knowsAbout server-side.", player]] call _debugLog;
    };

    // Initial reveal pass.
    [_aircraft, _crewGroup, _moveToPositionATL, _RevealRadius, _RevealAirRadius, _debugLog] call _revealTick;

    // Periodic refresh: keeps intel from decaying and picks up new contacts.
    // Limited duration so it doesn't run forever.
    [_aircraft, _crewGroup, _moveToPositionATL, _RevealRadius, _RevealAirRadius, _debugLog, _revealTick] spawn {
        params ["_aircraft", "_crewGroup", "_moveToPositionATL", "_revealRadius", "_revealAirRadius", "_debugLog", "_revealTick"];
        private _interval = 60;
        private _maxRuns = 10;

        for "_i" from 1 to _maxRuns do {
            sleep _interval;
            if (isNull _aircraft || {!alive _aircraft}) exitWith {};
            if (isNull _crewGroup || {(count (units _crewGroup)) == 0}) exitWith {};

            // If we're close enough to the target, stop refreshing.
            if ((_aircraft distance2D _moveToPositionATL) < ((_revealRadius min 1000) max 200)) exitWith {};

            [_aircraft, _crewGroup, _moveToPositionATL, _revealRadius, _revealAirRadius, _debugLog] call _revealTick;
            [format ["[AIRSPAWN] RevealRefresh: tick=%1/%2", _i, _maxRuns]] call _debugLog;
        };
    };
};

if (waypointType _waypoint != "SAD") then {
    _waypoint setWaypointCompletionRadius 1000;
    _waypoint setWaypointStatements ["true", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach thisList"];
};