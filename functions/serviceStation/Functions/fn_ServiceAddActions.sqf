//	
//	
//	This handles adding addactions to vehicles entering the Service Station
//	
//	Made by NeKo-ArroW

Params ["_Veh"];

_Veh addaction ["<t color='#F7FE2E'>Repair</t>", 
{
	Params ["_Veh"];
	_SS = (_Veh getVariable "NEKY_ServiceStation_InStation") select 1;
	_Params = [_Veh,_SS,False];
	if (_SS in NEKY_ServiceStationActive) then 
	{
		[] call OKS_Fnc_Busy;
	} else {
		_Params spawn OKS_Fnc_Repair;
		[_SS] Spawn OKS_Fnc_Lights;
	};
}, [], 10, false, true, "", "((_Target getVariable ['NEKY_ServiceStation_InStation',[false]]) select 0) && ((isNull (objectParent player)) || ((gunner _target) == player || (driver _target) == player || (commander _target) == player))"];

_Veh addaction ["<t color='#F7FE2E'>Refuel</t>", 
{
	Params ["_Veh"];
	_SS = (_Veh getVariable "NEKY_ServiceStation_InStation") select 1;
	_Params = [_Veh,_SS,False];
	if (_SS in NEKY_ServiceStationActive) then 
	{
		call OKS_Fnc_Busy;
	} else {
		_Params spawn OKS_Fnc_Refuel; 
		[_SS] Spawn OKS_Fnc_Lights;
	};
}, [], 10, false, true, "", "((_Target getVariable ['NEKY_ServiceStation_InStation',[false]]) select 0) && ((isNull (objectParent player)) || ((gunner _target) == player || (driver _target) == player || (commander _target) == player))"];
	
_Veh addaction ["<t color='#F7FE2E'>Rearm</t>",
{
	Params ["_Veh"];
	_SS = (_Veh getVariable "NEKY_ServiceStation_InStation") select 1;
	_Params = [_Veh,_SS,false];
	if (_SS in NEKY_ServiceStationActive) then 
	{
		call OKS_Fnc_Busy;
	} else {
		_Params spawn OKS_Fnc_Rearm;
		[_SS] Spawn OKS_Fnc_Lights;
	};
}, [], 10, false, true, "", "((_Target getVariable ['NEKY_ServiceStation_InStation',[false]]) select 0) && ((isNull (objectParent player)) || ((gunner _target) == player || (driver _target) == player || (commander _target) == player))"];