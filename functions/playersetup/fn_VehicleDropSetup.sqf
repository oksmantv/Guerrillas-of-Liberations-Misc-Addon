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
        [_Vehicle,25,true] spawn OKS_fnc_MobileSS;

        sleep 5;	
        [_Vehicle] spawn OKS_fnc_Mechanized;	
    };
};