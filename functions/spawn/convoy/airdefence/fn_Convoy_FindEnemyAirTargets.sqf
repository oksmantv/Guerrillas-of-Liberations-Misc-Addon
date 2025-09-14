params ["_ConvoyCrewGroups", "_ConvoyVehicleArray", "_ConvoySide", "_IgnoredAirTargets"];

private _DetectedEnemyAirVehicles = [];
{
    private _GroupLeader = leader _x;
    if (!isNull _GroupLeader) then {
        private _KnownTargets = _GroupLeader targets [true, 500, [sideEnemy]];
        {
            if (alive _x) then {
                private _TargetVehicle = vehicle _x;
                if (!isNull _TargetVehicle && (_TargetVehicle isKindOf "AIR") && !(_TargetVehicle isKindOf "ParachuteBase") && (canMove _TargetVehicle)) then {
                    _DetectedEnemyAirVehicles pushBackUnique _TargetVehicle;
                };
            };
        } forEach _KnownTargets;
    };
} forEach _ConvoyCrewGroups;

{
    private _NearbyAirVehicles = _x nearEntities ["Air", 500];
    {
        if (alive _x && (canMove _x) && !(_x isKindOf "ParachuteBase")) then {
            private _PilotOfAirVehicle = driver _x;
            if (isNull _PilotOfAirVehicle && (count crew _x > 0)) then { _PilotOfAirVehicle = (crew _x) select 0; };
            if (!isNull _PilotOfAirVehicle) then {
                private _AirVehicleSide = side _PilotOfAirVehicle;
                if ([_ConvoySide, _AirVehicleSide] call OKS_fnc_Convoy_IsEnemySide) then {
                    _DetectedEnemyAirVehicles pushBackUnique _x;
                };
            };
        };
    } forEach _NearbyAirVehicles;
} forEach _ConvoyVehicleArray;

_DetectedEnemyAirVehicles = _DetectedEnemyAirVehicles - _IgnoredAirTargets;
_DetectedEnemyAirVehicles;