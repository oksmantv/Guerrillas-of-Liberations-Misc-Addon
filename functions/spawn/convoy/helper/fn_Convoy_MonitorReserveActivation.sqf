/*
  OKS_fnc_Convoy_MonitorReserveActivation
  Monitors convoy for destroyed/immobile vehicles and activates reserves automatically.
  Params:
    0: OBJECT - lead vehicle
    1: ARRAY  - reserve queue
*/

params ["_convoyLeadVehicle", "_reserveVehicleQueue"];

while {true} do {
    sleep 2;
    private _currentConvoyVehicleArray = _convoyLeadVehicle getVariable ["OKS_Convoy_VehicleArray", []];
    private _destroyedVehicleIndexes = [];
    {
        if (isNull _x || {!alive _x} || {!canMove _x}) then {
            _destroyedVehicleIndexes pushBack _forEachIndex;
        };
    } forEach _currentConvoyVehicleArray;

    if (_destroyedVehicleIndexes isEqualTo []) then { 
        continue;
    };

    {
        private _currentDestroyedIndex = _x;
        if (count _reserveVehicleQueue > 0) then {
            private _activatedReserveVehicle = _reserveVehicleQueue deleteAt 0;
            private _convoyLeadGroup = group driver _convoyLeadVehicle;
            private _reserveVehicleGroup = group driver _activatedReserveVehicle;

            [ _convoyLeadGroup, _reserveVehicleGroup, getPosATL _activatedReserveVehicle ] call OKS_fnc_Convoy_CopyRouteForReserve;
            while { (count waypoints _reserveVehicleGroup) > 0} do 
            {
                deleteWaypoint ((waypoints _reserveVehicleGroup) select 0); 
            };

            _currentConvoyVehicleArray pushBack _activatedReserveVehicle;

            _convoyLeadVehicle setVariable ["OKS_Convoy_VehicleArray", _currentConvoyVehicleArray, true];
            _activatedReserveVehicle setVariable ["OKS_Convoy_LeadVehicle", _convoyLeadVehicle, true];
            _activatedReserveVehicle setVariable ["OKS_Convoy_Catchup", true, true];

            if (missionNamespace getVariable ["GOL_Convoy_Debug", false]) then {
                format ["[CONVOY-RESERVE-ACTIVATED] Reserve vehicle %1 activated for dead/immobile slot %2", _activatedReserveVehicle, _currentDestroyedIndex] spawn OKS_fnc_LogDebug;
            };
        };
    } forEach _destroyedVehicleIndexes;
}
