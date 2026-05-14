/*
    Function: OKS_fnc_InterceptHvtTask

     Description:
     Spawns an HVT with guards, delays movement, mounts into a vehicle if available,
     and runs an intercept task that can resolve by capture or capture-or-kill.
     Optional extraction site turns the task into a two-phase objective where surrender
     is required first and then transport on foot to extraction.

     Parameters:
     0: _spawnPos (ARRAY|OBJECT)
         HVT anchor spawn position. Guards may be placed in nearest suitable building.
     1: _endPos (ARRAY|OBJECT)
         Destination used for movement and end behavior.
     2: _side (SIDE|ARRAY)
         Either a single side for both or [hvtSide, guardSide]. Sides must be friendly.
     3: _endBehavior (STRING)
         "DISAPPEAR" or "GARRISON".
     4: _designatedVehicle (OBJECT)
         Optional vehicle. If null/invalid, nearest valid vehicle is selected.
     5: _delay (NUMBER|ARRAY)
         Number in seconds or [min,max] random range. Default 180.
     6: _guardData (ARRAY)
         [guardCount, surrenderThresholdPercent].
     7: _taskData (ARRAY)
         [showTaskPosition, taskParentId, showVehicleType, hvtProfileImagePath].
     8: _failOnKill (BOOL|STRING legacy)
         Primary mode bool. true = capture (HVT death fails), false = capture-or-kill.
         Legacy strings still accepted: "CAPTURE", "CAPTUREORKILL", "KILL".
     9: _extractionSite (NIL|ARRAY|OBJECT)
         Optional extraction objective. If set, completion requires surrendered HVT
         on foot within 50m of extraction.

    Returns: HVT unit object (or objNull on failure)

    Notes:
    The provided spawn position is the HVT anchor point. The HVT spawns on that exact
    position, while guards may be placed into the nearest suitable building around it.
    The returned HVT unit can be customized (name/face/loadout) by caller code; the
    main task profile text is assembled later after the configured delay.

    Example:
    [
        getPosATL SpawnLogic,
        getPosATL EndLogic,
        [east, east],
        "GARRISON",
        objNull,
        [120, 240],
        [8, 30],
        [true, "MainTask", true, ""],
        true,
        nil
    ] call OKS_fnc_InterceptHvtTask;
*/

if (!isServer) exitWith {
    if (missionNamespace getVariable ["GOL_HVT_Debug", false]) then {
        "[INTERCEPT HVT] fn_InterceptHvtTask ignored: called on non-server machine." call OKS_fnc_LogDebug;
    };
    objNull
};

params [
    ["_spawnPos", [0,0,0], [[], objNull]],
    ["_endPos", [0,0,0], [[], objNull]],
    ["_side", east, [sideUnknown, []]],
    ["_endBehavior", "DISAPPEAR", [""]],
    ["_designatedVehicle", objNull, [objNull]],
    ["_delay", 180, [0, []]],
    ["_guardData", [6, 35], [[]]],
    ["_taskData", [true, "", true, ""], [[]]],
    ["_failOnKill", true, [true, ""]],
    ["_extractionSite", nil]
];

private _hvtDebug = missionNamespace getVariable ["GOL_HVT_Debug", false];

if (_hvtDebug) then {
    "[INTERCEPT HVT] fn_InterceptHvtTask entered." call OKS_fnc_LogDebug;
};

private _spawnPosition = if (_spawnPos isEqualType objNull) then {getPosATL _spawnPos} else {_spawnPos};
private _endPosition = if (_endPos isEqualType objNull) then {getPosATL _endPos} else {_endPos};

private _hvtSide = _side;
private _guardSide = _side;
if (_side isEqualType []) then {
    _hvtSide = _side param [0, sideUnknown, [sideUnknown]];
    _guardSide = _side param [1, sideUnknown, [sideUnknown]];
};

if (
    _hvtSide isEqualTo sideUnknown ||
    _guardSide isEqualTo sideUnknown ||
    (_hvtSide getFriend _guardSide) < 0.6 ||
    (_guardSide getFriend _hvtSide) < 0.6
) exitWith {
    format ["[INTERCEPT HVT] Invalid side relation. HVT side=%1 Guard side=%2", _hvtSide, _guardSide] call OKS_fnc_LogDebug;
    objNull
};

private _hvtClass = switch (_hvtSide) do {
    case west: {"B_officer_F"};
    case east: {"O_officer_F"};
    case independent: {"I_officer_F"};
    case civilian: {"C_man_1"};
    default {"O_officer_F"};
};

_guardData params [
    ["_guardCount", 6, [0]],
    ["_surrenderThresholdPct", 35, [0]]
];
_guardCount = _guardCount max 0;
_surrenderThresholdPct = (_surrenderThresholdPct max 0) min 100;

_taskData params [
    ["_showTaskPosition", true, [false]],
    ["_taskParent", "", [""]],
    ["_showVehicleType", true, [false]],
    ["_hvtProfileImagePath", "", [""]]
];

// Primary mode is now bool: true=Capture (kill fails), false=CaptureOrKill (kill succeeds).
// Backward compatibility: accept old string mode in this same slot.
private _killFailsTask = true;
if (_failOnKill isEqualType "") then {
    private _legacyMode = toUpperANSI _failOnKill;
    _killFailsTask = !(_legacyMode in ["CAPTUREORKILL", "CAPTURE_OR_KILL", "KILL"]);
    if (_hvtDebug) then {
        "[INTERCEPT HVT] Legacy mode string detected. Prefer bool FailOnKill (true/false)." call OKS_fnc_LogDebug;
    };
} else {
    _killFailsTask = _failOnKill;
};

private _hasExtraction = false;
private _extractionPos = [0,0,0];
if (!isNil "_extractionSite") then {
    if (_extractionSite isEqualType objNull) then {
        if (!isNull _extractionSite) then {
            _hasExtraction = true;
            _extractionPos = getPosATL _extractionSite;
        };
    } else {
        if (_extractionSite isEqualType []) then {
            if ((count _extractionSite) >= 2) then {
                _hasExtraction = true;
                _extractionPos = +_extractionSite;
            };
        };
    };
};

private _waitDelay = 180;
if (_delay isEqualType 0) then {
    _waitDelay = _delay max 0;
};
if (_delay isEqualType []) then {
    private _from = _delay param [0, 180, [0]];
    private _to = _delay param [1, _from, [0]];
    if (_to < _from) then {
        private _tmp = _from;
        _from = _to;
        _to = _tmp;
    };
    _waitDelay = _from + random (_to - _from);
};

private _hvtGroup = createGroup [_hvtSide, true];
private _hvtUnit = _hvtGroup createUnit [_hvtClass, _spawnPosition, [], 0, "NONE"];
_hvtUnit setVariable ["GOL_HVT", true, true];
_hvtUnit setVariable ["GOL_SurrenderEnabled", true, true];
_hvtUnit setVariable ["OKS_InterceptHvt_AllowExit", false, true];

private _taskSettings = [_guardSide] call OKS_fnc_Task_Settings;
_taskSettings params [
    ["_leaders", []],
    ["_units", []]
];

if (_leaders isEqualTo [] || {_units isEqualTo []}) exitWith {
    format ["[INTERCEPT HVT] Missing guard class settings for side %1", _guardSide] call OKS_fnc_LogDebug;
    deleteVehicle _hvtUnit;
    objNull
};

private _guardGroup = createGroup [_guardSide, true];
for "_i" from 1 to _guardCount do {
    private _className = if ((count units _guardGroup) == 0) then {selectRandom _leaders} else {selectRandom _units};
    private _u = _guardGroup createUnit [_className, _spawnPosition, [], 0, "NONE"];
    _u setVariable ["GOL_HVT_Guard", true, true];
};

private _initialBuilding = nearestBuilding _spawnPosition;
if (!isNull _initialBuilding && {_initialBuilding distance2D _spawnPosition < 120}) then {
    private _buildingPos = [_initialBuilding] call BIS_fnc_buildingPositions;
    if (_buildingPos isNotEqualTo []) then {
        {
            _x setPosATL (_buildingPos select (_forEachIndex mod (count _buildingPos)));
            _x disableAI "PATH";
            _x setUnitPos "MIDDLE";
        } forEach (units _guardGroup);
    };
};

if (_hvtDebug) then {
    format ["[INTERCEPT HVT] Spawned HVT=%1 with %2 guards. Delay=%3s", _hvtUnit, _guardCount, round _waitDelay] call OKS_fnc_LogDebug;
};

[
    _hvtUnit,
    _guardGroup,
    _spawnPosition,
    _endPosition,
    _endBehavior,
    _designatedVehicle,
    _waitDelay,
    _guardCount,
    _surrenderThresholdPct,
    _showTaskPosition,
    _taskParent,
    _showVehicleType,
    _hvtProfileImagePath,
    _killFailsTask,
    _hasExtraction,
    _extractionPos,
    _hvtDebug
] spawn {
    params [
        "_hvtUnit",
        "_guardGroup",
        "_spawnPosition",
        "_endPosition",
        "_endBehavior",
        "_designatedVehicle",
        "_waitDelay",
        "_initialGuardCount",
        "_surrenderThresholdPct",
        "_showTaskPosition",
        "_taskParent",
        "_showVehicleType",
        "_hvtProfileImagePath",
        "_killFailsTask",
        "_hasExtraction",
        "_extractionPos",
        "_hvtDebug"
    ];

    sleep _waitDelay;

    if (!alive _hvtUnit) exitWith {};

    {
        _x enableAI "PATH";
        _x setBehaviour "CARELESS";
    } forEach (units _guardGroup);

    private _vehicle = [_spawnPosition, _designatedVehicle, _guardGroup, _hvtUnit, 250] call OKS_fnc_InterceptHvt_SelectVehicle;
    private _hvtInVehicle = false;
    private _driverMounted = false;
    private _overflowGuards = [];
    private _overflowGroup = grpNull;

    if (!isNull _vehicle) then {
        _vehicle setVariable ["OKS_InterceptHvt_Reserved", true, false];
        private _mountResult = [_vehicle, _guardGroup, _hvtUnit, _spawnPosition] call OKS_fnc_InterceptHvt_MountGroup;
        _mountResult params ["_overflowGuards", "_hvtMounted", "_driverMountedNow", "_overflowGroup"];
        _hvtInVehicle = _hvtMounted;
        _driverMounted = _driverMountedNow;

        if !(_hvtInVehicle && _driverMounted) then {
            if (_hvtDebug) then {
                format ["[INTERCEPT HVT] Mount fallback to on-foot: hvtMounted=%1 driverMounted=%2 overflow=%3", _hvtInVehicle, _driverMounted, count _overflowGuards] call OKS_fnc_LogDebug;
            };
            {
                if (vehicle _x == _vehicle) then {
                    moveOut _x;
                    unassignVehicle _x;
                };
            } forEach (units _guardGroup);
            if (vehicle _hvtUnit == _vehicle) then {
                moveOut _hvtUnit;
                unassignVehicle _hvtUnit;
            };
            _vehicle = objNull;
        };

        if (!isNull _vehicle && {_hvtInVehicle}) then {
            [_vehicle, _guardGroup, _hvtUnit] spawn OKS_fnc_InterceptHvt_HandleDisabledVehicle;
        };
    };

    private _moveTarget = _endPosition;
    private _nearestRoad = [_endPosition, 250] call BIS_fnc_nearestRoad;
    if (!isNull _nearestRoad) then {
        _moveTarget = getPosATL _nearestRoad;
    };

    if (!isNull _vehicle && {_hvtInVehicle}) then {
        _guardGroup setBehaviour "CARELESS";
        _guardGroup setSpeedMode "FULL";

        private _wp = _guardGroup addWaypoint [_moveTarget, 0];
        _wp setWaypointType "MOVE";
        _wp setWaypointBehaviour "CARELESS";
        _wp setWaypointSpeed "FULL";

        // Overflow guards: sequential vehicle assignment with simple getIn waypoint.
        // Each overflow unit/pair gets their own vehicle and group, then follows main group.
        if (!isNull _overflowGroup && {(units _overflowGroup) isNotEqualTo []}) then {
            [_overflowGroup, _spawnPosition, _moveTarget, _hvtDebug] spawn {
                params ["_og", "_spawnPos", "_target", "_debug"];
                private _pool = (units _og) select {alive _x};
                if (_pool isEqualTo []) exitWith {};

                if (_debug) then {
                    format ["[INTERCEPT HVT][OVERFLOW] Start. units=%1 spawn=%2 target=%3", count _pool, _spawnPos, _target] call OKS_fnc_LogDebug;
                };

                private _overflowSide = side _og;
                
                // Sequentially assign overflow units to vehicles.
                while {_pool isNotEqualTo []} do {
                    // Create a new independent group for this overflow team.
                    private _teamGrp = createGroup [_overflowSide, true];
                    
                    // Pick a vehicle for this team.
                    private _teamVeh = [_spawnPos, objNull, _teamGrp, objNull, 250] call OKS_fnc_InterceptHvt_SelectVehicle;

                    if (_debug) then {
                        format ["[INTERCEPT HVT][OVERFLOW] Pick vehicle result=%1 remainingUnits=%2", _teamVeh, count _pool] call OKS_fnc_LogDebug;
                    };
                    
                    if (isNull _teamVeh) then {
                        // No more vehicles; remaining overflow joins back to main group (on-foot).
                        {
                            [_x] joinSilent _og;
                        } forEach _pool;

                        _og setBehaviour "AWARE";
                        _og setSpeedMode "FULL";
                        _og move _target;

                        _pool = [];
                        
                        if (_debug) then {
                            "[INTERCEPT HVT][OVERFLOW] No additional vehicle available; remaining guards moving on-foot as overflow group." call OKS_fnc_LogDebug;
                        };
                    } else {
                        // Overflow transport must have a drivable seat for this team.
                        if ((_teamVeh emptyPositions "driver") <= 0 && {isNull driver _teamVeh}) then {
                            if (_debug) then {
                                format ["[INTERCEPT HVT][OVERFLOW] Skip non-drivable vehicle %1", typeOf _teamVeh] call OKS_fnc_LogDebug;
                            };
                            _teamVeh setVariable ["OKS_InterceptHvt_Reserved", false, false];
                            deleteGroup _teamGrp;
                            sleep 0.2;
                            continue;
                        };

                        _teamVeh setVariable ["OKS_InterceptHvt_Reserved", true, false];
                        _teamGrp addVehicle _teamVeh;
                        
                        // Fill this team with units up to vehicle capacity.
                        private _teamUnits = [];
                        private _teamCapacity = (
                            (_teamVeh emptyPositions "driver") +
                            (_teamVeh emptyPositions "commander") +
                            (_teamVeh emptyPositions "gunner") +
                            (_teamVeh emptyPositions "cargo")
                        ) max 1;
                        
                        for "_i" from 1 to _teamCapacity do {
                            if (_pool isEqualTo []) exitWith {};
                            private _u = _pool deleteAt 0;
                            [_u] joinSilent _teamGrp;
                            _teamUnits pushBack _u;
                        };
                        
                        if (_teamUnits isNotEqualTo []) then {
                            // Explicitly assign seats so overflow teams reliably mount secondary vehicles.
                            private _teamPool = +_teamUnits;
                            private _teamAssignedDriver = objNull;
                            private _teamAssignedCommander = objNull;
                            private _teamAssignedGunner = objNull;

                            if ((_teamVeh emptyPositions "driver") > 0 && {_teamPool isNotEqualTo []} && {isNull driver _teamVeh}) then {
                                _teamAssignedDriver = _teamPool deleteAt 0;
                                _teamAssignedDriver enableAI "PATH";
                                _teamAssignedDriver setBehaviour "AWARE";
                                [_teamAssignedDriver] allowGetIn true;
                                _teamAssignedDriver assignAsDriver _teamVeh;
                                [_teamAssignedDriver] orderGetIn true;
                                _teamAssignedDriver doMove (getPosATL _teamVeh);
                            };

                            if ((_teamVeh emptyPositions "commander") > 0 && {_teamPool isNotEqualTo []} && {isNull commander _teamVeh}) then {
                                _teamAssignedCommander = _teamPool deleteAt 0;
                                [_teamAssignedCommander] allowGetIn true;
                                _teamAssignedCommander assignAsCommander _teamVeh;
                                [_teamAssignedCommander] orderGetIn true;
                            };

                            if ((_teamVeh emptyPositions "gunner") > 0 && {_teamPool isNotEqualTo []} && {isNull gunner _teamVeh}) then {
                                _teamAssignedGunner = _teamPool deleteAt 0;
                                [_teamAssignedGunner] allowGetIn true;
                                _teamAssignedGunner assignAsGunner _teamVeh;
                                [_teamAssignedGunner] orderGetIn true;
                            };

                            {
                                [_x] allowGetIn true;
                                _x assignAsCargo _teamVeh;
                                [_x] orderGetIn true;
                            } forEach _teamPool;

                            _teamGrp setBehaviour "AWARE";
                            _teamGrp setSpeedMode "FULL";
                            
                            private _moveVehWp = _teamGrp addWaypoint [getPosATL _teamVeh, 0];
                            _moveVehWp setWaypointType "GETIN NEAREST";
                            _moveVehWp setWaypointBehaviour "AWARE";
                            _moveVehWp setWaypointSpeed "FULL";

                            private _mountTimeout = time + 35;
                            private _lastOverflowLog = time;
                            waitUntil {
                                sleep 0.5;
                                if (_debug && {time >= _lastOverflowLog}) then {
                                    _lastOverflowLog = time + 5;
                                    format [
                                        "[INTERCEPT HVT][OVERFLOW] WaitTick. team=%1 veh=%2 assignedDriver=%3 currentDriver=%4 mounted=%5 tLeft=%6",
                                        _teamGrp,
                                        typeOf _teamVeh,
                                        _teamAssignedDriver,
                                        driver _teamVeh,
                                        (!isNull _teamAssignedDriver && {driver _teamVeh == _teamAssignedDriver}),
                                        round (_mountTimeout - time)
                                    ] call OKS_fnc_LogDebug;
                                };
                                (time >= _mountTimeout) ||
                                (!isNull _teamAssignedDriver && {driver _teamVeh == _teamAssignedDriver})
                            };

                            if (!isNull _teamAssignedDriver && {alive _teamAssignedDriver} && {driver _teamVeh != _teamAssignedDriver}) then {
                                private _existingDriver = driver _teamVeh;
                                if (!isNull _existingDriver && {_existingDriver != _teamAssignedDriver}) then {
                                    [_existingDriver] allowGetIn false;
                                    _existingDriver leaveVehicle _teamVeh;
                                    moveOut _existingDriver;
                                    unassignVehicle _existingDriver;
                                };
                                unassignVehicle _teamAssignedDriver;
                                _teamAssignedDriver moveInDriver _teamVeh;
                            };

                            if (!isNull _teamAssignedCommander && {alive _teamAssignedCommander} && {commander _teamVeh != _teamAssignedCommander}) then {
                                unassignVehicle _teamAssignedCommander;
                                _teamAssignedCommander moveInCommander _teamVeh;
                            };

                            if (!isNull _teamAssignedGunner && {alive _teamAssignedGunner} && {gunner _teamVeh != _teamAssignedGunner}) then {
                                unassignVehicle _teamAssignedGunner;
                                _teamAssignedGunner moveInGunner _teamVeh;
                            };

                            {
                                if (alive _x && {vehicle _x != _teamVeh}) then {
                                    unassignVehicle _x;
                                    _x moveInCargo _teamVeh;
                                };
                            } forEach _teamPool;
                            
                            // Then move to main destination.
                            private _moveWp = _teamGrp addWaypoint [_target, 0];
                            _moveWp setWaypointType "MOVE";
                            _moveWp setWaypointBehaviour "AWARE";
                            _moveWp setWaypointSpeed "FULL";
                            
                            if (_debug) then {
                                format [
                                    "[INTERCEPT HVT][OVERFLOW] Team ready. team=%1 veh=%2 units=%3 driver=%4 waypoints=%5",
                                    _teamGrp,
                                    typeOf _teamVeh,
                                    count _teamUnits,
                                    driver _teamVeh,
                                    count (waypoints _teamGrp)
                                ] call OKS_fnc_LogDebug;
                            };
                        };
                    };
                    
                    sleep 0.5;
                };
            };
        };
    } else {
        _guardGroup move _moveTarget;
        // Overflow remains a separate element and receives independent movement.
        if (!isNull _overflowGroup) then {
            _overflowGroup move _moveTarget;
        };
        _hvtUnit doMove _moveTarget;
        _hvtUnit setBehaviour "CARELESS";
    };

    waitUntil {
        sleep 1;
        if (!alive _hvtUnit) exitWith {true};
        private _referenceObj = if (!isNull _vehicle && {vehicle _hvtUnit == _vehicle}) then {_vehicle} else {_hvtUnit};
        (_referenceObj distance2D _spawnPosition) >= 50
    };

    if (!alive _hvtUnit) exitWith {};

    private _isCaptureOrKill = !_killFailsTask;

    private _vehicleTaskType = "danger";
    if (!isNull _vehicle) then {
        if (_vehicle isKindOf "Car") then {
            _vehicleTaskType = "car";
        };
        if (_vehicle isKindOf "Truck") then {
            _vehicleTaskType = "truck";
        };
        if (_vehicle isKindOf "Tank" || {_vehicle isKindOf "Wheeled_APC_F"} || {_vehicle isKindOf "Tracked_APC_F"}) then {
            _vehicleTaskType = "danger";
        };
    };

    private _vehicleText = "";
    if (_showVehicleType && {!isNull _vehicle}) then {
        private _vehicleCfg = configFile >> "CfgVehicles" >> typeOf _vehicle;
        private _vehicleName = getText (_vehicleCfg >> "displayName");
        private _vehiclePicture = getText (_vehicleCfg >> "editorPreview");
        private _texturePath = (getObjectTextures _vehicle) param [0, ""];
        private _textureDisplayName = "N/A";

        if !(_texturePath isEqualTo "") then {
            private _texturePathLower = toLowerANSI _texturePath;
            private _textureSourcesCfg = _vehicleCfg >> "TextureSources";

            for "_i" from 0 to ((count _textureSourcesCfg) - 1) do {
                private _srcCfg = _textureSourcesCfg select _i;
                if (isClass _srcCfg) then {
                    private _srcTextures = getArray (_srcCfg >> "textures");
                    private _matched = false;
                    {
                        private _srcTexLower = toLowerANSI _x;
                        if (
                            (_srcTexLower find _texturePathLower) >= 0 ||
                            (_texturePathLower find _srcTexLower) >= 0
                        ) exitWith {
                            _matched = true;
                        };
                    } forEach _srcTextures;

                    if (_matched) exitWith {
                        _textureDisplayName = getText (_srcCfg >> "displayName");
                        if (_textureDisplayName isEqualTo "") then {
                            _textureDisplayName = configName _srcCfg;
                        };
                    };
                };
            };

            if (_textureDisplayName isEqualTo "N/A") then {
                private _parts = _texturePath splitString "\\/";
                if (_parts isNotEqualTo []) then {
                    _textureDisplayName = _parts select ((count _parts) - 1);
                    if ((toLowerANSI _textureDisplayName) find ".paa" >= 0) then {
                        _textureDisplayName = _textureDisplayName select [0, (count _textureDisplayName) - 4 max 0];
                    };
                };
            };
        };

        if (_vehiclePicture isEqualTo "") then {
            _vehiclePicture = getText (_vehicleCfg >> "picture");
        };

        // Structured text requires ampersands to be escaped.
        _vehicleName = _vehicleName splitString "&" joinString "&amp;";
        _textureDisplayName = _textureDisplayName splitString "&" joinString "&amp;";

        _vehicleText = format [
            "<br/><t color='#C8D6E5'>Transport:</t> <t color='#FFFFFF'>%1</t><br/><t color='#C8D6E5'>Texture:</t> <t color='#FFFFFF'>%2</t>",
            _vehicleName,
            _textureDisplayName
        ];
        if !(_vehiclePicture isEqualTo "") then {
            _vehicleText = _vehicleText + format ["<br/><img image='%1' width='128' height='64' />", _vehiclePicture];
        };
    };

    // Build HVT profile after delay/movement so caller-side identity/appearance overrides are reflected.
    private _itemDisplayNameFn = {
        params ["_className", "_noneText"];
        if (_className isEqualTo "") exitWith {_noneText};

        private _cfg = configNull;
        private _hasCfg = false;
        if (isClass (configFile >> "CfgWeapons" >> _className)) then {
            _cfg = configFile >> "CfgWeapons" >> _className;
            _hasCfg = true;
        } else {
            if (isClass (configFile >> "CfgGlasses" >> _className)) then {
                _cfg = configFile >> "CfgGlasses" >> _className;
                _hasCfg = true;
            } else {
                if (isClass (configFile >> "CfgVehicles" >> _className)) then {
                    _cfg = configFile >> "CfgVehicles" >> _className;
                    _hasCfg = true;
                };
            };
        };

        if (!_hasCfg) exitWith {_className};
        private _dn = getText (_cfg >> "displayName");
        if (_dn isEqualTo "") then {_className} else {_dn}
    };

    private _hvtName = name _hvtUnit;
    private _hvtFaceClass = face _hvtUnit;
    private _hvtRace = [_hvtUnit, sideUnknown] call OKS_fnc_GetEthnicity;
    if (isNil "_hvtRace" || {_hvtRace isEqualTo ""}) then {
        _hvtRace = "Unknown";
    };

    // Only use explicitly defined portrait image path provided in taskData.
    private _hvtProfileImage = _hvtProfileImagePath;

    private _hvtHeadgearName = [headgear _hvtUnit, "None"] call _itemDisplayNameFn;
    private _hvtGogglesName = [goggles _hvtUnit, "None"] call _itemDisplayNameFn;
    private _hvtUniformName = [uniform _hvtUnit, "None"] call _itemDisplayNameFn;
    private _hvtVestName = [vest _hvtUnit, "None"] call _itemDisplayNameFn;
    private _hvtBackpackName = [backpack _hvtUnit, "None"] call _itemDisplayNameFn;

    // Structured text safety.
    _hvtName = _hvtName splitString "&" joinString "&amp;";
    _hvtRace = _hvtRace splitString "&" joinString "&amp;";
    _hvtHeadgearName = _hvtHeadgearName splitString "&" joinString "&amp;";
    _hvtGogglesName = _hvtGogglesName splitString "&" joinString "&amp;";
    _hvtUniformName = _hvtUniformName splitString "&" joinString "&amp;";
    _hvtVestName = _hvtVestName splitString "&" joinString "&amp;";
    _hvtBackpackName = _hvtBackpackName splitString "&" joinString "&amp;";

    private _identityText = format [
        "<br/><t color='#C8D6E5'>Officer:</t> <t color='#FFFFFF'>%1</t><br/>" +
        "<t color='#C8D6E5'>Race:</t> <t color='#FFFFFF'>%2</t><br/>" +
        "<t color='#C8D6E5'>Headgear:</t> <t color='#FFFFFF'>%3</t><br/>" +
        "<t color='#C8D6E5'>Goggles:</t> <t color='#FFFFFF'>%4</t><br/>" +
        "<t color='#C8D6E5'>Uniform:</t> <t color='#FFFFFF'>%5</t><br/>" +
        "<t color='#C8D6E5'>Vest:</t> <t color='#FFFFFF'>%6</t><br/>" +
        "<t color='#C8D6E5'>Backpack:</t> <t color='#FFFFFF'>%7</t>",
        _hvtName,
        _hvtRace,
        _hvtHeadgearName,
        _hvtGogglesName,
        _hvtUniformName,
        _hvtVestName,
        _hvtBackpackName
    ];

    if !(_hvtProfileImage isEqualTo "") then {
        _identityText = _identityText + format ["<br/><img image='%1' width='96' height='96' />", _hvtProfileImage];
    };

    private _mainTaskTitle = "Intercept HVT";
    private _mainTaskDescription = format [
        "<t size='1.15' color='#F4D35E'>High Value Target Intercept</t><br/>" +
        "<t color='#FFFFFF'>Track and contain the HVT movement corridor before escape.</t>%1%2",
        _vehicleText,
        _identityText
    ];
    private _locateTaskTitle = "Locate HVT";
    private _locateTaskDescription = format [
        "<t size='1.15' color='#F4D35E'>Locate High Value Target</t><br/>" +
        "<t color='#FFFFFF'>The HVT has dismounted and garrisoned in a nearby building. Proceed with caution, they may have reached a friendly position.</t>%1%2",
        _vehicleText,
        _identityText
    ];
    private _secureTaskTitle = "Secure HVT";
    private _secureTaskDescription = format [
        "<t size='1.15' color='#F4D35E'>Secure High Value Target</t><br/>" +
        "<t color='#FFFFFF'>The HVT has surrendered. Maintain custody and prepare for transfer to extraction.</t>%1%2",
        _vehicleText,
        _identityText
    ];

    private _captureTaskTitle = if (_isCaptureOrKill && {!_hasExtraction}) then {"Capture or Kill HVT"} else {"Capture HVT"};
    private _captureTaskDescription = if (_isCaptureOrKill && {!_hasExtraction}) then {
        "<t size='1.10' color='#F7B267'>Capture Phase</t><br/><t color='#FFFFFF'>Intercept the HVT. Lethal resolution is authorized.</t>"
    } else {
        "<t size='1.10' color='#F7B267'>Capture Phase</t><br/><t color='#FFFFFF'>Force HVT surrender and secure him alive.</t>"
    };

    private _extractTaskTitle = "Extract HVT";
    private _extractTaskDescription = format [
        "<t size='1.10' color='#6EC1E4'>Extraction Phase</t><br/><t color='#FFFFFF'>Escort the surrendered HVT to extraction at grid %1 (within 50m).</t>",
        mapGridPosition _extractionPos
    ];

    private _mainTaskId = format ["InterceptHVT_Main_%1", floor (random 1000000)];
    private _captureTaskId = format ["InterceptHVT_Capture_%1", floor (random 1000000)];
    private _extractTaskId = format ["InterceptHVT_Extract_%1", floor (random 1000000)];

    private _mainTaskArray = [_mainTaskId];
    if !(_taskParent isEqualTo "") then {
        _mainTaskArray pushBack _taskParent;
    };

    private _captureTaskArray = [_captureTaskId, _mainTaskId];
    private _mainTaskPos = getPosATL _hvtUnit;

    [
        true,
        _mainTaskArray,
        [_mainTaskDescription, _mainTaskTitle, "Intercept"],
        _mainTaskPos,
        "ASSIGNED",
        -1,
        true,
        _vehicleTaskType,
        false
    ] call BIS_fnc_taskCreate;

    [
        true,
        _captureTaskArray,
        [_captureTaskDescription, _captureTaskTitle, "Capture"],
        objNull,
        "CREATED",
        -1,
        false,
        "run",
        false
    ] call BIS_fnc_taskCreate;

    [_mainTaskId, _hvtUnit] spawn OKS_fnc_InterceptHvt_UpdateTrackedTaskPos;

    private _thresholdCount = ceil (_initialGuardCount * (_surrenderThresholdPct / 100));
    private _garrisonTriggered = false;
    private _locatePhaseStarted = false;
    private _extractionPhaseStarted = false;
    private _nextExtractionCheck = time;
    private _finished = false;

    while {!_finished} do {
        sleep 1;

        if (!alive _hvtUnit) then {
            if (_isCaptureOrKill && {!_hasExtraction}) then {
                [_captureTaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
                [_mainTaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
            } else {
                [_captureTaskId, "FAILED", true] call BIS_fnc_taskSetState;
                [_mainTaskId, "FAILED", true] call BIS_fnc_taskSetState;
                if (_extractionPhaseStarted) then {
                    [_extractTaskId, "FAILED", true] call BIS_fnc_taskSetState;
                };
            };
            _finished = true;
        } else {
            private _aliveGuards = {(alive _x)} count (units _guardGroup);
            if (_aliveGuards <= _thresholdCount) then {
                [_hvtUnit] call OKS_fnc_InterceptHvt_SetHvtSurrendered;
            };

            if (_hvtUnit getVariable ["OKS_InterceptHvt_Surrendered", false]) then {
                if (_hasExtraction) then {
                    if (time >= _nextExtractionCheck) then {
                        _nextExtractionCheck = time + 30;

                        if (!_extractionPhaseStarted) then {
                            _extractionPhaseStarted = true;
                            [_captureTaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
                            [_mainTaskId, [_secureTaskDescription, _secureTaskTitle, "Secure"]] call BIS_fnc_taskSetDescription;

                            [
                                true,
                                [_extractTaskId, _mainTaskId],
                                [_extractTaskDescription, _extractTaskTitle, "Extract"],
                                _extractionPos,
                                "CREATED",
                                -1,
                                false,
                                "land",
                                false
                            ] call BIS_fnc_taskCreate;

                            [_mainTaskId, _extractionPos] call BIS_fnc_taskSetDestination;
                            [_extractTaskId, true] call BIS_fnc_taskSetCurrent;
                        };

                        private _onFootAtExtract = (vehicle _hvtUnit == _hvtUnit) && {(_hvtUnit distance2D _extractionPos) <= 50};
                        if (_onFootAtExtract) then {
                            [_extractTaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
                            [_mainTaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
                            _finished = true;
                        };
                    };
                } else {
                    [_captureTaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
                    [_mainTaskId, "SUCCEEDED", true] call BIS_fnc_taskSetState;
                    _finished = true;
                };
            };

            if (!_finished) then {
                private _movingAsset = if (vehicle _hvtUnit == _hvtUnit) then {_hvtUnit} else {vehicle _hvtUnit};
                private _atDestination = _movingAsset distance2D _endPosition < 25;
                if (_atDestination) then {
                    private _behaviorUpper = toUpperANSI _endBehavior;
                    private _assetSpeed = vectorMagnitude velocity _movingAsset;

                    if (!_locatePhaseStarted && {_assetSpeed <= 0.14}) then {
                        _locatePhaseStarted = true;
                        [_mainTaskId, [_locateTaskDescription, _locateTaskTitle, "Locate"]] call BIS_fnc_taskSetDescription;
                        [_mainTaskId, "search"] call BIS_fnc_taskSetType;
                    };

                    if (_behaviorUpper == "DISAPPEAR") then {
                        [_captureTaskId, "FAILED", true] call BIS_fnc_taskSetState;
                        [_mainTaskId, "FAILED", true] call BIS_fnc_taskSetState;
                        if (_extractionPhaseStarted) then {
                            [_extractTaskId, "FAILED", true] call BIS_fnc_taskSetState;
                        };
                        if (!isNull (vehicle _hvtUnit) && {vehicle _hvtUnit != _hvtUnit}) then {
                            deleteVehicle (vehicle _hvtUnit);
                        };
                        deleteVehicle _hvtUnit;
                        _finished = true;
                    } else {
                        if (isNil "_garrisonTriggered") then {
                            _garrisonTriggered = false;
                        };
                        if (!_garrisonTriggered) then {
                            if (_assetSpeed <= 0.14) then {
                                _garrisonTriggered = [_guardGroup, _hvtUnit, _endPosition, _overflowGroup] call OKS_fnc_InterceptHvt_GarrisonEnd;
                            };
                        };
                    };
                };
            };
        };
    };

    if (alive _hvtUnit) then {
        _hvtUnit setVariable ["OKS_InterceptHvt_TaskDone", true, true];
    };

    if (_hvtDebug) then {
        format ["[INTERCEPT HVT] Task loop ended for HVT %1", _hvtUnit] call OKS_fnc_LogDebug;
    };
};

_hvtUnit;