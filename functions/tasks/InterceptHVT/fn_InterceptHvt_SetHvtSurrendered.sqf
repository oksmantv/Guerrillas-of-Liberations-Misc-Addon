/*
    [hvtUnit] call OKS_fnc_InterceptHvt_SetHvtSurrendered;
*/
params [["_hvtUnit", objNull, [objNull]]];
if (isNull _hvtUnit || {!alive _hvtUnit}) exitWith {false};
if (_hvtUnit getVariable ["OKS_InterceptHvt_Surrendered", false]) exitWith {true};

private _hvtDebug = missionNamespace getVariable ["GOL_HVT_Debug", false];
private _isCaptureOrKill = _hvtUnit getVariable ["OKS_InterceptHvt_CaptureOrKill", false];

if (_isCaptureOrKill && {random 1 < 0.10}) exitWith {
    _hvtUnit setVariable ["OKS_InterceptHvt_RefusedSurrender", true, true];
    if (_hvtDebug) then {
        format ["[INTERCEPT HVT] HVT refused surrender and will keep fighting. HVT=%1", _hvtUnit] call OKS_fnc_LogDebug;
    };
    false
};

_hvtUnit setVariable ["OKS_InterceptHvt_Surrendered", true, true];
_hvtUnit setCaptive true;

// Stop the HVT from fighting immediately — before any async spawn runs.
_hvtUnit setBehaviour "CARELESS";
_hvtUnit setCombatMode "BLUE";
_hvtUnit disableAI "AUTOTARGET";
_hvtUnit disableAI "TARGET";

// Disarm now so weapons are gone before the vehicle-stop sequence completes.
_hvtUnit setVariable ["GOL_ThrownWeaponOnGround", true, true];
[_hvtUnit, objNull, false] spawn OKS_fnc_ThrowWeaponsOnGround;

// Immediately redirect all overflow groups AND main guard group to SAD at the HVT's current position.
// Runs unconditionally so it works whether the HVT is mounted or on foot.
private _sadRallyPos = getPosATL (if (vehicle _hvtUnit != _hvtUnit) then {vehicle _hvtUnit} else {_hvtUnit});

// Update main guard group to SAD.
private _mainGrp = _hvtUnit getVariable ["OKS_InterceptHvt_MainGuardGroup", grpNull];
if (!isNull _mainGrp) then {
    [_mainGrp] call OKS_fnc_ClearWaypoints;
    private _sadWp = _mainGrp addWaypoint [_sadRallyPos, 0];
    _sadWp setWaypointType "SAD";
    _sadWp setWaypointBehaviour "COMBAT";
    _sadWp setWaypointCombatMode "RED";
    _sadWp setWaypointSpeed "FULL";
    _mainGrp setBehaviour "COMBAT";
    _mainGrp setCombatMode "RED";
    _mainGrp setSpeedMode "FULL";
    _mainGrp setCurrentWaypoint _sadWp;
    if (_hvtDebug) then {
        format ["[INTERCEPT HVT] Main guard group redirected to SAD at HVT location. Pos=%1", _sadRallyPos] call OKS_fnc_LogDebug;
    };
};

// Overflow groups should keep moving toward the ambush site in AWARE mode and
// only dismount when contact/combat naturally forces them out.
private _overflowGrps = _hvtUnit getVariable ["OKS_InterceptHvt_OverflowGroups", []];
if (_hvtDebug && {_overflowGrps isNotEqualTo []}) then {
    format ["[INTERCEPT HVT] Redirecting %1 overflow group(s) to ambush site.", count _overflowGrps] call OKS_fnc_LogDebug;
};

private _overflowLeadVeh = _hvtUnit getVariable ["OKS_InterceptHvt_MainVehicle", objNull];
if (isNull _overflowLeadVeh) then {
    _overflowLeadVeh = vehicle _hvtUnit;
};
private _overflowLeadPos = getPosATL _overflowLeadVeh;

{
    _x params ["_grp", "_veh", "_units"];
    if (!isNull _veh && {alive _veh}) then {
        _veh lock 0;
    };

    if (!isNull _grp && {(units _grp) isNotEqualTo []}) then {
        [_grp] call OKS_fnc_ClearWaypoints;
        private _moveWp = _grp addWaypoint [_overflowLeadPos, 0];
        _moveWp setWaypointType "MOVE";
        _moveWp setWaypointBehaviour "AWARE";
        _moveWp setWaypointCombatMode "YELLOW";
        _moveWp setWaypointSpeed "FULL";
        _grp setBehaviour "AWARE";
        _grp setCombatMode "YELLOW";
        _grp setSpeedMode "FULL";
        _grp setCurrentWaypoint _moveWp;
    };
} forEach (_hvtUnit getVariable ["OKS_InterceptHvt_OverflowAssignments", []]);

if (_hvtDebug && {_overflowGrps isNotEqualTo []}) then {
    format ["[INTERCEPT HVT] Overflow groups are moving toward %1 in AWARE mode.", _overflowLeadPos] call OKS_fnc_LogDebug;
};

private _aceFnName = ["ACE", "captives", "fnc", "setSurrendered"] joinString "_";
private _aceSetSurrendered = missionNamespace getVariable [_aceFnName, {}];

if (vehicle _hvtUnit != _hvtUnit) then {
    private _veh = vehicle _hvtUnit;

    if (_hvtDebug) then {
        format ["[INTERCEPT HVT] Surrender triggered while mounted. Waiting for safer dismount speed. Veh=%1 speed=%2", typeOf _veh, round (speed _veh)] call OKS_fnc_LogDebug;
    };

    [_hvtUnit, _veh, _hvtDebug, _aceSetSurrendered] spawn OKS_fnc_InterceptHvt_HandleMountedSurrender;
} else {
    // On foot — weapon drop and combat-mode lockout already applied above.
    _hvtUnit setVariable ["OKS_InterceptHvt_AllowExit", true, true];
    _hvtUnit disableAI "PATH";
    _hvtUnit setUnitPos "MIDDLE";
    if !(_aceSetSurrendered isEqualTo {}) then {
        [_hvtUnit, true] call _aceSetSurrendered;
    };
    _hvtUnit action ["Surrender", _hvtUnit];
    _hvtUnit setVariable ["OKS_InterceptHvt_SurrenderActionDone", true, true];
};

true;