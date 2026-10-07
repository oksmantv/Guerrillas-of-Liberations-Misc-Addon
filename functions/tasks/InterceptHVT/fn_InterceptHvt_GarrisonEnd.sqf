/*
    [guardGroup, hvtUnit, endPos, overflowGroup, debug] call OKS_fnc_InterceptHvt_GarrisonEnd;
*/
params [
    ["_guardGroup", grpNull, [grpNull]],
    ["_hvtUnit", objNull, [objNull]],
    ["_endPos", [0,0,0], [[]]],
    ["_overflowGroup", grpNull, [grpNull]],
    ["_debug", false, [false]]
];

if (isNull _guardGroup) exitWith {false};

private _targetBuilding = nearestBuilding _endPos;
if (isNull _targetBuilding) exitWith {false};

if (alive _hvtUnit) then {
    _hvtUnit setVariable ["OKS_InterceptHvt_InGarrison", true, true];
    _hvtUnit setVariable ["OKS_InterceptHvt_AllowExit", true, true];
};

private _buildingPositions = [_targetBuilding] call BIS_fnc_buildingPositions;
if (_buildingPositions isEqualTo []) then {
    _buildingPositions = [getPosATL _targetBuilding];
};

private _guards = (units _guardGroup) select {alive _x};
private _mountedCommander = objNull;
private _mountedGunner = objNull;

{
    private _currentVehicle = vehicle _x;
    if (_currentVehicle != _x) then {
        if (_x == commander _currentVehicle) then {
            _mountedCommander = _x;
        } else {
            if (_x == gunner _currentVehicle) then {
                _mountedGunner = _x;
            } else {
                _x setVariable ["OKS_InterceptHvt_ShouldExit", true];
                [_x] allowGetIn false;
                _x leaveVehicle _currentVehicle;
                doGetOut _x;
                unassignVehicle _x;
            };
        };
    } else {
        [_x] allowGetIn false;
    };
} forEach _guards;

if (alive _hvtUnit && {vehicle _hvtUnit != _hvtUnit}) then {
    private _hvtVehicle = vehicle _hvtUnit;
    _hvtUnit setVariable ["OKS_InterceptHvt_ShouldExit", true];
    [_hvtUnit] allowGetIn false;
    _hvtUnit leaveVehicle _hvtVehicle;
    doGetOut _hvtUnit;
    unassignVehicle _hvtUnit;
} else {
    if (alive _hvtUnit) then {
        [_hvtUnit] allowGetIn false;
    };
};

sleep 0.5;

private _dismountGuards = _guards select {
    _x != _mountedCommander && {_x != _mountedGunner}
};

waitUntil {
    sleep 0.5;
    ({vehicle _x == _x} count _dismountGuards) == count _dismountGuards &&
    (!alive _hvtUnit || {vehicle _hvtUnit == _hvtUnit})
};

// Multi-building garrison: radius 30 with even-distribution fill mode (0) so guards
// spread across surrounding buildings rather than stacking in a single one.
{
    _x enableAI "PATH";
    _x enableAI "FSM";
    _x setBehaviour "AWARE";
} forEach _dismountGuards;

_guardGroup setSpeedMode "FULL";

if (_dismountGuards isNotEqualTo []) then {
    [getPosATL _targetBuilding, 150, _dismountGuards, 0.75, _debug] spawn OKS_fnc_GarrisonBuildingsInArea;
};


private _candidateSlots = _buildingPositions select {
    ((nearestObjects [_x, ["CAManBase"], 0.9]) select {
        alive _x && {_x != _hvtUnit}
    }) isEqualTo []
};
private _slotPool = if (_candidateSlots isEqualTo []) then {_buildingPositions} else {_candidateSlots};
private _hvtDest = selectRandom _slotPool;

if (alive _hvtUnit) then {
    private _hvtGroup = group _hvtUnit;
    _hvtUnit enableAI "PATH";
    _hvtUnit setBehaviour "CARELESS";
    _hvtGroup setSpeedMode "FULL";
    [_hvtUnit] orderGetIn false;
    [_hvtGroup] call OKS_fnc_ClearWaypoints;
    _hvtUnit doMove _hvtDest;
    [_hvtUnit, _hvtDest, _buildingPositions] spawn {
        params ["_hvt", "_dest", "_positions"];
        private _hvtDebug = missionNamespace getVariable ["GOL_HVT_Debug", false];

        waitUntil {
            sleep 1;
            !alive _hvt ||
            ((vehicle _hvt == _hvt) && {_hvt distance2D _dest < 4})
        };

        if (alive _hvt) then {
            // Let nearby units fully settle after dismount/garrison before checking for unit stacking.
            sleep 30;

            private _findBestFreeSlot = {
                params ["_slots", "_hvtUnit"];
                private _bestSlot = [];
                private _bestScore = -1;

                {
                    private _slot = _x;
                    private _occupied = ((nearestObjects [_slot, ["CAManBase"], 0.9]) select {
                        alive _x && {_x != _hvtUnit}
                    }) isNotEqualTo [];

                    if (!_occupied) then {
                        private _nearUnits = (nearestObjects [_slot, ["CAManBase"], 8]) select {
                            alive _x && {_x != _hvtUnit}
                        };
                        private _score = if (_nearUnits isEqualTo []) then {999} else {_slot distance2D (_nearUnits select 0)};
                        if (_score > _bestScore) then {
                            _bestScore = _score;
                            _bestSlot = _slot;
                        };
                    };
                } forEach _slots;

                _bestSlot
            };

            // Retry a few times in case guards path into the chosen slot right after relocation.
            for "_attempt" from 1 to 3 do {
                private _stackedNow = ((nearestObjects [_hvt, ["CAManBase"], 0.9]) select {
                    alive _x && {_x != _hvt}
                }) isNotEqualTo [];

                if (!_stackedNow) exitWith {};

                private _bestSlot = [_positions, _hvt] call _findBestFreeSlot;
                if (_bestSlot isEqualTo []) exitWith {
                    if (_hvtDebug) then {
                        format ["[INTERCEPT HVT] HVT stack detected on attempt %1 but no free building slot found.", _attempt] call OKS_fnc_LogDebug;
                    };
                };

                _hvt setPosATL _bestSlot;
                if (_hvtDebug) then {
                    format ["[INTERCEPT HVT] HVT deconflicted to slot %1 on attempt %2", _bestSlot, _attempt] call OKS_fnc_LogDebug;
                };

                sleep 0.4;
            };

            private _grp = group _hvt;
            [_grp] call OKS_fnc_ClearWaypoints;
            _hvt disableAI "PATH";
            _hvt setUnitPos "MIDDLE";
        };
    };
};

true;