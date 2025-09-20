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
    // Get convoy array from convoy leader, but use first available vehicle if leader is destroyed
    private _currentConvoyVehicleArray = _convoyLeadVehicle getVariable ["OKS_Convoy_VehicleArray", []];
    if (_currentConvoyVehicleArray isEqualTo [] && (count _reserveVehicleQueue > 0)) then {
        // Fallback: get array from any available vehicle in reserve queue
        {
            private _fallbackArray = _x getVariable ["OKS_Convoy_VehicleArray", []];
            if (_fallbackArray isNotEqualTo []) exitWith {
                _currentConvoyVehicleArray = _fallbackArray;
            };
        } forEach _reserveVehicleQueue;
    };
    
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

            // Update convoy array on all vehicles for resilience
            {
                if (!isNull _x && alive _x) then {
                    _x setVariable ["OKS_Convoy_VehicleArray", _currentConvoyVehicleArray, true];
                };
            } forEach _currentConvoyVehicleArray;
            
            _activatedReserveVehicle setVariable ["OKS_Convoy_FrontLeader", _convoyLeadVehicle, true];
            _activatedReserveVehicle setVariable ["OKS_Convoy_Catchup", true, true];

            if (missionNamespace getVariable ["GOL_Convoy_Debug", false]) then {
                format ["[CONVOY-RESERVE-ACTIVATED] Reserve vehicle %1 activated for dead/immobile slot %2", _activatedReserveVehicle, _currentDestroyedIndex] spawn OKS_fnc_LogDebug;
            };
        };
    } forEach _destroyedVehicleIndexes;
}
