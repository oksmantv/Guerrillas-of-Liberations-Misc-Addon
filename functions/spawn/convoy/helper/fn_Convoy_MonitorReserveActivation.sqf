/*
  OKS_fnc_Convoy_MonitorReserveActivation
  Monitors convoy for destroyed/immobile vehicles and activates reserves automatically.
  Params:
    0: OBJECT - lead vehicle
    1: ARRAY  - reserve queue
*/

params ["_leadVeh", "_reserveQueue"];

while {true} do {
    sleep 2;
    private _arr = _leadVeh getVariable ["OKS_Convoy_VehicleArray", []];
    private _deadIdxs = [];
    {
        if (isNull _x || {!alive _x} || {!canMove _x}) then {
            _deadIdxs pushBack _forEachIndex;
        };
    } forEach _arr;
    if (_deadIdxs isEqualTo []) then { continue; };
    {
        private _idx = _x;
        if (count _reserveQueue > 0) then {
            private _reserveVeh = _reserveQueue deleteAt 0;
            private _leadGrp = group driver _leadVeh;
            private _resGrp = group driver _reserveVeh;
            [ _leadGrp, _resGrp, getPosATL _reserveVeh ] call OKS_fnc_Convoy_CopyRouteForReserve;
            while { (count waypoints _resGrp) > 0 } do { deleteWaypoint ((waypoints _resGrp) select 0); };
            _arr pushBack _reserveVeh;
            _leadVeh setVariable ["OKS_Convoy_VehicleArray", _arr, true];
            _reserveVeh setVariable ["OKS_Convoy_LeadVehicle", _leadVeh, true];
            _reserveVeh setVariable ["OKS_Convoy_Catchup", true, true];
        };
    } forEach _deadIdxs;
}
