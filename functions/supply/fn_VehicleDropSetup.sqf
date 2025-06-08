 /*
    Setup Vehicle & MHQ Drops
*/
if(!isNil "Vehicle_1") then {
    GOL_NEKY_VEHICLEDROP_VEHICLECLASS = (typeOf Vehicle_1); // Classname
    GOL_NEKY_VEHICLEDROP_APPEARANCE = compile ([Vehicle_1,""] call BIS_fnc_exportVehicle);
    GOL_NEKY_VEHICLEDROP_CODE = {

        Params ["_Vehicle"];
        _Vehicle call GOL_NEKY_VEHICLEDROP_APPEARANCE;

        sleep 5;
        [_Vehicle] spawn OKS_fnc_Mechanized;	
    };
};

if(!isNil "MHQ_1") then {
    GOL_NEKY_MHQDROP_VEHICLECLASS = (typeOf MHQ_1); // Classname
    GOL_NEKY_MHQDROP_APPEARANCE = compile ([MHQ_1,""] call BIS_fnc_exportVehicle);
    GOL_NEKY_MHQDROP_CODE = {

        Params ["_Vehicle"];
        _Vehicle call GOL_NEKY_MHQDROP_APPEARANCE;
        [_Vehicle, "medium"] call GW_MHQ_Fnc_Handler;

        _MHQShouldBeMobileServiceStation = missionNamespace getVariable ["MHQ_ShouldBe_ServiceStation",false];
        if(_MHQShouldBeMobileServiceStation isEqualTo true) then {
            _Debug = missionNamespace getVariable ["MHQ_Debug",false];
            if(_Debug) then {
                format["SetupMSS-Drop was run on %1",_Vehicle] spawn OKS_fnc_LogDebug;
            };
            [_Vehicle] spawn OKS_fnc_SetupMobileServiceStation;
        } else {
            _Debug = missionNamespace getVariable ["MHQ_Debug",false];
            if(_Debug) then {
                format["SetupMSS-Drop was not run on %1. MHQ_ShouldBe_ServiceStation: False",_Vehicle] spawn OKS_fnc_LogDebug;
            };
        };

        sleep 5;	
        [_Vehicle] spawn OKS_fnc_Mechanized;	
    };
};

GOL_NEKY_SUPPLY_HELICOPTER = missionNamespace getVariable ["NEKY_SupplyHelicopter",""];
publicVariable "GOL_NEKY_SUPPLY_HELICOPTER";
