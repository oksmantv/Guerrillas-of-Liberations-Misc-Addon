/*
Helper: Place debug marker arrow at a position.
Params:
1. Position (ATL or object)
2. IsReserve (bool) - true for reserve marker (blue), false for main marker (red)
*/
params ["_PosOrObj", "_isReserve"];
private _DebugObjects = missionNamespace getVariable ["GOL_Convoy_Markers_Debug", false];
if (_DebugObjects) then {
    private _arrowType = if (_isReserve) then { "Sign_Arrow_Direction_Blue_F" } else { "Sign_Arrow_Direction_Green_F" };
    private _arrowPos = if (_PosOrObj isEqualType objNull) then { [getPos _PosOrObj select 0, getPos _PosOrObj select 1, 1] } else { _PosOrObj };
    private _arrow = createVehicle [_arrowType, _arrowPos, [], 0, "CAN_COLLIDE"];
    _arrow setPosATL _arrowPos;
};