//	
//	
//	
//	
//	

Params ["_Veh","_SS"];

NEKY_ServiceStationActive PushBack _SS;
PublicVariable "NEKY_ServiceStationActive";

["Full service selected", _Veh] spawn OKS_fnc_Hints;
sleep 2;
[_Veh,_SS,true] call OKS_fnc_Repair;