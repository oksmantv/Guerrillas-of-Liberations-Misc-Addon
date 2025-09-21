params ["_ConvoyCrewGroups", "_ConvoyVehicleArray", "_ConvoySide", "_IgnoredAirTargets"];

private _DetectedEnemyAirVehicles = [];

// Get dynamic detection ranges from missionNamespace (set by CBA settings)
private _heliRange = missionNamespace getVariable ["OKS_Convoy_HelicopterDetectionRange", 1500];
private _planeRange = missionNamespace getVariable ["OKS_Convoy_PlaneDetectionRange", 2500];

// 1. Scan known targets for helicopters and planes separately
{
    private _Group = _x;
    private _GroupLeader = leader _x;
    if (!isNull _GroupLeader) then {
        private _KnownTargets = _GroupLeader targets [true, (_heliRange max _planeRange), [sideEnemy]];
        {
            if (alive _x) then {
                private _TargetVehicle = vehicle _x;
                if (!isNull _TargetVehicle && (canMove _TargetVehicle) && !(_TargetVehicle isKindOf "ParachuteBase")) then {
                    if (_TargetVehicle isKindOf "HELICOPTER" && {_Group knowsAbout _TargetVehicle > 2.0} && {_GroupLeader distance _TargetVehicle <= _heliRange}) then {
                        _DetectedEnemyAirVehicles pushBackUnique _TargetVehicle;
                    };
                    if (_TargetVehicle isKindOf "PLANE" && {_Group knowsAbout _TargetVehicle > 2.0} && {_GroupLeader distance _TargetVehicle <= _planeRange}) then {
                        _DetectedEnemyAirVehicles pushBackUnique _TargetVehicle;
                    };
                };
            };
        } forEach _KnownTargets;
    };
} forEach _ConvoyCrewGroups;

// 2. Scan nearby air vehicles for each convoy vehicle, split by type
{
    private _veh = _x;
    // Helicopters
    private _NearbyHelis = _veh nearEntities ["Helicopter", _heliRange];
    {
        if (alive _x && canMove _x && !(_x isKindOf "ParachuteBase")) then {
            private _Pilot = driver _x;
            if (isNull _Pilot && {count crew _x > 0}) then { _Pilot = (crew _x) select 0; };
            if (!isNull _Pilot) then {
                private _side = side _Pilot;
                if ([_ConvoySide, _side] call OKS_fnc_Convoy_IsEnemySide) then {
                    if (_veh knowsAbout _x > 2.0) then {
                        _DetectedEnemyAirVehicles pushBackUnique _x;
                    };
                };
            };
        };
    } forEach _NearbyHelis;
    // Planes
    private _NearbyPlanes = _veh nearEntities ["Plane", _planeRange];
    {
        if (alive _x && canMove _x && !(_x isKindOf "ParachuteBase")) then {
            private _Pilot = driver _x;
            if (isNull _Pilot && {count crew _x > 0}) then { _Pilot = (crew _x) select 0; };
            if (!isNull _Pilot) then {
                private _side = side _Pilot;
                if ([_ConvoySide, _side] call OKS_fnc_Convoy_IsEnemySide) then {
                    if (_veh knowsAbout _x > 2.0) then {
                        _DetectedEnemyAirVehicles pushBackUnique _x;
                    };
                };
            };
        };
    } forEach _NearbyPlanes;
} forEach _ConvoyVehicleArray;

_DetectedEnemyAirVehicles = _DetectedEnemyAirVehicles - _IgnoredAirTargets;
_DetectedEnemyAirVehicles;